#include "hzpch.h"

#include "Application.h"

#include "Hazel/Events/ApplicationEvent.h"
#include "Hazel/Log.h"

namespace Hazel
{

	Hazel::Application::Application()
	{
	}

	Hazel::Application::~Application()
	{
	}

	void Hazel::Application::Run()
	{
		WindowResizeEvent e(1280, 720);
		if (e.IsInCategory(EventCategoryApplication)) {
			HZ_TRACE(e);
		}
		if (e.IsInCategory(EventCategoryInput)) {
			HZ_TRACE(e);
		}
		while (true);
	}
}
