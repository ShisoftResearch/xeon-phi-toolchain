#include "contract.h"
#include <stdexcept>
#include <string>
struct guard {unsigned &count;std::string payload;guard(unsigned &c):count(c),payload(80,'x'){}~guard(){++count;}};
__attribute__((noinline)) static void descend(unsigned n,unsigned &count){
 guard g(count);if(n)descend(n-1,count);else throw std::runtime_error("K1OM unwind probe");
 /* Keep recursion non-tail and local objects live across its exceptional edge. */
 if(g.payload.size()!=80)throw std::logic_error("bad guard");
}
UnwindResult exercise_unwind(unsigned depth){UnwindResult r={0,false};try{descend(depth,r.destroyed);}catch(const std::runtime_error&e){r.caught=std::string(e.what())=="K1OM unwind probe";}return r;}
Mixed transform_mixed(Mixed m){m.value+=m.count;++m.count;return m;}
Pair transform_pair(Pair p){Pair q={p.y,p.x};return q;}
Large transform_large(Large p){for(unsigned i=0;i<5;++i)p.x[i]+=i;++p.tag;return p;}
