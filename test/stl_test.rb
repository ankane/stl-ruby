require_relative "test_helper"

class StlTest < Minitest::Test
  def test_hash
    today = Date.today
    series = self.series.map.with_index.to_h { |v, i| [today + i, v] }
    result = Stl.decompose(series, period: 7)
    assert_elements_in_delta [0.36926576, 0.75655484, -1.3324139, 1.9553658, -0.6044802], result[:seasonal].first(5)
    assert_elements_in_delta [4.804099, 4.9097075, 5.015316, 5.16045, 5.305584], result[:trend].first(5)
    assert_elements_in_delta [-0.17336464, 3.3337379, -1.6829021, 1.8841844, -4.7011037], result[:remainder].first(5)
  end

  def test_array
    result = Stl.decompose(series, period: 7)
    assert_elements_in_delta [0.36926576, 0.75655484, -1.3324139, 1.9553658, -0.6044802], result[:seasonal].first(5)
    assert_elements_in_delta [4.804099, 4.9097075, 5.015316, 5.16045, 5.305584], result[:trend].first(5)
    assert_elements_in_delta [-0.17336464, 3.3337379, -1.6829021, 1.8841844, -4.7011037], result[:remainder].first(5)
  end

  def test_robust
    result = Stl.decompose(series, period: 7, robust: true)
    assert_elements_in_delta [0.14922355, 0.47939026, -1.833231, 1.7411387, 0.8200711], result[:seasonal].first(5)
    assert_elements_in_delta [5.397365, 5.4745436, 5.5517216, 5.6499176, 5.748114], result[:trend].first(5)
    assert_elements_in_delta [-0.5465884, 3.0460663, -1.7184906, 1.6089439, -6.5681853], result[:remainder].first(5)
    assert_elements_in_delta [0.99374926, 0.8129377, 0.9385952, 0.9458036, 0.29742217], result[:weights].first(5)
  end

  def test_repeating
    series = 24.times.to_a.shuffle * 8
    result = Stl.decompose(series, period: 24)
    assert_elements_in_delta [0] * series.size, result[:remainder]
    assert_elements_in_delta [11.5] * series.size, result[:trend]
  end

  def test_period_one
    error = assert_raises(ArgumentError) do
      Stl.decompose(series, period: 1)
    end
    assert_equal "period must be greater than 1", error.message
  end

  def test_too_few_periods
    error = assert_raises(ArgumentError) do
      Stl.decompose(series, period: 16)
    end
    assert_equal "series has less than two periods", error.message
  end

  def test_bad_seasonal_degree
    error = assert_raises(ArgumentError) do
      Stl.decompose(series, period: 7, seasonal_degree: 2)
    end
    assert_equal "seasonal_degree must be 0 or 1", error.message
  end

  def test_plot_hash
    today = Date.today
    series = self.series.map.with_index.to_h { |v, i| [today + i, v] }
    result = Stl.decompose(series, period: 7)
    assert_kind_of Vega::LiteChart, Stl.plot(series, result)
  end

  def test_plot_array
    result = Stl.decompose(series, period: 7)
    assert_kind_of Vega::LiteChart, Stl.plot(series, result)
  end

  def test_seasonal_strength
    result = Stl.decompose(series, period: 7)
    assert_in_delta 0.284111676315015, Stl.seasonal_strength(result)
  end

  def test_seasonal_strength_max
    series = 30.times.map { |i| i % 7 }
    result = Stl.decompose(series, period: 7)
    assert_in_delta 1, Stl.seasonal_strength(result)
  end

  def test_trend_strength
    result = Stl.decompose(series, period: 7)
    assert_in_delta 0.16384245231864702, Stl.trend_strength(result)
  end

  def test_trend_strength_max
    series = 30.times.to_a
    result = Stl.decompose(series, period: 7)
    assert_in_delta 1, Stl.trend_strength(result)
  end

  def series
    [
      5.0, 9.0, 2.0, 9.0, 0.0, 6.0, 3.0, 8.0, 5.0, 8.0,
      7.0, 8.0, 8.0, 0.0, 2.0, 5.0, 0.0, 5.0, 6.0, 7.0,
      3.0, 6.0, 1.0, 4.0, 4.0, 4.0, 3.0, 7.0, 5.0, 8.0
    ]
  end
end
