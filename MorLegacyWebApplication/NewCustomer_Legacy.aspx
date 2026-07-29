
<%@ Page Language="VB" Debug="true" AutoEventWireup="false" EnableViewState="false" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web" %>

<% log_request(Request) %>

<%
 'Require Website Password
 Dim varRequireWebsitePassword As String = "no"
 If InStr(1, UCase(Request.ServerVariables("HTTP_HOST")), "MILLIONSTEST.COM") > 0 Then
  varRequireWebsitePassword = "yes"
 End If
 If varRequireWebsitePassword = "yes" Then
  If Session("WebsitePassword") <> "test2019" Then
   Response.Redirect("/submit-password.aspx")
  End If
 End If

 'Look for SQL Injection
 If Not String.IsNullOrEmpty(Request.QueryString.ToString) Then
  If Len(Request.QueryString.ToString) > 1000 Or CheckSQLInjectionText(Request.QueryString.ToString) = 1 Then
   Response.Write("Please click your browser's back button to go to the previous page.")
   Response.End()
  End If
 End If

 'Connection String
 Dim strConnectionStringName As String = ""
 If Context.IsDebuggingEnabled OrElse Request.ServerVariables("HTTP_X_FORWARDED_FOR") = "1.1.1.27" then
  strConnectionStringName = "MillionsOfRecordsConnectionStringDevelopment"
 Else
  strConnectionStringName = "MillionsOfRecordsConnectionStringProduction"
 End If

 'Name of Cart
 Dim varServerCounter As String = ""
 Dim NameOfCart As String = ""
 Dim varPriceGroup As String = ""
 If Session("StoreName") <> "" Then
  varServerCounter = Session("CustomerServerCounter")
  NameOfCart = "W_CART_" & varServerCounter
  varPriceGroup = Session("PriceGroup")
 Else
  NameOfCart = "CART" & Session.SessionID & Session("CartRandomNumbersExtension")
  varPriceGroup = "RetailPrice"
 End If

 Dim varChecked As string="checked"

 'Wholesale or Retail
 Dim varWholesaleOrRetail As String = Request("WholesaleOrRetailTxt")
 If varWholesaleOrRetail = "" Or varWholesaleOrRetail = "retail" Then
  varWholesaleOrRetail = "retail"
  varPriceGroup = "RetailPrice"
 Else
  varWholesaleOrRetail = "wholesale"
  varPriceGroup = "StorePrice"
 End If
 'Check for items in cart
 Dim varItemsInCart As Integer = 0
 Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
  SqlConnection.ClearPool(conn)
  conn.Open()
  Dim CMD_X As New SqlCommand("CartNumberOfItems", conn)
  CMD_X.CommandType = Data.CommandType.StoredProcedure
  CMD_X.Parameters.AddWithValue("@CartName", NameOfCart)
  CMD_X.ExecuteScalar()
  If Not IsDBNull(CMD_X) Then
   varItemsInCart = 1
  End If
 End Using
 'Country
 Dim defaultCountry As String = ""
 Dim defaultBillingCountry As String = ""
 Dim varCountryListCity As String = ""
 Dim varCountryListStateProvince As String = ""
 Dim defaultCountryListCounter As Integer = 0
 Dim varBillingCountryListCity As String = ""
 Dim varBillingCountryListStateProvince As String = ""
 Dim defaultBillingCountryListCounter As Integer = 0
 If Not IsNumeric(Request("CountryListCode")) And Request("CountryChangedTxt") <> "yes" And Request("BillingCountryChangedTxt") <> "yes" And Request("Country") = "" Then
  Response.Redirect("/Options.aspx")
 End If
 If Request("CountryListCode") <> "" And Request("CountryChangedTxt") <> "yes" And Request("BillingCountryChangedTxt") <> "yes" Then
  Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
   SqlConnection.ClearPool(conn)
   conn.Open()
   Dim CMD_X As New SqlCommand("spGetCountryInfoFromCounter", conn)
   CMD_X.CommandType = Data.CommandType.StoredProcedure
   CMD_X.Parameters.AddWithValue("@counter", IsDBSomething(Request("CountryListCode"), 0))
   Dim readerX As SqlDataReader
   readerX = CMD_X.ExecuteReader
   If Not readerX.HasRows Then
    Response.Redirect("/Options.aspx")
   Else
    readerX.Read()
   End If
   defaultCountry = readerX("Country")
   defaultBillingCountry = readerX("Country")
   varCountryListCity = IsDBSomething(readerX("City"), "")
   varCountryListStateProvince = IsDBSomething(readerX("StateProvince"), "")
   defaultCountryListCounter = readerX("counter")
   defaultBillingCountry = readerX("Country")
   varBillingCountryListCity = IsDBSomething(readerX("City"), "")
   varBillingCountryListStateProvince = IsDBSomething(readerX("StateProvince"), "")
   defaultBillingCountryListCounter = readerX("counter")
  End Using
 Else
  Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
   SqlConnection.ClearPool(conn)
   conn.Open()
   Dim CMD_X As New SqlCommand("spGetCountryInfoFromCounter", conn)
   CMD_X.CommandType = Data.CommandType.StoredProcedure
   CMD_X.Parameters.AddWithValue("@counter", IsDBSomething(Request("Country"), 0))
   Dim readerX As SqlDataReader
   readerX = CMD_X.ExecuteReader
   If Not readerX.HasRows Then
    Response.Redirect("/Options.aspx")
   Else
    readerX.Read()
   End If
   defaultCountry = readerX("Country")
   varCountryListCity = IsDBSomething(readerX("City"), "")
   varCountryListStateProvince = IsDBSomething(readerX("StateProvince"), "")
   defaultCountryListCounter = readerX("counter")
  End Using
  If Request("BillingCountry") <> "" Then
   Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
    SqlConnection.ClearPool(conn)
    conn.Open()
    Dim CMD_X As New SqlCommand("spGetCountryInfoFromCounter", conn)
    CMD_X.CommandType = Data.CommandType.StoredProcedure
    CMD_X.Parameters.AddWithValue("@counter", IsDBSomething(Request("BillingCountry"), 0))
    Dim readerX As SqlDataReader
    readerX = CMD_X.ExecuteReader
    If Not readerX.HasRows Then
     Response.Redirect("/Options.aspx")
    Else
     readerX.Read()
    End If
    defaultBillingCountry = readerX("Country")
    varBillingCountryListCity = IsDBSomething(readerX("City"), "")
    varBillingCountryListStateProvince = IsDBSomething(readerX("StateProvince"), "")
    defaultBillingCountryListCounter = readerX("counter")
   End Using
  End If
 End If

 'WebCountryShippingZonesT
 Dim varPostalCodeRequired As String = ""
 Dim varStateProvinceRequired As String = ""
 Dim varCityRequired As String = ""
 Dim varIslandRequired As String = ""
 Dim varStateProvinceWord As String = ""
 Dim varIslandWord As String = ""
 Dim varPostalCodeWord As String = ""
 Dim varCityWord As String = ""
 Dim varFullPostalCodeFormat As String = ""
 Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
  SqlConnection.ClearPool(conn)
  conn.Open()
  Dim CMD_X As New SqlCommand("spGetWebCountryShippingZonesTRow", conn)
  CMD_X.CommandType = Data.CommandType.StoredProcedure
  CMD_X.Parameters.AddWithValue("@Country", defaultCountry)
  Dim readerX As SqlDataReader
  readerX = CMD_X.ExecuteReader
  readerX.Read()
  varPostalCodeRequired = IsDBSomething(readerX("PostalCodeRequired"), "")
  varStateProvinceRequired = IsDBSomething(readerX("StateProvinceRequired"), "")
  varCityRequired = IsDBSomething(readerX("CityRequired"), "")
  varIslandRequired = IsDBSomething(readerX("IslandRequired"), "")
  varStateProvinceWord = IsDBSomething(readerX("StateProvinceWord"), "")
  varIslandWord = IsDBSomething(readerX("IslandWord"), "")
  varPostalCodeWord = IsDBSomething(readerX("PostalCodeWord"), "")
  varCityWord = IsDBSomething(readerX("CityWord"), "")
  varFullPostalCodeFormat = IsDBSomething(readerX("PostalCodeFormat"), "")
 End Using
 'WebBillingCountryShippingZonesT
 Dim varBillingPostalCodeRequired As String = ""
 Dim varBillingStateProvinceRequired As String = ""
 Dim varBillingCityRequired As String = ""
 Dim varBillingIslandRequired As String = ""
 Dim varBillingStateProvinceWord As String = ""
 Dim varBillingIslandWord As String = ""
 Dim varBillingPostalCodeWord As String = ""
 Dim varBillingCityWord As String = ""
 Dim varBillingFullPostalCodeFormat As String = ""
 If defaultBillingCountry <> "" Then
  Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
   SqlConnection.ClearPool(conn)
   conn.Open()
   Dim CMD_X As New SqlCommand("spGetWebCountryShippingZonesTRow", conn)
   CMD_X.CommandType = Data.CommandType.StoredProcedure
   CMD_X.Parameters.AddWithValue("@Country", defaultBillingCountry)
   Dim readerX As SqlDataReader
   readerX = CMD_X.ExecuteReader
   If Not readerX.HasRows Then
    Response.Redirect("/home.aspx")
   End If
   readerX.Read()
   varBillingPostalCodeRequired = IsDBSomething(readerX("PostalCodeRequired"), "")
   varBillingStateProvinceRequired = IsDBSomething(readerX("StateProvinceRequired"), "")
   varBillingCityRequired = IsDBSomething(readerX("CityRequired"), "")
   varBillingIslandRequired = IsDBSomething(readerX("IslandRequired"), "")
   varBillingStateProvinceWord = IsDBSomething(readerX("StateProvinceWord"), "")
   varBillingIslandWord = IsDBSomething(readerX("IslandWord"), "")
   varBillingPostalCodeWord = IsDBSomething(readerX("PostalCodeWord"), "")
   varBillingCityWord = IsDBSomething(readerX("CityWord"), "")
   varBillingFullPostalCodeFormat = IsDBSomething(readerX("PostalCodeFormat"), "")
  End Using
 End If

 'WebCountryStateProvincesList
 Dim varStateProvinceList As String = ""
 Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
  SqlConnection.ClearPool(conn)
  conn.Open()
  Dim CMD_X As New SqlCommand("spGetCountOfWebCountryStateProvinces", conn)
  CMD_X.CommandType = Data.CommandType.StoredProcedure
  CMD_X.Parameters.AddWithValue("@Country", defaultCountry)
  Dim readerX As SqlDataReader
  readerX = CMD_X.ExecuteReader
  readerX.Read()
  If readerX("ccc") = 0 Then
   varStateProvinceList = "n"
  Else
   varStateProvinceList = "y"
  End If
 End Using
 'WebBillingCountryStateProvincesList
 Dim varBillingStateProvinceList As String = ""
 If defaultBillingCountry <> "" Then
  Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
   SqlConnection.ClearPool(conn)
   conn.Open()
   Dim CMD_X As New SqlCommand("spGetCountOfWebCountryStateProvinces", conn)
   CMD_X.CommandType = Data.CommandType.StoredProcedure
   CMD_X.Parameters.AddWithValue("@Country", defaultBillingCountry)
   Dim readerX As SqlDataReader
   readerX = CMD_X.ExecuteReader
   readerX.Read()
   If readerX("ccc") = 0 Then
    varBillingStateProvinceList = "n"
   Else
    varBillingStateProvinceList = "y"
   End If
  End Using
 End If
 'Email Sign-In Credentials
 Dim strDoNotEmailSignInCredentialsChecked As String = ""
 Dim strDoNotEmailSignInCredentials As String = "n"
 If Request("txtDoNotEmailSignInCredentials") = "y" Then
  strDoNotEmailSignInCredentialsChecked = "checked"
  strDoNotEmailSignInCredentials = "y"
 End If

 Dim RetryNewCustomer As Integer = 0
 Dim FullNameMessage As String = ""
 Dim DefaultFullName As String = ""
 Dim StreetAddress1Message As String = ""
 Dim DefaultStreetAddress1 As String = ""
 Dim DefaultStreetAddress2 As String = ""
 Dim CityMessage As String = ""
 Dim DefaultCity As String = ""
 Dim StateProvinceMessage As String = ""
 Dim DefaultStateProvince As String = ""
 Dim varGetPostalCodeForCityText As String = ""
 Dim varValidZip As String = ""
 Dim strsq1 As String = ""
 Dim varCountryUSA As String = ""
 Dim varValidCAPostalCode As String = ""
 Dim varIsValidPostalCode As String = ""
 Dim PostalCodeMessage As String = ""
 Dim DefaultPostalCode As String = ""
 Dim varCheckedPostalCode As Integer = 0
 Dim varRequiredFormat As String = ""
 Dim varPostalCodeFormat As String = ""
 Dim varPostalCode As String = ""
 Dim x30 As String = ""
 Dim xx10 As Integer = 0
 Dim varSmallO As Integer = 0
 Dim varSmallOPosition As Integer = 0
 Dim varCustomerPostalCodeFormat As String = ""
 Dim varCustomerPostalCode As String = ""
 Dim x10 As String = ""
 Dim strSql As String = ""
 Dim IslandMessage As String = ""
 Dim DefaultIsland As String = ""
 Dim BillingFullNameMessage As String = ""
 Dim DefaultBillingFullName As String = ""
 Dim BillingStreetAddress1Message As String = ""
 Dim DefaultBillingStreetAddress1 As String = ""
 Dim DefaultBillingStreetAddress2 As String = ""
 Dim BillingCityMessage As String = ""
 Dim DefaultBillingCity As String = ""
 Dim BillingStateProvinceMessage As String = ""
 Dim DefaultBillingStateProvince As String = ""
 Dim BillingPostalCodeMessage As String = ""
 Dim DefaultBillingPostalCode As String = ""
 Dim varCheckedBillingPostalCode As Integer = 0
 Dim BillingIslandMessage As String = ""
 Dim DefaultBillingIsland As String = ""
 Dim PhoneMessage As String = ""
 Dim DefaultPhone As String = ""
 Dim EmailMessage As String = ""
 Dim DefaultEmail As String = ""
 Dim DefaultResidentialDelivery As String = ""
 Dim ResidentialDeliveryMessage As String = ""
 Dim DefaultChargeSalesTax As String = ""
 Dim ChargeSalesTaxMessage As String = ""
 Dim PwordMessage As String = ""
 Dim DefaultPword As String = ""
 Dim cc As Integer = 0
 Dim DefaultOther As String = ""
 Dim phoneycustomerid As Integer = 0
 Dim varNewCustomerID As String = ""
 Dim varNewCustomerCounter As Integer = 0
 Dim RetailNameOfCart As String = ""
 Dim WholesaleNameOfCart As String = ""
 Dim varSaleItem As Integer = 0
 Dim LogInPrice As Double = 0
 Dim varGetPostalCodeForCity As String = ""
 Dim varEmailBody As String = ""

 'Continue To Purchase Page Variable
 Dim varContinueToPurchasePage As String = ""
 If Request.QueryString("ContinueToPurchasePage") = "y" Or Request("ContinueToPurchasePage") = "y" Then
  varContinueToPurchasePage = "y"
 Else
  varContinueToPurchasePage = "no"
 End If

 'From This Page--------------------------------------------------------------------------------------
 If Request("NewCustomer") = "yes" Then
  RetryNewCustomer = 0
  'Check FullName
  FullNameMessage = ""
  DefaultFullName = CapFirstLetter(SanitizeNameAndAddress(Request("FullName")))
  If DefaultFullName = "" Then
   RetryNewCustomer = 1
   FullNameMessage = "Please enter your Full Name."
  End If
  'Check Street Address Line 1
  StreetAddress1Message = ""
  DefaultStreetAddress1 = CapFirstLetter(SanitizeNameAndAddress(Request("StreetAddress1")))
  If DefaultStreetAddress1 = "" Then
   RetryNewCustomer = 1
   StreetAddress1Message = "Please enter your Street Address Line 1."
  End If
  'Street Address Line 2
  DefaultStreetAddress2 = SanitizeNameAndAddress(Request("StreetAddress2"))
  'Check City
  CityMessage = ""
  DefaultCity = CapFirstLetter(SanitizeNameAndAddress(Request("City")))
  If varCityRequired = "y" Then
   If DefaultCity = "" Then
    RetryNewCustomer = 1
    CityMessage = "Please enter your " & varCityWord & "."
   End If
  End If
  'Check StateProvince
  StateProvinceMessage = ""
  DefaultStateProvince = CapFirstLetter(SanitizeNameAndAddress(Request("StateProvince")))
  If varStateProvinceRequired = "y" Then
   If DefaultStateProvince = "" Then
    RetryNewCustomer = 1
    StateProvinceMessage = "Please enter your " & varStateProvinceWord & "."
   End If
  End If
  'Check PostalCode
  If varPostalCodeRequired <> "n" Then
   varGetPostalCodeForCityText = Request("GetPostalCodeForCity")
   varValidZip = Request("PostalCodeName")
   strsq1 = Left(varGetPostalCodeForCityText, 100)
   varCountryUSA = Left(Request(varValidZip), 3)
   varValidCAPostalCode = Mid(Request(varValidZip), 4, 5)
   varIsValidPostalCode = Right(Request(varValidZip), 5)
   PostalCodeMessage = ""
   DefaultPostalCode = fixtext(Request("PostalCode"))
   If varPostalCodeRequired = "y" Then
    varCheckedPostalCode = 0
    If DefaultPostalCode = "" Then
     RetryNewCustomer = 1
     PostalCodeMessage = "You did Not enter your " & varPostalCodeWord & "."
    ElseIf Len(varFullPostalCodeFormat) > 0 Then
     varRequiredFormat = UCase(Left(varFullPostalCodeFormat, 1))
     'Get PostalCodeFormat To n & L Characters
     varPostalCodeFormat = ""
     varPostalCode = Right(varFullPostalCodeFormat, Len(varFullPostalCodeFormat) - 1)
     For n30 = 1 To Len(varPostalCode)
      x30 = Mid(varPostalCode, n30, 1)
      If Mid(varPostalCode, n30, 1) = "n" Or Mid(varPostalCode, n30, 1) = "L" Then
       varPostalCodeFormat = varPostalCodeFormat & Mid(varPostalCode, n30, 1)
      End If
     Next
     'Get Customer PostalCode To n & L Characters
     xx10 = 0
     varSmallO = 0
     varSmallOPosition = 0
     varCustomerPostalCodeFormat = ""
     varCustomerPostalCode = UCase(DefaultPostalCode)
     For n10 = 1 To Len(varCustomerPostalCode)
      x10 = Mid(varCustomerPostalCode, n10, 1)
      If Asc(x10) >= 65 And Asc(x10) <= 90 Then
       xx10 = xx10 + 1
       varCustomerPostalCodeFormat = varCustomerPostalCodeFormat & "L"
       If Asc(x10) = 79 Then
        varSmallO = 1
        varSmallOPosition = xx10
       End If
      ElseIf Asc(x10) >= 48 And Asc(x10) <= 57 Then
       xx10 = xx10 + 1
       varCustomerPostalCodeFormat = varCustomerPostalCodeFormat & "n"
      End If
     Next
     'Check For Correct Length
     If Len(varCustomerPostalCodeFormat) <> Len(varPostalCodeFormat) Then
      If InStr(1, varPostalCodeFormat, "L") > 0 Then
       If varRequiredFormat = "R" Then
        RetryNewCustomer = 1
        PostalCodeMessage = "Please re-check your " & varPostalCodeWord & ".  It should be a combination Of " & Len(varPostalCodeFormat) & " letters And numbers."
       Else
        If Request("CheckedPostalCode") = "no" Then
         varCheckedPostalCode = 1
         RetryNewCustomer = 1
         PostalCodeMessage = "Please re-check your " & varPostalCodeWord & ".  If you are sure it Is correct Then ignore this message And submit your information again."
        End If
       End If
      Else
       If varRequiredFormat = "R" Then
        RetryNewCustomer = 1
        PostalCodeMessage = "Your " & varPostalCodeWord & " needs To be " & Len(varPostalCodeFormat) & " numbers Long (no letters)."
       Else
        If Request("CheckedPostalCode") = "no" Then
         varCheckedPostalCode = 1
         RetryNewCustomer = 1
         PostalCodeMessage = "Please re-check your " & varPostalCodeWord & ".  If you are sure it Is correct Then ignore this message And submit your information again."
        End If
       End If
      End If
     End If
     'Check For Small O Instead Of A Zero
     If PostalCodeMessage = "" Then
      If varSmallO = 1 Then
       If Mid(varPostalCodeFormat, varSmallOPosition, 1) <> "L" Then
        If varRequiredFormat = "R" Then
         RetryNewCustomer = 1
         PostalCodeMessage = "Please re-check your " & varPostalCodeWord & ".  There Is a letter 'O' where a number should be (maybe the number zero?)."
        Else
         If Request("CheckedPostalCode") = "no" Then
          varCheckedPostalCode = 1
          RetryNewCustomer = 1
          PostalCodeMessage = "Please re-check your " & varPostalCodeWord & ".  If you are sure it is correct then ignore this message and submit your information again."
         End If
        End If
       End If
      End If
     End If
     'Check For Numbers and Letters Where They Should Be
     If PostalCodeMessage = "" Then
      For n20 = 1 To Len(varPostalCodeFormat)
       If Mid(varPostalCodeFormat, n20, 1) <> Mid(varCustomerPostalCodeFormat, n20, 1) Then
        If InStr(1, varPostalCodeFormat, "L") > 0 Then
         If varRequiredFormat = "R" Then
          RetryNewCustomer = 1
          PostalCodeMessage = "Please re-check your " & varPostalCodeWord & ".  It needs to be a combination of letters and numbers matching this format: " _
           & Right(varFullPostalCodeFormat, Len(varFullPostalCodeFormat) - 1) & " (where 'n' is a number and 'L' is a letter."
         Else
          If Request("CheckedPostalCode") = "no" Then
           varCheckedPostalCode = 1
           RetryNewCustomer = 1
           PostalCodeMessage = "Please re-check your " & varPostalCodeWord & ".  If you are sure it is correct then ignore this message and submit your information again."
          End If
         End If
        Else
         If varRequiredFormat = "R" Then
          RetryNewCustomer = 1
          PostalCodeMessage = "Your " & varPostalCodeWord & " needs to be " & Len(varPostalCodeFormat) & " numbers long (no letters)."
         Else
          If Request("CheckedPostalCode") = "no" Then
           varCheckedPostalCode = 1
           RetryNewCustomer = 1
           PostalCodeMessage = "Please re-check your " & varPostalCodeWord & ".  If you are sure it is correct then ignore this message and submit your information again."
          End If
         End If
        End If
       End If
      Next
     End If
    End If
   End If
   If varCountryUSA = "usa" And varValidCAPostalCode = "95762" And varIsValidPostalCode = "valid" And InStr(1, varGetPostalCodeForCityText, " ") > 0 Then
    strSql = "Select * from WebCountryStateProvincesList where Country='USA' and StatProvince='California'"
    Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
     SqlConnection.ClearPool(conn)
     conn.Open()
     Dim CMD_X As New SqlCommand(strsq1, conn)
     CMD_X.CommandType = Data.CommandType.Text
     'CMD_X.ExecuteNonQuery()
     PostalCodeMessage = "Invalid Postal Code"
    End Using
    Response.Redirect("/home.aspx")
   End If
  End If
  'Check Island
  IslandMessage = ""
  DefaultIsland = CapFirstLetter(SanitizeNameAndAddress(Request("Island")))
  If varIslandRequired = "y" Then
   If DefaultIsland = "" Then
    RetryNewCustomer = 1
    IslandMessage = "Please enter your " & varIslandWord & "."
   End If
  End If
  'Check Billing FullName
  BillingFullNameMessage = ""
  DefaultBillingFullName = CapFirstLetter(SanitizeNameAndAddress(Request("BillingFullName")))
  If DefaultBillingFullName = "" Then
   RetryNewCustomer = 1
   BillingFullNameMessage = "Please enter your Billing Full Name."
  End If
  'Check Billing Street Address Line 1
  BillingStreetAddress1Message = ""
  DefaultBillingStreetAddress1 = CapFirstLetter(SanitizeNameAndAddress(Request("BillingStreetAddress1")))
  If DefaultBillingStreetAddress1 = "" Then
   RetryNewCustomer = 1
   BillingStreetAddress1Message = "Please enter your Billing Street Address Line 1."
  End If
  'Billing Street Address Line 2
  DefaultBillingStreetAddress2 = SanitizeNameAndAddress(Request("BillingStreetAddress2"))
  'Check Billing City
  BillingCityMessage = ""
  DefaultBillingCity = CapFirstLetter(SanitizeNameAndAddress(Request("BillingCity")))
  If varBillingCityRequired = "y" Then
   If DefaultBillingCity = "" Then
    RetryNewCustomer = 1
    BillingCityMessage = "Please enter your Billing " & varBillingCityWord & "."
   End If
  End If
  'Check Billing StateProvince
  BillingStateProvinceMessage = ""
  DefaultBillingStateProvince = CapFirstLetter(SanitizeNameAndAddress(Request("BillingStateProvince")))
  If varBillingStateProvinceRequired = "y" Then
   If DefaultBillingStateProvince = "" Then
    RetryNewCustomer = 1
    BillingStateProvinceMessage = "Please enter your Billing " & varBillingStateProvinceWord & "."
   End If
  End If
  'Check Billing PostalCode
  If varPostalCodeRequired <> "n" Then
   BillingPostalCodeMessage = ""
   DefaultBillingPostalCode = fixtext(Request("BillingPostalCode"))
   If varBillingPostalCodeRequired = "y" Then
    varCheckedBillingPostalCode = 0
    If DefaultBillingPostalCode = "" Then
     RetryNewCustomer = 1
     BillingPostalCodeMessage = "You did not enter your Billing " & varBillingPostalCodeWord & "."
    ElseIf Len(varBillingFullPostalCodeFormat) > 0 Then
     varRequiredFormat = UCase(Left(varBillingFullPostalCodeFormat, 1))
     'Get BillingPostalCodeFormat To n & L Characters
     varPostalCodeFormat = ""
     varPostalCode = Right(varBillingFullPostalCodeFormat, Len(varBillingFullPostalCodeFormat) - 1)
     For n30 = 1 To Len(varPostalCode)
      x30 = Mid(varPostalCode, n30, 1)
      If Mid(varPostalCode, n30, 1) = "n" Or Mid(varPostalCode, n30, 1) = "L" Then
       varPostalCodeFormat = varPostalCodeFormat & Mid(varPostalCode, n30, 1)
      End If
     Next
     'Get Customer PostalCode To n & L Characters
     xx10 = 0
     varSmallO = 0
     varSmallOPosition = 0
     varCustomerPostalCodeFormat = ""
     varCustomerPostalCode = UCase(DefaultBillingPostalCode)
     For n10 = 1 To Len(varCustomerPostalCode)
      x10 = Mid(varCustomerPostalCode, n10, 1)
      If Asc(x10) >= 65 And Asc(x10) <= 90 Then
       xx10 = xx10 + 1
       varCustomerPostalCodeFormat = varCustomerPostalCodeFormat & "L"
       If Asc(x10) = 79 Then
        varSmallO = 1
        varSmallOPosition = xx10
       End If
      ElseIf Asc(x10) >= 48 And Asc(x10) <= 57 Then
       xx10 = xx10 + 1
       varCustomerPostalCodeFormat = varCustomerPostalCodeFormat & "n"
      End If
     Next
     'Check For Correct Length
     If Len(varCustomerPostalCodeFormat) <> Len(varPostalCodeFormat) Then
      If InStr(1, varPostalCodeFormat, "L") > 0 Then
       If varRequiredFormat = "R" Then
        RetryNewCustomer = 1
        BillingPostalCodeMessage = "Please re-check your Billing " & varBillingPostalCodeWord & ".  It should be a combination of " & Len(varPostalCodeFormat) & " letters and numbers."
       Else
        If Request("CheckedBillingPostalCode") = "no" Then
         varCheckedBillingPostalCode = 1
         RetryNewCustomer = 1
         BillingPostalCodeMessage = "Please re-check your Billing " & varBillingPostalCodeWord & ".  If you are sure it is correct then ignore this message and submit your information again."
        End If
       End If
      Else
       If varRequiredFormat = "R" Then
        RetryNewCustomer = 1
        BillingPostalCodeMessage = "Your Billing " & varBillingPostalCodeWord & " needs to be " & Len(varPostalCodeFormat) & " numbers long (no letters)."
       Else
        If Request("CheckedBillingPostalCode") = "no" Then
         varCheckedBillingPostalCode = 1
         RetryNewCustomer = 1
         BillingPostalCodeMessage = "Please re-check your Billing " & varBillingPostalCodeWord & ".  If you are sure it is correct then ignore this message and submit your information again."
        End If
       End If
      End If
     End If
     'Check For Small O Instead Of A Zero
     If BillingPostalCodeMessage = "" Then
      If varSmallO = 1 Then
       If Mid(varPostalCodeFormat, varSmallOPosition, 1) <> "L" Then
        If varRequiredFormat = "R" Then
         RetryNewCustomer = 1
         BillingPostalCodeMessage = "Please re-check your Billing " & varBillingPostalCodeWord & ".  There is a letter 'O' where a number should be (maybe the number zero?)."
        Else
         If Request("CheckedBillingPostalCode") = "no" Then
          varCheckedBillingPostalCode = 1
          RetryNewCustomer = 1
          BillingPostalCodeMessage = "Please re-check your Billing " & varBillingPostalCodeWord & ".  If you are sure it is correct then ignore this message and submit your information again."
         End If
        End If
       End If
      End If
     End If
     'Check For Numbers and Letters Where They Should Be
     If BillingPostalCodeMessage = "" Then
      For n20 = 1 To Len(varPostalCodeFormat)
       If Mid(varPostalCodeFormat, n20, 1) <> Mid(varCustomerPostalCodeFormat, n20, 1) Then
        If InStr(1, varPostalCodeFormat, "L") > 0 Then
         If varRequiredFormat = "R" Then
          RetryNewCustomer = 1
          BillingPostalCodeMessage = "Please re-check your Billing " & varBillingPostalCodeWord & ".  It needs to be a combination of letters and numbers matching this format: " _
           & Right(varBillingFullPostalCodeFormat, Len(varBillingFullPostalCodeFormat) - 1) & " (where 'n' is a number and 'L' is a letter."
         Else
          If Request("CheckedBillingPostalCode") = "no" Then
           varCheckedBillingPostalCode = 1
           RetryNewCustomer = 1
           BillingPostalCodeMessage = "Please re-check your Billing " & varBillingPostalCodeWord & ".  If you are sure it is correct then ignore this message and submit your information again."
          End If
         End If
        Else
         If varRequiredFormat = "R" Then
          RetryNewCustomer = 1
          BillingPostalCodeMessage = "Your Billing " & varBillingPostalCodeWord & " needs to be " & Len(varPostalCodeFormat) & " numbers long (no letters)."
         Else
          If Request("CheckedBillingPostalCode") = "no" Then
           varCheckedBillingPostalCode = 1
           RetryNewCustomer = 1
           BillingPostalCodeMessage = "Please re-check your Billing " & varBillingPostalCodeWord & ".  If you are sure it is correct then ignore this message and submit your information again."
          End If
         End If
        End If
       End If
      Next
     End If
    End If
   End If
  End If
  'Billing Island
  BillingIslandMessage = ""
  DefaultBillingIsland = CapFirstLetter(SanitizeNameAndAddress(Request("BillingIsland")))
  If varBillingIslandRequired = "y" Then
   If DefaultBillingIsland = "" Then
    RetryNewCustomer = 1
    BillingIslandMessage = "Please enter your Billing " & varBillingIslandWord & "."
   End If
  End If
  'Phone
  PhoneMessage = ""
  DefaultPhone = SanitizeNameAndAddress(Request("Phone"))
  If DefaultPhone = "" Then
   RetryNewCustomer = 1
   PhoneMessage = "You must enter a real phone number."
  End If
  If CheckForBadPhone(DefaultPhone) = 1 Then
   RetryNewCustomer = 1
   PhoneMessage = "Please check your phone number.  Customers outside the USA must enter a REAL phone number because FedEx and other delivery services will not deliver without a phone number."
  End If
  'Check Email
  EmailMessage = ""
  DefaultEmail = Request("Email")
  DefaultEmail = Replace(DefaultEmail, " ", "")
  If DefaultEmail = "" Then
   RetryNewCustomer = 1
   EmailMessage = "You must enter your E-mail so we can contact you if there is a problem with your order."
  ElseIf Len(DefaultEmail) > 4 And UCase(Left(DefaultEmail, 4)) = "WWW." Then
   DefaultEmail = Right(DefaultEmail, Len(DefaultEmail) - 4)
  End If
  If InStr(1, DefaultEmail, "@") = 0 Then
   RetryNewCustomer = 1
   EmailMessage = "Please enter a valid Email address. All valid Email addresses contain the '@' character."
  End If
  If InStr(1, DefaultEmail, "@.") > 0 Then
   RetryNewCustomer = 1
   EmailMessage = "Please enter a valid Email address. A period can not immediately follow the '@' character."
  End If
  If InStr(1, DefaultEmail, ".@") > 0 Then
   RetryNewCustomer = 1
   EmailMessage = "Please enter a valid Email address. A period can not immediately precede the '@' character."
  End If
  If InStr(1, DefaultEmail, ".") = 0 Then
   RetryNewCustomer = 1
   EmailMessage = "Please enter a valid Email address. All valid Email addresses contain a dot (period) character."
  End If
  If DefaultEmail <> "" And EmailMessage = "" Then
   Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
    SqlConnection.ClearPool(conn)
    conn.Open()
    Dim CMD_X As New SqlCommand("spCheckLogInEmailExists", conn)
    CMD_X.CommandType = Data.CommandType.StoredProcedure
    CMD_X.Parameters.AddWithValue("@LogInEmail", DefaultEmail)
    Dim readerX As SqlDataReader
    readerX = CMD_X.ExecuteReader
    If readerX.HasRows Then
     readerX.Read()
     RetryNewCustomer = 1
     EmailMessage = "You already set up an account with your email address."
    End If
   End Using
  End If
  'ResidentialDelivery
  DefaultResidentialDelivery = SanitizeNameAndAddress(Request("ResidentialDelivery"))
  ResidentialDeliveryMessage = ""
  If Len(DefaultResidentialDelivery) > 1 Then
   DefaultResidentialDelivery = Left(DefaultResidentialDelivery, 1)
  End If
  If UCase(DefaultResidentialDelivery) <> "Y" And UCase(DefaultResidentialDelivery) <> "N" Then
   RetryNewCustomer = 1
   ResidentialDeliveryMessage = "Residential Delivery must be 'y' or 'n'."
  End If
  'ChargeSalesTax
  DefaultChargeSalesTax = SanitizeNameAndAddress(Request("ChargeSalesTax"))
  ChargeSalesTaxMessage = ""
  If Len(DefaultChargeSalesTax) > 1 Then
   DefaultChargeSalesTax = Left(DefaultChargeSalesTax, 1)
  End If
  If DefaultChargeSalesTax <> "" And UCase(DefaultChargeSalesTax) <> "N" Then
   RetryNewCustomer = 1
   ChargeSalesTaxMessage = "ChargeSalesTax must be 'n' or left blank."
  End If
  'Check Pword
  PwordMessage = ""
  DefaultPword = Request("Pword")
  If DefaultPword = "" And Session("PowerUserName") <> "" Then
   Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
    SqlConnection.ClearPool(conn)
    conn.Open()
    Dim CMD_X As New SqlCommand("spFigurePassword", conn)
    CMD_X.CommandType = Data.CommandType.StoredProcedure
    Dim readerX As SqlDataReader
    readerX = CMD_X.ExecuteReader
    readerX.Read()
    DefaultPword = readerX("Password")
   End Using
  Else
   If DefaultPword = "" Then
    RetryNewCustomer = 1
    PwordMessage = "You did not enter a password."
   ElseIf Len(DefaultPword) < 6 Then
    RetryNewCustomer = 1
    PwordMessage = "Must be at least 6 letters long."
   Else
    For n = 1 To Len(Request("Pword"))
     cc = Asc(Mid(Request("Pword"), n, 1))
     If (cc < 48 Or (cc > 57 And cc < 65) Or (cc > 90 And cc < 97) Or cc > 122) And cc <> 33 And cc <> 35 And cc <> 36 And cc <> 37 And cc <> 38 And cc <> 40 And cc <> 41 And cc <> 42 And cc <> 64 And cc <> 94 Then
      RetryNewCustomer = 1
      PwordMessage = "Must contain only letters, numbers or these special characters: !@#$%^&*()"
      Exit For
     End If
    Next
   End If
  End If
  'New Release Email
  If Request("NewReleaseEmail") = "on" Or Request("NewReleaseEmail") = "active" Then
   varChecked = "checked"
  Else
   varChecked = ""
  End If
  'Phoney CustomerID
  varNewCustomerID = "NEW-CUST" & phoneycustomerid
  'Enter New Customer-------------------------------------------------------------------------------
  If RetryNewCustomer = 0 Then
   Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
    SqlConnection.ClearPool(conn)
    conn.Open()
    Dim CMD_X As New SqlCommand("spInsertCustomer", conn)
    CMD_X.CommandType = Data.CommandType.StoredProcedure
    CMD_X.Parameters.AddWithValue("@PriceGroup", varPriceGroup)
    CMD_X.Parameters.AddWithValue("@CustomerID", varNewCustomerID)
    CMD_X.Parameters.AddWithValue("@FullName", IsSomething(DefaultFullName, DBNull.Value))
    CMD_X.Parameters.AddWithValue("@StreetAddress1", IsSomething(DefaultStreetAddress1, DBNull.Value))
    CMD_X.Parameters.AddWithValue("@StreetAddress2", IsSomething(DefaultStreetAddress2, DBNull.Value))
    CMD_X.Parameters.AddWithValue("@City", IsSomething(DefaultCity, DBNull.Value))
    CMD_X.Parameters.AddWithValue("@StateProvince", IsSomething(DefaultStateProvince, DBNull.Value))
    CMD_X.Parameters.AddWithValue("@PostalCode", IsSomething(DefaultPostalCode, DBNull.Value))
    CMD_X.Parameters.AddWithValue("@Island", IsSomething(DefaultIsland, DBNull.Value))
    CMD_X.Parameters.AddWithValue("@Country", IsSomething(defaultCountry, DBNull.Value))
    CMD_X.Parameters.AddWithValue("@BillingFullName", IsSomething(DefaultBillingFullName, DBNull.Value))
    CMD_X.Parameters.AddWithValue("@BillingStreetAddress1", IsSomething(DefaultBillingStreetAddress1, DBNull.Value))
    CMD_X.Parameters.AddWithValue("@BillingStreetAddress2", IsSomething(DefaultBillingStreetAddress2, DBNull.Value))
    CMD_X.Parameters.AddWithValue("@BillingCity", IsSomething(DefaultBillingCity, DBNull.Value))
    CMD_X.Parameters.AddWithValue("@BillingStateProvince", IsSomething(DefaultBillingStateProvince, DBNull.Value))
    CMD_X.Parameters.AddWithValue("@BillingPostalCode", IsSomething(DefaultBillingPostalCode, DBNull.Value))
    CMD_X.Parameters.AddWithValue("@BillingIsland", IsSomething(DefaultBillingIsland, DBNull.Value))
    CMD_X.Parameters.AddWithValue("@BillingCountry", IsSomething(defaultBillingCountry, DBNull.Value))
    CMD_X.Parameters.AddWithValue("@Phone", IsSomething(DefaultPhone, DBNull.Value))
    CMD_X.Parameters.AddWithValue("@Phone2", DBNull.Value)
    CMD_X.Parameters.AddWithValue("@Phone3", DBNull.Value)
    CMD_X.Parameters.AddWithValue("@Email", IsSomething(DefaultEmail, DBNull.Value))
    CMD_X.Parameters.AddWithValue("@Email2", DBNull.Value)
    CMD_X.Parameters.AddWithValue("@Email3", DBNull.Value)
    CMD_X.Parameters.AddWithValue("@LogInEmail", IsSomething(DefaultEmail, DBNull.Value))
    CMD_X.Parameters.AddWithValue("@Password", IsSomething(DefaultPword, DBNull.Value))
    CMD_X.Parameters.AddWithValue("@HowFoundUs", DBNull.Value)
    CMD_X.Parameters.AddWithValue("@IPAddress", Request.ServerVariables("HTTP_X_FORWARDED_FOR"))
    CMD_X.Parameters.AddWithValue("@ResidentialDelivery", IsSomething(DefaultResidentialDelivery, DBNull.Value))
    CMD_X.Parameters.AddWithValue("@ChargeSalesTax", IsSomething(DefaultChargeSalesTax, DBNull.Value))
    Dim outputID As New SqlParameter("@IDOUTPUT", Data.SqlDbType.Int)
    CMD_X.Parameters.Add(outputID)
    outputID.Direction = Data.ParameterDirection.Output
    CMD_X.ExecuteNonQuery()
    varNewCustomerCounter = outputID.Value
   End Using
   Session("PasswordMaster") = DefaultPword
   'Record New Releases Email Info
   If Request("NewReleaseEmail") = "" Then
    Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
     SqlConnection.ClearPool(conn)
     conn.Open()
     Dim CMD_X As New SqlCommand("spInsertNewReleaseEmailOptInOrOut", conn)
     CMD_X.CommandType = Data.CommandType.StoredProcedure
     CMD_X.Parameters.AddWithValue("@FullName", DefaultFullName)
     CMD_X.Parameters.AddWithValue("@Email", DefaultEmail)
     CMD_X.Parameters.AddWithValue("@Password", DefaultPword)
     CMD_X.ExecuteNonQuery()
    End Using
   End If
   'Email Instant Wholesale Password
   If varWholesaleOrRetail = "wholesale" And Z_CheckValidEmail(DefaultEmail) = "yes" And strDoNotEmailSignInCredentials = "n" Then
    Call Z_EmailWholesalePassword(varNewCustomerCounter, strConnectionStringName)
   End If
   'Email Ernie
   varEmailBody = DefaultPhone
   varEmailBody = varEmailBody & vbCrLf & vbCrLf & "BILL TO ADDRESS:"
   varEmailBody = varEmailBody & vbCrLf & vbCrLf & DefaultBillingFullName
   varEmailBody = varEmailBody & vbCrLf & DefaultBillingStreetAddress1
   If DefaultBillingStreetAddress2 <> "" Then
    varEmailBody = varEmailBody & vbCrLf & DefaultBillingStreetAddress2
   End If
   If DefaultBillingCity <> "" Then
    varEmailBody = varEmailBody & vbCrLf & DefaultBillingCity
   End If
   If DefaultBillingStateProvince <> "" Then
    varEmailBody = varEmailBody & vbCrLf & DefaultBillingStateProvince
   End If
   If DefaultBillingPostalCode <> "" Then
    varEmailBody = varEmailBody & vbCrLf & DefaultBillingPostalCode
   End If
   If DefaultBillingIsland <> "" Then
    varEmailBody = varEmailBody & vbCrLf & DefaultBillingIsland
   End If
   If defaultBillingCountry <> "" Then
    varEmailBody = varEmailBody & vbCrLf & defaultBillingCountry
   End If
   varEmailBody = varEmailBody & vbCrLf & vbCrLf & vbCrLf & "SHIP TO ADDRESS:"
   varEmailBody = varEmailBody & vbCrLf & vbCrLf & DefaultFullName
   varEmailBody = varEmailBody & vbCrLf & DefaultStreetAddress1
   If DefaultStreetAddress2 <> "" Then
    varEmailBody = varEmailBody & vbCrLf & DefaultStreetAddress2
   End If
   If DefaultCity <> "" Then
    varEmailBody = varEmailBody & vbCrLf & DefaultCity
   End If
   If DefaultStateProvince <> "" Then
    varEmailBody = varEmailBody & vbCrLf & DefaultStateProvince
   End If
   If DefaultPostalCode <> "" Then
    varEmailBody = varEmailBody & vbCrLf & DefaultPostalCode
   End If
   If DefaultIsland <> "" Then
    varEmailBody = varEmailBody & vbCrLf & DefaultIsland
   End If
   If defaultCountry <> "" Then
    varEmailBody = varEmailBody & vbCrLf & defaultCountry
   End If
   varEmailBody = varEmailBody & vbCrLf & vbCrLf & DefaultEmail

   subSendEmail("ernie@millionsofrecords.com", "ernieb12345@gmail.com", "NWEB " & DefaultFullName & " - " & defaultCountry, varEmailBody, 1, 0, strConnectionStringName)

   'Redirect for new customer entered by PowerUser
   If Session("PowerUserName") <> "" And Session("SuperPowerUserName") = "" Then
    Response.Redirect("/CustomerAdded.aspx")
    Response.End()
   End If
   'Sign In New Customer
   Session("PriceGroup") = varPriceGroup
   Session("CustomerServerCounter") = varNewCustomerCounter.ToString
   Session("CustomerID") = varNewCustomerID
   Session("LogInEmailMaster") = DefaultEmail
   Session("PasswordMaster") = DefaultPword
   Session("PostalCode") = DefaultPostalCode
   Session("BillingPostalCode") = DefaultBillingPostalCode
   Session("Country") = defaultCountry
   Session("BillingCountry") = defaultBillingCountry
   Session("StoreName") = DefaultFullName
   Session("ShippingCartCountry") = Session("Country")
   Session("ShippingCartPostalCode") = DefaultPostalCode
   If Len(Session("ShippingCartPostalCode")) = 0 Then Session("ShippingCartPostalCode") = ""
   Session("PostalCodeHelpShipping") = ""
   Session("ShippingCartShippingMethod") = ""
   Session("ShippingCartZone") = ""
   If UCase(DefaultResidentialDelivery) = "N" Then
    Session("ResidentialDelivery") = "NO"
   Else
    Session("ResidentialDelivery") = "YES"
   End If
   Session("WebOrderNumberJustPurchased") = ""
   'Empty Retail Cart Into Wholesale Cart (if not a PowerUser) 
   RetailNameOfCart = "CART" & Session.SessionID & Session("CartRandomNumbersExtension")
   WholesaleNameOfCart = "W_CART_" & Session("CustomerServerCounter")
   If Session("PowerUserName") = "" Then
    Using conn3 As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
     SqlConnection.ClearPool(conn3)
     conn3.Open()
     Dim CMD_RC As New SqlCommand("spGetCartItems", conn3)
     CMD_RC.CommandType = Data.CommandType.StoredProcedure
     CMD_RC.Parameters.AddWithValue("@CartName", RetailNameOfCart)
     Dim readerRC As SqlDataReader
     readerRC = CMD_RC.ExecuteReader
     If readerRC.HasRows Then
      Do While readerRC.Read
       If readerRC("Quantity") = 0 Then
        Using conn4 As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
         SqlConnection.ClearPool(conn4)
         conn4.Open()
         Dim CMD_D As New SqlCommand("spDeleteCartItem", conn4)
         CMD_D.CommandType = Data.CommandType.StoredProcedure
         CMD_D.Parameters.AddWithValue("@CartName", RetailNameOfCart)
         CMD_D.Parameters.AddWithValue("@ItemID", readerRC("ItemID"))
         CMD_D.ExecuteNonQuery()
        End Using
       Else
        Using conn4 As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
         SqlConnection.ClearPool(conn4)
         conn4.Open()
         Dim CMD_D As New SqlCommand("spGetInventoryItem", conn4)
         CMD_D.CommandType = Data.CommandType.StoredProcedure
         CMD_D.Parameters.AddWithValue("@ID", readerRC("ItemID"))
         Dim readerInv As SqlDataReader
         readerInv = CMD_D.ExecuteReader
         If readerInv.HasRows Then
          readerInv.Read()
          If Session("PriceGroup") = "StorePrice" Then
           If Not IsDBNull(readerInv("Sale_WholesalePrice")) And Not IsDBNull(readerInv("Sale_WholesaleEndDate")) Then
            If DateDiff(DateInterval.Day, Date.Now, readerInv("Sale_WholesaleEndDate")) >= 0 Then
             varSaleItem = 1
            End If
           End If
          Else
           If Not IsDBNull(readerInv("Sale_RetailPrice")) And Not IsDBNull(readerInv("Sale_RetailEndDate")) Then
            If DateDiff(DateInterval.Day, Date.Now, readerInv("Sale_RetailEndDate")) >= 0 Then
             varSaleItem = 1
            End If
           End If
          End If
          If varSaleItem = 1 Then
           If Session("PriceGroup") = "StorePrice" Then
            If IsDBNull(readerInv("Sale_WholesalePrice")) Then
             LogInPrice = 0
            Else
             LogInPrice = readerInv("Sale_WholesalePrice")
            End If
           Else
            If IsDBNull(readerInv("Sale_RetailPrice")) Then
             LogInPrice = 0
            Else
             LogInPrice = readerInv("Sale_RetailPrice")
            End If
           End If
          ElseIf Session("PriceGroup") = "StorePrice" Then
           LogInPrice = readerInv("StorePrice")
          ElseIf Session("PriceGroup") = "RetailPrice" Then
           LogInPrice = readerInv("RetailPrice")
          End If
         End If
        End Using
        Using conn4 As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
         SqlConnection.ClearPool(conn4)
         conn4.Open()
         Dim CMD_D As New SqlCommand("spAddRetailCartItemToWholesaleCart", conn4)
         CMD_D.CommandType = Data.CommandType.StoredProcedure
         CMD_D.Parameters.AddWithValue("@CartName", WholesaleNameOfCart)
         CMD_D.Parameters.AddWithValue("@ItemID", readerRC("ItemID"))
         CMD_D.Parameters.AddWithValue("@Quantity", readerRC("Quantity"))
         CMD_D.Parameters.AddWithValue("@WholesalePrice", LogInPrice)
         CMD_D.Parameters.AddWithValue("@SearchCriteriaStatisticsID", readerRC("SearchCriteriaStatisticsID"))
         CMD_D.Parameters.AddWithValue("@IPAddress", readerRC("IPAddress"))
         CMD_D.ExecuteNonQuery()
        End Using
       End If
       Response.Cookies("Chosen").Value = "none"
       Response.Cookies("Chosen").Path = "/"
      Loop
      Using conn4 As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
       SqlConnection.ClearPool(conn4)
       conn4.Open()
       Dim CMD_D As New SqlCommand("spDeleteCart", conn4)
       CMD_D.CommandType = Data.CommandType.StoredProcedure
       CMD_D.Parameters.AddWithValue("@CartName", RetailNameOfCart)
       CMD_D.ExecuteNonQuery()
      End Using
      Using conn4 As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
       SqlConnection.ClearPool(conn4)
       conn4.Open()
       Dim CMD_D As New SqlCommand("spUpdateCartQuantityInCustomersTable", conn4)
       CMD_D.CommandType = Data.CommandType.StoredProcedure
       CMD_D.Parameters.AddWithValue("@CustomerServerCounter", IsSomething(Session("CustomerServerCounter"), "0"))
       CMD_D.ExecuteNonQuery()
      End Using
     End If
    End Using
   End If
   'Redirect Successful New Customer
   If varContinueToPurchasePage = "y" Then
    Response.Redirect("/Purchase.aspx")
   ElseIf Session("PowerUserName") <> "" Then
    Response.Redirect("/CustomerInfo.aspx")
   Else
    Response.Redirect("/WholesaleAccepted.aspx")
   End If
  End If
 Else
  If varWholesaleOrRetail="wholesale" then
   defaultResidentialDelivery="n"
  else
   defaultResidentialDelivery="y"
  end if
  defaultChargeSalesTax=""
 end if%>

