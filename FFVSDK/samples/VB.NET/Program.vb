
Imports System
Imports System.Collections.Generic
Imports System.Windows.Forms
Imports Neurotec.Biometrics

Namespace VBNETSample
	NotInheritable Class Program
		Private Sub New()
		End Sub
		''' <summary>
		''' The main entry point for the application.
		''' </summary>
		<STAThread()> _
		Public Shared Sub Main()
			Application.EnableVisualStyles()
			Application.SetCompatibleTextRenderingDefault(False)

			Dim engine As Global.Neurotec.Biometrics.Nffv = Nothing
			Try
				Dim chooseScannerForm As New ChooseScannerForm()
				If chooseScannerForm.ShowDialog() = DialogResult.OK Then
					Try
						engine = New Nffv(chooseScannerForm.FingerprintDatabase, chooseScannerForm.FingerprintDatabasePassword, chooseScannerForm.ScannerString)
					Catch generatedExceptionName As Exception
						MessageBox.Show(Nothing, "Failed to initialize Nffv or create/load database.\r\nPlease check if:\r\n - Provided password is correct;\r\n - Database filename is correct;\r\n", "Nffv C# Sample", MessageBoxButtons.OK, MessageBoxIcon.[Error])
						Return
					End Try
					Application.Run(New MainForm(engine, chooseScannerForm.UserDatabase))
				End If
			Catch ex As Exception
				MessageBox.Show(String.Format("An error has occured: {0}", ex.Message), "Nffv C# Sample", MessageBoxButtons.OK, MessageBoxIcon.[Error])
			Finally
				If engine IsNot Nothing Then
					engine.Dispose()
				End If
			End Try
		End Sub
	End Class
End Namespace
