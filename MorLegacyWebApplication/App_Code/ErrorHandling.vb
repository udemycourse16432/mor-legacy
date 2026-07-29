Imports System.Web
Imports System.Net
Imports System.IO
Imports System.Data.SqlClient
Imports System.Net.Mail
Imports Microsoft.VisualBasic

Public Module ErrorHandling
    Public Sub subLogError(ByVal strFullName As String, ByVal strCustomerID As String, ByVal strErrorMessage As String, ByVal strStackTrace As String, ByVal strQueryString As String, ByVal strFormValues As String, ByVal strPowerUserName As String, ByVal strIPAddress As String, ByVal strUserAgent As String, ByVal strCartName As String, ByVal strErrorLevel As String, ByVal strConnectionStringName As String)
        Dim intRecordAndEmailError As Integer = 1
        'Get Elapsed Time Since Last Error
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
            SqlConnection.ClearPool(conn)
            conn.Open()
            Dim CMD_ElapsedTime As New SqlCommand("spGetElapsedTimeSinceLastASPXError", conn)
            CMD_ElapsedTime.CommandType = Data.CommandType.StoredProcedure
            Dim readerElapsedTime As SqlDataReader
            readerElapsedTime = CMD_ElapsedTime.ExecuteReader
            If readerElapsedTime.HasRows Then
                readerElapsedTime.Read()
                If readerElapsedTime("IPAddress") = strIPAddress Then
                    If readerElapsedTime("Minutes") < CDbl(10) Then
                        intRecordAndEmailError = 1
                    End If
                Else
                    If readerElapsedTime("Minutes") < CDbl(2) Then
                        intRecordAndEmailError = 1
                    End If
                End If
            End If
            readerElapsedTime.Close()
            readerElapsedTime = Nothing
        End Using

        If intRecordAndEmailError = 1 Then
            'Record Error into Errors Table
            ' Dim strCounter As String = ""
            ' Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
            ' SqlConnection.ClearPool(conn)
            ' conn.Open()
            ' Dim CMD_Errors As New SqlCommand("spASPXErrors_Insert", conn)
            ' CMD_Errors.CommandType = Data.CommandType.StoredProcedure
            ' CMD_Errors.Parameters.AddWithValue("@CartName", IsSomething(strCartName, "-"))
            ' CMD_Errors.Parameters.AddWithValue("@UserAgent", Left(strUserAgent, 300))
            ' CMD_Errors.Parameters.AddWithValue("@IPAddress", IsSomething(strIPAddress, "-"))
            ' CMD_Errors.Parameters.AddWithValue("@PowerUserName", IsSomething(strPowerUserName, "-"))
            ' CMD_Errors.Parameters.AddWithValue("@ErrorMessage", Left(strErrorMessage, 500))
            ' CMD_Errors.Parameters.AddWithValue("@ErrorStackTrace", Left(strStackTrace, 2000))
            ' CMD_Errors.Parameters.AddWithValue("@QueryString", Left(strQueryString, 1000))
            ' CMD_Errors.Parameters.AddWithValue("@FormValues", Left(strFormValues, 2000))
            ' CMD_Errors.Parameters.AddWithValue("@ErrorLevel", Left(strErrorLevel, 50))
            ' Dim outputCounter As New SqlParameter("@counterOUTPUT", Data.SqlDbType.Int)
            ' CMD_Errors.Parameters.Add(outputCounter)
            ' outputCounter.Direction = Data.ParameterDirection.Output
            ' CMD_Errors.ExecuteNonQuery()
            ' strCounter = outputCounter.Value.ToString
            ' End Using

            'Email Kirby
            Dim strBody As String = ""
            strBody = strBody & Chr(10) & "ERROR MESSAGE:  " & strErrorMessage
            strBody = strBody & Chr(10) & Chr(10) & "QUERY STRING:  " & strQueryString
            strBody = strBody & Chr(10) & Chr(10) & "FORM VALUES:  " & IsSomething(strFormValues, "")
            strBody = strBody & Chr(10) & Chr(10) & "STACK TRACE:  " & strStackTrace
            strBody = strBody & Chr(10) & Chr(10) & "CART NAME:  " & IsSomething(strCartName, "")
            strBody = strBody & Chr(10) & Chr(10) & "USER AGENT:  " & IsSomething(strUserAgent, "")
            strBody = strBody & Chr(10) & Chr(10) & "IP ADDRESS:  " & IsSomething(strIPAddress, "")
            strBody = strBody & Chr(10) & Chr(10) & "CUSTOMER NAME:  " & IsSomething(strFullName, "")
            strBody = strBody & Chr(10) & Chr(10) & "CUSTOMER ID:  " & IsSomething(strCustomerID, "")
            strBody = strBody & Chr(10) & Chr(10) & "POWERUSER NAME:  " & IsSomething(strPowerUserName, "")
            'strBody = strBody & Chr(10) & Chr(10) & "COUNTER:  " & IsSomething(strCounter, "")

            subSendEmail("ernie@millionsofrecords.com", "ernieb12345@gmail.com", "ZWEB - MillionsOfRecords Website Application Level Error", strBody, 1, 0, strConnectionStringName)
        End If

    End Sub


End Module
