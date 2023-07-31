VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Nffv"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private Declare Function NffvInitializeA Lib "Nffv.dll" (ByVal szDbName As String, ByVal szPassword As String, ByVal szScannerModules As String) As Long
Private Declare Function NffvInitializeNoScannersA Lib "Nffv.dll" Alias "NffvInitializeA" (ByVal szDbName As String, ByVal szPassword As String, ByVal szNullString As Long) As Long
Private Declare Sub NffvUninitialize Lib "Nffv.dll" ()

Private Declare Function NffvGetUserCount Lib "Nffv.dll" (ByVal pValue As Long) As Long
Private Declare Function NffvGetUser Lib "Nffv.dll" (ByVal index As Long, ByVal pValue As Long) As Long
Private Declare Function NffvRemoveUser Lib "Nffv.dll" (ByVal index As Long) As Long
Private Declare Function NffvClearUsers Lib "Nffv.dll" () As Long

Private Declare Function NffvEnroll Lib "Nffv.dll" (ByVal timeout As Long, ByVal pStatus As Long, ByVal pHUser As Long) As Long
Private Declare Function NffvVerify Lib "Nffv.dll" (ByVal hUser As Long, ByVal timeout As Long, ByVal pStatus As Long, ByVal pScore As Long) As Long

Private Declare Function NffvGetQualityThreshold Lib "Nffv.dll" (ByRef pValue As Byte) As Long
Private Declare Function NffvSetQualityThreshold Lib "Nffv.dll" (ByVal value As Byte) As Long
Private Declare Function NffvGetMatchingThreshold Lib "Nffv.dll" (ByRef pValue As Long) As Long
Private Declare Function NffvSetMatchingThreshold Lib "Nffv.dll" (ByVal value As Long) As Long

Public Event ErrorOccured(ByVal msg As String, ByVal errorCode As Long)

Private Sub Class_Terminate()
        NffvUninitialize
End Sub

Public Sub Init(ByVal DatabaseName As String, ByVal Password As String, ByVal ScannerModules As String)
        Dim ret As Long
        If ScannerModules = "" Then
                ' if no scanners should be loaded, empty null terminated string needs to be passed
                ' if null is passed, then all scanners are loaded
                Dim nullTerminatedString As Long
                nullTerminatedString = 0
                ret = NffvInitializeNoScannersA(DatabaseName, Password, VarPtr(nullTerminatedString))
        Else
                ret = NffvInitializeA(DatabaseName, Password, ScannerModules)
        End If
        CheckError "NffvInitializeA", ret
End Sub

Public Function GetUserCount() As Long
    Dim ret As Long
    Dim userCount As Long
    ret = NffvGetUserCount(VarPtr(userCount))
    CheckError "NffvGetUserCount", ret
    GetUserCount = userCount
End Function

Public Function GetUser(ByVal index As Long) As NffvUser
    Dim ret As Long
    Dim hEngineUser As Long
    
    ret = NffvGetUser(index, VarPtr(hEngineUser))
    CheckError "NffvGetUser", ret
    
    Dim engineUser As New NffvUser
    engineUser.Init hEngineUser
    Set GetUser = engineUser
End Function

Public Sub RemoveUser(ByVal index As Long)
    Dim ret As Long
    
    ret = NffvRemoveUser(index)
    CheckError "NffvRemoveUser", ret
End Sub

Public Sub ClearUsers()
    Dim ret As Long
    
    ret = NffvClearUsers
    CheckError "NffvClearUsers", ret
End Sub

Public Function Enroll(ByVal timeout As Long, ByRef engineUser As NffvUser) As NffvStatus
    Dim ret As Long
    Dim hEngineUser As Long
    Dim status As NffvStatus
    
    ret = NffvEnroll(timeout, VarPtr(status), VarPtr(hEngineUser))
    CheckError "NffvEnroll", ret
    
    Enroll = status
    If status = nfesTemplateCreated Then
        Dim newEngineUser As New NffvUser
        newEngineUser.Init hEngineUser
        Set engineUser = newEngineUser
    End If
End Function

Public Function Verify(ByRef engineUser As NffvUser, ByVal timeout As Long, ByRef score As Long) As NffvStatus
    Dim ret As Long
    Dim hEngineUser As Long
    Dim status As NffvStatus
    ret = NffvVerify(engineUser.GetHandle(), timeout, VarPtr(status), VarPtr(score))
    CheckError "NffvVerify", ret
    Verify = status
End Function

Public Function GetQualityThreshold() As Byte
    Dim ret As Long
    Dim qualityThreshold As Byte
    ret = NffvGetQualityThreshold(qualityThreshold)
    CheckError "NffvGetQualityThreshold", ret
    GetQualityThreshold = qualityThreshold
End Function

Public Sub SetQualityThreshold(ByVal qualityThreshold As Byte)
    Dim ret As Long
    ret = NffvSetQualityThreshold(qualityThreshold)
    CheckError "NffvSetQualityThreshold", ret
End Sub

Public Function GetMatchingThreshold() As Long
    Dim ret As Long
    Dim matchingThreshold As Long
    ret = NffvGetMatchingThreshold(matchingThreshold)
    CheckError "NffvGetQualityThreshold", ret
    GetMatchingThreshold = matchingThreshold
End Function

Public Sub SetMatchingThreshold(ByVal matchingThreshold As Long)
    Dim ret As Long
    ret = NffvSetMatchingThreshold(matchingThreshold)
    CheckError "NffvSetMatchingThreshold", ret
End Sub

Public Sub CheckError(FunctionName As String, errorCode As Long)
    If errorCode < 0 Then
        Err.Raise errorCode, FunctionName, modNffv.ErrorMessage(FunctionName, errorCode)
    End If
End Sub
