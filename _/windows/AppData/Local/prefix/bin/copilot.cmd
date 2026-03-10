@echo off
REM get the script name without path
for %%I in ("%~nx0") do set "name=%%~I"
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
if /I "%name%"=="cbc" goto cbc_prompt
if /I "%name%"=="codebuddy" goto cbc_prompt
set "args=%args% --yolo"
goto after_prompt

:cbc_prompt
set "args=%args% -y"

:after_prompt
REM run the command and pipe through glow
"%USERPROFILE%\.bun\bin\%name%" %args% | glow
exit /b

:end_parse
REM final exec without glow when loop finishes with single arg
"%USERPROFILE%\.bun\bin\%name%" %args%
