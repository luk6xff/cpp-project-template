//The value of multiplier was captured by value when the lambda was defined. Thus, changing the value of
//multiplier later does not change the lambda, and it still multiplies by three. The transform() algorithm is called
//twice, so the effect is to multiply by 9, not 60.

#include <algorithm>
#include <iostream>
#include <iterator>
#include <vector>
int main()
{
	std::vector<int> data{ 1, 2, 3 };
	int multiplier{ 3 };
	auto times = [multiplier](int i) { return i * multiplier; };
	std::transform(data.begin(), data.end(), data.begin(), times);
	multiplier = 20;
	std::transform(data.begin(), data.end(), data.begin(), times);
	std::copy(data.begin(), data.end(),
		std::ostream_iterator<int>(std::cout, "\n"));
}