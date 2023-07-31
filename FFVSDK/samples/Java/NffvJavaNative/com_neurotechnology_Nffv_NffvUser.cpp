#include "stdafx.h"
#include <com_neurotechnology_Nffv_NffvUser.h>
#include "NffvJavaNative.h"

/*
 * Class:     com_neurotechnology_Nffv_NffvUser
 * Method:    getID
 * Signature: (J)I
 */
JNIEXPORT jint JNICALL Java_com_neurotechnology_Nffv_NffvUser_getID
(JNIEnv * env, jclass cls, jlong handle){
	NInt id;

	NResult result = NffvUserGetId((HNffvUser) handle, &id);

	if NFailed(result) ThrowJavaException(env,(int)result);

	return (jint) id;
}

/*
 * Class:     com_neurotechnology_Nffv_NffvUser
 * Method:    loadImage
 * Signature: (JLcom/neurotechnology/Nffv/NffvImage;)V
 */
JNIEXPORT void JNICALL Java_com_neurotechnology_Nffv_NffvUser_loadImage
(JNIEnv * env, jclass cls, jlong handle, jobject imageobject){

	NSizeType size;
	NByte * pixels;
	
	NUInt width;
	NUInt height;
	NFloat horzResolution;
	NFloat vertResolution; 
	NSizeType stride = 0;

	NResult result = NffvUserGetImage((HNffvUser) handle, &width, &height, &horzResolution, &vertResolution, &stride, NULL);
	size = height * stride;

	if NFailed(result){
		ThrowJavaException(env,(int)result);
		return;
	}

	pixels = new NByte[size];

	result = NffvUserGetImage((HNffvUser) handle, &width, &height, &horzResolution, &vertResolution, &stride, pixels);

	if NFailed(result){
		ThrowJavaException(env,(int)result);
		delete [] pixels;
		return;
	}

	

	jclass imgcls = env->GetObjectClass(imageobject);

	jmethodID method = env->GetMethodID(imgcls, "setImageData", "([B)V");
	if(method == NULL){
		ThrowJavaException(env,0,"cannot find method setImageData");
		delete [] pixels;
		return;
	}
	jbyteArray barr = env->NewByteArray((jsize)size);
	env->SetByteArrayRegion(barr, 0, (jsize)size, (jbyte *) pixels);
	env->CallVoidMethod(imageobject,method,barr);
	delete [] pixels;
	//env->ReleaseByteArrayElements(barr, (jbyte*) pixels, 0);

	method = env->GetMethodID(imgcls, "setWidth", "(I)V");
	if(method == NULL){
		ThrowJavaException(env,0,"cannot find method setWidth");
		return;
	}
	env->CallVoidMethod(imageobject, method, width);

	method = env->GetMethodID(imgcls, "setHeight", "(I)V");
	if(method == NULL){
		ThrowJavaException(env,0,"cannot find method setHeight");
		return;
	}
	env->CallVoidMethod(imageobject, method, height);


	method = env->GetMethodID(imgcls, "setStride", "(I)V");
	if(method == NULL){
		ThrowJavaException(env,0,"cannot find method setStride");
		return;
	}
	env->CallVoidMethod(imageobject, method, stride);

	method = env->GetMethodID(imgcls, "setHorizontalResolution", "(F)V");
	if(method == NULL){
		ThrowJavaException(env,0,"cannot find method setHorizontalResolution");
		return;
	}
	env->CallVoidMethod(imageobject, method, horzResolution);

	method = env->GetMethodID(imgcls, "setVerticalResolution", "(F)V");
	if(method == NULL){
		ThrowJavaException(env,0,"cannot find method setVerticalResolution");
		return;
	}
	env->CallVoidMethod(imageobject, method, vertResolution);

}