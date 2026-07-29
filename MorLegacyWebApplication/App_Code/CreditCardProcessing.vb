Imports System.Web
Imports System.Net
Imports System.IO
Imports System.Data.SqlClient
Imports System.Net.Mail
Imports Microsoft.VisualBasic

Public Module CreditCardProcessing

    'RenCreditCard Function-------------------------------------------------------------
    Public Function RunCreditCard(ByVal strUserAgent As String _
     , ByVal strCartName As String _
     , ByVal strWebOrderNumber As String _
     , ByVal strRequestAcct As String _
     , ByVal strRequestExpDate As String _
     , ByVal strRequestAmt As String _
     , ByVal strRequestCVV2 As String _
     , ByVal strRequestFirstName As String _
     , ByVal strRequestLastName As String _
     , ByVal strRequestStreet As String _
     , ByVal strRequestStreet2 As String _
     , ByVal strRequestCity As String _
     , ByVal strRequestState As String _
     , ByVal strRequestZip As String _
     , ByVal strRequestCountry As String _
     , ByVal strCustomerID As String _
     , ByVal intCustomerServerCounter As Integer _
     , ByVal strComment1 As String _
     , ByVal strComment2 As String _
     , ByVal strIPAddress As String _
     , ByVal strEmail As String _
     , ByVal strHTTP_HOST As String _
     , ByVal strConnectionStringName As String)
        Dim strOrderID As String = ""
        Dim strFormat As String = ""
        Dim strSpaces As String = ""
        Dim strQuantity As String = ""
        Dim strPrice As String = ""
        Dim strInventory As String = ""
        'Check for correct HTTP_HOST
        If InStr(1, UCase(strHTTP_HOST), "MILLIONSOFRECORDS.COM") = 0 And InStr(1, UCase(strHTTP_HOST), "MILLIONSTEST2019.COM") = 0 Then
            RunCreditCard = "ERROR - Bad Host Name"
            subSendEmail("ernie@millionsofrecords.com", "ernieb12345@gmail.com", "RunCreditCard sub - ERROR - Bad Host Name", "", 1, 0, strConnectionStringName)
            Exit Function
        End If
        'Check for search engine browsers
        If InStr(1, UCase(strUserAgent), "GOOGLE") > 0 Or InStr(1, UCase(strUserAgent), "YAHOO") > 0 Or InStr(1, UCase(strUserAgent), "MSN") > 0 Or InStr(1, UCase(strUserAgent), "SLURP") > 0 Then
            RunCreditCard = "ERROR - Possible search engine."
            Exit Function
        End If
        'Request Variables
        strUserAgent = FigureUserAgent(IsSomething(strUserAgent, ""))
        strWebOrderNumber = FigureOrderNumber(IsSomething(strWebOrderNumber, ""))
        strRequestAcct = FigureAcct(IsSomething(strRequestAcct, ""))
        strRequestExpDate = FigureExpDate(IsSomething(strRequestExpDate, ""))
        strRequestAmt = FigureAmt(IsSomething(strRequestAmt, ""))
        If Not IsNumeric(strRequestAmt) Then
            strRequestAmt = "0"
        End If
        strRequestCVV2 = IsSomething(strRequestCVV2, "")

        strRequestFirstName = IsSomething(strRequestFirstName, "")
        strRequestFirstName = Replace(strRequestFirstName, "&", " ")
        strRequestFirstName = Replace(strRequestFirstName, "#", " ")
        strRequestFirstName = Replace(strRequestFirstName, "(", " ")
        strRequestFirstName = Replace(strRequestFirstName, ")", " ")
        strRequestFirstName = Replace(strRequestFirstName, "-", " ")
        strRequestFirstName = Replace(strRequestFirstName, "/", " ")
        strRequestFirstName = Trim(strRequestFirstName)

        strRequestLastName = IsSomething(strRequestLastName, "")
        strRequestLastName = Replace(strRequestLastName, "&", " ")
        strRequestLastName = Replace(strRequestLastName, "#", " ")
        strRequestLastName = Replace(strRequestLastName, "(", " ")
        strRequestLastName = Replace(strRequestLastName, ")", " ")
        strRequestLastName = Replace(strRequestLastName, "-", " ")
        strRequestLastName = Replace(strRequestLastName, "/", " ")
        strRequestLastName = Trim(strRequestLastName)

        strRequestStreet = FigureStreet(IsSomething(strRequestStreet, ""))
        strRequestStreet2 = FigureStreet2(IsSomething(strRequestStreet2, "-"))
        strRequestCity = FigureCity(IsSomething(strRequestCity, ""))
        strRequestState = IsSomething(strRequestState, "-")
        strRequestCountry = IsSomething(strRequestCountry, "")
        strRequestZip = FigureZip(IsSomething(strRequestZip, ""))
        strOrderID = FigureOrderID()
        strComment1 = FigureComment1(IsSomething(strComment1, ""))
        strEmail = FigureEmail(IsSomething(strEmail, ""))

        'Enter Request Data Into PayFlowRequests Table
        Dim intPayFlowRequestsCounter As Integer = 0
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
            SqlConnection.ClearPool(conn)
            conn.Open()
            Dim CMD_Insert As New SqlCommand("spPayFlowRequests_Insert", conn)
            CMD_Insert.CommandType = Data.CommandType.StoredProcedure
            CMD_Insert.Parameters.AddWithValue("@EncryptionKey", ConfigurationManager.AppSettings("EncryptionKey").ToString)
            CMD_Insert.Parameters.AddWithValue("@Status", "NewRequest")
            CMD_Insert.Parameters.AddWithValue("@UserAgent", IsSomething(strUserAgent, DBNull.Value))
            CMD_Insert.Parameters.AddWithValue("@Request_TRXTYPE", "s")
            CMD_Insert.Parameters.AddWithValue("@Request_TENDER", "c")
            CMD_Insert.Parameters.AddWithValue("@Request_ACCT", IsSomething(strRequestAcct, DBNull.Value))
            CMD_Insert.Parameters.AddWithValue("@Request_EXPDATE", IsSomething(strRequestExpDate, DBNull.Value))
            CMD_Insert.Parameters.AddWithValue("@Request_AMT", CDbl(strRequestAmt))
            CMD_Insert.Parameters.AddWithValue("@Request_CVV2", IsSomething(strRequestCVV2, DBNull.Value))
            CMD_Insert.Parameters.AddWithValue("@Request_BILLTOFIRSTNAME", IsSomething(strRequestFirstName, DBNull.Value))
            CMD_Insert.Parameters.AddWithValue("@Request_BILLTOLASTNAME", IsSomething(strRequestLastName, DBNull.Value))
            CMD_Insert.Parameters.AddWithValue("@Request_BILLTOSTREET", IsSomething(strRequestStreet, DBNull.Value))
            CMD_Insert.Parameters.AddWithValue("@Request_BILLTOSTREET2", IsSomething(strRequestStreet2, DBNull.Value))
            CMD_Insert.Parameters.AddWithValue("@Request_BILLTOCITY", IsSomething(strRequestCity, DBNull.Value))
            CMD_Insert.Parameters.AddWithValue("@Request_BILLTOSTATE", IsSomething(strRequestState, DBNull.Value))
            CMD_Insert.Parameters.AddWithValue("@Request_BILLTOZIP", IsSomething(strRequestZip, DBNull.Value))
            CMD_Insert.Parameters.AddWithValue("@Request_BILLTOCOUNTRY", IsSomething(strRequestCountry, DBNull.Value))
            CMD_Insert.Parameters.AddWithValue("@Request_CUSTIP", IsSomething(strIPAddress, DBNull.Value))
            CMD_Insert.Parameters.AddWithValue("@Request_ORDERID", IsSomething(strOrderID, DBNull.Value))
            CMD_Insert.Parameters.AddWithValue("@Request_COMMENT1", IsSomething(strComment1, DBNull.Value))
            CMD_Insert.Parameters.AddWithValue("@Request_COMMENT2", IsSomething(strComment2, DBNull.Value))
            CMD_Insert.Parameters.AddWithValue("@WebOrderNumber", IsSomething(strWebOrderNumber, DBNull.Value))
            CMD_Insert.Parameters.AddWithValue("@CustomerID", 0)
            CMD_Insert.Parameters.AddWithValue("@RightFour", IsSomething(Right(strRequestAcct, 4), DBNull.Value))
            CMD_Insert.Parameters.AddWithValue("@IV", DBNull.Value)
            Try
                Dim outputCounter As New SqlParameter("@CounterOUTPUT", Data.SqlDbType.Int)
                CMD_Insert.Parameters.Add(outputCounter)
                outputCounter.Direction = Data.ParameterDirection.Output
                CMD_Insert.ExecuteNonQuery()
                intPayFlowRequestsCounter = outputCounter.Value
            Catch ex As Exception
                RunCreditCard = "ERROR - spPayFlowRequests_Insert." & ex.Message
                subSendEmail("ernie@millionsofrecords.com", "ernieb12345@gmail.com", "RunCreditCard sub - ERROR - spPayFlowRequests_Insert", "(" & DateTime.Now.ToString() & ")" & vbCrLf & "FIRST NAME: " & strRequestFirstName & vbCrLf & "LAST NAME: " & strRequestLastName & vbCrLf & "CUSTOMERID: " & strCustomerID & vbCrLf & "AMT: " & strRequestAmt & vbCrLf & ex.Message, 1, 0, strConnectionStringName)
                Exit Function
            End Try

        End Using
        'Run Credit Card
        RunCreditCard = CreditCardRequest(strIPAddress _
        , strRequestAcct _
        , strRequestExpDate _
        , strRequestAmt _
        , strRequestCVV2 _
        , strRequestFirstName _
        , strRequestLastName _
        , strRequestStreet _
        , strRequestStreet2 _
        , strRequestCity _
        , strRequestState _
        , strRequestCountry _
        , strRequestZip _
        , strOrderID _
        , strWebOrderNumber _
        , strComment1 _
        , strComment2 _
        , strConnectionStringName)
        RunCreditCard = RunCreditCard & "&COUNTER=" & CStr(intPayFlowRequestsCounter)
        'Split Up Response From PayFlow
        Dim strSplitUpResponse As String() = RunCreditCard.Split("&")
        Dim dicResponse As New StringDictionary()
        Dim strSplitUpResponseNameValuePairs As String()
        Dim n As Integer = 0
        For n = 0 To UBound(strSplitUpResponse)
            strSplitUpResponseNameValuePairs = strSplitUpResponse(n).Split("=")
            dicResponse.Add(System.Web.HttpUtility.UrlDecode(strSplitUpResponseNameValuePairs(0)), System.Web.HttpUtility.UrlDecode(strSplitUpResponseNameValuePairs(1)))
        Next
        'Update PayFlowRequests table with Response data
        Dim strFieldNames(8) As String
        strFieldNames(1) = "PNREF"
        strFieldNames(2) = "PPREF"
        strFieldNames(3) = "RESULT"
        strFieldNames(4) = "CVV2MATCH"
        strFieldNames(5) = "RESPMSG"
        strFieldNames(6) = "DUPLICATE"
        strFieldNames(7) = "PROCAVS"
        strFieldNames(8) = "RequestType"
        Dim strFieldData(8) As String
        Dim intN As Integer
        For intN = 1 To 8
            Try
                strFieldData(intN) = CleanResponseCharacters(dicResponse(strFieldNames(intN)))
            Catch ex As Exception
                If InStr(ex.ToString, "The given key was not present in the dictionary") > 0 Then
                    strFieldData(intN) = ""
                Else
                    RunCreditCard = "ERROR - RunCreditCard sub (The given key was not present in the dictionary)"
                    subSendEmail("ernie@millionsofrecords.com", "ernieb12345@gmail.com", "RunCreditCard Sub - ERROR - The given key was not present in the dictionary", "(" & DateTime.Now.ToString() & ")" & vbCrLf & ex.Message, 1, 0, strConnectionStringName)
                    Exit Function
                End If
            End Try
        Next
        'Update PayFlowRequests Table
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
            SqlConnection.ClearPool(conn)
            conn.Open()
            Dim CMD_Update As New SqlCommand("spPayFlowRequests_Update_Answer", conn)
            CMD_Update.CommandType = Data.CommandType.StoredProcedure
            CMD_Update.Parameters.AddWithValue("@Status", "Completed")
            CMD_Update.Parameters.AddWithValue("@Response_PNREF", IsSomething(strFieldData(1), DBNull.Value))
            CMD_Update.Parameters.AddWithValue("@Response_PPREF", IsSomething(strFieldData(2), DBNull.Value))
            CMD_Update.Parameters.AddWithValue("@Response_RESULT", IsSomething(strFieldData(3), DBNull.Value))
            CMD_Update.Parameters.AddWithValue("@Response_CVV2MATCH", IsSomething(strFieldData(4), DBNull.Value))
            CMD_Update.Parameters.AddWithValue("@Response_RESPMSG", IsSomething(strFieldData(5), DBNull.Value))
            CMD_Update.Parameters.AddWithValue("@Response_DUPLICATE", IsSomething(strFieldData(6), DBNull.Value))
            CMD_Update.Parameters.AddWithValue("@Response_PROCAVS", IsSomething(strFieldData(7), DBNull.Value))
            CMD_Update.Parameters.AddWithValue("@VBNETPostType", IsSomething(strFieldData(8), DBNull.Value))
            CMD_Update.Parameters.AddWithValue("@Counter", intPayFlowRequestsCounter)
            Try
                CMD_Update.ExecuteNonQuery()
            Catch ex As Exception
                RunCreditCard = "ERROR - RunCreditCard Sub - SPROC spPayFlowRequests_Update_Answer " & ex.Message
                subSendEmail("ernie@millionsofrecords.com", "ernieb12345@gmail.com", "ERROR - RunCreditCard Sub - SPROC spPayFlowRequests_Update_Answer", "(" & DateTime.Now.ToString() & ")" & vbCrLf & ex.Message, 1, 0, strConnectionStringName)
                Exit Function
            End Try
        End Using
        Dim strSubject As String = ""
        Dim strBody As String = ""
        Dim strPROCAVS As String = ""
        Dim strCustomerBlockedFromCheckoutText As String = ""
        'Check If Customer Blocked From Checkout
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
            SqlConnection.ClearPool(conn)
            conn.Open()
            Dim CMD_X As New SqlCommand("spCheckForCCFraudDeclines", conn)
            CMD_X.CommandType = Data.CommandType.StoredProcedure
            CMD_X.Parameters.AddWithValue("@IPAddress", strIPAddress)
            Dim xx As SqlDataReader
            xx = CMD_X.ExecuteReader
            If xx.HasRows Then
                xx.Read()
                If xx("Declines") >= 5 Then
                    strCustomerBlockedFromCheckoutText = "CUSTOMER BLOCKED FROM CHECKOUT | "
                End If
            End If
        End Using
        'Email Ernie If Declined
        If IsSomething(strFieldData(3), "") <> "0" And intCustomerServerCounter <> 0 Then
            strSubject = strCustomerBlockedFromCheckoutText & "CREDIT CARD DECLINE | " & strRequestAmt & " | " & strRequestFirstName & " " & strRequestLastName & " | Cust. " & strCustomerID & " | " & strWebOrderNumber
            If IsSomething(strFieldData(7), "") = "A" Then
                strPROCAVS = "A | Address (yes) / Zip (no)"
            ElseIf IsSomething(strFieldData(7), "") = "D" Then
                strPROCAVS = "D | International Address (yes) / Zip (yes)"
            ElseIf IsSomething(strFieldData(7), "") = "G" Then
                strPROCAVS = "G | Global Unavailable"
            ElseIf IsSomething(strFieldData(7), "") = "N" Then
                strPROCAVS = "N | Address (no) / Zip (no)"
            ElseIf IsSomething(strFieldData(7), "") = "S" Then
                strPROCAVS = "S | Service Not Supported"
            ElseIf IsSomething(strFieldData(7), "") = "Y" Then
                strPROCAVS = "Y | Address (yes) / Zip (yes)"
            ElseIf IsSomething(strFieldData(7), "") = "Z" Then
                strPROCAVS = "Z | Address (no) / Zip (yes)"
            Else
                strPROCAVS = IsSomething(strFieldData(7), "")
            End If
            strBody = "RESULT:   " & IsSomething(strFieldData(3), "")
            strBody = strBody & vbCrLf & vbCrLf & "CVV2MATCH:   " & IsSomething(strFieldData(4), "")
            strBody = strBody & vbCrLf & vbCrLf & "MESSAGE:   " & IsSomething(strFieldData(5), "")
            strBody = strBody & vbCrLf & vbCrLf & "PROCAVS:   " & strPROCAVS
            Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
                SqlConnection.ClearPool(conn)
                conn.Open()
                Dim CMD_X As New SqlCommand("spGetCustomerDetailsByServerCounter", conn)
                CMD_X.CommandType = Data.CommandType.StoredProcedure
                CMD_X.Parameters.AddWithValue("@counter", intCustomerServerCounter)
                Dim xx As SqlDataReader
                xx = CMD_X.ExecuteReader
                xx.Read()
                strBody = strBody & vbCrLf & vbCrLf & "------------"
                strBody = strBody & vbCrLf & "IP ADDRESS:"
                strBody = strBody & vbCrLf & "------------"
                strBody = strBody & vbCrLf
                strBody = strBody & vbCrLf & strIPAddress
                strBody = strBody & vbCrLf & vbCrLf & "------------"
                strBody = strBody & vbCrLf & "CUSTOMER ID:"
                strBody = strBody & vbCrLf & "------------"
                strBody = strBody & vbCrLf
                strBody = strBody & vbCrLf & strCustomerID
                strBody = strBody & vbCrLf & vbCrLf & "------------"
                strBody = strBody & vbCrLf & "PHONE:"
                strBody = strBody & vbCrLf & "------------"
                strBody = strBody & vbCrLf
                If Not IsDBNull(xx("Phone")) Then
                    strBody = strBody & vbCrLf & xx("Phone")
                End If
                strBody = strBody & vbCrLf & vbCrLf & "------------"
                strBody = strBody & vbCrLf & "EMAIL:"
                strBody = strBody & vbCrLf & "------------"
                strBody = strBody & vbCrLf
                If Not IsDBNull(xx("Email")) Then
                    strBody = strBody & vbCrLf & xx("Email")
                End If
                strBody = strBody & vbCrLf & vbCrLf & "------------"
                strBody = strBody & vbCrLf & "BILL TO:"
                strBody = strBody & vbCrLf & "------------"
                strBody = strBody & vbCrLf
                If Not IsDBNull(xx("BillingFullName")) Then
                    strBody = strBody & vbCrLf & xx("BillingFullName")
                End If
                If Not IsDBNull(xx("BillingStreetAddress1")) Then
                    strBody = strBody & vbCrLf & xx("BillingStreetAddress1")
                End If
                If Not IsDBNull(xx("BillingStreetAddress2")) Then
                    strBody = strBody & vbCrLf & xx("BillingStreetAddress2")
                End If
                If Not IsDBNull(xx("BillingCity")) Then
                    strBody = strBody & vbCrLf & xx("BillingCity")
                End If
                If Not IsDBNull(xx("BillingStateProvince")) Then
                    strBody = strBody & vbCrLf & xx("BillingStateProvince")
                End If
                If Not IsDBNull(xx("BillingPostalCode")) Then
                    strBody = strBody & vbCrLf & xx("BillingPostalCode")
                End If
                If Not IsDBNull(xx("BillingCountry")) Then
                    strBody = strBody & vbCrLf & xx("BillingCountry")
                End If
                strBody = strBody & vbCrLf & vbCrLf & "------------"
                strBody = strBody & vbCrLf & "SHIP TO:"
                strBody = strBody & vbCrLf & "------------"
                strBody = strBody & vbCrLf
                If Not IsDBNull(xx("FullName")) Then
                    strBody = strBody & vbCrLf & xx("FullName")
                End If
                If Not IsDBNull(xx("StreetAddress1")) Then
                    strBody = strBody & vbCrLf & xx("StreetAddress1")
                End If
                If Not IsDBNull(xx("StreetAddress2")) Then
                    strBody = strBody & vbCrLf & xx("StreetAddress2")
                End If
                If Not IsDBNull(xx("City")) Then
                    strBody = strBody & vbCrLf & xx("City")
                End If
                If Not IsDBNull(xx("StateProvince")) Then
                    strBody = strBody & vbCrLf & xx("StateProvince")
                End If
                If Not IsDBNull(xx("PostalCode")) Then
                    strBody = strBody & vbCrLf & xx("PostalCode")
                End If
                If Not IsDBNull(xx("Country")) Then
                    strBody = strBody & vbCrLf & xx("Country")
                End If
            End Using
            Using conn2 As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
                SqlConnection.ClearPool(conn2)
                conn2.Open()
                Dim CMD_X2 As New SqlCommand("spGetCartItemsForCreditCardDecline", conn2)
                CMD_X2.CommandType = Data.CommandType.StoredProcedure
                CMD_X2.Parameters.AddWithValue("@CartName", strCartName)
                Dim xxItems As SqlDataReader
                xxItems = CMD_X2.ExecuteReader
                If xxItems.HasRows Then
                    strBody = strBody & vbCrLf & vbCrLf & "------------"
                    strBody = strBody & vbCrLf & "ITEMS:"
                    strBody = strBody & vbCrLf & "------------"
                    Do While xxItems.Read
                        strFormat = xxItems("Format")
                        If strFormat = "7""" Then
                            strFormat = Left(strSpaces, 4) & strFormat
                        ElseIf strFormat = "LP" Then
                            strFormat = Left(strSpaces, 4) & strFormat
                        ElseIf strFormat = "CD" Then
                            strFormat = Left(strSpaces, 3) & strFormat
                        ElseIf strFormat = "B" Then
                            strFormat = Left(strSpaces, 5) & strFormat
                        ElseIf strFormat = "DVD" Then
                            strFormat = Left(strSpaces, 3) & strFormat
                        ElseIf strFormat = "VHS" Then
                            strFormat = Left(strSpaces, 3) & strFormat
                        ElseIf strFormat = "10""" Then
                            strFormat = Left(strSpaces, 3) & strFormat
                        ElseIf strFormat = "12""" Then
                            strFormat = Left(strSpaces, 3) & strFormat
                        Else
                            strFormat = Left(strSpaces, 3) & strFormat
                        End If
                        strQuantity = xxItems("Quantity").ToString
                        strQuantity = Left(strSpaces, (6 - Len(strQuantity)) * 2) & strQuantity
                        strPrice = Math.Round(xxItems("Price"), 2).ToString
                        strPrice = Left(strSpaces, (8 - Len(strPrice)) * 2) & strPrice
                        strInventory = xxItems("Inventory").ToString
                        strInventory = Left(strSpaces, (6 - Len(strInventory)) * 2) & strInventory
                        strBody = strBody & vbCrLf & strFormat & "  " & strPrice & "  " & strQuantity & "  " & strInventory & "   " & Trim(xxItems("ArtistTitle"))
                    Loop
                End If
            End Using
            subSendEmail("ernie@millionsofrecords.com", "ernieb12345@gmail.com", "ZWEB - " & strSubject, strBody, 1, 0, strConnectionStringName)
        End If
    End Function

    'CreditCardRequest Function-----------------------------------------------------------
    Function CreditCardRequest(ByVal IPAddress As String _
      , ByVal Acct As String _
      , ByVal ExpDate As String _
      , ByVal Amt As String _
      , ByVal CVV2 As String _
      , ByVal FirstName As String _
      , ByVal LastName As String _
      , ByVal Street As String _
      , ByVal Street2 As String _
      , ByVal City As String _
      , ByVal State As String _
      , ByVal CountryCode As String _
      , ByVal Zip As String _
      , ByVal OrderID As String _
      , ByVal WebOrderNumber As String _
      , ByVal Comment1 As String _
      , ByVal Comment2 As String _
      , ByVal strConnectionStringName As String)


        Dim HTTPPostTo As String
        Dim User As String
        Dim Pwd As String
        Dim Signature As String
        Dim varRequestTYPE As String = "" 'test, sandbox, live
        If strConnectionStringName = "MillionsOfRecordsConnectionStringDevelopment" Then
            varRequestTYPE = "TEST"
        ElseIf strConnectionStringName = "MillionsOfRecordsConnectionStringTest" Then
            varRequestTYPE = "LIVE"
        Else
            varRequestTYPE = "LIVE"
        End If
        If UCase(varRequestTYPE) = "TEST" Then
            HTTPPostTo = "http://www.millionsofrecords.com/HTTPSRequestTest-Target.aspx"
            User = "paypal@getink.com"
            Pwd = "AfG6k47!B3M"
        ElseIf UCase(varRequestTYPE) = "SANDBOX" Then
            HTTPPostTo = "https://pilot-payflowpro.paypal.com"
            User = "merchant@millionsofrecords.com"
            Pwd = "merchant123"
        ElseIf UCase(varRequestTYPE) = "LIVE" Then
            HTTPPostTo = "https://payflowpro.paypal.com"
            User = "spockandscotty"
            Pwd = "3000bakercey"
        End If

        Dim varOriginalAmt As String = Amt

        IPAddress = IsSomething(IPAddress, "")
        Acct = IsSomething(Acct, "")
        ExpDate = IsSomething(ExpDate, "")
        Amt = IsSomething(Amt, "")
        FirstName = IsSomething(FirstName, "")
        LastName = IsSomething(LastName, "-")
        Street = IsSomething(Street, "")
        Street2 = IsSomething(Street2, "-")
        City = IsSomething(City, "")
        State = IsSomething(State, "-")
        CountryCode = IsSomething(CountryCode, "")
        Zip = IsSomething(Zip, "")
        OrderID = IsSomething(OrderID, "")

        Dim strNVP As String = ""
        strNVP = strNVP & "HOSTADDRESS=" & HTTPPostTo
        strNVP = strNVP & "&TIMEOUT=60"
        strNVP = strNVP & "&PARTNER=PayPal"
        strNVP = strNVP & "&VENDOR=" & User
        strNVP = strNVP & "&USER=" & User
        strNVP = strNVP & "&PWD=" & Pwd
        strNVP = strNVP & "&TRXTYPE=S"
        strNVP = strNVP & "&TENDER=C"
        strNVP = strNVP & "&CURRENCY=USD"
        strNVP = strNVP & "&ACCT=" & Acct
        strNVP = strNVP & "&AMT=" & Amt
        strNVP = strNVP & "&EXPDATE=" & ExpDate
        strNVP = strNVP & "&CVV2=" & CVV2
        strNVP = strNVP & "&COMMENT1=" & Comment1
        strNVP = strNVP & "&COMMENT2=" & Comment2
        strNVP = strNVP & "&BILLTOFIRSTNAME=" & FirstName
        strNVP = strNVP & "&BILLTOLASTNAME=" & LastName
        strNVP = strNVP & "&BILLTOSTREET=" & Street
        strNVP = strNVP & "&BILLTOSTREET2=" & Street2
        strNVP = strNVP & "&BILLTOCITY=" & City
        strNVP = strNVP & "&BILLTOSTATE=" & State
        strNVP = strNVP & "&BILLTOZIP=" & Zip
        strNVP = strNVP & "&BILLTOCOUNTRY=US"
        strNVP = strNVP & "&CUSTIP=" & IPAddress
        strNVP = strNVP & "&ORDERID=" & OrderID
        strNVP = strNVP & "&VERBOSITY=HIGH"
        CreditCardRequest = PayPalCall(strNVP, HTTPPostTo, strConnectionStringName)
        CreditCardRequest = CreditCardRequest & "&RequestTYPE=" & varRequestTYPE
    End Function

    'PayPalCall Function-------------------------------------------------------------------
    Function PayPalCall(ByVal postData, ByVal HTTPPostTo, ByVal strConnectionStringName)
        System.Net.ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12
        Dim encoding As New UTF8Encoding
        Dim byteData As Byte() = encoding.GetBytes(postData)

        Dim postReq As HttpWebRequest = DirectCast(WebRequest.Create(HTTPPostTo), HttpWebRequest)
        postReq.Method = "POST"
        postReq.KeepAlive = True

        postReq.ContentType = "application/x-www-form-urlencoded"
        postReq.UserAgent = "Mozilla/5.0 (Windows; U; Windows NT 6.1; ru; rv:1.9.2.3) Gecko/20100401 Firefox/4.0 (.NET CLR 3.5.30729)"
        postReq.ContentLength = byteData.Length

        Dim postreqstream As Stream = postReq.GetRequestStream()
        postreqstream.Write(byteData, 0, byteData.Length)
        postreqstream.Close()
        Dim postresponse As HttpWebResponse

        Try
            postresponse = DirectCast(postReq.GetResponse(), HttpWebResponse)
        Catch ex As Exception
            If InStr(ex.ToString, "The remote name could not be resolved") > 0 Or InStr(ex.ToString, "(404) Not Found") > 0 Then
                PayPalCall = "ERROR - 'The remote name could not be resolved' (which means the PayPal website could not be found).  We apologize for the inconvenience...please try again later.  Thank you."
                subSendEmail("ernie@millionsofrecords.com", "ernieb12345@gmail.com", "RunCreditCard sub - ERROR - 'The remote name could not be resolved' (which means the PayPal website could not be found)", "(" & DateTime.Now.ToString() & ")" & vbCrLf & ex.Message, 1, 0, strConnectionStringName)
                Exit Function
            Else
                PayPalCall = "ERROR - PayPalCall sub"
                subSendEmail("ernie@millionsofrecords.com", "ernieb12345@gmail.com", "PayPalCall sub - ERROR", "(" & DateTime.Now.ToString() & ")" & vbCrLf & ex.Message, 1, 0, strConnectionStringName)
                Exit Function
            End If
        End Try
        Dim postreqreader As New StreamReader(postresponse.GetResponseStream())
        PayPalCall = postreqreader.ReadToEnd
        postresponse.Close()
    End Function


    'FigureCardType Function----------------------------------------------------------------
    Function FigureCardType(ByVal strAcct As String)
        If Len(strAcct) = 0 Or strAcct = "-" Then
            FigureCardType = ""
            Exit Function
        End If
        If strAcct.Substring(1, 1) = "3" Then
            FigureCardType = "Amex"
        ElseIf strAcct.Substring(1, 1) = "4" Then
            FigureCardType = "Visa"
        ElseIf strAcct.Substring(1, 1) = "5" Then
            FigureCardType = "MasterCard"
        ElseIf strAcct.Substring(1, 1) = "6" Then
            FigureCardType = "Discover"
        Else
            FigureCardType = ""
        End If
    End Function

    'CleanResponseCharacters Function--------------------------------------------------------
    Function CleanResponseCharacters(ByVal str As String)
        If Len(str) = 0 Then
            CleanResponseCharacters = ""
            Exit Function
        End If
        'Quote
        str = str.Replace(Chr(34), "")
        '& Sign
        str = str.Replace("&", "")
        'Comma
        str = str.Replace(",", "")
        'Tab
        str = str.Replace(Chr(9), "")
        'Linefeed
        str = str.Replace(Chr(10), "")
        'Carriage Return
        str = str.Replace(Chr(13), "")
        'Backspace
        str = str.Replace(Chr(8), "")
        'Tilde
        str = str.Replace("~", "")
        'ASC 123 to 255
        Dim n As Integer
        For n = 123 To 255
            str = str.Replace(Chr(n), "")
        Next
        CleanResponseCharacters = str
    End Function


    'FigureAcct Function----------------------------------------------------------------------------------------
    Function FigureAcct(ByVal strText As String)
        FigureAcct = ""
        If strText = "" Then
            Exit Function
        End If
        Dim n As Integer
        For n = 1 To strText.Length
            If Asc(Mid(strText, n, 1)) >= 48 And Asc(Mid(strText, n, 1)) <= 57 Then
                FigureAcct = FigureAcct & Mid(strText, n, 1)
            End If
        Next
        FigureAcct = Left(FigureAcct, 25)
    End Function
    'FigureUserAgent Function----------------------------------------------------------------------------------------
    Function FigureUserAgent(ByVal strText As String)
        FigureUserAgent = ""
        If strText = "" Then
            Exit Function
        End If
        strText = Trim(strText)
        FigureUserAgent = Trim(Left(strText, 300))
    End Function
    'FigureOrderNumber Function----------------------------------------------------------------------------------------
    Function FigureOrderNumber(ByVal strText As String)
        FigureOrderNumber = ""
        If strText = "" Then
            Exit Function
        End If
        strText = Trim(strText)
        FigureOrderNumber = Trim(Left(strText, 15))
    End Function

    'FigureExpDate Function----------------------------------------------------------------------------------------
    Function FigureExpDate(ByVal strText As String)
        FigureExpDate = ""
        If strText = "" Then
            Exit Function
        End If
        strText = Trim(strText)
        FigureExpDate = Trim(Left(strText, 4))
    End Function
    'FigureAmt Function----------------------------------------------------------------------------------------
    Function FigureAmt(ByVal strText As String)
        FigureAmt = "0"
        If strText = "" Then
            Exit Function
        End If
        strText = Trim(strText)
        If Not IsNumeric(strText) Then
            Exit Function
        End If
        FigureAmt = FormatNumber(strText, 2).ToString
    End Function
    'FigureCVV2 Function----------------------------------------------------------------------------------------
    Function FigureCVV2(ByVal strText As String, ByVal strAcct As String)
        FigureCVV2 = ""
        If strText = "" Or strText = "-" Then
            If strAcct = "" Or Left(strAcct, 1) <> "3" Then
                FigureCVV2 = "111"
            Else
                FigureCVV2 = "1111"
            End If
            Exit Function
        Else
            strText = Trim(strText)
            FigureCVV2 = Trim(Left(strText, 6))
        End If
    End Function
    'FigureFirstName Function----------------------------------------------------------------------------------------
    Function FigureFirstName(ByVal strText As String)
        FigureFirstName = strText
        If InStr(1, FigureFirstName, " ") > 0 Then
            FigureFirstName = Trim(Left(FigureFirstName, InStr(1, FigureFirstName, " ") - 1))
        End If
        If FigureFirstName <> "" Then
            FigureFirstName = Trim(Left(FigureFirstName, 30))
        End If
    End Function
    'FigureLastName Function----------------------------------------------------------------------------------------
    Function FigureLastName(ByVal strText As String)
        FigureLastName = strText
        If InStr(1, FigureLastName, " ") > 0 Then
            FigureLastName = Trim(Right(FigureLastName, Len(FigureLastName) - InStr(1, FigureLastName, " ")))
        End If
        If FigureLastName <> "" Then
            FigureLastName = Trim(Left(FigureLastName, 30))
        End If
    End Function
    'FigureCustomerID Function----------------------------------------------------------------------------------------
    Function FigureCustomerID(ByVal strText As String)
        FigureCustomerID = ""
        If strText = "" Then
            Exit Function
        End If
        strText = Trim(strText)
        FigureCustomerID = Trim(Left(strText, 10))
        If Not IsNumeric(FigureCustomerID) Then
            FigureCustomerID = "0"
        End If
    End Function
    'FigureComment1 Function----------------------------------------------------------------------------------------
    Function FigureComment1(ByVal strText As String)
        FigureComment1 = ""
        If strText = "" Then
            Exit Function
        End If
        strText = Trim(strText)
        FigureComment1 = Trim(Left(strText, 128))
    End Function
    'FigureStreet Function----------------------------------------------------------------------------------------
    Function FigureStreet(ByVal strStreet1 As String)
        FigureStreet = ""
        If strStreet1 = "" Then
            Exit Function
        End If
        FigureStreet = Trim(Left(strStreet1, 30))
    End Function
    'FigureStreet2 Function----------------------------------------------------------------------------------------
    Function FigureStreet2(ByVal strStreet2 As String)
        FigureStreet2 = ""
        If strStreet2 = "" Then
            Exit Function
        End If
        FigureStreet2 = Trim(Left(strStreet2, 30))
    End Function

    'FigureCity Function----------------------------------------------------------------------------------------
    Function FigureCity(ByVal strText As String)
        FigureCity = ""
        If strText = "" Then
            Exit Function
        End If
        strText = Trim(strText)
        FigureCity = Trim(Left(strText, 20))
    End Function
    'FigureCompleteType Function----------------------------------------------------------------------------------------
    Function FigureCompleteType(ByVal strText As String)
        FigureCompleteType = ""
        If strText = "" Then
            Exit Function
        End If
        strText = Trim(strText)
        FigureCompleteType = Trim(Left(strText, 50))
    End Function

    'FigureState Function----------------------------------------------------------------------------------------
    Function FigureState(ByVal strCountry As String, ByVal strState As String, ByVal strConnectionStringName As String)
        FigureState = ""
        If strCountry = "" And strState = "" Then
            Exit Function
        End If
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
            SqlConnection.ClearPool(conn)
            conn.Open()
            Dim CMD_State As New SqlCommand("FigureStateForPaymentsProRequest", conn)
            CMD_State.CommandType = Data.CommandType.StoredProcedure
            CMD_State.Parameters.AddWithValue("@Country", strCountry)
            CMD_State.Parameters.AddWithValue("@State", strState)
            FigureState = IsDBSomething(CMD_State.ExecuteScalar(), "-")
            FigureState = Left(FigureState, 30)
        End Using
    End Function
    'FigureZip Function----------------------------------------------------------------------------------------
    Function FigureZip(ByVal strText As String)
        FigureZip = ""
        If strText = "" Then
            Exit Function
        End If
        strText = Trim(strText)
        FigureZip = Trim(Left(strText, 9))
    End Function
    'FigureEmail Function----------------------------------------------------------------------------------------
    Function FigureEmail(ByVal strText As String)
        FigureEmail = ""
        If strText = "" Then
            Exit Function
        End If
        strText = Trim(strText)
        FigureEmail = Trim(Left(strText, 100))
    End Function
    'FigureCountry Function----------------------------------------------------------------------------------------
    Function FigureCountry(ByVal strCountry As String, strConnectionStringName As String)
        FigureCountry = "US"
        If strCountry = "" Then
            Exit Function
        End If
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
            SqlConnection.ClearPool(conn)
            conn.Open()
            Dim CMD_Country As New SqlCommand("FigureCountryForPaymentsProRequest", conn)
            CMD_Country.CommandType = Data.CommandType.StoredProcedure
            CMD_Country.Parameters.AddWithValue("@Country", strCountry)
            FigureCountry = IsSomething(CMD_Country.ExecuteScalar(), "")
            FigureCountry = Left(FigureCountry, 5)
        End Using
    End Function

    'FigureOrderID Function
    Function FigureOrderID()
        Dim strTimeNow As String = Now().ToString
        Dim strAMPM As String
        Dim strTimeStamp As String
        If Hour(strTimeNow) > 11 Then
            strAMPM = "P"
        Else
            strAMPM = "A"
        End If
        strTimeStamp = strAMPM & Month(strTimeNow) & Day(strTimeNow) & Year(strTimeNow) & Hour(strTimeNow) & Minute(strTimeNow) & Second(strTimeNow)
        Dim strRandomNumbers As String = RandomNumbers(8)
        FigureOrderID = "SALE-W-" & strTimeStamp & "-" & strRandomNumbers
    End Function

    'RandomNumbers Function
    Function RandomNumbers(ByVal intNumberOfNumbers As Integer)
        Dim n As Integer
        Dim varXrandom3 As Double
        For n = 1 To Second(Now()) + 1
            Randomize()
            varXrandom3 = Rnd(2000)
        Next
        RandomNumbers = Int(Rnd() * (10 ^ intNumberOfNumbers) - 1)
    End Function
End Module