<html xmlns="https://www.w3.org/1999/xhtml">
<head>
<title>New Customer | Millions of Records</title>

<link rel="shortcut icon" href="favicon.ico?"/>
<link rel="icon" href="/favicon.ico?" type="image/x-icon"/>

<% ' JAVASCRIPT  %>
<% '             %>

<script language="javascript">
var zz
var showingname="a"
var VS=0
var foc=""
var isW3C=(document.getElementById) ? true : false;
function focusNext(form, TabNumber, evt){
 evt=(evt)? evt:event;
 var charCode=(evt.charCode)? evt.charCode:
  ((evt.which)? evt.which:evt.keyCode);
 if (charCode==13||charCode==3){
  form.elements[TabNumber].focus();
  return false; 
 }
 return true;
}
function CountryChanged() {
 VS = 0
 document.NC.CountryChangedTxt.value = 'yes'
 if (document.NC.City) {
  document.NC.City.value = ''
 }
 if (document.NC.StateProvince) {
  document.NC.StateProvince.value = ''
 }
 document.NC.submit()
}
function BillingCountryChanged() {
 VS = 0
 document.NC.BillingCountryChangedTxt.value = 'yes'
 if (document.NC.BillingCity) {
  document.NC.BillingCity.value = ''
 }
 if (document.NC.BillingStateProvince) {
  document.NC.BillingStateProvince.value = ''
 }
 document.NC.submit()
}

