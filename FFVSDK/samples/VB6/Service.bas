Attribute VB_Name = "modService"
Option Explicit

Private Type PicBmp
    size As Long
    Type As Long
    hBmp As Long
    hPal As Long
    Reserved As Long
End Type

Private Type GUID
    Data1 As Long
    Data2 As Integer
    Data3 As Integer
    Data4(7) As Byte
End Type

Public Const IMAGE_BITMAP = 0

Public Const LR_DEFAULTCOLOR = 0
Public Const LR_MONOCHROME = 1
Public Const LR_COLOR = 2
Public Const LR_COPYRETURNORG = &H4
Public Const LR_COPYDELETEORG = &H8
Public Const LR_LOADFROMFILE = &H10
Public Const LR_LOADTRANSPARENT = &H20
Public Const LR_DEFAULTSIZE = &H40
Public Const LR_VGACOLOR = &H80
Public Const LR_LOADMAP3DCOLORS = &H1000
Public Const LR_CREATEDIBSECTION = &H2000
Public Const LR_COPYFROMRESOURCE = &H4000
Public Const LR_SHARED = &H8000

'Public Declare Function LoadImage Lib "user32" Alias "LoadImageA" (ByVal hInst As Long, ByVal lpsz As String, ByVal un1 As Long, ByVal n1 As Long, ByVal n2 As Long, ByVal un2 As Long) As Long
'Public Declare Function GetLastError Lib "kernel32" () As Long

'Public Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (ByRef destination As Any, ByRef source As Any, ByVal length As Long)
'Public Declare Sub CopyMemoryFromPointer Lib "kernel32" Alias "RtlMoveMemory" (ByRef destination As Any, ByVal source As Long, ByVal length As Long)
Private Declare Function OleCreatePictureIndirect Lib "olepro32.dll" (PicDesc As PicBmp, RefIID As GUID, ByVal fPictureOwnsHandle As Long, IPic As IPicture) As Long

Public Function PictureFromHandle(ByVal hBmp As Long) As IPictureDisp
    Dim r As Long
    Dim pic As PicBmp
'    IPicture requires a reference to "Standard OLE Types"
    Dim IPic As IPictureDisp
    Dim IID_IDispatch As GUID
'    Fill in with IDispatch Interface ID
    With IID_IDispatch
        .Data1 = &H7BF80980
        .Data2 = &HBF32
        .Data3 = &H101A
        .Data4(0) = &H8B
        .Data4(1) = &HBB
        .Data4(2) = &H0
        .Data4(3) = &HAA
        .Data4(4) = &H0
        .Data4(5) = &H30
        .Data4(6) = &HC
        .Data4(7) = &HAB
    End With
'    Fill Pic with necessary parts
    With pic
        .size = Len(pic)          ' Length of structure
        .Type = vbPicTypeBitmap   ' Type of Picture (bitmap)
        .hBmp = hBmp              ' Handle to bitmap
    End With
'    Create Picture object
    r = OleCreatePictureIndirect(pic, IID_IDispatch, 1, IPic)
'    Return the new Picture object
    Set PictureFromHandle = IPic
End Function
