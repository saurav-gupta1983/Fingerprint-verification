@mkdir bin
javac -d bin -source 1.5 -target 1.5 -cp ../../../bin/Win32_x86/Nffv.jar src\NffvSample\*.java
jar -cmvf src\manifest.txt ..\..\..\bin\Win32_x86\NffvSample.jar -C bin NffvSample img/logo.png 
jarsigner -keystore ..\NffvJavaWrapper\appkey -storepass key123 -keypass key123 -verbose ..\..\..\bin\win32_x86\NffvSample.jar java
copy NffvSample.html ..\..\..\bin\win32_x86\
