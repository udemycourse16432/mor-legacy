
<%@ Page Language="VB" Debug="true" AutoEventWireup="false" EnableViewState="false" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "https://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

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

 'Check for valid ID
 If Not IsNumeric(Request.QueryString("ID")) Then
  Response.Redirect("/Home.aspx")
 End If
 If Len(Request.QueryString("ID")) > 6 Then
  Response.Redirect("/Home.aspx")
 End If

 Dim var_err_img As String = AssetsPath() & "/out-288.jpg"
 Dim varSearchID As String = ""
 Dim varYearTitleText As String = ""
 Dim varxxFormat As String = ""
 Dim varxxArtistTitle As String = ""
 Dim varxxItemDetailsWeb As String = ""
 Dim varxxID As String = ""
 Dim varxxRetailPrice As String = ""
 Dim varxxUsedItem As String = ""
 Dim varxxInventory As String = ""
 Dim varxxLabel As String = ""
 Dim varxxCatalog As String = ""
 Dim varxxYearFrom As String = ""
 Dim varxxYearTo As String = ""
 Dim varxxYearsText As String = ""
 Dim varxxRhythmName As String = ""
 Dim varxxGenre1 As String = ""
 Dim varxxGenre2 As String = ""
 Dim varxxGenre3 As String = ""
 Dim varxxGenre4 As String = ""
 Dim varxxGenre5 As String = ""
 Dim varxxGenre6 As String = ""
 Dim varxxGenre7 As String = ""
 Dim varxxGenre8 As String = ""
 Dim varxxGenre9 As String = ""
 Dim varxxTracksGroup As String = ""
 Dim varxxNumberOfTracks As Integer = 0
 Dim varxxWebEssential As String = ""
 Dim varxxStorePrice As String = ""
 Dim varxxMP3FileCompleted As String = ""
 Dim varxxWebReviewHTML As String = ""
 Dim varxxMusicianGroup As String = ""
 Dim varxxProduceGroup As String = ""
 Dim varxxSale_WholesalePrice As String = ""
 Dim varxxSale_RetailPrice As String = ""
 Dim varxxSale_WholesaleEndDate As String = ""
 Dim varxxSale_RetailEndDate As String = ""
 Dim varxxSale_WholesaleFootnoteText As String = ""
 Dim varxxSale_RetailFootnoteText As String = ""
 Dim varxxItemFootnoteText As String = ""
 Dim varxxUPC As String = ""
 Dim varxxWeightInGrams As String = ""
 Dim varxxConditionVinylOrCD As String = ""
 Dim varxxConditionJacket As String = ""
 Dim varxxConditionNotes As String = ""
 Dim varxxConditionText As String = ""
 Dim varItemFeatureID As String = ""
 Dim strCondition1 As String = ""
 Dim strCondition2 As String = ""
 Dim varCartDateTime As DateTime
 Dim CVid(100)
 Dim CVimg(100)
 Dim CVat(100)
 Dim varCVFormatText As String = ""
 Dim CVPrice As String = ""
 Dim varSimilarItemsSearchID As String = ""
 Dim varSimilarGenre As String = ""
 Dim varSimilarYearFrom As String = ""
 Dim varSimilarYearTo As String = ""
 Dim strCustomersAlsoViewedSQL As String = ""
 Dim strSimilarRhythm As String = "qzqzqzqz"
 Dim ns As Integer = 0
 Dim x1 As Integer = 0
 Dim strFormatSQL As String = ""
 Dim varSimilarItemsAvailable As Integer = 0
 Dim strCVArrayString As String = ""
 Dim CVImageHeight As String = ""
 Dim MBid(100)
 Dim MBimg(100)
 Dim MBat(100)
 Dim nsa As Integer = 0
 Dim MBImageHeight As String = ""
 Dim strMBArrayString As String = ""
 Dim varArtistAvailable As Integer = 0
 Dim strArtistForMoreBy As String = ""
 Dim strMoreBySQL As String = ""
 Dim strArtistsTextFromArtist As String = ""
 Dim strShowSound As String = "n"

 Dim ua As String = Request.ServerVariables("HTTP_USER_AGENT")
 Dim varKnownSearchEngineUserAgent As Integer = 0
 If InStr(1, UCase(ua), "GOOGLEBOT") > 0 Or InStr(1, UCase(ua), "GOOGLE.") > 0 Or InStr(1, UCase(ua), "BINGBOT") > 0 Or InStr(1, UCase(ua), "BINGPREVIEW") > 0 Or InStr(1, UCase(ua), "METASR") > 0 Or InStr(1, UCase(ua), "SLURP") > 0 Then
  varKnownSearchEngineUserAgent = 1
 End If

 'SearchID
 varSearchID = Request.QueryString("searchid")

 'Open Inventory Item Recordset
 Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
  SqlConnection.ClearPool(conn)
  conn.Open()
  Dim CMD_X As New SqlCommand("spGetitemDetails", conn)
  CMD_X.CommandType = Data.CommandType.StoredProcedure
  CMD_X.Parameters.AddWithValue("@ID", CLng(ST(Request.QueryString("ID"))))
  Dim xx As SqlDataReader
  xx = CMD_X.ExecuteReader

  If Not xx.HasRows Then
   Response.Redirect("/Home.aspx")
  Else
   xx.Read()
   varxxFormat = xx("Format")
   varxxArtistTitle = xx("ArtistTitle")
   varxxItemDetailsWeb = IsDBSomething(xx("ItemDetailsWeb"), "")
   varxxID = xx("ID").ToString
   varxxRetailPrice = xx("RetailPrice").ToString
   varxxUsedItem = IsDBSomething(xx("UsedItem"), "")
   varxxInventory = xx("Inventory")
   varxxLabel = IsDBSomething(xx("Label"), "")
   varxxCatalog = Trim(IsDBSomething(xx("Catalog"), ""))
   varxxYearFrom = Trim(IsDBSomething(xx("YearFrom"), ""))
   varxxYearTo = Trim(IsDBSomething(xx("YearTo"), ""))
   varxxRhythmName = Trim(IsDBSomething(xx("RhythmName"), ""))
   varxxGenre1 = IsDBSomething(xx("Genre1"), "")
   varxxGenre2 = IsDBSomething(xx("Genre2"), "")
   varxxGenre3 = IsDBSomething(xx("Genre3"), "")
   varxxGenre4 = IsDBSomething(xx("Genre4"), "")
   varxxGenre5 = IsDBSomething(xx("Genre5"), "")
   varxxGenre6 = IsDBSomething(xx("Genre6"), "")
   varxxGenre7 = IsDBSomething(xx("Genre7"), "")
   varxxGenre8 = IsDBSomething(xx("Genre8"), "")
   varxxGenre9 = IsDBSomething(xx("Genre9"), "")
   varxxTracksGroup = IsDBSomething(xx("TracksGroup"), "")
   varxxNumberOfTracks = FigureNumberOfTracks(IsDBSomething(xx("TracksGroup"), ""))
   varxxWebEssential = IsDBSomething(xx("WebEssential"), "")
   varxxStorePrice = xx("StorePrice")
   varxxMP3FileCompleted = IsDBSomething(xx("MP3FileCompleted"), "")
   varxxWebReviewHTML = IsDBSomething(xx("WebReviewHTML"), "")
   varxxMusicianGroup = IsDBSomething(xx("MusicianGroup"), "")
   varxxProduceGroup = IsDBSomething(xx("ProduceGroup"), "")
   If IsDBNull(xx("Sale_WholesalePrice")) Then
    varxxSale_WholesalePrice = 0
   Else
    varxxSale_WholesalePrice = xx("Sale_WholesalePrice")
   End If
   If IsDBNull(xx("Sale_RetailPrice")) Then
    varxxSale_RetailPrice = 0
   Else
    varxxSale_RetailPrice = xx("Sale_RetailPrice")
   End If
   If IsDBNull(xx("Sale_WholesaleEndDate")) Then
    varxxSale_WholesaleEndDate = ""
   Else
    varxxSale_WholesaleEndDate = xx("Sale_WholesaleEndDate")
   End If
   If IsDBNull(xx("Sale_RetailEndDate")) Then
    varxxSale_RetailEndDate = ""
   Else
    varxxSale_RetailEndDate = xx("Sale_RetailEndDate")
   End If
   varxxSale_WholesaleFootnoteText = IsDBSomething(xx("Sale_WholesaleFootnoteText"), "")
   varxxSale_RetailFootnoteText = IsDBSomething(xx("Sale_RetailFootnoteText"), "")
   varxxItemFootnoteText = IsDBSomething(xx("ItemFootnoteText"), "")
   varxxUPC = IsDBSomething(xx("UPC"), "")
   If IsDBNull(xx("WeightInGrams")) Then
    varxxWeightInGrams = 0
   Else
    varxxWeightInGrams = xx("WeightInGrams")
   End If
   varxxConditionVinylOrCD = IsDBSomething(xx("ConditionVinylOrCD"), "")
   varxxConditionJacket = IsDBSomething(xx("ConditionJacket"), "")
   varxxConditionNotes = IsDBSomething(xx("ConditionNotes"), "")
   varxxConditionText = IsDBSomething(xx("ConditionText"), "")
  End If
 End Using
 'Redirect for out of stock
 If varxxInventory = 0 Then
  Response.Redirect("/home.aspx")
 End If


 'Is Item In Cart Recordset
 Dim intQuantityInCart As Integer = 0
 Dim varCartPrice As Decimal = 0
 Using conn2 As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
  SqlConnection.ClearPool(conn2)
  conn2.Open()
  Dim CMD_X2 As New SqlCommand("spIsItemInCart", conn2)
  CMD_X2.CommandType = Data.CommandType.StoredProcedure
  CMD_X2.Parameters.AddWithValue("@NameOfCart", NameOfCart)
  CMD_X2.Parameters.AddWithValue("@ItemID", CLng(varxxID))
  Dim readerX2 As SqlDataReader
  readerX2 = CMD_X2.ExecuteReader
  If readerX2.HasRows Then
   readerX2.Read()
   intQuantityInCart = readerX2("Quantity")
   varCartPrice = readerX2("Price")
   varCartDateTime = readerX2("DateTime")
  End If
 End Using

 'Variables
 Dim varArtist As String = ""
 Dim varTitle As String = ""
 Dim varAT As String = ""
 Dim varImageHeight As Integer = 0
 Dim varImageWidth As Integer = 0
 Dim varDash As String = InStr(1, varxxArtistTitle, " - ")
 If varDash > 0 Then
  varArtist = Trim(Left(varxxArtistTitle, varDash))
  varTitle = Trim(Right(varxxArtistTitle, Len(varxxArtistTitle) - varDash - 2))
 Else
  varArtist = varxxArtistTitle
  varTitle = ""
 End If
 varAT = ItemDetails_FigureArtistWebHTML(varxxFormat, varxxArtistTitle, varxxItemDetailsWeb)
 varDash = InStr(1, varAT, " - ")
 If varDash > 0 Then
  varAT = Trim(Left(varAT, varDash))
 End If
 If varxxFormat = "CD" Then
  varImageHeight = 288
  varImageWidth = 330
  CVImageHeight = 175
  MBImageHeight = 175
 Else
  varImageHeight = 330
  varImageWidth = 330
  CVImageHeight = 201
  MBImageHeight = 201
 End If
 If UCase(varxxUsedItem) = "Y" Then
  varxxUsedItem = "y"
 Else
  varxxUsedItem = "n"
 End If
 If varxxYearFrom <> "" And varxxYearTo <> "" Then
  varxxYearsText = varxxYearFrom & "-" & varxxYearTo
 Else
  varxxYearsText = varxxYearFrom
 End If
 If varxxFormat = "7""" Then
  strFormatSQL = " and Inventory.Format like '7%'"
 ElseIf varxxFormat = "12""" Then
  strFormatSQL = " and (Inventory.Format like '12%' or Inventory.Format like '10%')"
 ElseIf varxxFormat = "10""" Then
  strFormatSQL = " and (Inventory.Format like '12%' or Inventory.Format like '10%')"
 Else
  strFormatSQL = " and Inventory.Format ='" & varxxFormat & "'"
 End If

 'Customers Also Viewed Array----------------------------------------------------------------------------------------------------------
 If varKnownSearchEngineUserAgent = 0 Then
  varSimilarGenre = IsDBSomething(varxxGenre1, "")
  varSimilarYearFrom = IsDBSomething(varxxYearFrom, "")
  varSimilarYearTo = IsDBSomething(varxxYearTo, "")
  If varSimilarYearFrom = "" Then
   varSimilarYearFrom = "1000"
  Else
   varSimilarYearFrom = varSimilarYearFrom - 1
   If varSimilarYearTo = "" Then
    varSimilarYearTo = varSimilarYearFrom + 2
   Else
    varSimilarYearTo = varSimilarYearTo + 1
   End If
  End If
  varSimilarGenre = Replace(varSimilarGenre, "'", "''")
  If varSimilarGenre = "" Then
   varSimilarGenre = "asdfafsdaf"
  End If
  If IsDBSomething(varxxRhythmName, "") <> "" Then
   strSimilarRhythm = Replace(varxxRhythmName, "'", "''")
  End If
  ns = 0
  If varxxYearFrom <> "" Then
   If varxxYearTo <> "" Then
    If varxxGenre1 <> "" And IsNumeric(varxxYearFrom) And IsNumeric(varxxYearTo) Then
     If CInt(varxxYearFrom) - CInt(varxxYearTo) < 6 Then
      varSimilarItemsAvailable = 1
     End If
    End If
   Else
    If varxxGenre1 <> "" And IsNumeric(varxxYearFrom) Then
     varSimilarItemsAvailable = 1
    End If
   End If
  End If
  If varSimilarItemsAvailable = 1 Then
   strCustomersAlsoViewedSQL = "select ID,ArtistTitle,SalesLast30Days,Format,RetailPrice,ExportPrice from inventory where ID in (select ID from inventory" _
    & " where (((Genre1='" & varSimilarGenre & "' or Genre2='" & varSimilarGenre & "' or Genre3='" & varSimilarGenre & "' or Genre4='" & varSimilarGenre & "' or Genre5='" & varSimilarGenre & "' or Genre6='" & varSimilarGenre & "' or Genre7='" & varSimilarGenre & "' or Genre8='" & varSimilarGenre & "' or Genre9='" & varSimilarGenre & "')" _
    & " and ((YearFrom >= " & varSimilarYearFrom & " and YearFrom <= " & varSimilarYearTo & ") or (YearTo >= " & varSimilarYearFrom & " and YearTo <= " & varSimilarYearTo & ")))" _
    & " or RhythmName='" & strSimilarRhythm & "')" _
    & " and inventory >0 and ShowOnWebsite='y' and useditem='n'" _
    & strFormatSQL _
    & " and Inventory.ID<>" & varxxID _
    & " Order by SalesLast30Days desc, Inventory.ID desc offset 0 rows fetch next 15 rows only) Order by NEWID()"
   Using connA As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
    SqlConnection.ClearPool(connA)
    connA.Open()
    Dim CMD_A As New SqlCommand(strCustomersAlsoViewedSQL, connA)
    CMD_A.CommandType = Data.CommandType.Text
    Dim readerA As SqlDataReader
    readerA = CMD_A.ExecuteReader
    If readerA.HasRows Then
     ns = 0
     x1 = 0
     Do While readerA.Read
      If ScanPath(readerA("ID"), "320", "A") <> "" Then
       If Session("PriceGroup") = "StorePrice" Or Session("PriceGroup") = "ExportPrice" Then
        CVPrice = FormatNumber(readerA("ExportPrice"), 2)
       Else
        CVPrice = FormatNumber(readerA("RetailPrice"), 2)
       End If
       CVid(ns) = readerA("ID")
       CVimg(ns) = ScanPath(readerA("ID"), "320", "A")
       CVat(ns) = "<b>" & Replace(readerA("Format"), Chr(34), " Inch") & " $" & CVPrice & " </b>" & FigureLength(Replace(readerA("ArtistTitle"), Chr(34), " Inch"))
       ns = ns + 1
      End If
      If ns = 50 Then Exit Do
      x1 = x1 + 1
     Loop
    End If
   End Using

   strCustomersAlsoViewedSQL = "select ID,ArtistTitle,SalesLast30Days,Format,RetailPrice,ExportPrice from inventory where ID in (select ID from inventory" _
    & " where (((Genre1='" & varSimilarGenre & "' or Genre2='" & varSimilarGenre & "' or Genre3='" & varSimilarGenre & "' or Genre4='" & varSimilarGenre & "' or Genre5='" & varSimilarGenre & "' or Genre6='" & varSimilarGenre & "' or Genre7='" & varSimilarGenre & "' or Genre8='" & varSimilarGenre & "' or Genre9='" & varSimilarGenre & "')" _
    & " and ((YearFrom >= " & varSimilarYearFrom & " and YearFrom <= " & varSimilarYearTo & ") or (YearTo >= " & varSimilarYearFrom & " and YearTo <= " & varSimilarYearTo & ")))" _
    & " or RhythmName='" & strSimilarRhythm & "')" _
    & " and inventory >0 and ShowOnWebsite='y' and useditem='n'" _
    & strFormatSQL _
    & " and Inventory.ID<>" & varxxID _
    & " Order by SalesLast30Days desc, Inventory.ID desc offset 15 rows fetch next 45 rows only) Order by NEWID()"
   Using connA As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
    SqlConnection.ClearPool(connA)
    connA.Open()
    Dim CMD_A As New SqlCommand(strCustomersAlsoViewedSQL, connA)
    CMD_A.CommandType = Data.CommandType.Text
    Dim readerA As SqlDataReader
    readerA = CMD_A.ExecuteReader
    If readerA.HasRows Then
     Do While readerA.Read
      If ScanPath(readerA("ID"), "320", "A") <> "" Then
       If Session("PriceGroup") = "StorePrice" Or Session("PriceGroup") = "ExportPrice" Then
        CVPrice = FormatNumber(readerA("ExportPrice"), 2)
       Else
        CVPrice = FormatNumber(readerA("RetailPrice"), 2)
       End If
       CVid(ns) = readerA("ID")
       CVimg(ns) = ScanPath(readerA("ID"), "320", "A")
       CVat(ns) = "<b>" & Replace(readerA("Format"), Chr(34), " Inch") & " $" & CVPrice & " </b>" & FigureLength(Replace(readerA("ArtistTitle"), Chr(34), " Inch"))
       ns = ns + 1
      End If
      If ns = 50 Then Exit Do
      x1 = x1 + 1
     Loop
    End If
   End Using
  End If
 End If
 '-----------------------------------------------------------------------------------------------------------------------------------

 'More By This Artist Array----------------------------------------------------------------------------------------------------------
 If varKnownSearchEngineUserAgent = 0 Then
  x1 = 0
  Using connA As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
   SqlConnection.ClearPool(connA)
   connA.Open()
   Dim CMD_A As New SqlCommand("spGetWebArtistsForInventoryItemByCounter", connA)
   CMD_A.CommandType = Data.CommandType.StoredProcedure
   CMD_A.Parameters.AddWithValue("@InventoryID", CLng(varxxID))
   Dim readerA As SqlDataReader
   readerA = CMD_A.ExecuteReader
   If readerA.HasRows Then
    readerA.Read()
    strArtistForMoreBy = Replace(readerA("Artist"), "'", "''")
    x1 = x1 + 1
   End If
  End Using
  If x1 = 1 Then
   If strArtistForMoreBy = "Various" Then
    strArtistForMoreBy = ""
   End If
  Else
   strArtistForMoreBy=""
  End If
  If strArtistForMoreBy <> "" Then
   strMoreBySQL = "select ID,ArtistTitle,SalesLast30Days,Format,RetailPrice,ExportPrice from inventory where ID in (select ID from inventory" _
    & " where (ArtistTitle like '" & strArtistForMoreBy & " - %' or ArtistTitle like '" & strArtistForMoreBy & ", %' or ArtistTitle like '%, " & strArtistForMoreBy & " -%' or ArtistTitle like '%, " & strArtistForMoreBy & ",%')" _
    & " and inventory >0 and ShowOnWebsite='y' and useditem='n'" _
    & strFormatSQL _
    & " and Inventory.ID<>" & varxxID _
    & " Order by SalesLast30Days desc, Inventory.ID desc offset 0 rows fetch next 15 rows only) Order by NEWID()"
   Using connA As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
    SqlConnection.ClearPool(connA)
    connA.Open()
    Dim CMD_A As New SqlCommand(strMoreBySQL, connA)
    CMD_A.CommandType = Data.CommandType.Text
    Dim readerA As SqlDataReader
    readerA = CMD_A.ExecuteReader
    If readerA.HasRows Then
     nsa = 0
     x1 = 0
     Do While readerA.Read
      If ScanPath(readerA("ID"), "320", "A") <> "" And readerA("ID") <> CVid(0) And readerA("ID") <> CVid(1) And readerA("ID") <> CVid(2) And readerA("ID") <> CVid(3) And readerA("ID") <> CVid(4) Then
       If Session("PriceGroup") = "StorePrice" Or Session("PriceGroup") = "ExportPrice" Then
        CVPrice = FormatNumber(readerA("ExportPrice"), 2)
       Else
        CVPrice = FormatNumber(readerA("RetailPrice"), 2)
       End If
       strArtistsTextFromArtist = FigureArtistsTextFromArtist(Replace(strArtistForMoreBy, "'", "''"), Replace(readerA("ArtistTitle"), Chr(34), " Inch"))
       MBid(nsa) = readerA("ID")
       MBimg(nsa) = ScanPath(readerA("ID"), "320", "A")
       MBat(nsa) = "<b>" & Replace(readerA("Format"), Chr(34), " Inch") & " $" & CVPrice & " </b>" & FigureLength(strArtistsTextFromArtist)
       nsa = nsa + 1
      End If
      If nsa = 50 Then Exit Do
      x1 = x1 + 1
     Loop
    End If
   End Using

   strMoreBySQL = "select ID,ArtistTitle,SalesLast30Days,Format,RetailPrice,ExportPrice from inventory where ID in (select ID from inventory" _
    & " where (ArtistTitle like '" & strArtistForMoreBy & " - %' or ArtistTitle like '" & strArtistForMoreBy & ", %' or ArtistTitle like '%, " & strArtistForMoreBy & " -%' or ArtistTitle like '%, " & strArtistForMoreBy & ",%')" _
    & " and inventory >0 and ShowOnWebsite='y' and useditem='n'" _
    & strFormatSQL _
    & " and Inventory.ID<>" & varxxID _
    & " Order by SalesLast30Days desc, Inventory.ID desc offset 15 rows fetch next 45 rows only) Order by NEWID()"
   Using connA As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
    SqlConnection.ClearPool(connA)
    connA.Open()
    Dim CMD_A As New SqlCommand(strMoreBySQL, connA)
    CMD_A.CommandType = Data.CommandType.Text
    Dim readerA As SqlDataReader
    readerA = CMD_A.ExecuteReader
    If readerA.HasRows Then
     Do While readerA.Read
      If ScanPath(readerA("ID"), "320", "A") <> "" And readerA("ID") <> CVid(0) And readerA("ID") <> CVid(1) And readerA("ID") <> CVid(2) And readerA("ID") <> CVid(3) And readerA("ID") <> CVid(4) Then
       If Session("PriceGroup") = "StorePrice" Or Session("PriceGroup") = "ExportPrice" Then
        CVPrice = FormatNumber(readerA("ExportPrice"), 2)
       Else
        CVPrice = FormatNumber(readerA("RetailPrice"), 2)
       End If
       strArtistsTextFromArtist = FigureArtistsTextFromArtist(Replace(strArtistForMoreBy, "'", "''"), Replace(readerA("ArtistTitle"), Chr(34), " Inch"))
       MBid(nsa) = readerA("ID")
       MBimg(nsa) = ScanPath(readerA("ID"), "320", "A")
       MBat(nsa) = "<b>" & Replace(readerA("Format"), Chr(34), " Inch") & " $" & CVPrice & " </b>" & FigureLength(strArtistsTextFromArtist)
       nsa = nsa + 1
      End If
      If nsa = 50 Then Exit Do
      x1 = x1 + 1
     Loop
    End If
   End Using
  End If
 End If
 '-----------------------------------------------------------------------------------------------------------------------------


 'Scans
 Dim varThumbFront As String = "n"
 Dim varThumbFrontZoom As String = "n"
 Dim varThumbBack As String = "n"
 Dim varThumbBackZoom As String = "n"
 Dim varNumberOfImages As Integer = 0
 Dim varFirstImageSource As String = ""
 Dim varFirstImageSupersizeTarget As String = ""
 Dim varSecondImageSource As String = ""
 Dim varSecondImageSupersizeTarget As String = ""
 Dim varNoImage As Integer = 0

 If ScanPath(varxxID, "large", "a") <> "" Then
  varThumbFront = "y"
  If ScanPath(varxxID, "large", "b") <> "" Then
   varNumberOfImages = 2
   varThumbBack = "y"
   varFirstImageSource = ScanPath(varxxID, "large", "A")
   varFirstImageSupersizeTarget = ScanPath(varxxID, "1130", "A")
   varSecondImageSource = ScanPath(varxxID, "large", "B")
   varSecondImageSupersizeTarget = ScanPath(varxxID, "1130", "B")
  Else
   varNumberOfImages = 1
   varFirstImageSource = ScanPath(varxxID, "large", "A")
   varFirstImageSupersizeTarget = ScanPath(varxxID, "1130", "A")
   varSecondImageSource = ""
  End If
 Else
  varNumberOfImages = 1
  If varxxInventory = 0 Then
   varFirstImageSource = AssetsPath() + "/n330out.jpg"
   varImageHeight = 330
   varImageWidth = 330
   varNoImage = 1
  Else
   varFirstImageSource = AssetsPath() + "/n330.jpg"
   varImageHeight = 330
   varImageWidth = 330
   varNoImage = 1
  End If
  varSecondImageSource = ""
 End If

 'Price
 Dim varSaleItem As String = 0
 Dim varPriceGroupPrice As String = ""
 Dim varPriceUsing As String = ""
 Dim varPriceForCartAddText As String = ""

 If Session("PriceGroup") = "StorePrice" Or Session("PriceGroup") = "ExportPrice" Then
  If varxxSale_WholesalePrice <> "" And varxxSale_WholesaleEndDate <> "" Then
   If DateDiff("d", Date.Now, varxxSale_WholesaleEndDate) >= 0 Then
    varSaleItem = 1
   End If
  End If
 Else
  If varxxSale_RetailPrice <> "" And varxxSale_RetailEndDate <> "" Then
   If DateDiff("d", Date.Now, varxxSale_RetailEndDate) >= 0 Then
    varSaleItem = 1
   End If
  End If
 End If
 If Session("PriceGroup") = "StorePrice" Or Session("PriceGroup") = "ExportPrice" Then
  varPriceGroupPrice = varxxStorePrice
  If varSaleItem = 1 Then
   varPriceUsing = varxxSale_WholesalePrice
  Else
   varPriceUsing = varxxStorePrice
  End If
 Else
  varPriceGroupPrice = varxxRetailPrice
  If varSaleItem = 1 Then
   varPriceUsing = varxxSale_RetailPrice
  Else
   varPriceUsing = varxxRetailPrice
  End If
 End If
 varPriceForCartAddText = varPriceUsing
 If intQuantityInCart > 0 Then
  If CDbl(varPriceUsing) > CDbl(varCartPrice) And DateDiff("d", varCartDateTime, Date.Now) <= 30 Then
   varPriceUsing= varCartPrice
  End If
 End If

