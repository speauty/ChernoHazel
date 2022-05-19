
#include <Hazel.h>

class Sandbox:public Hazel::Application
{
public:
	Sandbox()
	{
	}

	~Sandbox()
	{
	
	}

private:

};

Hazel::Application* Hazel::CreateApplication()
{
	return new Sandbox();
}