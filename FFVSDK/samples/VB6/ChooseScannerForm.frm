VERSION 5.00
Begin VB.Form ChooseScannerForm 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Choose Scanner"
   ClientHeight    =   5655
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   4560
   Icon            =   "ChooseScannerForm.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5655
   ScaleWidth      =   4560
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton btnOK 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   375
      Left            =   1920
      TabIndex        =   6
      Top             =   5040
      Width           =   1215
   End
   Begin VB.CommandButton btnCancel 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   3240
      TabIndex        =   5
      Top             =   5040
      Width           =   1215
   End
   Begin VB.TextBox tbUserDB 
      Height          =   285
      Left            =   1440
      TabIndex        =   3
      Text            =   "UserDB.vb6.dat"
      Top             =   4440
      Width           =   3015
   End
   Begin VB.TextBox tbPassword 
      Height          =   285
      IMEMode         =   3  'DISABLE
      Left            =   1440
      PasswordChar    =   "*"
      TabIndex        =   2
      Top             =   3960
      Width           =   3015
   End
   Begin VB.TextBox tbFingerprintDB 
      Height          =   285
      Left            =   1440
      TabIndex        =   1
      Text            =   "FingerprintDB.vb6.dat"
      Top             =   3600
      Width           =   3015
   End
   Begin VB.ListBox lbScanners 
      Height          =   2310
      Left            =   120
      Style           =   1  'Checkbox
      TabIndex        =   0
      Top             =   1080
      Width           =   4335
   End
   Begin VB.Label Label5 
      Caption         =   "User DB:"
      Height          =   255
      Left            =   120
      TabIndex        =   9
      Top             =   4440
      Width           =   1215
   End
   Begin VB.Label Label3 
      Caption         =   "Password:"
      Height          =   255
      Left            =   120
      TabIndex        =   8
      Top             =   3960
      Width           =   1215
   End
   Begin VB.Label Label2 
      Caption         =   "Fingerprint DB:"
      Height          =   255
      Left            =   120
      TabIndex        =   7
      Top             =   3600
      Width           =   1215
   End
   Begin VB.Label Label1 
      Caption         =   $"ChooseScannerForm.frx":1BB2
      Height          =   855
      Left            =   120
      TabIndex        =   4
      Top             =   240
      Width           =   4335
   End
End
Attribute VB_Name = "ChooseScannerForm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private dialogOK As Boolean

Private Sub btnCancel_Click()
    Me.Hide
End Sub

Private Sub btnOK_Click()
    dialogOK = True
    Me.Hide
End Sub

Private Sub Form_Load()
    dialogOK = False
    Dim moduleString As String
        moduleString = Nffv_GetAvailableScannerModules
    Dim moduleNames() As String
    moduleNames = Split(moduleString, ";")
    For Each moduleName In moduleNames
        lbScanners.AddItem moduleName
    Next
    
    If lbScanners.ListCount = 0 Then
        lbScanners.AddItem "No scanners found"
        lbScanners.Enabled = False
    End If
End Sub

Public Function GetScanners() As String
    If lbScanners.SelCount > 0 Then
        Dim currentModule As Long
        currentModule = 0
        ReDim moduleList(lbScanners.SelCount - 1) As String
        For i = 0 To lbScanners.ListCount - 1
            If lbScanners.Selected(i) Then
                moduleList(currentModule) = lbScanners.List(i)
                currentModule = currentModule + 1
            End If
        Next
        GetScanners = Join(moduleList, ";")
    Else
        GetScanners = ""
    End If
End Function

Public Function GetFingerprintDB() As String
    GetFingerprintDB = tbFingerprintDB.Text
End Function

Public Function GetPassword() As String
    GetPassword = tbPassword.Text
End Function

Public Function GetUserDB() As String
    GetUserDB = tbUserDB.Text
End Function

Public Function IsDialogOK() As Boolean
    IsDialogOK = dialogOK
End Function

