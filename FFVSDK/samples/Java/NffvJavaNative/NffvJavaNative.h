#include "stdafx.h"
#include <jni.h>
#include <Nffv.h>

void ThrowJavaException(JNIEnv* env, int code, const char* msg = "Unexpected error in native code");
void fillInfo(JNIEnv * env, jobject info, NLibraryInfoA libinfo);