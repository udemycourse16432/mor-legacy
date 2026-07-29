Imports System.Configuration
Imports System.IO
Imports System.ServiceModel.MsmqIntegration
Imports MimeKit
Imports MailKit
Imports MailKit.Net.Smtp

Public Module email

    Public Sub subSendEmail(ByVal strFrom As String, ByVal strTo As String, ByVal strSubject As String, ByVal strBody As String, ByVal intLogEmailErrors As Integer, ByVal intHTML As Integer, ByVal strConnectionStringName As String)
        If strConnectionStringName = "MillionsOfRecordsConnectionStringDevelopment" Then Exit Sub
        Dim msg As New MimeMessage()
        msg.From.Add(New MailboxAddress("", ConfigurationManager.AppSettings("SMTP_User")))
        msg.To.Add(New MailboxAddress("", strTo))
        msg.ReplyTo.Add(New MailboxAddress(ConfigurationManager.AppSettings("SMTP_ReplyTo_Name"), ConfigurationManager.AppSettings("SMTP_ReplyTo_EMail")))
        msg.Subject = strSubject
        msg.Body = New TextPart("plain") With {.Text = strBody}
        Try
            Using smtpClient As New SmtpClient()
                smtpClient.Connect(ConfigurationManager.AppSettings("SMTP_Host"), Integer.Parse(ConfigurationManager.AppSettings("SMTP_Port")), True)
                smtpClient.Authenticate(ConfigurationManager.AppSettings("SMTP_User"), ConfigurationManager.AppSettings("SMTP_Pass"))
                smtpClient.Send(msg)
                smtpClient.Disconnect(True)
            End Using
        Catch ex As Exception
            Using writer As New StreamWriter("D:\SendEmail_err.txt", True)
                writer.WriteLine(Now().ToString("yyyy-MM-dd HH:mm:ss.fff") & " " & ex.Message)
                writer.WriteLine("                         From: " & strFrom)
                writer.WriteLine("                         To  : " & strTo)
                writer.WriteLine("                         Subj: " & strSubject)
                writer.WriteLine("                         Body: " & strBody)
            End Using
        End Try
    End Sub

End Module