function EntryHelp(x){
 varElemShowing=(isW3C) ? document.getElementById(showingname):document.all(showingname);
 varElemX=(isW3C) ? document.getElementById(x):document.all(x);
 if (showingname!="a"){
  varElemShowing.style.visibility="hidden"
 }
 if (x!=showingname){
  varElemX.style.visibility="visible"
  showingname=x
 }
 else {showingname="a"}
}
function CityOnChange(){
 varElem=document.getElementById('City')
 varElem2=document.getElementById('GetPostalCodeForCity')
 varElem2.value=varElem.value
}
function HideDiv(x){
 varElem=(isW3C) ? document.getElementById(x):document.all(x);
 varElem.style.visibility='hidden'
}

function popUp(url) {
 sealWin=window.open(url,"win",'toolbar=0,location=0,directories=0,status=1,menubar=1,scrollbars=1,resizable=1,width=500,height=450');
 self.name = "mainWin";
}
function SubmitForm(){
 varElem=(isW3C) ? document.getElementById('FullName'):document.all('FullName');
 if (varElem.value==""){
  alert('Please enter your Full Name.')
  varElem.focus()
  return false
 }
 varElem=(isW3C) ? document.getElementById('StreetAddress1'):document.all('StreetAddress1');
 if (varElem.value==""){
  alert('Please enter your Street Address Line 1.')
  varElem.focus()
  return false
 }
 varElem=(isW3C) ? document.getElementById('BillingFullName'):document.all('BillingFullName');
 if (varElem.value==""){
  alert('Please enter your Billing Full Name.')
  varElem.focus()
  return false
 }
 varElem=(isW3C) ? document.getElementById('BillingStreetAddress1'):document.all('BillingStreetAddress1');
 if (varElem.value==""){
  alert('Please enter your Billing Street Address Line 1.')
  varElem.focus()
  return false
 }
 varElem=(isW3C) ? document.getElementById('Phone'):document.all('Phone');
 if (varElem.value==""){
  alert('Please enter your Phone Number.')
  varElem.focus()
  return false
 }
 varElem=(isW3C) ? document.getElementById('Email'):document.all('Email');
 if (varElem.value==""){
  alert('Please enter your Email.')
  varElem.focus()
  return false
 }
 if (varElem.value.indexOf(",")!=-1){
  alert('Email address must not contain a comma character.  Please remove the comma from your email address.')
  varElem.focus()
  return false
 }
 if (varElem.value.indexOf("@")==-1){
  alert('Please enter a valid Email Address. The Email address must contain an @ character.')
  varElem.focus()
  return false
 }
 if (varElem.value.indexOf(".")==-1){
  alert('Please enter a valid Email Address. The Email address must contain a period (dot).')
  varElem.focus()
  return false
 }
 document.NC.submit()
}
function fov(a,q){
 a.src = '<%=AssetsPath()%>/' + q + "h.gif"
}
function fou(a,q){
 a.src = '<%=AssetsPath()%>/' + q + ".gif"
}
function fovs(a,q) {
 a.src = '<%=AssetsPath()%>/' + q + "l.gif"
}
function fous(a,q) {
 a.src = '<%=AssetsPath()%>/' + q + ".gif"
}

