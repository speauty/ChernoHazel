-- �����ռ�����
workspace "Hazel"
	-- �ܹ�
	architecture "x64"
	-- ����
	configurations {"Debug", "Release", "Dist"}

-- �Զ������ ���Ŀ¼
outputdirs = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

-- ��Ŀ Hazel
project "Hazel"
	-- λ��
	location "Hazel"
	-- ��Ŀ����
	kind "SharedLib"
	-- ����
	language "C++"
	-- Ŀ��Ŀ¼
	targetdir ("bin/" .. outputdirs .. "/%{prj.name}")
	-- �м�Ŀ¼(.o)
	objdir ("bin-int/" .. outputdirs .. "/%{prj.name}")
	-- �����ļ� ** �ݹ��������
	files {"%{prj.name}/src/**.h", "%{prj.name}/src/**.cpp"}
	-- ����·��
	includedirs {
		-- Hazel����Ŀ¼, �������Ŀ¼, ����ʹ��
		"%{prj.name}/src",
		-- ��־�� spdlog
		"%{prj.name}/vendor/spdlog/include"
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
			"HZ_BUILD_DLL", "HZ_PLATFORM_WINDOWS", "_WINDLL"
		}
		-- �������ò���ָ�
		postbuildcommands {
			-- �״����� ������Ҳ�����Ӧ�ļ� �Ӷ������쳣 �ٴ����м���
			("{COPY} %{cfg.buildtarget.relpath} ../bin/" .. outputdirs .. "/Sandbox")
		}
	-- ������ Debug���� ��������Debug
	filter "configurations:Debug"
		defines "HZ_DEBUG"
		symbols "On"
	-- ������ Release����
	filter "configurations:Release"
		defines "HZ_RELEASE"
		-- �����Ż�
		optimize "On"
	-- ������ Dist����
	filter "configurations:Dist"
		defines "HZ_DIST"
		optimize "On"

	--[[filter {"system:windows", "configurations:Release"}
		-- ����ѡ�� ���ö��߳�
		buildoptions "/MT"
	--]]

-- ��Ŀ Sandbox
project "Sandbox"
	location "Sandbox"
	kind "ConsoleApp"
	targetdir ("bin/" .. outputdirs .. "/%{prj.name}")
	objdir ("bin-int/" .. outputdirs .. "/%{prj.name}")
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
		symbols "On"
	filter "configurations:Release"
		defines "HZ_RELEASE"
		optimize "On"
	filter "configurations:Dist"
		defines "HZ_DIST"
		optimize "On"
	
		