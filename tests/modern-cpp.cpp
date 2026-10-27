#include <atomic>
#include <cstdio>
#include <filesystem>
#include <fstream>
#include <future>
#include <iomanip>
#include <mutex>
#include <optional>
#include <random>
#include <sstream>
#include <stdexcept>
#include <string>
#include <string_view>
#include <thread>
#include <vector>
#include <unistd.h>
static void require(bool ok,const char*message){if(!ok)throw std::runtime_error(message);}
int main(){try{
 std::string text="native K1OM C++17";std::string_view view(text);require(view.substr(7,4)=="K1OM"&&text.find(view.substr(7,4))==7,"string_view");
 std::optional<std::string> option;require(!option,"optional empty");option.emplace(view.substr(7,4));require(*option=="K1OM","optional value");
 std::ostringstream stream;stream<<std::fixed<<std::setprecision(3)<<1.25<<' '<<2.5L;require(stream.str()=="1.250 2.500","floating stream formatting");
 std::istringstream parser(stream.str());double d;long double ld;parser>>d>>ld;require(d==1.25&&ld==2.5L,"floating stream parsing");
 bool caught=false;try{std::ifstream missing;missing.exceptions(std::ios::failbit);missing.open("/tmp/knc-file-that-does-not-exist-13.4.0");}catch(const std::ios_base::failure&){caught=true;}require(caught,"ios failure bridge");
 std::once_flag once;std::atomic<unsigned> count(0);std::vector<std::thread> workers;
 for(unsigned i=0;i<16;++i)workers.emplace_back([&]{for(unsigned j=0;j<64;++j)std::call_once(once,[&]{count.fetch_add(1);});});
 for(auto&t:workers)t.join();require(count.load()==1,"call_once TLS proxy");
 auto future=std::async(std::launch::async,[]{return std::string("future works");});require(future.get()=="future works","future");
 std::random_device random;volatile unsigned sample=random();(void)sample;
 namespace fs=std::filesystem;char pattern[]="/tmp/knc-cxx17-XXXXXX";char*directory=mkdtemp(pattern);require(directory,"mkdtemp");
 fs::path base(directory),nested=base/"a"/"b",file=nested/"data.txt";require(fs::create_directories(nested),"filesystem mkdir");
 {std::ofstream output(file);output<<view<<'\n';require(bool(output),"ofstream path");}
 require(fs::exists(file)&&fs::is_regular_file(file)&&fs::file_size(file)==view.size()+1,"filesystem stat");
 unsigned entries=0;for(const auto&entry:fs::directory_iterator(nested)){require(entry.path().filename()=="data.txt","directory entry");++entries;}require(entries==1,"directory count");
 fs::path renamed=nested/"renamed.txt";fs::rename(file,renamed);require(fs::canonical(renamed).filename()=="renamed.txt","canonical path");
 {std::ifstream input(renamed);std::string line;std::getline(input,line);require(line==view,"ifstream path");}
 require(fs::remove_all(base)==4,"filesystem cleanup");
 std::printf("PASS modern K1OM C++17: string_view/optional, filesystem and path streams, double/long-double formatting/parsing, dual-ABI ios exceptions, call_once TLS, threads/future and OS random_device\n");return 0;
 }catch(const std::exception&e){std::fprintf(stderr,"FAIL modern C++17: %s\n",e.what());return 1;}}
