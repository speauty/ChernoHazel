-- 工作空间名称
workspace "Hazel"
	-- 架构
	architecture "x64"
	-- 配置
	configurations {"Debug", "Release", "Dist"}

-- 自定义变量 输出目录
outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

IncludeDir = {}
IncludeDir["GLFW"] = "Hazel/vendor/GLFW/include"

include "Hazel/vendor/GLFW"

-- 项目 Hazel
project "Hazel"
	-- 位置
	location "Hazel"
	-- 项目类型
	kind "SharedLib"
	-- 语言
	language "C++"

	-- 目标目录
	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	-- 中间目录(.o)
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

	pchheader "hzpch.h"
	pchsource "Hazel/src/hzpch.cpp"

	-- 包含文件 ** 递归搜索标记
	files {"%{prj.name}/src/**.h", "%{prj.name}/src/**.cpp"}
	-- 包含路径
	includedirs {
		-- Hazel核心目录, 加入包含目录, 方便使用
		"%{prj.name}/src",
		-- 日志库 spdlog
		"%{prj.name}/vendor/spdlog/include",
		"%{IncludeDir.GLFW}",
	}
	
	links
	{
		"GLFW",
		"opengl32.lib"
	}
	
	-- 过滤器 windows
	filter "system:windows"
		-- ?方言
		cppdialect "C++17"
		-- 运行时静态支持
		staticruntime "On"
		-- WinSDK版本 这个需要本地化设置 这里保持最新版本
		systemversion "latest"
		-- 宏定义
		defines {
			"HZ_BUILD_DLL", "HZ_PLATFORM_WINDOWS", "_WINDLL"
		}
		-- 构建后置操作指令集
		postbuildcommands {
			-- 首次运行 这里会找不到相应文件 从而导致异常 再次运行即可
			("{COPY} %{cfg.buildtarget.relpath} ../bin/" .. outputdir .. "/Sandbox")
		}
	-- 过滤器 Debug配置 仅适用于Debug
	filter "configurations:Debug"
		defines "HZ_DEBUG"
		buildoptions "/MDd"
		symbols "On"
	-- 过滤器 Release配置
	filter "configurations:Release"
		defines "HZ_RELEASE"
		buildoptions "/MD"
		-- 启用优化
		optimize "On"
	-- 过滤器 Dist配置
	filter "configurations:Dist"
		defines "HZ_DIST"
		buildoptions "/MD"
		optimize "On"

	--[[filter {"system:windows", "configurations:Release"}
		-- 构建选项 采用多线程
		buildoptions "/MT"
	--]]

-- 项目 Sandbox
project "Sandbox"
	location "Sandbox"
	kind "ConsoleApp"
	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")
	files {"%{prj.name}/src/**.h", "%{prj.name}/src/**.cpp"}
	includedirs {
		"Hazel/vendor/spdlog/include",
		"Hazel/src"
	}
	-- 链接
	links {"Hazel"}
	filter "system:windows"
		cppdialect "C++17"
		staticruntime "On"
		systemversion "10.0"
		defines {"HZ_PLATFORM_WINDOWS"}
	filter "configurations:Debug"
		defines "HZ_DEBUG"
		buildoptions "/MDd"
		symbols "On"
	filter "configurations:Release"
		defines "HZ_RELEASE"
		buildoptions "/MD"
		optimize "On"
	filter "configurations:Dist"
		defines "HZ_DIST"
		buildoptions "/MD"
		optimize "On"
	
		