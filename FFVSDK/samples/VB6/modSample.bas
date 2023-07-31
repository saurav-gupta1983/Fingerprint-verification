Attribute VB_Name = "modSample"
Public engine As Nffv
Public userDatabase As String

Public Sub Main()
    On Error GoTo ErrorHandler
    
    Dim frmChooseScanner As New ChooseScannerForm
    frmChooseScanner.Show vbModal
    If Not frmChooseScanner.IsDialogOK Then
        Exit Sub
    End If
    Dim FingerprintDB As String
    Dim Password As String
    Dim ScannerModules As String
    FingerprintDB = frmChooseScanner.GetFingerprintDB
    Password = frmChooseScanner.GetPassword
    ScannerModules = frmChooseScanner.GetScanners
    userDatabase = frmChooseScanner.GetUserDB
    Unload frmChooseScanner
    
    On Error GoTo InitErrorHandler
    Set engine = New Nffv
    engine.Init FingerprintDB, Password, ScannerModules
    
    On Error GoTo ErrorHandler
    
    Dim frmMain As New MainForm
    frmMain.Show
    
    Exit Sub
    
InitErrorHandler:
    MsgBox "Failed to initialize Nffv or create/load database." & vbNewLine & _
     "Please check if:" & vbNewLine & _
     " - Provided password is correct;" & vbNewLine & _
     " - Database filename is correct;" & vbNewLine & _
     " - Scanners are used properly.", vbOKOnly + vbCritical
    Exit Sub
    
ErrorHandler:
    MsgBox "An error has occured: " & Err.Description
End Sub
