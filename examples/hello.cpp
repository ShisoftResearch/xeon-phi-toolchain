#include <iostream>
#include <vector>
int main() {
    std::vector<int> values{1,2,3,4};
    int sum=0;
    for (int x : values) sum+=x;
    std::cout << "Native K1OM C++ sum: " << sum << '\n';
    return sum!=10;
}
