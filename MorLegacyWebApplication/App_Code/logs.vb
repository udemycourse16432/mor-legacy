Imports System.IO

Public Module logs

    Public Sub log_request(Request)
        ' Get the root path of the application and combine it with a "logs" folder
        Dim logDirectory As String = Path.Combine(HttpRuntime.AppDomainAppPath, "logs")

        ' Ensure the directory exists so the StreamWriter doesn't crash
        If Not Directory.Exists(logDirectory) Then
            Directory.CreateDirectory(logDirectory)
        End If

        Dim fileName As String = Path.GetFileNameWithoutExtension(Request.Path) & ".txt"
        Dim fullPath As String = Path.Combine(logDirectory, fileName)

        Using writer As New StreamWriter(fullPath, True)
            Dim line As String = Now().ToString("yyyy-MM-dd HH:mm:ss.fff") & " " & Request.ServerVariables("HTTP_X_FORWARDED_FOR") & " " &
              Request.ServerVariables("REQUEST_METHOD") & " " &
              Request.ServerVariables("URL") & Request.Url.Query
            If Request.ServerVariables("REQUEST_METHOD") = "POST" Then
                line = line & " FORM="
                For Each key As String In Request.Form.AllKeys
                    Dim value As String = Request.Form(key)
                    line = line & key & "=" & value & ","
                Next
            End If
            writer.WriteLine(line)
        End Using
    End Sub

End Module
