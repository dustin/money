require 'gchart'

module ReportHelper

  def pie_chart(data, labels, opts = {})
    if data.size > 1
      if data.size > 10
        data = data.first(10) << (data[10..-1].sum)
        labels = labels.first(10) << 'Other'
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
