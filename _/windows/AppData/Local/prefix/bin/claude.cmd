@echo off
setlocal enabledelayedexpansion
REM copy all args into args list (simulated via %*)
set "args=%*"

:parse_loop
if "%~1"=="" goto end_parse
if "%~1"=="-p" goto handle_prompt
if "%~1"=="--prompt" goto handle_prompt
shift
goto parse_loop

:handle_prompt
REM adjust based on script name
set "args=%args% --permission-mode=auto"
REM run the command and pipe through glow
bun -b "%USERPROFILE%\.bun\install\global\node_modules\@anthropic-ai\claude-code\cli.js" %args% | glow
exit /b

:end_parse
REM final exec without glow when loop finishes with single arg
bun -b "%USERPROFILE%\.bun\install\global\node_modules\@anthropic-ai\claude-code\cli.js" %args%
