#pragma once

#include "Core.h"
#include "spdlog/spdlog.h"
#include "spdlog/fmt/ostr.h"

/**
 * about spdlog or log, you should read at first
 * 1. there's no fatal log-level, so you can replaced by the critical as I did below;
 * 2. no color for output in windows terminal as well as cmd, if you want to fix it, maybe refer to https://github.com/gabime/spdlog/issues/1983;
 * 3. why using macros to wrap functions of Hazel::Log? because we should drop these in some configurations, like distribution;
 * 4. why using our class to wrap third-library? to reduce impact on client code, when changing it or replacing it by other library.
 */

namespace Hazel
{
	class HAZEL_API Log
	{
	private:
		static std::shared_ptr<spdlog::logger> s_CoreLogger;
		static std::shared_ptr<spdlog::logger> s_ClientLogger;
	public:
		static void Init();
		inline static std::shared_ptr<spdlog::logger>& GetCoreLogger() { return s_CoreLogger; }
		inline static std::shared_ptr<spdlog::logger>& GetClientLogger() { return s_ClientLogger; }
	};
}

// core log macros
#define HZ_CORE_CRITICAL(...) ::Hazel::Log::GetCoreLogger()->critical(__VA_ARGS__)
#define HZ_CORE_ERROR(...)    ::Hazel::Log::GetCoreLogger()->error(__VA_ARGS__)
#define HZ_CORE_WARN(...)     ::Hazel::Log::GetCoreLogger()->warn(__VA_ARGS__)
#define HZ_CORE_INFO(...)     ::Hazel::Log::GetCoreLogger()->info(__VA_ARGS__)
#define HZ_CORE_TRACE(...)    ::Hazel::Log::GetCoreLogger()->trace(__VA_ARGS__)

// client log macros
#define HZ_CRITICAL(...) ::Hazel::Log::GetClientLogger()->critical(__VA_ARGS__)
#define HZ_ERROR(...)    ::Hazel::Log::GetClientLogger()->error(__VA_ARGS__)
#define HZ_WARN(...)     ::Hazel::Log::GetClientLogger()->warn(__VA_ARGS__)
#define HZ_INFO(...)     ::Hazel::Log::GetClientLogger()->info(__VA_ARGS__)
#define HZ_TRACE(...)    ::Hazel::Log::GetClientLogger()->trace(__VA_ARGS__)