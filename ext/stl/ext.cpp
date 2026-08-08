#include <cstddef>
#include <vector>

#include <rice/rice.hpp>
#include <rice/stl.hpp>

#include "stl.hpp"

Rice::Array to_a(const std::vector<float>& x) {
  Rice::Array a;
  for (const auto v : x) {
    a.push(v, false);
  }
  return a;
}

extern "C"
void Init_ext() {
  Rice::Module rb_mStl = Rice::define_module("Stl");

  Rice::define_class_under<stl::StlParams>(rb_mStl, "StlParams")
    .define_constructor(Rice::Constructor<stl::StlParams>())
    .define_attr("seasonal_length", &stl::StlParams::seasonal_length)
    .define_attr("trend_length", &stl::StlParams::trend_length)
    .define_attr("low_pass_length", &stl::StlParams::low_pass_length)
    .define_attr("seasonal_degree", &stl::StlParams::seasonal_degree)
    .define_attr("trend_degree", &stl::StlParams::trend_degree)
    .define_attr("low_pass_degree", &stl::StlParams::low_pass_degree)
    .define_attr("seasonal_jump", &stl::StlParams::seasonal_jump)
    .define_attr("trend_jump", &stl::StlParams::trend_jump)
    .define_attr("low_pass_jump", &stl::StlParams::low_pass_jump)
    .define_attr("inner_loops", &stl::StlParams::inner_loops)
    .define_attr("outer_loops", &stl::StlParams::outer_loops)
    .define_attr("robust", &stl::StlParams::robust);

  Rice::define_class_under<stl::MstlParams>(rb_mStl, "MstlParams")
    .define_constructor(Rice::Constructor<stl::MstlParams>())
    .define_attr("iterations", &stl::MstlParams::iterations)
    .define_attr("lambda", &stl::MstlParams::lambda)
    .define_attr("seasonal_lengths", &stl::MstlParams::seasonal_lengths)
    .define_attr("stl_params", &stl::MstlParams::stl_params);

  rb_mStl
    .define_singleton_function(
      "_decompose",
      [](Rice::Array rb_series, size_t period, const stl::StlParams& params, bool weights) {
        std::vector<float> series = rb_series.to_vector<float>();
        stl::Stl fit{series, period, params};

        Rice::Hash ret;
        ret[Rice::Symbol("seasonal")] = to_a(fit.seasonal());
        ret[Rice::Symbol("trend")] = to_a(fit.trend());
        ret[Rice::Symbol("remainder")] = to_a(fit.remainder());
        if (weights) {
          ret[Rice::Symbol("weights")] = to_a(fit.weights());
        }
        return ret;
      })
    .define_singleton_function(
      "_decompose_mstl",
      [](Rice::Array rb_series, const std::vector<size_t>& periods, const stl::MstlParams& params) {
        std::vector<float> series = rb_series.to_vector<float>();
        stl::Mstl fit{series, periods, params};

        Rice::Array seasonal;
        for (const auto& s : fit.seasonal()) {
          seasonal.push(to_a(s), false);
        }

        Rice::Hash ret;
        ret[Rice::Symbol("seasonal")] = seasonal;
        ret[Rice::Symbol("trend")] = to_a(fit.trend());
        ret[Rice::Symbol("remainder")] = to_a(fit.remainder());
        return ret;
      });
}
