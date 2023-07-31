#include "stdafx.h"
#include <com_neurotechnology_Nffv_Nffv.h>
#include "NffvJavaNative.h"

/*
 * Class:     com_neurotechnology_Nffv_Nffv
 * Method:    getAvailableScannerModules0
 * Signature: ()Ljava/lang/String;
 */
JNIEXPORT jstring JNICALL Java_com_neurotechnology_Nffv_Nffv_getAvailableScannerModules0
(JNIEnv * env, jclass cls){
	NAChar * scanners;
	NResult result = NffvGetAvailableScannerModulesA(&scanners);
	if(NFailed(result)){
		ThrowJavaException(env, result);
		return NULL;
	}
	jstring jscanners = env->NewStringUTF((char *) scanners);
	NffvFreeMemory(scanners);

	return jscanners;
}


/*
 * Class:     com_neurotechnology_Nffv_Nffv
 * Method:    create
 * Signature: (Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)J
 */
JNIEXPORT void JNICALL Java_com_neurotechnology_Nffv_Nffv_create0
(JNIEnv * env, jclass cls, jstring database, jstring pass, jstring scaners){

	const char * cdatabase = env->GetStringUTFChars(database, NULL);
	const char * cscaners = env->GetStringUTFChars(scaners, NULL);
	const char * cpass = env->GetStringUTFChars(pass, NULL);

	NResult result = NffvInitializeA((char *)cdatabase , (char *)cpass, (char *)cscaners);

	env->ReleaseStringUTFChars(database, cdatabase);
	env->ReleaseStringUTFChars(scaners, cscaners);
	env->ReleaseStringUTFChars(pass, cpass);

	if NFailed(result) ThrowJavaException(env,(int)result);
}

/*
 * Class:     com_neurotechnology_Nffv_Nffv
 * Method:    getUsers
 * Signature: (J)[J
 */
JNIEXPORT jlongArray JNICALL Java_com_neurotechnology_Nffv_Nffv_getUsers0
(JNIEnv * env, jclass cls){

	NInt count;

	NResult result = NffvGetUserCount(&count);

	if NFailed(result) {
		ThrowJavaException(env,(int)result);
		return NULL;
	}

	jlong * cusers = new jlong[count];

	for (int i = 0; i < count; i++){
		HNffvUser user;
		result = NffvGetUser(i, &user);
		if NFailed(result) {
			ThrowJavaException(env,(int)result);
			delete [] cusers;
			return NULL;
		}
		cusers[i] = (jlong) user;
	}

	jlongArray users = env->NewLongArray(count);
	env->SetLongArrayRegion(users, 0, count, cusers);

	delete [] cusers;

	return users;
}

/*
 * Class:     com_neurotechnology_Nffv_Nffv
 * Method:    getUserByID
 * Signature: (JI)J
 */
JNIEXPORT jlong JNICALL Java_com_neurotechnology_Nffv_Nffv_getUserByID0
(JNIEnv * env, jclass cls, jint id){

	HNffvUser user;

	NResult result = NffvGetUserById(id, &user);

	if NFailed(result) ThrowJavaException(env,(int)result);

	return (jlong)user;
}

/*
 * Class:     com_neurotechnology_Nffv_Nffv
 * Method:    removeUser
 * Signature: (JJ)V
 */
JNIEXPORT void JNICALL Java_com_neurotechnology_Nffv_Nffv_removeUser0
(JNIEnv * env, jclass cls, jlong userhandle){
	
	NInt id;

	NResult result = NffvUserGetId((HNffvUser) userhandle, &id);

	if NFailed(result){
		ThrowJavaException(env,(int)result);
		return;
	}

	NInt index;

	result = NffvGetUserIndexById(id, &index);

	if NFailed(result){
		ThrowJavaException(env,(int)result);
		return;
	}

	result = NffvRemoveUser(index);

	if NFailed(result) ThrowJavaException(env,(int)result);
}

/*
 * Class:     com_neurotechnology_Nffv_Nffv
 * Method:    removeUserID
 * Signature: (JI)V
 */
JNIEXPORT void JNICALL Java_com_neurotechnology_Nffv_Nffv_removeUserID0
(JNIEnv *env, jclass cls, jint id){

	NInt index;

	NResult result = NffvGetUserIndexById((NInt) id, &index);

	if NFailed(result) {
		ThrowJavaException(env,(int)result);
		return;
	}

	result = NffvRemoveUser(index);

	if NFailed(result) ThrowJavaException(env,(int)result);
}

