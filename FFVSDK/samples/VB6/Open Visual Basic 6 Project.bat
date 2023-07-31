@echo off
set projectDir=%CD%
cd ..\..\bin\win32_x86
start "VB6 Project Starter" "%projectDir%\VB6Sample.vbp"