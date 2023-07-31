#include <stdafx.h>
#include <com_neurotechnology_Library_NativeManager.h>

/*
 * Class:     com_neurotechnology_Library_NativeManager
 * Method:    getProductNameN
 * Signature: ()Ljava/lang/String;
 */
JNIEXPORT jstring JNICALL Java_com_neurotechnology_Library_NativeManager_getProductNameN
(JNIEnv * env, jclass cls){
	return env->NewStringUTF("Nffv");
}

/*
 * Class:     com_neurotechnology_Library_NativeManager
 * Method:    getVersionMajorN
 * Signature: ()I
 */
JNIEXPORT jint JNICALL Java_com_neurotechnology_Library_NativeManager_getVersionMajorN
(JNIEnv * env, jclass cls){
	return 1;
}

/*
 * Class:     com_neurotechnology_Library_NativeManager
 * Method:    getVersionMinorN
 * Signature: ()I
 */
JNIEXPORT jint JNICALL Java_com_neurotechnology_Library_NativeManager_getVersionMinorN
(JNIEnv * env, jclass cls){
	return 3;
}