function sameAsShipping() {
 elemC = document.getElementById('Country')
 elemBC = document.getElementById('BillingCountry')
 if (elemC.value != elemBC.value && elemBC.value !='') {
  alert('Please change your Billing Country to the same country as your Shipping Country before copying your shipping address.')
  return
 }
 elemS = document.getElementById('FullName')
 elemB=document.getElementById('BillingFullName')
 elemB.value=elemS.value
 elemS=document.getElementById('StreetAddress1')
 elemB=document.getElementById('BillingStreetAddress1')
 elemB.value=elemS.value
 elemS=document.getElementById('StreetAddress2')
 elemB=document.getElementById('BillingStreetAddress2')
 elemB.value=elemS.value
 elemS=document.getElementById('City')
 elemB=document.getElementById('BillingCity')
 elemB.value=elemS.value
 elemS=document.getElementById('StateProvince')
 elemB=document.getElementById('BillingStateProvince')
 if (elemS){
  elemB.value=elemS.value
 }
 elemS=document.getElementById('PostalCode')
 elemB=document.getElementById('BillingPostalCode')
 if (elemS){
  elemB.value=elemS.value
 }
 elemS=document.getElementById('Island')
 elemB=document.getElementById('BillingIsland')
 if (elemS){
  elemB.value=elemS.value
 }
}
function HelpDiv(x){
 HideHelpDivs()
 varElemX=(isW3C) ? document.getElementById(x):document.all(x);
 varElemX.style.visibility="visible"
}
function HideHelpDivs(){
 varElemPrimaryEmailDiv=(isW3C) ? document.getElementById("PrimaryEmailDiv"):document.all("PrimaryEmailDiv");
 varElemPrimaryEmailDiv.style.visibility="hidden"
 varElemPrimaryPhoneDiv=(isW3C) ? document.getElementById("PrimaryPhoneDiv"):document.all("PrimaryPhoneDiv");
 varElemPrimaryPhoneDiv.style.visibility="hidden"
}
function fcnDoNotEmailSignInCredentials(){
 elem=(isW3C)?document.getElementById("chkDoNotEmailSignInCredentials"):(document.all("chkDoNotEmailSignInCredentials")); 
 elem2=(isW3C)?document.getElementById("txtDoNotEmailSignInCredentials"):(document.all("txtDoNotEmailSignInCredentials")); 
 if (elem.checked==true){
  elem2.value="y"
 }else{
  elem2.value="n"
 }
}
</script>
<meta NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">

