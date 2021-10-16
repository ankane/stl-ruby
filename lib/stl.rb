# ext
require "stl/ext"

# modules
require "stl/version"

module Stl
  def self.decompose(
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
end
