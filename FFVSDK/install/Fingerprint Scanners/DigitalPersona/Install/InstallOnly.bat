msiexec /i Setup.msi /qn FT_1_KEY=54df8c46a66ba14fdd8f0152cce9e65f  FT_2_KEY=d6c49aefd2ff0c3e54bf942a588faa7b REBOOT=ReallySuppress /l*v c:\msi.trace
@pause

; this batch file will perform silent install with default security keys, and it will not reboot