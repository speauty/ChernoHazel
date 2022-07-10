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

		virtual void OnAttach() override;
		virtual void OnDetach() override;
		virtual void OnImGuiRender() override;

		void Begin();
		void End();

	private:
		float m_Time = 0.0f;
	};
}