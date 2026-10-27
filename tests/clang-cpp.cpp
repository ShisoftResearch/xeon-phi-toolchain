#include <cstdio>
#include <vector>
#include <string>
#include <thread>
#include <atomic>
#include <stdexcept>
static thread_local unsigned local_value=7;
int main(){
 std::vector<float> values(128,1.5f);float sum=0;for(float x:values)sum+=x;
 std::string text="native KNC C++17";std::atomic<unsigned> count(0);unsigned worker_local=0;
 std::thread worker([&]{local_value+=11;worker_local=local_value;for(unsigned i=0;i<1000;i++)count.fetch_add(1,std::memory_order_relaxed);});worker.join();
 bool caught=false;try{(void)values.at(999);}catch(const std::out_of_range&){caught=true;}
 std::printf("PASS %s: vector/string, FP sum=%g, thread/atomics=%u, TLS=%u/%u, exception=%d\n",text.c_str(),(double)sum,count.load(),local_value,worker_local,caught);
 return sum!=192.0f||count!=1000||local_value!=7||worker_local!=18||!caught;
}
