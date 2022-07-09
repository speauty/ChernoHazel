#pragma once

#include "Hazel/Layer.h"

#include <Hazel/Events/MouseEvent.h>
#include <Hazel/Events/KeyEvent.h>
#include <Hazel/Events/ApplicationEvent.h>

namespace Hazel {

	/*
	 * @todo fix ImGui���ڳ�����Ӱ, Ŀ�ⴰ�ڻ�֮֡���û����ɾ��ģ���ʱ��������������ٿ���
	 * @todo ImGui�����޷���ϵ���ر��¼�δ���룿
	 */
	class HAZEL_API ImGuiLayer : public Layer
	{
	public:
		ImGuiLayer();
		~ImGuiLayer();

		void OnAttach();
		void OnDetach();
		void OnUpdate();
		void OnEvent(Event& event);
	private:
		bool OnMouseButtonPressedEvent(MouseButtonPressedEvent& e);
		bool OnMouseButtonReleasedEvent(MouseButtonReleasedEvent& e);
		bool OnMouseMovedEvent(MouseMovedEvent& e);
		bool OnMouseScrolledEvent(MouseScrolledEvent& e);

		bool OnKeyPressedEvent(KeyPressedEvent& e);
		bool OnKeyReleasedEvent(KeyReleasedEvent& e);
		bool OnKeyTypedEvent(KeyTypedEvent& e);

		bool OnWindowResizedEvent(WindowResizeEvent& e);

	private:
		float m_Time = 0.0f;
	};
}