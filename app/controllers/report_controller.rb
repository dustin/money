class ReportController < ApplicationController

  def index
    title 'Reports'
  end

  def balances
    title 'Reports - Balances'
  end

  def month_flow
    get_flow('Month', Proc.new {|gid| month_flow_query gid})
  end

  def year_flow
    get_flow('Year', Proc.new {|gid| year_flow_query gid})
  end

  def month_cat
    year=month=0
    if params[:date]
      parts=params[:date].split /-/
      year=parts[0].to_i
      month=parts[1].to_i
    else
      year = params[:year].to_i
      month = params[:month].to_i
    end
    title "Reports - Category report for #{year}/#{month}"
    @cats=[]
    current_user.groups.sort.each do |g|
      gcat=[]
      totspent=totbudget=totdiff=0.0
      ActiveRecord::Base.connection.execute(month_category_report(year, month, g.id)).each do |r|
        name=r[1]
        spent=r[3].to_f
        budget=r[2].to_f
        diff=budget - spent

        totspent += spent
        totbudget += budget
        totdiff += diff
        gcat << [name, spent, budget, diff]
      end
      @cats << [g, totspent, totbudget, totdiff, gcat]
    end
  end

  protected

  def get_flow(type, query)
    title "Reports - Flow for #{current_user.name}"
    @type = type
    @flow=[]
    current_user.groups.sort.each do |g|
      gflow=[]
      ActiveRecord::Base.connection.execute(query.call(g.id)).each do |r|
        gflow << r
      end
      @flow << [g, gflow]
    end
    render :action => :flow
  end

  def month_flow_query(gid)
    validate_num gid
    query=<<ENDSQL
    select
        date(date_trunc('month', ds)) as theDate,
        sum(amount) as flow
    from
        money_transactions
    where
        deleted_at is null
        and money_account_id in
            (select id from money_accounts where group_id = #{gid})
    group by
        theDate
    order by
        theDate desc
ENDSQL
    query
  end

  def year_flow_query(gid)
    validate_num gid
    query=<<ENDSQL
    select
        date(date_trunc('year', ds)) as theDate,
        sum(amount) as flow
    from
        money_transactions
    where
        deleted_at is null
        and money_account_id in
            (select id from money_accounts where group_id = #{gid})
    group by
        theDate
    order by
        theDate desc
ENDSQL
    query
  end

  def month_category_report(year, month, gid)
    validate_num year
    validate_num month
    validate_num gid
    query=<<ENDSQL
    select
        c.id,
        c.name,
        c.budget,
        sum(t.amount) as total
    from
        categories c join money_transactions t on (c.id = t.category_id)
    where
        date(date_trunc('month', ds)) = date(date_trunc('month', '#{year}-#{month}-01'::date))
        and t.deleted_at is null
        and t.money_account_id in ( select id from money_accounts where group_id = #{gid} )
    group by
        c.id,
        c.budget,
        c.name
    order by
        total
ENDSQL
    query
  end

  def validate_num(n)
    raise "#{n} is not a number" if n.class != Fixnum
  end

  def authorized?
    current_user.admin?
  end

  def access_denied
    render :action => :access_denied
  end
end
