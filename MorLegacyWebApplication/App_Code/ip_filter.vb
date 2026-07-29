Imports System.IO
Imports System.Configuration

Public Module ip_filter

    Public Sub only_office(Request, Response)
        If Request.ServerVariables("HTTP_X_FORWARDED_FOR") <> ConfigurationManager.AppSettings("IP_Office") Then
            log_request(Request)
            Response.Write("Invalid Credentials; IP Address Recorded")
            Response.End()
        End If
    End Sub

    'for testing
    Public Sub only_tony(Request, Response)
        If Request.ServerVariables("HTTP_X_FORWARDED_FOR") <> "76.91.74.198" Then
            log_request(Request)
            Response.Write("Invalid Credentials; IP Address Recorded")
            Response.End()
        End If
    End Sub

End Module
