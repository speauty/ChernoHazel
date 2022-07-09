-- �����ռ�����
workspace "Hazel"
	-- �ܹ�
	architecture "x64"
	-- ����
	configurations {"Debug", "Release", "Dist"}

-- �Զ������ ���Ŀ¼
outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

IncludeDir = {}
IncludeDir["GLFW"] = "Hazel/vendor/GLFW/include"
IncludeDir["Glad"] = "Hazel/vendor/Glad/include"

include "Hazel/vendor/GLFW"
include "Hazel/vendor/Glad"

-- ��Ŀ Hazel
project "Hazel"
	-- λ��
	location "Hazel"
	-- ��Ŀ����
	kind "SharedLib"
	-- ����
	language "C++"

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
	}
	
	links
	{
		"GLFW",
		"Glad",
		"opengl32.lib"
	}
	
	-- ������ windows
	filter "system:windows"
		-- ?����
		cppdialect "C++17"
		-- ����ʱ��̬֧��
		staticruntime "On"
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
		buildoptions "/MDd"
		symbols "On"
	-- ������ Release����
	filter "configurations:Release"
		defines "HZ_RELEASE"
		buildoptions "/MD"
		-- �����Ż�
		optimize "On"
	-- ������ Dist����
	filter "configurations:Dist"
		defines "HZ_DIST"
		buildoptions "/MD"
		optimize "On"

	--[[filter {"system:windows", "configurations:Release"}
		-- ����ѡ�� ���ö��߳�
		buildoptions "/MT"
	--]]

-- ��Ŀ Sandbox
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
	-- ����
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
	
		