  -------------------------------------------------------------------
			   DigitalPersona
	
	Gold Fingerprint Recognition Software version 3.2.0 
			
			    Readme File
			   
			   April 2007
				
   --------------------------------------------------------------------
	   (c) 2007 DigitalPersona, Inc. All Rights Reserved. 


This document provides late-breaking or other information that supplements the DigitalPersona Gold SDK documentation.


-------------------------
How to Use This Document
-------------------------

To view the Readme file on-screen in Windows Notepad, maximize the Notepad window. On the Format menu, click Word Wrap. To print the Readme file, open it in Notepad or another word processor, and then use the Print command on the File menu.


---------
CONTENTS
---------

1.   INSTALLATION

2.   COMPATIBILITY

3.   SYSTEM REQUIREMENTS

4.   RELEASE NOTES
     4.1    dpFTConvertDB.exe Database Conversion Utility
     4.2    Language Support
     4.3    Support for Windows Vista
     4.4    Support for new DigitalPersona keyboard with newer U.are.U reader	
     4.5    New Installer method (Microsoft Install Framework) was used to install device drivers	
     
5.   KNOWN ISSUES      
     

6.   SUPPORT AND FEEDBACK
 

----------------
1. INSTALLATION
----------------
You must have local administrator rights to install this product on the supported Windows based operating systems.

1- Insert the Gold Fingerprint Recognition Software CD in the CD-ROM drive.
2- Run Setup.exe located in the "Fingerprint Recognition SW" folder on the CD.
3- Follow the installation instructions.
4- Restart the computer and log on to your Windows account.
5- Connect the U.are.U Fingerprint Reader.


-----------------
2. COMPATIBILITY
-----------------

DigitalPersona Gold Fingerprint Recognition Software version 3.2.0 is compatible with the following DigitalPersona products:
- DigitalPersona Gold SDK/Fingerprint Recognition Software version 2.2.0 and later
- DigitalPersona Pro for Active Directory version 3.4.0 and 3.5.x
- Online Client version 3.1.0 and later
- DigitalPersona Platinum SDK/Fingerprint Recognition Software version 3.1.X and 3.3.0

DigitalPersona Gold SDK version 3.2.0 is not compatible with:
- DigitalPersona Password Manager 1.0 and 2.0
- DigitalPersona Pro for Active Directory version 4.0.0 and later


DigitalPersona Gold Fingerprint Recognition Software is not certified to be used in conjunction with the following DigitalPersona products:
- U.are.U Pro for AD version 2.1.4 and earlier
- U.are.U Personal 
- U.are.U Pro for NT 
- U.are.U Pro for AD-SA
- U.are.U Platinum SDK/Reader Software 2.0.2 and earlier


-----------------------
3. SYSTEM REQUIREMENTS
-----------------------

- Pentium-class processor
- 32 MB RAM
- USB port
- 14 MB free hard disk space
- Windows Vista (32-bit), Windows 2000 Server, Windows 2003 Server, Windows XP, Windows 2000 Professional, Windows NT4, and Windows 98/Me.


-----------------
4. RELEASE NOTES
-----------------

4.1	dpFTConvertDB.exe Database Conversion Utility
Databases created with DigitalPersona database functions (dpDBase module) are affected by the fact that XTF templates are used by default for template registration, due to the increase in size of the registration templates. The dpFTConvertDB.exe utility can be used to convert such databases to new ones with a specified template size.

4.2	Language Support
Installer Language supports English only.

4.3	Support for Windows Vista
This version now supports the new Windows Vista 32-bit operating system.

4.4	Support for new keyboard with U.are.U reader
This version includes a new WHQL driver that supports the newer U.are.U 4000B reader Rev 101, and the new DigitalPersona Fingerprint Keyboards.

4.5	New Installer method (Microsoft Install Framework) was used to install device drivers. 

----------------
5. KNOWN ISSUES 
----------------

5.1    This product version has not been certified on Windows 98 and NT4.

5.2    Due to new security features introduced in Windows Vista, silent install/uninstall commands have to be issued from a DOS session that had been invoked as an administrator.

5.3    After an upgrade install to Gold 3.2 from Gold 2.2.x, the U.are.U 2000 and 4000 readers may not work immediately. The user has to manually update the device driver through Windows Device Manager. Reboot the machine if necessary. 


------------------------
6. SUPPORT AND FEEDBACK
------------------------

If you have suggestions for future product releases or require technical support for your product, e-mail to techsupport@digitalpersona.com. In the subject line, type "Gold SDK support."

The DigitalPersona Web site, at http://www.digitalpersona.com, provides support for registered users as well.











