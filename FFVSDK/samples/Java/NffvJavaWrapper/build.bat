@mkdir include
@mkdir bin
javac @options @..\specific\Nffv\NffvClasses
copy ..\specific\Nffv\LibraryInfo.txt bin\com\neurotechnology\Library\
copy ..\specific\Nffv\MainLibWindows.xml bin\com\neurotechnology\Library\
copy ..\specific\Nffv\fpsmmLibWindows.xml bin\com\neurotechnology\Library\
jar -cvf ..\..\..\bin\Win32_x86\Nffv.jar -C bin com
keytool -genkey -dname "cn=Neurotechnology, ou=JavaSoft, o=Neurotechnology, c=LT" -alias java -keypass key123 -keystore appkey -storepass key123 -validity 360 
jarsigner -keystore appkey -storepass key123 -keypass key123 -verbose ..\..\..\bin\win32_x86\Nffv.jar java
javah -classpath ..\..\..\bin\Win32_x86\Nffv.jar -d include\ com.neurotechnology.Library.NativeManager
javah -classpath ..\..\..\bin\Win32_x86\Nffv.jar -d include\ com.neurotechnology.Nffv.Nffv
javah -classpath ..\..\..\bin\Win32_x86\Nffv.jar -d include\ com.neurotechnology.Nffv.NffvUser
