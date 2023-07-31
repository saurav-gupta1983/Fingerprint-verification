VERSION 5.00
Begin VB.Form SettingsForm 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Settings"
   ClientHeight    =   2850
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   5880
   Icon            =   "SettingsForm.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2850
   ScaleWidth      =   5880
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.HScrollBar hsQualityThreshold 
      Height          =   255
      Left            =   2160
      Max             =   255
      TabIndex        =   3
      Top             =   240
      Width           =   2895
   End
   Begin VB.ComboBox cbMatchingThreshold 
      Height          =   315
      Left            =   2160
      TabIndex        =   2
      Text            =   "Combo1"
      Top             =   1200
      Width           =   2895
   End
   Begin VB.CommandButton btnCancel 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   4560
      TabIndex        =   1
      Top             =   2280
      Width           =   1095
   End
   Begin VB.CommandButton btnOK 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   375
      Left            =   3240
      TabIndex        =   0
      Top             =   2280
      Width           =   1215
   End
   Begin VB.Label Label1 
      Caption         =   "0 - 99: low, 100-199: medium, 200 - 255: high."
      Height          =   375
      Left            =   2040
      TabIndex        =   7
      Top             =   600
      Width           =   3735
   End
   Begin VB.Label Label3 
      Caption         =   "Matching Threshold (FAR):"
      Height          =   375
      Left            =   120
      TabIndex        =   6
      Top             =   1200
      Width           =   2055
   End
   Begin VB.Label Label2 
      Caption         =   "Quality Threshold:"
      Height          =   375
      Left            =   120
      TabIndex        =   5
      Top             =   240
      Width           =   1815
   End
   Begin VB.Label lblQualityThreshold 
      Height          =   255
      Left            =   5160
      TabIndex        =   4
      Top             =   240
      Width           =   615
   End
End
Attribute VB_Name = "SettingsForm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Private Sub btnCancel_Click()
    Unload Me
End Sub

Private Sub btnOK_Click()
    On Error GoTo ErrorHandler
    Dim qualityThreshold As Byte
    Dim matchingThreshold As Long
    
    qualityThreshold = hsQualityThreshold.value
    matchingThreshold = MatchingThresholdFromString(cbMatchingThreshold.Text)
    
    engine.SetQualityThreshold qualityThreshold
    engine.SetMatchingThreshold matchingThreshold
    
    Unload Me

    Exit Sub
ErrorHandler:
    MsgBox "Invalid value was specified."
End Sub

Private Sub Form_Load()
    cbMatchingThreshold.AddItem (FormatPercent(0.001, 1))
    cbMatchingThreshold.AddItem (FormatPercent(0.0001, 2))
    cbMatchingThreshold.AddItem (FormatPercent(0.00001, 3))
    cbMatchingThreshold.ListIndex = 2
    
    Dim qualityThreshold As Byte
    Dim matchingThreshold As Long
    qualityThreshold = engine.GetQualityThreshold()
    matchingThreshold = engine.GetMatchingThreshold()
    
    cbMatchingThreshold.Text = MatchingThresholdToString(matchingThreshold)
    hsQualityThreshold.value = qualityThreshold
End Sub


Private Sub hsQualityThreshold_Change()
    lblQualityThreshold.Caption = "" & hsQualityThreshold.value
End Sub

