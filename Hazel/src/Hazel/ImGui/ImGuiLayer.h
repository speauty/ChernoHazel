#pragma once

#include "Hazel/Layer.h"

#include <Hazel/Events/MouseEvent.h>
#include <Hazel/Events/KeyEvent.h>
#include <Hazel/Events/ApplicationEvent.h>

namespace Hazel {

	/*
	 * @todo fix ImGui窗口出现重影, 目测窗口或帧之类的没清理干净的，暂时放在这儿，后面再看看
	 * @todo ImGui窗体无法关系，关闭事件未接入？
	 */
	class HAZEL_API ImGuiLayer : public Layer
	{
	public:
		ImGuiLayer();
		~ImGuiLayer();

		virtual void OnAttach() override;
		virtual void OnDetach() override;
		virtual void OnImGuiRender() override;

		void Begin();
		void End();

	private:
		float m_Time = 0.0f;
	};
}