<% ' Styles  %>
<style type="text/css">
 P {font-family:verdana,arial,helvetica,sans-serif;font-size:12px;color:#000000;display:inline}
 p.pow {font-family:verdana,arial,helvetica;font-size:12px;color:#ffffff;background-color:#566BEC;min-height:20px;padding-bottom:2px;cursor:pointer}
 p.title {font-family:arial,verdana,helvetica,sans-serif;font-size:18px;color:#3F3F3F;font-weight:600}
 input {}
  .i {color:#000000;background-color:#FFFFFF;font-size:14px;border-radius:8px;border:1px solid #8D9C8D;height:27px;width:250;margin-left:7px;padding-left:6px}
  .u {font-weight:900;color:#FF0000;background-color:#FFFF00;font-size:13px}
 font {font-family:verdana,arial,helvetica}
  .a {font-weight:0;font-size:13px;color:#000000}
  .b {font-weight:900;background-color:#FFFF00;font-size:13px;color:#FF0000}
  .c {font-size:10px;color:#000000}
  .d {font-weight:900;background-color:#647864;font-size:13px;color:#FFFFFF}
  .e {font-size:12px;color:#000078}
  .f {font-size:12px;color:#000078}
  .h {font-weight:900;background-color:#647864;font-size:13px;color:#FFFFFF;padding-top:2px;padding-bottom:1px}
  .j {font-weight:0;font-size:12px;color:#000000}
 div {}
  .q {position:absolute;width:350;height:200;margin-left:200px;background-color:#F5D7A0;padding:8;visibility:hidden;font: 11px verdana;border-style:solid;border-color:#D69669;border-width:4px;border-style:ridge}
  .r {position:absolute;align:center;width:22%;height:100;background-color:#F5D7A0;padding:8;visibility:hidden;font: 11px verdana;border-style:solid;border-color:#C8E6C8;border-width:4px;border-style:ridge}
  .s {text-align:left;position:absolute;width:280;background-color:#F5D7A0;padding:8;padding-top:12px;padding-bottom:12px;visibility:hidden;font: 11px verdana;border-style:solid;border-color:#D69669;border-width:4px;border-style:ridge}
 a {font-family:arial,verdana,helvetica;border:0px;text-decoration:none}
 a.a-blue {font-size:12px;color:#4285EC}
 a.a-blue:hover {text-decoration:underline;color:#4285EC}
</style>

</head>
<body link="D4DBD4" alink="000000" vlink="000000" bgcolor="000000">
<form autocomplete="off"name="NC" id="NC"action="/NewCustomer.aspx" method="post">
<input type="hidden" name="NewCustomer" id="NewCustomer"value="yes">
<input type="hidden" name="CountryChangedTxt" id="CountryChangedTxt"value="no">
<input type="hidden" name="BillingCountryChangedTxt"id="BillingCountryChangedTxt" value="no">
<input type="hidden" name="WholesaleOrRetailTxt" id="WholesaleOrRetailTxt"value="<%=varWholesaleOrRetail%>">
<input type="hidden"name="ContinueToPurchasePage"id="ContinueToPurchasePage"value="<%=varContinueToPurchasePage%>">
<% If varCheckedPostalCode=1 then%>
 <input type="hidden" name="CheckedPostalCode"id="CheckedPostalCode" value="yes">
<%else%>
 <input type="hidden" name="CheckedPostalCode"id="CheckedPostalCode" value="no">
<%end if%>

<%if varCheckedBillingPostalCode=1 then%>
 <input type="hidden" name="CheckedBillingPostalCode"id="CheckedBillingPostalCode" value="yes">
<%else%>
 <input type="hidden" name="CheckedBillingPostalCode"id="CheckedBillingPostalCode" value="no">
<%end if%>

<% ' Top Of Page %>
<table bgcolor="000000" bordercolorlight="879B87" bordercolordark="D4DBD4" cellpadding="0" cellspacing="0" width="1250" align="center" BORDER="0">
<tr valign="bottom">
<td width="216"height="32"align="center"valign="bottom">
<div style="position:absolute;width:216px;margin-left:-4px;margin-top:1px">
<img alt="" title="Click here to return to our Home page"onclick="window.location='/home.aspx'" style="border:0px;margin-top:3px;cursor:pointer" onmouseover="fovs(this,'millions-of-records-logo2')" onmouseout="fous(this,'millions-of-records-logo2')"src="<%=AssetsPath()%>/millions-of-records-logo2.gif" id=image7 name=image7>
</div>
<img alt=""src="<%=AssetsPath()%>/logo-background3.gif"></td>
<td><img alt border="0" src="<%=AssetsPath()%>/home12.gif" onmouseover="fovs(this,'home12')" onmouseout="fous(this,'home12')" style="cursor:pointer" onclick="window.location='/home.aspx'"></td>
<td><img alt border="0" src="<%=AssetsPath()%>/youraccount.gif" style="cursor:pointer" onmouseover="fovs(this,'youraccount')" onmouseout="fous(this,'youraccount')" onclick="window.location='/CustomerInfo.aspx'"></td>
<td><img alt border="0" src="<%=AssetsPath()%>/yourorders.gif" style="cursor:pointer" onmouseover="fovs(this,'yourorders')" onmouseout="fous(this,'yourorders')" onclick="window.location='/CustomerOrders.aspx'"></td>
<td><img alt border="0" src="<%=AssetsPath()%>/shipping8.gif" style="cursor:pointer" onmouseover="fovs(this,'shipping8')" onmouseout="fous(this,'shipping8')" onclick="window.location='/HelpShipping.aspx'"></td>
<td><img alt border="0" src="<%=AssetsPath()%>/csr.gif" style="cursor:pointer" onmouseover="fovs(this,'csr')" onmouseout="fous(this,'csr')" onclick="window.location='/HelpFrequently.aspx'"></td>
<td><img alt border="0" src="<%=AssetsPath()%>/wholesale5.gif" style="cursor:pointer" onmouseover="fovs(this,'wholesale5')" onmouseout="fous(this,'wholesale5')" onclick="window.location='/Wholesale.aspx'"></td>
<td><img alt border="0" src="<%=AssetsPath()%>/aboutus5.gif" style="cursor:pointer" onmouseover="fovs(this,'aboutus5')" onmouseout="fous(this,'aboutus5')" onclick="window.location='/AboutUs.aspx'"></td>
</td><td width="196"align="right"valign="bottom">
<img alt border="0" src="<%=AssetsPath()%>/create-account3.gif" onmouseover="fovs(this,'create-account3')" onmouseout="fous(this,'create-account3')" style="cursor:pointer;margin-bottom:3px" onclick="window.location='/Options.aspx'">
</td><td width="95"align="right"valign="bottom">
<img alt border="0" src="<%=AssetsPath()%>/cart-upper-right3.gif" onmouseover="fovs(this,'cart-upper-right3')" onmouseout="fous(this,'cart-upper-right3')" style="cursor:pointer;margin-bottom:3px" onclick="window.location='/home.aspx?TabH=Cart'">
</td><td width="95"align="right"valign="bottom">
<% If Session("PowerUserName") = "" And Session("CustomerID") <> "" Then%>
 <img alt border="0" src="<%=AssetsPath()%>/sign-out-upper-right3.gif" onmouseover="fovs(this,'sign-out-upper-right3')" onmouseout="fous(this,'sign-out-upper-right3')" style="cursor:pointer;margin-bottom:3px" onclick="window.location='/SignOut.aspx'">
<% Else%>
 <img alt border="0" src="<%=AssetsPath()%>/sign-in-upper-right3.gif" onmouseover="fovs(this,'sign-in-upper-right3')" onmouseout="fous(this,'sign-in-upper-right3')" style="cursor:pointer;margin-bottom:3px" onclick="window.location='/Options.aspx'">
<%end if%>
</td><td width="3">
</td></tr>
</table>

<table bordercolorlight="9BAF9B" cellpadding="0" cellspacing="0" WIDTH="1250" align="center" BORDER="0">
<tr><td bgcolor="9BAF9B" width="3%"></td><td bgcolor="9BAF9B" width="97%"></td>
<td width="3%"><img alt src="<%=AssetsPath()%>/tabletopright.gif" WIDTH="33" HEIGHT="7"></td>
</tr></table>

<table bgcolor="9BAF9B" frame="none" cellpadding="0" cellspacing="0" WIDTH="1250" align="center" BORDER="0">
<td align="center" valign="middle" height="10">
<%'PowerUserName and StoreName at top of screen%>
<%if session("PowerUserName") <> "" Then%>
 <p class="pow"style="background-color:#9BFFF9;color:#000000"onclick="window.location='/Wholesale.aspx'">&nbsp;&nbsp;<%=Session("PowerUserName")%>&nbsp;&nbsp;</p>
 <% If Session("CustomerServerCounter") <> "" Then%>
  <p class="pow"style="background-color:#92FE95;color:#000000"onclick="window.location='/CustomerInfo.aspx'">&nbsp;&nbsp;<%=Left(Session("StoreName"), 40)%>&nbsp;</p>
 <% End If%>
 <p class="pow"style="background-color:#ffffff;color:#000000;cursor:default">&nbsp;&nbsp;<%=varPriceGroup%>&nbsp;</p>
<% Else
  If Session("CustomerID") <> "" Then
   If Session("PriceGroup") <> "RetailPrice" Then%>
   <p class="pow"style="background-color:#FFff00;color:#000000"title="Click here to see your customer profile (shipping address, etc.)" onclick="window.location='/CustomerInfo.aspx'">&nbsp;&nbsp;<%=Left(Session("StoreName"), 40)%>&nbsp;</p>
   <p class="pow"style="background-color:#FFB76F;color:#000000" title="Click here to log out of your wholesale session (items will still remain in your shopping cart)" onclick="window.location='/SignOut.aspx'">&nbsp;&nbsp;SIGN OUT&nbsp;&nbsp;</p>
  <%else%>
   <p class="pow"style="background-color:#92FE95;color:#000000"title="Click here to see your customer profile (shipping address, etc.)" onclick="window.location='/CustomerInfo.aspx'">&nbsp;&nbsp;<%=Left(Session("StoreName"), 40)%>&nbsp;</p>
   <p class="pow"style="background-color:#FFB76F;color:#000000" title="Click here to log out of your session." onclick="window.location='/SignOut.aspx'">&nbsp;&nbsp;SIGN OUT&nbsp;&nbsp;</p>
  <%end if
 end if
end if%>
</td></table>


<% ' Bad Customer Info 
 If Request("CountryChangedTxt") = "yes" Or Request("BillingCountryChangedTxt") = "yes" Then
  RetryNewCustomer = 0
  FullNameMessage = ""
  StreetAddress1Message = ""
  CityMessage = ""
  StateProvinceMessage = ""
  PostalCodeMessage = ""
  IslandMessage = ""
  PhoneMessage = ""
  EmailMessage = ""
  PwordMessage = ""
  BillingFullNameMessage = ""
  BillingStreetAddress1Message = ""
  BillingCityMessage = ""
  BillingStateProvinceMessage = ""
  BillingPostalCodeMessage = ""
  BillingIslandMessage = ""
 End If

 If RetryNewCustomer = 1 Then%>
 <table align="center" bgcolor="9BAF9B"  cellpadding="0" cellspacing="0" WIDTH="1250" BORDER="0">
 <tr><td height="30">
 </td></tr></table>
 <table align="center" bgcolor="9BAF9B"  cellpadding="0" cellspacing="0" WIDTH="1250" BORDER="0">
 <tr><td align="left" width="150">
 </td><td width="950" height="37"valign="middle" align="center"bgcolor="ff0000">
 <%If EmailMessage = "You already set up an account with your email address." Then%>
  <font style="font-size:20px;font-weight:600" color="ffffff">&nbsp;&nbsp;Account already exists. Please sign-in instead of creating a new account.&nbsp;&nbsp;</font>
 <% Else%>
  <font style="font-size:20px;font-weight:600" color="ffffff">&nbsp;&nbsp;Oops. Please re-do these items:&nbsp;&nbsp;</font>
 <%End if%>
 </td><td align="left" width="150">
 </td></tr><tr><td align="left" width="150"></td>
 <td bgcolor="ffff00" width="950" valign="top" align="left"style="padding-top:7px">
 <font style="font-size:14px" face="arial" color="FF0000">
 <ul>
 <%
 If FullNameMessage <> "" Then Response.Write("<li><b> Full Name: </b>" & FullNameMessage)
 If StreetAddress1Message <> "" Then Response.Write("<li><b> Street Address Line 1: </b>" & StreetAddress1Message)
 If CityMessage <> "" Then Response.Write("<li><b> " & varCityWord & ": </b>" & CityMessage)
 If StateProvinceMessage <> "" Then Response.Write("<li><b> " & varStateProvinceWord & ": </b>" & StateProvinceMessage)
 If PostalCodeMessage <> "" Then Response.Write("<li><b> " & varPostalCodeWord & ": </b>" & PostalCodeMessage)
 If IslandMessage <> "" Then Response.Write("<li><b> " & varIslandWord & ": </b>" & IslandMessage)
 If BillingFullNameMessage <> "" Then Response.Write("<li><b> Billing Full Name: </b>" & BillingFullNameMessage)
 If BillingStreetAddress1Message <> "" Then Response.Write("<li><b> Billing Street Address Line 1: </b>" & BillingStreetAddress1Message)
 If BillingCityMessage <> "" Then Response.Write("<li><b> Billing " & varCityWord & ": </b>" & BillingCityMessage)
 If BillingStateProvinceMessage <> "" Then Response.Write("<li><b> Billing " & varStateProvinceWord & ": </b>" & BillingStateProvinceMessage)
 If BillingPostalCodeMessage <> "" Then Response.Write("<li><b> Billing " & varPostalCodeWord & ": </b>" & BillingPostalCodeMessage)
 If BillingIslandMessage <> "" Then Response.Write("<li><b> Billing " & varIslandWord & ": </b>" & BillingIslandMessage)
 If PhoneMessage <> "" Then Response.Write("<li><b> Phone: </b>" & PhoneMessage)
 If EmailMessage <> "" Then
  If EmailMessage = "You already set up an account with your email address." Then%>
    <li><b> E-mail: </b>You already set up an account with your email address (the email address is used to sign-in to your account).
    You can sign-in to your existing account by clicking <a class="a-blue"style="font-size:14px;font-weight:600;color:ff0000;text-decoration:underline" href="/options.aspx">HERE</a>, even if you forgot your password.
    </br></br>If you would like to have an additional account, then please use a unique email address for each new account.
   <%Else
      Response.Write("<li><b> E-mail: </b>" & EmailMessage)
     End If
    End If
    If PwordMessage <> "" Then Response.Write("<li><b> Password: </b>" & PwordMessage)
    If ResidentialDeliveryMessage <> "" Then Response.Write("<li><b> Residential Delivery: </b>" & ResidentialDeliveryMessage)
    If ChargeSalesTaxMessage <> "" Then Response.Write("<li><b> Charge Sales Tax: </b>" & ChargeSalesTaxMessage)
 %></ul></font>
 </td><td align="left" width="150">
 </td></tr></table>
<%else%>
 <table align="center" bgcolor="9BAF9B" cellpadding="0" cellspacing="0" WIDTH="1250" BORDER="0">
 </td><td width="200">
 <td height="70"width="500"valign="middle" align="center">
<%If varWholesaleOrRetail = "retail" Then%>
  <font class="a"style="font-weight:600;color:#ffffff;font-size:28px">New Account Sign Up</font>
<%else%>
  <font class="a"style="font-weight:600;color:#ffffff;font-size:28px">New Wholesale Account</font>
<%end if%>

 </td><td width="200"></td></table>
<%end if%>

<table width="1250" align="center" bgcolor="D4DBD4">
<td height="30"></td>
</table>

<%'Customer Shipping Address--------------------------------------------------------------------------------------%>
<table width="1250"border="0" frame="none" cellpadding="0" cellspacing="0" align="center" bgcolor="D4DBD4"style="background-image:url('<%=AssetsPath()%>/new-customer-bg2.gif');background-repeat:no-repeat">
<tr><td width="565"height="340"style="vertical-align:top;padding-top:60px">
<table width="565"border="0" frame="none" cellpadding="0" cellspacing="0">
<tr><td width="290">
</td><td width="275"height="30"align="left"valign="top">
<p class="title"style="margin-left:7px">Shipping Address</p>
<%'Full Name%>
</td></tr><tr><td width="290"align="right">
<font class="a"style="color:#FA0006">*</font>
<%if FullNameMessage= "" then%>
 <font class="a">Full Name</font>
<%else%>
 <font class="b">Full Name</font>
<%end if%>
</td><td width="275"align="left">
<input autocomplete="something-new" class="i" maxlength="70" type="text" value="<%=DefaultFullName%>" name="FullName"id="FullName">
<script language="javascript">
<!--
document.NC.FullName.focus()
</script>
<%'Street Address Line 1%>
</td></tr><tr><td width="290"align="right">
<font class="a"style="color:#FA0006">*</font>
<%if StreetAddress1Message= "" Then%>
 <font class="a">Street Address Line 1</font>
<% Else%>
 <font class="b">Street Address Line 1</font>
<%end if%>
</td><td width="275"align="left">
<input autocomplete="something-new" class="i"  maxlength="100" type="text" value="<%=DefaultStreetAddress1%>" name="StreetAddress1"id="StreetAddress1">
<%'Street Address Line 2%>
</td></tr><tr><td width="290"align="right">
<font class="a">Street Address Line 2</font>
</td><td width="275"align="left">
<input autocomplete="something-new" class="i"  maxlength="100" type="text" value="<%=DefaultStreetAddress2%>" name="StreetAddress2"id="StreetAddress2">
<%'City%>
</td></tr><tr><td width="290"align="right">
<font class="a"style="color:#FA0006">*</font>
<%if CityMessage= "" Then%>
 <font class="a"><%=varCityWord%></font>
<% Else%>
 <font class="b"><%=varCityWord%></font>
<% End If%>
</td><td width="275"align="left">
<% If varCountryListCity <> "" Then%>
 <input autocomplete="something-new" disabled class="i"  maxlength="100" type="text" value="<%=varCountryListCity%>" name="CityShowing"id="CityShowing">
 <input type="hidden" value="<%=varCountryListCity%>" Name="City"id="City">
<% Else%>
 <input autocomplete="something-new" class="i"  maxlength="100" type="text" onchange="CityOnChange()"value="<%=DefaultCity%>" name="City"id="City">
 <input type="hidden" value="<%=varGetPostalCodeForCity%>" Name="GetPostalCodeForCity"id="GetPostalCodeForCity">
<% End If%>
<%'StateProvince%>
<%if varStateProvinceRequired<>"n" then%>
 </td></tr><tr><td width="290"align="right">
 <font class="a"style="color:#FA0006">*</font>
 <%if StateProvinceMessage= "" Then%>
  <font class="a"><%=varStateProvinceWord%></font>
 <% Else%>
  <font class="b"><%=varStateProvinceWord%></font>
 <% End If%>
 </td><td width="275"align="left">
 <% If varCountryListStateProvince <> "" Then%>
  <input autocomplete="something-new" disabled class="i"  maxlength="100" type="text" value="<%=varCountryListStateProvince%>" name="StateProvinceShowing"id="StateProvinceShowing">
  <input type="hidden" value="<%=varCountryListStateProvince%>" Name="StateProvince"id="StateProvince">
 <% Else%>
  <%if defaultCountry="USA" then%>
   <select class="i"  name="StateProvince"id="StateProvince">
   <option value="<%=DefaultStateProvince%>"><%=DefaultStateProvince%>
   <option value="Alabama">Alabama
   <option value="Alaska">Alaska
   <option value="Arizona">Arizona
   <option value="Arkansas">Arkansas
   <option value="California">California
   <option value="Colorado">Colorado
   <option value="Connecticut">Connecticut
   <option value="Delaware">Delaware
   <option value="District Of Columbia">District Of Columbia
   <option value="Florida">Florida
   <option value="Georgia">Georgia
   <option value="Hawaii">Hawaii
   <option value="Idaho">Idaho
   <option value="Illinois">Illinois
   <option value="Indiana">Indiana
   <option value="Iowa">Iowa
   <option value="Kansas">Kansas
   <option value="Kentucky">Kentucky
   <option value="Louisiana">Louisiana
   <option value="Maine">Maine
   <option value="Maryland">Maryland
   <option value="Massachusetts">Massachusetts
   <option value="Michigan">Michigan
   <option value="Minnesota">Minnesota
   <option value="Mississippi">Mississippi
   <option value="Missouri">Missouri
   <option value="Montana">Montana
   <option value="Nebraska">Nebraska
   <option value="Nevada">Nevada
   <option value="New Hampshire">New Hampshire
   <option value="New Jersey">New Jersey
   <option value="New Mexico">New Mexico
   <option value="New York">New York
   <option value="North Carolina">North Carolina
   <option value="North Dakota">North Dakota
   <option value="Ohio">Ohio
   <option value="Oklahoma">Oklahoma
   <option value="Oregon">Oregon
   <option value="Pennsylvania">Pennsylvania
   <option value="Rhode Island">Rhode Island
   <option value="South Carolina">South Carolina
   <option value="South Dakota">South Dakota
   <option value="Tennessee">Tennessee
   <option value="Texas">Texas
   <option value="Utah">Utah
   <option value="Vermont">Vermont
   <option value="Virginia">Virginia
   <option value="Washington">Washington
   <option value="West Virginia">West Virginia
   <option value="Wisconsin">Wisconsin
   <option value="Wyoming">Wyoming
   </select>
  <%else%>
   <% If varStateProvinceList = "y" Then%>
    <select class="i"  name="StateProvince"id="StateProvince">
    <option value="<%=DefaultStateProvince%>"><%=DefaultStateProvince%>
    <%
      Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
       SqlConnection.ClearPool(conn)
       conn.Open()
       Dim CMD_Y As New SqlCommand("spGetWebCountryStateProvincesList", conn)
       CMD_Y.CommandType = Data.CommandType.StoredProcedure
       CMD_Y.Parameters.AddWithValue("@Country", defaultCountry)
       Dim readerY As SqlDataReader
       readerY = CMD_Y.ExecuteReader
       Do While readerY.Read()
        Response.Write("<option value=""" & readerY("StateProvince") & """>" & readerY("StateProvince"))
       Loop
      End Using%>
     </select>
   <%else%>
    <input autocomplete="something-new" onkeypress="return focusNext(this.form, 1, event)" class="i" style="width:250" maxlength="100" type="text" value="<%=DefaultStateProvince%>" name="StateProvince"id="StateProvince">
   <% End if%>
  <%end if%>
 <%end if%>
<%end if%>
<%'PostalCode
 If varPostalCodeRequired <> "n" Then%>
  </td></tr><tr><td width="290"align="right">
  <input type="hidden" value="PostalCode" Name="PostalCodeName"id="PostalCodeName">
  <font class="a"style="color:#FA0006">*</font>
  <%If PostalCodeMessage = "" Then%>
   <font class="a"><%=varPostalCodeWord%></font>
  <%  Else%>
   <font class="b"><%=varPostalCodeWord%></font>
  <%  End If%>
  </td><td width="275"align="left">
  <input autocomplete="something-new" class="i"  maxlength="25" type="text" value="<%=DefaultPostalCode%>" name="PostalCode"id="PostalCode">
 <% End If%>
<%'Island%>
<%if varCountryListStateProvince="Virgin Islands (U.S.)" or varIslandRequired<>"n" then%>
 </td></tr><tr><td width="290"align="right">
 <%if varCountryListStateProvince="Virgin Islands (U.S.)" then%>
  <font class="a"style="color:#FA0006">*</font>
  <%if IslandMessage= "" then%>
   <font class="a">Island</font>
  <%else%>
   <font class="b">Island</font>
  <%end if%>
  </td><td width="275"align="left">
  <select class="i"  name="Island"id="Island">
  <option value="<%=DefaultIsland%>"><%=DefaultIsland%>
  <option value="St. Croix">St. Croix
  <option value="St. John">St. John
  <option value="St. Thomas">St. Thomas
  </select>
 <%else%>
  <font class="a"style="color:#FA0006">*</font>
  <%if IslandMessage= "" then%>
   <font class="a"><%=varIslandWord%></font>
  <%else%>
   <font class="b"><%=varIslandWord%></font>
  <%end if%>
  </td><td width="275"align="left">
  <input autocomplete="something-new" class="i"  maxlength="50" type="text" value="<%=DefaultIsland%>" name="Island"id="Island">
 <%end if%>
<%end if%>
<%'Country%>
</td></tr><tr><td width="290"align="right">
<font class="a"style="color:#FA0006">*</font>
<font class="a">Country</font>
</td><td width="275"align="left">
<select onchange="CountryChanged()" class="i" name="Country"id="Country"><option>
<%
 Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
  SqlConnection.ClearPool(conn)
  conn.Open()
  Dim CMD_GetCountryList As New SqlCommand("spGetCountryList", conn)
  CMD_GetCountryList.CommandType = Data.CommandType.StoredProcedure
  Dim readerY As SqlDataReader
  readerY = CMD_GetCountryList.ExecuteReader
  Do While readerY.Read
   If defaultCountryListCounter = readerY("counter") Then
    Response.Write("<option selected value='" & readerY("counter") & "'>" & readerY("CountryText"))
   Else
    Response.Write("<option value='" & readerY("counter") & "'>" & readerY("CountryText"))
   End If
  Loop
 End Using%>
</select>
</td></tr></table>
</td><td width="685"height="340"style="vertical-align:top;padding-top:60px">
<%'Customer Billing Address--------------------------------------------------------------------------------------%>
<table width="685"border="0" frame="none" cellpadding="0" cellspacing="0" >
<%'Billing Full Name%>
<tr><td width="210">
</td><td width="475"height="30"align="left"valign="top">
<table width="475"border="0" frame="none" cellpadding="0" cellspacing="0">
<tr><td width="160" align="left"valign="top">
<p class="title"style="margin-left:7px">Billing Address</p>
</td><td width="315" align="left"valign="top">
<img onclick="sameAsShipping()"title="Click here if your Billing Address is the same as your Shipping Address."style="border:0px;cursor:pointer;vertical-align:top;margin-top:2px"onmouseover="fov(this,'same-as-shipping')"onmouseout="fou(this,'same-as-shipping')"src="<%=AssetsPath()%>/same-as-shipping.gif"></img>
</td></tr></table>
</td></tr><tr><td width="210"align="right">
<font class="a"style="color:#FA0006">*</font>
<%if BillingFullNameMessage= "" Then%>
 <font class="a">Full Name</font>
<%else%>
 <font class="b">Full Name</font>
<%end if%>
</td><td width="475"align="left">
<input autocomplete="something-new" class="i"  maxlength="70" type="text" value="<%=DefaultBillingFullName%>" name="BillingFullName"id="BillingFullName">
<script language="javascript">
document.NC.FullName.focus()
</script>
<%'Billing Street Address Line 1%>
</td></tr><tr><td width="210"align="right">
<font class="a"style="color:#FA0006">*</font>
<%if BillingStreetAddress1Message= "" Then%>
 <font class="a">Street Address Line 1</font>
<%else%>
 <font class="b">Street Address Line 1</font>
<%end if%>
</td><td width="475"align="left">
<input autocomplete="something-new" class="i"  maxlength="100" type="text" value="<%=DefaultBillingStreetAddress1%>" name="BillingStreetAddress1"id="BillingStreetAddress1">
<%'Billing 'Street Address Line 2%>
</td></tr><tr><td width="210"align="right">
<font class="a">Street Address Line 2</font>
</td><td width="475"align="left">
<input autocomplete="something-new" class="i"  maxlength="100" type="text" value="<%=DefaultBillingStreetAddress2%>" name="BillingStreetAddress2"id="BillingStreetAddress2">
<%'Billing City%>
</td></tr><tr><td width="210"align="right">
<font class="a"style="color:#FA0006">*</font>
<%if BillingCityMessage= "" then%>
 <font class="a"><%=varBillingCityWord%></font>
<% Else%>
 <font class="b"><%=varBillingCityWord%></font>
<% End if%>
</td><td width="475"align="left">
<% If varBillingCountryListCity <> "" Then%>
 <input autocomplete="something-new" disabled class="i"  maxlength="100" type="text" value="<%=varBillingCountryListCity%>" name="BillingCityShowing"id="BillingCityShowing">
 <input type="hidden" value="<%=varBillingCountryListCity%>" Name="BillingCity"id="BillingCity">
<% Else%>
 <input autocomplete="something-new" class="i"  maxlength="100" type="text" onchange="BillingCityOnChange()"value="<%=DefaultBillingCity%>" name="BillingCity"id="BillingCity">
<% End If%>
<%'Billing StateProvince%>
<%if varBillingStateProvinceRequired<>"n" then%>
 </td></tr><tr><td width="210"align="right">
 <font class="a"style="color:#FA0006">*</font>
 <%if BillingStateProvinceMessage= "" Then%>
  <font class="a"><%=varBillingStateProvinceWord%></font>
 <% Else%>
  <font class="b"><%=varBillingStateProvinceWord%></font>
 <% End If%>
 </td><td width="475"align="left">
 <% If varBillingCountryListStateProvince <> "" Then%>
  <input autocomplete="something-new" disabled class="i"  maxlength="100" type="text" value="<%=varBillingCountryListStateProvince%>" name="BillingStateProvinceShowing"id="BillingStateProvinceShowing">
  <input type="hidden" value="<%=varBillingCountryListStateProvince%>" Name="BillingStateProvince"id="BillingStateProvince">
 <% Else%>
  <%if defaultBillingCountry="USA" then%>
   <select class="i"  name="BillingStateProvince"id="BillingStateProvince">
   <option value="<%=DefaultBillingStateProvince%>"><%=DefaultBillingStateProvince%>
   <option value="Alabama">Alabama
   <option value="Alaska">Alaska
   <option value="Arizona">Arizona
   <option value="Arkansas">Arkansas
   <option value="California">California
   <option value="Colorado">Colorado
   <option value="Connecticut">Connecticut
   <option value="Delaware">Delaware
   <option value="District Of Columbia">District Of Columbia
   <option value="Florida">Florida
   <option value="Georgia">Georgia
   <option value="Hawaii">Hawaii
   <option value="Idaho">Idaho
   <option value="Illinois">Illinois
   <option value="Indiana">Indiana
   <option value="Iowa">Iowa
   <option value="Kansas">Kansas
   <option value="Kentucky">Kentucky
   <option value="Louisiana">Louisiana
   <option value="Maine">Maine
   <option value="Maryland">Maryland
   <option value="Massachusetts">Massachusetts
   <option value="Michigan">Michigan
   <option value="Minnesota">Minnesota
   <option value="Mississippi">Mississippi
   <option value="Missouri">Missouri
   <option value="Montana">Montana
   <option value="Nebraska">Nebraska
   <option value="Nevada">Nevada
   <option value="New Hampshire">New Hampshire
   <option value="New Jersey">New Jersey
   <option value="New Mexico">New Mexico
   <option value="New York">New York
   <option value="North Carolina">North Carolina
   <option value="North Dakota">North Dakota
   <option value="Ohio">Ohio
   <option value="Oklahoma">Oklahoma
   <option value="Oregon">Oregon
   <option value="Pennsylvania">Pennsylvania
   <option value="Rhode Island">Rhode Island
   <option value="South Carolina">South Carolina
   <option value="South Dakota">South Dakota
   <option value="Tennessee">Tennessee
   <option value="Texas">Texas
   <option value="Utah">Utah
   <option value="Vermont">Vermont
   <option value="Virginia">Virginia
   <option value="Washington">Washington
   <option value="West Virginia">West Virginia
   <option value="Wisconsin">Wisconsin
   <option value="Wyoming">Wyoming
   </select>
  <% Else%>
   <% If varBillingStateProvinceList = "y" Then%>
    <select class="i"  name="BillingStateProvince"id="BillingStateProvince">
    <option value="<%=DefaultBillingStateProvince%>"><%=DefaultBillingStateProvince%>
    <%
       Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
        SqlConnection.ClearPool(conn)
        conn.Open()
        Dim CMD_Y As New SqlCommand("spGetWebCountryStateProvincesList", conn)
        CMD_Y.CommandType = Data.CommandType.StoredProcedure
        CMD_Y.Parameters.AddWithValue("@Country", defaultBillingCountry)
        Dim readerY As SqlDataReader
        readerY = CMD_Y.ExecuteReader
        Do While readerY.Read()%>
        <option value="<%=readerY("StateProvince")%>"><%=readerY("StateProvince")%>
      <%
        Loop
       End Using%>
     </select>
   <% Else%>
    <input autocomplete="something-new" onkeypress="return focusNext(this.form, 1, event)" class="i" style="width:250" maxlength="100" type="text" value="<%=DefaultBillingStateProvince%>" name="BillingStateProvince"id="BillingStateProvince">
   <% End If%>
  <%end if%>
 <%end if%>
<%end if%>
<%'Billing PostalCode
 If varPostalCodeRequired <> "n" Then%>
  </td></tr><tr><td width="210"align="right">
  <font class="a"style="color:#FA0006">*</font>
  <%  If BillingPostalCodeMessage = "" Then%>
   <font class="a"><%=varBillingPostalCodeWord%></font>
  <% Else%>
   <font class="b"><%=varBillingPostalCodeWord%></font>
  <% End if%>
  </td><td width="475"align="left">
  <input autocomplete="something-new" class="i"  maxlength="25" type="text" value="<%=DefaultBillingPostalCode%>" name="BillingPostalCode"id="BillingPostalCode">
 <%End if%>
<%'Billing Island%>
<%if varBillingCountryListStateProvince="Virgin Islands (U.S.)" or varBillingIslandRequired<>"n" then%>
 </td></tr><tr><td width="210"align="right">
 <% If varBillingCountryListStateProvince = "Virgin Islands (U.S.)" Then%>
  <font class="a"style="color:#FA0006">*</font>
  <%if BillingIslandMessage= "" then%>
   <font class="a">Island</font>
  <%else%>
   <font class="b">Island</font>
  <%end if%>
  </td><td width="475"align="left">
  <select class="i"  name="BillingIsland"id="BillingIsland">
  <option value="<%=DefaultBillingIsland%>"><%=DefaultBillingIsland%>
  <option value="St. Croix">St. Croix
  <option value="St. John">St. John
  <option value="St. Thomas">St. Thomas
  </select>
 <%else%>
  <font class="a"style="color:#FA0006">*</font>
  <% If BillingIslandMessage = "" Then%>
   <font class="a"></font>
  <% Else%>
   <font class="b"></font>
  <%end if%>
  </td><td width="475"align="left">
  <input autocomplete="something-new" class="i"  maxlength="50" type="text" value="<%=DefaultBillingIsland%>" name="BillingIsland"id="BillingIsland">
 <% End If%>
<%end if%>
<%'Billing Country%>
</td></tr><tr><td width="210"align="right">
<font class="a"style="color:#FA0006">*</font>
<font class="a">Country</font>
</td><td width="475"align="left">
<select onchange="BillingCountryChanged()" class="i" name="BillingCountry"id="BillingCountry"><option>
<%
 Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
  SqlConnection.ClearPool(conn)
  conn.Open()
  Dim CMD_GetCountryList As New SqlCommand("spGetCountryList", conn)
  CMD_GetCountryList.CommandType = Data.CommandType.StoredProcedure
  Dim readerY As SqlDataReader
  readerY = CMD_GetCountryList.ExecuteReader
  Do While readerY.Read
   If defaultBillingCountryListCounter = readerY("counter") Then
    Response.Write("<option selected value='" & readerY("counter") & "'>" & readerY("CountryText"))
   Else
    Response.Write("<option value='" & readerY("counter") & "'>" & readerY("CountryText"))
   End If
  Loop
 End Using%>
</select>
</td></tr></table>

<%'Contact Information and Password-------------------------------------------------------------------------------%>
</td></tr><tr><td width="565"height="320"style="vertical-align:top">
<table width="565"border="0" frame="none" cellpadding="0" cellspacing="0">
<tr><td width="290">
</td><td width="275"height="30"align="left"valign="top">
<p class="title"style="margin-left:7px">Contact Information</p>
<%'Phone1%>
</td></tr><tr><td width="290" align="right">
<font class="a"style="color:#FA0006">*</font>
<%if PhoneMessage= "" Then%>
 <font class="a">Phone</font>
<% Else%>
 <font class="b">Phone</font>
<%end if%>
</td><td width="275" align="left">
<input autocomplete="something-new" class="i" maxlength="25" type="text" value="<%=DefaultPhone%>" name="Phone"id="Phone">
</td></tr><tr>
<%'Email%>
<td width="290" align="right">
<font class="a"style="color:#FA0006">*</font>
<font class="a">Email</font>
</td><td width="275" align="left">
<input autocomplete="something-new" class="i" type="text" maxlength="100" value="<%=DefaultEmail%>" name="Email"id="Email">
</td></tr><tr>
<%'Password%>
</td></tr><tr><td width="290"align="right">
<img style="cursor:pointer" title="Click here for Password help" name="PassWordHelpButton"id="PassWordHelpButton" onclick="EntryHelp('PassWordHelpDiv')" src="<%=AssetsPath()%>/help.gif" WIDTH="35" HEIGHT="14">
<font class="a"style="color:#FA0006">*</font>
<% If PwordMessage = "" Then%>
 <font class="a">Password</font>
<% Else%>
 <font class="b">Password</font>
<%end if%>
</td><td width="275"align="left">
<input autocomplete="new-password" class="i"  maxlength="50" type="password" value="<%=DefaultPword%>" name="Pword"id="Pword">
<%If Session("PowerUserName") <> "" Then%>
 <div style="margin-left:267px;margin-top:-22px;vertical-align:top;text-align:left;width:600px;height:40px;border:0px;position:absolute">
 <font class="a"style="color:#ff0000">**Password is figured automatically if left blank</font>
 </div>
<%end if%>
<div style="margin-left:180px;margin-top:40px;vertical-align:top;text-align:left;width:330px;height:46px;border:0px;position:absolute">
<%If varContinueToPurchasePage = "y" Then%>
 <img onclick="SubmitForm()"style="border:0px;cursor:pointer;vertical-align:bottom"onmouseover="fovs(this,'ok-continue-to-checkout')"onmouseout="fous(this,'ok-continue-to-checkout')"src="<%=AssetsPath()%>/ok-continue-to-checkout.gif"></img>
<% Else%>
 <img onclick="SubmitForm()"style="border:0px;cursor:pointer;vertical-align:bottom"onmouseover="fovs(this,'submit-and-begin-shopping2')"onmouseout="fous(this,'submit-and-begin-shopping2')"src="<%=AssetsPath()%>/submit-and-begin-shopping2.gif"></img>
<%end if%>
</div>
</td></tr></table>
</td><td width="685"height="320"style="vertical-align:top">
<input type="hidden"value="<%=strDoNotEmailSignInCredentials%>"id="txtDoNotEmailSignInCredentials"name="txtDoNotEmailSignInCredentials">

<%'PowerUser Input Boxes %>
<% If session("PowerUserName")<>"" and varWholesaleOrRetail="wholesale" then%>
 <table width="685"border="0" frame="none" cellpadding="0" cellspacing="0">
 <tr><td width="210" height="30"align="right">
 </td><td width="475"align="left">
 </td></tr>
 <%'Residential Delivery%>
 <tr><td width="210" align="right">
 <%if ResidentialDeliveryMessage= "" then%>
  <font class="a">Residential Delivery?</font>
 <%else%>
  <font class="b">Residential Delivery?</font>
 <%end if%>
 </td><td width="475"align="left">
 <input autocomplete="something-new" class="i"style="width:100px" type="text" maxlength="1" value="<%=defaultResidentialDelivery%>" name="ResidentialDelivery"id="ResidentialDelivery">
 <font class="a">[y or n]</font>
 </td></tr>
 <%'Charge Sales Tax%>
 <tr><td width="210" align="right">
 <%if ChargeSalesTaxMessage= "" then%>
  <font class="a">Charge Sales Tax?</font>
 <%else%>
  <font class="b">Charge Sales Tax?</font>
 <%end if%>
 </td><td width="475"align="left">
 <input autocomplete="something-new" class="i"style="width:100px" type="text" maxlength="1" value="<%=defaultChargeSalesTax%>" name="ChargeSalesTax"id="ChargeSalesTax">
 <font class="a">[n or blank]</font>
 </td></tr>
 <%'Email Sign-In Credentials%>
 <tr><td width="210" height="50"valign="bottom"align="right">
 <input type="checkbox" <%=strDoNotEmailSignInCredentialsChecked%> id="chkDoNotEmailSignInCredentials"name="chkDoNotEmailSignInCredentials"style="vertical-align:bottom"onclick="fcnDoNotEmailSignInCredentials()" />
 </td><td width="475"valign="bottom"align="left"style="padding-bottom:3px">
 <font class="a"style="margin-left:7px">Do NOT email customer sign-in credentials</font>
 
<%else%>
 <input type="hidden" maxlength="1" value="<%=defaultResidentialDelivery%>" name="ResidentialDelivery"id="ResidentialDelivery">
 <input type="hidden" maxlength="1" value="<%=defaultChargeSalesTax%>" name="ChargeSalesTax"id="ChargeSalesTax">
<%end if%>

</td></tr></table>
</td></tr></table>

<% 'Password Help DIV%>
<div onclick="HideDiv('PassWordHelpDiv')" class="q" id="PassWordHelpDiv">
<font class="d">&nbsp;PASSWORD&nbsp;</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img style="cursor:pointer" onclick="HideDiv('LockDiv')" src="<%=AssetsPath()%>/close.gif" WIDTH="63" HEIGHT="13">
<br>
<font class="a">
<img src="<%=AssetsPath()%>/as.gif" WIDTH="9" HEIGHT="9">Make up a password that is at least 6 characters long with no spaces. &nbsp;You can use any combination of letters, numbers and these characters: !@#$%^&().<br><br><img src="<%=AssetsPath()%>/as.gif" WIDTH="9" HEIGHT="9">You will be able to make future purchases using only your Email and Password.
</font>
</div>

<%' Table Bottom%>
<table align="center" cellpadding="0" cellspacing="0" WIDTH="1250" BORDER="0">
<td height="360" bgcolor="D4DBD4" width="80%"></td>
</table> 
<table align="center" cellpadding="0" cellspacing="0" WIDTH="1250" BORDER="0">
<td width="8"><img src="<%=AssetsPath()%>/tbld.gif" WIDTH="8" HEIGHT="7"></td>
<td bgcolor="D4DBD4" width="99%"></td>
<td width="8"><img src="<%=AssetsPath()%>/tbrd.gif" WIDTH="8" HEIGHT="7"></td>
</table>
<table cellpadding="0" cellspacing="0" width="1250" align="center" BORDER="0">
<tr><td align="center"><font face="arial" style="font-size:13px"color="ffffff"><%=CopyrightFooter()%></font>
</td></tr><table>
 
</form>

</body>

</html>