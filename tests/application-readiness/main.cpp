/* Substantial C++17-mode workload against the actual MPSS libstdc++ surface.
 * No claim that this old library supplies all C++17 library facilities. */
#include "contract.h"
#include <algorithm>
#include <atomic>
#include <condition_variable>
#include <chrono>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <deque>
#include <fstream>
#include <memory>
#include <mutex>
#include <numeric>
#include <stdexcept>
#include <string>
#include <thread>
#include <vector>
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
extern "C" void scaling_fp32(float*,const float*,const float*,std::size_t);
extern "C" double scaling_fp64(const double*,const double*,std::size_t);
extern "C" std::uint32_t scaling_q8(const std::int8_t*,const std::int8_t*,std::size_t);
static thread_local unsigned local_id=0;
static std::atomic<unsigned> tls_destructors(0);
struct ThreadState {unsigned jobs=0;~ThreadState(){tls_destructors.fetch_add(1,std::memory_order_relaxed);}};
static thread_local ThreadState state;
struct Queue {std::mutex mutex;std::condition_variable readable,writable;std::deque<unsigned> tasks;bool closed=false;};
static void require(bool value,const char*what){if(!value)throw std::runtime_error(what);}
static void abi(){
 for(int i=-1024;i<1024;++i){double x=i*0.25;Mixed m={x,i};m=transform_mixed(m);require(m.value==x+i&&m.count==i+1,"mixed aggregate");
  Pair p={x,-x};p=transform_pair(p);require(p.x==-x&&p.y==x,"FP aggregate");
  Large l={{x,x+1,x+2,x+3,x+4},static_cast<std::uint64_t>(i)};l=transform_large(l);for(unsigned j=0;j<5;++j)require(l.x[j]==x+2*j,"sret aggregate");require(l.tag==static_cast<std::uint64_t>(i)+1,"sret tag");
 }
 for(unsigned depth=0;depth<32;++depth){UnwindResult r=exercise_unwind(depth);require(r.caught&&r.destroyed==depth+1,"stack unwind");}
 bool caught=false;try{std::vector<int>(4).at(5);}catch(const std::out_of_range&){caught=true;}require(caught,"SDK exception");
}
static void files(){
 char path[]="/tmp/knc-app-XXXXXX";int fd=mkstemp(path);require(fd>=0,"mkstemp");
 const std::size_t bytes=65536;require(ftruncate(fd,bytes)==0,"ftruncate");
 unsigned char*p=static_cast<unsigned char*>(mmap(nullptr,bytes,PROT_READ|PROT_WRITE,MAP_SHARED,fd,0));require(p!=MAP_FAILED,"file mmap");
 for(std::size_t i=0;i<bytes;++i)p[i]=static_cast<unsigned char>(i*13+7);
 require(msync(p,bytes,MS_SYNC)==0,"msync");require(munmap(p,bytes)==0,"munmap");require(close(fd)==0,"close");
 std::ifstream input(path,std::ios::binary);std::vector<char> data(bytes);input.read(data.data(),bytes);require(input.gcount()==static_cast<std::streamsize>(bytes),"ifstream length");
 for(std::size_t i=0;i<bytes;++i)require(static_cast<unsigned char>(data[i])==static_cast<unsigned char>(i*13+7),"file contents");input.close();require(unlink(path)==0,"unlink");
}
int main(){try{
 auto start=std::chrono::steady_clock::now();abi();files();constexpr unsigned workers=32,jobs=65536,n=1021;Queue queue;
 std::atomic<unsigned> completed(0),failures(0);std::atomic<std::uint64_t> checks(0);std::vector<std::thread> threads;
 std::vector<unsigned> visits(jobs,0),worker_jobs(workers,0);
 for(unsigned id=0;id<workers;++id)threads.emplace_back([&,id]{try{
  require(local_id==0,"TLS initial value");local_id=id+1;
  std::vector<float>a(n),b(n),out(n);std::vector<double>da(n),db(n);std::vector<std::int8_t>qa(n),qb(n);
  for(;;){unsigned task;{
   std::unique_lock<std::mutex> lock(queue.mutex);queue.readable.wait(lock,[&]{return queue.closed||!queue.tasks.empty();});
   if(queue.tasks.empty()){require(queue.closed,"queue close");break;}task=queue.tasks.front();queue.tasks.pop_front();queue.writable.notify_one();
  }
  std::int64_t fp_expected=0;std::uint32_t q_expected=0;
  for(unsigned i=0;i<n;++i){int x=static_cast<int>((task*3+i*7)%31)-15,y=static_cast<int>((task*5+i*11)%17)-8;
   a[i]=da[i]=x;b[i]=db[i]=y;qa[i]=x;qb[i]=y;fp_expected+=x*y;q_expected+=static_cast<std::uint32_t>(x*y);
  }
  scaling_fp32(out.data(),a.data(),b.data(),n);double fp=scaling_fp64(da.data(),db.data(),n);std::uint32_t q=scaling_q8(qa.data(),qb.data(),n);
  require(fp==fp_expected&&q==q_expected,"dot products");for(unsigned i=0;i<n;++i)require(out[i]==a[i]*b[i]+3,"FP32 affine");
  require(local_id==id+1,"TLS isolation");++state.jobs;++visits[task];checks.fetch_add(n+3,std::memory_order_relaxed);
  completed.fetch_add(1,std::memory_order_release);
  if((task&63)==0){UnwindResult r=exercise_unwind(task%17);require(r.caught&&r.destroyed==task%17+1,"worker unwind");}
  }
  worker_jobs[id]=state.jobs;
 }catch(const std::exception&e){std::fprintf(stderr,"worker %u: %s\n",id,e.what());failures.fetch_add(1);{std::lock_guard<std::mutex> lock(queue.mutex);queue.closed=true;queue.tasks.clear();}queue.readable.notify_all();queue.writable.notify_all();}});
 for(unsigned task=0;task<jobs;++task){std::unique_lock<std::mutex> lock(queue.mutex);queue.writable.wait(lock,[&]{return queue.closed||queue.tasks.size()<64;});if(queue.closed)break;queue.tasks.push_back(task);queue.readable.notify_one();}
 {std::lock_guard<std::mutex> lock(queue.mutex);queue.closed=true;}queue.readable.notify_all();
 for(auto&t:threads)t.join();require(!failures.load()&&completed.load(std::memory_order_acquire)==jobs,"completion");
 require(local_id==0&&tls_destructors.load()==workers,"TLS cleanup");for(auto v:visits)require(v==1,"exactly-once jobs");require(std::accumulate(worker_jobs.begin(),worker_jobs.end(),0u)==jobs,"worker accounting");
 auto elapsed=std::chrono::duration_cast<std::chrono::nanoseconds>(std::chrono::steady_clock::now()-start).count();
 std::printf("DURATION application ns=%llu\n",static_cast<unsigned long long>(elapsed));
 std::printf("PASS application readiness: C++17 mode, workers=%u jobs=%u lane_checks=%llu; bounded queue, mutex/condition_variable, release/acquire atomics, TLS destructors, vector/string/allocation, file mmap/streams, aggregate calls and recursive unwind\n",workers,jobs,static_cast<unsigned long long>(checks.load()));return 0;
 }catch(const std::exception&e){std::fprintf(stderr,"FAIL application readiness: %s\n",e.what());return 1;}}
