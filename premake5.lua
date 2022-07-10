-- �����ռ�����
workspace "Hazel"
	-- �ܹ�
	architecture "x64"
	startproject "Sandbox"
	-- ����
	configurations {"Debug", "Release", "Dist"}

-- �Զ������ ���Ŀ¼
outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

IncludeDir = {}
IncludeDir["GLFW"] = "Hazel/vendor/GLFW/include"
IncludeDir["Glad"] = "Hazel/vendor/Glad/include"
IncludeDir["ImGui"] = "Hazel/vendor/ImGui"
IncludeDir["glm"] = "Hazel/vendor/glm"

include "Hazel/vendor/GLFW"
include "Hazel/vendor/Glad"
include "Hazel/vendor/ImGui"

-- ��Ŀ Hazel
project "Hazel"
	-- λ��
	location "Hazel"
	-- ��Ŀ����
	kind "StaticLib"
	-- ����
	language "C++"
	staticruntime "on"

	-- Ŀ��Ŀ¼
	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	-- �м�Ŀ¼(.o)
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

	pchheader "hzpch.h"
	pchsource "Hazel/src/hzpch.cpp"

	-- �����ļ� ** �ݹ��������
	files {"%{prj.name}/src/**.h", "%{prj.name}/src/**.cpp"}
	
	defines
	{
		"_CRT_SECURE_NO_WARNINGS"
	}
	
	-- ����·��
	includedirs {
		-- Hazel����Ŀ¼, �������Ŀ¼, ����ʹ��
		"%{prj.name}/src",
		-- ��־�� spdlog
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
	
	-- ������ windows
	filter "system:windows"
		-- ?����
		cppdialect "C++17"
		-- WinSDK�汾 �����Ҫ���ػ����� ���ﱣ�����°汾
		systemversion "latest"
		-- �궨��
		defines {
			"HZ_BUILD_DLL", 
			"HZ_PLATFORM_WINDOWS", 
			"_WINDLL",
			"GLFW_INCLUDE_NONE",
		}
		-- �������ò���ָ�
		postbuildcommands {
			-- �״����� ������Ҳ�����Ӧ�ļ� �Ӷ������쳣 �ٴ����м���
			("{COPY} %{cfg.buildtarget.relpath} ../bin/" .. outputdir .. "/Sandbox")
		}
	-- ������ Debug���� ��������Debug
	filter "configurations:Debug"
		defines "HZ_DEBUG"
		runtime "Debug"
		symbols "on"
	-- ������ Release����
	filter "configurations:Release"
		defines "HZ_RELEASE"
		runtime "Release"
		-- �����Ż�
		optimize "on"
	-- ������ Dist����
	filter "configurations:Dist"
		defines "HZ_DIST"
		runtime "Release"
		optimize "on"

-- ��Ŀ Sandbox
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
	-- ����
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
	
		