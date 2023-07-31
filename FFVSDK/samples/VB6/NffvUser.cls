VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "NffvUser"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Private Declare Function NffvUserGetHBitmap Lib "Nffv.dll" (ByVal hUser As Long, ByRef hBitmap As Long) As Long
Private Declare Function NffvUserGetId Lib "Nffv.dll" (ByVal hUser As Long, ByRef pValue As Long) As Long

Public Event ErrorOccured(msg As String, ByVal errorCode As Long)

Private hEngineUser As Long

Public Sub Init(hNewEngineUser As Long)
    hEngineUser = hNewEngineUser
End Sub

Friend Function GetImage() As IPictureDisp
    Dim ret As Long
    Dim hBitmap As Long
    ret = NffvUserGetHBitmap(hEngineUser, hBitmap)
    CheckError "NffvUserGetHBitmap", ret
    Set GetImage = PictureFromHandle(hBitmap)
End Function

Friend Function GetHBitmap() As Long
    Dim ret As Long
    Dim hBitmap As Long
    ret = NffvUserGetHBitmap(hEngineUser, hBitmap)
    CheckError "NffvUserGetHBitmap", ret
    GetHBitmap = hBitmap
End Function

Friend Function GetUserId() As Long
    Dim ret As Long
    Dim pValue As Long
    ret = NffvUserGetId(hEngineUser, pValue)
    CheckError "NffvUserGetId", ret
    GetUserId = pValue
End Function

Friend Function GetHandle() As Long
    GetHandle = hEngineUser
End Function

Private Sub CheckError(FunctionName As String, errorCode As Long)
    If errorCode < 0 Then
        Err.Raise errorCode, FunctionName, modNffv.ErrorMessage(FunctionName, errorCode)
    End If
End Sub
