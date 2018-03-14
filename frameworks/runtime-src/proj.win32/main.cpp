#include "main.h"
#include "SimulatorWin.h"
#include <shellapi.h>

// int WINAPI _tWinMain(HINSTANCE hInstance,
// 	HINSTANCE hPrevInstance,
// 	LPTSTR    lpCmdLine,
// 	int       nCmdShow)
// {
// 	UNREFERENCED_PARAMETER(hPrevInstance);
// 	UNREFERENCED_PARAMETER(lpCmdLine);
//     auto simulator = SimulatorWin::getInstance();
//     return simulator->run();
// }

// uncomment below line, open debug console
#define USE_WIN32_CONSOLE

int WINAPI _tWinMain(HINSTANCE hInstance,
	HINSTANCE hPrevInstance,
	LPTSTR    lpCmdLine,
	int       nCmdShow)
{
	UNREFERENCED_PARAMETER(hPrevInstance);
	UNREFERENCED_PARAMETER(lpCmdLine);

#ifdef USE_WIN32_CONSOLE
	AllocConsole();
	freopen("CONIN$", "r", stdin);
	freopen("CONOUT$", "w", stdout);
	freopen("CONOUT$", "w", stderr);
#endif

	// create the application instance
	// AppDelegate app;

	int ret = SimulatorWin::getInstance()->run();

#ifdef USE_WIN32_CONSOLE
	FreeConsole();
#endif
}