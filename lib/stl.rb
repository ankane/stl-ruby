# ext
require "stl/ext"

# modules
require "stl/version"

module Stl
  class << self
    def decompose(
      series, period:,
      seasonal_length: nil, trend_length: nil, low_pass_length: nil,
      seasonal_degree: nil, trend_degree: nil, low_pass_degree: nil,
      seasonal_jump: nil, trend_jump: nil, low_pass_jump: nil,
      inner_loops: nil, outer_loops: nil, robust: false
    )
      params = StlParams.new

      params.seasonal_length(seasonal_length) unless seasonal_length.nil?
      params.trend_length(trend_length) unless trend_length.nil?
      params.low_pass_length(low_pass_length) unless low_pass_length.nil?

      params.seasonal_degree(seasonal_degree) unless seasonal_degree.nil?
      params.trend_degree(trend_degree) unless trend_degree.nil?
      params.low_pass_degree(low_pass_degree) unless low_pass_degree.nil?

      params.seasonal_jump(seasonal_jump) unless seasonal_jump.nil?
      params.trend_jump(trend_jump) unless trend_jump.nil?
      params.low_pass_jump(low_pass_jump) unless low_pass_jump.nil?

      params.inner_loops(inner_loops) unless inner_loops.nil?
      params.outer_loops(outer_loops) unless outer_loops.nil?
      params.robust(robust) unless robust.nil?

      if series.is_a?(Hash)
        sorted = series.sort_by { |k, _| k }
        y = sorted.map(&:last)
      else
        y = series
      end

      params.fit(y, period, outer_loops.nil? ? robust : outer_loops > 0)
    end

    def plot(series, result)
      require "vega"

      data =
        if series.is_a?(Hash)
          series.sort_by { |k, _| k }.map.with_index do |s, i|
            {
              x: iso8601(s[0]),
              series: s[1],
              seasonal: result[:seasonal][i],
              trend: result[:trend][i],
              remainder: result[:remainder][i]
            }
          end
        else
          series.map.with_index do |v, i|
            {
              x: i,
              series: v,
              seasonal: result[:seasonal][i],
              trend: result[:trend][i],
              remainder: result[:remainder][i]
            }
          end
        end

      if series.is_a?(Hash)
        x = {field: "x", type: "temporal"}
        x["scale"] = {type: "utc"} if series.keys.first.is_a?(Date)
      else
        x = {field: "x", type: "quantitative"}
      end
      x[:axis] = {title: nil, labelFontSize: 12}

      charts =
        ["series", "seasonal", "trend", "remainder"].map do |field|
          {
            mark: {type: "line"},
            encoding: {
              x: x,
              y: {field: field, type: "quantitative", scale: {zero: false}, axis: {labelFontSize: 12}}
            },
            width: "container",
            height: 100
          }
        end

      Vega.lite
        .data(data)
        .vconcat(charts)
        .config(autosize: {type: "fit-x", contains: "padding"})
        .width(nil) # prevents warning
        .height(nil) # prevents warning and sets div height to auto
    end

    private

    def iso8601(v)
      if v.is_a?(Date)
        v.strftime("%Y-%m-%d")
      else
        v.strftime("%Y-%m-%dT%H:%M:%S.%L%z")
      end
    end
  end
end
