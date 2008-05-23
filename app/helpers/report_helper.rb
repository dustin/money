require 'gchart'

module ReportHelper

  def pie_chart(data, labels, opts = {})
    if data.size > 1
      width = opts.delete(:width) || 400
      height = opts.delete(:height) || 200
      tag :img, :alt => "pie",
        :src => Gchart.pie_3d(opts.merge({:data => data, :legend => labels,
          :width => width, :height => height}))
    end
  end

end
