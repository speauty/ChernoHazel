-- 工作空间名称
workspace "Hazel"
	-- 架构
	architecture "x64"
	startproject "Sandbox"
	-- 配置
	configurations {"Debug", "Release", "Dist"}

-- 自定义变量 输出目录
outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

IncludeDir = {}
IncludeDir["GLFW"] = "Hazel/vendor/GLFW/include"
IncludeDir["Glad"] = "Hazel/vendor/Glad/include"
IncludeDir["ImGui"] = "Hazel/vendor/ImGui"
IncludeDir["glm"] = "Hazel/vendor/glm"

include "Hazel/vendor/GLFW"
include "Hazel/vendor/Glad"
include "Hazel/vendor/ImGui"

-- 项目 Hazel
project "Hazel"
	-- 位置
	location "Hazel"
	-- 项目类型
	kind "StaticLib"
	-- 语言
	language "C++"
	staticruntime "on"

	-- 目标目录
	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	-- 中间目录(.o)
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

	pchheader "hzpch.h"
	pchsource "Hazel/src/hzpch.cpp"

	-- 包含文件 ** 递归搜索标记
	files {"%{prj.name}/src/**.h", "%{prj.name}/src/**.cpp"}
	
	defines
	{
		"_CRT_SECURE_NO_WARNINGS"
	}
	
	-- 包含路径
	includedirs {
		-- Hazel核心目录, 加入包含目录, 方便使用
		"%{prj.name}/src",
		-- 日志库 spdlog
		"%{prj.name}/vendor/spdlog/include",
		"%{IncludeDir.GLFW}",
		"%{IncludeDir.Glad}",
		"%{IncludeDir.ImGui}",
		"%{IncludeDir.glm}",
	}
	
	links
	{
		"GLFW",
		"Glad",
		"ImGui",
		"opengl32.lib"
	}
	
	-- 过滤器 windows
	filter "system:windows"
		-- ?方言
		cppdialect "C++17"
		-- WinSDK版本 这个需要本地化设置 这里保持最新版本
		systemversion "latest"
		-- 宏定义
		defines {
			"HZ_BUILD_DLL", 
			"HZ_PLATFORM_WINDOWS", 
			"_WINDLL",
			"GLFW_INCLUDE_NONE",
		}
		-- 构建后置操作指令集
		postbuildcommands {
			-- 首次运行 这里会找不到相应文件 从而导致异常 再次运行即可
			("{COPY} %{cfg.buildtarget.relpath} ../bin/" .. outputdir .. "/Sandbox")
		}
	-- 过滤器 Debug配置 仅适用于Debug
	filter "configurations:Debug"
		defines "HZ_DEBUG"
		runtime "Debug"
		symbols "on"
	-- 过滤器 Release配置
	filter "configurations:Release"
		defines "HZ_RELEASE"
		runtime "Release"
		-- 启用优化
		optimize "on"
	-- 过滤器 Dist配置
	filter "configurations:Dist"
		defines "HZ_DIST"
		runtime "Release"
		optimize "on"

-- 项目 Sandbox
project "Sandbox"
	location "Sandbox"
	kind "ConsoleApp"
	language "C++"
	cppdialect "C++17"
	staticruntime "on"
	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")
	files {"%{prj.name}/src/**.h", "%{prj.name}/src/**.cpp"}
	includedirs {
		"Hazel/vendor/spdlog/include",
		"Hazel/src",
		"Hazel/vendor",
		"%{IncludeDir.glm}",
	}
	-- 链接
	links {"Hazel"}
	filter "system:windows"
		cppdialect "C++17"
		systemversion "10.0"
		defines {"HZ_PLATFORM_WINDOWS"}
	filter "configurations:Debug"
		defines "HZ_DEBUG"
		runtime "Debug"
		symbols "on"
	filter "configurations:Release"
		defines "HZ_RELEASE"
		runtime "Release"
		optimize "on"
	filter "configurations:Dist"
		defines "HZ_DIST"
		runtime "Release"
		optimize "on"
	
		