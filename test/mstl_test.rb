require_relative "test_helper"

class MstlTest < Minitest::Test
  def test_hash
    today = Date.today
    series = self.series.map.with_index.to_h { |v, i| [today + i, v] }
    result = Stl.decompose(series, period: [6, 10])
    assert_elements_in_delta [0.28318232, 0.70529824, -1.980384, 2.1643379, -2.3356874], result[:seasonal][0].first(5)
    assert_elements_in_delta [1.4130436, 1.6048906, 0.050958008, -1.8706754, -1.7704514], result[:seasonal][1].first(5)
    assert_elements_in_delta [5.139485, 5.223691, 5.3078976, 5.387292, 5.4666862], result[:trend].first(5)
    assert_elements_in_delta [-1.835711, 1.4661198, -1.3784716, 3.319045, -1.3605475], result[:remainder].first(5)
  end

  def test_array
    result = Stl.decompose(series, period: [6, 10])
    assert_elements_in_delta [0.28318232, 0.70529824, -1.980384, 2.1643379, -2.3356874], result[:seasonal][0].first(5)
    assert_elements_in_delta [1.4130436, 1.6048906, 0.050958008, -1.8706754, -1.7704514], result[:seasonal][1].first(5)
    assert_elements_in_delta [5.139485, 5.223691, 5.3078976, 5.387292, 5.4666862], result[:trend].first(5)
    assert_elements_in_delta [-1.835711, 1.4661198, -1.3784716, 3.319045, -1.3605475], result[:remainder].first(5)
  end

  def test_unsorted_periods
    result = Stl.decompose(series, period: [10, 6])
    assert_elements_in_delta [1.4130436, 1.6048906, 0.050958008, -1.8706754, -1.7704514], result[:seasonal][0].first(5)
    assert_elements_in_delta [0.28318232, 0.70529824, -1.980384, 2.1643379, -2.3356874], result[:seasonal][1].first(5)
    assert_elements_in_delta [5.139485, 5.223691, 5.3078976, 5.387292, 5.4666862], result[:trend].first(5)
    assert_elements_in_delta [-1.835711, 1.4661198, -1.3784716, 3.319045, -1.3605475], result[:remainder].first(5)
  end

  def test_lambda
    result = Stl.decompose(series, period: [6, 10], lambda: 0.5)
    assert_elements_in_delta [0.43371448, 0.10503793, -0.7178911, 1.2356076, -1.8253292], result[:seasonal][0].first(5)
    assert_elements_in_delta [1.0437742, 0.8650516, 0.07303603, -1.428663, -1.1990008], result[:seasonal][1].first(5)
    assert_elements_in_delta [2.0748303, 2.1291165, 2.1834028, 2.2330272, 2.2826517], result[:trend].first(5)
    assert_elements_in_delta [-1.0801829, 0.900794, -0.7101207, 1.9600279, -1.2583216], result[:remainder].first(5)
  end

  def test_lambda_zero
    series = self.series.map { |v| v + 1 }
    result = Stl.decompose(series, period: [6, 10], lambda: 0.0)
    assert_elements_in_delta [0.18727916, 0.029921893, -0.2716494, 0.47748315, -0.7320051], result[:seasonal][0].first(5)
    assert_elements_in_delta [0.42725056, 0.32145387, -0.019030934, -0.56607914, -0.46765903], result[:seasonal][1].first(5)
    assert_elements_in_delta [1.592807, 1.6144379, 1.6360688, 1.6559447, 1.6758206], result[:trend].first(5)
    assert_elements_in_delta [-0.41557717, 0.33677137, -0.24677622, 0.7352363, -0.47615635], result[:remainder].first(5)
  end

  def test_lambda_out_of_range
    error = assert_raises(ArgumentError) do
      Stl.decompose(series, period: [6, 10], lambda: 2)
    end
    assert_equal "lambda must be between 0 and 1", error.message
  end

  def test_empty_periods
    error = assert_raises(ArgumentError) do
      Stl.decompose(series, period: [])
    end
    assert_equal "periods must not be empty", error.message
  end

  def test_period_one
    error = assert_raises(ArgumentError) do
      Stl.decompose(series, period: [1])
    end
    assert_equal "periods must be at least 2", error.message
  end

  def test_too_few_periods
    error = assert_raises(ArgumentError) do
      Stl.decompose(series, period: [16])
    end
    assert_equal "series has less than two periods", error.message
  end

  def test_plot_hash
    today = Date.today
    series = self.series.map.with_index.to_h { |v, i| [today + i, v] }
    result = Stl.decompose(series, period: [7])
    error = assert_raises(RuntimeError) do
      Stl.plot(series, result)
    end
    assert_equal "not implemented yet", error.message
  end

  def test_plot_array
    result = Stl.decompose(series, period: [7])
    error = assert_raises(RuntimeError) do
      Stl.plot(series, result)
    end
    assert_equal "not implemented yet", error.message
  end

  def test_seasonal_strength
    result = Stl.decompose(series, period: [7], seasonal_length: 7)
    assert_in_delta 0.284111676315015, Stl.seasonal_strength(result)[0]
  end

  def test_seasonal_strength_max
    series = 30.times.map { |i| i % 7 }
    result = Stl.decompose(series, period: [7], seasonal_length: [7])
    assert_in_delta 1, Stl.seasonal_strength(result)[0]
  end

  def test_trend_strength
    result = Stl.decompose(series, period: [7], seasonal_length: 7)
    assert_in_delta 0.16384245231864702, Stl.trend_strength(result)
  end

  def test_trend_strength_max
    series = 30.times.to_a
    result = Stl.decompose(series, period: [7], seasonal_length: 7)
    assert_in_delta 1, Stl.trend_strength(result)
  end
end
