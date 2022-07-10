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
	kind "SharedLib"
	-- ����
	language "C++"
	staticruntime "off"

	-- Ŀ��Ŀ¼
	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	-- �м�Ŀ¼(.o)
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

	pchheader "hzpch.h"
	pchsource "Hazel/src/hzpch.cpp"

	-- �����ļ� ** �ݹ��������
	files {"%{prj.name}/src/**.h", "%{prj.name}/src/**.cpp"}
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
		symbols "On"
	-- ������ Release����
	filter "configurations:Release"
		defines "HZ_RELEASE"
		runtime "Release"
		-- �����Ż�
		optimize "On"
	-- ������ Dist����
	filter "configurations:Dist"
		defines "HZ_DIST"
		runtime "Release"
		optimize "On"

-- ��Ŀ Sandbox
project "Sandbox"
	location "Sandbox"
	kind "ConsoleApp"
	language "C++"
	staticruntime "off"
	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")
	files {"%{prj.name}/src/**.h", "%{prj.name}/src/**.cpp"}
	includedirs {
		"Hazel/vendor/spdlog/include",
		"Hazel/src",
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
		symbols "On"
	filter "configurations:Release"
		defines "HZ_RELEASE"
		runtime "Release"
		optimize "On"
	filter "configurations:Dist"
		defines "HZ_DIST"
		runtime "Release"
		optimize "On"
	
		