VERSION 5.00
Begin VB.Form MainForm 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Nffv VB6 Sample"
   ClientHeight    =   7380
   ClientLeft      =   150
   ClientTop       =   840
   ClientWidth     =   9450
   Icon            =   "MainForm.frx":0000
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   7380
   ScaleWidth      =   9450
   StartUpPosition =   3  'Windows Default
   Begin VB.ListBox lbDatabase 
      Height          =   6885
      Left            =   6480
      TabIndex        =   0
      Top             =   360
      Width           =   2895
   End
   Begin VB.Label Label1 
      BackColor       =   &H80000002&
      Caption         =   "User List"
      ForeColor       =   &H80000009&
      Height          =   255
      Left            =   6480
      TabIndex        =   1
      Top             =   0
      Width           =   2895
   End
   Begin VB.Image imgFingerprint 
      BorderStyle     =   1  'Fixed Single
      Height          =   7335
      Left            =   0
      Top             =   0
      Width           =   6375
   End
   Begin VB.Menu mnuUser 
      Caption         =   "&User"
      Begin VB.Menu mnuEnroll 
         Caption         =   "&Enroll"
      End
      Begin VB.Menu mnuVerify 
         Caption         =   "&Verify"
      End
      Begin VB.Menu Separator 
         Caption         =   "-"
      End
      Begin VB.Menu mnuDelete 
         Caption         =   "&Delete"
      End
      Begin VB.Menu mnuClear 
         Caption         =   "&Clear Database"
      End
      Begin VB.Menu Separator2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuExit 
         Caption         =   "&Exit"
      End
   End
   Begin VB.Menu mnuTools 
      Caption         =   "&Tools"
      Begin VB.Menu mnuOptions 
         Caption         =   "&Options"
      End
   End
   Begin VB.Menu mnuHelp 
      Caption         =   "&Help"
      Begin VB.Menu mnuAbout 
         Caption         =   "&About"
      End
   End
End
Attribute VB_Name = "MainForm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Private Sub Form_Load()
    LoadUserDatabase
End Sub

Private Sub Form_Unload(Cancel As Integer)
    SaveUserDatabase
End Sub

Private Sub mnuAbout_Click()
    Dim frmAbout As New AboutForm
    frmAbout.Show vbModal
End Sub

Private Sub mnuClear_Click()
    If MsgBox("Do you really want to delete all users from database?", vbYesNo) = vbYes Then
        engine.ClearUsers
        lbDatabase.Clear
    End If
End Sub

Private Sub mnuDelete_Click()
    If lbDatabase.ListIndex < 0 Then
        MsgBox "No user selected in User List.", vbOKOnly + vbInformation
        Exit Sub
    End If
    
    If MsgBox("Do you really want to delete selected user from database?", vbYesNo) = vbYes Then
        Dim previousIndex As Long
        previousIndex = lbDatabase.ListIndex
        
        engine.RemoveUser lbDatabase.ListIndex
        lbDatabase.RemoveItem lbDatabase.ListIndex
        
        If previousIndex < lbDatabase.ListCount Then
            lbDatabase.ListIndex = previousIndex
        ElseIf lbDatabase.ListCount > 0 Then
            lbDatabase.ListIndex = lbDatabase.ListCount - 1
        End If
    End If
End Sub

Private Sub mnuEnroll_Click()
    On Error GoTo ErrorHandler
    
    Dim identifier As String
    identifier = InputBox("Please enter an identifier for new user", "New user identifier")
    If StrPtr(identifier) = 0 Then Exit Sub ' Cancel pressed
    
    Dim engineUser As NffvUser
    Dim status As NffvStatus
    Dim frmScan As New ScanForm
    frmScan.Show
    frmScan.Refresh
    status = engine.Enroll(20000, engineUser)
    Unload frmScan
    Set frmScan = Nothing
    If status = nfesTemplateCreated Then
      imgFingerprint.Picture = engineUser.GetImage()
      If identifier = "" Then identifier = Str(engineUser.GetUserId())
      lbDatabase.AddItem identifier
      lbDatabase.ListIndex = lbDatabase.ListCount - 1
    Else
        MsgBox "Failed to enroll: " & Nffv_GetStatusDescription(status)
    End If
    Exit Sub
    
ErrorHandler:
    If Err.number = -7 Then
        MsgBox "Invalid operation. Possibly no more records can be added to database."
    Else
        MsgBox "An error has occured: " & Err.Description
    End If
    
    If Not frmScan Is Nothing Then Unload frmScan
End Sub

Private Sub mnuExit_Click()
    Unload Me
End Sub

Private Sub mnuOptions_Click()
    Dim frmSettings As New SettingsForm
    frmSettings.Show vbModal
End Sub

Private Sub mnuVerify_Click()
    If lbDatabase.ListIndex < 0 Then
        MsgBox "No user selected in User List. Please select/enroll user first.", vbOKOnly + vbInformation
        Exit Sub
    End If
    
    Dim engineUser As NffvUser
    Set engineUser = engine.GetUser(lbDatabase.ListIndex)
    Dim score As Long
    Dim engineStatus As NffvStatus
    Dim frmScan As New ScanForm
    frmScan.Show
    frmScan.Refresh
    engineStatus = engine.Verify(engineUser, 20000, score)
    Unload frmScan
    Set frmScan = Nothing
    If engineStatus = nfesTemplateCreated Then
        If score > 0 Then
            MsgBox lbDatabase.List(lbDatabase.ListIndex) & " verified." & vbNewLine & "Fingerprint matching score: " & score
        Else
             MsgBox lbDatabase.List(lbDatabase.ListIndex) & " not verified." & vbNewLine & "Fingerprints do not match."
        End If
    Else
        MsgBox "Failed to verify: " & Nffv_GetStatusDescription(engineStatus)
    End If
End Sub

Public Sub SetUserDatabaseFilename(UserDB As String)
    userDatabase = UserDB
End Sub

Private Function LoadUserDatabase()
    Dim fnum As Integer, isOpen As Boolean
    On Error GoTo Error_Handler
    fnum = FreeFile()
    Open userDatabase For Input As #fnum
    isOpen = True
    Dim allText As String
    allText = Input(LOF(fnum), fnum)
    
    Dim usersList() As String
    usersList = Split(allText, vbCrLf)
    For Each userIdentifier In usersList
        If userIdentifier <> "" Then lbDatabase.AddItem userIdentifier
    Next
    
    If lbDatabase.ListCount > 0 Then lbDatabase.ListIndex = 0 ' select first by default
    
    ' Intentionally flow into the error handler to close the file.
Error_Handler:
    If isOpen Then Close #fnum
End Function

Private Sub SaveUserDatabase()
    On Error GoTo Error_Handler
    
    Dim allText As String
    If lbDatabase.ListCount > 0 Then
        ReDim usersList(lbDatabase.ListCount - 1) As String
        Dim i As Long
        For i = 0 To lbDatabase.ListCount - 1
            usersList(i) = lbDatabase.List(i)
        Next
        allText = Join(usersList, vbCrLf)
    Else
        allText = ""
    End If
    
    Dim fnum As Integer, isOpen As Boolean
    fnum = FreeFile()
    Open userDatabase For Output As #fnum
    isOpen = True
    Print #fnum, allText
    ' Intentionally flow into the error handler to close the file.
Error_Handler:
    If isOpen Then Close #fnum
    If Err Then MsgBox "Failure while saving user database: " & Err.Description
End Sub

