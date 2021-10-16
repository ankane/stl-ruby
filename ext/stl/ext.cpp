// stl
#include "stl.hpp"

// rice
#include <rice/rice.hpp>
#include <rice/stl.hpp>

Rice::Array to_a(std::vector<float>& x) {
  auto a = Rice::Array();
  for (auto v : x) {
    a.push(v);
  }
  return a;
}

extern "C"
void Init_ext() {
  auto rb_mStl = Rice::define_module("Stl");

  Rice::define_class_under<stl::StlParams>(rb_mStl, "StlParams")
    .define_constructor(Rice::Constructor<stl::StlParams>())
    .define_method("seasonal_length", &stl::StlParams::seasonal_length)
    .define_method("trend_length", &stl::StlParams::trend_length)
    .define_method("low_pass_length", &stl::StlParams::low_pass_length)
    .define_method("seasonal_degree", &stl::StlParams::seasonal_degree)
    .define_method("trend_degree", &stl::StlParams::trend_degree)
    .define_method("low_pass_degree", &stl::StlParams::low_pass_degree)
    .define_method("seasonal_jump", &stl::StlParams::seasonal_jump)
    .define_method("trend_jump", &stl::StlParams::trend_jump)
    .define_method("low_pass_jump", &stl::StlParams::low_pass_jump)
    .define_method("inner_loops", &stl::StlParams::inner_loops)
    .define_method("outer_loops", &stl::StlParams::outer_loops)
    .define_method("robust", &stl::StlParams::robust)
    .define_method(
      "fit",
      [](stl::StlParams& self, std::vector<float> series, size_t period, bool weights) {
        auto result = self.fit(series, period);

        auto ret = Rice::Hash();
        ret[Rice::Symbol("seasonal")] = to_a(result.seasonal);
        ret[Rice::Symbol("trend")] = to_a(result.trend);
        ret[Rice::Symbol("remainder")] = to_a(result.remainder);
        if (weights) {
          ret[Rice::Symbol("weights")] = to_a(result.weights);
        }
        return ret;
      });
}
