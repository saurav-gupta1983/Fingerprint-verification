Attribute VB_Name = "modNffv"
Private Declare Function NffvGetErrorMessageA Lib "Nffv.dll" (ByVal errorCode As Long, ByVal pMsg As String) As Long
Private Declare Function NffvGetInfoA Lib "Nffv.dll" (ByRef libraryInfo As NLibraryInfo) As Long
Private Declare Function NffvGetAvailableScannerModulesA Lib "Nffv.dll" (ByVal ppStr As Long) As Long
Private Declare Sub NffvFreeMemory Lib "Nffv.dll" (ByVal ptr As Long)
Private Declare Function lstrcpynA Lib "kernel32.dll" (ByVal pDstStr As Long, ByVal pStrStr As Long, ByVal numChars As Long) As Long

Public Type NLibraryInfo
    Title As String * 64
    Product As String * 64
    Company As String * 64
    Copyright As String * 64
    VersionMajor As Long
    VersionMinor As Long
    VersionBuild As Long
    VersionRevision As Long
    DistributorId As Long
    SerialNumber As Long
End Type

Public Enum NffvStatus
    nfesNone = 0
    nfesTemplateCreated = 1
    nfesNoScanner = 2
    nfesScannerTimeout = 3
    nfesQualityCheckFailed = 100
End Enum

Public Function NErrorGetDefaultMessage(ByVal errorCode) As String
    NErrorGetDefaultMessage = ""
    
    Dim ret As Long
    ret = NffvGetErrorMessageA(errorCode, 0)
    If ret > 0 Then
        Dim errStr As String
        errStr = Space$(ret)
        ret = NffvGetErrorMessageA(errorCode, errStr)
        If ret >= 0 Then
            NErrorGetDefaultMessage = errStr
        End If
    End If
End Function

Public Function ErrorMessage(FunctionName As String, errorCode As Long) As String
    ErrorMessage = FunctionName & ": " & NErrorGetDefaultMessage(errorCode)
End Function

Public Function Nffv_GetInfo() As NLibraryInfo
    Dim libraryInfo As NLibraryInfo
    NffvGetInfoA libraryInfo
    Nffv_GetInfo = libraryInfo
End Function

Public Function Nffv_GetAvailableScannerModules() As String
    Dim pModules As Long
    Dim modulesLength As Long
    modulesLength = NffvGetAvailableScannerModulesA(VarPtr(pModules))
    If modulesLength > 0 Then
        ReDim pStrBytes(modulesLength) As Byte
        lstrcpynA VarPtr(pStrBytes(0)), pModules, modulesLength + 1
        ReDim Preserve pStrBytes(modulesLength - 1) As Byte
        Nffv_GetAvailableScannerModules = StrConv(pStrBytes, vbUnicode)
    Else
        Nffv_GetAvailableScannerModules = ""
    End If
    NffvFreeMemory pModules
End Function

Public Function Nffv_GetStatusDescription(ByVal status As NffvStatus) As String
    Dim desc As String
    desc = "Unknown"
    Select Case status
    Case nfesNone
        desc = "None"
    Case nfesTemplateCreated
        desc = "Template created"
    Case nfesNoScanner
        desc = "No scanner"
    Case nfesScannerTimeout
        desc = "Scanner timeout"
    Case nfesQualityCheckFailed
        desc = "Quality check failed"
    End Select
    Nffv_GetStatusDescription = desc
End Function

Function Log10(number As Double) As Double
    Log10 = Log(number) / 2.30258509299405
End Function

Function Ceiling(number As Double) As Long
    Ceiling = -Int(-number)
End Function

Public Function MatchingThresholdToString(ByVal value As Long) As String
    Dim p As Double
    Dim decimalDigits As Integer
    
    p = -value / 12
    decimalDigits = CInt(Ceiling(-p)) - 2
    If decimalDigits < 0 Then decimalDigits = 0
    
    MatchingThresholdToString = FormatPercent(10 ^ p, decimalDigits)
End Function

Public Function MatchingThresholdFromString(ByVal value As String) As Long
    Dim p As Double
    Dim result As Long
    
    value = Replace(value, "%", "")
    p = CDbl(value) / 100#
    If p > 1 Then p = 1
    If p < 0.000000000001 Then p = 0.000000000001
    p = Log10(p)
    
    result = CInt(Round(-12 * p))
    If result < 0 Then result = 0
    MatchingThresholdFromString = result
End Function
