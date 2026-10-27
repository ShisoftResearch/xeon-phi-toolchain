#pragma once
#include <cstdint>
struct Mixed {double value;std::int64_t count;};
struct Pair {double x,y;};
struct Large {double x[5];std::uint64_t tag;};
struct UnwindResult {unsigned destroyed;bool caught;};
UnwindResult exercise_unwind(unsigned depth);
Mixed transform_mixed(Mixed);
Pair transform_pair(Pair);
Large transform_large(Large);
