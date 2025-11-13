#include <Shlwapi.h>
#include <stdio.h>
#include <windows.h>

#pragma comment(lib, "shlwapi.lib")

#ifndef EXEC_PATH
#define EXEC_PATH L"\"C:\\Program Files\\Git\\usr\\bin\\bash.exe\""
#endif

int main(int argc, const char *argv[]) {
  size_t execPathLen = wcslen(EXEC_PATH);
  LPWSTR lpArgs = PathGetArgsW(GetCommandLineW());
  size_t bufLen = execPathLen + wcslen(lpArgs) + 2;
  LPWSTR lpCommandLine = (LPWSTR)malloc(bufLen * sizeof(WCHAR));
  swprintf_s(lpCommandLine, bufLen, L"%s %s", EXEC_PATH, lpArgs);
#ifdef _DEBUG
  wprintf_s(L"%s\n", lpCommandLine);
#endif

  bufLen = execPathLen - 1 + GetEnvironmentVariableW(L"Path", NULL, 0);
  LPWSTR lpEnvPath = (LPWSTR)malloc(bufLen * sizeof(WCHAR));
  wcscpy_s(lpEnvPath, bufLen, EXEC_PATH + 1);
  PathRemoveFileSpecW(lpEnvPath);
  wcscat_s(lpEnvPath, bufLen, L";");
  GetEnvironmentVariableW(L"Path", lpEnvPath + wcslen(lpEnvPath), bufLen);
  SetEnvironmentVariableW(L"Path", lpEnvPath);

  DWORD dwExitCode = 0;
  PROCESS_INFORMATION pi = {0};
  STARTUPINFO si = {0};
  si.cb = sizeof(STARTUPINFO);
  si.hStdInput = GetStdHandle(STD_INPUT_HANDLE);
  si.hStdOutput = GetStdHandle(STD_OUTPUT_HANDLE);
  si.hStdError = GetStdHandle(STD_ERROR_HANDLE);
  si.dwFlags |= STARTF_USESTDHANDLES;

  if (!CreateProcessW(NULL, lpCommandLine, NULL, NULL, TRUE, 0, NULL, NULL,
                      (LPSTARTUPINFOW)&si, &pi)) {
    fprintf_s(stderr, "create process failed: %lu\n", GetLastError());
    goto clean;
  }

  DWORD dwWaitResult = WaitForSingleObject(pi.hProcess, INFINITE);
  if (dwWaitResult != WAIT_OBJECT_0) {
    fprintf_s(stderr, "wait for process failed: %lu\n", dwWaitResult);
  }

  if (!GetExitCodeProcess(pi.hProcess, &dwExitCode)) {
    fprintf_s(stderr, "get exit code failed: %lu\n", GetLastError());
    dwExitCode = (DWORD)-1;
  }

clean:
  free(lpCommandLine);
  free(lpEnvPath);
  CloseHandle(pi.hProcess);
  CloseHandle(pi.hThread);
  return dwExitCode;
}
