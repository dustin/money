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

  protected

  def get_flow(type, query)
    title "Reports - Flow for #{current_user.name}"
    @type = type
    @flow=[]
    current_user.groups.sort.each do |g|
      gflow=[]
      ActiveRecord::Base.connection.execute(query g.id).each do |r|
        gflow << r
      end
      @flow << [g, gflow]
    end
    render :action => :flow
  end

  def month_flow_query(gid)
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

  def authorized?
    current_user.admin?
  end

  def access_denied
    render :action => :access_denied
  end
end
