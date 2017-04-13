#include <iostream>
#include <thread>

#include "IrStd/Compiler.hpp"
#include "IrStd/Bootstrap.hpp"
#include "IrStd/Logger.hpp"
#include "IrStd/Compiler.hpp"
#include "IrStd/Exception.hpp"

constexpr int numThreads = 10;

void call_from_thread(int tid)
{
	IRSTD_LOG_INFO("Launched by thread " << tid);
}

int main()
{
	std::thread t[numThreads];



	IRSTD_LOG_INFO("Using " IRSTD_COMPILER_STRING);

	// Launch a group of threads
	for (int i = 0; i < numThreads; ++i) {
		t[i] = std::thread(call_from_thread, i);
	}

	// Join the threads with the main thread
	for (int i = 0; i < numThreads; ++i) {
		t[i].join();
	}

	return 0;
}