/*
 * Class:     com_neurotechnology_Nffv_Nffv
 * Method:    removeUsers
 * Signature: (J)V
 */
JNIEXPORT void JNICALL Java_com_neurotechnology_Nffv_Nffv_removeUsers0
(JNIEnv * env, jclass cls){

	NResult result = NffvClearUsers();
	
	if NFailed(result) ThrowJavaException(env,(int)result);
}

/*
 * Class:     com_neurotechnology_Nffv_Nffv
 * Method:    verify
 * Signature: (JJILcom/neurotechnology/Nffv/Nffv;)I
 */
JNIEXPORT jint JNICALL Java_com_neurotechnology_Nffv_Nffv_verify0
(JNIEnv * env, jclass cls, jlong userhandle, jint timeout, jobject engine){

	NffvStatus status;
	NInt score;

	NResult result = NffvVerify((HNffvUser) userhandle, timeout, &status, &score);

	if NFailed(result) {
		ThrowJavaException(env,(int)result);
		return 0;
	}

	jclass engineclass = env->GetObjectClass(engine);
	jmethodID method = env->GetMethodID(engineclass,"setIntEngineStatus","(I)V");

	env->CallVoidMethod(engine, method, (jint)status);

	return score;
}

/*
 * Class:     com_neurotechnology_Nffv_Nffv
 * Method:    enroll
 * Signature: (JILcom/neurotechnology/Nffv/Nffv;)J
 */
JNIEXPORT jlong JNICALL Java_com_neurotechnology_Nffv_Nffv_enroll0
(JNIEnv * env, jclass cls, jint timeout, jobject engine){

	NffvStatus status;
	HNffvUser userhandle;

	NResult result = NffvEnroll(timeout, &status, &userhandle);

	if NFailed(result) {
		ThrowJavaException(env,(int)result);
		return 0;
	}
	
	jclass engineclass = env->GetObjectClass(engine);
	jmethodID method = env->GetMethodID(engineclass,"setIntEngineStatus","(I)V");

	env->CallVoidMethod(engine, method, (jint)status);

	return (jlong) userhandle;
}

/*
 * Class:     com_neurotechnology_Nffv_Nffv
 * Method:    getQualityThreshold
 * Signature: (J)I
 */
JNIEXPORT jint JNICALL Java_com_neurotechnology_Nffv_Nffv_getQualityThreshold0
(JNIEnv * env, jclass cls){
	NByte value;
	NResult result = NffvGetQualityThreshold(&value);
	if NFailed(result) 
		ThrowJavaException(env,(int)result);

	return (jint)value;
}

/*
 * Class:     com_neurotechnology_Nffv_Nffv
 * Method:    setQualityThreshold
 * Signature: (JI)V
 */
JNIEXPORT void JNICALL Java_com_neurotechnology_Nffv_Nffv_setQualityThreshold0
(JNIEnv * env, jclass cls, jint value){

	NResult result = NffvSetQualityThreshold((NByte) value);
	if NFailed(result) 
		ThrowJavaException(env,(int)result);
}

/*
 * Class:     com_neurotechnology_Nffv_Nffv
 * Method:    getMatchingThreshold
 * Signature: (J)I
 */
JNIEXPORT jint JNICALL Java_com_neurotechnology_Nffv_Nffv_getMatchingThreshold0
(JNIEnv * env, jclass cls){

	NInt value;

	NResult result = NffvGetMatchingThreshold(&value);
	if NFailed(result) 
		ThrowJavaException(env,(int)result);
	return (jint) value;
}

/*
 * Class:     com_neurotechnology_Nffv_Nffv
 * Method:    setMatchingThreshold
 * Signature: (JI)V
 */
JNIEXPORT void JNICALL Java_com_neurotechnology_Nffv_Nffv_setMatchingThreshold0
(JNIEnv * env, jclass cls, jint value){
	NResult result = NffvSetMatchingThreshold((NInt) value);
	if NFailed(result) 
		ThrowJavaException(env,(int)result);
}

/*
 * Class:     com_neurotechnology_Nffv_Nffv
 * Method:    getMaxUserCount
 * Signature: ()I
 */
JNIEXPORT jint JNICALL Java_com_neurotechnology_Nffv_Nffv_getMaxUserCount0
(JNIEnv * env, jclass cls){
	return (jint)NFFV_MAX_USER_COUNT;
}

/*
 * Class:     com_neurotechnology_Nffv_Nffv
 * Method:    free0
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_com_neurotechnology_Nffv_Nffv_free0
(JNIEnv * env, jclass cls){
	NffvUninitialize();
}