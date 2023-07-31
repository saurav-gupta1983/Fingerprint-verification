Set oShell = CreateObject("WScript.Shell")
oShell.CurrentDirectory = oShell.ExpandEnvironmentStrings("%ProgramFiles%") & "\Dermalog\ComponentSystem\VideoCapture"
oShell.Run "DPinst.exe"