%>

<html>
<head>

<link rel="shortcut icon" href="favicon.ico?"/>
<link rel="icon" href="/favicon.ico?" type="image/x-icon"/>

<%'Javascript%>

<%If varKnownSearchEngineUserAgent = 0 Then
  Response.Write("<script language=""javascript"">")
  If ns < 4 Then
   Response.Write(vbCrLf & "CVnumberon=" & ns)
  Else
   Response.Write(vbCrLf & "CVnumberon=4")
  End If
  strCVArrayString = vbCrLf & "let CVid = ["
  For x1 = 0 To ns - 1
   If x1 <> 0 Then strCVArrayString = strCVArrayString & ","
   strCVArrayString = strCVArrayString & """" & CVid(x1) & """"
  Next
  strCVArrayString = strCVArrayString & "]"
  Response.Write(strCVArrayString)
  strCVArrayString = vbCrLf & "let CVimg = ["
  For x1 = 0 To ns - 1
   If x1 <> 0 Then strCVArrayString = strCVArrayString & ","
   strCVArrayString = strCVArrayString & """" & CVimg(x1) & """"
  Next
  strCVArrayString = strCVArrayString & "]"
  Response.Write(strCVArrayString)
  strCVArrayString = vbCrLf & "CVat=[];"
  For x1 = 0 To ns - 1
   strCVArrayString = strCVArrayString & vbCrLf & "CVat[" & x1 & "]=""" & CVat(x1) & """;"
  Next
  Response.Write(strCVArrayString)

  If nsa < 4 Then
   Response.Write(vbCrLf & "MBnumberon=" & nsa)
  Else
   Response.Write(vbCrLf & "MBnumberon=4")
  End If
  strMBArrayString = vbCrLf & "let MBid = ["
  For x1 = 0 To nsa - 1
   If x1 <> 0 Then strMBArrayString = strMBArrayString & ","
   strMBArrayString = strMBArrayString & """" & MBid(x1) & """"
  Next
  strMBArrayString = strMBArrayString & "]"
  Response.Write(strMBArrayString)
  strMBArrayString = vbCrLf & "let MBimg = ["
  For x1 = 0 To nsa - 1
   If x1 <> 0 Then strMBArrayString = strMBArrayString & ","
   strMBArrayString = strMBArrayString & """" & MBimg(x1) & """"
  Next
  strMBArrayString = strMBArrayString & "]"
  Response.Write(strMBArrayString)
  strMBArrayString = vbCrLf & "MBat=[];"
  For x1 = 0 To nsa - 1
   strMBArrayString = strMBArrayString & vbCrLf & "MBat[" & x1 & "]=""" & MBat(x1) & """;"
  Next
  Response.Write(strMBArrayString)
  Response.Write(vbCrLf & "</script>")
 End If%>
<input id="AssetsPath" value="<%=AssetsPath()%>" style="display:none" />
<input id="MP3sPath" value="<%=MP3sPath()%>" style="display:none" />
<script type="text/javascript" src="/JS38/ItemDetailsMain_2.js?x=144"></script>
<%'Styles %>
<link rel="stylesheet" type="text/css" href="/CSS24/ItemDetailsMain_2.css?x=37" />

<title><%=WebSiteSEOCode(varxxArtistTitle)%></title>
<meta name="title" lang="en-us"content="<%=WebSiteSEOCode(varxxArtistTitle)%>">
<meta name="description" lang="en-us"content="In stock now. $<%=FormatNumber(varxxRetailPrice, 2)%> . Buy <%=WebSiteSEOCode(varxxArtistTitle)%> from MillionsOfRecords.com. Music distributor for CD and vinyl records.">
<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
</head>

<%'Body %>
<!--body onload="cc()"leftmargin="10" rightmargin="10" link="ffffff" alink="ffffff" vlink="ffffff" bgcolor="000000"-->
<body leftmargin="10" rightmargin="10" link="ffffff" alink="ffffff" vlink="ffffff" bgcolor="000000">
<%'Top of Page%>
<table bgcolor="000000" bordercolorlight="879B87" bordercolordark="D4DBD4" cellpadding="0" cellspacing="0" width="1250" align="center" BORDER="0">
<tr valign="bottom">
<td width="216"height="32"align="center"valign="bottom">
<div id="psi1Div"style="position:fixed;visibility:hidden;display:none;left:50%;margin-left:-383px;width:766px;height:475px;top:170px;z-index:20000;text-align:left;vertical-align:top;background-image:url('<%=AssetsPath()%>/psi-bg3.gif');background-repeat:no-repeat">
<div id="psi2Div"style="position:absolute;visibility:hidden;display:none;width:646px;height:355px;margin-left:60px;margin-top:60px">
<img alt=""title="Close this message."style="margin-top:-41px;margin-left:653px;cursor:pointer"onclick="hidepsiDiv()"onmouseover="fov(this,'close-psi')"onmouseout="fou(this,'close-psi')"src="<%=AssetsPath()%>/close-psi.gif" />
<p class="log-in">Hello,
<br/><br/>Please sign in to your account.  If you don't sign in now then this cart will be emptied if you leave the website.
<br/><br/>After signing in, you can continue shopping and your cart will be automatically saved to your account.
<br/><br/>Please sign in or create an account.  Your cart will be saved forever, and you can continue shopping.
</p><br/><br/>
<img alt=""style="cursor:pointer;margin-left:170px"src="<%=AssetsPath()%>/sign-in-btn.gif"onclick="window.location='/Options.aspx'"onmouseover="fov(this,'sign-in-btn')" onmouseout="fou(this,'sign-in-btn')">
<img alt=""style="cursor:pointer;margin-left:30px"src="<%=AssetsPath()%>/create-account-btn.gif"onclick="window.location='/Options.aspx'"onmouseover="fov(this,'create-account-btn')" onmouseout="fou(this,'create-account-btn')">
<br/><br/><p class="log-in-s">If you have any questions, please email Ernie at ernieb12345@gmail.com for a prompt reply.
<br/><br/>Thank you.
</p>
</div>
</div>


<%'Supersize Image Div%>
<div class="qq"name="supersize-img-div"id="supersize-img-div">
<table cellpadding="0" width="1250" cellspacing="0" align="center" border="0">
<tr><td bgcolor="000000"width="120px"style="vertical-align:top;text-align:center">
<img title="View" name="supersize-thumb1" id="supersize-thumb1" src="<%=varFirstImageSource%>" onclick="SD('<%=varFirstImageSupersizeTarget%>')" style="max-width:100px;max-height:100px;border:3px solid #ffff00" alt="" onerror="this.onerror=null;this.src='<%=var_err_img%>'"/>
<%If varSecondImageSupersizeTarget <> "" Then%>
 <br/><img title="View" name="supersize-thumb2" id="supersize-thumb2" src="<%=varSecondImageSource%>" onclick="SD('<%=varSecondImageSupersizeTarget%>')" style="max-width:100px;max-height:100px;border:3px solid #ffff00;margin-top:6px"alt="" onerror="this.onerror=null;this.src='<%=var_err_img%>'"/>
<%end if%>
<br/><img alt="" class="a"style="vertical-align:top;cursor:pointer;margin-top:30px" src="<%=AssetsPath()%>/back22.gif"onmouseover="fovs(this,'back22')" onmouseout="fous(this,'back22')" onclick="HD()"/>
</td><td width="1130"style="vertical-align:top;text-align:center">
<img title="Close" name="supersize" id="supersize" onclick="HD()" style="max-width:1130px;max-height:1130px;border:1px solid #BABBBA" alt="" onerror="this.onerror=null;this.src='<%=var_err_img%>'"/>
</td></tr></table>
</div>

<div style="position:absolute;width:216px;margin-left:-4px;margin-top:5px;cursor:pointer"onclick="window.location='/home.aspx'">
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
 <img alt border="0" src="<%=AssetsPath()%>/create-account3.gif" onmouseover="fov(this,'create-account3')" onmouseout="fou(this,'create-account3')" style="cursor:pointer;margin-bottom:3px" onclick="window.location='/Options.aspx'">
</td><td width="95"align="right"valign="bottom">
<img alt border="0" src="<%=AssetsPath()%>/cart-upper-right3.gif" onmouseover="fov(this,'cart-upper-right3')" onmouseout="fou(this,'cart-upper-right3')" style="cursor:pointer;margin-bottom:3px" onclick="window.location='/home.aspx?TabH=Cart'">
</td><td width="95"align="right"valign="bottom">
<% If Session("PowerUserName") = "" And Session("CustomerID") <> "" Then%>
 <img alt border="0" src="<%=AssetsPath()%>/sign-out-upper-right3.gif" onmouseover="fov(this,'sign-out-upper-right3')" onmouseout="fou(this,'sign-out-upper-right3')" style="cursor:pointer;margin-bottom:3px" onclick="window.location='/SignOut.aspx'">
<% Else%>
 <img alt border="0" src="<%=AssetsPath()%>/sign-in-upper-right3.gif" onmouseover="fov(this,'sign-in-upper-right3')" onmouseout="fou(this,'sign-in-upper-right3')" style="cursor:pointer;margin-bottom:3px" onclick="window.location='/Options.aspx'">
<%end if%>
</td><td width="3">
</td></tr>
</table>

<table bordercolorlight="9BAF9B" cellpadding="0" cellspacing="0" WIDTH="1250" align="center" BORDER="0">
<tr><td bgcolor="9BAF9B" width="3%"></td><td bgcolor="9BAF9B" width="97%"></td>
<td width="3%"><img alt src="<%=AssetsPath()%>/tabletopright.gif" WIDTH="33" HEIGHT="7"></td>
</tr></table>

<table cellpadding="0" cellspacing="0" align="center" bgcolor="9BAF9B" width="1250">
<td align="center"height="65"valign="top">
<%'PowerUserName and StoreName at top of screen
 If Session("PowerUserName") <> "" Then%>
 <p class="pow"style="background-color:#9BFFF9;color:#000000"onclick="window.location='/Wholesale.aspx'">&nbsp;&nbsp;<%=Session("PowerUserName")%>&nbsp;&nbsp;</p>
 <% If Session("CustomerServerCounter") <> "" Then%>
  <p class="pow"style="background-color:#FFff00;color:#000000"onclick="window.location='/CustomerInfo.aspx'">&nbsp;&nbsp;<%=Left(Session("StoreName"), 40)%>&nbsp;</p>
 <% End If%>
 <p class="pow"style="background-color:#ffffff;color:#000000;cursor:default">&nbsp;&nbsp;<%=varPriceGroup%>&nbsp;</p>
 <%Else
    If Session("CustomerID") <> "" Then%>
    <div style="cursor:pointer;position:absolute;display:block;width:180px;height:29px;margin-left:1060px;margin-top:-6px;padding-top:11px;vertical-align:top;text-align:center;background-image:url('<%=AssetsPath()%>/log-in-name-bg2.gif');background-repeat:no-repeat"title="Click here to see your customer profile (shipping address, etc.)"onclick="window.location='/CustomerInfo.aspx'">
    <p style="vertical-align:top;text-align:center;font-size:13px;font-family:arial"><%=FigureSignedInName(Session("StoreName"))%></p>
    </div>
   <%End If
   End If%>

</td></table>


<table align="center" bgcolor="ffffff" cellpadding="0" cellspacing="0" width="1250" border="0">
 <%'Audio Tag%>
<audio id="sound-player"/>
</audio>

<tr><td width="255"align="left"height="35">
<%'Back or Home button%>
<div style="position:absolute;height:170px;width:130px;margin-left:50px;margin-top:50px;text-align:center;vertical-align:top">
<%if instr(UCase(Request.ServerVariables("HTTP_REFERER")), "MILLIONSOFRECORDS") = 0 And InStr(UCase(Request.ServerVariables("HTTP_REFERER")), "MILLIONSTEST2019") = 0 Then%>
 <a href="/home.aspx"><img title="Go to our home page."src="<%=AssetsPath()%>/home-circle.gif"></a>
<% Else%>
 <img alt=""title="Back"src="<%=AssetsPath()%>/back1.gif"style="cursor:pointer"onclick="history.back()"onmouseover="fov(this,'back1')" onmouseout="fou(this,'back1')">
<%end if%>
</div>
<%'Images%>
</td><td width="330"style="vertical-align:bottom;text-align:center;padding-bottom:3px">
<img src="<%=AssetsPath()%>/zoom-front2.gif" style="cursor:pointer" onclick="SD('<%=varFirstImageSupersizeTarget%>')" onmouseover="fov(this,'zoom-front2')" onmouseout="fou(this,'zoom-front2')" />
</td><td width="80"onclick="HD()">
</td><td width="330"style="vertical-align:bottom;text-align:center;padding-bottom:3px">
<% If varNumberOfImages > 1 Then%>
 <img src="<%=AssetsPath()%>/zoom-back2.gif" style="cursor:pointer" onclick="SD('<%=varSecondImageSupersizeTarget%>')" onmouseover="fov(this,'zoom-back2')" onmouseout="fou(this,'zoom-back2')" />
<% End If%>
</td><td width="255"onclick="HD()">
</td></tr><tr><td width="255"height="<%=varImageHeight + 4%>">
</td><td width="330"style="vertical-align:top;text-align:center">
<%if varNoImage=0 then%>
 <img style="max-width:330px;max-height:330px;border:2px solid #000000;cursor:pointer" alt="<%=NoQuotes(WebSiteSEOCode(varxxArtistTitle))%>" title="<%=NoQuotes(WebSiteSEOCode(varxxArtistTitle))%>" src="<%=varFirstImageSource%>" onclick="SD('<%=varFirstImageSupersizeTarget%>')" onerror="this.onerror=null;this.src='<%=var_err_img%>'"/>
<% Else%>
 <img style="max-width:330px;max-height:330px;border:1px solid #BABBBA"alt=""src="<%=varFirstImageSource%>"/>
<% End If%>
</td><td width="80"onclick="HD()">
</td><td width="330"style="vertical-align:top;text-align:center">
<%if varNumberOfImages>1 then%>
 <img style="max-width:330px;max-height:330px;border:2px solid #000000;cursor:pointer" alt="<%=NoQuotes(WebSiteSEOCode(varxxArtistTitle))%>" title="<%=NoQuotes(WebSiteSEOCode(varxxArtistTitle))%>" src="<%=varSecondImageSource%>" onclick="SD('<%=varSecondImageSupersizeTarget%>')" onerror="this.onerror=null;this.src='<%=var_err_img%>'"/>
<% End If%>
</td><td width="255"style="text-align:center;vertical-align:middle"onclick="HD()">
<%'Similar Items
 If varSimilarItemsAvailable = 1 Then%>
 <a href="/home.aspx?X3QT=SimilarItems&X3AID=<%=varxxID%>"><img alt=""title=""src="<%=AssetsPath()%>/similar-items2.gif"style="cursor:pointer;vertical-align:middle"onclick="history.back()"onmouseover="fov(this,'similar-items2')" onmouseout="fou(this,'similar-items2')"></a>
<%End If%>
</td></tr><tr><td width="255"height="16"></td><td width="330"></td><td width="80"></td><td width="330"></td><td width="255">
</td></tr></table>
<%If varxxInventory = 0 Then 'OUT OF STOCK------------------------------%>
  <table align="center" bgcolor="ffffff" cellpadding="0" cellspacing="0" width="1250" border="0">
  <tr><td width="255"height="500"style="vertical-align:top;padding-left:80px;padding-right:80px;padding-top:20px">
  <p class="title">This item is out of stock.  Please click the "Continue Shopping" button to view our huge inventory of Vinyl and CD's.</p>
  <br /><a href="https://www.millionsofrecords.com"><img style="margin-top:50px"src="<%=AssetsPath()%>/continue-shopping-btn.gif"/></a>
  </td></tr></table>
<%Else '-----IN STOCK-----------------------------------------------%>
 <%'Price%>
 <table align="center" bgcolor="ffffff" cellpadding="0" cellspacing="0" width="1250" border="0">
 <tr><td width="255"onclick="HD()">
 </td><td width="390"style="vertical-align:top;text-align:left">
  <table align="left" bgcolor="ffffff" cellpadding="0" cellspacing="0" width="390px" border="0">
  <tr><td width="390"height="50"style="vertical-align:top;text-align:left">
  <p class="p-format"><%=varxxFormat%>&nbsp;</p>
  <%If varSaleItem = 1 Then
     If Session("PriceGroup") = "StorePrice" Or Session("PriceGroup") = "ExportPrice" Then%>
    <p class="p-price-x"><%=FormatCurrency(varPriceGroupPrice, 2)%></p>
    &nbsp;&nbsp;&nbsp;<p class="p-price-sale"><%=FormatCurrency(varxxSale_WholesalePrice, 2)%></p>
   <% Else%>
    <p class="p-price-x"><%=FormatCurrency(varPriceGroupPrice, 2)%></p>
    &nbsp;&nbsp;&nbsp;<p class="p-price-sale"><%=FormatCurrency(varxxSale_RetailPrice, 2)%></p>
   <%end if%>
  <%else%>
   <p class="p-price"><%=FormatCurrency(varPriceUsing, 2)%></p>
  <%end if%>
  <%'Add To Cart%>
  </td></tr><tr><td width="390"height="47"style="vertical-align:top;text-align:left;background-image:url('<%=AssetsPath()%>/item-add-bg2.gif');background-repeat:no-repeat">
  <%if varxxInventory>0 then%>
   <table border="0"cellspacing="0" cellpadding="0" width="390"style="border-collapse:collapse">
   <tr><td width="46"height="7">
   </td><td width="20">
   </td><td width="115">
   </td><td width="209">
   </td></tr><tr><td width="46"align="right"valign="top"style="text-align:right;vertical-align:top">
   <%if ucase(varxxUsedItem) = "Y" Or Left(varxxArtistTitle, 10) = "USED ITEM:" Then%>
    <div class="ui"style="z-index:1000">
    <img alt=""title="This is a used item"src="<%=AssetsPath()%>/item-used-item.gif" />
    </div>
   <%end if%>
   <div class="yc2"style="z-index:1000"name="YC<%=varxxID%>"id="YC<%=varxxID%>">
   <img alt=""style="cursor:pointer"src="<%=AssetsPath()%>/item-ych2.gif"onclick="gtcart()" />
   </div>
   <input type="hidden" name="SearchIDTxt" id="SearchIDTxt" Value="<%=varSearchID%>" />
   <input type="hidden" name="X3CARTCQ" id="X3CARTCQ" value="no" />
   <%If intQuantityInCart > 0 Then%>
    <input type="text" id="OA<%=varxxID%>" name="OA<%=varxxID%>" class="item-qty-x"ONKEYDOWN="Sc();VS=0"onkeyup="CQ(<%=varxxID%>,<%=varPriceForCartAddText%>,0,'OA',1)" VALUE="<%=intQuantityInCart%>" maxlength="3" />
    <%Else%>
    <input type="text"id="OA<%=varxxID%>" name="OA<%=varxxID%>" class="item-qty"ONKEYDOWN="Sc();VS=0"onkeyup="CQ(<%=varxxID%>,<%=varPriceForCartAddText%>,0,'OA',1)" maxlength="3" />
   <%End If%>
   </td><td width="20"align="center"valign="top"style="text-align:center;vertical-align:top">
   <img alt=""style="border-width:0px;cursor:pointer;margin-top:0px"title="Remove item from cart." ONCLICK="CQ(<%=varxxID%>,<%=varPriceForCartAddText%>,-1,'OA',0)"onmouseover="fov(this,'item-x2')" onmouseout="fou(this,'item-x2')" src="<%=AssetsPath()%>/item-x2.gif" />
   </td><td width="115"align="left"valign="top"style="text-align:left;vertical-align:top">
   <img alt=""style="border-width:0px;cursor:pointer;margin-top:0px"title="Add 1 to quantity in cart." ONCLICK="CQ(<%=varxxID%>,<%=varPriceForCartAddText%>,1,'OA',0)"onmouseover="fov(this,'item-add2')" onmouseout="fou(this,'item-add2')" src="<%=AssetsPath()%>/item-add2.gif" />
   <%'Footnote%>
   </td><td width="209"style="text-align:left;vertical-align:bottom">
   <%if session("PriceGroup") = "StorePrice" Or Session("PriceGroup") = "ExportPrice" Then
     If varSaleItem = 1 Then
      If varxxSale_WholesaleFootnoteText <> "" Then%>
      <p class="p_salefootnote"><%=varxxSale_WholesaleFootnoteText%></p>
     <%Else%>
      <p class="p_itemfootnote"><%=varxxItemFootnoteText%></p>
     <%End If%>
    <%else%>
     <p class="p_itemfootnote"><%=varxxItemFootnoteText%></p>
    <%End If
     Else
      If varSaleItem = 1 Then
       If varxxSale_RetailFootnoteText <> "" Then%>
      <p class="p_salefootnote"><%=varxxSale_RetailFootnoteText%></p>
     <%Else%>
      <p class="p_itemfootnote"><%=varxxItemFootnoteText%></p>
     <%End If%>
    <%else%>
     <p class="p_itemfootnote"><%=varxxItemFootnoteText%></p>
    <%End If
     End If%>
   </td></tr></table>
  <% End if%>
  </td></tr></table>
  </td><td width="20">
  <%'Checkmarks%>
 </td><td width="330"style="vertical-align:top;text-align:left">
  <table width="330"border="0"cellspacing="0" cellpadding="0" style="border-collapse:collapse">
  <tr><td width="26"height="26"style="vertical-align:bottom;text-align:left">
 <%if varxxUsedItem="n" then%>
  <img style="border:0px;cursor:default"src="<%=AssetsPath()%>/item-checkmark.gif">
 <%End if%>
  </td><td width="304"style="vertical-align:bottom;text-align:left">
  <%If varxxUsedItem = "n" Then
    If varxxFormat = "12""" Or varxxFormat = "10""" Or varxxFormat = "7""" Then%>
    <p class="item-facts">Brand-new</p>
   <%else%>
    <p class="item-facts">Brand-new, factory shrink wrapped</p>
   <%end if%>
  <%end if%>
  </tr><tr><td width="26"height="24"style="vertical-align:bottom;text-align:left">
  <img style="border:0px;cursor:default"src="<%=AssetsPath()%>/item-checkmark.gif">
  </td><td width="304"style="vertical-align:bottom;text-align:left">
  <p class="item-facts">In stock, ships today</p>
  </tr><tr><td width="26"height="24"style="vertical-align:bottom;text-align:left">
  <img style="border:0px;cursor:default"src="<%=AssetsPath()%>/item-checkmark.gif">
  </td><td width="304"style="vertical-align:bottom;text-align:left">
  <p class="item-facts">Ultra-secure packaging</p>
  </tr><tr><td width="26"height="24"style="vertical-align:bottom;text-align:left">
  <img style="border:0px;cursor:default"src="<%=AssetsPath()%>/item-checkmark.gif">
  </td><td width="304"style="vertical-align:bottom;text-align:left">
  <p class="item-facts">100% money-back guarantee</p>
  </td></tr></table>
 </td><td width="255"onclick="HD()">
 </td></tr></table>
 <%'Inventory Item Features
  Dim strItemFeatureHoverOverText As String = ""

  Using conn3 As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
   SqlConnection.ClearPool(conn3)
   conn3.Open()
   Dim CMD_XF As New SqlCommand("spInventoryItemFeaturesForProductDetailsPage", conn3)
   CMD_XF.CommandType = Data.CommandType.StoredProcedure
   CMD_XF.Parameters.AddWithValue("@InventoryID", varxxID)
   Dim xxF As SqlDataReader
   xxF = CMD_XF.ExecuteReader
   If xxF.HasRows Then%>
   <table align = "center" bgcolor="ffffff" cellpadding="0" cellspacing="0" width="1250" border="0">
   <tr><td width="1250"style="vertical-align:top;text-align:left;padding-top:25px">
   <table align="center" bgcolor="ffffff" cellpadding="0" cellspacing="0" width="585" border="0">
   <%Do While xxF.Read()
     strItemFeatureHoverOverText = ""
     If Not IsDBNull(xxF("ItemFeatureHoverOverText")) Then
      strItemFeatureHoverOverText = Replace(xxF("ItemFeatureHoverOverText"), """", "'")
     End If
     varItemFeatureID = xxF("InventoryItemFeatureID")%>
    <tr><td width="30"height="20"style="vertical-align:top;text-align:left">
    <img src = "<%=AssetsPath()%>/green-star.gif" style="vertical-align:top"/>
    </td><td width="555"style="vertical-align:top;text-align:left;padding-top:3px">
    <%If Not IsDBNull(xxF("ItemFeatureWebProductDetailsPageHyperlinkText")) Then%>
     <div class="fd"style="z-index:2000"id="IF<%=varxxID%>-<%=varItemFeatureID%>"onclick="hideItemFeaturesDiv('<%=varxxID%>-<%=varItemFeatureID%>')">
     <p class="item-features-div"><%=Replace(Replace(xxF("ItemFeatureWebProductDetailsPageHyperlinkText"), "NEW PARAGRAPH ", "<br/><br/>"), """", "'")%></p>
     </div>
    <%End If%>
    <a class="item-features"title="<%=strItemFeatureHoverOverText%>"style="vertical-align:top"href="/home.aspx?X3QT=ItemFeature&X3AID=<%=xxF("InventoryItemFeatureID")%>"><%=xxF("ItemFeatureWebProductDetailsPageText")%></a>
    <%If Not IsDBNull(xxF("ItemFeatureWebProductDetailsPageHyperlinkText")) Then%>
     <p class="whats-this"style="vertical-align:middle"onclick="showItemFeaturesDiv('<%=varxxID%>-<%=varItemFeatureID%>')">What's&nbsp;this?</p>
    <%End If%>
    </td></tr>
   <%Loop%>
   </table>
   </td></tr></table>
  <%End If
   End Using%>


 <%'Artist Title%>
 <table align="center" bgcolor="ffffff" cellpadding="0" cellspacing="0" width="1250" border="0">
 <tr><td height="20">
 </td></tr></table>
 <table align="center" bgcolor="ffffff" cellpadding="0" cellspacing="0" width="1250" border="0">
 <tr><td width="60">
 </td><td width="1130"style="text-align:center;vertical-align:top">
 <p class="artist"><%=varAT%></p>
 </td><td width="60">
 </tr><tr><td width="60"height="6">
 </td><td width="1130">
 </td><td width="60">
 </tr><tr><td width="60">
 </td><td width="1130"style="text-align:center;vertical-align:top">
 <p class="title"><%=varTitle%></p>
 </td><td width="60">
 </td></tr></table>
 <table align="center" bgcolor="ffffff" cellpadding="0" cellspacing="0" width="1250" border="0">
 <tr><td height="20">
 </td></tr></table>
 <%'Label, Year%>
 <table align="center" bgcolor="ffffff" cellpadding="0" cellspacing="0" width="1250" border="0">
 <tr><td width="100">
 </td><td bgcolor="EEEEEE"width="1050"style="text-align:center;vertical-align:middle;padding:8px;border-top:1px solid #AAAAAA;border-right:1px solid #AAAAAA;border-left:1px solid #AAAAAA">
 <p class="label-label">Label:</p>&nbsp;<a class="l"title="Show all items on this label."href="/home.aspx?i=1&labelID=<%=varxxID%>"><%=varxxLabel%></a>
 <% If varxxYearsText <> "" Then
  If InStr(1, varxxYearsText, "-") > 0 Then
   varYearTitleText = "Show all items recorded during these years."
  Else
   varYearTitleText = "Show all items recorded during this year."
  End If%>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<p class="label-label">Recorded:</p>&nbsp;<a class="l"title="<%=varYearTitleText%>"href="/home.aspx?i=1&yearID=<%=varxxID%>"><%=varxxYearsText%></a>
 <% End If%>
 </td><td width="100">
 </td></tr></table>
 <%'Genres%>
 <table align="center" bgcolor="ffffff" cellpadding="0" cellspacing="0" width="1250" border="0">
 <tr><td width="100">
 </td><td bgcolor="EEEEEE"width="1050"style="text-align:center;vertical-align:middle;padding-top:0px;padding-bottom:8px;padding-left:8px;padding-right:8px;border-right:1px solid #AAAAAA;border-left:1px solid #AAAAAA">
 <% If varxxGenre1 <> "" Then%>
  <p class="label-label">Genre:</p>&nbsp;<a class="l"title="Show all items on this genre."href="/home.aspx?i=1&genre=<%=Server.UrlEncode(varxxGenre1)%>"><%=varxxGenre1%></a>
  <% If varxxGenre2 <> "" Then%>
   <p class="label-label"> / </p><a class="l"title="Show all items on this genre."href="/home.aspx?i=1&genre=<%=Server.UrlEncode(varxxGenre2)%>"><%=varxxGenre2%></a>
  <% End If%>
  <% If varxxGenre3 <> "" Then%>
   <p class="label-label"> / </p><a class="l"title="Show all items on this genre."href="/home.aspx?i=1&genre=<%=Server.UrlEncode(varxxGenre3)%>"><%=varxxGenre3%></a>
  <% End If%>
  <% If varxxGenre4 <> "" Then%>
   <p class="label-label"> / </p><a class="l"title="Show all items on this genre."href="/home.aspx?i=1&genre=<%=Server.UrlEncode(varxxGenre4)%>"><%=varxxGenre4%></a>
  <% End If%>
  <% If varxxGenre5 <> "" Then%>
   <p class="label-label"> / </p><a class="l"title="Show all items on this genre."href="/home.aspx?i=1&genre=<%=Server.UrlEncode(varxxGenre5)%>"><%=varxxGenre5%></a>
  <% End If%>
  <% If varxxGenre6 <> "" Then%>
   <p class="label-label"> / </p><a class="l"title="Show all items on this genre."href="/home.aspx?i=1&genre=<%=Server.UrlEncode(varxxGenre6)%>"><%=varxxGenre6%></a>
  <% End If%>
  <% If varxxGenre7 <> "" Then%>
   <p class="label-label"> / </p><a class="l"title="Show all items on this genre."href="/home.aspx?i=1&genre=<%=Server.UrlEncode(varxxGenre7)%>"><%=varxxGenre7%></a>
  <% End If%>
  <% If varxxGenre8 <> "" Then%>
   <p class="label-label"> / </p><a class="l"title="Show all items on this genre."href="/home.aspx?i=1&genre=<%=Server.UrlEncode(varxxGenre8)%>"><%=varxxGenre8%></a>
  <% End If%>
  <% If varxxGenre9 <> "" Then%>
   <p class="label-label"> / </p><a class="l"title="Show all items on this genre."href="/home.aspx?i=1&genre=<%=Server.UrlEncode(varxxGenre9)%>"><%=varxxGenre9%></a>
  <% End If%>
 <%end if%>
 </td><td width="100">
 </td></tr></table>
 <%'Rhythm%>
 <%If varxxRhythmName<>"" then%>
  <table align="center" bgcolor="ffffff" cellpadding="0" cellspacing="0" width="1250" border="0">
  <tr><td width="100">
  </td><td bgcolor="EEEEEE"width="1050"style="text-align:center;vertical-align:middle;padding-top:0px;padding-bottom:8px;padding-left:8px;padding-right:8px;border-right:1px solid #AAAAAA;border-left:1px solid #AAAAAA">
  <p class="label-label">Rhythm:</p>&nbsp;<a class="l"title="Show all items on this rhythm."href="/home.aspx?X3QT=AllRhythm&X3AID=<%=varxxID%>"><%=varxxRhythmName%></a>
  </td><td width="100">
  </td></tr></table>
 <% End if%>
 <%'Item #, etc%>
 <table align="center" bgcolor="ffffff" cellpadding="0" cellspacing="0" width="1250" border="0">
 <tr><td width="100">
 </td><td bgcolor="EEEEEE"width="1050"style="text-align:center;vertical-align:middle;padding-top:0px;padding-bottom:8px;padding-left:8px;padding-right:8px;border-bottom:1px solid #AAAAAA;border-right:1px solid #AAAAAA;border-left:1px solid #AAAAAA">
 <p class="itemID">Our Item#:&nbsp;<%=varxxID%></p>
 <% If varxxUPC <> "" Then%>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<p class="itemID">UPC:&nbsp;<%=varxxUPC%></p>
 <% End If%>
 <% If varxxCatalog <> "" Then%>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<p class="itemID">Catalog:&nbsp;<%=varxxCatalog%></p>
 <% End If%>
 <% If varxxWeightInGrams <> "" Then%>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<p class="itemID">Item Weight:&nbsp;<%=varxxWeightInGrams%>&nbsp;grams</p>
 <% End If%>
 </td><td width="100">
 </td></tr></table>
 <table align="center" bgcolor="ffffff" cellpadding="0" cellspacing="0" width="1250" border="0">
 <tr><td height="20">
 </td></tr></table>
 <table align="center" bgcolor="ffffff" cellpadding="0" cellspacing="0" width="1250" border="0">
 <tr><td width="100">
 </td><td width="575"style="vertical-align:top;padding-right:50px">
 <%'Track Listing
  Dim varSongEnd As Integer = 0
  Dim varTrackNumber As Integer = 0
  Dim varEndOfTracks As Integer = 0
  Dim varLeadingZero As String = ""
  Dim varSongPointer As Integer = 0
  Dim varSongStart As Integer = 0
  Dim varSongTitle As String = ""

  If strShowSound = "y" And UCase(varxxMP3FileCompleted) = "Y" And InStr(1, varxxTracksGroup, "  1) ") > 0 And varxxNumberOfTracks > 0 Then%>
  <img class="b"alt="Tracks Listing"title="Track Listing for <%=NoQuotes(WebSiteSEOCode(varxxArtistTitle))%>."src="<%=AssetsPath()%>/i-track-listing.gif" /><br/>
  <%varSongEnd = 1
  varTrackNumber = 0
  varEndOfTracks = 0
  For n = 1 To CInt(varxxNumberOfTracks)
   varLeadingZero = ""
   varTrackNumber = n
   If varTrackNumber < 10 Then varLeadingZero = "0"
   If n < 100 Then
    varSongStart = InStr(varSongEnd, varxxTracksGroup, varTrackNumber & ") ") + 3
   Else
    varSongStart = InStr(varSongEnd, varxxTracksGroup, varTrackNumber & ") ") + 4
   End If
   varSongEnd = InStr(varSongStart, varxxTracksGroup, "  ") - 1
   If varSongEnd <= 0 Then
    varSongEnd = Len(varxxTracksGroup)
    varEndOfTracks = 1
   End If
   varSongTitle = Mid(varxxTracksGroup, varSongStart, varSongEnd - varSongStart + 1)%>
    <img name="T<%=varxxID%>T<%=varLeadingZero%><%=n%>"id="T<%=varxxID%>T<%=varLeadingZero%><%=n%>"style="vertical-align:middle;cursor:pointer"src="<%=AssetsPath()%>/play-sound.gif"alt="Play song"title="Play sound sample"onclick="T('T<%=varxxID%>T<%=varLeadingZero%><%=n%>','<%=MP3Folder(varxxID)%>')"onmouseover="fov(this,'play-sound')"onmouseout="fou(this,'play-sound')"><p class="tracks"><%=n%>. </P><h2 class="tracks"><%=varSongTitle%></H2><br/>
    <% If varEndOfTracks = 1 Then Exit For
  Next
  If Request.QueryString("ps") = "1" Then%>
   <script language="javascript">
   T('T<%=varxxID%>T01','<%=MP3Folder(varxxID)%>')
    </script>
  <%End If
  ElseIf InStr(1, varxxTracksGroup, "  1) ") > 0 And varxxNumberOfTracks > 0 Then%>
   <img class="b"alt="Tracks Listing"title="Track Listing for <%=NoQuotes(WebSiteSEOCode(varxxArtistTitle))%>."src="<%=AssetsPath()%>/i-track-listing.gif"><br/>
   <%varSongEnd = 1
  varTrackNumber = 0
  varEndOfTracks = 0
  For n = 1 To CInt(varxxNumberOfTracks)
   varLeadingZero = ""
   varTrackNumber = n
   If varTrackNumber < 10 Then varLeadingZero = "0"
   If n < 100 Then
    varSongStart = InStr(varSongEnd, varxxTracksGroup, varTrackNumber & ") ") + 3
   Else
    varSongStart = InStr(varSongEnd, varxxTracksGroup, varTrackNumber & ") ") + 4
   End If
   varSongEnd = InStr(varSongStart, varxxTracksGroup, "  ") - 1
   If varSongEnd <= 0 Then
    varSongEnd = Len(varxxTracksGroup)
    varEndOfTracks = 1
   End If
   varSongTitle = Mid(varxxTracksGroup, varSongStart, varSongEnd - varSongStart + 1)%>
     <img style="vertical-align:middle"src="<%=AssetsPath()%>/ns.gif"><p class="tracks"><%=n%>. </P><H2 class="tracks"><%=varSongTitle%></H2><br/>
     <% If varEndOfTracks = 1 Then Exit For
   Next
  ElseIf ((varxxFormat = "CD" Or varxxFormat = "LP") And InStr(UCase(varxxArtistTitle), "RECORD BAG") = 0) Then%>
 <% End If%>
 </td><td width="475"style="vertical-align:top">
 <%'Condition
  If ucase(varxxUsedItem) = "Y" Then%>
 <img class="b"alt="Condition"src="<%=AssetsPath()%>/condition.gif"/><br/>
  <%If varxxFormat = "CD" Then%>
   <p class="review">All used CDs play perfectly and have brand-new jewel cases. Backed by our 100% money-back guarantee.</p><br/>
  <%ElseIf varxxFormat = "DVD" Then%>
   <p Class="review">All used DVDs play perfectly and are backed by our 100% money-back guarantee.</p><br/>
  <%ElseIf varxxFormat = "VHS" Then%>
   <p class="review">All used VHS (videotapes) play perfectly and are backed by our 100% money-back guarantee.</p><br/>
  <%ElseIf varxxFormat = "CS" Then%>
    <p Class="review">All used cassette tapes play perfectly and are backed by our 100% money-back guarantee.</p><br/>
  <%Else%>
   <%If varxxConditionJacket <> "" Then%>
    <p class="review">Jacket Condition = <%=varxxConditionJacket%></p>
    <%If varxxConditionText <> "" Then%>
     <div class="ctd"style="z-index:2000"id="JacketConditionDiv"onclick="hideConditionTextDiv('JacketConditionDiv')">
     <p class="condition-text-div"><%=varxxConditionText%></p>
     </div>
     <img onclick="showConditionTextDiv('JacketConditionDiv')"style="cursor:pointer;margin-top:-2px;margin-left:5px"src="<%=AssetsPath()%>/question-blue.gif" />
    <%End If%>
    <br/>
   <%End If%>
  <%End If%>

  <%If varxxConditionVinylOrCD <> "" And (varxxFormat = "LP" Or varxxFormat = "12""" Or varxxFormat = "10""" Or varxxFormat = "7""") Then%>
   <p class="review">Vinyl Condition &nbsp;&nbsp;= <%=varxxConditionVinylOrCD%></p>
    <%If varxxConditionText <> "" Then%>
     <div class="ctd"style="z-index:2000"id="VinylConditionDiv"onclick="hideConditionTextDiv('VinylConditionDiv')">
     <p class="condition-text-div"><%=varxxConditionText%></p>
     </div>
     <img onclick="showConditionTextDiv('VinylConditionDiv')"style="cursor:pointer;margin-top:-2px;margin-left:5px"src="<%=AssetsPath()%>/question-blue.gif" />
    <%End If%>
    <br/>
  <%End If%>
 
  <%If varxxConditionNotes <> "" Then%>
   <p class="review"><%=varxxConditionNotes%></p><br/>
  <%End If%>
 <%End If%>
 <%'Review
 Dim varGif As Integer = 0
 Dim varGif2 As Integer = 0

 If varxxWebReviewHTML <> "" Then
  varGif = InStr(1, varxxWebReviewHTML, "yr1.gif")
  varGif2 = InStr(1, varxxWebReviewHTML, "yrd.gif")
  If varGif > 0 Then%>
  <img class="b"alt="Album review for <%=NoQuotes(WebSiteSEOCode(varxxArtistTitle))%>"title="Album review for <%=NoQuotes(WebSiteSEOCode(varxxArtistTitle))%>"src="<%=AssetsPath()%>/review.gif"/><br/>
  <p class="review"><%=Trim(Right(varxxWebReviewHTML, Len(varxxWebReviewHTML) - varGif - 12))%></p><br/><br/>
 <%ElseIf varGif2 > 0 Then%>
   <img class="b"alt="Album review for <%=NoQuotes(WebSiteSEOCode(varxxArtistTitle))%>"title="Album review for <%=NoQuotes(WebSiteSEOCode(varxxArtistTitle))%>"src="<%=AssetsPath()%>/review.gif"/><br/>
   <p class="review"><%=Trim(Right(varxxWebReviewHTML, Len(varxxWebReviewHTML) - varGif2 - 12))%></p><br/><br/>
  <%Else%>
   <img class="b"alt="Album review for <%=NoQuotes(WebSiteSEOCode(varxxArtistTitle))%>"title="Album review for <%=NoQuotes(WebSiteSEOCode(varxxArtistTitle))%>"src="<%=AssetsPath()%>/review.gif"/><br/>
   <p class="review"><%=varxxWebReviewHTML%></p><br/><br/>
  <% End If%>
 <% End If%>
 <%'Musicians
  If Len(varxxMusicianGroup) > 0 Then
   varGif = InStr(1, varxxMusicianGroup, "ym1.gif")
   If varGif > 0 Then%>
  <img class="b"alt="Musicians for <%=NoQuotes(WebSiteSEOCode(varxxArtistTitle))%>"title="Musicians for <%=NoQuotes(WebSiteSEOCode(varxxArtistTitle))%>"src="<%=AssetsPath()%>/i-musicians.gif"><br/>
  <p class="musicians"><%=Trim(Right(varxxMusicianGroup, Len(varxxMusicianGroup) - varGif - 12))%></p><br/><br/>
  <% End If%>
 <%end if%>
 <%'Production
  If Len(varxxProduceGroup) > 0 Then
   varGif = InStr(1, varxxProduceGroup, "yp1.gif")
   If varGif > 0 Then%>
  <img class="b"alt="Production for <%=NoQuotes(WebSiteSEOCode(varxxArtistTitle))%>"title="Production for <%=NoQuotes(WebSiteSEOCode(varxxArtistTitle))%>"src="<%=AssetsPath()%>/i-production.gif"><br/>
  <p class="production"><%=Trim(Right(varxxProduceGroup, Len(varxxProduceGroup) - varGif - 12))%></p><br/>
  <%End If%>
 <%end if%>
 </td><td width="100">
 </td></tr></table>
<%End if %>

<%'Customer Viewed
 If varSimilarItemsAvailable = 1 And ns > 1 And varKnownSearchEngineUserAgent = 0 Then%>
  <table align="center" bgcolor="ffffff" cellpadding="0" cellspacing="0" width="1250" border="0">
  <tr><td height="80"style="vertical-align:bottom">
  <p style="font-size:22px;font-weight:600;color:#c74100;margin-left:75px">You may also be interested in...</p>
  </td></tr></table> 
  <table align="center" bgcolor="ffffff" cellpadding="0" cellspacing="0" width="1250" border="0"style="border-collapse:collapse">
  <tr><td height="218"width="62"style="vertical-align:middle;text-align:right">
  <%If CVid(5) > 0 Then%>
   <img alt=""id="imgCVPrevious"onclick="CVnextbatch('-')"onmouseover="fov(this,'arrow-previous')"onmouseout="fou(this,'arrow-previous')"style="visibility:hidden;cursor:pointer;margin-top:0px;margin-right:0px"src="<%=AssetsPath()%>/arrow-previous.gif" />
  <%End If%>
  </td><td width="225"style="vertical-align:bottom;text-align:center">
  <%If CVid(0) > 0 Then%>
   <a id="CVhref1"href="/itemdetails.aspx?ID=<%=CVid(0)%>"><img alt=""title="" id="CVimg1" class="CVimg" width="" height="<%=CVImageHeight%>" src="<%=ScanPath(CInt(CVid(0)), "320", "A")%>" onerror="this.onerror=null;this.src='<%=var_err_img%>'"/></a>
  <%  End If%>
  </td><td width="225"style="vertical-align:bottom;text-align:center">
  <%If CVid(1) > 0 Then%>
   <a id="CVhref2"href="/itemdetails.aspx?ID=<%=CVid(1)%>"><img alt=""title="" id="CVimg2" class="CVimg" width="" height="<%=CVImageHeight%>" src="<%=ScanPath(CInt(CVid(1)), "320", "A")%>" onerror="this.onerror=null;this.src='<%=var_err_img%>'"/></a>
  <%  End If%>
  </td><td width="225"style="vertical-align:bottom;text-align:center">
  <%If CVid(2) > 0 Then%>
   <a id="CVhref3"href="/itemdetails.aspx?ID=<%=CVid(2)%>"><img alt=""title="" id="CVimg3" class="CVimg" width="" height="<%=CVImageHeight%>" src="<%=ScanPath(CInt(CVid(2)), "320", "A")%>" onerror="this.onerror=null;this.src='<%=var_err_img%>'"/></a>
  <%  End If%>
  </td><td width="225"style="vertical-align:bottom;text-align:center">
  <%If CVid(3) > 0 Then%>
   <a id="CVhref4"href="/itemdetails.aspx?ID=<%=CVid(3)%>"><img alt=""title="" id="CVimg4" class="CVimg" width="" height="<%=CVImageHeight%>" src="<%=ScanPath(CInt(CVid(3)), "320", "A")%>" onerror="this.onerror=null;this.src='<%=var_err_img%>'"/></a>
  <%  End If%>
  </td><td width="225"style="vertical-align:bottom;text-align:center">
  <%If CVid(4) > 0 Then%>
   <a id="CVhref5"href="/itemdetails.aspx?ID=<%=CVid(4)%>"><img alt=""title="" id="CVimg5" class="CVimg" width="" height="<%=CVImageHeight%>" src="<%=ScanPath(CInt(CVid(4)), "320", "A")%>" onerror="this.onerror=null;this.src='<%=var_err_img%>'"/></a>
  <%  End If%>
  </td><td width="63"style="vertical-align:middle;text-align:left">
  <%If CVid(5) > 0 Then%>
   <img alt=""id="imgCVNext"onclick="CVnextbatch('+')"onmouseover="fov(this,'arrow-next')"onmouseout="fou(this,'arrow-next')"style="cursor:pointer;margin-top:0px;margin-left:0px"src="<%=AssetsPath()%>/arrow-next.gif" />
  <%End If%>
  </td></tr></table> 
  <table align="center" bgcolor="ffffff" cellpadding="0" cellspacing="0" width="1250" border="0"style="border-collapse:collapse;vertical-align:top">
  <tr><td width="74">
  </td><td width="201"height="48"style="vertical-align:top;text-align:center">
  <div class="CV"id="CVdiv1">
  <p id="CVp1"class="CV"><%=CVat(0)%></p>
  </div>
  </td><td width="24">
  </td><td width="201"height="48"style="vertical-align:top;text-align:center">
  <div class="CV"id="CVdiv2">
  <p id="CVp2"class="CV"><%=CVat(1)%></p>
  </div>
  </td><td width="24">
  </td><td width="201"height="48"style="vertical-align:top;text-align:center">
  <div class="CV"id="CVdiv3">
  <p id="CVp3"class="CV"><%=CVat(2)%></p>
  </div>
  </td><td width="24">
  </td><td width="201"height="48"style="vertical-align:top;text-align:center">
  <div class="CV"id="CVdiv4">
  <p id="CVp4"class="CV"><%=CVat(3)%></p>
  </div>
  </td><td width="24">
  </td><td width="201"height="48"style="vertical-align:top;text-align:center">
  <div class="CV"id="CVdiv5">
  <p id="CVp5"class="CV"><%=CVat(4)%></p>
  </div>
  </td><td width="75">
  </td></tr></table> 
<%End If%>

 <%'More By This Artist
  If strArtistForMoreBy <> "" And nsa > 1 And varKnownSearchEngineUserAgent = 0 Then%>
  <table align="center" bgcolor="ffffff" cellpadding="0" cellspacing="0" width="1250" border="0">
  <tr><td height="45"style="vertical-align:bottom">
  <%If Left(MBat(0), 5) = "<b>LP" Or Left(MBat(0), 5) = "<b>CD" Or Left(MBat(0), 5) = "<b>7 " Or Left(MBat(0), 5) = "<b>12" Or Left(MBat(0), 5) = "<b>10" Then%>
   <p style="font-size:22px;font-weight:600;color:#c74100;margin-left:75px">More by <%=Replace(strArtistForMoreBy, "''", "'")%>...</p>
  <%Else%>
   <p style="font-size:22px;font-weight:600;color:#c74100;margin-left:75px">You may also be interested in...</p>
  <%end If%>
  </td></tr></table> 
  <table align="center" bgcolor="ffffff" cellpadding="0" cellspacing="0" width="1250" border="0">
  <tr><td height="218"width="62"style="vertical-align:middle;text-align:right">
  <%If MBid(5) > 0 Then%>
   <img alt=""id="imgMBPrevious"onclick="MBnextbatch('-')"onmouseover="fov(this,'arrow-previous')"onmouseout="fou(this,'arrow-previous')"style="visibility:hidden;cursor:pointer;margin-top:0px;margin-right:0px"src="<%=AssetsPath()%>/arrow-previous.gif" />
  <%End If%>
  </td><td width="225"style="vertical-align:bottom;text-align:center">
  <%If MBid(0) > 0 Then%>
   <a id="MBhref1"href="/itemdetails.aspx?ID=<%=MBid(0)%>"><img alt=""title="" id="MBimg1" class="MBimg" width="" height="<%=MBImageHeight%>" src="<%=ScanPath(CInt(MBid(0)), "320", "A")%>" onerror="this.onerror=null;this.src='<%=var_err_img%>'"/></a>
  <%  End If%>
  </td><td width="225"style="vertical-align:bottom;text-align:center">
  <%If MBid(1) > 0 Then%>
   <a id="MBhref2"href="/itemdetails.aspx?ID=<%=MBid(1)%>"><img alt=""title="" id="MBimg2" class="MBimg" width="" height="<%=MBImageHeight%>" src="<%=ScanPath(CInt(MBid(1)), "320", "A")%>" onerror="this.onerror=null;this.src='<%=var_err_img%>'"/></a>
  <%  End If%>
  </td><td width="225"style="vertical-align:bottom;text-align:center">
  <%If MBid(2) > 0 Then%>
   <a id="MBhref3"href="/itemdetails.aspx?ID=<%=MBid(2)%>"><img alt=""title="" id="MBimg3" class="MBimg" width="" height="<%=MBImageHeight%>" src="<%=ScanPath(CInt(MBid(2)), "320", "A")%>" onerror="this.onerror=null;this.src='<%=var_err_img%>'"/></a>
  <%  End If%>
  </td><td width="225"style="vertical-align:bottom;text-align:center">
  <%If MBid(3) > 0 Then%>
   <a id="MBhref4"href="/itemdetails.aspx?ID=<%=MBid(3)%>"><img alt=""title="" id="MBimg4" class="MBimg" width="" height="<%=MBImageHeight%>" src="<%=ScanPath(CInt(MBid(3)), "320", "A")%>" onerror="this.onerror=null;this.src='<%=var_err_img%>'"/></a>
  <%  End If%>
  </td><td width="225"style="vertical-align:bottom;text-align:center">
  <%If MBid(4) > 0 Then%>
   <a id="MBhref5"href="/itemdetails.aspx?ID=<%=MBid(4)%>"><img alt=""title="" id="MBimg5" class="MBimg" width="" height="<%=MBImageHeight%>" src="<%=ScanPath(CInt(MBid(4)), "320", "A")%>" onerror="this.onerror=null;this.src='<%=var_err_img%>'"/></a>
  <%  End If%>
  </td><td width="63"style="vertical-align:middle;text-align:left">
  <%If MBid(5) > 0 Then%>
   <img alt=""id="imgMBNext"onclick="MBnextbatch('+')"onmouseover="fov(this,'arrow-next')"onmouseout="fou(this,'arrow-next')"style="cursor:pointer;margin-top:0px;margin-left:0px"src="<%=AssetsPath()%>/arrow-next.gif" />
  <%End If%>
  </td></tr></table> 
  <table align="center" bgcolor="ffffff" cellpadding="0" cellspacing="0" width="1250" border="0"style="border-collapse:collapse">
  <tr><td width="74">
  </td><td width="201"height="48"style="vertical-align:top;text-align:center">
  <div class="CV"id="MBdiv1">
  <p id="MBp1"class="CV"><%=MBat(0)%></p>
  </div>
  </td><td width="24">
  </td><td width="201"height="48"style="vertical-align:top;text-align:center">
  <div class="CV"id="MBdiv2">
  <p id="MBp2"class="CV"><%=MBat(1)%></p>
  </div>
  </td><td width="24">
  </td><td width="201"height="48"style="vertical-align:top;text-align:center">
  <div class="CV"id="MBdiv3">
  <p id="MBp3"class="CV"><%=MBat(2)%></p>
  </div>
  </td><td width="24">
  </td><td width="201"height="48"style="vertical-align:top;text-align:center">
  <div class="CV"id="MBdiv4">
  <p id="MBp4"class="CV"><%=MBat(3)%></p>
  </div>
  </td><td width="24">
  </td><td width="201"height="48"style="vertical-align:top;text-align:center">
  <div class="CV"id="MBdiv5">
  <p id="MBp5"class="CV"><%=MBat(4)%></p>
  </div>
  </td><td width="75">
  </td></tr></table> 
<%End If%>
<%'Bottom%>
<table align="center" bgcolor="ffffff" cellpadding="0" cellspacing="0" width="1250" border="0">
<tr><td height="50">
</td></tr></table>
<table cellpadding="0" cellspacing="0" WIDTH="1250" align="center" BORDER="0">
<tr><td width="7"><img alt="" src="<%=AssetsPath()%>/tblw.gif" WIDTH="8" HEIGHT="7">
</td><td bgcolor="fffffff" width="99%">
</td><td width="7"><img alt="" src="<%=AssetsPath()%>/tbrw.gif" WIDTH="8" HEIGHT="7">
</td></tr></table> 
<table cellpadding="0" cellspacing="0" width="1250" align="center" BORDER="0">
<tr><td align="center"><font face="arial" style="font-size:13px"color="ffffff"><%=CopyrightFooter()%></font>
</td></tr><table>

<br/><br/><br/>
</body>
</html>
