#include <iostream>
#include <thread>

#include "IrStd/IrStd.hpp"
#include <curl/curl.h>
#include <future>

constexpr int numThreads = 10;

IRSTD_TOPIC_USE(None);
IRSTD_TOPIC_USE(IrStdMemory);

void call_from_thread(int tid)
{
	IRSTD_LOG_INFO("Launched by thread " << tid);
}

static size_t fetchCurlCallback(void *contents, size_t size, size_t nmemb, void *userp)
{
	((std::string*)userp)->append((char*)contents, size * nmemb);
	return size * nmemb;
}

bool fetch(std::string& data, const char* const url)
{
	CURL *curl;
	CURLcode res;

	curl = curl_easy_init();
	if (curl)
	{
		::curl_easy_setopt(curl, CURLOPT_URL, url);
		::curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, fetchCurlCallback);
		::curl_easy_setopt(curl, CURLOPT_WRITEDATA, &data);
		res = ::curl_easy_perform(curl);
		::curl_easy_cleanup(curl);

		if (res == ::CURLE_OK)
		{
			return true;
		}

		IRSTD_LOG(curl_easy_strerror(res) << " (url=" << url << ")");
	}

	return true;
}

void read_page()
{
	std::string data;
	std::future<bool> fut = std::async(fetch, std::ref(data), "htdtp://dsd"); 

	fut.wait();

	IRSTD_LOG(data);
}

int mainIrStd()
{
	IrStd::Logger::getDefault().allTopics();

	std::thread t[numThreads];
	std::string data;

	IrStd::Fetch fetch(data);
	auto fut = fetch.url("www.google.com");

	fut.wait();

	IRSTD_LOG(data);

	//fetch.

	IRSTD_LOG_INFO("Using " IRSTD_COMPILER_STRING);

	// Launch a group of threads
	for (int i = 0; i < numThreads; ++i) {
		t[i] = std::thread(call_from_thread, i);
	}

	// Join the threads with the main thread
	for (int i = 0; i < numThreads; ++i) {
		t[i].join();
	}

	read_page();

	return 0;
}

int main()
{
	auto& main = IrStd::Main::getInstance();
	return main.call(mainIrStd);
}
