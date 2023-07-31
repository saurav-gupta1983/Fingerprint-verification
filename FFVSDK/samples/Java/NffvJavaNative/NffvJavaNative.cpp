// NffvJavaNative.cpp : Defines the entry point for the DLL application.
//

#include "stdafx.h"
#include "NffvJavaNative.h"


#ifdef _MANAGED
#pragma managed(push, off)
#endif


void ThrowJavaException(JNIEnv* env,  int code, const char* msg)
{

	switch(code){
		case -1: msg = "Unspecified error has occurred."; break;
		case -2: msg = "Standard error has occurred (for internal use)."; break;
		case -3: msg = "Null reference has occurred (for internal use)."; break;
		case -4: msg = "There were not enough memory."; break;
		case -5: msg = "Functionality is not implemented."; break;
		case -6: msg = "Functionality is not supported."; break;
		case -7: msg = "Attempted to perform invalid operation."; break;
		case -8: msg = "Arithmetic overflow has occurred."; break;
		case -9: msg = "Index is out of range (for internal use)."; break;
		case -10: msg = "Argument is invalid."; break;
		case -11: msg = "Argument value is #NULL where non-NULL value was expected."; break;
		case -12: msg = "Argument value is out of range."; break;
		case -13: msg = "Format of argument value is invalid."; break;
		case -14: msg = "Input/output error has occurred."; break;
		case -15: msg = "Attempted to read file or buffer after its end."; break;
		case -90: msg = "Error in external code"; break;
		case -91: msg = "Win32 error has occured"; break;
		case -92: msg = "COM error has occured"; break;
		case -93: msg = "CLR exeption has occured"; break;
		case -100: msg = "Parameter ID is invalid."; break;
		case -101: msg = "Attempted to set read only parameter."; break;
		case -200: msg = "Module is not registered."; break;
	}

    jthrowable exc = env->ExceptionOccurred();
    if (exc == NULL) 
    {
        jclass newExcCls = env->FindClass("java/lang/Exception");
        if (newExcCls != NULL) 
        {
            if (msg == NULL)
                env->ThrowNew(newExcCls, "");
            else
                env->ThrowNew(newExcCls, msg);

            env->DeleteLocalRef(newExcCls);           
        }
    }
}

void fillInfo(JNIEnv * env, jobject info, NLibraryInfoA libinfo){

	jclass infoclass = env->GetObjectClass(info);
	if (infoclass == NULL)
	{
         ThrowJavaException(env,0,"No LibraryInfo object found");
		 return;
	}

    jmethodID method = env->GetMethodID(infoclass, "setCompany", "(Ljava/lang/String;)V");
	if (method == NULL){
		ThrowJavaException(env,0,"No setCompany method found in LibraryInfo object");
		return;
	}
	else{
		jstring company = env->NewStringUTF(libinfo.Company);
		env->CallObjectMethod(info,method,company);
	}

	method = env->GetMethodID(infoclass, "setCopyright", "(Ljava/lang/String;)V");
	if (method == NULL){
		ThrowJavaException(env,0,"No setCopyright method found in LibraryInfo object");
		return;
	}
	else {
		jstring copyright = env->NewStringUTF(libinfo.Copyright);
		env->CallObjectMethod(info,method,copyright);
	}

	method = env->GetMethodID(infoclass, "setProduct", "(Ljava/lang/String;)V");
	if (method == NULL){
		ThrowJavaException(env,0,"No setProduct method found in LibraryInfo object");
		return;
	}
	else{
		jstring product = env->NewStringUTF(libinfo.Product);
		env->CallObjectMethod(info,method,product);
	}

	method = env->GetMethodID(infoclass, "setTitle", "(Ljava/lang/String;)V");
	if (method == NULL){
		ThrowJavaException(env,0,"No setTitle method found in LibraryInfo object");
		return;
	}
	else {
		jstring title = env->NewStringUTF(libinfo.Title);
		env->CallObjectMethod(info,method,title);
	}

	method = env->GetMethodID(infoclass, "setVersionBuild", "(I)V");
	if (method == NULL){
		ThrowJavaException(env,0,"No setVersionBuild method found in LibraryInfo object");
		return;
	}
	else env->CallObjectMethod(info,method,libinfo.VersionBuild);

	method = env->GetMethodID(infoclass, "setVersionMajor", "(I)V");
	if (method == NULL){
		ThrowJavaException(env,0,"No setVersionMajor method found in LibraryInfo object");
		return;
	}
	else env->CallObjectMethod(info,method,libinfo.VersionMajor);

	method = env->GetMethodID(infoclass, "setVersionMinor", "(I)V");
	if (method == NULL){
		ThrowJavaException(env,0,"No setVersionMinor method found in LibraryInfo object");
		return;
	}
	else env->CallObjectMethod(info,method,libinfo.VersionMinor);

	method = env->GetMethodID(infoclass, "setVersionRevision", "(I)V");
	if (method == NULL){
		ThrowJavaException(env,0,"No setVersionRevision method found in LibraryInfo object");
		return;
	}
	else env->CallObjectMethod(info,method,libinfo.VersionRevision);
}


BOOL APIENTRY DllMain( HMODULE hModule,
                       DWORD  ul_reason_for_call,
                       LPVOID lpReserved
					 )
{
    return TRUE;
}

#ifdef _MANAGED
#pragma managed(pop)
#endif

