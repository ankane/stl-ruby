# STL Ruby

Seasonal-trend decomposition for Ruby

[![Build Status](https://github.com/ankane/stl-ruby/workflows/build/badge.svg?branch=master)](https://github.com/ankane/stl-ruby/actions)

## Installation

Add this line to your application’s Gemfile:

```ruby
gem 'stl-rb'
```

## Getting Started

Decompose a time series

```ruby
series = {
  Date.parse("2020-01-01") => 100,
  Date.parse("2020-01-02") => 150,
  Date.parse("2020-01-03") => 136,
  # ...
}

Stl.decompose(series, period: 7)
```

Works great with [Groupdate](https://github.com/ankane/groupdate)

```ruby
series = User.group_by_day(:created_at).count
Stl.decompose(series, period: 7)
```

Series can also be an array without times

```ruby
series = [100, 150, 136, ...]
Stl.decompose(series, period: 7)
```

Use robustness iterations

```ruby
Stl.decompose(series, period: 7, robust: true)
```

## Options

Pass options

```ruby
Stl.decompose(
  series,
  period: 7,              # period of the seasonal component
  seasonal_length: 7,     # length of the seasonal smoother
  trend_length: 15,       # length of the trend smoother
  low_pass_length: 7,     # length of the low-pass filter
  seasonal_degree: 0,     # degree of locally-fitted polynomial in seasonal smoothing
  trend_degree: 1,        # degree of locally-fitted polynomial in trend smoothing
  low_pass_degree: 1,     # degree of locally-fitted polynomial in low-pass smoothing
  seasonal_jump: 1,       # skipping value for seasonal smoothing
  trend_jump: 2,          # skipping value for trend smoothing
  low_pass_jump: 1,       # skipping value for low-pass smoothing
  inner_loops: 2,         # number of loops for updating the seasonal and trend components
  outer_loops: 0,         # number of iterations of robust fitting
  robust: false           # if robustness iterations are to be used
)
```

## Plotting

Add [Vega](https://github.com/ankane/vega) to your application’s Gemfile:

```ruby
gem 'vega'
```

And use:

```ruby
Stl.plot(series, decompose_result)
```

## Credits

This library was ported from the [Fortran implementation](https://www.netlib.org/a/stl).

## References

- [STL: A Seasonal-Trend Decomposition Procedure Based on Loess](https://www.scb.se/contentassets/ca21efb41fee47d293bbee5bf7be7fb3/stl-a-seasonal-trend-decomposition-procedure-based-on-loess.pdf)

## History

View the [changelog](https://github.com/ankane/stl-ruby/blob/master/CHANGELOG.md)

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/ankane/stl-ruby/issues)
- Fix bugs and [submit pull requests](https://github.com/ankane/stl-ruby/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features

To get started with development:

```sh
git clone https://github.com/ankane/stl-ruby.git
cd stl-ruby
bundle install
bundle exec rake compile
bundle exec rake test
```
