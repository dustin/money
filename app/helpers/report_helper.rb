require 'gchart'

module ReportHelper

  MAX_PIE_SIZE=7 unless defined? MAX_PIE_SIZE

  def pie_chart(data, labels, opts = {})
    if data.size > 1
      if data.size > MAX_PIE_SIZE
        data = data.first(MAX_PIE_SIZE) << (data[MAX_PIE_SIZE..-1].sum)
        labels = labels.first(MAX_PIE_SIZE) << 'Other'
      end
      width = opts.delete(:width) || 400
      height = opts.delete(:height) || 200
      tag :img, :alt => "pie",
        :src => Gchart.pie_3d(opts.merge({:data => data, :legend => labels,
          :width => width, :height => height}))
    end
  end

  def bar_chart(data, labels, opts = {})
    if data.size > 1
      width = opts.delete(:width) || 600
      height = opts.delete(:height) || 200
      tag :img, :alt => "pie",
        :src => Gchart.bar(opts.merge({:data => data, :legend => labels,
          :width => width, :height => height}))
    end
  end


end
