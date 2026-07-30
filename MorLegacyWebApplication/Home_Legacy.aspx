<%
' @module Home_Page
' @description Core landing page logic and search processing
' @exports var_err_img, varQueryType
%>

<%@ page language="VB" debug="true" autoeventwireup="false" enableviewstate="false" %>

<%@ import namespace="System" %>
<%@ import namespace="System.Net" %>
<%@ import namespace="System.IO" %>
<%@ import namespace="System.Data.SqlClient" %>
<%@ import namespace="System.Web" %>

<%
 'Check for valid Request.QueryStrings
 If Len(Request.QueryString("LabelID")) > 6 Then
  Response.Redirect("/Home.aspx")
 End If
 If Len(Request.QueryString("YearID")) > 6 Then
  Response.Redirect("/Home.aspx")
 End If
 If Request.QueryString("X3SR") <> "" Then
  If Len(Request.QueryString("X3SR")) > 6 Then
   Response.Redirect("/Home.aspx")
  End If
  If Not IsNumeric(Request.QueryString("X3SR")) Then
   Response.Redirect("/Home.aspx")
  End If
 End If
 If Request.QueryString("X3P") <> "" Then
  If Len(Request.QueryString("X3P")) > 5 Then
   Response.Redirect("/Home.aspx")
  End If
  If Not IsNumeric(Request.QueryString("X3P")) Then
   Response.Redirect("/Home.aspx")
  End If
 End If

 Dim var_err_img As String = AssetsPath() & "/out-288.jpg"
 Dim varRecordSearchCriteria As Integer = 0
 Dim z As Integer=0
 Dim varRecordsLimit
 Dim var15PerPageSelected As String = ""
 Dim var25PerPageSelected As String = ""
 Dim var50PerPageSelected As String = ""
 Dim var100PerPageSelected As String=""
 Dim var200PerPageSelected As String=""
 Dim var500PerPageSelected As String = ""
 Dim varSortSelectedFormatArtist As String = ""
 Dim varSortSelectedFormatLabel As String = ""
 Dim varSortSelectedFormatBestSellers As String = ""
 Dim varSortSelectedFormatPriceHighest As String = ""
 Dim varSortSelectedFormatPriceLowest As String = ""
 Dim varSortSelectedRecentArrivalDate As String = ""
 Dim varShowSales As Integer=0
 Dim varThumbnailImageSource As String=""
 Dim varSupersizeButton As Integer = 0
 Dim varNumberOfImages As Integer = 0
 Dim varFirstImageSource As String = ""
 Dim varFirstImageSourceForSupersize As String = ""
 Dim varSecondImageSource As String = ""
 Dim varSecondImageSourceForSupersize As String = ""
 Dim varLoadingImageSource As String=""
 Dim varImageBorder As String=""
 Dim varFormatIcon As String=0
 Dim strMostRecentDateBoughtItem As String = ""
 Dim strQuantityBought As String = ""
 Dim varSaleItem As integer=0
 Dim varPriceGroupPrice As Decimal = 0
 Dim varPriceUsing As Decimal = 0
 Dim intQuantityInCart As integer=0
 Dim varCartPrice As Decimal = 0
 Dim varCartDateTime As DateTime
 Dim varPriceForCartAddText As String=""
 Dim varCartFColor As String=""
 Dim varInStock As Integer=0
 Dim varStockText As string=""
 dim varUsedItem As string="n"
 Dim varAT As String = ""
 Dim varFirstZLImageSource As String = ""
 Dim varSecondZLImageSource As String=""
 Dim varImageClass As String=""
 Dim varInv As String=""
 Dim varFC As String=""
 Dim varPadTop As String=""
 Dim intDaysSinceBought As Integer=0
 Dim varYearString As String=""
 Dim varImageHoverText As String=""
 Dim varListYearFrom As String=""
 Dim varListYearFromOriginal As String = ""
 Dim varListYearToOriginal As String = ""
 Dim varSimilarItemsAvailable As Integer=0
 Dim varBGForHere As String=""
 Dim pagenumbernext As Integer=0
 Dim varDefaultImageSource As String = ""
 Dim varFormat As String=""
 Dim varSongEnd As Integer = 0
 Dim varTrackNumber As Integer = 0
 Dim varEndOfTracks As Integer = 0
 Dim varLeadingZero As String = ""
 Dim varSongPointer As Integer = 0
 Dim varSongStart As Integer = 0
 Dim varSongTitle As String = ""
 Dim varxxTracksGroup As String = ""
 Dim varxxNumberOfTracks As Integer = 0
 Dim varItemFeatureID As String = ""
 Dim varxxMP3FileCompleted As String = ""
 Dim varItemFeatureTextThumbnailView As String = ""
 Dim intIF As Integer = 0
 Dim intPipe1 As Integer = 0
 Dim intPipe2 As Integer = 0
 Dim intPipe3 As Integer = 0
 Dim intPipe4 As Integer = 0
 Dim intPipe5 As Integer = 0
 Dim intPipe6 As Integer = 0
 Dim strItemFeature As String = ""
 Dim strItemFeatureIDText As String = ""
 Dim strItemFeatureWebGalleryText As String = ""
 Dim strItemFeatureWebProductDetailsPageText As String = ""
 Dim strItemFeatureWebProductDetailsPageHyperlinkText As String = ""
 Dim strItemFeatureHoverText As String = ""
 Dim varWebSearchSuggestionHint As String = ""
 Dim varWebSearchSuggestionHintRaw As String = ""
 Dim varWebSearchSuggestionSearchType As String = ""
 Dim strQuickSuggestionFormatSQL As String = ""
 Dim varSavedForLaterHeaderChecked As Integer = 0
 Dim defaultPostalCode As String = ""
 Dim defaultStateProvince As String = ""
 Dim varZip3 As String = ""
 Dim defaultCountry As String = ""
 Dim varUPSGroundZone As String = ""
 Dim varDHLInternationalZone As String = ""
 Dim varFedExGroundZone As String = ""
 Dim varUPSGroundCanadaZone As String = ""
 Dim varPriorityMailZone As String = ""
 Dim varExpressMailZone As String = ""
 Dim varMediaMailZone As String = ""
 Dim varAirMailLetterPostZone As String = ""
 Dim varAirParcelPostZone As String = ""
 Dim varGlobalExpressZone As String = ""
 Dim varFedExExpressZone As String = ""
 Dim varFedExInternationalPriorityZone As String = ""
 Dim varFedExInternationalEconomyZone As String = ""
 Dim varFirstClassRateUsed As Integer = 0
 Dim varLastRateChecked As Decimal = 0
 Dim intN As Integer = 0
 Dim varVariousGenre As String = ""
 Dim intNN As Integer = 0
 Dim strAllLabel1 As String = ""
 Dim strAllLabel2 As String = "qxqxqxqxqxqx"
 Dim strAllLabel3 As String = "qxqxqxqxqxqx"
 Dim intLabelNameSearchSlash As Integer = 0
 Dim intInventoryID As Integer = 0
 Dim varCVItemID As Integer = 0
 Dim varCVFormatOrder As Integer = 100000
 Dim varCVSalesLast30Days As Integer = 0
 Dim varButtonColor As String = Request("BC")
 Dim varFromOurSite As String = "n"
 Dim strShowSound As String = "n"

 If Not String.IsNullOrEmpty(Request.ServerVariables("HTTP_REFERER")) Then
  If InStr(Request.ServerVariables("HTTP_REFERER"), "millionsofrecords") > 0 Then
   varFromOurSite = "y"
  End If
 End If
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

 'Product Weight
 Dim varWeightOfProductInGrams As Integer = 0
 Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
  SqlConnection.ClearPool(conn)
  conn.Open()
  Dim CMD_Y As New SqlCommand("spGetWeightOfProduct", conn)
  CMD_Y.CommandType = Data.CommandType.StoredProcedure
  CMD_Y.Parameters.AddWithValue("@CartName", NameOfCart)
  Dim readerY As SqlDataReader
  readerY = CMD_Y.ExecuteReader
  If readerY.HasRows Then
   readerY.Read()
   varWeightOfProductInGrams = readerY("sumweight")
  End If
 End Using

 'Cart Page?
 Dim varCartPage As Integer = 0
 If Request.QueryString("TabH")="Cart" or request.QueryString("X3QT")="PageSearchForCart" then
  varCartPage=1
 end If

 Dim strSQL As String = ""
 Dim n As Integer = 0
 Dim ua As String = Request.ServerVariables("HTTP_USER_AGENT")
 Dim artistpart(40)

 'Major Browsers
 Dim varMajorBrowser As Integer = 0
 Dim MajorBrowsers(8)
 MajorBrowsers(0) = "CHROME"
 MajorBrowsers(1) = "IPHONE"
 MajorBrowsers(2) = "EDGE"
 MajorBrowsers(3) = "ANDROID"
 MajorBrowsers(4) = "MSIE"
 MajorBrowsers(5) = "SAFARI"
 MajorBrowsers(6) = "TRIDENT"
 MajorBrowsers(7) = "FIREFOX"
 MajorBrowsers(8) = "OPERA"
 For n = 0 To 8
  If InStr(1, UCase(ua), MajorBrowsers(n)) > 0 Then
   varMajorBrowser = 1
  End If
 Next

 Dim varKnownSearchEngineUserAgent As Integer = 0
 If InStr(1, UCase(ua), "GOOGLEBOT") > 0 Or InStr(1, UCase(ua), "GOOGLE.") > 0 Or InStr(1, UCase(ua), "BINGBOT") > 0 Or InStr(1, UCase(ua), "BINGPREVIEW") > 0 Or InStr(1, UCase(ua), "METASR") > 0 Or InStr(1, UCase(ua), "SLURP") > 0 Then
  varKnownSearchEngineUserAgent = 1
 End If

 'Empty The Cart
 If Session("Powerusername") <> "" Then
  If Request.QueryString("emptythecart") = "1" Then
   Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
    SqlConnection.ClearPool(conn)
    conn.Open()
    Dim CMD_X As New SqlCommand("spEmptyTheCart", conn)
    CMD_X.CommandType = Data.CommandType.StoredProcedure
    CMD_X.Parameters.AddWithValue("@Cartname", NameOfCart)
    CMD_X.ExecuteNonQuery()
   End Using
  End If
 End If

 'Residential Delivery
 Dim varResidentialDelivery As String = "YES"
 If varCartPage=1 Then
  If Session("PriceGroup") = "StorePrice" Or Session("PriceGroup") = "ExportPrice" Then
   Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
    SqlConnection.ClearPool(conn)
    conn.Open()
    Dim CMD_X As New SqlCommand("spResidentialDelivery", conn)
    CMD_X.CommandType = Data.CommandType.StoredProcedure
    CMD_X.Parameters.AddWithValue("@counter", IsSomething(Session("CustomerServerCounter"), "0"))
    Dim readerX As SqlDataReader
    readerX = CMD_X.ExecuteReader
    If readerX.HasRows Then
     readerX.Read()
     If UCase(readerX("ResidentialDelivery")) = "Y" Then
      varResidentialDelivery = "YES"
     Else
      varResidentialDelivery = "NO"
     End If
    End If
   End Using
  End if
 end If

 'CustomerID
 Dim varCustomerID As Integer = 0
 If session("CustomerID") <> "" And isnumeric(session("CustomerID")) Then
  varCustomerID = session("CustomerID")
 End If
 'Update Hold Price to lower of Hold Price or Invetnory Price
 If varCartPage = 1 Then
  strSQL = "update carts" _
   & " set price=[" & varPriceGroup & "]" _
   & " from carts,inventory" _
   & " where inventory.id=carts.itemid" _
   & " and cartname='" & NameOfCart & "'" _
   & " and [" & varPriceGroup & "] < price"
  Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
   SqlConnection.ClearPool(conn)
   conn.Open()
   Dim CMD_X As New SqlCommand(strSQL, conn)
   CMD_X.CommandType = Data.CommandType.Text
   CMD_X.ExecuteNonQuery()
  End Using
 End If

 Dim varAllLabelName As String = ""
 Dim varAllRhythmName As String = ""
 Dim varAllGenreName As String = ""

 'X3 request info
 Dim varIFID As String = "0"
 Dim RecordNumber As Integer=0
 Dim varSortOrder As String = Request("X3SO")
 Dim varSortOrderStatistic As String = Request("X3SO")
 Dim varStartRecord As Integer = 0
 If IsNumeric(Request("X3SR")) Then
  varStartRecord = Request("X3SR")
 End If
 Dim varPageOn As String = Request("X3P")
 Dim varPageQuery As String = "y"
 Dim varLabelExact As String = Request("X3LEL3")
 Dim varGenreExact As String = Request("X3GEL3")
 Dim varArtistExact As String = Request("X3AEL3")
 Dim varArtistSearchType As String = Request("X3ASTL3")
 Dim varArtistSearchTypeCounter As String = Request("X3ASTCL3")
 Dim varRhythmExact As String = Request("X3REL3")
 Dim varArtistSelected As String = Request("X3ASEL3")
 Dim varLabelSelected As String = Request("X3LSEL3")
 Dim varGenreSelected As String = Request("X3GSEL3")
 Dim varAllID As String = Request("X3AIDL3")
 Dim varAllArtistName As String = Request("X3AANL3")
 Dim varQueryType As String = Request("X3QTL3")
 Dim varArtistCriteria As String = Request("X3AL3")
 Dim varFormatCriteria As String = Request("X3FL3")
 Dim varRecentCriteria As String = Request("X3RL3")
 Dim varRhythmCriteria As String = Request("X3RYL3")
 Dim varlabelCriteria As String = Request("X3LL3")
 Dim varIncludeUsedCriteria As String = Request("X3IUL3")
 Dim varGenreCriteria As String = Request("X3GL3")
 Dim varYearCriteria As String = Request("X3YL3")
 Dim varPriceCriteria As String = Request("X3PRL3")
 Dim varReggaeOrNonReggae As String = Request("X3RONL3")
 Dim varErnieMessageID As String = Request("X3EMIDL3")
 Dim varCustBoughtFormat As String = Request("X3CBFL3")
 Dim varCustBoughtDays As String = Request("X3CBDL3")
 Dim varKeepSearchCriteria As String = ""
 Dim varAllGenre As String = ""
 If Request("X3KSL3") <> "" Then varKeepSearchCriteria = Request("X3KSL3")
 If Request("X3QT") = "PageSearch" Or Request.QueryString("X3QT") = "PageSearchForCart" Or Request("X3QT") = "NewSort" Then
  varSortOrder = Request("X3SO")
  varSortOrderStatistic = Request("X3SO")
  If IsNumeric(Request("X3SR")) Then
   varStartRecord = Request("X3SR")
  End If
  varPageOn = Request("X3P")
  varPageQuery = "y"
  varLabelExact = Request("X3LEL3")
  varGenreExact = Request("X3GEL3")
  varArtistExact = Request("X3AEL3")
  varArtistSearchType = Request("X3ASTL3")
  varArtistSearchTypeCounter = Request("X3ASTCL3")
  varRhythmExact = Request("X3REL3")
  varArtistSelected = Request("X3ASEL3")
  varLabelSelected = Request("X3LSEL3")
  varGenreSelected = Request("X3GSEL3")
  varAllID = Request("X3AIDL3")
  varAllArtistName = Request("X3AANL3")
  varQueryType = Request("X3QTL3")
  varArtistCriteria = Request("X3AL3")
  varFormatCriteria = Request("X3FL3")
  varRecentCriteria = Request("X3RL3")
  varRhythmCriteria = Request("X3RYL3")
  varlabelCriteria = Request("X3LL3")
  varIncludeUsedCriteria = Request("X3IUL3")
  varGenreCriteria = Request("X3GL3")
  varYearCriteria = Request("X3YL3")
  varPriceCriteria = Request("X3PRL3")
  varReggaeOrNonReggae = Request("X3RONL3")
  If Request("X3KSL3") <> "" Then varKeepSearchCriteria = Request("X3KSL3")
  varErnieMessageID = Request("X3EMIDL3")
  varCustBoughtFormat = Request("X3CBFL3")
  varCustBoughtDays = Request("X3CBDL3")
 Else
  varSortOrder = "FBS"
  varSortOrderStatistic = request("X3SO")
  varStartRecord = IsDBSomething(request("X3SR"), 1)
  varPageOn = 1
  varPageQuery = "n"
  varLabelExact = request("X3LE")
  varGenreExact = request("X3GE")
  varArtistExact = Request("X3AE")
  varArtistSearchType = Request("X3AST")
  varArtistSearchTypeCounter = Request("X3ASTC")
  varRhythmExact = Request("X3RE")
  varArtistSelected = request("X3ASE")
  varLabelSelected = request("X3LSE")
  varGenreSelected = request("X3GSE")
  varAllID = request("X3AID")
  varQueryType = Request("X3QT")
  If Request.QueryString("labelID") <> "" Then
   varAllID = Request.QueryString("labelID")
   varQueryType = "AllLabel"
  End If
  If Request.QueryString("yearID") <> "" Then
   varAllID = Request.QueryString("yearID")
   varQueryType = "AllYear"
  End If
  If Request.QueryString("genre") <> "" Then
   varAllGenre = Trim((Request.QueryString("genre")))
   varQueryType = "AllGenre"
  End If
  varAllArtistName = Replace(Request("X3AAN"), "'", "''")
  If Request.QueryString("artist") <> "" Then
   varAllArtistName = fixtext(Request.QueryString("artist"))
  End If
  If Request.QueryString("artist") <> "" Then
   varQueryType = "AllArtist"
  End If
  If Request("EMID") <> "" And Not IsNumeric(Request("EMID")) = 1 Then
   varQueryType = "EMID"
   varErnieMessageID = CLng(Request("EMID"))
  End If
  If Request.QueryString("ItemID") <> "" And Not IsNumeric(Request.QueryString("ItemID")) = 1 Then
   varQueryType = "SI"
  End If
  varCustBoughtFormat = request("X3CBF")
  varCustBoughtDays = request("X3CBD")
  If request("YSFSearch") = "y" Then
   varArtistCriteria = request("YSFArtist")
   varFormatCriteria = request("YSFFormat")
   varRecentCriteria = request("YSFRecent")
   varYearCriteria = request("YSFYear")
   varPriceCriteria = request("YSFPrice")
   varGenreCriteria = request("YSFGenre")
   varLabelCriteria = request("YSFLabel")
   varIncludeUsedCriteria = request("YSFIncludeUsed")
  Else
   varArtistCriteria = request("X3A")
   varFormatCriteria = request("X3F")
   varRecentCriteria = request("X3R")
   varYearCriteria = request("X3Y")
   varPriceCriteria = request("X3PR")
   varGenreCriteria = request("X3G")
   varLabelCriteria = request("X3L")
   varIncludeUsedCriteria = request("X3IU")
  End If
  varRhythmCriteria = Request("X3RY")
  varReggaeOrNonReggae = request("X3RON")
  If request("X3KS") <> "" Then varKeepSearchCriteria = request("X3KS")
 End If

 If Not isnumeric(varPageOn) Then
  varPageOn = 1
 End If

 varArtistCriteria =replace(varArtistCriteria,"""","")
 'Millions of Records Search
 if varArtistCriteria="6314millionsofrecords" then
  varQueryType="millions"
 end if
 'Broadcast List Search
 if Request.QueryString("broadcast-list")<>"" then
  if isnumeric(Request.QueryString("broadcast-list")) then
   varQueryType="BroadcastList"
  end if
 end If
 'ID and UPC and SupplierID search
 Dim varPossibleItemID As String = ""
 Dim varItemIDToSearch As Integer = 0
 Dim varSupplierIDToSearch As Integer = 0
 Dim varUPCToSearch As String = ""
 If instr(1,ucase(varArtistCriteria),"ITEM")>0 then
  varPossibleItemID=varArtistCriteria
  varPossibleItemID=replace(varPossibleItemID,"item","")
  varPossibleItemID=replace(varPossibleItemID,"#","")
  varPossibleItemID=replace(varPossibleItemID,"""","")
  varPossibleItemID=trim(varPossibleItemID)
  if isnumeric(varPossibleItemID) then
   varQueryType="ID"
   varItemIDToSearch=cdbl(varPossibleItemID)
  end if
 end if
 if len(varArtistCriteria)>1 and len(varArtistCriteria)<=7 then
  if ucase(left(varArtistCriteria,1))="I" then
   if isnumeric(right(varArtistCriteria,len(varArtistCriteria)-1)) then
    varQueryType="ID"
    varItemIDToSearch=cdbl(right(varArtistCriteria,len(varArtistCriteria)-1))
   end if
  end if
 end if
 if ucase(left(varArtistCriteria,1))="U" and len(varArtistCriteria)>=5 then
  if isnumeric(right(varArtistCriteria,len(varArtistCriteria)-1)) then
   varQueryType="UPC"
   varUPCToSearch=right(varArtistCriteria,len(varArtistCriteria)-1)
  end if
 end If
 If len(varArtistCriteria) > 1 Then
  If isnumeric(varArtistCriteria) And len(varArtistCriteria) <= 20 Then
   If len(varArtistCriteria) >= 7 Then
    varQueryType = "UPC"
    varUPCToSearch = varArtistCriteria
   Else
    varQueryType = "ID"
    varItemIDToSearch = CDbl(varArtistCriteria)
   End If
  End If
 End If
 If Len(varArtistCriteria) >= 4 And Len(varArtistCriteria) <= 10 Then
  If UCase(Left(varArtistCriteria, 3)) = "SID" Then
   If IsNumeric(Right(varArtistCriteria, Len(varArtistCriteria) - 3)) Then
    varQueryType = "SupplierID"
    varSupplierIDToSearch = CDbl(Right(varArtistCriteria, Len(varArtistCriteria) - 3))
   End If
  End If
 End If

 'PlaySound
 If UCase(varArtistCriteria) = "PLAYSOUND" Then
  varQueryType = "PlaySound"
 End If
 'Default Home Page?
 Dim varDefaultHomePage As Integer = 0
 If varQueryType="DefaultPage" or (varQueryType="" and varCartPage=0 and varQueryType<>"SI") then
  varDefaultHomePage=1
 end If
 'Display Type
 Dim varDisplayType As String = ""
 If Request.Cookies("DisplayOptions") Is Nothing Then
  varDisplayType = "Grid"
 ElseIf Request.Cookies("DisplayOptions").value.ToString = "" Then
  If Session("SuperPowerUserName") = "" Then
   varDisplayType = "Grid"
  Else
   varDisplayType = "Thumbnails"
  End If
 ElseIf Request.Cookies("DisplayOptions").value.ToString = "List" Then
  varDisplayType = "List"
 ElseIf Request.Cookies("DisplayOptions").value.ToString = "Thumbnails" Then
  varDisplayType = "Thumbnails"
 ElseIf Request.Cookies("DisplayOptions").value.ToString = "Grid" Then
  varDisplayType = "Grid"
 Else
  varDisplayType = "Grid"
 End if
 if varCartPage=1 then
  varDisplayType="Thumbnails"
 end If

 'Shipping Info
 If varCartPage = 1 And Request.QueryString("enoz7") <> "" And Request.QueryString("SM") <> "" And Request.QueryString("FSC") = "y" Then
  session("ShippingCartZone") = Request.QueryString("enoz7")
  session("ShippingCartShippingMethod") = Request.QueryString("SM")
  session("ShippingCartShippingMethodChosen") = Request.QueryString("SM")
  Session("ShippingCartStateProvince") = Request.QueryString("SP")
  Session("PostalCodeHelpShipping") = Request.QueryString("SPC")
 End If%>

<html xmlns="https://www.w3.org/1999/xhtml">

<head>


    <%'Pre-Load Images%>
    <script language="javascript" type="text/javascript">

        if (document.imes) {
            img1 = new image()
            img1.src ="<%=AssetsPath()%>/calc-shipping2.gif"
    img2 = new image()
    img2.src ="<%=AssetsPath()%>/calc-shipping2l.gif"
    img3 = new image()
    img3.src ="<%=AssetsPath()%>/checkout10.gif"
    img4 = new image()
    img4.src ="<%=AssetsPath()%>/checkout10l.gif"
    img5 = new image()
    img5.src ="<%=AssetsPath()%>/updatecart6.gif"
    img6 = new image()
    img6.src ="<%=AssetsPath()%>/updatecart6l.gif"
    img7 = new image()
    img7.src ="<%=AssetsPath()%>/backordersinstock9.gif"
    img8 = new image()
    img8.src ="<%=AssetsPath()%>/backordersinstock9l.gif"
        }
    </script>
    <%If Session("PoweruserName") <> "" Then%>
    <script language="javascript" type="text/javascript">
        function emptyTheCart() {
            var r = confirm("THIS ACTION WILL DELETE ALL ITEMS IN THE SHOPPING CART.  ARE YOU SURE YOU WANT TO DO THIS?")
            if (r == true) {
                window.location = "/Home.aspx?TabH=Cart&emptythecart=1"
            } else {
                return
            }

        }
    </script>
    <%end if%>

    <%'Page Title%>
    <title>Millions Of Records</title>
    <meta name="google-site-verification" content="scGFqh6yf74_NBziUQjYhonCet9kFfarkKuIBJvS5hA" />
    <meta name="description" lang="en-us" content="Music distributor for CD and vinyl records.  Over 1,000,000 music items in stock.  We ship to all countries including the United States, France, Germany, Japan, Brazil, England, Sweden, Canada, Switzerland and many more.">
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
    <link rel="shortcut icon" href="favicon.ico?" />
    <link rel="icon" href="/favicon.ico?" type="image/x-icon" />
    <link rel="stylesheet" type="text/css" href="/CSS24/HomeMain_11.css?x=205" />
    <input id="AssetsPath" value="<%=AssetsPath()%>" style="display: none" />
    <input id="MP3sPath" value="<%=MP3sPath()%>" style="display: none" />
    <script type="text/javascript" src="/JS38/HomeMain_11.js?x=43"></script>
    <script type="text/javascript" src="/JS38/HomeSuggest_4.js?x=335"></script>
    <%

 'Label for Best Selling Labels
 Dim varBSLTxt As String = Request("BSLTxt")

 'Song Search
 Dim varSongSearchFormat As String = fixtext(Request("SSFtxt"))
 Dim varSongSearchSong As String = fixtext(Request("SSStxt"))
 'Check for Clng
 If (varQueryType = "AllLabel" Or varQueryType = "AllRhythm" Or varQueryType = "SimilarItems") And Not IsNumeric(varAllID) Then
  varQueryType = "DefaultPage"
 End If
 If Request.QueryString("labelID")<>"" and not isnumeric(Request.QueryString("labelID")) then
  varQueryType="DefaultPage"
 end if
 if Request.QueryString("yearID")<>"" and not isnumeric(Request.QueryString("yearID")) then
  varQueryType="DefaultPage"
 end If

 'Sort Order for NON-criteria input searches
 Dim varAllowSortOrders As Integer = 0
 Dim varUsedSearch As Integer = 0
 Dim varDateOnlySort As Integer = 0
 Dim varSortOrderString As String = ""
 If (varQueryType = "New-Release-LPs" Or varQueryType = "New-Release-CDs" Or varQueryType = "New-Release-12s-10s" Or varQueryType = "New-Release-7s" Or varQueryType = "genre-new-arrival-lps" Or varQueryType = "genre-new-arrival-cds" Or varQueryType = "genre-new-arrival-12s-10s" Or varQueryType = "genre-new-arrival-7s" Or varQueryType = "New-Release-Supplies" Or varQueryType = "New-Release-Cassettes" Or varQueryType = "New-Release-CSs" Or varQueryType = "Used-Collectible-7s") And Request("X3QT") <> "PageSearch" And Request("X3QT") <> "NewSort" Then
  varSortOrder = "RAD"
 End If
 If (varQueryType = "Back-In-Stock-LPs" Or varQueryType = "Back-In-Stock-CDs" Or varQueryType = "Back-In-Stock-CSs" Or varQueryType = "Back-In-Stock-7s" Or varQueryType = "Back-In-Stock-12s-10s") And Request("X3QT") <> "PageSearch" And Request("X3QT") <> "NewSort" Then
  varSortOrder = "RABIS"
 End If
 If (varQueryType = "Used-Reggae-7s" Or varQueryType = "genre-used-7s") And Request("X3QT") <> "PageSearch" And Request("X3QT") <> "NewSort" Then
  varSortOrder = "FBS"
 End If
 If (varQueryType = "Best-Selling-LPs" Or varQueryType = "Best-Selling-CDs" Or varQueryType = "Best-Selling-Supplies" Or varQueryType = "Best-Selling-CSs" Or varQueryType = "Best-Selling-7s" Or varQueryType = "Best-Selling-12s-10s" Or varQueryType = "Best-Selling-CSs" Or varQueryType = "genre-best-selling-lps" Or varQueryType = "genre-best-selling-cds" Or varQueryType = "genre-best-selling-12s-10s" Or varQueryType = "genre-best-selling-7s") And Request("X3QT") <> "PageSearch" And Request("X3QT") <> "NewSort" Then
  varSortOrder = "FBS"
 End If
 varUsedSearch = 0
 varDateOnlySort = 0
 If varSortOrder="" then
  if (varQueryType="QQRA" or varRecentCriteria<>"") and varQueryType<>"QQRA" and varQueryType<>"QQBS" and varQueryType<>"QQEP" and varQueryType<>"QQBSL" and varQueryType<>"QQBLOWLP" and varQueryType<>"QQ144981" and varQueryType<>"QQBLOWCD" and varQueryType<>"QQRB" and varQueryType<>"QQ45" and varQueryType<>"QQUV" and varQueryType<>"QQUCD" and varQueryType<>"QQSS" Then
   varSortOrderString = " order by [UsedItem], case when InStockDate>BackInStockDate then InStockDate else BackInStockDate end desc,ID desc,[formatorder],[ArtistTitle]"
   varDateOnlySort =1
  else
   varSortOrderString=" order by [formatorder], [UsedItem], [ArtistTitle]"
  end if
 elseif varSortOrder="FA" or varSortOrder="" then
  varSortOrderString=" order by [formatorder], [UsedItem], [ArtistTitle]"
 elseif varSortOrder="FL" or varSortOrder="" Then
  varSortOrderString = " order by [formatorder], [UsedItem], [Label], [ArtistTitle]"
 ElseIf varSortOrder="FBS" Then
  varSortOrderString = " order by [formatorder], [UsedItem], [salesLast30days] desc, Inventory desc, id desc"
 ElseIf varSortOrder="FPH" then
  if session("PriceGroup")="" or session("PriceGroup")="RetailPrice" then
   varSortOrderString=" order by [formatorder], [UsedItem], case when Sale_RetailPrice is not null and dateadd(dd,0,datediff(dd,0,Sale_RetailEndDate))>=dateadd(dd,0,datediff(dd,0,getdate())) then Sale_RetailPrice else RetailPrice end desc, [ArtistTitle]"
  elseif session("PriceGroup")="StorePrice" then
   varSortOrderString=" order by [formatorder], [UsedItem], case when Sale_WholesalePrice is not null and dateadd(dd,0,datediff(dd,0,Sale_WholesaleEndDate))>=dateadd(dd,0,datediff(dd,0,getdate())) then Sale_WholesalePrice else StorePrice end desc, [ArtistTitle]"
  elseif session("PriceGroup")="ExportPrice" then
   varSortOrderString=" order by [formatorder], [UsedItem], case when Sale_WholesalePrice is not null and dateadd(dd,0,datediff(dd,0,Sale_WholesaleEndDate))>=dateadd(dd,0,datediff(dd,0,getdate())) then Sale_WholesalePrice else ExportPrice end desc, [ArtistTitle]"
  end if
 elseif varSortOrder="FPL" then
  if session("PriceGroup")="" or session("PriceGroup")="RetailPrice" then
   varSortOrderString=" order by [formatorder], [UsedItem], case when Sale_RetailPrice is not null and dateadd(dd,0,datediff(dd,0,Sale_RetailEndDate))>=dateadd(dd,0,datediff(dd,0,getdate())) then Sale_RetailPrice else RetailPrice end, [ArtistTitle]"
  elseif session("PriceGroup")="StorePrice" then
   varSortOrderString=" order by [formatorder], [UsedItem], case when Sale_WholesalePrice is not null and dateadd(dd,0,datediff(dd,0,Sale_WholesaleEndDate))>=dateadd(dd,0,datediff(dd,0,getdate())) then Sale_WholesalePrice else StorePrice end, [ArtistTitle]"
  elseif session("PriceGroup")="ExportPrice" then
   varSortOrderString=" order by [formatorder], [UsedItem], case when Sale_WholesalePrice is not null and dateadd(dd,0,datediff(dd,0,Sale_WholesaleEndDate))>=dateadd(dd,0,datediff(dd,0,getdate())) then Sale_WholesalePrice else ExportPrice end, [ArtistTitle]"
  end if
 elseif varSortOrder="RAD" then
  if varUsedSearch=1 then
   varSortOrderString=" order by [UsedItem], [DateAdded] desc, ID desc"
  Else
   varSortOrderString = " order by [UsedItem], case when InStockDate>BackInStockDate then InStockDate else BackInStockDate end desc, ID desc"
  End if
 ElseIf varSortOrder = "RABIS" Then
  varSortOrderString = " order by [UsedItem], BackInStockDate desc, ID desc"
 ElseIf varSortOrder = "RADA" Then
  varSortOrderString = " order by [UsedItem], DateAdded desc, ID desc"
 End If
 'SearchID
 Dim varXrandom1 As Integer = 0
 For nrand1 = 1 To Date.Now.Second + 1
  Randomize()
  varXrandom1 = Rnd(2000)
 Next
 Dim varLengthRandomNumbersSearchID As Double = (10 ^ 8) - 1
 Dim varSearchID As String = Session.SessionID & Session("CartRandomNumbersExtension") & "S" & Int(Rnd() * varLengthRandomNumbersSearchID)
 If len(varSearchID)>50 then varSearchID=left(varSearchID,50)

 'Cookie Values
 If Request.Cookies("RecordsLimit") Is Nothing Then
  Response.Cookies("RecordsLimit").Value = "200"
  Response.Cookies("RecordsLimit").Path = "/"
 ElseIf Request.Cookies("RecordsLimit").ToString = "" Then
  Response.Cookies("RecordsLimit").Value = "200"
  Response.Cookies("RecordsLimit").Path = "/"
 End If
 'Deleted and Inventory > 0
 Dim varStreetDateText As String = ""
 Dim varIText As String = ">0"
 Dim varSDText As String = ""
 Dim varShowText As String = "='y'"
 If Session("StoreName") <> "" Then
  varStreetDateText = " and StreetDate is not null"
 Else
  varStreetDateText = " and StreetDate <=GetDate()"
 End If
 If Request.QueryString("ShowOrHideZeroInStock") = "y" And Session("PowerUserName") <> "" Then
  Session("ShowOrHideZeroInStock") = "y"
  varIText = ">=0"
 ElseIf Request.QueryString("ShowOrHideZeroInStock") = "n" And Session("PowerUserName") <> "" Then
  Session("ShowOrHideZeroInStock") = "n"
  varIText = ">0"
 End If
 If Session("ShowOrHideZeroInStock") = "y" And Session("PowerUserName") <> "" Then
  Session("ShowOrHideZeroInStock") = "y"
  varIText = ">=0"
 Else
  Session("ShowOrHideZeroInStock") = "n"
  varIText = ">0"
 End If
 varSDText = "='n'"
 'Keep Search Criteria
 Dim varClearSearchCriteriaAfterEachSearch As String = ""
 varKeepSearchCriteria = "y"
 'Reggae Or NonReggae
 Dim varReggaeOrNonReggaeSQL As String = ""
 Dim varReggaeOnlyChecked As String = ""
 Dim varNonReggaeChecked As String = ""
 Dim varAllMusicChecked As String = ""
 If varReggaeOrNonReggae="r" then
  varReggaeOrNonReggaeSQL=" and (Genre1 like 'Reggae'" _
   & " or Genre2 like 'Reggae'" _
   & " or Genre3 like 'Reggae'" _
   & " or Genre4 like 'Reggae'" _
   & " or Genre5 like 'Reggae'" _
   & " or Genre6 like 'Reggae'" _
   & " or Genre7 like 'Reggae'" _
   & " or Genre8 like 'Reggae'" _
   & " or Genre9 like 'Reggae')"
  varReggaeOnlyChecked="checked"
  varNonReggaeChecked=""
  varAllMusicChecked=""
 elseif varReggaeOrNonReggae="n" then
  varReggaeOrNonReggaeSQL=" and (Genre1 <> 'Reggae' or Genre1 is null)" _
   & " and (Genre2 <> 'Reggae' or Genre2 is null)" _
   & " and (Genre3 <> 'Reggae' or Genre3 is null)" _
   & " and (Genre4 <> 'Reggae' or Genre4 is null)" _
   & " and (Genre5 <> 'Reggae' or Genre5 is null)" _
   & " and (Genre6 <> 'Reggae' or Genre6 is null)" _
   & " and (Genre7 <> 'Reggae' or Genre7 is null)" _
   & " and (Genre8 <> 'Reggae' or Genre8 is null)" _
   & " and (Genre9 <> 'Reggae' or Genre9 is null)"
  varReggaeOnlyChecked=""
  varNonReggaeChecked="checked"
  varAllMusicChecked=""
 else
  varReggaeOrNonReggaeSQL=""
  varReggaeOnlyChecked=""
  varNonReggaeChecked=""
  varAllMusicChecked="checked"
 end If
 session("ReggaeOrNonReggae")=IsDBSomething(varReggaeOrNonReggae,"")

 dim arrayIDs(200)
 Dim arrayFormats(10)
 arrayFormats(1) = ""
 arrayFormats(2) = "Vinyl"
 arrayFormats(3) = "CD"
 arrayFormats(4) = "LP"
 arrayFormats(5) = "7"""
 arrayFormats(6) = "12"""
 arrayFormats(7) = "10"""


 Dim arrayRecent(15)
 arrayRecent(1)=""
 arrayRecent(2)="1 Day Back"
 arrayRecent(3)="2 Days Back"
 arrayRecent(4)="3 Days Back"
 arrayRecent(5)="4 Days Back"
 arrayRecent(6)="5 Days Back"
 arrayRecent(7)="6 Days Back"
 arrayRecent(8)="7 Days Back"
 arrayRecent(9)="14 Days Back"
 arrayRecent(10)="21 Days Back"
 arrayRecent(11)="30 Days Back"
 arrayRecent(12)="60 Days Back"
 arrayRecent(13)="90 Days Back"
 arrayRecent(14)="180 Days Back"
 arrayRecent(15)="360 Days Back"

 dim arrayYear(13)
 arrayYear(1)=""
 arrayYear(2)="2010's"
 arrayYear(3)="2000's"
 arrayYear(4)="1990's"
 arrayYear(5)="1980's"
 arrayYear(6)="1970's"
 arrayYear(7)="1960's"
 arrayYear(8)="1950's"
 arrayYear(9)="1940's"
 arrayYear(10)="1930's"
 arrayYear(11)="1920's"
 arrayYear(12)="1910's"
 arrayYear(13)="1900's"

 dim MonthNames(12)
 MonthNames(1)="Jan"
 MonthNames(2)="Feb"
 MonthNames(3)="Mar"
 MonthNames(4)="Apr"
 MonthNames(5)="May"
 MonthNames(6)="Jun"
 MonthNames(7)="Jul"
 MonthNames(8)="Aug"
 MonthNames(9)="Sep"
 MonthNames(10)="Oct"
 MonthNames(11)="Nov"
 MonthNames(12)="Dec"

 dim arrayPrice(17)
 arrayPrice(1)=""
 arrayPrice(2) = "Under $2"
 arrayPrice(3) = "Under $3"
 arrayPrice(4) = "Under $5"
 arrayPrice(5) = "Under $8"
 arrayPrice(6) = "Under $10"
 arrayPrice(7) = "Under $12"
 arrayPrice(8) = "Under $14"
 arrayPrice(9) = "Under $16"
 arrayPrice(10) = "Under $18"
 arrayPrice(11) = "Under $20"
 arrayPrice(12) = "Under $25"
 arrayPrice(13) = "Under $30"
 arrayPrice(15) = "Over $20"
 arrayPrice(16)="Over $50"
 arrayPrice(17)="Over $100"

 dim arrayIncludeUsed(4)
 arrayIncludeUsed(1)=""
 arrayIncludeUsed(2)="New & Used"
 arrayIncludeUsed(3)="New Items Only"
 arrayIncludeUsed(4)="Used Items Only"

 Dim varKeepSearchArtist As String = ""
 Dim varKeepSearchGenre As String = ""
 Dim varKeepSearchLabel As String = ""
 If varKeepSearchCriteria="y" and varQueryType<>"ID" and varQueryType<>"UPC" then
  varKeepSearchArtist=varArtistCriteria
  varKeepSearchGenre=varGenreCriteria
  varKeepSearchLabel=varLabelCriteria
 end If

 varKeepSearchArtist =""
 varKeepSearchGenre=""
 varKeepSearchLabel = ""

 Dim varYouSearchedForArtist As String = ""
 Dim varYouSearchedForFormat As String = ""
 Dim varYouSearchedForRecent As String = ""
 Dim varYouSearchedForYear As String = ""
 Dim varYouSearchedForPrice As String = ""
 Dim varYouSearchedForGenre As String = ""
 Dim varYouSearchedForLabel As String = ""
 Dim varYouSearchedForIncludeUsed As String = ""

 If varKeepSearchCriteria="y" and varQueryType<>"ID" and varQueryType<>"UPC" then
  varKeepSearchArtist=varArtistCriteria
  varKeepSearchGenre=varGenreCriteria
  varKeepSearchLabel=varLabelCriteria
 end If
 If varQueryType = "AllArtist" Or Request.QueryString("artist") <> "" Or Request.QueryString("year") <> "" Then
  varKeepSearchArtist = ""
  varArtistCriteria = ""
  varFormatCriteria = ""
  varRecentCriteria = ""
  varYearCriteria = ""
  varPriceCriteria = ""
  varGenreCriteria = ""
  varLabelCriteria = ""
  varIncludeUsedCriteria = ""
  varKeepSearchGenre = ""
  varKeepSearchLabel = ""
 ElseIf varQueryType = "AllLabel" Or varQueryType = "SimilarItems" Then
  varKeepSearchLabel = ""
  varKeepSearchArtist = ""
  varArtistCriteria = ""
  varFormatCriteria = ""
  varRecentCriteria = ""
  varYearCriteria = ""
  varPriceCriteria = ""
  varGenreCriteria = ""
  varLabelCriteria = ""
  varIncludeUsedCriteria = ""
  varKeepSearchGenre = ""
 End If

 If varQueryType = "DefaultPage" Or (varQueryType = "" And varCartPage = 0 And varQueryType <> "SI") Or (varArtistSearchType <> "" And UCase(varArtistSearchType) <> "ARTIST") Then
  varKeepSearchLabel = ""
  varKeepSearchArtist = ""
  varFormatCriteria = ""
  varRecentCriteria = ""
  varYearCriteria = ""
  varPriceCriteria = ""
  varKeepSearchGenre = ""
  varKeepSearchCriteria = "n"
  varYouSearchedForArtist = ""
  varYouSearchedForFormat = ""
  varYouSearchedForRecent = ""
  varYouSearchedForYear = ""
  varYouSearchedForPrice = ""
  varYouSearchedForGenre = ""
  varYouSearchedForLabel = ""
  varYouSearchedForIncludeUsed = ""
 End If

 'Include Used Items
 Dim varNewOrUsedText As String = ""
 Dim varNewOrUsedStatistic As String = ""
 If varIncludeUsedCriteria = "New Items Only" Then
  varNewOrUsedText = " and (UsedItem is null or UsedItem='n')"
  varNewOrUsedStatistic = "new only"
 ElseIf varIncludeUsedCriteria = "Used Items Only" Then
  varNewOrUsedText = " and UsedItem ='y'"
  varNewOrUsedStatistic = "used only"
  varUsedSearch = 1
 Else
  varNewOrUsedText = ""
 End If%>
</head>

<% ' Body %>
<body topmargin="8" leftmargin="0" rightmargin="0" bgcolor="000000" style="text-align: center">

    <% ' Top Of Page %>
    <table bgcolor="000000" bordercolorlight="879B87" bordercolordark="D4DBD4" cellpadding="0" cellspacing="0" width="1250" align="center" border="0">
        <tr valign="bottom">
            <a name="top" id="top"></a>
            <td width="216" height="32" align="center" valign="bottom">
                <div id="psi1Div" style="position: fixed; visibility: hidden; display: none; left: 50%; margin-left: -383px; width: 766px; height: 475px; top: 170px; z-index: 20000; text-align: left; vertical-align: top; background-image: url('<%=AssetsPath()%>/psi-bg3.gif'); background-repeat: no-repeat">
                    <div id="psi2Div" style="position: absolute; visibility: hidden; display: none; width: 646px; height: 355px; margin-left: 60px; margin-top: 60px">
                        <img alt="" title="Close this message." style="margin-top: -41px; margin-left: 653px; cursor: pointer" onclick="hidepsiDiv()" onmouseover="fov(this,'close-psi')" onmouseout="fou(this,'close-psi')" src="<%=AssetsPath()%>/close-psi.gif" />
                        <p class="log-in">
                            Hello,
                            <br />
                            <br />
                            Please sign in to your account.  If you don't sign in now then this cart will be emptied if you leave our website.
                            <br />
                            <br />
                            After signing in, you can continue shopping and your cart will be automatically saved to your account. 
                            <br />
                            <br />
                            Please sign in or create an account.  Your cart will be saved forever, and you can continue shopping. 
                        </p>
                        <br />
                        <br />
                        <img alt="" style="cursor: pointer; margin-left: 61px" src="<%=AssetsPath()%>/sign-in-btn.gif" onclick="window.location='/Options.aspx'" onmouseover="fov(this,'sign-in-btn')" onmouseout="fou(this,'sign-in-btn')">
                        <img alt="" style="cursor: pointer; margin-left: 13px" src="<%=AssetsPath()%>/create-account-btn.gif" onclick="window.location='/Options.aspx'" onmouseover="fov(this,'create-account-btn')" onmouseout="fou(this,'create-account-btn')">
                        <img alt="" title="Hide this message and continue shopping." style="margin-left: 45px; cursor: pointer" onclick="hidepsiDiv()" onmouseover="fov(this,'c-s')" onmouseout="fou(this,'c-s')" src="<%=AssetsPath()%>/c-s.gif" />
                        <br />
                        <br />
                        <p class="log-in-s">
                            If you have any questions, please email Ernie at ernie@millionsofrecords.com for a prompt reply. 
                            <br />
                            <br />
                            Thank you.
                        </p>
                    </div>
                </div>

                <div style="position: absolute; width: 216px; margin-left: -4px; margin-top: 5px; cursor: pointer" onclick="window.location='/home.aspx'">
                    <img alt="" title="Click here to return to our Home page" onclick="window.location='/home.aspx'" style="border: 0px; cursor: pointer" onmouseover="fov(this,'millions-of-records-logo2')" onmouseout="fou(this,'millions-of-records-logo2')" src="<%=AssetsPath()%>/millions-of-records-logo2.gif" id="image7" name="image7">
                </div>

                <img alt="" src="<%=AssetsPath()%>/logo-background3.gif"></td>
            <% If Request.QueryString("TabH") = "Cart" Then%>
            <td>
                <img alt border="0" src="<%=AssetsPath()%>/home12.gif" onmouseover="fov(this,'home12')" onmouseout="fou(this,'home12')" style="cursor: pointer" onclick="window.location='/home.aspx'"></td>
            <% Else%>
            <td>
                <img alt border="0" src="<%=AssetsPath()%>/home12h.gif" style="cursor: pointer" onclick="window.location='/home.aspx'"></td>
            <%end if%>
            <td>
                <img alt border="0" src="<%=AssetsPath()%>/youraccount.gif" style="cursor: pointer" onmouseover="fov(this,'youraccount')" onmouseout="fou(this,'youraccount')" onclick="window.location='/CustomerInfo.aspx'"></td>
            <td>
                <img alt border="0" src="<%=AssetsPath()%>/yourorders.gif" style="cursor: pointer" onmouseover="fov(this,'yourorders')" onmouseout="fou(this,'yourorders')" onclick="window.location='/CustomerOrders.aspx'"></td>
            <td>
                <img alt border="0" src="<%=AssetsPath()%>/shipping8.gif" style="cursor: pointer" onmouseover="fov(this,'shipping8')" onmouseout="fou(this,'shipping8')" onclick="window.location='/HelpShipping.aspx'"></td>
            <td>
                <img alt border="0" src="<%=AssetsPath()%>/csr.gif" style="cursor: pointer" onmouseover="fov(this,'csr')" onmouseout="fou(this,'csr')" onclick="window.location='/HelpFrequently.aspx'"></td>
            <td>
                <img alt border="0" src="<%=AssetsPath()%>/wholesale5.gif" style="cursor: pointer" onmouseover="fov(this,'wholesale5')" onmouseout="fou(this,'wholesale5')" onclick="window.location='/Wholesale.aspx'"></td>
            <td>
                <img alt border="0" src="<%=AssetsPath()%>/aboutus5.gif" style="cursor: pointer" onmouseover="fov(this,'aboutus5')" onmouseout="fou(this,'aboutus5')" onclick="window.location='/AboutUs.aspx'"></td>
            <td width="74"></td>
            </td><td width="122" align="right" valign="bottom">
                <img alt border="0" src="<%=AssetsPath()%>/create-account3.gif" onmouseover="fov(this,'create-account3')" onmouseout="fou(this,'create-account3')" style="cursor: pointer; margin-bottom: 3px"
                    onclick="window.location='/Options.aspx'">
            </td>
            <td width="95" align="right" valign="bottom">
                <img alt border="0" src="<%=AssetsPath()%>/cart-upper-right3.gif" onmouseover="fov(this,'cart-upper-right3')" onmouseout="fou(this,'cart-upper-right3')" style="cursor: pointer; margin-bottom: 3px"
                    onclick="window.location='/home.aspx?TabH=Cart'">
            </td>
            <td width="95" align="right" valign="bottom">
                <% If Session("PowerUserName") = "" And Session("CustomerID") <> "" Then%>
                <img alt border="0" src="<%=AssetsPath()%>/sign-out-upper-right3.gif" onmouseover="fov(this,'sign-out-upper-right3')" onmouseout="fou(this,'sign-out-upper-right3')" style="cursor: pointer; margin-bottom: 3px"
                    onclick="window.location='/SignOut.aspx'">
                <% Else%>
                <img alt border="0" src="<%=AssetsPath()%>/sign-in-upper-right3.gif" onmouseover="fov(this,'sign-in-upper-right3')" onmouseout="fou(this,'sign-in-upper-right3')" style="cursor: pointer; margin-bottom: 3px"
                    onclick="window.location='/Options.aspx'">
                <%end if%>
            </td>
            <td width="3"></td>
        </tr>
    </table>

    <table bordercolorlight="9BAF9B" cellpadding="0" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td bgcolor="9BAF9B" width="3%"></td>
            <td bgcolor="9BAF9B" width="97%"></td>
            <td width="3%">
                <img alt src="<%=AssetsPath()%>/tabletopright.gif" width="33" height="7"></td>
            <form onkeydown="FormKeyDown()" onsubmit="return FFV()" action="/home.aspx" method="get" name="FF" id="FF">
        </tr>
    </table>

    <input type="hidden" name="cookieexists" id="cookieexists" value="false">
    <input type="hidden" name="FFID" id="FFID" value="">
    <input type="hidden" name="X3LE" id="X3LE">
    <%'LabelExact%>
    <input type="hidden" name="X3GE" id="X3GE">
    <%'GenreExact%>
    <input type="hidden" name="X3AE" id="X3AE">
    <%'ArtistExact%>
    <input type="hidden" name="X3AST" id="X3AST">
    <%'ArtistSearchType%>
    <input type="hidden" name="X3ASTC" id="X3ASTC">
    <%'ArtistSearchTypeCounter%>
    <input type="hidden" name="X3RE" id="X3RE">
    <%'RhythmExact%>
    <input type="hidden" name="X3ASE" id="X3ASE">
    <%'varArtistSelected%>
    <input type="hidden" name="X3LSE" id="X3LSE">
    <%'varLabelSelected%>
    <input type="hidden" name="X3GSE" id="X3GSE">
    <%'varGenreSelected%>
    <input type="hidden" name="X3AID" id="X3AID">
    <%'AllID%>
    <input type="hidden" name="X3AAN" id="X3AAN">
    <%'AllArtistName%>
    <input type="hidden" name="X3QT" id="X3QT" value="NewSearch">
    <%'QueryType%>
    <input type="hidden" name="X3RON" id="X3RON" value="<%=Session("ReggaeOrNonReggae")%>">
    <%'Reggae or NonReggae%>
    <input type="hidden" name="X3KS" id="X3KS" value="<%=varKeepSearchCriteria%>">
    <%'Keep search criteria for next search%>
    <input type="hidden" name="X3SO" id="X3SO" value="<%=varSortOrder%>">
    <%'Sort Order%>
    <input type="hidden" name="SearchIDTxt" id="SearchIDTxt" value="<%=varSearchID%>">
    <input type="hidden" name="X3RY" id="X3RY" value="">
    <%'Rhythm%>
    <input type="hidden" name="BC" id="BC" value="">
    <%'Button Color%>
    <%if varQueryType="Backorders" then%>
    <input type="hidden" name="BOLast" id="BOLast" value="y">
    <%end if%>

    <table cellpadding="0" cellspacing="0" align="center" bgcolor="9BAF9B" width="1250">
        <tr>
            <td align="center" height="35" valign="top">
                <%'PowerUserName and StoreName at top of screen
 If Session("PowerUserName") <> "" Then%>
                <p class="pow" style="background-color: #9BFFF9; color: #000000" onclick="window.location='/Wholesale.aspx'">&nbsp;&nbsp;<%=Session("PowerUserName")%>&nbsp;&nbsp;</p>
                <% If Session("CustomerServerCounter") <> "" Then%>
                <p class="pow" style="background-color: #FFff00; color: #000000" onclick="window.location='/CustomerInfo.aspx'">&nbsp;&nbsp;<%=Left(Session("StoreName"), 40)%>&nbsp;</p>
                <% End If%>
                <p class="pow" style="background-color: #ffffff; color: #000000; cursor: default">&nbsp;&nbsp;<%=varPriceGroup%>&nbsp;</p>
                <%Else
    If Session("CustomerID") <> "" Then%>
                <div style="cursor: pointer; position: absolute; display: block; width: 180px; height: 29px; margin-left: 1060px; margin-top: -6px; padding-top: 11px; vertical-align: top; text-align: center; background-image: url('<%=AssetsPath()%>/log-in-name-bg2.gif'); background-repeat: no-repeat" title="Click here to see your customer profile (shipping address, etc.)" onclick="window.location='/CustomerInfo.aspx'">
                    <p style="vertical-align: top; text-align: center; font-size: 13px; font-family: arial">
                        <%=FigureSignedInName(Session("StoreName"))%>
                    </p>
                </div>
                <%End If
   End If%>
            </td>
    </table>

    <%'Artist
   If varQueryType <> "NewSearch" Then
    varKeepSearchCriteria = "n"
    varKeepSearchArtist = ""
    varFormatCriteria = ""
    varRecentCriteria = ""
    varYearCriteria = ""
    varPriceCriteria = ""
    varKeepSearchGenre = ""
    varKeepSearchLabel = ""
    varIncludeUsedCriteria = ""
   End If
    %>
    <table cellpadding="0" bgcolor="9BAF9B" cellspacing="0" width="1250" align="center" border="0">
        <td width="125" align="right" valign="top">
            <div style="position: absolute; width: 700px; margin-left: 250px; margin-top: -27px; height: 40px">
                <p style="font-family: arial; font-size: 16px; font-weight: 600; background-color: #ffff00; border-radius: 13px; padding-top: 9px; padding-bottom: 9px; padding-left: 17px; padding-right: 17px">
                    Phone (916) 586-9410 (24 hours, 7 days) or email ernieb12345@gmail.com
                </p>
            </div>
        </td>
        <td height="36" width="924" valign="middle" align="right">
            <div name="s-l" id="s-l" style="position: absolute; width: 38px; margin-left: 18px; margin-top: 5px; z-index: 50">
                <img title="Search" onclick="document.getElementById('X3A').focus()" src="<%=AssetsPath()%>/search-left.gif">
            </div>
            <div name="x-1-artist" id="x-1-artist" style="position: absolute; width: 21px; margin-left: 869px; margin-top: 13px; z-index: 50">
                <img title="Clear criteria" onclick="clearCriteria('X3A')" style="border: 0px; cursor: pointer" src="<%=AssetsPath()%>/x-1b.gif">
            </div>
            <%
   Dim varArtistBGText As String = ""
   If varKeepSearchArtist = "" Then
    varArtistBGText = "-default11"
   Else
    varArtistBGText = "2"
   End If%>
            <input class="w" style="font-size: 16px; border-radius: 24px; padding-left: 62px; padding-bottom: 1px; padding-right: 35px; width: 924px; height: 50px; border: 1px solid #879B87; vertical-align: middle; background-image: url('<%=AssetsPath()%>/artist-bg<%=varArtistBGText%>.gif'); background-repeat: no-repeat" value="<%=varKeepSearchArtist%>" onblur="ArtistOnBlur()" autocomplete="off" onkeyup="ArtistKeyUp(event)" onkeydown="ArtistKeyDown(event)" onclick="GotoArtist()" onchange="VS=1" type="text" id="X3A" name="X3A">
            <%'Search Button%>
        </td>
        <td width="80" valign="middle" align="left">
            <input alt="" title="Search our inventory" type="image" style="margin-left: -19px" border="0" src="<%=AssetsPath()%>/artist-search11.gif" onmouseover="VS=1;fov(this,'artist-search11')" onmouseout="fou(this,'artist-search11')" id="artistSearchBtn" name="artistSearchBtn">
        </td>
        <td width="121" align="left" valign="top">
            <%'PowerUser Customer Bought Searches%>
            <%if session("PowerUserName") <> "" And Session("StoreName") <> "" And varCustomerID <> 0 Then%>
            <div name="cust-bought-div" id="cust-bought-div" style="position: absolute; margin-top: -49px; margin-left: -30px; width: 200px; visibility: visible; z-index: 100">
                <select title="Select a format." class="rad" style="width: 64px; height: 19px; font-size: 10px; margin-left: 4px; background-color: #ffffff" name="X3CBF" id="X3CBF">
                    <%
  strSQL = "select Format,formatorder from inventory" _
       & " group by Format,formatorder" _
       & " order by formatorder"
  Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
   SqlConnection.ClearPool(conn)
   conn.Open()
   Dim CMD_X As New SqlCommand(strSQL, conn)
   CMD_X.CommandType = Data.CommandType.Text
   Dim readerX As SqlDataReader
   readerX = CMD_X.ExecuteReader
   Do While readerX.Read
    Response.Write("<option value=""" & readerX("Format") & """>" & readerX("Format") & "</option>")
   Loop
  End Using%>
                </select><select title="Select how many days back." class="rad" style="width: 73px; height: 19px; font-size: 10px; background-color: #ffffff" name="X3CBD" id="X3CBD"><option value="30">30 days</option>
                </select>
                <br>
                <img title="Best sellers that the customer has NOT bought - web or any other kind of order)." src="<%=AssetsPath()%>/notbought2.gif" style="border: 0px; cursor: pointer; margin-left: 4px; padding-top: 4px" onclick="CustNotBought()"><img title="Best sellers that the customer HAS bought (web or any other kind of order)." src="<%=AssetsPath()%>/bought2.gif" style="border: 0px; cursor: pointer; margin-left: 4px; padding-top: 4px" onclick="CustBought()">
            </div>
            <%end if%>
        </td>
        </tr>
    </table>
    <%'Audio Tag%>
    <audio id="sound-player" />
    </audio>

    <%'Artist Suggest%>
    <table cellpadding="0" bgcolor="9BAF9B" cellspacing="0" width="1250" align="center" border="0">
        <tr valign="bottom">
            <td width="125"></td>
            <td height="4" width="910" valign="top" align="left">
                <div name="Adivmain" id="Adivmain" style="position: absolute; margin-top: -1px; width: 903px; min-height: 740px; visibility: hidden; z-index: 25000; background-color: #ffffff; border-bottom: 10px solid #6995C2; border-left: 10px solid #6995C2; border-right: 10px solid #6995C2; border-top: 1px solid #999A99; border-top-left-radius: 5px; border-top-right-radius: 8px; border-bottom-left-radius: 11px; border-bottom-right-radius: 11px">
                    <div name="div-more" id="div-more" style="visibility: hidden; margin-left: 367px; margin-top: 712px; position: absolute">
                        <img id="moresug" src="<%=AssetsPath()%>/moresug2.gif" style="cursor: pointer" onmousedown="nextPage()" onmouseover="fov(this,'moresug2')" onmouseout="fou(this,'moresug2')" />
                    </div>
                    <div name="div-previous" id="div-previous" style="visibility: hidden; margin-left: 367px; margin-top: 712px; position: absolute">
                        <img id="previoussug" src="<%=AssetsPath()%>/previoussug2.gif" style="cursor: pointer" onmousedown="previousPage()" onmouseover="fov(this,'previoussug2')" onmouseout="fou(this,'previoussug2')" />
                    </div>
                    <div name="div-pre" id="div-pre" style="visibility: hidden; margin-left: 280px; margin-top: 712px; position: absolute">
                        <img id="presug" src="<%=AssetsPath()%>/prevsug4.gif" style="cursor: pointer" onmousedown="previousPage()" onmouseover="fov(this,'prevsug4')" onmouseout="fou(this,'prevsug4')" />
                    </div>
                    <div name="div-next" id="div-next" style="visibility: hidden; margin-left: 454px; margin-top: 712px; position: absolute">
                        <img id="nextsug" src="<%=AssetsPath()%>/nextsug4.gif" style="cursor: pointer" onmousedown="nextPage()" onmouseover="fov(this,'nextsug4')" onmouseout="fou(this,'nextsug4')" />
                    </div>

                    <div name="Ad1" id="Ad1" onmouseover="ArtistMouseOverSuggest(1)" onmouseout="ArtistMouseOutSuggest(1)" onmousedown="ArtistClickSuggest(1)" class="div-ad" style="border-top-right-radius: 5px">
                        <table name="table1" id="table1" cellpadding="0" cellspacing="0" width="100%" align="center" border="0" style="border-collapse: collapse">
                            <tr>
                                <td width="50" class="td-adi">
                                    <img class="ai" id="Ai1" src="<%=AssetsPath()%>/b2.gif" /></td>
            </td>
            <td width="613" class="td-ad">
                <p id="Ap1" class="p-Ap">-</p>
                <p id="Ap1st" class="p-ApaST">-</p>
            </td>
            <td width="140" class="td-ad2" id="td1v">
                <p id="Ap1v" class="sug" onmouseover="Vov('1')" onmouseout="Vou('1')" onmousedown="V('1')">-</p>
            </td>
            <td width="100" class="td-ad2" id="td1c">
                <p id="Ap1c" class="sug" onmouseover="CDov('1')" onmouseout="CDou('1')" onmousedown="CD('1')">-</p>
                <input type="hidden" id="Ast1" value="" />
                <input type="hidden" id="Astc1" value="" />
                <input type="hidden" id="AstR1" value="" />
            </td>
        </tr>
    </table>
    </div>
    <div name="Ad2" id="Ad2" onmouseover="ArtistMouseOverSuggest(2)" onmouseout="ArtistMouseOutSuggest(2)" onmousedown="ArtistClickSuggest(2)" class="div-ad" style="border-top-right-radius: 5px">
        <table name="table2" id="table2" cellpadding="0" cellspacing="0" width="100%" align="center" border="0" style="border-collapse: collapse">
            <tr>
                <td width="50" class="td-adi">
                    <img class="ai" id="Ai2" src="<%=AssetsPath()%>/b2.gif" /></td>
                </td><td width="613" class="td-ad">
                    <p id="Ap2" class="p-Ap">-</p>
                    <p id="Ap2st" class="p-ApaST">-</p>
                </td>
                <td width="140" class="td-ad2" id="td2v">
                    <p id="Ap2v" class="sug" onmouseover="Vov('2')" onmouseout="Vou('2')" onmousedown="V('2')">-</p>
                </td>
                <td width="100" class="td-ad2" id="td2c">
                    <p id="Ap2c" class="sug" onmouseover="CDov('2')" onmouseout="CDou('2')" onmousedown="CD('2')">-</p>
                    <input type="hidden" id="Ast2" value="" />
                    <input type="hidden" id="Astc2" value="" />
                    <input type="hidden" id="AstR2" value="" />
                </td>
            </tr>
        </table>
    </div>
    <div name="Ad3" id="Ad3" onmouseover="ArtistMouseOverSuggest(3)" onmouseout="ArtistMouseOutSuggest(3)" onmousedown="ArtistClickSuggest(3)" class="div-ad" style="border-top-right-radius: 5px">
        <table name="table3" id="table3" cellpadding="0" cellspacing="0" width="100%" align="center" border="0" style="border-collapse: collapse">
            <tr>
                <td width="50" class="td-adi">
                    <img class="ai" id="Ai3" src="<%=AssetsPath()%>/b2.gif" /></td>
                </td><td width="613" class="td-ad">
                    <p id="Ap3" class="p-Ap">-</p>
                    <p id="Ap3st" class="p-ApaST">-</p>
                </td>
                <td width="140" class="td-ad2" id="td3v">
                    <p id="Ap3v" class="sug" onmouseover="Vov('3')" onmouseout="Vou('3')" onmousedown="V('3')">-</p>
                </td>
                <td width="100" class="td-ad2" id="td3c">
                    <p id="Ap3c" class="sug" onmouseover="CDov('3')" onmouseout="CDou('3')" onmousedown="CD('3')">-</p>
                    <input type="hidden" id="Ast3" value="" />
                    <input type="hidden" id="Astc3" value="" />
                    <input type="hidden" id="AstR3" value="" />
                </td>
            </tr>
        </table>
    </div>
    <div name="Ad4" id="Ad4" onmouseover="ArtistMouseOverSuggest(4)" onmouseout="ArtistMouseOutSuggest(4)" onmousedown="ArtistClickSuggest(4)" class="div-ad" style="border-top-right-radius: 5px">
        <table name="table4" id="table4" cellpadding="0" cellspacing="0" width="100%" align="center" border="0" style="border-collapse: collapse">
            <tr>
                <td width="50" class="td-adi">
                    <img class="ai" id="Ai4" src="<%=AssetsPath()%>/b2.gif" /></td>
                </td><td width="613" class="td-ad">
                    <p id="Ap4" class="p-Ap">-</p>
                    <p id="Ap4st" class="p-ApaST">-</p>
                </td>
                <td width="140" class="td-ad2" id="td4v">
                    <p id="Ap4v" class="sug" onmouseover="Vov('4')" onmouseout="Vou('4')" onmousedown="V('4')">-</p>
                </td>
                <td width="100" class="td-ad2" id="td4c">
                    <p id="Ap4c" class="sug" onmouseover="CDov('4')" onmouseout="CDou('4')" onmousedown="CD('4')">-</p>
                    <input type="hidden" id="Ast4" value="" />
                    <input type="hidden" id="Astc4" value="" />
                    <input type="hidden" id="AstR4" value="" />
                </td>
            </tr>
        </table>
    </div>
    <div name="Ad5" id="Ad5" onmouseover="ArtistMouseOverSuggest(5)" onmouseout="ArtistMouseOutSuggest(5)" onmousedown="ArtistClickSuggest(5)" class="div-ad" style="border-top-right-radius: 5px">
        <table name="table5" id="table5" cellpadding="0" cellspacing="0" width="100%" align="center" border="0" style="border-collapse: collapse">
            <tr>
                <td width="50" class="td-adi">
                    <img class="ai" id="Ai5" src="<%=AssetsPath()%>/b2.gif" /></td>
                </td><td width="613" class="td-ad">
                    <p id="Ap5" class="p-Ap">-</p>
                    <p id="Ap5st" class="p-ApaST">-</p>
                </td>
                <td width="140" class="td-ad2" id="td5v">
                    <p id="Ap5v" class="sug" onmouseover="Vov('5')" onmouseout="Vou('5')" onmousedown="V('5')">-</p>
                </td>
                <td width="100" class="td-ad2" id="td5c">
                    <p id="Ap5c" class="sug" onmouseover="CDov('5')" onmouseout="CDou('5')" onmousedown="CD('5')">-</p>
                    <input type="hidden" id="Ast5" value="" />
                    <input type="hidden" id="Astc5" value="" />
                    <input type="hidden" id="AstR5" value="" />
                </td>
            </tr>
        </table>
    </div>
    <div name="Ad6" id="Ad6" onmouseover="ArtistMouseOverSuggest(6)" onmouseout="ArtistMouseOutSuggest(6)" onmousedown="ArtistClickSuggest(6)" class="div-ad" style="border-top-right-radius: 5px">
        <table name="table6" id="table6" cellpadding="0" cellspacing="0" width="100%" align="center" border="0" style="border-collapse: collapse">
            <tr>
                <td width="50" class="td-adi">
                    <img class="ai" id="Ai6" src="<%=AssetsPath()%>/b2.gif" /></td>
                </td><td width="613" class="td-ad">
                    <p id="Ap6" class="p-Ap">-</p>
                    <p id="Ap6st" class="p-ApaST">-</p>
                </td>
                <td width="140" class="td-ad2" id="td6v">
                    <p id="Ap6v" class="sug" onmouseover="Vov('6')" onmouseout="Vou('6')" onmousedown="V('6')">-</p>
                </td>
                <td width="100" class="td-ad2" id="td6c">
                    <p id="Ap6c" class="sug" onmouseover="CDov('6')" onmouseout="CDou('6')" onmousedown="CD('6')">-</p>
                    <input type="hidden" id="Ast6" value="" />
                    <input type="hidden" id="Astc6" value="" />
                    <input type="hidden" id="AstR6" value="" />
                </td>
            </tr>
        </table>
    </div>
    <div name="Ad7" id="Ad7" onmouseover="ArtistMouseOverSuggest(7)" onmouseout="ArtistMouseOutSuggest(7)" onmousedown="ArtistClickSuggest(7)" class="div-ad" style="border-top-right-radius: 5px">
        <table name="table7" id="table7" cellpadding="0" cellspacing="0" width="100%" align="center" border="0" style="border-collapse: collapse">
            <tr>
                <td width="50" class="td-adi">
                    <img class="ai" id="Ai7" src="<%=AssetsPath()%>/b2.gif" /></td>
                </td><td width="613" class="td-ad">
                    <p id="Ap7" class="p-Ap">-</p>
                    <p id="Ap7st" class="p-ApaST">-</p>
                </td>
                <td width="140" class="td-ad2" id="td7v">
                    <p id="Ap7v" class="sug" onmouseover="Vov('7')" onmouseout="Vou('7')" onmousedown="V('7')">-</p>
                </td>
                <td width="100" class="td-ad2" id="td7c">
                    <p id="Ap7c" class="sug" onmouseover="CDov('7')" onmouseout="CDou('7')" onmousedown="CD('7')">-</p>
                    <input type="hidden" id="Ast7" value="" />
                    <input type="hidden" id="Astc7" value="" />
                    <input type="hidden" id="AstR7" value="" />
                </td>
            </tr>
        </table>
    </div>
    <div name="Ad8" id="Ad8" onmouseover="ArtistMouseOverSuggest(8)" onmouseout="ArtistMouseOutSuggest(8)" onmousedown="ArtistClickSuggest(8)" class="div-ad" style="border-top-right-radius: 5px">
        <table name="table8" id="table8" cellpadding="0" cellspacing="0" width="100%" align="center" border="0" style="border-collapse: collapse">
            <tr>
                <td width="50" class="td-adi">
                    <img class="ai" id="Ai8" src="<%=AssetsPath()%>/b2.gif" /></td>
                </td><td width="613" class="td-ad">
                    <p id="Ap8" class="p-Ap">-</p>
                    <p id="Ap8st" class="p-ApaST">-</p>
                </td>
                <td width="140" class="td-ad2" id="td8v">
                    <p id="Ap8v" class="sug" onmouseover="Vov('8')" onmouseout="Vou('8')" onmousedown="V('8')">-</p>
                </td>
                <td width="100" class="td-ad2" id="td8c">
                    <p id="Ap8c" class="sug" onmouseover="CDov('8')" onmouseout="CDou('8')" onmousedown="CD('8')">-</p>
                    <input type="hidden" id="Ast8" value="" />
                    <input type="hidden" id="Astc8" value="" />
                    <input type="hidden" id="AstR8" value="" />
                </td>
            </tr>
        </table>
    </div>
    <div name="Ad9" id="Ad9" onmouseover="ArtistMouseOverSuggest(9)" onmouseout="ArtistMouseOutSuggest(9)" onmousedown="ArtistClickSuggest(9)" class="div-ad" style="border-top-right-radius: 5px">
        <table name="table9" id="table9" cellpadding="0" cellspacing="0" width="100%" align="center" border="0" style="border-collapse: collapse">
            <tr>
                <td width="50" class="td-adi">
                    <img class="ai" id="Ai9" src="<%=AssetsPath()%>/b2.gif" /></td>
                </td><td width="613" class="td-ad">
                    <p id="Ap9" class="p-Ap">-</p>
                    <p id="Ap9st" class="p-ApaST">-</p>
                </td>
                <td width="140" class="td-ad2" id="td9v">
                    <p id="Ap9v" class="sug" onmouseover="Vov('9')" onmouseout="Vou('9')" onmousedown="V('9')">-</p>
                </td>
                <td width="100" class="td-ad2" id="td9c">
                    <p id="Ap9c" class="sug" onmouseover="CDov('9')" onmouseout="CDou('9')" onmousedown="CD('9')">-</p>
                    <input type="hidden" id="Ast9" value="" />
                    <input type="hidden" id="Astc9" value="" />
                    <input type="hidden" id="AstR9" value="" />
                </td>
            </tr>
        </table>
    </div>
    <div name="Ad10" id="Ad10" onmouseover="ArtistMouseOverSuggest(10)" onmouseout="ArtistMouseOutSuggest(10)" onmousedown="ArtistClickSuggest(10)" class="div-ad" style="border-top-right-radius: 5px">
        <table name="table10" id="table10" cellpadding="0" cellspacing="0" width="100%" align="center" border="0" style="border-collapse: collapse">
            <tr>
                <td width="50" class="td-adi">
                    <img class="ai" id="Ai10" src="<%=AssetsPath()%>/b2.gif" /></td>
                </td><td width="613" class="td-ad">
                    <p id="Ap10" class="p-Ap">-</p>
                    <p id="Ap10st" class="p-ApaST">-</p>
                </td>
                <td width="140" class="td-ad2" id="td10v">
                    <p id="Ap10v" class="sug" onmouseover="Vov('10')" onmouseout="Vou('10')" onmousedown="V('10')">-</p>
                </td>
                <td width="100" class="td-ad2" id="td10c">
                    <p id="Ap10c" class="sug" onmouseover="CDov('10')" onmouseout="CDou('10')" onmousedown="CD('10')">-</p>
                    <input type="hidden" id="Ast10" value="" />
                    <input type="hidden" id="Astc10" value="" />
                    <input type="hidden" id="AstR10" value="" />
                </td>
            </tr>
        </table>
    </div>
    <div name="Ad11" id="Ad11" onmouseover="ArtistMouseOverSuggest(11)" onmouseout="ArtistMouseOutSuggest(11)" onmousedown="ArtistClickSuggest(11)" class="div-ad" style="border-top-right-radius: 5px">
        <table name="table11" id="table11" cellpadding="0" cellspacing="0" width="100%" align="center" border="0" style="border-collapse: collapse">
            <tr>
                <td width="50" class="td-adi">
                    <img class="ai" id="Ai11" src="<%=AssetsPath()%>/b2.gif" /></td>
                </td><td width="613" class="td-ad">
                    <p id="Ap11" class="p-Ap">-</p>
                    <p id="Ap11st" class="p-ApaST">-</p>
                </td>
                <td width="140" class="td-ad2" id="td11v">
                    <p id="Ap11v" class="sug" onmouseover="Vov('11')" onmouseout="Vou('11')" onmousedown="V('11')">-</p>
                </td>
                <td width="100" class="td-ad2" id="td11c">
                    <p id="Ap11c" class="sug" onmouseover="CDov('11')" onmouseout="CDou('11')" onmousedown="CD('11')">-</p>
                    <input type="hidden" id="Ast11" value="" />
                    <input type="hidden" id="Astc11" value="" />
                    <input type="hidden" id="AstR11" value="" />
                </td>
            </tr>
        </table>
    </div>
    <div name="Ad12" id="Ad12" onmouseover="ArtistMouseOverSuggest(12)" onmouseout="ArtistMouseOutSuggest(12)" onmousedown="ArtistClickSuggest(12)" class="div-ad" style="border-top-right-radius: 5px">
        <table name="table12" id="table12" cellpadding="0" cellspacing="0" width="100%" align="center" border="0" style="border-collapse: collapse">
            <tr>
                <td width="50" class="td-adi">
                    <img class="ai" id="Ai12" src="<%=AssetsPath()%>/b2.gif" /></td>
                </td><td width="613" class="td-ad">
                    <p id="Ap12" class="p-Ap">-</p>
                    <p id="Ap12st" class="p-ApaST">-</p>
                </td>
                <td width="140" class="td-ad2" id="td12v">
                    <p id="Ap12v" class="sug" onmouseover="Vov('12')" onmouseout="Vou('12')" onmousedown="V('12')">-</p>
                </td>
                <td width="100" class="td-ad2" id="td12c">
                    <p id="Ap12c" class="sug" onmouseover="CDov('12')" onmouseout="CDou('12')" onmousedown="CD('12')">-</p>
                    <input type="hidden" id="Ast12" value="" />
                    <input type="hidden" id="Astc12" value="" />
                    <input type="hidden" id="AstR12" value="" />
                </td>
            </tr>
        </table>
    </div>
    <div name="Ad13" id="Ad13" onmouseover="ArtistMouseOverSuggest(13)" onmouseout="ArtistMouseOutSuggest(13)" onmousedown="ArtistClickSuggest(13)" class="div-ad" style="border-top-right-radius: 5px">
        <table name="table13" id="table13" cellpadding="0" cellspacing="0" width="100%" align="center" border="0" style="border-collapse: collapse">
            <tr>
                <td width="50" class="td-adi">
                    <img class="ai" id="Ai13" src="<%=AssetsPath()%>/b2.gif" /></td>
                </td><td width="613" class="td-ad">
                    <p id="Ap13" class="p-Ap">-</p>
                    <p id="Ap13st" class="p-ApaST">-</p>
                </td>
                <td width="140" class="td-ad2" id="td13v">
                    <p id="Ap13v" class="sug" onmouseover="Vov('13')" onmouseout="Vou('13')" onmousedown="V('13')">-</p>
                </td>
                <td width="100" class="td-ad2" id="td13c">
                    <p id="Ap13c" class="sug" onmouseover="CDov('13')" onmouseout="CDou('13')" onmousedown="CD('13')">-</p>
                    <input type="hidden" id="Ast13" value="" />
                    <input type="hidden" id="Astc13" value="" />
                    <input type="hidden" id="AstR13" value="" />
                </td>
            </tr>
        </table>
    </div>
    <div name="Ad14" id="Ad14" onmouseover="ArtistMouseOverSuggest(14)" onmouseout="ArtistMouseOutSuggest(14)" onmousedown="ArtistClickSuggest(14)" class="div-ad" style="border-top-right-radius: 5px">
        <table name="table14" id="table14" cellpadding="0" cellspacing="0" width="100%" align="center" border="0" style="border-collapse: collapse">
            <tr>
                <td width="50" class="td-adi">
                    <img class="ai" id="Ai14" src="<%=AssetsPath()%>/b2.gif" /></td>
                </td><td width="613" class="td-ad">
                    <p id="Ap14" class="p-Ap">-</p>
                    <p id="Ap14st" class="p-ApaST">-</p>
                </td>
                <td width="140" class="td-ad2" id="td14v">
                    <p id="Ap14v" class="sug" onmouseover="Vov('14')" onmouseout="Vou('14')" onmousedown="V('14')">-</p>
                </td>
                <td width="100" class="td-ad2" id="td14c">
                    <p id="Ap14c" class="sug" onmouseover="CDov('14')" onmouseout="CDou('14')" onmousedown="CD('14')">-</p>
                    <input type="hidden" id="Ast14" value="" />
                    <input type="hidden" id="Astc14" value="" />
                    <input type="hidden" id="AstR14" value="" />
                </td>
            </tr>
        </table>
    </div>
    <div name="Ad15" id="Ad15" onmouseover="ArtistMouseOverSuggest(15)" onmouseout="ArtistMouseOutSuggest(15)" onmousedown="ArtistClickSuggest(15)" class="div-ad" style="border-top-right-radius: 5px">
        <table name="table15" id="table15" cellpadding="0" cellspacing="0" width="100%" align="center" border="0" style="border-collapse: collapse">
            <tr>
                <td width="50" class="td-adi">
                    <img class="ai" id="Ai15" src="<%=AssetsPath()%>/b2.gif" /></td>
                </td><td width="613" class="td-ad">
                    <p id="Ap15" class="p-Ap">-</p>
                    <p id="Ap15st" class="p-ApaST">-</p>
                </td>
                <td width="140" class="td-ad2" id="td15v">
                    <p id="Ap15v" class="sug" onmouseover="Vov('15')" onmouseout="Vou('15')" onmousedown="V('15')">-</p>
                </td>
                <td width="100" class="td-ad2" id="td15c">
                    <p id="Ap15c" class="sug" onmouseover="CDov('15')" onmouseout="CDou('15')" onmousedown="CD('15')">-</p>
                    <input type="hidden" id="Ast15" value="" />
                    <input type="hidden" id="Astc15" value="" />
                    <input type="hidden" id="AstR15" value="" />
                </td>
            </tr>
        </table>
    </div>
    <div name="Ad16" id="Ad16" onmouseover="ArtistMouseOverSuggest(16)" onmouseout="ArtistMouseOutSuggest(16)" onmousedown="ArtistClickSuggest(16)" class="div-ad" style="border-top-right-radius: 5px">
        <table name="table16" id="table16" cellpadding="0" cellspacing="0" width="100%" align="center" border="0" style="border-collapse: collapse">
            <tr>
                <td width="50" class="td-adi">
                    <img class="ai" id="Ai16" src="<%=AssetsPath()%>/b2.gif" /></td>
                </td><td width="613" class="td-ad">
                    <p id="Ap16" class="p-Ap">-</p>
                    <p id="Ap16st" class="p-ApaST">-</p>
                </td>
                <td width="140" class="td-ad2" id="td16v">
                    <p id="Ap16v" class="sug" onmouseover="Vov('16')" onmouseout="Vou('16')" onmousedown="V('16')">-</p>
                </td>
                <td width="100" class="td-ad2" id="td16c">
                    <p id="Ap16c" class="sug" onmouseover="CDov('16')" onmouseout="CDou('16')" onmousedown="CD('16')">-</p>
                    <input type="hidden" id="Ast16" value="" />
                    <input type="hidden" id="Astc16" value="" />
                    <input type="hidden" id="AstR16" value="" />
                </td>
            </tr>
        </table>
    </div>
    <div name="Ad17" id="Ad17" onmouseover="ArtistMouseOverSuggest(17)" onmouseout="ArtistMouseOutSuggest(17)" onmousedown="ArtistClickSuggest(17)" class="div-ad" style="border-top-right-radius: 5px">
        <table name="table17" id="table17" cellpadding="0" cellspacing="0" width="100%" align="center" border="0" style="border-collapse: collapse">
            <tr>
                <td width="50" class="td-adi">
                    <img class="ai" id="Ai17" src="<%=AssetsPath()%>/b2.gif" /></td>
                </td><td width="613" class="td-ad">
                    <p id="Ap17" class="p-Ap">-</p>
                    <p id="Ap17st" class="p-ApaST">-</p>
                </td>
                <td width="140" class="td-ad2" id="td17v">
                    <p id="Ap17v" class="sug" onmouseover="Vov('17')" onmouseout="Vou('17')" onmousedown="V('17')">-</p>
                </td>
                <td width="100" class="td-ad2" id="td17c">
                    <p id="Ap17c" class="sug" onmouseover="CDov('17')" onmouseout="CDou('17')" onmousedown="CD('17')">-</p>
                    <input type="hidden" id="Ast17" value="" />
                    <input type="hidden" id="Astc17" value="" />
                    <input type="hidden" id="AstR17" value="" />
                </td>
            </tr>
        </table>
    </div>
    <div name="Ad18" id="Ad18" onmouseover="ArtistMouseOverSuggest(18)" onmouseout="ArtistMouseOutSuggest(18)" onmousedown="ArtistClickSuggest(18)" class="div-ad" style="border-top-right-radius: 5px">
        <table name="table18" id="table18" cellpadding="0" cellspacing="0" width="100%" align="center" border="0" style="border-collapse: collapse">
            <tr>
                <td width="50" class="td-adi">
                    <img class="ai" id="Ai18" src="<%=AssetsPath()%>/b2.gif" /></td>
                </td><td width="613" class="td-ad">
                    <p id="Ap18" class="p-Ap">-</p>
                    <p id="Ap18st" class="p-ApaST">-</p>
                </td>
                <td width="140" class="td-ad2" id="td18v">
                    <p id="Ap18v" class="sug" onmouseover="Vov('18')" onmouseout="Vou('18')" onmousedown="V('18')">-</p>
                </td>
                <td width="100" class="td-ad2" id="td18c">
                    <p id="Ap18c" class="sug" onmouseover="CDov('18')" onmouseout="CDou('18')" onmousedown="CD('18')">-</p>
                    <input type="hidden" id="Ast18" value="" />
                    <input type="hidden" id="Astc18" value="" />
                    <input type="hidden" id="AstR18" value="" />
                </td>
            </tr>
        </table>
    </div>
    <div name="Ad19" id="Ad19" onmouseover="ArtistMouseOverSuggest(19)" onmouseout="ArtistMouseOutSuggest(19)" onmousedown="ArtistClickSuggest(19)" class="div-ad" style="border-top-right-radius: 5px">
        <table name="table19" id="table19" cellpadding="0" cellspacing="0" width="100%" align="center" border="0" style="border-collapse: collapse">
            <tr>
                <td width="50" class="td-adi">
                    <img class="ai" id="Ai19" src="<%=AssetsPath()%>/b2.gif" /></td>
                </td><td width="613" class="td-ad">
                    <p id="Ap19" class="p-Ap">-</p>
                    <p id="Ap19st" class="p-ApaST">-</p>
                </td>
                <td width="140" class="td-ad2" id="td19v">
                    <p id="Ap19v" class="sug" onmouseover="Vov('19')" onmouseout="Vou('19')" onmousedown="V('19')">-</p>
                </td>
                <td width="100" class="td-ad2" id="td19c">
                    <p id="Ap19c" class="sug" onmouseover="CDov('19')" onmouseout="CDou('19')" onmousedown="CD('19')">-</p>
                    <input type="hidden" id="Ast19" value="" />
                    <input type="hidden" id="Astc19" value="" />
                    <input type="hidden" id="AstR19" value="" />
                </td>
            </tr>
        </table>
    </div>
    <div name="Ad20" id="Ad20" onmouseover="ArtistMouseOverSuggest(20)" onmouseout="ArtistMouseOutSuggest(20)" onmousedown="ArtistClickSuggest(20)" class="div-ad" style="border-top-right-radius: 5px">
        <table name="table20" id="table20" cellpadding="0" cellspacing="0" width="100%" align="center" border="0" style="border-collapse: collapse">
            <tr>
                <td width="50" class="td-adi">
                    <img class="ai" id="Ai20" src="<%=AssetsPath()%>/b2.gif" /></td>
                </td><td width="613" class="td-ad">
                    <p id="Ap20" class="p-Ap">-</p>
                    <p id="Ap20st" class="p-ApaST">-</p>
                </td>
                <td width="140" class="td-ad2" id="td20v">
                    <p id="Ap20v" class="sug" onmouseover="Vov('20')" onmouseout="Vou('20')" onmousedown="V('20')">-</p>
                </td>
                <td width="100" class="td-ad2" id="td20c">
                    <p id="Ap20c" class="sug" onmouseover="CDov('20')" onmouseout="CDou('20')" onmousedown="CD('20')">-</p>
                    <input type="hidden" id="Ast20" value="" />
                    <input type="hidden" id="Astc20" value="" />
                    <input type="hidden" id="AstR20" value="" />
                </td>
            </tr>
        </table>
    </div>

    </div>

</td><td width="215"></td>
    </tr></table>
    <%'Search Labels%>
    <table cellpadding="0" bgcolor="9BAF9B" cellspacing="0" width="1250" align="center" border="0">
        <tr valign="bottom">
            <td width="165"></td>
            <td width="131" align="center">
                <img alt="" src="<%=AssetsPath()%>/fq11.gif">
            </td>
            <td width="157" align="center">
                <img alt="" src="<%=AssetsPath()%>/naq11.gif">
            </td>
            <td width="105" align="center">
                <img alt="" src="<%=AssetsPath()%>/yq11.gif">
            </td>
            <td width="115" align="center">
                <img alt="" src="<%=AssetsPath()%>/pq11.gif">
            </td>
            <td width="159" align="center">
                <img alt="" onclick="GotoGenre()" src="<%=AssetsPath()%>/gq11.gif">
            </td>
            <td width="177" align="center">
                <img alt="" onclick="GotoLabel()" src="<%=AssetsPath()%>/lq11.gif">
            </td>
            <td width="155" align="center"></td>
            <td width="86"></td>
        </tr>
    </table>
    <%'Search Boxes%>
    <table cellpadding="0" bgcolor="9BAF9B" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td width="165"></td>
            <td width="131" height="28" align="left">
                <div name="x-1-format" id="x-1-format" style="position: absolute; width: 15px; margin-left: 94px; margin-top: 7px; z-index: 50">
                    <img title="Clear criteria" onclick="clearCriteria('X3F')" style="border: 0px; cursor: pointer" src="<%=AssetsPath()%>/x-1.gif">
                </div>
                <select class="w" onchange="VS=1;document.getElementById('artistSearchBtn').focus()" onkeydown="EK()" style="border-radius: 5px; padding-left: 3px; padding-top: 4px; width: 131px; height: 28px; border: 1px solid #616161; vertical-align: middle" name="X3F" id="X3F">
                    <%

   Dim strOptionFormat As String = ""
   For n = 1 To 7
    If (varFormatCriteria = arrayFormats(n) Or varFormatCriteria & """" = arrayFormats(n)) And varKeepSearchCriteria = "y" Then
     strOptionFormat = "<option selected>"
    Else
     strOptionFormat = "<option>"
    End If
    Response.Write(strOptionFormat & arrayFormats(n))
   Next%>
                </select>
            </td>
            <td width="157" align="left">
                <div name="x-1-recent" id="x-1-recent" style="position: absolute; width: 15px; margin-left: 120px; margin-top: 7px; z-index: 50">
                    <img title="Clear criteria" onclick="clearCriteria('X3R')" style="border: 0px; cursor: pointer" src="<%=AssetsPath()%>/x-1.gif">
                </div>
                <select class="w" style="border-radius: 5px; padding-left: 3px; padding-top: 4px; margin-left: 0px; width: 157px; height: 28px; border: 1px solid #616161; vertical-align: middle" onchange="VS=1;document.getElementById('artistSearchBtn').focus()" onkeydown="EK()" align="center" name="X3R" id="X3R">
                    <%
   Dim strOptionRecent As String = ""
   For n = 1 To 15
    If varRecentCriteria = arrayRecent(n) And varKeepSearchCriteria = "y" Then
     strOptionRecent = "<option selected>"
    Else
     strOptionRecent = "<option>"
    End If
    Response.Write(strOptionRecent & arrayRecent(n))
   Next%>
                </select>
            </td>
            <td width="105" align="left">
                <div name="x-1-year" id="x-1-year" style="position: absolute; width: 15px; margin-left: 68px; margin-top: 7px; z-index: 50">
                    <img title="Clear criteria" onclick="clearCriteria('X3Y')" style="border: 0px; cursor: pointer" src="<%=AssetsPath()%>/x-1.gif">
                </div>
                <select class="w" style="border-radius: 5px; padding-left: 3px; padding-top: 4px; margin-left: 0px; width: 105px; height: 28px; border: 1px solid #616161; vertical-align: middle" onchange="VS=1;document.getElementById('artistSearchBtn').focus()" onkeydown="EK()" name="X3Y" id="X3Y">
                    <%
 Dim strOptionYear As String = ""
 For n = 1 To 13
  If varYearCriteria = arrayYear(n) And varKeepSearchCriteria = "y" Then
   strOptionYear = "<option selected>"
  Else
   strOptionYear = "<option>"
  End If
  Response.Write(strOptionYear & arrayYear(n))
 Next%>
                </select>
            </td>
            <td width="115" align="left">
                <div name="x-1-price" id="x-1-price" style="position: absolute; width: 15px; margin-left: 78px; margin-top: 7px; z-index: 50">
                    <img title="Clear criteria" onclick="clearCriteria('X3PR')" style="border: 0px; cursor: pointer" src="<%=AssetsPath()%>/x-1.gif">
                </div>
                <select class="w" style="border-radius: 5px; padding-left: 3px; padding-top: 4px; margin-left: 0px; width: 115px; height: 28px; border: 1px solid #616161; vertical-align: middle" onchange="VS=1;document.getElementById('artistSearchBtn').focus()" onkeydown="EK()" name="X3PR" id="X3PR">
                    <%
 Dim strOptionPrice As String = ""
 For n = 1 To 17
  If varPriceCriteria = arrayPrice(n) And varKeepSearchCriteria = "y" Then
   strOptionPrice = "<option selected>"
  Else
   strOptionPrice = "<option>"
  End If
  Response.Write(strOptionPrice & arrayPrice(n))
 Next%>
                </select>
            </td>
            <td width="159" align="left">
                <div name="x-1-genre" id="x-1-genre" style="position: absolute; width: 15px; margin-left: 136px; margin-top: 7px; z-index: 50">
                    <img title="Clear criteria" onclick="clearCriteria('X3G')" style="border: 0px; cursor: pointer" src="<%=AssetsPath()%>/x-1.gif">
                </div>
                <input class="w" style="border-radius: 5px; padding-left: 6px; padding-bottom: 5px; padding-right: 26px; margin-left: 0px; width: 159px; height: 28px; border: 1px solid #616161; vertical-align: middle"
                    value="<%=varKeepSearchGenre%>" style="width: 164; height: 24px" autocomplete="off" onblur="GenreOnBlur()" onkeyup="GenreKeyUp(event)" onkeydown="GenreKeyDown(event)" onclick="GotoGenre()" onchange="VS=1;document.getElementById('artistSearchBtn').focus()" type="text" value="" maxlength="120" name="X3G" id="X3G">
            </td>
            <td width="177" align="left">
                <div name="x-1-label" id="x-1-label" style="position: absolute; width: 15px; margin-left: 154px; margin-top: 7px; z-index: 50">
                    <img title="Clear criteria" onclick="clearCriteria('X3L')" style="border: 0px; cursor: pointer" src="<%=AssetsPath()%>/x-1.gif">
                </div>
                <input class="w" style="border-radius: 5px; padding-left: 6px; padding-bottom: 5px; padding-right: 26px; margin-left: 0px; width: 177px; height: 28px; border: 1px solid #616161; vertical-align: middle" value="<%=varKeepSearchLabel%>" autocomplete="off" onblur="LabelOnBlur()" onkeyup="LabelKeyUp(event)" onkeydown="LabelKeyDown(event)" onchange="VS=1" type="text" value="" maxlength="120" name="X3L" id="X3L">
            </td>
            <td width="155" align="left"></td>
            <td width="86" valign="top">
                <%'Reset All Button%>
                <img alt="" title="Reset all search criteria" style="cursor: pointer; margin-top: -8px; margin-left: -145px" onclick="resetAll()" src="<%=AssetsPath()%>/reset-all7.gif">
            </td>
        </tr>
    </table>
    <table cellpadding="0" bgcolor="9BAF9B" cellspacing="0" width="1250" align="center" border="0">
        <tr valign="bottom">
            <td width="165"></td>
            <td width="131"></td>
            <td width="157"></td>
            <td width="105"></td>
            <td width="115"></td>
            <td height="1" width="159" valign="top" align="left">
                <%'Genre Suggest%>
                <div name="Gdivmain" id="Gdivmain" style="position: absolute; width: 300px; min-height: 217px; visibility: hidden; z-index: 200; background-color: #FFFFC8; border: 1px solid #363636">
                    <div name="Gd1" id="Gd1" onmouseover="GenreMouseOverSuggest(1)" onmouseout="GenreMouseOutSuggest(1)" onmousedown="GenreClickSuggest(1)" style="width: 292px; padding: 3px; visibility: hidden; cursor: default; text-align: left; padding: 3px; z-index: 100; background-color: #FFFFC8; border: 0px">
                        <p name="Gp1" id="Gp1" style="font-weight: 900; color: #2F3042; font-size: 11px">-</p>
                        <p name="Gp1a" id="Gp1a" style="color: #2F3042; font-size: 11px">-</p>
                    </div>
                    <div name="Gd2" id="Gd2" onmouseover="GenreMouseOverSuggest(2)" onmouseout="GenreMouseOutSuggest(2)" onmousedown="GenreClickSuggest(2)" style="width: 292px; padding: 3px; visibility: hidden; cursor: default; text-align: left; padding: 3px; z-index: 100; background-color: #FFFFC8; border: 0px">
                        <p name="Gp2" id="Gp2" style="font-weight: 900; color: #2F3042; font-size: 11px">-</p>
                        <p name="Gp2a" id="Gp2a" style="color: #2F3042; font-size: 11px">-</p>
                    </div>
                    <div name="Gd3" id="Gd3" onmouseover="GenreMouseOverSuggest(3)" onmouseout="GenreMouseOutSuggest(3)" onmousedown="GenreClickSuggest(3)" style="width: 292px; padding: 3px; visibility: hidden; cursor: default; text-align: left; padding: 3px; z-index: 100; background-color: #FFFFC8; border: 0px">
                        <p name="Gp3" id="Gp3" style="font-weight: 900; color: #2F3042; font-size: 11px">-</p>
                        <p name="Gp3a" id="Gp3a" style="color: #2F3042; font-size: 11px">-</p>
                    </div>
                    <div name="Gd4" id="Gd4" onmouseover="GenreMouseOverSuggest(4)" onmouseout="GenreMouseOutSuggest(4)" onmousedown="GenreClickSuggest(4)" style="width: 292px; padding: 3px; visibility: hidden; cursor: default; text-align: left; padding: 3px; z-index: 100; background-color: #FFFFC8; border: 0px">
                        <p name="Gp4" id="Gp4" style="font-weight: 900; color: #2F3042; font-size: 11px">-</p>
                        <p name="Gp4a" id="Gp4a" style="color: #2F3042; font-size: 11px">-</p>
                    </div>
                    <div name="Gd5" id="Gd5" onmouseover="GenreMouseOverSuggest(5)" onmouseout="GenreMouseOutSuggest(5)" onmousedown="GenreClickSuggest(5)" style="width: 292px; padding: 3px; visibility: hidden; cursor: default; text-align: left; padding: 3px; z-index: 100; background-color: #FFFFC8; border: 0px">
                        <p name="Gp5" id="Gp5" style="font-weight: 900; color: #2F3042; font-size: 11px">-</p>
                        <p name="Gp5a" id="Gp5a" style="color: #2F3042; font-size: 11px">-</p>
                    </div>
                    <div name="Gd6" id="Gd6" onmouseover="GenreMouseOverSuggest(6)" onmouseout="GenreMouseOutSuggest(6)" onmousedown="GenreClickSuggest(6)" style="width: 292px; padding: 3px; visibility: hidden; cursor: default; text-align: left; padding: 3px; z-index: 100; background-color: #FFFFC8; border: 0px">
                        <p name="Gp6" id="Gp6" style="font-weight: 900; color: #2F3042; font-size: 11px">-</p>
                        <p name="Gp6a" id="Gp6a" style="color: #2F3042; font-size: 11px">-</p>
                    </div>
                    <div name="Gd7" id="Gd7" onmouseover="GenreMouseOverSuggest(7)" onmouseout="GenreMouseOutSuggest(7)" onmousedown="GenreClickSuggest(7)" style="width: 292px; padding: 3px; visibility: hidden; cursor: default; text-align: left; padding: 3px; z-index: 100; background-color: #FFFFC8; border: 0px">
                        <p name="Gp7" id="Gp7" style="font-weight: 900; color: #2F3042; font-size: 11px">-</p>
                        <p name="Gp7a" id="Gp7a" style="color: #2F3042; font-size: 11px">-</p>
                    </div>
                    <div name="Gd8" id="Gd8" onmouseover="GenreMouseOverSuggest(8)" onmouseout="GenreMouseOutSuggest(8)" onmousedown="GenreClickSuggest(8)" style="width: 292px; padding: 3px; visibility: hidden; cursor: default; text-align: left; padding: 3px; z-index: 100; background-color: #FFFFC8; border: 0px">
                        <p name="Gp8" id="Gp8" style="font-weight: 900; color: #2F3042; font-size: 11px">-</p>
                        <p name="Gp8a" id="Gp8a" style="color: #2F3042; font-size: 11px">-</p>
                    </div>
                    <div name="Gd9" id="Gd9" onmouseover="GenreMouseOverSuggest(9)" onmouseout="GenreMouseOutSuggest(9)" onmousedown="GenreClickSuggest(9)" style="width: 292px; padding: 3px; visibility: hidden; cursor: default; text-align: left; padding: 3px; z-index: 100; background-color: #FFFFC8; border: 0px">
                        <p name="Gp9" id="Gp9" style="font-weight: 900; color: #2F3042; font-size: 11px">-</p>
                        <p name="Gp9a" id="Gp9a" style="color: #2F3042; font-size: 11px">-</p>
                    </div>
                    <div name="Gd10" id="Gd10" onmouseover="GenreMouseOverSuggest(10)" onmouseout="GenreMouseOutSuggest(10)" onmousedown="GenreClickSuggest(10)" style="width: 292px; padding: 3px; visibility: hidden; cursor: default; text-align: left; padding: 3px; z-index: 100; background-color: #FFFFC8; border: 0px">
                        <p name="Gp10" id="Gp10" style="font-weight: 900; color: #2F3042; font-size: 11px">-</p>
                        <p name="Gp10a" id="Gp10a" style="color: #2F3042; font-size: 11px">-</p>
                    </div>
                    <div name="GdP" id="GdP" style="height: 26px; padding: 0px; visibility: hidden; text-align: left; z-index: 100; background-color: #EEEEBC; border-top: 1px dashed #A2A286">
                        <table cellpadding="0" cellspacing="0" width="100%" align="center" border="0">
                            <tr>
                                <td width="55" align="left" valign="bottom">
                                    <img name="Gup" id="Gup" title="Previous" onmousedown="intGP--;GetGenres('u')" onmouseup="GotoGenre();GenreShowAllSuggest()" style="border: 0px; vertical-align: bottom; margin-top: 2px; margin-left: 7px; cursor: pointer" src="<%=AssetsPath()%>/Aup.gif">
                                    <img name="Gdn" id="Gdn" title="Next" onmousedown="intGP++;GetGenres('d')" onmouseup="GotoGenre();GenreShowAllSuggest()" style="border: 0px; vertical-align: bottom; margin-top: 2px; cursor: pointer" src="<%=AssetsPath()%>/Adn.gif">
                                </td>
                                <td width="100" style="text-align: left; vertical-align: bottom; padding-bottom: 2px">
                                    <p name="GpP" id="GpP" style="color: #2F3042; font-size: 11px">-</p>
                                </td>
                                <td width="140" style="text-align: right; vertical-align: bottom; padding-bottom: 2px; padding-right: 12px">
                                    <p name="GpT" id="GpT" style="color: #2F3042; font-size: 11px">-</p>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </td>
            <td width="177" valign="top" align="left">

                <%'Label Suggest%>
                <div name="Ldivmain" id="Ldivmain" style="position: absolute; width: 300px; min-height: 217px; visibility: hidden; z-index: 200; background-color: #FFFFC8; border: 1px solid #363636">
                    <div name="Ld1" id="Ld1" onmouseover="LabelMouseOverSuggest(1)" onmouseout="LabelMouseOutSuggest(1)" onmousedown="LabelClickSuggest(1)" style="width: 292px; padding: 3px; visibility: hidden; cursor: default; text-align: left; padding: 3px; z-index: 100; background-color: #FFFFC8; border: 0px">
                        <p name="Lp1" id="Lp1" style="font-weight: 900; color: #2F3042; font-size: 11px">-</p>
                        <p name="Lp1a" id="Lp1a" style="color: #2F3042; font-size: 11px">-</p>
                    </div>
                    <div name="Ld2" id="Ld2" onmouseover="LabelMouseOverSuggest(2)" onmouseout="LabelMouseOutSuggest(2)" onmousedown="LabelClickSuggest(2)" style="width: 292px; padding: 3px; visibility: hidden; cursor: default; text-align: left; padding: 3px; z-index: 100; background-color: #FFFFC8; border: 0px">
                        <p name="Lp2" id="Lp2" style="font-weight: 900; color: #2F3042; font-size: 11px">-</p>
                        <p name="Lp2a" id="Lp2a" style="color: #2F3042; font-size: 11px">-</p>
                    </div>
                    <div name="Ld3" id="Ld3" onmouseover="LabelMouseOverSuggest(3)" onmouseout="LabelMouseOutSuggest(3)" onmousedown="LabelClickSuggest(3)" style="width: 292px; padding: 3px; visibility: hidden; cursor: default; text-align: left; padding: 3px; z-index: 100; background-color: #FFFFC8; border: 0px">
                        <p name="Lp3" id="Lp3" style="font-weight: 900; color: #2F3042; font-size: 11px">-</p>
                        <p name="Lp3a" id="Lp3a" style="color: #2F3042; font-size: 11px">-</p>
                    </div>
                    <div name="Ld4" id="Ld4" onmouseover="LabelMouseOverSuggest(4)" onmouseout="LabelMouseOutSuggest(4)" onmousedown="LabelClickSuggest(4)" style="width: 292px; padding: 3px; visibility: hidden; cursor: default; text-align: left; padding: 3px; z-index: 100; background-color: #FFFFC8; border: 0px">
                        <p name="Lp4" id="Lp4" style="font-weight: 900; color: #2F3042; font-size: 11px">-</p>
                        <p name="Lp4a" id="Lp4a" style="color: #2F3042; font-size: 11px">-</p>
                    </div>
                    <div name="Ld5" id="Ld5" onmouseover="LabelMouseOverSuggest(5)" onmouseout="LabelMouseOutSuggest(5)" onmousedown="LabelClickSuggest(5)" style="width: 292px; padding: 3px; visibility: hidden; cursor: default; text-align: left; padding: 3px; z-index: 100; background-color: #FFFFC8; border: 0px">
                        <p name="Lp5" id="Lp5" style="font-weight: 900; color: #2F3042; font-size: 11px">-</p>
                        <p name="Lp5a" id="Lp5a" style="color: #2F3042; font-size: 11px">-</p>
                    </div>
                    <div name="Ld6" id="Ld6" onmouseover="LabelMouseOverSuggest(6)" onmouseout="LabelMouseOutSuggest(6)" onmousedown="LabelClickSuggest(6)" style="width: 292px; padding: 3px; visibility: hidden; cursor: default; text-align: left; padding: 3px; z-index: 100; background-color: #FFFFC8; border: 0px">
                        <p name="Lp6" id="Lp6" style="font-weight: 900; color: #2F3042; font-size: 11px">-</p>
                        <p name="Lp6a" id="Lp6a" style="color: #2F3042; font-size: 11px">-</p>
                    </div>
                    <div name="Ld7" id="Ld7" onmouseover="LabelMouseOverSuggest(7)" onmouseout="LabelMouseOutSuggest(7)" onmousedown="LabelClickSuggest(7)" style="width: 292px; padding: 3px; visibility: hidden; cursor: default; text-align: left; padding: 3px; z-index: 100; background-color: #FFFFC8; border: 0px">
                        <p name="Lp7" id="Lp7" style="font-weight: 900; color: #2F3042; font-size: 11px">-</p>
                        <p name="Lp7a" id="Lp7a" style="color: #2F3042; font-size: 11px">-</p>
                    </div>
                    <div name="Ld8" id="Ld8" onmouseover="LabelMouseOverSuggest(8)" onmouseout="LabelMouseOutSuggest(8)" onmousedown="LabelClickSuggest(8)" style="width: 292px; padding: 3px; visibility: hidden; cursor: default; text-align: left; padding: 3px; z-index: 100; background-color: #FFFFC8; border: 0px">
                        <p name="Lp8" id="Lp8" style="font-weight: 900; color: #2F3042; font-size: 11px">-</p>
                        <p name="Lp8a" id="Lp8a" style="color: #2F3042; font-size: 11px">-</p>
                    </div>
                    <div name="Ld9" id="Ld9" onmouseover="LabelMouseOverSuggest(9)" onmouseout="LabelMouseOutSuggest(9)" onmousedown="LabelClickSuggest(9)" style="width: 292px; padding: 3px; visibility: hidden; cursor: default; text-align: left; padding: 3px; z-index: 100; background-color: #FFFFC8; border: 0px">
                        <p name="Lp9" id="Lp9" style="font-weight: 900; color: #2F3042; font-size: 11px">-</p>
                        <p name="Lp9a" id="Lp9a" style="color: #2F3042; font-size: 11px">-</p>
                    </div>
                    <div name="Ld10" id="Ld10" onmouseover="LabelMouseOverSuggest(10)" onmouseout="LabelMouseOutSuggest(10)" onmousedown="LabelClickSuggest(10)" style="width: 292px; padding: 3px; visibility: hidden; cursor: default; text-align: left; padding: 3px; z-index: 100; background-color: #FFFFC8; border: 0px">
                        <p name="Lp10" id="Lp10" style="font-weight: 900; color: #2F3042; font-size: 11px">-</p>
                        <p name="Lp10a" id="Lp10a" style="color: #2F3042; font-size: 11px">-</p>
                    </div>
                    <div name="LdP" id="LdP" style="height: 26px; padding: 0px; visibility: hidden; text-align: left; z-index: 100; background-color: #EEEEBC; border-top: 1px dashed #A2A286">
                        <table cellpadding="0" cellspacing="0" width="100%" align="center" border="0">
                            <tr>
                                <td width="55" align="left" valign="bottom">
                                    <img name="Lup" id="Lup" title="Previous" onmousedown="intLP--;GetLabels('u')" onmouseup="GotoLabel();LabelShowAllSuggest()" style="border: 0px; vertical-align: bottom; margin-top: 2px; margin-left: 7px; cursor: pointer" src="<%=AssetsPath()%>/Aup.gif">
                                    <img name="Ldn" id="Ldn" title="Next" onmousedown="intLP++;GetLabels('d')" onmouseup="GotoLabel();LabelShowAllSuggest()" style="border: 0px; vertical-align: bottom; margin-top: 2px; cursor: pointer" src="<%=AssetsPath()%>/Adn.gif">
                                </td>
                                <td width="100" style="text-align: left; vertical-align: bottom; padding-bottom: 2px">
                                    <p name="LpP" id="LpP" style="color: #2F3042; font-size: 11px">-</p>
                                </td>
                                <td width="140" style="text-align: right; vertical-align: bottom; padding-bottom: 2px; padding-right: 12px">
                                    <p name="LpT" id="LpT" style="color: #2F3042; font-size: 11px">-</p>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </td>
            <td width="155" align="right" height="16"></td>
            <td width="86"></td>
        </tr>
    </table>

    <table cellpadding="0" bgcolor="9BAF9B" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td width="1250" height="11"></td>
        </tr>
    </table>


    <%
 Dim varDisplayLikeHomePage As Integer = 0
 varYouSearchedForArtist = Replace(varArtistCriteria, """", "")
 varYouSearchedForFormat = varFormatCriteria
 varYouSearchedForRecent = varRecentCriteria
 varYouSearchedForYear = varYearCriteria
 varYouSearchedForPrice = varPriceCriteria
 varYouSearchedForGenre = varGenreCriteria
 varYouSearchedForLabel = varlabelCriteria
 varYouSearchedForIncludeUsed = varIncludeUsedCriteria
 ' *** SQL STRING ***
 ' *** SQL STRING ***

 Dim varSearchTypeDescription As String = ""
 Dim NoSearchCriteria As String = ""
 Dim searchartist As String = ""
 Dim varSearchArtist As String = ""
 Dim position As Integer = 0
 Dim varSongSearch As Integer = 0
 Dim varSoundCheck As Integer = 0
 Dim numberofartistparts As Integer = 0
 Dim startposition As Integer = 0
 Dim varUsedItemsSearch As Integer = 0
 Dim searchFormat As String = ""
 Dim varSearchFormat As String = ""
 Dim SearchRecentDate As String = ""
 Dim varHowRecentStatistic As String = ""
 Dim SearchRhythm As String = ""
 Dim SearchLabel As String = ""
 Dim varSearchLabel As String = ""
 Dim varSpecialCoxsoneSearch As String = ""
 Dim SearchIncludeUsed As String = ""
 Dim SearchGenre As String = ""
 Dim SearchYear As String = ""
 Dim varYearStatistic As String = ""
 Dim varSelectedAYear As Integer = 0
 Dim SearchYearFrom As String = ""
 Dim SearchYearTo As String = ""
 Dim SearchPrice As String = ""
 Dim varSelectedAPrice As String = ""
 Dim SearchPriceFrom As Integer = 0
 Dim SearchPriceTo As Integer = 0
 Dim varPriceFromStatistic As String = ""
 Dim varPriceToStatistic As String = ""
 Dim ArtistTitlePrintout As String = ""
 Dim FormatPrintout As String = ""
 Dim RecentDatePrintout As String = ""
 Dim RhythmPrintout As String = ""
 Dim LabelPrintout As String = ""
 Dim YearPrintout As String = ""
 Dim SearchQueryString As String = ""
 Dim AndOrWhere As String = ""
 Dim varIsACatalogSearch As Integer = 0
 Dim varChar4 As Integer = 0
 Dim varChar3 As Integer = 0
 Dim varLetterPart As String = ""
 Dim varNumberPart As String = ""
 Dim Format As String = ""
 Dim varGenreSQL As String = ""
 Dim varSearchGenreFixed As String = ""
 Dim varLabelSearchID As String = ""
 Dim labelnamesearch As String = ""
 Dim varSimilarItemsSearchID As String = ""
 Dim varSimilarGenre As String = ""
 Dim varSimilarYearFrom As String = ""
 Dim varSimilarYearTo As String = ""
 Dim varYearSearchID As String = ""
 Dim varAllYearYearFrom As String = ""
 Dim varAllYearYearTo As String = ""
 Dim rhythmnamesearch As String = ""
 Dim SortRhythm As String = ""
 Dim varRhythmNameSearch As String = ""
 Dim varWholesaleCustomerID As String = ""
 Dim CartTotal As Decimal = 0
 Dim varFormatQuantityTotal(30)
 Dim varFormatPriceTotal(30)
 Dim varFormatOn(30)
 Dim varQuantityGot As Integer = 0
 Dim varPriceTotal As Double = 0
 Dim totalcartquantity As Integer = 0
 Dim varLastFormat As String = ""
 Dim varFormatRow As Integer = 0
 Dim EPQueryString As String = ""
 Dim varBroadcastListName As String = ""
 Dim varSongSearchFormatPrintout As String = ""
 Dim varSongSearchPrintoutQuote As Integer = 0
 Dim varSSSong As String = ""
 Dim varSSFormat As String = ""
 Dim varSingleItemNotInInventoryTable As Integer = 0
 Dim varSingleItemZeroInventory As Integer = 0
 Dim varSingleItemFound As Integer = 0
 Dim varSPROCNameForCartTotals As String = ""

 If varQueryType = "NewSearch" Then
  varSearchTypeDescription = "New Search"
  NoSearchCriteria = "yes"
  'SearchArtist 
  searchartist = fixtext(varArtistCriteria)
  varSearchArtist = Trim(searchartist)
  If UCase(varSearchArtist) = "ALL" Then
   varSearchArtist = ""
  End If
  If Len(searchartist) >= 4 Then
   position = InStr(1, searchartist, "[%]")
   If position > 0 Then
    Do
     searchartist = Trim(Left(searchartist, position - 1)) & " [%] " & Trim(Right(searchartist, Len(searchartist) - position - 2))
     If position + 3 > Len(searchartist) Then Exit Do
     position = InStr(position + 3, searchartist, "[%]")
     If position = 0 Then Exit Do
    Loop
   End If
  End If
  searchartist = Trim(searchartist)
  If Len(searchartist) > 255 Then
   searchartist = Left(searchartist, 255)
  End If
  If UCase(searchartist) = "ALL" Then
   searchartist = ""
  Else
   If UCase(searchartist) = "ACDC" Then
    searchartist = "AC/DC"
   End If
   If Left(searchartist, 3) = "000" And Len(searchartist) > 3 Then
    varSongSearch = 1
    searchartist = Right(searchartist, Len(searchartist) - 3)
    varSearchTypeDescription = "New Search (Song Search 000)"
   End If
   varSoundCheck = 0
   If Left(UCase(searchartist), 10) = "SOUNDCHECK" And Len(searchartist) > 10 Then
    varSoundCheck = 1
    searchartist = Right(searchartist, Len(searchartist) - 10)
    varSearchTypeDescription = "Sound Check"
   End If
   If Len(searchartist) >= 4 Then
    If Left(searchartist, 3) = "mr " Then
     searchartist = "mr. " & Trim(Right(searchartist, Len(searchartist) - 3))
    ElseIf Left(searchartist, 3) = "jr " Then
     searchartist = "jr. " & Trim(Right(searchartist, Len(searchartist) - 3))
    ElseIf Left(searchartist, 4) = "the " Then
     searchartist = Trim(Right(searchartist, Len(searchartist) - 4))
    End If
    If Len(searchartist) >= 8 Then
     If Left(searchartist, 7) = "mister " Then
      searchartist = "mr. " & Trim(Right(searchartist, Len(searchartist) - 7))
     ElseIf Left(searchartist, 7) = "junior " Then
      searchartist = "jr. " & Trim(Right(searchartist, Len(searchartist) - 7))
     End If
    End If
   End If
   If UCase(searchartist) = "ROCKER T" Or UCase(searchartist) = "ROCKER TEE" Or UCase(searchartist) = "ROCKER-T" Then
    artistpart(1) = "Rocker T"
    numberofartistparts = 1
   Else
    startposition = 1
    For n = 1 To 40
     position = InStr(startposition, searchartist, " ")
     If position > 0 Then
      artistpart(n) = Trim(Mid(searchartist, startposition, position - startposition))
      searchartist = Trim(Left(searchartist, position - 1)) & " " & Trim(Right(searchartist, Len(searchartist) - position))
      startposition = position + 1
     Else
      artistpart(n) = Trim(Right(searchartist, Len(searchartist) - startposition + 1))
      Exit For
     End If
    Next
    numberofartistparts = n
   End If
   varUsedItemsSearch = 0
   If UCase(searchartist) = "USED ITEMS" Or UCase(searchartist) = "USED ITEM" Or UCase(searchartist) = "USED ITEMS:" Or UCase(searchartist) = "USED ITEM:" Then
    artistpart(1) = "USED ITEM:"
    numberofartistparts = 1
    varUsedItemsSearch = 1
   ElseIf UCase(searchartist) = "USED 7""" Or UCase(searchartist) = "USED 12""" Or UCase(searchartist) = "USED 10""" Or UCase(searchartist) = "USED LP" Or UCase(searchartist) = "USED CD" Or UCase(searchartist) = "USED VINYL" Or UCase(searchartist) = "USED RECORDS" Or UCase(searchartist) = "USED RECORD" Then
    artistpart(1) = "USED ITEM:"
    numberofartistparts = 1
    varUsedItemsSearch = 1
   End If
  End If
  'searchFormat
  searchFormat = UCase(varFormatCriteria)
  varSearchFormat = searchFormat
  If searchFormat = "ALL" Then
   searchFormat = ""
  ElseIf UCase(searchFormat) = "CASSETTE TAPES" Then
   searchFormat = "CS"
  ElseIf UCase(searchFormat) = "SLEEVES" Then
   searchFormat = "SLV"
  ElseIf InStr(1, UCase(searchFormat), "ADAPTERS") > 0 Then
   searchFormat = "ADP"
  ElseIf UCase(searchFormat) = "STICKERS" Then
   searchFormat = "STK"
  ElseIf UCase(searchFormat) = "PHOTOS" Then
   searchFormat = "PH"
  ElseIf UCase(searchFormat) = "SLIPMATS" Then
   searchFormat = "SLM"
  ElseIf UCase(searchFormat) = "RECORD SUPPLIES/BAGS" Then
   searchFormat = "RB"
  ElseIf UCase(searchFormat) = "FLAGS" Then
   searchFormat = "FLG"
  ElseIf UCase(searchFormat) = "VINYL" Then
   searchFormat = "Vinyl"
  End If
  'searchRecentDate
  SearchRecentDate = ""
  Select Case varRecentCriteria
   Case "ALL"
    varHowRecentStatistic = ""
    SearchRecentDate = ""
   Case "1 Day Back"
    SearchRecentDate = Date.Now.AddDays(-2).ToString
    varHowRecentStatistic = 1
   Case "2 Days Back"
    SearchRecentDate = Date.Now.AddDays(-3).ToString
    varHowRecentStatistic = 2
   Case "3 Days Back"
    SearchRecentDate = Date.Now.AddDays(-4).ToString
    varHowRecentStatistic = 3
   Case "4 Days Back"
    SearchRecentDate = Date.Now.AddDays(-5).ToString
    varHowRecentStatistic = 4
   Case "5 Days Back"
    SearchRecentDate = Date.Now.AddDays(-6).ToString
    varHowRecentStatistic = 5
   Case "6 Days Back"
    SearchRecentDate = Date.Now.AddDays(-7).ToString
    varHowRecentStatistic = 6
   Case "7 Days Back"
    SearchRecentDate = Date.Now.AddDays(-8).ToString
    varHowRecentStatistic = 7
   Case "14 Days Back"
    SearchRecentDate = Date.Now.AddDays(-15).ToString
    varHowRecentStatistic = 14
   Case "21 Days Back"
    SearchRecentDate = Date.Now.AddDays(-22).ToString
    varHowRecentStatistic = 21
   Case "30 Days Back"
    SearchRecentDate = Date.Now.AddDays(-31).ToString
    varHowRecentStatistic = 30
   Case "60 Days Back"
    SearchRecentDate = Date.Now.AddDays(-61).ToString
    varHowRecentStatistic = 60
   Case "90 Days Back"
    SearchRecentDate = Date.Now.AddDays(-91).ToString
    varHowRecentStatistic = 90
   Case "180 Days Back"
    SearchRecentDate = Date.Now.AddDays(-181).ToString
    varHowRecentStatistic = 180
   Case "360 Days Back"
    SearchRecentDate = Date.Now.AddDays(-361).ToString
    varHowRecentStatistic = 360
  End Select
  'SearchRhythm
  SearchRhythm = fixtext(varRhythmCriteria)
  If Len(SearchRhythm) > 50 Then
   SearchRhythm = Left(SearchRhythm, 50)
  End If
  If SearchRhythm = "ALL" Then
   SearchRhythm = ""
  End If

  'SearchLabel
  SearchLabel = fixtext(varlabelCriteria)
  If Len(SearchLabel) > 50 Then
   SearchLabel = Left(SearchLabel, 50)
  End If
  If SearchLabel = "ALL" Then
   SearchLabel = ""
  End If
  varSearchLabel = SearchLabel
  varSpecialCoxsoneSearch = 0

  'SearchIncludeUsed
  SearchIncludeUsed = fixtext(varIncludeUsedCriteria)
  If Len(SearchIncludeUsed) > 50 Then
   SearchIncludeUsed = Left(SearchIncludeUsed, 50)
  End If
  If SearchIncludeUsed = "ALL" Then
   SearchIncludeUsed = ""
  End If

  'SearchGenre
  SearchGenre = fixtext(varGenreCriteria)
  If Len(SearchGenre) > 50 Then
   SearchGenre = Left(SearchGenre, 50)
  End If
  If SearchGenre = "ALL" Then
   SearchGenre = ""
  End If
  'SearchYearFrom and SearchYearTo
  SearchYear = varYearCriteria
  varYearStatistic = SearchYear
  varSelectedAYear = 0
  If SearchYear = "ALL" Then
   SearchYearFrom = "1900"
   varYearStatistic = ""
   SearchYearTo = CStr(Year(Date.Now))
  ElseIf SearchYear = "2010's" Then
   varSelectedAYear = 1
   SearchYearFrom = "2010"
   SearchYearTo = CStr(Year(Date.Now))
  ElseIf SearchYear = "2000's" Then
   varSelectedAYear = 1
   SearchYearFrom = "2000"
   SearchYearTo = "2009"
  ElseIf SearchYear = "1990's" Then
   varSelectedAYear = 1
   SearchYearFrom = "1990"
   SearchYearTo = "1999"
  ElseIf SearchYear = "1980's" Then
   varSelectedAYear = 1
   SearchYearFrom = "1980"
   SearchYearTo = "1989"
  ElseIf SearchYear = "1970's" Then
   varSelectedAYear = 1
   SearchYearFrom = "1970"
   SearchYearTo = "1979"
  ElseIf SearchYear = "1960's" Then
   varSelectedAYear = 1
   SearchYearFrom = "1960"
   SearchYearTo = "1969"
  ElseIf SearchYear = "1950's" Then
   varSelectedAYear = 1
   SearchYearFrom = "1950"
   SearchYearTo = "1959"
  ElseIf SearchYear = "1940's" Then
   varSelectedAYear = 1
   SearchYearFrom = "1940"
   SearchYearTo = "1949"
  ElseIf SearchYear = "1930's" Then
   varSelectedAYear = 1
   SearchYearFrom = "1930"
   SearchYearTo = "1939"
  ElseIf SearchYear = "1920's" Then
   varSelectedAYear = 1
   SearchYearFrom = "1920"
   SearchYearTo = "1929"
  ElseIf SearchYear = "1910's" Then
   varSelectedAYear = 1
   SearchYearFrom = "1910"
   SearchYearTo = "1919"
  ElseIf SearchYear = "1900's" Then
   varSelectedAYear = 1
   SearchYearFrom = "1900"
   SearchYearTo = "1909"
  Else
   varYearCriteria = ""
   SearchYear = ""
   SearchYearFrom = "1900"
   varYearStatistic = ""
   SearchYearTo = CStr(Year(Date.Now))
  End If

  'SearchPriceFrom and SearchPriceTo
  SearchPrice = varPriceCriteria
  varSelectedAPrice = 0
  If SearchPrice = "ALL" Then
   varSelectedAPrice = 0
   SearchPriceFrom = 0
   SearchPriceTo = 9999
  ElseIf SearchPrice = "Under $2" Then
   varSelectedAPrice = 1
   SearchPriceFrom = 0
   SearchPriceTo = 2.0
   varPriceFromStatistic = "0"
   varPriceToStatistic = "2.00"
  ElseIf SearchPrice = "Under $3" Then
   varSelectedAPrice = 1
   SearchPriceFrom = 0
   SearchPriceTo = 3.0
   varPriceFromStatistic = "0"
   varPriceToStatistic = "3.00"
  ElseIf SearchPrice = "Under $5" Then
   varSelectedAPrice = 1
   SearchPriceFrom = 0
   SearchPriceTo = 5.0
   varPriceFromStatistic = "0"
   varPriceToStatistic = "5.00"
  ElseIf SearchPrice = "Under $8" Then
   varSelectedAPrice = 1
   SearchPriceFrom = 0
   SearchPriceTo = 8.0
   varPriceFromStatistic = "0"
   varPriceToStatistic = "8.00"
  ElseIf SearchPrice = "Under $10" Then
   varSelectedAPrice = 1
   SearchPriceFrom = 0
   SearchPriceTo = 10.0
   varPriceFromStatistic = "0"
   varPriceToStatistic = "10.00"
  ElseIf SearchPrice = "Under $12" Then
   varSelectedAPrice = 1
   SearchPriceFrom = 0
   SearchPriceTo = 12.0
   varPriceFromStatistic = "0"
   varPriceToStatistic = "12.00"
  ElseIf SearchPrice = "Under $13" Then
   varSelectedAPrice = 1
   SearchPriceFrom = 0
   SearchPriceTo = 13.0
   varPriceFromStatistic = "0"
   varPriceToStatistic = "13.00"
  ElseIf SearchPrice = "Under $14" Then
   varSelectedAPrice = 1
   SearchPriceFrom = 0
   SearchPriceTo = 14.0
   varPriceFromStatistic = "0"
   varPriceToStatistic = "14.00"
  ElseIf SearchPrice = "Under $16" Then
   varSelectedAPrice = 1
   SearchPriceFrom = 0
   SearchPriceTo = 16.0
   varPriceFromStatistic = "0"
   varPriceToStatistic = "16.00"
  ElseIf SearchPrice = "Under $18" Then
   varSelectedAPrice = 1
   SearchPriceFrom = 0
   SearchPriceTo = 18.0
   varPriceFromStatistic = "0"
   varPriceToStatistic = "18.00"
  ElseIf SearchPrice = "Under $20" Then
   varSelectedAPrice = 1
   SearchPriceFrom = 0
   SearchPriceTo = 20.0
   varPriceFromStatistic = "0"
   varPriceToStatistic = "20.00"
  ElseIf SearchPrice = "Under $25" Then
   varSelectedAPrice = 1
   SearchPriceFrom = 0
   SearchPriceTo = 25.0
   varPriceFromStatistic = "0"
   varPriceToStatistic = "25.00"
  ElseIf SearchPrice = "Under $30" Then
   varSelectedAPrice = 1
   SearchPriceFrom = 0
   SearchPriceTo = 30.0
   varPriceFromStatistic = "0"
   varPriceToStatistic = "30.00"
  ElseIf SearchPrice = "Over $20" Then
   varSelectedAPrice = 1
   SearchPriceFrom = 20
   SearchPriceTo = 10000
   varPriceFromStatistic = "20.00"
   varPriceToStatistic = "10000"
  ElseIf SearchPrice = "Over $50" Then
   varSelectedAPrice = 1
   SearchPriceFrom = 50
   SearchPriceTo = 10000
   varPriceFromStatistic = "50.00"
   varPriceToStatistic = "10000"
  ElseIf SearchPrice = "Over $100" Then
   varSelectedAPrice = 1
   SearchPriceFrom = 100
   SearchPriceTo = 10000
   varPriceFromStatistic = "100.00"
   varPriceToStatistic = "10000"
  Else
   varPriceCriteria = ""
   SearchPrice = ""
   varSelectedAPrice = 0
   SearchPriceFrom = 0
   varPriceFromStatistic = 0
   SearchPriceTo = 9999
   varPriceToStatistic = ""
  End If


  ArtistTitlePrintout = ""
  FormatPrintout = ""
  RecentDatePrintout = ""
  RhythmPrintout = ""
  LabelPrintout = ""
  YearPrintout = ""
  SearchQueryString = "select * from inventory"
  AndOrWhere = "where"
  If searchartist <> "" Then ' artist
   If Left(searchartist, 11) = "Begins With" Then
    If Len(searchartist) >= 13 Then
     searchartist = Mid(searchartist, 13, 1)
     varSearchTypeDescription = "New Search (Begins With...)"
    Else
     searchartist = "Begins With ?"
    End If
    SearchQueryString = SearchQueryString & " " & AndOrWhere & " artisttitle like '" & searchartist & "%'"
    AndOrWhere = "and"
    ArtistTitlePrintout = searchartist
    NoSearchCriteria = "no"
   ElseIf varUsedItemsSearch = 1 Then 'used item search
    SearchQueryString = SearchQueryString & " " & AndOrWhere & " artisttitle like 'USED ITEM:%'"
    AndOrWhere = "and"
    ArtistTitlePrintout = "USED ITEMS"
    NoSearchCriteria = "no"
   ElseIf varSoundCheck = 1 Then ' Sound Check
    SearchQueryString = SearchQueryString & " " & AndOrWhere & " MP3SoundGroup =" & searchartist
    AndOrWhere = "and"
    ArtistTitlePrintout = searchartist
    NoSearchCriteria = "no"
   Else
    varIsACatalogSearch = 0 ' Catalog Search
    For n3 = 1 To Len(searchartist)
     varChar4 = Asc(UCase(Mid(searchartist, n3, 1)))
     If varChar4 >= 48 And varChar4 <= 57 And n3 <> 1 Then
      varChar3 = Asc(UCase(Mid(searchartist, n3 - 1, 1)))
      If varChar3 >= 65 And varChar3 <= 90  And UCase(searchartist) <> "MP3" Then
       varIsACatalogSearch = 1
       varLetterPart = Left(searchartist, n3 - 1)
       varNumberPart = Right(searchartist, Len(searchartist) - n3 + 1)
       Exit For
      End If
     End If
    Next
    If InStr(1, UCase(searchartist), "UB40") > 0 Then
     varIsACatalogSearch = 0
    End If
    If varIsACatalogSearch = 1 Then
     varSearchTypeDescription = "New Search (Catalog Search)"
     If varNumberPart = "0" Then
      SearchQueryString = SearchQueryString & " " & AndOrWhere & " catalog like '%" & varLetterPart & "%'"
      AndOrWhere = "and"
      ArtistTitlePrintout = searchartist
      NoSearchCriteria = "no"
     Else
      SearchQueryString = SearchQueryString & " " & AndOrWhere & " catalog like '%" & varLetterPart & "%'" _
       & " and catalog like '%" & varNumberPart & "%'"
      AndOrWhere = "and"
      ArtistTitlePrintout = searchartist
      NoSearchCriteria = "no"
     End If
    Else 'Artist Search
     If varArtistExact = "y" Then
      SearchQueryString = "select Genre1,WeightInGrams,SupplierID,Inventory.Format,UPC,rhythmname,id,artisttitle,cutout,UsedItem" _
       & ",tracksgroup,producegroup,WebEssential,WebReviewHTML,musiciangroup,storeprice,exportprice" _
       & ",retailprice,Cost,MP3FileCompleted,Deleted,Inventory,NumberOfTracks" _
       & ",Sale_RetailPrice,Sale_RetailEndDate,Sale_RetailFootnoteText,Sale_RetailItemDetailsText,Sale_WholesalePrice,Sale_WholesaleEndDate,Sale_WholesaleFootnoteText,Sale_WholesaleItemDetailsText,ItemFootnoteText" _
       & ",Label,Catalog,YearFrom,YearTo,DateAdded,ConditionJacket,ConditionVinylOrCD,ConditionNotes,ConditionText" _
       & ",ItemFeatures1,ItemFeatures2,ItemFeatures3,ItemFeatures4,ItemFeatures5,ItemFeatures6,ItemFeatures7,ItemFeatures8,ItemFeatures9,ItemFeatures10,FormatOrder,SalesLast30Days" _
       & " from inventory inner join WebArtists on Inventory.ID=WebArtists.InventoryID" _
       & " where WebArtists.Artist = '" & searchartist & "'"
      AndOrWhere = "and"
     Else
      For nnn = 1 To numberofartistparts
       If nnn = 1 Then
        SearchQueryString = SearchQueryString & " where ((ArtistTitle like '%" & artistpart(nnn) & "%'"
       Else
        SearchQueryString = SearchQueryString & " and ArtistTitle like '%" & artistpart(nnn) & "%'"
       End If
      Next
      SearchQueryString = SearchQueryString & ")"
      For nnn = 1 To numberofartistparts
       If nnn = 1 Then
        SearchQueryString = SearchQueryString & " or (label like '%" & artistpart(nnn) & "%'"
       Else
        SearchQueryString = SearchQueryString & " and label like '%" & artistpart(nnn) & "%'"
       End If
      Next
      SearchQueryString = SearchQueryString & ")"
      For nnn = 1 To numberofartistparts
       If nnn = 1 Then
        SearchQueryString = SearchQueryString & " or (Genre1 like '%" & artistpart(nnn) & "%'"
       Else
        SearchQueryString = SearchQueryString & " and Genre1 like '%" & artistpart(nnn) & "%'"
       End If
      Next
      SearchQueryString = SearchQueryString & ")"
      For nnn = 1 To numberofartistparts
       If nnn = 1 Then
        SearchQueryString = SearchQueryString & " or (Genre2 like '%" & artistpart(nnn) & "%'"
       Else
        SearchQueryString = SearchQueryString & " and Genre2 like '%" & artistpart(nnn) & "%'"
       End If
      Next
      SearchQueryString = SearchQueryString & ")"
      For nnn = 1 To numberofartistparts
       If nnn = 1 Then
        SearchQueryString = SearchQueryString & " or (Genre3 like '%" & artistpart(nnn) & "%'"
       Else
        SearchQueryString = SearchQueryString & " and Genre3 like '%" & artistpart(nnn) & "%'"
       End If
      Next
      SearchQueryString = SearchQueryString & ")"
      For nnn = 1 To numberofartistparts
       If nnn = 1 Then
        SearchQueryString = SearchQueryString & " or (Genre4 like '%" & artistpart(nnn) & "%'"
       Else
        SearchQueryString = SearchQueryString & " and Genre4 like '%" & artistpart(nnn) & "%'"
       End If
      Next
      SearchQueryString = SearchQueryString & ")"
      For nnn = 1 To numberofartistparts
       If nnn = 1 Then
        SearchQueryString = SearchQueryString & " or (Genre5 like '%" & artistpart(nnn) & "%'"
       Else
        SearchQueryString = SearchQueryString & " and Genre5 like '%" & artistpart(nnn) & "%'"
       End If
      Next
      SearchQueryString = SearchQueryString & ")"
      For nnn = 1 To numberofartistparts
       If nnn = 1 Then
        SearchQueryString = SearchQueryString & " or (Genre6 like '%" & artistpart(nnn) & "%'"
       Else
        SearchQueryString = SearchQueryString & " and Genre6 like '%" & artistpart(nnn) & "%'"
       End If
      Next
      SearchQueryString = SearchQueryString & ")"
      For nnn = 1 To numberofartistparts
       If nnn = 1 Then
        SearchQueryString = SearchQueryString & " or (Genre7 like '%" & artistpart(nnn) & "%'"
       Else
        SearchQueryString = SearchQueryString & " and Genre7 like '%" & artistpart(nnn) & "%'"
       End If
      Next
      SearchQueryString = SearchQueryString & ")"
      For nnn = 1 To numberofartistparts
       If nnn = 1 Then
        SearchQueryString = SearchQueryString & " or (Genre8 like '%" & artistpart(nnn) & "%'"
       Else
        SearchQueryString = SearchQueryString & " and Genre8 like '%" & artistpart(nnn) & "%'"
       End If
      Next
      SearchQueryString = SearchQueryString & ")"
      For nnn = 1 To numberofartistparts
       If nnn = 1 Then
        SearchQueryString = SearchQueryString & " or (Genre9 like '%" & artistpart(nnn) & "%'"
       Else
        SearchQueryString = SearchQueryString & " and Genre9 like '%" & artistpart(nnn) & "%'"
       End If
      Next
      SearchQueryString = SearchQueryString & ")"
      For nnn = 1 To numberofartistparts
       If nnn = 1 Then
        SearchQueryString = SearchQueryString & " or (ItemFeatures1 like '%" & artistpart(nnn) & "%'"
       Else
        SearchQueryString = SearchQueryString & " and ItemFeatures1 like '%" & artistpart(nnn) & "%'"
       End If
      Next
      SearchQueryString = SearchQueryString & ")"
      For nnn = 1 To numberofartistparts
       If nnn = 1 Then
        SearchQueryString = SearchQueryString & " or (ItemFeatures2 like '%" & artistpart(nnn) & "%'"
       Else
        SearchQueryString = SearchQueryString & " and ItemFeatures2 like '%" & artistpart(nnn) & "%'"
       End If
      Next
      SearchQueryString = SearchQueryString & ")"
      For nnn = 1 To numberofartistparts
       If nnn = 1 Then
        SearchQueryString = SearchQueryString & " or (ItemFeatures3 like '%" & artistpart(nnn) & "%'"
       Else
        SearchQueryString = SearchQueryString & " and ItemFeatures3 like '%" & artistpart(nnn) & "%'"
       End If
      Next
      SearchQueryString = SearchQueryString & ")"
      For nnn = 1 To numberofartistparts
       If nnn = 1 Then
        SearchQueryString = SearchQueryString & " or (ItemFeatures4 like '%" & artistpart(nnn) & "%'"
       Else
        SearchQueryString = SearchQueryString & " and ItemFeatures4 like '%" & artistpart(nnn) & "%'"
       End If
      Next
      SearchQueryString = SearchQueryString & ")"
      For nnn = 1 To numberofartistparts
       If nnn = 1 Then
        SearchQueryString = SearchQueryString & " or (ItemFeatures5 like '%" & artistpart(nnn) & "%'"
       Else
        SearchQueryString = SearchQueryString & " and ItemFeatures5 like '%" & artistpart(nnn) & "%'"
       End If
      Next
      SearchQueryString = SearchQueryString & ")"
      For nnn = 1 To numberofartistparts
       If nnn = 1 Then
        SearchQueryString = SearchQueryString & " or (ItemFeatures6 like '%" & artistpart(nnn) & "%'"
       Else
        SearchQueryString = SearchQueryString & " and ItemFeatures6 like '%" & artistpart(nnn) & "%'"
       End If
      Next
      SearchQueryString = SearchQueryString & ")"
      For nnn = 1 To numberofartistparts
       If nnn = 1 Then
        SearchQueryString = SearchQueryString & " or (ItemFeatures7 like '%" & artistpart(nnn) & "%'"
       Else
        SearchQueryString = SearchQueryString & " and ItemFeatures7 like '%" & artistpart(nnn) & "%'"
       End If
      Next
      SearchQueryString = SearchQueryString & ")"
      For nnn = 1 To numberofartistparts
       If nnn = 1 Then
        SearchQueryString = SearchQueryString & " or (ItemFeatures8 like '%" & artistpart(nnn) & "%'"
       Else
        SearchQueryString = SearchQueryString & " and ItemFeatures8 like '%" & artistpart(nnn) & "%'"
       End If
      Next
      SearchQueryString = SearchQueryString & ")"
      For nnn = 1 To numberofartistparts
       If nnn = 1 Then
        SearchQueryString = SearchQueryString & " or (ItemFeatures9 like '%" & artistpart(nnn) & "%'"
       Else
        SearchQueryString = SearchQueryString & " and ItemFeatures9 like '%" & artistpart(nnn) & "%'"
       End If
      Next
      SearchQueryString = SearchQueryString & ")"
      For nnn = 1 To numberofartistparts
       If nnn = 1 Then
        SearchQueryString = SearchQueryString & " or (ItemFeatures10 like '%" & artistpart(nnn) & "%'"
       Else
        SearchQueryString = SearchQueryString & " and ItemFeatures10 like '%" & artistpart(nnn) & "%'"
       End If
      Next
      SearchQueryString = SearchQueryString & ")"
      For nnn = 1 To numberofartistparts
       If nnn = 1 Then
        SearchQueryString = SearchQueryString & " or (RhythmName like '%" & artistpart(nnn) & "%'"
       Else
        SearchQueryString = SearchQueryString & " and RhythmName like '%" & artistpart(nnn) & "%'"
       End If
      Next
      SearchQueryString = SearchQueryString & ")"

      SearchQueryString = SearchQueryString & ")"
      AndOrWhere = "and"
      ArtistTitlePrintout = searchartist
      NoSearchCriteria = "no"
     End If
    End If

   End If
  End If
  If searchFormat <> "" Then ' format
   If UCase(searchFormat) = "SLV" Then
    SearchQueryString = SearchQueryString & " " & AndOrWhere & " (ArtistTitle like 'Sleeves%')"
    AndOrWhere = "and"
    FormatPrintout = "Sleeves"
   ElseIf searchFormat = "Vinyl" Then
    SearchQueryString = SearchQueryString & " " & AndOrWhere & " (Inventory.Format like '12%' or Inventory.Format='LP' or Inventory.Format like '7%' or Inventory.Format like '10%')"
    AndOrWhere = "and"
    FormatPrintout = Format
   ElseIf searchFormat = "ADP" Then
    SearchQueryString = SearchQueryString & " " & AndOrWhere & " (artisttitle like '%spindle adapter%')"
    AndOrWhere = "and"
    FormatPrintout = Format
   ElseIf searchFormat = "SLM" Then
    SearchQueryString = SearchQueryString & " " & AndOrWhere & " (artisttitle like '%slipmat%')"
    AndOrWhere = "and"
    FormatPrintout = Format
   ElseIf searchFormat = "RB" Then
    SearchQueryString = SearchQueryString & " " & AndOrWhere & " (Inventory.Format like 'ADP' or Inventory.Format like 'BAG' or Inventory.Format like 'SLV' or Inventory.Format like 'JKT' or Inventory.ArtistTitle like '%Record Bag%')"
    AndOrWhere = "and"
    FormatPrintout = Format
   ElseIf searchFormat = "DVD & VHS" Then
    SearchQueryString = SearchQueryString & " " & AndOrWhere & " (Inventory.Format like 'DVD' or Inventory.Format like 'VHS')"
    AndOrWhere = "and"
    FormatPrintout = Format
   ElseIf searchFormat = "PH" Then
    SearchQueryString = SearchQueryString & " " & AndOrWhere & " (Inventory.Format like 'PH')"
    AndOrWhere = "and"
    FormatPrintout = Format
   ElseIf searchFormat = "SHIRTS" Then
    SearchQueryString = SearchQueryString & " " & AndOrWhere & " (Inventory.Format like 'S')"
    AndOrWhere = "and"
    FormatPrintout = Format
   ElseIf searchFormat = "CS" Then
    SearchQueryString = SearchQueryString & " " & AndOrWhere & " (Inventory.Format like 'CS')"
    AndOrWhere = "and"
    FormatPrintout = Format
   Else
    SearchQueryString = SearchQueryString & " " & AndOrWhere & " Inventory.Format like '" & searchFormat & "%'"
    AndOrWhere = "and"
    FormatPrintout = Format
   End If
   NoSearchCriteria = "no"
  End If
  If SearchRecentDate <> "" Then ' Recent Date 
   If varUsedSearch = 1 Then
    SearchQueryString = SearchQueryString & " " & AndOrWhere & " DateAdded>='" & SearchRecentDate & "'"
    AndOrWhere = "and"
    NoSearchCriteria = "no"
   Else
    SearchQueryString = SearchQueryString & " " & AndOrWhere & " (instockdate>='" & SearchRecentDate & "' or backinstockdate>='" & SearchRecentDate & "')"
    AndOrWhere = "and"
    NoSearchCriteria = "no"
   End If
  End If
  If SearchLabel <> "" Then ' label 
   If varLabelExact = "" Or UCase(SearchLabel) = "HEARTBEAT" Or UCase(SearchLabel) = "HEART BEAT" Or UCase(SearchLabel) = "TROJAN" Then
    SearchQueryString = SearchQueryString & " " & AndOrWhere & " (Label like '%" & Trim(SearchLabel) & "%')"
   Else
    SearchQueryString = SearchQueryString & " " & AndOrWhere & " Label like '" & Trim(SearchLabel) & "'"
   End If
   AndOrWhere = "and"
   NoSearchCriteria = "no"
  End If
  If varSelectedAYear = 1 Then ' Year
   SearchQueryString = SearchQueryString & " " & AndOrWhere & " ((YearFrom >= " & SearchYearFrom & " and YearFrom <= " & SearchYearTo & ") or (YearTo >= " & SearchYearFrom & " and YearTo <= " & SearchYearTo & "))"
   AndOrWhere = "and"
   NoSearchCriteria = "no"
  End If
  If varSelectedAPrice = 1 Then ' PriceFrom and PriceTo
   If Session("PriceGroup") = "" Or Session("PriceGroup") = "RetailPrice" Then
    SearchQueryString = SearchQueryString & " " & AndOrWhere & " (case when Sale_RetailPrice is not null and dateadd(dd,0,datediff(dd,0,Sale_RetailEndDate))>=dateadd(dd,0,datediff(dd,0,getdate())) then Sale_RetailPrice else RetailPrice  end) >= " & CStr(SearchPriceFrom) _
     & " and (case when Sale_RetailPrice is not null and dateadd(dd,0,datediff(dd,0,Sale_RetailEndDate))>=dateadd(dd,0,datediff(dd,0,getdate())) then Sale_RetailPrice else RetailPrice  end) <= " & CStr(SearchPriceTo)
   ElseIf Session("PriceGroup") = "StorePrice" Then
    SearchQueryString = SearchQueryString & " " & AndOrWhere & " (case when Sale_WholesalePrice is not null and dateadd(dd,0,datediff(dd,0,Sale_WholesaleEndDate))>=dateadd(dd,0,datediff(dd,0,getdate())) then Sale_WholesalePrice else StorePrice  end) >= " & CStr(SearchPriceFrom) _
     & " and (case when Sale_WholesalePrice is not null and dateadd(dd,0,datediff(dd,0,Sale_WholesaleEndDate))>=dateadd(dd,0,datediff(dd,0,getdate())) then Sale_WholesalePrice else StorePrice  end) <= " & CStr(SearchPriceTo)
   ElseIf Session("PriceGroup") = "ExportPrice" Then
    SearchQueryString = SearchQueryString & " " & AndOrWhere & " (case when Sale_WholesalePrice is not null and dateadd(dd,0,datediff(dd,0,Sale_WholesaleEndDate))>=dateadd(dd,0,datediff(dd,0,getdate())) then Sale_WholesalePrice else ExportPrice  end) >= " & CStr(SearchPriceFrom) _
     & " and (case when Sale_WholesalePrice is not null and dateadd(dd,0,datediff(dd,0,Sale_WholesaleEndDate))>=dateadd(dd,0,datediff(dd,0,getdate())) then Sale_WholesalePrice else ExportPrice  end) <= " & CStr(SearchPriceTo)
   End If
   AndOrWhere = "and"
   NoSearchCriteria = "no"
  End If
  varGenreSQL = ""
  If SearchGenre <> "" Then ' Genre 
   varSearchGenreFixed = Replace(SearchGenre, " ", "%")
   varSearchGenreFixed = Replace(varSearchGenreFixed, "-", "%")
   varSearchGenreFixed = Replace(varSearchGenreFixed, "/", "%")
   varReggaeOrNonReggaeSQL = ""
   SearchQueryString = SearchQueryString & " " & AndOrWhere & " (Genre1 like '" & Trim(varSearchGenreFixed) & "'" _
    & " or Genre2 like '" & Trim(varSearchGenreFixed) & "'" _
    & " or Genre3 like '" & Trim(varSearchGenreFixed) & "'" _
    & " or Genre4 like '" & Trim(varSearchGenreFixed) & "'" _
    & " or Genre5 like '" & Trim(varSearchGenreFixed) & "'" _
    & " or Genre6 like '" & Trim(varSearchGenreFixed) & "'" _
    & " or Genre7 like '" & Trim(varSearchGenreFixed) & "'" _
    & " or Genre8 like '" & Trim(varSearchGenreFixed) & "'" _
    & " or Genre9 like '" & Trim(varSearchGenreFixed) & "')"
   AndOrWhere = "and"
   NoSearchCriteria = "no"
  End If
  ' show Inventory, show Deleted, NeworUsed, ReggaeOrNonReggae, StreetDate
  SearchQueryString = SearchQueryString & " and inventory" & varIText & " and deleted " & varSDText & " and ShowOnWebsite " & varShowText & varNewOrUsedText & varReggaeOrNonReggaeSQL & varStreetDateText
  ' Sort By
  varAllowSortOrders = 1
  If Len(varSortOrder) = 0 And varDateOnlySort = 0 Then
   SearchQueryString = SearchQueryString & " order by [formatorder], [UsedItem], [ArtistTitle]"
  Else
   SearchQueryString = SearchQueryString & varSortOrderString
  End If
  ' special All queries 
 ElseIf varQueryType = "AllArtist" Or Request.QueryString("artist") <> "" Then
  If Len(varAllArtistName) >= 5 Then
  End If
  If Len(varAllArtistName) >= 6 Then
  End If
  If Request.QueryString("i") = "1" Then
   varSearchTypeDescription = "All By This Artist From ItemDetails Page"
  Else
   varSearchTypeDescription = "All By This Artist"
  End If
  SearchQueryString = "select * from inventory" _
   & " inner join WebArtists on Inventory.ID=WebArtists.InventoryID" _
   & " where webartists.artist='" & varAllArtistName & "'" _
   & " and inventory" & varIText & " and deleted " & varSDText & " and ShowOnWebsite " & varShowText & varNewOrUsedText & varStreetDateText _
   & varSortOrderString
  varYouSearchedForArtist = varAllArtistName
  varAllowSortOrders = 1
 ElseIf varQueryType = "genre-new-arrival-lps" Then
  varSearchTypeDescription = "genre-new-arrival-lps (" & varAllArtistName & ")"
  SearchQueryString = "select * from inventory" _
  & " where Format='LP'" _
  & " and (Genre1='" & varAllArtistName & "' or Genre2='" & varAllArtistName & "' or Genre3='" & varAllArtistName & "' or Genre4='" & varAllArtistName & "' or Genre5='" & varAllArtistName & "' or Genre6='" & varAllArtistName & "' or Genre7='" & varAllArtistName & "' or Genre8='" & varAllArtistName & "' or Genre9='" & varAllArtistName & "')" _
  & " and inventory>0 and deleted='n' and ShowOnWebsite='y' and (UsedItem is null or UsedItem='n')" _
  & varReggaeOrNonReggaeSQL _
  & varSortOrderString
  varYouSearchedForArtist = UCase(varAllArtistName) & " - New Arrival LPs"
  varAllowSortOrders = 1
 ElseIf varQueryType = "genre-new-arrival-cds" Then
  varSearchTypeDescription = "genre-new-arrival-cds (" & varAllArtistName & ")"
  SearchQueryString = "select * from inventory" _
   & " where Format='CD'" _
   & " and (Genre1='" & varAllArtistName & "' or Genre2='" & varAllArtistName & "' or Genre3='" & varAllArtistName & "' or Genre4='" & varAllArtistName & "' or Genre5='" & varAllArtistName & "' or Genre6='" & varAllArtistName & "' or Genre7='" & varAllArtistName & "' or Genre8='" & varAllArtistName & "' or Genre9='" & varAllArtistName & "')" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y' and (UsedItem is null or UsedItem='n')" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varYouSearchedForArtist = UCase(varAllArtistName) & " - New Arrival CDs"
  varAllowSortOrders = 1
 ElseIf varQueryType = "genre-new-arrival-12s-10s" Then
  varSearchTypeDescription = "genre-new-arrival-12s-10s (" & varAllArtistName & ")"
  SearchQueryString = "select * from inventory" _
   & " where (Format='12""' or Format='10""')" _
   & " and (Genre1='" & varAllArtistName & "' or Genre2='" & varAllArtistName & "' or Genre3='" & varAllArtistName & "' or Genre4='" & varAllArtistName & "' or Genre5='" & varAllArtistName & "' or Genre6='" & varAllArtistName & "' or Genre7='" & varAllArtistName & "' or Genre8='" & varAllArtistName & "' or Genre9='" & varAllArtistName & "')" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y' and (UsedItem is null or UsedItem='n')" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varYouSearchedForArtist = UCase(varAllArtistName) & " - New Arrival 12 inch/10 inch"
  varAllowSortOrders = 1
 ElseIf varQueryType = "genre-new-arrival-7s" Then
  varSearchTypeDescription = "genre-new-arrival-7s (" & varAllArtistName & ")"
  SearchQueryString = "select * from inventory" _
   & " where (Format='7""')" _
   & " and (Genre1='" & varAllArtistName & "' or Genre2='" & varAllArtistName & "' or Genre3='" & varAllArtistName & "' or Genre4='" & varAllArtistName & "' or Genre5='" & varAllArtistName & "' or Genre6='" & varAllArtistName & "' or Genre7='" & varAllArtistName & "' or Genre8='" & varAllArtistName & "' or Genre9='" & varAllArtistName & "')" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y' and (UsedItem is null or UsedItem='n')" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varYouSearchedForArtist = UCase(varAllArtistName) & " - New Arrival 7 inch"
  varAllowSortOrders = 1
 ElseIf varQueryType = "genre-best-selling-lps" Then
  varSearchTypeDescription = "genre-best-selling-lps (" & varAllArtistName & ")"
  SearchQueryString = "select * from inventory" _
   & " where Format='LP'" _
   & " and (Genre1='" & varAllArtistName & "' or Genre2='" & varAllArtistName & "' or Genre3='" & varAllArtistName & "' or Genre4='" & varAllArtistName & "' or Genre5='" & varAllArtistName & "' or Genre6='" & varAllArtistName & "' or Genre7='" & varAllArtistName & "' or Genre8='" & varAllArtistName & "' or Genre9='" & varAllArtistName & "')" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y' and (UsedItem is null or UsedItem='n')" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varYouSearchedForArtist = UCase(varAllArtistName) & " - Best Selling LPs"
  varAllowSortOrders = 1
 ElseIf varQueryType = "genre-best-selling-cds" Then
  varSearchTypeDescription = "genre-best-selling-cds (" & varAllArtistName & ")"
  SearchQueryString = "select * from inventory" _
   & " where Format='CD'" _
   & " and (Genre1='" & varAllArtistName & "' or Genre2='" & varAllArtistName & "' or Genre3='" & varAllArtistName & "' or Genre4='" & varAllArtistName & "' or Genre5='" & varAllArtistName & "' or Genre6='" & varAllArtistName & "' or Genre7='" & varAllArtistName & "' or Genre8='" & varAllArtistName & "' or Genre9='" & varAllArtistName & "')" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y' and (UsedItem is null or UsedItem='n')" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varYouSearchedForArtist = UCase(varAllArtistName) & " - Best Selling CDs"
  varAllowSortOrders = 1
 ElseIf varQueryType = "genre-best-selling-12s-10s" Then
  varSearchTypeDescription = "genre-best-selling-12s-10s (" & varAllArtistName & ")"
  SearchQueryString = "select * from inventory" _
   & " where (Format='12""' or Format='10""')" _
   & " and (Genre1='" & varAllArtistName & "' or Genre2='" & varAllArtistName & "' or Genre3='" & varAllArtistName & "' or Genre4='" & varAllArtistName & "' or Genre5='" & varAllArtistName & "' or Genre6='" & varAllArtistName & "' or Genre7='" & varAllArtistName & "' or Genre8='" & varAllArtistName & "' or Genre9='" & varAllArtistName & "')" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y' and (UsedItem is null or UsedItem='n')" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varYouSearchedForArtist = UCase(varAllArtistName) & " - Best Selling 12 Inch/10 Inch"
  varAllowSortOrders = 1
 ElseIf varQueryType = "genre-best-selling-7s" Then
  varSearchTypeDescription = "genre-best-selling-7s (" & varAllArtistName & ")"
  SearchQueryString = "select * from inventory" _
   & " where Format='7""'" _
   & " and (Genre1='" & varAllArtistName & "' or Genre2='" & varAllArtistName & "' or Genre3='" & varAllArtistName & "' or Genre4='" & varAllArtistName & "' or Genre5='" & varAllArtistName & "' or Genre6='" & varAllArtistName & "' or Genre7='" & varAllArtistName & "' or Genre8='" & varAllArtistName & "' or Genre9='" & varAllArtistName & "')" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y' and (UsedItem is null or UsedItem='n')" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varYouSearchedForArtist = UCase(varAllArtistName) & " - Best Selling 7s"
  varAllowSortOrders = 1
 ElseIf varQueryType = "genre-essential-pick-LPs" Then
  varSearchTypeDescription = "genre-essential-pick-LPs (" & varAllArtistName & ")"
  SearchQueryString = "select * from inventory" _
   & " where (Genre1='" & varAllArtistName & "' or Genre2='" & varAllArtistName & "' or Genre3='" & varAllArtistName & "' or Genre4='" & varAllArtistName & "' or Genre5='" & varAllArtistName & "' or Genre6='" & varAllArtistName & "' or Genre7='" & varAllArtistName & "' or Genre8='" & varAllArtistName & "' or Genre9='" & varAllArtistName & "')" _
   & " and WebEssential='y'" _
   & " and Format='LP'" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y'" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = UCase(varAllArtistName) & " - Essential Pick LPs"
 ElseIf varQueryType = "genre-essential-pick-CDs" Then
  varSearchTypeDescription = "genre-essential-pick-CDs (" & varAllArtistName & ")"
  SearchQueryString = "select * from inventory" _
   & " where (Genre1='" & varAllArtistName & "' or Genre2='" & varAllArtistName & "' or Genre3='" & varAllArtistName & "' or Genre4='" & varAllArtistName & "' or Genre5='" & varAllArtistName & "' or Genre6='" & varAllArtistName & "' or Genre7='" & varAllArtistName & "' or Genre8='" & varAllArtistName & "' or Genre9='" & varAllArtistName & "')" _
   & " and WebEssential='y'" _
   & " and Format='CD'" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y'" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = UCase(varAllArtistName) & " - Essential Pick CDs"
 ElseIf varQueryType = "genre-essential-pick-12s-10s" Then
  varSearchTypeDescription = "genre-essential-pick-12s-10s (" & varAllArtistName & ")"
  SearchQueryString = "select * from inventory" _
   & " where (Genre1='" & varAllArtistName & "' or Genre2='" & varAllArtistName & "' or Genre3='" & varAllArtistName & "' or Genre4='" & varAllArtistName & "' or Genre5='" & varAllArtistName & "' or Genre6='" & varAllArtistName & "' or Genre7='" & varAllArtistName & "' or Genre8='" & varAllArtistName & "' or Genre9='" & varAllArtistName & "')" _
   & " and WebEssential='y'" _
   & " and (Format='12""' or Format='10""')" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y'" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = UCase(varAllArtistName) & " - Essential Pick 12 Inch/10 Inch"
 ElseIf varQueryType = "genre-essential-pick-7s" Then
  varSearchTypeDescription = "genre-essential-pick-7s (" & varAllArtistName & ")"
  SearchQueryString = "select * from inventory" _
   & " where (Genre1='" & varAllArtistName & "' or Genre2='" & varAllArtistName & "' or Genre3='" & varAllArtistName & "' or Genre4='" & varAllArtistName & "' or Genre5='" & varAllArtistName & "' or Genre6='" & varAllArtistName & "' or Genre7='" & varAllArtistName & "' or Genre8='" & varAllArtistName & "' or Genre9='" & varAllArtistName & "')" _
   & " and WebEssential='y'" _
   & " and Format='7""'" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y'" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = UCase(varAllArtistName) & " - Essential Pick 7 Inch"
 ElseIf varQueryType = "genre-view-all-items" Then
  varSearchTypeDescription = "genre-view-all-items (" & varAllArtistName & ")"
  SearchQueryString = "select * from inventory" _
   & " where (Genre1='" & varAllArtistName & "' or Genre2='" & varAllArtistName & "' or Genre3='" & varAllArtistName & "' or Genre4='" & varAllArtistName & "' or Genre5='" & varAllArtistName & "' or Genre6='" & varAllArtistName & "' or Genre7='" & varAllArtistName & "' or Genre8='" & varAllArtistName & "' or Genre9='" & varAllArtistName & "')" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y'" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = UCase(varAllArtistName) & " - All Items"
 ElseIf varQueryType = "genre-view-all-LPs" Then
  varSearchTypeDescription = "genre-view-all-LPs (" & varAllArtistName & ")"
  SearchQueryString = "select * from inventory" _
   & " where (Genre1='" & varAllArtistName & "' or Genre2='" & varAllArtistName & "' or Genre3='" & varAllArtistName & "' or Genre4='" & varAllArtistName & "' or Genre5='" & varAllArtistName & "' or Genre6='" & varAllArtistName & "' or Genre7='" & varAllArtistName & "' or Genre8='" & varAllArtistName & "' or Genre9='" & varAllArtistName & "')" _
   & " and Format='LP'" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y'" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = UCase(varAllArtistName) & " - LPs"
 ElseIf varQueryType = "genre-view-all-CDs" Then
  varSearchTypeDescription = "genre-view-all-CDs (" & varAllArtistName & ")"
  SearchQueryString = "select * from inventory" _
   & " where (Genre1='" & varAllArtistName & "' or Genre2='" & varAllArtistName & "' or Genre3='" & varAllArtistName & "' or Genre4='" & varAllArtistName & "' or Genre5='" & varAllArtistName & "' or Genre6='" & varAllArtistName & "' or Genre7='" & varAllArtistName & "' or Genre8='" & varAllArtistName & "' or Genre9='" & varAllArtistName & "')" _
   & " and Format='CD'" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y'" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = UCase(varAllArtistName) & " - CDs"
 ElseIf varQueryType = "genre-view-all-12s-10s" Then
  varSearchTypeDescription = "genre-view-all-12s-10s (" & varAllArtistName & ")"
  SearchQueryString = "select * from inventory" _
   & " where (Genre1='" & varAllArtistName & "' or Genre2='" & varAllArtistName & "' or Genre3='" & varAllArtistName & "' or Genre4='" & varAllArtistName & "' or Genre5='" & varAllArtistName & "' or Genre6='" & varAllArtistName & "' or Genre7='" & varAllArtistName & "' or Genre8='" & varAllArtistName & "' or Genre9='" & varAllArtistName & "')" _
   & " and (Format='12""' or Format='10""')" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y'" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = UCase(varAllArtistName) & " - 12 Inch/10 Inch"
 ElseIf varQueryType = "genre-view-all-7s" Then
  varSearchTypeDescription = "genre-view-all-7s (" & varAllArtistName & ")"
  SearchQueryString = "select * from inventory" _
   & " where (Genre1='" & varAllArtistName & "' or Genre2='" & varAllArtistName & "' or Genre3='" & varAllArtistName & "' or Genre4='" & varAllArtistName & "' or Genre5='" & varAllArtistName & "' or Genre6='" & varAllArtistName & "' or Genre7='" & varAllArtistName & "' or Genre8='" & varAllArtistName & "' or Genre9='" & varAllArtistName & "')" _
   & " and Format='7""'" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y'" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = UCase(varAllArtistName) & " - 7 Inch"
 ElseIf varQueryType = "genre-180-gram-vinyl" Then
  varSearchTypeDescription = "genre-180-gram-vinyl (" & varAllArtistName & ")"
  SearchQueryString = "select * from inventory" _
   & " where (Genre1='" & varAllArtistName & "' or Genre2='" & varAllArtistName & "' or Genre3='" & varAllArtistName & "' or Genre4='" & varAllArtistName & "' or Genre5='" & varAllArtistName & "' or Genre6='" & varAllArtistName & "' or Genre7='" & varAllArtistName & "' or Genre8='" & varAllArtistName & "' or Genre9='" & varAllArtistName & "')" _
   & " and (ItemFeatures1 like '%180 Gram%' or ItemFeatures1 like '%180-Gram%' or ItemFeatures2 like '%180 Gram%' or ItemFeatures2 like '%180-Gram%' or ItemFeatures3 like '%180 Gram%' or ItemFeatures3 like '%180-Gram%' or ItemFeatures4 like '%180 Gram%' or ItemFeatures4 like '%180-Gram%' or ItemFeatures5 like '%180 Gram%' or ItemFeatures5 like '%180-Gram%' or ItemFeatures6 like '%180 Gram%' or ItemFeatures6 like '%180-Gram%' or ItemFeatures7 like '%180 Gram%' or ItemFeatures7 like '%180-Gram%' or ItemFeatures8 like '%180 Gram%' or ItemFeatures8 like '%180-Gram%' or ItemFeatures9 like '%180 Gram%' or ItemFeatures9 like '%180-Gram%' or ItemFeatures10 like '%180 Gram%' or ItemFeatures10 like '%180-Gram%' or ArtistTitle like '%180 Gram%' or ArtistTitle like '%180-Gram%')" _
   & " and (Format='LP' or Format='12""' or Format='10""' or Format='7""')" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y'" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = UCase(varAllArtistName) & " - 180 Gram Vinyl"
 ElseIf varQueryType = "genre-colored-vinyl" Then
  varSearchTypeDescription = "genre-colored-vinyl (" & varAllArtistName & ")"
  SearchQueryString = "select * from inventory" _
   & " where (Genre1='" & varAllArtistName & "' or Genre2='" & varAllArtistName & "' or Genre3='" & varAllArtistName & "' or Genre4='" & varAllArtistName & "' or Genre5='" & varAllArtistName & "' or Genre6='" & varAllArtistName & "' or Genre7='" & varAllArtistName & "' or Genre8='" & varAllArtistName & "' or Genre9='" & varAllArtistName & "')" _
   & " and (ItemFeatures1 like '%Colored Vinyl%' or ItemFeatures2 like '%Colored Vinyl%' or ItemFeatures3 like '%Colored Vinyl%' or ItemFeatures4 like '%Colored Vinyl%' or ItemFeatures5 like '%Colored Vinyl%' or ItemFeatures6 like '%Colored Vinyl%' or ItemFeatures7 like '%Colored Vinyl%' or ItemFeatures8 like '%Colored Vinyl%' or ItemFeatures9 like '%Colored Vinyl%' or ItemFeatures10 like '%Colored Vinyl%' or ArtistTitle like '%Colored Vinyl%')" _
   & " and (Format='LP' or Format='12""' or Format='10""' or Format='7""')" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y'" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = UCase(varAllArtistName) & " - Colored Vinyl"
 ElseIf varQueryType = "genre-limited-edition-vinyl" Then
  varSearchTypeDescription = "genre-limited-edition-vinyl (" & varAllArtistName & ")"
  SearchQueryString = "select * from inventory" _
   & " where (Genre1='" & varAllArtistName & "' or Genre2='" & varAllArtistName & "' or Genre3='" & varAllArtistName & "' or Genre4='" & varAllArtistName & "' or Genre5='" & varAllArtistName & "' or Genre6='" & varAllArtistName & "' or Genre7='" & varAllArtistName & "' or Genre8='" & varAllArtistName & "' or Genre9='" & varAllArtistName & "')" _
   & " and (ItemFeatures1 like '%Limited Edition%' or ItemFeatures2 like '%Limited Edition%' or ItemFeatures3 like '%Limited Edition%' or ItemFeatures4 like '%Limited Edition%' or ItemFeatures5 like '%Limited Edition%' or ItemFeatures6 like '%Limited Edition%' or ItemFeatures7 like '%Limited Edition%' or ItemFeatures8 like '%Limited Edition%' or ItemFeatures9 like '%Limited Edition%' or ItemFeatures10 like '%Limited Edition%' or ArtistTitle like '%Limited Edition%')" _
   & " and (Format='LP' or Format='12""' or Format='10""' or Format='7""')" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y'" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = UCase(varAllArtistName) & " - Limited Edition Vinyl"
 ElseIf varQueryType = "genre-lps-under-15" Then
  varSearchTypeDescription = "genre-lps-under-15 (" & varAllArtistName & ")"
  SearchQueryString = "select * from inventory" _
   & " where (Genre1='" & varAllArtistName & "' or Genre2='" & varAllArtistName & "' or Genre3='" & varAllArtistName & "' or Genre4='" & varAllArtistName & "' or Genre5='" & varAllArtistName & "' or Genre6='" & varAllArtistName & "' or Genre7='" & varAllArtistName & "' or Genre8='" & varAllArtistName & "' or Genre9='" & varAllArtistName & "')" _
   & " and Format='LP'" _
   & " and " & varPriceGroup & "<=14.99" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y'" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = UCase(varAllArtistName) & " - LPs $14.99 or Less"
 ElseIf varQueryType = "genre-cds-under-5" Then
  varSearchTypeDescription = "genre-cds-under-5 (" & varAllArtistName & ")"
  SearchQueryString = "select * from inventory" _
   & " where (Genre1='" & varAllArtistName & "' or Genre2='" & varAllArtistName & "' or Genre3='" & varAllArtistName & "' or Genre4='" & varAllArtistName & "' or Genre5='" & varAllArtistName & "' or Genre6='" & varAllArtistName & "' or Genre7='" & varAllArtistName & "' or Genre8='" & varAllArtistName & "' or Genre9='" & varAllArtistName & "')" _
   & " and Format='CD'" _
   & " and " & varPriceGroup & "<=4.99" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y'" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = UCase(varAllArtistName) & " - CDs Under $5"
 ElseIf varQueryType = "genre-used-7s" Then
  varSearchTypeDescription = "genre-used-7s (" & varAllArtistName & ")"
  SearchQueryString = "select * from inventory" _
   & " where (Genre1='" & varAllArtistName & "' or Genre2='" & varAllArtistName & "' or Genre3='" & varAllArtistName & "' or Genre4='" & varAllArtistName & "' or Genre5='" & varAllArtistName & "' or Genre6='" & varAllArtistName & "' or Genre7='" & varAllArtistName & "' or Genre8='" & varAllArtistName & "' or Genre9='" & varAllArtistName & "')" _
   & " and Format='7""'" _
   & " and UsedItem='y'" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y'" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = UCase(varAllArtistName) & " - Used 7 Inch"
 ElseIf varQueryType = "AllArtistGenreArtists" Then
  If InStr(UCase(varAllArtistName), "XXVARIOUS") > 0 Then
   varVariousGenre = Trim(Left(varAllArtistName, InStr(UCase(varAllArtistName), "XXVARIOUS") - 1))
   varAllArtistName = "Various"
   varSearchTypeDescription = "genre-all-artist (" & varVariousGenre & " - " & varAllArtistName & ")"
   SearchQueryString = "Select * from inventory" _
    & " inner join WebArtists On Inventory.ID=WebArtists.InventoryID" _
    & " where webartists.artist='" & varAllArtistName & "'" _
    & " and (Genre1='" & varVariousGenre & "' or Genre2='" & varVariousGenre & "' or Genre3='" & varVariousGenre & "' or Genre4='" & varVariousGenre & "' or Genre5='" & varVariousGenre & "' or Genre6='" & varVariousGenre & "' or Genre7='" & varVariousGenre & "' or Genre8='" & varVariousGenre & "' or Genre9='" & varVariousGenre & "')" _
    & " and inventory" & varIText & " and deleted " & varSDText & " and ShowOnWebsite " & varShowText & varNewOrUsedText & varStreetDateText _
    & varSortOrderString
   varYouSearchedForArtist = UCase(varVariousGenre) & " - " & varAllArtistName
  Else
   varSearchTypeDescription = "genre-all-artist (" & varAllArtistName & ")"
   SearchQueryString = "Select * from inventory" _
    & " inner join WebArtists On Inventory.ID=WebArtists.InventoryID" _
    & " where webartists.artist='" & varAllArtistName & "'" _
    & " and inventory" & varIText & " and deleted " & varSDText & " and ShowOnWebsite " & varShowText & varNewOrUsedText & varStreetDateText _
    & varSortOrderString
   varYouSearchedForArtist = varAllArtistName
  End If
  varAllowSortOrders = 1
 ElseIf varQueryType = "AllLabelGenreArtists" Then
  varSearchTypeDescription = "genre-all-label (" & varAllArtistName & ")"
  SearchQueryString = "Select * from inventory" _
   & " where label='" & varAllArtistName & "'" _
   & " and inventory" & varIText & " and deleted " & varSDText & " and ShowOnWebsite " & varShowText & varNewOrUsedText & varStreetDateText _
   & varSortOrderString
  varYouSearchedForArtist = varAllArtistName
  varAllowSortOrders = 1
 ElseIf varQueryType = "AllLabel" Or Request.QueryString("labelID") <> "" Then
  varLabelSearchID = varAllID
  If Request.QueryString("labelID") <> "" Then
   varLabelSearchID = Request.QueryString("labelID")
  End If
  If Not IsNumeric(varLabelSearchID) Then
   varLabelSearchID = 0
  End If
  If Request.QueryString("i") = "1" Then
   varSearchTypeDescription = "All On This Label From ItemDetails Page"
  Else
   varSearchTypeDescription = "All On This Label"
  End If
  Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
   SqlConnection.ClearPool(conn)
   conn.Open()
   Dim CMD_X As New SqlCommand("spGetlabelFromItemID", conn)
   CMD_X.CommandType = Data.CommandType.StoredProcedure
   CMD_X.Parameters.AddWithValue("@ID", CLng(varLabelSearchID))
   Dim readerX As SqlDataReader
   readerX = CMD_X.ExecuteReader
   If readerX.HasRows Then
    readerX.Read()
    labelnamesearch = readerX("Label")
    varAllowSortOrders = 1
    intLabelNameSearchSlash = InStr(labelnamesearch, "/")
    If intLabelNameSearchSlash > 0 Then
     strAllLabel1 = Trim(Left(labelnamesearch, intLabelNameSearchSlash - 1))
     If Len(labelnamesearch) > intLabelNameSearchSlash Then
      labelnamesearch = Trim(Right(labelnamesearch, Len(labelnamesearch) - intLabelNameSearchSlash))
      intLabelNameSearchSlash = InStr(labelnamesearch, "/")
      If intLabelNameSearchSlash > 0 Then
       strAllLabel2 = Trim(Left(labelnamesearch, intLabelNameSearchSlash - 1))
       If Len(labelnamesearch) > intLabelNameSearchSlash Then
        strAllLabel3 = Trim(Right(labelnamesearch, Len(labelnamesearch) - intLabelNameSearchSlash))
       End If
      Else
       strAllLabel2 = labelnamesearch
      End If
     End If
    Else
     strAllLabel1 = readerX("Label")
    End If
    SearchQueryString = "select * from inventory" _
     & " where (Label like '" & FixSQLText(strAllLabel1) & "' or Label like '" & FixSQLText(strAllLabel2) & "' or Label like '" & FixSQLText(strAllLabel3) & "' or Label like '" & FixSQLText(readerX("Label")) & "'" _
     & " or Label like '" & FixSQLText(strAllLabel1) & "/%' or Label like '%/" & FixSQLText(strAllLabel1) & "/%' or Label like '%/" & FixSQLText(strAllLabel1) & "'" _
     & " or Label like '" & FixSQLText(strAllLabel2) & "/%' or Label like '%/" & FixSQLText(strAllLabel2) & "/%' or Label like '%/" & FixSQLText(strAllLabel2) & "'" _
     & " or Label like '" & FixSQLText(strAllLabel3) & "/%' or Label like '%/" & FixSQLText(strAllLabel3) & "/%' or Label like '%/" & FixSQLText(strAllLabel3) & "')" _
     & " and inventory" & varIText & " and deleted " & varSDText & " and ShowOnWebsite " & varShowText & varNewOrUsedText & varStreetDateText _
     & varSortOrderString
    varYouSearchedForArtist = readerX("Label") & " Record Label"
    varAllLabelName = readerX("Label")
   Else
    varAllowSortOrders = 1
    SearchQueryString = "select * from inventory" _
     & " where Label like 'qxqxqxqxqxqxqxqxqxqx'" _
     & " and inventory" & varIText & " and deleted " & varSDText & " and ShowOnWebsite " & varShowText & varNewOrUsedText & varStreetDateText _
     & varSortOrderString
   End If
  End Using
 ElseIf varQueryType = "SimilarItems" Then
  varSimilarItemsSearchID = varAllID
  If Request.QueryString("i") = "1" Then
   varSearchTypeDescription = "Similar Items From ItemDetails Page"
  Else
   varSearchTypeDescription = "Similar Items"
  End If
  Dim strSimilarRhythm As String = "qzqzqzqz"
  Dim ns As Integer = 0
  Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
   SqlConnection.ClearPool(conn)
   conn.Open()
   Dim CMD_X As New SqlCommand("spGetInventoryItem", conn)
   CMD_X.CommandType = Data.CommandType.StoredProcedure
   CMD_X.Parameters.AddWithValue("@ID", CLng(varSimilarItemsSearchID))
   Dim readerX As SqlDataReader
   readerX = CMD_X.ExecuteReader
   If readerX.HasRows Then
    readerX.Read()
    varSimilarGenre = IsDBSomething(readerX("Genre1"), "")
    varSimilarYearFrom = IsDBSomething(readerX("YearFrom"), "")
    varSimilarYearTo = IsDBSomething(readerX("YearTo"), "")
    varAllowSortOrders = 1
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
    If IsDBSomething(readerX("RhythmName"), "") <> "" Then
     strSimilarRhythm = Replace(readerX("RhythmName"), "'", "''")
    End If
    Dim strSimilarItemsSelectFields As String = ""
    Using connS As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
     SqlConnection.ClearPool(connS)
     connS.Open()
     Dim CMD_S As New SqlCommand("Select top 1 * from Inventory order by ID desc", connS)
     CMD_S.CommandType = Data.CommandType.Text
     Dim readerS As SqlDataReader
     readerS = CMD_S.ExecuteReader
     readerS.Read()
     For ns = 0 To readerS.FieldCount - 1
      If readerS.GetName(ns).ToString = "Format" Then
       strSimilarItemsSelectFields = strSimilarItemsSelectFields & "Inventory." & readerS.GetName(ns).ToString & ","
      Else
       strSimilarItemsSelectFields = strSimilarItemsSelectFields & readerS.GetName(ns).ToString & ","
      End If
     Next ns
     strSimilarItemsSelectFields = Left(strSimilarItemsSelectFields, Len(strSimilarItemsSelectFields) - 1)
    End Using
    Dim strWebArtist1 As String = "zzz11zzzz"
    Dim strWebArtist2 As String = "zzz11zzzz"
    Dim strWebArtist3 As String = "zzz11zzzz"
    Dim strWebArtist4 As String = "zzz11zzzz"
    Dim strWebArtist5 As String = "zzz11zzzz"
    ns = 0
    Using connA As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
     SqlConnection.ClearPool(connA)
     connA.Open()
     Dim CMD_A As New SqlCommand("spGetWebArtistsForInventoryItem", connA)
     CMD_A.CommandType = Data.CommandType.StoredProcedure
     CMD_A.Parameters.AddWithValue("@InventoryID", CLng(varSimilarItemsSearchID))
     Dim readerA As SqlDataReader
     readerA = CMD_A.ExecuteReader
     If readerA.HasRows Then
      Do While readerA.Read
       ns = ns + 1
       If ns = 1 Then
        strWebArtist1 = Replace(readerA("Artist"), "'", "''")
       ElseIf ns = 2 Then
        strWebArtist2 = Replace(readerA("Artist"), "'", "''")
       ElseIf ns = 3 Then
        strWebArtist3 = Replace(readerA("Artist"), "'", "''")
       ElseIf ns = 4 Then
        strWebArtist4 = Replace(readerA("Artist"), "'", "''")
       ElseIf ns = 5 Then
        strWebArtist5 = Replace(readerA("Artist"), "'", "''")
       End If
       If ns = 5 Then Exit Do
      Loop
     End If
    End Using
    SearchQueryString = "select " & strSimilarItemsSelectFields & " from inventory" _
     & " left join WebArtists on Inventory.ID=WebArtists.InventoryID" _
     & " where (((Genre1='" & varSimilarGenre & "' or Genre2='" & varSimilarGenre & "' or Genre3='" & varSimilarGenre & "' or Genre4='" & varSimilarGenre & "' or Genre5='" & varSimilarGenre & "' or Genre6='" & varSimilarGenre & "' or Genre7='" & varSimilarGenre & "' or Genre8='" & varSimilarGenre & "' or Genre9='" & varSimilarGenre & "')" _
     & " and ((YearFrom >= " & varSimilarYearFrom & " and YearFrom <= " & varSimilarYearTo & ") or (YearTo >= " & varSimilarYearFrom & " and YearTo <= " & varSimilarYearTo & ")))" _
     & " or (WebArtists.Artist='" & strWebArtist1 & "' or WebArtists.Artist='" & strWebArtist2 & "' or WebArtists.Artist='" & strWebArtist3 & "' or WebArtists.Artist='" & strWebArtist4 & "' or WebArtists.Artist='" & strWebArtist5 & "')" _
     & " or RhythmName='" & strSimilarRhythm & "')" _
     & " and inventory" & varIText & " and deleted " & varSDText & " and ShowOnWebsite " & varShowText & varNewOrUsedText & varStreetDateText _
     & " Group By " & strSimilarItemsSelectFields _
     & varSortOrderString
   Else
    varAllowSortOrders = 1
    SearchQueryString = "select * from inventory" _
     & " where Label like 'qxqxqxqxqxqxqxqxqxqx'" _
     & " and inventory" & varIText & " and deleted " & varSDText & " and ShowOnWebsite " & varShowText & varNewOrUsedText & varStreetDateText _
     & varSortOrderString
   End If
  End Using
  varYouSearchedForArtist = "Show Similar Items"
 ElseIf varQueryType = "AllYear" Or Request.QueryString("yearID") <> "" Then
  varYearSearchID = varAllID
  If Request.QueryString("yearID") <> "" Then
   varYearSearchID = Request.QueryString("yearID")
  End If
  If Not IsNumeric(varYearSearchID) Then
   varYearSearchID = 0
  End If
  If Request.QueryString("i") = "1" Then
   varSearchTypeDescription = "All Recorded This Year From ItemDetails Page"
  Else
   varSearchTypeDescription = "All Recorded This Year"
  End If
  Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
   SqlConnection.ClearPool(conn)
   conn.Open()
   Dim CMD_X As New SqlCommand("spGetInventoryItem", conn)
   CMD_X.CommandType = Data.CommandType.StoredProcedure
   CMD_X.Parameters.AddWithValue("@ID", CLng(varYearSearchID))
   Dim readerX As SqlDataReader
   readerX = CMD_X.ExecuteReader
   If readerX.HasRows Then
    readerX.Read()
    varAllYearYearFrom = IsDBSomething(readerX("YearFrom"), "")
    varAllYearYearTo = IsDBSomething(readerX("YearTo"), "")
    If varAllYearYearTo = "" Then
     varAllYearYearTo = varAllYearYearFrom
    End If
    varAllowSortOrders = 1
    SearchQueryString = "select * from inventory" _
     & " where ((YearFrom >= " & varAllYearYearFrom & " and YearFrom <= " & varAllYearYearTo & ") or (YearTo >= " & varAllYearYearFrom & " and YearTo <= " & varAllYearYearTo & "))" _
     & " and inventory" & varIText & " and deleted " & varSDText & " and ShowOnWebsite " & varShowText & varNewOrUsedText & varStreetDateText _
     & varSortOrderString
    If varAllYearYearFrom = varAllYearYearTo Then
     varYouSearchedForArtist = "Music Recorded In " & varAllYearYearFrom
    Else
     varYouSearchedForArtist = "Music Recorded From " & varAllYearYearFrom & "-" & varAllYearYearTo
    End If
   Else
    varAllowSortOrders = 1
    SearchQueryString = "select * from inventory" _
     & " where Label like 'qxqxqxqxqxqxqxqxqxqx'" _
     & " and inventory" & varIText & " and deleted " & varSDText & " and ShowOnWebsite " & varShowText & varNewOrUsedText & varStreetDateText _
     & varSortOrderString
    varYouSearchedForArtist = "Year not found"
   End If
  End Using
 ElseIf varQueryType = "AllGenre" Then
  If Request.QueryString("i") = "1" Then
   varSearchTypeDescription = "All On This Genre From ItemDetails Page"
  Else
   varSearchTypeDescription = "All On This Genre"
  End If
  varAllGenre = Trim(fixtext(Request.QueryString("genre")))
  SearchQueryString = "select Genre1,WeightInGrams,SupplierID,Inventory.Format,UPC,rhythmname,id,artisttitle,cutout,UsedItem" _
   & ",tracksgroup,producegroup,WebEssential,WebReviewHTML,musiciangroup,storeprice,exportprice" _
   & ",retailprice,Cost,MP3FileCompleted,Deleted,Inventory,NumberOfTracks" _
   & ",Sale_RetailPrice,Sale_RetailEndDate,Sale_RetailFootnoteText,Sale_RetailItemDetailsText,Sale_WholesalePrice,Sale_WholesaleEndDate,Sale_WholesaleFootnoteText,Sale_WholesaleItemDetailsText,ItemFootnoteText" _
   & ",Label,Catalog,YearFrom,YearTo,DateAdded,ConditionJacket,ConditionVinylOrCD,ConditionNotes,ConditionText" _
   & ",ItemFeatures1,ItemFeatures2,ItemFeatures3,ItemFeatures4,ItemFeatures5,ItemFeatures6,ItemFeatures7,ItemFeatures8,ItemFeatures9,ItemFeatures10,FormatOrder,SalesLast30Days" _
   & " from inventory inner join WebGenres on Inventory.ID=WebGenres.InventoryID" _
   & " where WebGenres.Genre = '" & varAllGenre & "'" _
   & " and inventory" & varIText & " and deleted " & varSDText & " and ShowOnWebsite " & varShowText & varStreetDateText _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = varAllGenre
 ElseIf varQueryType = "AllRhythm" Then
  varSearchTypeDescription = "All On This Rhythm"
  Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
   SqlConnection.ClearPool(conn)
   conn.Open()
   Dim CMD_X As New SqlCommand("spGetInventoryItem", conn)
   CMD_X.CommandType = Data.CommandType.StoredProcedure
   CMD_X.Parameters.AddWithValue("@ID", CLng(varAllID))
   Dim readerX As SqlDataReader
   readerX = CMD_X.ExecuteReader
   If readerX.HasRows Then
    readerX.Read()
    rhythmnamesearch = fixtext(readerX("rhythmname"))
    varAllowSortOrders = 1
    SearchQueryString = "select * from inventory" _
   & " where rhythmname like '" & rhythmnamesearch & "'" _
   & " and inventory" & varIText & " and deleted " & varSDText & " and ShowOnWebsite " & varShowText & varStreetDateText _
   & varSortOrderString
    varYouSearchedForArtist = readerX("rhythmname") & " rhythm"
    varAllRhythmName = readerX("rhythmname")
   Else
    varAllowSortOrders = 1
    SearchQueryString = "select * from inventory" _
     & " where rhythmname like 'qzqzqzqzqzqz'" _
     & " and inventory" & varIText & " and deleted " & varSDText & " and ShowOnWebsite " & varShowText & varStreetDateText _
     & varSortOrderString
    varYouSearchedForArtist = ""
   End If
  End Using
  'Backorders
 ElseIf varQueryType = "Backorders" Then
  varSearchTypeDescription = "Backorders"
  varWholesaleCustomerID = Session("CustomerID")
  If Len(varWholesaleCustomerID) = 0 Or Not IsNumeric(varWholesaleCustomerID) Then varWholesaleCustomerID = 777777777
  SearchQueryString = "select inventory.*, backordersinstocknow.* from inventory" _
   & " left join backordersinstocknow on inventory.id = backordersinstocknow.backorderinventoryid" _
   & " where backordersinstocknow.customerid=" & varWholesaleCustomerID _
   & " and Inventory>0 and ShowOnWebsite='y' and deleted='n' and StreetDate<=GetDate()" _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = "Backorders In Stock Now"
  'Cart
 ElseIf varCartPage = 1 Then
  varSearchTypeDescription = "Cart"
  SearchQueryString = "select Carts.*, inventory.* from Inventory" _
  & " left join Carts on Inventory.ID = Carts.ItemID" _
  & " where Carts.CartName='" & NameOfCart & "'" _
  & " order by SaveForLater,[formatorder], [UsedItem], [ArtistTitle]"
  varYouSearchedForArtist = "CART"
  'Adjust Cart Prices for Sale Items (Lower price now than cart price)
  Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
   SqlConnection.ClearPool(conn)
   conn.Open()
   Dim CMD_X As New SqlCommand("spCartPricesSalePricesToo", conn)
   CMD_X.CommandType = Data.CommandType.StoredProcedure
   CMD_X.Parameters.AddWithValue("@NameOfCart", NameOfCart)
   Dim readerX As SqlDataReader
   readerX = CMD_X.ExecuteReader
   If readerX.HasRows Then
    Do While readerX.Read
     If varPriceGroup = "RetailPrice" Or varPriceGroup = "" Then
      If Not IsDBNull(readerX("Sale_RetailPrice")) And Not IsDBNull(readerX("Sale_RetailEndDate")) Then
       If DateDiff("d", Date.Now, readerX("Sale_RetailEndDate")) >= 0 Then
        If CDbl(readerX("Sale_RetailPrice")) < CDbl(readerX("Price")) Then
         Using conn2 As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
          SqlConnection.ClearPool(conn2)
          conn2.Open()
          Dim CMD_X2 As New SqlCommand("spGetCustomerDetails", conn2)
          CMD_X2.CommandType = Data.CommandType.StoredProcedure
          CMD_X2.Parameters.AddWithValue("@CartCounter", readerX("CartCounter"))
          CMD_X2.Parameters.AddWithValue("@Price", CDbl(readerX("Sale_RetailPrice")))
          CMD_X2.ExecuteNonQuery()
         End Using
        End If
       End If
      End If
     ElseIf varPriceGroup = "StorePrice" Or varPriceGroup = "ExportPrice" Then
      If Not IsDBNull(readerX("Sale_WholesalePrice")) And Not IsDBNull(readerX("Sale_WholesalePrice")) Then
       If DateDiff("d", Date.Now, readerX("Sale_WholesaleEndDate")) >= 0 Then
        If CDbl(readerX("Sale_WholesalePrice")) < CDbl(readerX("Price")) Then
         Using conn2 As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
          SqlConnection.ClearPool(conn2)
          conn2.Open()
          Dim CMD_X2 As New SqlCommand("spGetCustomerDetails", conn2)
          CMD_X2.CommandType = Data.CommandType.StoredProcedure
          CMD_X2.Parameters.AddWithValue("@CartCounter", readerX("CartCounter"))
          CMD_X2.Parameters.AddWithValue("@Price", CDbl(readerX("Sale_WholesalePrice")))
          CMD_X2.ExecuteNonQuery()
         End Using
        End If
       End If
      End If
     End If
    Loop
   End If
  End Using
  'Cart totals
  If varPriceGroup = "RetailPrice" Then
   varSPROCNameForCartTotals = "spGetCartTotalsRetailPrice"
  Else
   varSPROCNameForCartTotals = "spGetCartTotalsWholesalePrice"
  End If
  Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
   SqlConnection.ClearPool(conn)
   conn.Open()
   Dim CMD_X As New SqlCommand(varSPROCNameForCartTotals, conn)
   CMD_X.CommandType = Data.CommandType.StoredProcedure
   CMD_X.Parameters.AddWithValue("@CartName", NameOfCart)
   Dim readerX As SqlDataReader
   readerX = CMD_X.ExecuteReader
   If readerX.HasRows Then
    Do While readerX.Read
     varQuantityGot = readerX("Quantity")
     varPriceTotal = varQuantityGot * CDbl(readerX("PriceForCart"))
     CartTotal = CartTotal + varPriceTotal
     totalcartquantity = totalcartquantity + varQuantityGot
     If varLastFormat <> readerX("Format") Then
      varFormatRow = varFormatRow + 1
      varFormatOn(varFormatRow) = readerX("Format")
     End If
     varFormatPriceTotal(varFormatRow) = varFormatPriceTotal(varFormatRow) + varPriceTotal
     varFormatQuantityTotal(varFormatRow) = varFormatQuantityTotal(varFormatRow) + varQuantityGot
     varLastFormat = readerX("Format")
    Loop
   End If
  End Using
  'CustomerBought
 ElseIf varQueryType = "CustBought" Then
  If Not IsNumeric(Request("varCustBoughtDays")) Then
   varCustBoughtDays = "30"
  End If
  If varCustBoughtFormat = "7" Then
   varCustBoughtFormat = "7"""
  ElseIf varCustBoughtFormat = "12" Then
   varCustBoughtFormat = "12"""
  ElseIf varCustBoughtFormat = "10" Then
   varCustBoughtFormat = "10"""
  End If
  If Len(varCustBoughtFormat) > 10 Then varCustBoughtFormat = Left(varCustBoughtFormat, 10)
  varSearchTypeDescription = varCustBoughtFormat & "s - Best Sellers Last " & varCustBoughtDays & " Days That Customer Has Bought"
  SearchQueryString = "select top 500 * from inventory where ID" _
 & " in (select id from inventory" _
 & " left join InvoiceItemsForWeb on Inventory.ID=InvoiceItemsForWeb.ItemID" _
 & " inner join InvoicesForWeb on InvoiceItemsForWeb.Inv=InvoicesForWeb.invoice" _
 & " where CustomerID=" & CLng(varCustomerID) _
 & " and Inventory.Format='" & varCustBoughtFormat & "'" _
 & " and inventory" & varIText & " and deleted " & varSDText & " and ShowOnWebsite " & varShowText & varStreetDateText _
 & " group by id)" _
 & " order by SalesLast" & varCustBoughtDays & "Days desc,inventory desc"
  varYouSearchedForArtist = varCustBoughtFormat & "s - Best Sellers Last " & varCustBoughtDays & " Days That Customer HAS Bought"
  'CustomerNotBought
 ElseIf varQueryType = "CustNotBought" Then
  If Not IsNumeric(Request("varCustBoughtDays")) Then
   varCustBoughtDays = "30"
  End If
  If varCustBoughtFormat = "7" Then
   varCustBoughtFormat = "7"""
  ElseIf varCustBoughtFormat = "12" Then
   varCustBoughtFormat = "12"""
  ElseIf varCustBoughtFormat = "10" Then
   varCustBoughtFormat = "10"""
  End If
  If Len(varCustBoughtFormat) > 10 Then varCustBoughtFormat = Left(varCustBoughtFormat, 10)
  varSearchTypeDescription = varCustBoughtFormat & "s - Best Sellers Last " & varCustBoughtDays & " Days That Customer Has NOT Bought"
  SearchQueryString = "select top 500 * from inventory where ID" _
 & " not in (select id from inventory" _
 & " left join InvoiceItemsForWeb on Inventory.ID=InvoiceItemsForWeb.ItemID" _
 & " inner join InvoicesForWeb on InvoiceItemsForWeb.Inv=InvoicesForWeb.invoice" _
 & " where CustomerID=" & CLng(varCustomerID) _
 & " group by id)" _
 & " and Inventory.Format='" & varCustBoughtFormat & "'" _
 & " and inventory" & varIText & " and deleted " & varSDText & " and ShowOnWebsite " & varShowText & varStreetDateText _
 & " order by SalesLast" & varCustBoughtDays & "Days desc,inventory desc"
  varYouSearchedForArtist = varCustBoughtFormat & "s - Best Sellers Last " & varCustBoughtDays & " Days That Customer Has NOT Bought"

  ' Special Quick Queries                                  
  '                                                        

  'ID Search
 ElseIf varQueryType = "ID" Then
  varSearchTypeDescription = "ID Search"
  SearchQueryString = "select * from inventory" _
  & " where ID=" & varItemIDToSearch _
  & " and inventory" & varIText & " and deleted " & varSDText & " and ShowOnWebsite " & varShowText & varStreetDateText _
  & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = "Our Item ID " & varItemIDToSearch
  'SupplierID Search
 ElseIf varQueryType = "SupplierID" Then
  varSearchTypeDescription = "SupplierID Search"
  SearchQueryString = "select * from inventory" _
   & " where SupplierID=" & varSupplierIDToSearch _
   & " and inventory" & varIText & " and deleted " & varSDText & " and ShowOnWebsite " & varShowText & varStreetDateText _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = "SupplierID " & varSupplierIDToSearch
  'UPC Search
 ElseIf varQueryType = "UPC" Then
  varSearchTypeDescription = "UPC Search"
  SearchQueryString = "select * from inventory" _
  & " where UPC like '%" & varUPCToSearch & "%'" _
  & " and inventory" & varIText & " and deleted " & varSDText & " and ShowOnWebsite " & varShowText & varStreetDateText _
  & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = "UPC Containing " & varUPCToSearch
  'QuickSuggestion
 ElseIf varQueryType = "QuickSuggestion" Then
  If Not IsNumeric(varArtistSearchTypeCounter) Then
   varArtistSearchTypeCounter = "0"
  End If
  If varArtistSearchType = "CD" Then
   strQuickSuggestionFormatSQL = " and Inventory.Format='CD'"
   varSearchTypeDescription = "QuickCD"
   varYouSearchedForArtist = " (CD ONLY)"
  ElseIf varArtistSearchType = "Vinyl" Then
   strQuickSuggestionFormatSQL = " and (Inventory.Format='LP' or Inventory.Format='12""' or Inventory.Format='10""' or Inventory.Format='7""')"
   varSearchTypeDescription = "QuickVinyl"
   varYouSearchedForArtist = " (VINYL ONLY)"
  ElseIf varArtistSearchType = "Other" Then
   strQuickSuggestionFormatSQL = " and (Inventory.Format<>'CD' and Inventory.Format<>'LP' and Inventory.Format<>'12""' and Inventory.Format<>'10""' and Inventory.Format<>'7""')"
   varSearchTypeDescription = "QuickOther"
   varYouSearchedForArtist = " (NOT CDs, NOT VINYL)"
  Else
   strQuickSuggestionFormatSQL = ""
   varSearchTypeDescription = "QuickAll"
   varYouSearchedForArtist = ""
  End If
  Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
   SqlConnection.ClearPool(conn)
   conn.Open()
   Dim CMD_X As New SqlCommand("spGetWebSearchSuggestionRow", conn)
   CMD_X.CommandType = Data.CommandType.StoredProcedure
   CMD_X.Parameters.AddWithValue("@counter", IsDBSomething(varArtistSearchTypeCounter, 0))
   Dim readerX As SqlDataReader
   readerX = CMD_X.ExecuteReader
   If readerX.HasRows Then
    readerX.Read()
    varWebSearchSuggestionHintRaw = readerX("Hint")
    varWebSearchSuggestionHint = Replace(readerX("Hint"), """", "'")
    varWebSearchSuggestionSearchType = Replace(readerX("SearchType"), """", "'")
   Else
    varWebSearchSuggestionHintRaw = varArtistCriteria
    varWebSearchSuggestionHint = varArtistCriteria
    varWebSearchSuggestionSearchType = "Artist"
   End If

   varWebSearchSuggestionHint = Replace(varWebSearchSuggestionHint, """", "'")
   varWebSearchSuggestionHint = Replace(varWebSearchSuggestionHint, "'", "''")
  End Using
  If UCase(varWebSearchSuggestionSearchType) = "ARTIST" Then
   varSearchTypeDescription = varSearchTypeDescription & " (" & varWebSearchSuggestionHint & ") ARTIST"
   SearchQueryString = "Select Genre1,WeightInGrams,SupplierID,Inventory.Format,UPC,rhythmname,id,artisttitle,cutout,UsedItem" _
    & ",tracksgroup,producegroup,WebEssential,WebReviewHTML,musiciangroup,storeprice,exportprice" _
    & ",retailprice,Cost,MP3FileCompleted,Deleted,Inventory,NumberOfTracks" _
    & ",Sale_RetailPrice,Sale_RetailEndDate,Sale_RetailFootnoteText,Sale_RetailItemDetailsText,Sale_WholesalePrice,Sale_WholesaleEndDate,Sale_WholesaleFootnoteText,Sale_WholesaleItemDetailsText,ItemFootnoteText" _
    & ",Label,Catalog,YearFrom,YearTo,DateAdded,ConditionJacket,ConditionVinylOrCD,ConditionNotes,ConditionText" _
    & ",ItemFeatures1,ItemFeatures2,ItemFeatures3,ItemFeatures4,ItemFeatures5,ItemFeatures6,ItemFeatures7,ItemFeatures8,ItemFeatures9,ItemFeatures10,FormatOrder,SalesLast30Days" _
    & " from inventory inner join WebArtists On Inventory.ID=WebArtists.InventoryID" _
    & " where WebArtists.Artist like '" & varWebSearchSuggestionHint & "'" _
    & strQuickSuggestionFormatSQL _
    & " and inventory" & varIText & " and deleted " & varSDText & " and ShowOnWebsite " & varShowText & varStreetDateText _
    & varSortOrderString
   varAllowSortOrders = 1
   varYouSearchedForArtist = varWebSearchSuggestionHintRaw & varYouSearchedForArtist
  ElseIf UCase(varWebSearchSuggestionSearchType) = "GENRE" Then
   varSearchTypeDescription = varSearchTypeDescription & " (" & varWebSearchSuggestionHint & ") GENRE"
   SearchQueryString = "select Genre1,WeightInGrams,SupplierID,Inventory.Format,UPC,rhythmname,id,artisttitle,cutout,UsedItem" _
    & ",tracksgroup,producegroup,WebEssential,WebReviewHTML,musiciangroup,storeprice,exportprice" _
    & ",retailprice,Cost,MP3FileCompleted,Deleted,Inventory,NumberOfTracks" _
    & ",Sale_RetailPrice,Sale_RetailEndDate,Sale_RetailFootnoteText,Sale_RetailItemDetailsText,Sale_WholesalePrice,Sale_WholesaleEndDate,Sale_WholesaleFootnoteText,Sale_WholesaleItemDetailsText,ItemFootnoteText" _
    & ",Label,Catalog,YearFrom,YearTo,DateAdded,ConditionJacket,ConditionVinylOrCD,ConditionNotes,ConditionText" _
    & ",ItemFeatures1,ItemFeatures2,ItemFeatures3,ItemFeatures4,ItemFeatures5,ItemFeatures6,ItemFeatures7,ItemFeatures8,ItemFeatures9,ItemFeatures10,FormatOrder,SalesLast30Days" _
    & " from inventory inner join WebGenres on Inventory.ID=WebGenres.InventoryID" _
    & " where WebGenres.Genre = '" & varWebSearchSuggestionHint & "'" _
    & strQuickSuggestionFormatSQL _
    & " and inventory" & varIText & " and deleted " & varSDText & " and ShowOnWebsite " & varShowText & varStreetDateText _
    & varSortOrderString
   varAllowSortOrders = 1
   varYouSearchedForArtist = varWebSearchSuggestionHintRaw & varYouSearchedForArtist
  ElseIf UCase(varWebSearchSuggestionSearchType) = "LABEL" Then
   varSearchTypeDescription = varSearchTypeDescription & " (" & varWebSearchSuggestionHint & ") LABEL"
   SearchQueryString = "select * from inventory" _
    & " where Label like '" & FixSQLText(varWebSearchSuggestionHintRaw) & "'" _
    & strQuickSuggestionFormatSQL _
    & " and inventory" & varIText & " and deleted " & varSDText & " and ShowOnWebsite " & varShowText & varStreetDateText _
    & varSortOrderString
   varAllowSortOrders = 1
   varYouSearchedForArtist = varWebSearchSuggestionHintRaw & varYouSearchedForArtist
  ElseIf UCase(varWebSearchSuggestionSearchType) = "RHYTHM" Then
   varSearchTypeDescription = varSearchTypeDescription & " (" & varWebSearchSuggestionHint & ") RHYTHM"
   SearchQueryString = "select * from inventory" _
    & " where RhythmName like '" & FixSQLText(varWebSearchSuggestionHintRaw) & "'" _
    & strQuickSuggestionFormatSQL _
    & " and inventory" & varIText & " and deleted " & varSDText & " and ShowOnWebsite " & varShowText & varStreetDateText _
    & varSortOrderString
   varAllowSortOrders = 1
   varYouSearchedForArtist = varWebSearchSuggestionHintRaw & varYouSearchedForArtist
  ElseIf UCase(varWebSearchSuggestionSearchType) = "ITEM FEATURE" Then
   varSearchTypeDescription = varSearchTypeDescription & " (" & varWebSearchSuggestionHint & ") ITEM FEATURE"
   SearchQueryString = "select Genre1,WeightInGrams,SupplierID,Inventory.Format,UPC,rhythmname,Inventory.id,artisttitle,cutout,UsedItem" _
    & ",tracksgroup,producegroup,WebEssential,WebReviewHTML,musiciangroup,storeprice,exportprice" _
    & ",retailprice,Cost,MP3FileCompleted,Deleted,Inventory,NumberOfTracks" _
    & ",Sale_RetailPrice,Sale_RetailEndDate,Sale_RetailFootnoteText,Sale_RetailItemDetailsText,Sale_WholesalePrice,Sale_WholesaleEndDate,Sale_WholesaleFootnoteText,Sale_WholesaleItemDetailsText,ItemFootnoteText" _
    & ",Label,Catalog,YearFrom,YearTo,DateAdded,ConditionJacket,ConditionVinylOrCD,ConditionNotes,ConditionText" _
    & ",ItemFeatures1,ItemFeatures2,ItemFeatures3,ItemFeatures4,ItemFeatures5,ItemFeatures6,ItemFeatures7,ItemFeatures8,ItemFeatures9,ItemFeatures10,FormatOrder,SalesLast30Days" _
    & " from inventory inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID" _
    & " inner join InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID" _
    & " where InventoryItemFeatureIndex.Hint like '" & FixSQLText(varWebSearchSuggestionHintRaw) & "'" _
    & strQuickSuggestionFormatSQL _
    & " and inventory" & varIText & " and deleted " & varSDText & " and ShowOnWebsite " & varShowText & varNewOrUsedText & varStreetDateText _
    & varSortOrderString
   varAllowSortOrders = 1
   varYouSearchedForArtist = varWebSearchSuggestionHintRaw & varYouSearchedForArtist
  ElseIf UCase(varWebSearchSuggestionSearchType) = "ALBUM" Then
   varSearchTypeDescription = varSearchTypeDescription & " (" & Left(Replace(varWebSearchSuggestionHint, """", ""), 220) & ") ALBUM"
   SearchQueryString = "select * from inventory" _
 & " where ArtistTitle like '" & FixSQLText(varWebSearchSuggestionHintRaw) & "'" _
 & strQuickSuggestionFormatSQL _
 & " and inventory" & varIText & " and deleted " & varSDText & " and ShowOnWebsite " & varShowText & varStreetDateText _
 & varSortOrderString
   varAllowSortOrders = 1
   varYouSearchedForArtist = varWebSearchSuggestionHintRaw & varYouSearchedForArtist
  End If
  'New Arrivals
 ElseIf varQueryType = "QQNA" Then
  varDisplayLikeHomePage = 1
  'Best Sellers
 ElseIf varQueryType = "QQBS" Then
  varDisplayLikeHomePage = 1
  'Best Selling Labels
 ElseIf varQueryType = "QQBSL" Then
  varSearchTypeDescription = "Best-Selling Labels Button"
  varYouSearchedForArtist = varBSLTxt & " Record Label"
  SearchQueryString = "select * from inventory" _
  & " where Label='" & Replace(varBSLTxt, "'", "''") & "'" _
  & " and inventory" & varIText & " and deleted " & varSDText & " and ShowOnWebsite " & varShowText & varNewOrUsedText & varStreetDateText _
  & varReggaeOrNonReggaeSQL _
  & varSortOrderString
 ElseIf varQueryType = "millions" Then
  varSearchTypeDescription = "millions"
  SearchQueryString = "select * from inventory" _
  & " where SupplierID=144981" _
  & " order by id desc"
  varAllowSortOrders = 1
  varYouSearchedForArtist = "Millions of Records"
  'BroadcastList
 ElseIf varQueryType = "BroadcastList" Then
  varSearchTypeDescription = "Broadcast List " & Request.QueryString("broadcast-list")
  If Request.QueryString("from-email") <> "" Then
   varSearchTypeDescription = varSearchTypeDescription & " (from email link)"
  End If
  If Request.QueryString("from-excel") <> "" Then
   varSearchTypeDescription = varSearchTypeDescription & " (from excel link)"
  End If
  SearchQueryString = "select inventory.*,BroadcastMasterItems.counter,SectionSortOrder from inventory" _
   & " inner join BroadcastMasterItems" _
   & " on Inventory.[ID]=BroadcastMasterItems.ItemID" _
   & " where [BroadcastCounter]=" & Request.QueryString("broadcast-list") _
   & " and inventory" & varIText & " and deleted " & varSDText & " and ShowOnWebsite " & varShowText & varNewOrUsedText & varStreetDateText _
   & varReggaeOrNonReggaeSQL _
   & " order by SectionSortOrder,[formatorder],ArtistTitle"
  varAllowSortOrders = 0
  Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
   SqlConnection.ClearPool(conn)
   conn.Open()
   Dim CMD_X As New SqlCommand("spGetBroadcastListName", conn)
   CMD_X.CommandType = Data.CommandType.StoredProcedure
   CMD_X.Parameters.AddWithValue("@counter", IsDBSomething(Request.QueryString("broadcast-list"), 0))
   Dim readerX As SqlDataReader
   readerX = CMD_X.ExecuteReader
   If readerX.HasRows Then
    varBroadcastListName = readerX("BroadcastListName")
   Else
    varBroadcastListName = ""
   End If
  End Using
  varYouSearchedForArtist = varBroadcastListName
 ElseIf varQueryType = "SI" Then
  varSearchTypeDescription = "ItemID Query String Search (" & Request("ItemID") & ")"
  If Request.QueryString("from-email") <> "" Then
   varSearchTypeDescription = "ItemID from Email link"
  End If
  If Request.QueryString("from-excel") <> "" Then
   varSearchTypeDescription = "ItemID from Excel link"
  End If
  varSingleItemNotInInventoryTable = 0
  varSingleItemZeroInventory = 0
  varSingleItemFound = 0
  strSQL = "select * from inventory" _
   & " where ID =" & CLng(Request("ItemID")) _
   & " and inventory" & varIText & " and deleted " & varSDText & " and ShowOnWebsite " & varShowText & varStreetDateText _
   & " order by [UsedItem], [ArtistTitle]"
  Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
   SqlConnection.ClearPool(conn)
   conn.Open()
   Dim CMD_X As New SqlCommand(strSQL, conn)
   CMD_X.CommandType = Data.CommandType.Text
   Dim readerX As SqlDataReader
   readerX = CMD_X.ExecuteReader
   If Not readerX.HasRows Then
    varQueryType = "DefaultPage"
    varSingleItemNotInInventoryTable = 1
    varDefaultHomePage = 1
   Else
    readerX.Read()
    If readerX("inventory") = 0 Then
     varQueryType = "DefaultPage"
     varSingleItemZeroInventory = 1
     varYouSearchedForArtist = "Item# " & readerX("ID")
    Else
     varSingleItemFound = 1
     SearchQueryString = "select * from inventory" _
      & " where ID=" & CLng(Request("ItemID")) _
      & " and inventory" & varIText & " and deleted " & varSDText & " and ShowOnWebsite " & varShowText & varStreetDateText _
      & " order by [UsedItem], [ArtistTitle]"
     varYouSearchedForArtist = "Item# " & readerX("ID")
    End If
   End If
  End Using
 ElseIf varQueryType = "EMID" Then
  If varErnieMessageID = "" Then
   varErnieMessageID = "1"
  End If
  varSearchTypeDescription = "A Message From Ernie Search (Message " & varErnieMessageID & ")"
  SearchQueryString = "select * from inventory" _
   & " inner join AMessageFromErnieQueryItems on inventory.id=AMessageFromErnieQueryItems.inventoryid" _
   & " where AMessageFromErnieQueryItems.messageid=" & varErnieMessageID _
 & " and inventory>0 and deleted='n' and ShowOnWebsite='y' and (UsedItem is null or UsedItem='n')" _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = "A Message From Ernie - Message # " & varErnieMessageID
 ElseIf varQueryType = "Best-Selling-LPs" Then
  varSearchTypeDescription = "Best Selling LPs"
  SearchQueryString = "select * from inventory" _
   & " where Format= 'LP'" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y' and (UsedItem is null or UsedItem='n')" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = "Best Selling LPs"
 ElseIf varQueryType = "Best-Selling-CDs" Then
  varSearchTypeDescription = "Best Selling CDs"
  SearchQueryString = "select * from inventory" _
   & " where Format= 'CD'" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y' and (UsedItem is null or UsedItem='n')" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = "Best Selling CDs"
 ElseIf varQueryType = "Best-Selling-Supplies" Then
  varSearchTypeDescription = "Best Selling Supplies"
  SearchQueryString = "select * from inventory" _
   & " where (Format='ADP' or Format='SLV' or Format='BAG' or Format='JKT' or Inventory.ArtistTitle like '%Record Bag%')" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y' and (UsedItem is null or UsedItem='n')" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = "Best Selling Supplies"
 ElseIf varQueryType = "Rock-LPs" Then
  varSearchTypeDescription = "Rock LPs"
  SearchQueryString = "select * from inventory" _
   & " where Format='LP'" _
   & " and (Genre1='Rock' or Genre2='Rock' or Genre3='Rock' or Genre4='Rock' or Genre5='Rock' or Genre6='Rock' or Genre7='Rock' or Genre8='Rock' or Genre9='Rock')" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y'" _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = "Rock LPs"
 ElseIf varQueryType = "Best-Selling-7s" Then
  varSearchTypeDescription = "Best Selling 7 Inch"
  SearchQueryString = "select * from inventory" _
   & " where Format= '7""'" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y' and (UsedItem is null or UsedItem='n')" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = "Best Selling 7 Inch"
 ElseIf varQueryType = "Best-Selling-12s-10s" Then
  varSearchTypeDescription = "Best Selling 12 Inch/10 Inch"
  SearchQueryString = "select * from inventory" _
   & " where (Format= '12""' or Format= '10""')" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y' and (UsedItem is null or UsedItem='n')" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = "Best Selling 12 Inch/10 Inch"
 ElseIf varQueryType = "New-Release-LPs" Then
  varSearchTypeDescription = "New Arrival LPs"
  SearchQueryString = "select * from inventory" _
 & " where Format='LP'" _
 & " and inventory>0 and deleted='n' and ShowOnWebsite='y' and (UsedItem is null or UsedItem='n')" _
 & varReggaeOrNonReggaeSQL _
 & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = "New Arrival LPs"
 ElseIf varQueryType = "New-Release-CDs" Then
  varSearchTypeDescription = "New Arrival CDs"
  SearchQueryString = "select * from inventory" _
 & " where Format='CD'" _
 & " and inventory>0 and deleted='n' and ShowOnWebsite='y' and (UsedItem is null or UsedItem='n')" _
 & varReggaeOrNonReggaeSQL _
 & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = "New Arrival CDs"
 ElseIf varQueryType = "New-Release-12s-10s" Then
  varSearchTypeDescription = "New Arrival 12 Inch/10 Inch"
  SearchQueryString = "select * from inventory" _
   & " where (Format='12""' or Format='10""')" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y' and (UsedItem is null or UsedItem='n')" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = "New Arrival 12 Inch/10 Inch"
 ElseIf varQueryType = "New-Release-7s" Then
  varSearchTypeDescription = "New Arrival 7 Inch"
  SearchQueryString = "select * from inventory" _
   & " where Format='7""'" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y' and (UsedItem is null or UsedItem='n')" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = "New Arrival 7 Inch"
 ElseIf varQueryType = "Sony-Universal-Warner-LPs" Then
  varSearchTypeDescription = "Sony Universal Warner LPs"
  SearchQueryString = "select * from inventory" _
   & " where Format='LP' and SupplierID=1070" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y' and (UsedItem is null or UsedItem='n')" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = "Sony Universal Warner LPs"
 ElseIf varQueryType = "Jazz-LPs" Then
  varSearchTypeDescription = "Jazz LPs"
  SearchQueryString = "select * from inventory" _
   & " where Format='LP'" _
   & " and (Genre1='Jazz' or Genre2='Jazz' or Genre3='Jazz' or Genre4='Jazz' or Genre5='Jazz' or Genre6='Jazz' or Genre7='Jazz' or Genre8='Jazz' or Genre9='Jazz')" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y'" _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = "Jazz LPs"
 ElseIf varQueryType = "Used-Collectible-7s" Then
  varSearchTypeDescription = "Used-Collectible 7 Inch"
  SearchQueryString = "select * from inventory" _
   & " where Format='7""'" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y' and UsedItem ='y'" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = "Used-Collectible 7 Inch"
 ElseIf varQueryType = "Back-In-Stock-LPs" Then
  varSearchTypeDescription = "Back In Stock LPs"
  SearchQueryString = "select * from inventory" _
   & " where Format='LP'" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y' and (UsedItem is null or UsedItem='n')" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = "Back In Stock LPs"
 ElseIf varQueryType = "Back-In-Stock-CDs" Then
  varSearchTypeDescription = "Back In Stock CDs"
  SearchQueryString = "select * from inventory" _
   & " where Format='CD'" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y' and (UsedItem is null or UsedItem='n')" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = "Back In Stock CDs"
 ElseIf varQueryType = "Back-In-Stock-CSs" Then
  varSearchTypeDescription = "Back In Stock Cassettes"
  SearchQueryString = "select * from inventory" _
   & " where Format='CS'" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y' and (UsedItem is null or UsedItem='n')" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = "Back In Stock Cassettes"
 ElseIf varQueryType = "Back-In-Stock-7s" Then
  varSearchTypeDescription = "Back In Stock 7 Inch"
  SearchQueryString = "select * from inventory" _
   & " where Format='7""'" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y' and (UsedItem is null or UsedItem='n')" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = "Back In Stock 7 Inch"
 ElseIf varQueryType = "Back-In-Stock-12s-10s" Then
  varSearchTypeDescription = "Back In Stock 12 Inch/10 Inch"
  SearchQueryString = "select * from inventory" _
 & " where (Format='12""' or Format='10""')" _
 & " and inventory>0 and deleted='n' and ShowOnWebsite='y' and (UsedItem is null or UsedItem='n')" _
 & varReggaeOrNonReggaeSQL _
 & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = "Back In Stock 12 Inch/10 Inch"
 ElseIf varQueryType = "All-LPs" Then
  varSearchTypeDescription = "All LPs"
  SearchQueryString = "select * from inventory" _
   & " where Format='LP'" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y'" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = "All LPs"
 ElseIf varQueryType = "All-CDs" Then
  varSearchTypeDescription = "All CDs"
  SearchQueryString = "select * from inventory" _
   & " where Format='CD'" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y'" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = "All CDs"
 ElseIf varQueryType = "All-12s-10s" Then
  varSearchTypeDescription = "All 12 Inch/10 Inch"
  SearchQueryString = "select * from inventory" _
   & " where Format='12""' or Format='10""'" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y'" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = "All 12 Inch/10 Inch"
 ElseIf varQueryType = "All-7s" Then
  varSearchTypeDescription = "All 7 Inch"
  SearchQueryString = "select * from inventory" _
   & " where Format='7""'" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y'" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = "All 7 Inch"
 ElseIf varQueryType = "All-Supplies" Then
  varSearchTypeDescription = "All Supplies"
  SearchQueryString = "select * from inventory" _
   & " where (Format='ADP' or Format='SLV' or Format='BAG' or Format='JKT' or Inventory.ArtistTitle like '%Record Bag%')" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y'" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = "All Supplies"
 ElseIf varQueryType = "All-Cassettes" Then
  varSearchTypeDescription = "All Cassettes"
  SearchQueryString = "select * from inventory" _
   & " where Format='CS'" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y'" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = "All Cassettes"
 ElseIf varQueryType = "LPs-1499" Then
  varSearchTypeDescription = "LPs $14.99 or Less"
  SearchQueryString = "select * from inventory" _
   & " where Format='LP'" _
   & " and " & varPriceGroup & "<=14.99" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y'" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = "LPs $14.99 or Less"
 ElseIf varQueryType = "Ace-Records-LPs" Then
  varSearchTypeDescription = "'Ace Records' LPs"
  SearchQueryString = "select * from inventory" _
   & " where Label like '%Ace Records%' and Format='LP'" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y' and (UsedItem is null or UsedItem='n')" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = "Ace Records LPs"
 ElseIf varQueryType = "Not-Now-Music-LPs" Then
  varSearchTypeDescription = "'Not Now Music' LPs"
  SearchQueryString = "select * from inventory" _
   & " where Label like '%Not Now Music%' and Format='LP'" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y' and (UsedItem is null or UsedItem='n')" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = "Not Now Music LPs"
 ElseIf varQueryType = "VP-Greensleeves-LPs" Then
  varSearchTypeDescription = "'VP/Greensleeves' LPs"
  SearchQueryString = "select * from inventory" _
   & " where (Label like '%VP%' or Label like '%Greensleeves%') and Format='LP'" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y' and (UsedItem is null or UsedItem='n')" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = "VP/Greensleeves LPs"
 ElseIf varQueryType = "Ace-Records-CDs" Then
  varSearchTypeDescription = "'Ace Records' CDs"
  SearchQueryString = "select * from inventory" _
   & " where Label like '%Ace Records%' and Format='CD'" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y' and (UsedItem is null or UsedItem='n')" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = "Ace Records CDs"
 ElseIf varQueryType = "Not-Now-Music-CDs" Then
  varSearchTypeDescription = "'Not Now Music' CDs"
  SearchQueryString = "select * from inventory" _
   & " where Label like '%Not Now Music%' and Format='CD'" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y' and (UsedItem is null or UsedItem='n')" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = "Not Now Music CDs"
 ElseIf varQueryType = "All-Reggae-LPs" Then
  varSearchTypeDescription = "All Reggae LPs"
  SearchQueryString = "select * from inventory" _
   & " where Format='LP'" _
   & " and (Genre1='Reggae' or Genre2='Reggae' or Genre3='Reggae' or Genre4='Reggae' or Genre5='Reggae' or Genre6='Reggae' or Genre7='Reggae' or Genre8='Reggae' or Genre9='Reggae')" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y'" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = "All Reggae LPs"
 ElseIf varQueryType = "All-Reggae-CDs" Then
  varSearchTypeDescription = "All Reggae CDs"
  SearchQueryString = "select * from inventory" _
   & " where Format='CD'" _
   & " and (Genre1='Reggae' or Genre2='Reggae' or Genre3='Reggae' or Genre4='Reggae' or Genre5='Reggae' or Genre6='Reggae' or Genre7='Reggae' or Genre8='Reggae' or Genre9='Reggae')" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y'" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = "All Reggae CDs"
 ElseIf varQueryType = "All-Reggae-12s-10s" Then
  varSearchTypeDescription = "All Reggae 12 Inch / 10 Inch / 7 Inch"
  SearchQueryString = "select * from inventory" _
   & " where (Format='12""' or Format='10""'  or Format='7""')" _
   & " and (Genre1='Reggae' or Genre2='Reggae' or Genre3='Reggae' or Genre4='Reggae' or Genre5='Reggae' or Genre6='Reggae' or Genre7='Reggae' or Genre8='Reggae' or Genre9='Reggae')" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y'" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = "All Reggae 12 Inch / 10 Inch / 7 Inch"
 ElseIf varQueryType = "All-Reggae-7s" Then
  varSearchTypeDescription = "All Reggae 7 Inch"
  SearchQueryString = "select * from inventory" _
   & " where Format='7""'" _
   & " and (Genre1='Reggae' or Genre2='Reggae' or Genre3='Reggae' or Genre4='Reggae' or Genre5='Reggae' or Genre6='Reggae' or Genre7='Reggae' or Genre8='Reggae' or Genre9='Reggae')" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y'" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = "All Reggae 7 Inch"
 ElseIf varQueryType = "Reggae-Essential-Picks" Then
  varSearchTypeDescription = "Reggae Essential Picks"
  SearchQueryString = "select * from inventory" _
   & " where (Genre1='Reggae' or Genre2='Reggae' or Genre3='Reggae' or Genre4='Reggae' or Genre5='Reggae' or Genre6='Reggae' or Genre7='Reggae' or Genre8='Reggae' or Genre9='Reggae')" _
   & " and WebEssential='y'" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y'" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = "Reggae Essential Picks"
 ElseIf varQueryType = "Used-Reggae-7s" Then
  varSearchTypeDescription = "Used Reggae 7 Inch"
  SearchQueryString = "select * from inventory" _
   & " where (Genre1='Reggae' or Genre2='Reggae' or Genre3='Reggae' or Genre4='Reggae' or Genre5='Reggae' or Genre6='Reggae' or Genre7='Reggae' or Genre8='Reggae' or Genre9='Reggae')" _
   & " and UsedItem='y'" _
   & " and Format='7""'" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y'" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = "Used Reggae 7 Inch"
 ElseIf varQueryType = "RCDs-499" Then
  varSearchTypeDescription = "Reggae CDs $4.99 or Less"
  SearchQueryString = "select * from inventory" _
   & " where Format='CD'" _
   & " and (Genre1='Reggae' or Genre2='Reggae' or Genre3='Reggae' or Genre4='Reggae' or Genre5='Reggae' or Genre6='Reggae' or Genre7='Reggae' or Genre8='Reggae' or Genre9='Reggae')" _
   & " and " & varPriceGroup & "<=4.99" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y'" _
   & varReggaeOrNonReggaeSQL _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = "Reggae CDs $4.99 or Less"
 ElseIf varQueryType = "ItemFeature" Then
  If Not IsNumeric(varAllID) Then
   varAllID = "0"
  End If
  varIFID = "|1|" & varAllID & "|2|%"
  Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
   SqlConnection.ClearPool(conn)
   conn.Open()
   Dim CMD_X As New SqlCommand("select * from InventoryItemFeatureIndex where InventoryItemFeatureID=" & varAllID, conn)
   CMD_X.CommandType = Data.CommandType.Text
   Dim readerX As SqlDataReader
   readerX = CMD_X.ExecuteReader
   If readerX.HasRows Then
    readerX.Read()
    varSearchTypeDescription = IsDBSomething(readerX("FormatForInternalUse"), "") & " " & IsDBSomething(readerX("ItemFeatureWebProductDetailsPageText"), "")
    varYouSearchedForArtist = varSearchTypeDescription
   End If
  End Using
  SearchQueryString = "select Genre1,WeightInGrams,SupplierID,Inventory.Format,UPC,rhythmname,Inventory.id,artisttitle,cutout,UsedItem" _
   & ",tracksgroup,producegroup,WebEssential,WebReviewHTML,musiciangroup,storeprice,exportprice" _
   & ",retailprice,Cost,MP3FileCompleted,Deleted,Inventory,NumberOfTracks" _
   & ",Sale_RetailPrice,Sale_RetailEndDate,Sale_RetailFootnoteText,Sale_RetailItemDetailsText,Sale_WholesalePrice,Sale_WholesaleEndDate,Sale_WholesaleFootnoteText,Sale_WholesaleItemDetailsText,ItemFootnoteText" _
   & ",Label,Catalog,YearFrom,YearTo,DateAdded,ConditionJacket,ConditionVinylOrCD,ConditionNotes,ConditionText" _
   & ",ItemFeatures1,ItemFeatures2,ItemFeatures3,ItemFeatures4,ItemFeatures5,ItemFeatures6,ItemFeatures7,ItemFeatures8,ItemFeatures9,ItemFeatures10,FormatOrder,SalesLast30Days" _
   & " from inventory inner join InventoryItemFeatures on Inventory.ID=InventoryItemFeatures.ItemID" _
   & " where InventoryItemFeatures.InventoryItemFeatureID = " & varWebSearchSuggestionHint & varAllID _
   & " and inventory" & varIText & " and deleted " & varSDText & " and ShowOnWebsite " & varShowText & varNewOrUsedText & varStreetDateText _
   & varSortOrderString
  varAllowSortOrders = 1
 ElseIf varQueryType = "PlaySound" Then
  varSearchTypeDescription = "Play Sound"
  SearchQueryString = "select * from inventory" _
   & " where UPPER(MP3FileCompleted) = 'Y'" _
   & " and charindex('  1) ',TracksGroup)>0" _
   & " and charindex('TRACKS: ',TracksGroup)>0" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y'" _
   & varSortOrderString
  varAllowSortOrders = 1
  varYouSearchedForArtist = "Play Sound"
 Else
  varDefaultHomePage = 1
  varSearchTypeDescription = "DefaultPage"
  varQueryType = "DefaultPage"
 End If

 '*** END OF SQL STRING ***


    %>


    <%'You Searched For Hidden Text Boxes%>
    <input type="hidden" name="YSFArtist" id="YSFArtist" value="<%=varYouSearchedForArtist%>">
    <input type="hidden" name="YSFFormat" id="YSFFormat" value='<%=varYouSearchedForFormat%>'>
    <%' value= in single quotes because of formats containing double quotes%>
    <input type="hidden" name="YSFRecent" id="YSFRecent" value="<%=varYouSearchedForRecent%>">
    <input type="hidden" name="YSFYear" id="YSFYear" value="<%=varYouSearchedForYear%>">
    <input type="hidden" name="YSFPrice" id="YSFPrice" value="<%=varYouSearchedForPrice%>">
    <input type="hidden" name="YSFGenre" id="YSFGenre" value="<%=varYouSearchedForGenre%>">
    <input type="hidden" name="YSFLabel" id="YSFLabel" value="<%=varYouSearchedForLabel%>">
    <input type="hidden" name="YSFIncludeUsed" id="YSFIncludeUsed" value="<%=varYouSearchedForIncludeUsed%>">
    <input type="hidden" name="YSFSearch" id="YSFSearch" value="">

    <%' Last X3 request criterias%>
    <input type="hidden" name="X3LEL3" id="X3LEL3" value="<%=varLabelExact%>">
    <input type="hidden" name="X3GEL3" id="X3GEL3" value="<%=varGenreExact%>">
    <input type="hidden" name="X3AEL3" id="X3AEL3" value="<%=varArtistExact%>">
    <input type="hidden" name="X3ASTL3" id="X3ASTL3" value="<%=varArtistSearchType%>">
    <input type="hidden" name="X3ASTCL3" id="X3ASTCL3" value="<%=varArtistSearchTypeCounter%>">
    <input type="hidden" name="X3REL3" id="X3REL3" value="<%=varRhythmExact%>">
    <input type="hidden" name="X3ASEL3" id="X3ASEL3" value="<%=varArtistSelected%>">
    <input type="hidden" name="X3LSEL3" id="X3LSEL3" value="<%=varLabelSelected%>">
    <input type="hidden" name="X3GSEL3" id="X3GSEL3" value="<%=varGenreSelected%>">
    <input type="hidden" name="X3AIDL3" id="X3AIDL3" value="<%=varAllID%>">
    <input type="hidden" name="X3AANL3" id="X3AANL3" value="<%=varAllArtistName%>">
    <input type="hidden" name="X3QTL3" id="X3QTL3" value="<%=varQueryType%>">
    <input type="hidden" name="X3AL3" id="X3AL3" value="<%=varArtistCriteria%>">
    <input type="hidden" name="X3FL3" id="X3FL3" value="<%=varFormatCriteria%>">
    <input type="hidden" name="X3RL3" id="X3RL3" value="<%=varRecentCriteria%>">
    <input type="hidden" name="X3RYL3" id="X3RYL3" value="<%=varRhythmCriteria%>">
    <input type="hidden" name="X3LL3" id="X3LL3" value="<%=varlabelCriteria%>">
    <input type="hidden" name="X3IUL3" id="X3IUL3" value="<%=varIncludeUsedCriteria%>">
    <input type="hidden" name="X3GL3" id="X3GL3" value="<%=varGenreCriteria%>">
    <input type="hidden" name="X3YL3" id="X3YL3" value="<%=varYearCriteria%>">
    <input type="hidden" name="X3PRL3" id="X3PRL3" value="<%=varPriceCriteria%>">
    <input type="hidden" name="X3RONL3" id="X3RONL3" value="<%=varReggaeOrNonReggae%>">
    <input type="hidden" name="X3KSL3" id="X3KSL3" value="<%=varKeepSearchCriteria%>">
    <input type="hidden" name="X3EMIDL3" id="X3EMIDL3" value="<%=varErnieMessageID%>">
    <input type="hidden" name="X3CBFL3" id="X3CBFL3" value="<%=varCustBoughtFormat%>">
    <input type="hidden" name="X3CBDL3" id="X3CBDL3" value="<%=varCustBoughtDays%>">

    <input type="hidden" name="X3SR" id="X3SR" value="1">
    <%'StartRecord%>
    <input type="hidden" name="X3P" id="X3P" value="1">
    <%'PageOn%>
    <input type="hidden" name="X3CARTCQ" id="X3CARTCQ" value="no">
    <%'CartChangedQuantity%>
    <input type="hidden" id="BSLTxt" value='<%=varBSLTxt%>' name="BSLTxt">
    <input type="hidden" id="SSFTxt" value="<%=varSongSearchFormat%>" name="SSFTxt">
    <input type="hidden" id="SSSTxt" value="<%=varSongSearchSong%>" name="SSSTxt">


    <%
 Dim varXXRecordCount As Integer = 0
 Dim NumberOfRecordsLimit As Integer = 160
 Dim NumberOfItemsFound As String = ""
 Dim xx As SqlDataReader
 Dim xxRecordcount As SqlDataReader
 'Fix SearchQueryString if only NewOrUsed is selected
 SearchQueryString = Replace(SearchQueryString, "from inventory and inventory>0", "from inventory where inventory>0",,, CompareMethod.Text)

 'Open Recordset for Non-Default Page
 If varDefaultHomePage = 0 And varDisplayLikeHomePage = 0 Then
  NumberOfRecordsLimit = 160
  If varCartPage = 1 Then NumberOfRecordsLimit = 500
  If NoSearchCriteria = "yes" And varQueryType = "NewSearch" And varIncludeUsedCriteria = "" Then
   SearchQueryString = "select inventory.* from inventory where Format like 'xxx'"
   varYouSearchedForArtist = ""
  End If
  'Recordcount
  Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
   SqlConnection.ClearPool(conn)
   conn.Open()
   Dim CMD_X As New SqlCommand(SearchQueryString, conn)
   CMD_X.CommandType = Data.CommandType.Text
   xxRecordcount = CMD_X.ExecuteReader
   If xxRecordcount.HasRows Then
    Do While xxRecordcount.Read
     varXXRecordCount = varXXRecordCount + 1
    Loop
   End If
  End Using
  If varXXRecordCount = 1 Then
   NumberOfItemsFound = "1 item found"
  Else
   NumberOfItemsFound = varXXRecordCount & " items found"
  End If
 End If

 'Record Search Criteria Statistics
 If varRecordSearchCriteria = 1 And varMajorBrowser = 1 And varKnownSearchEngineUserAgent = 0 Then
  Dim varQueryTypeStatistic As String = ""
  Dim varPriceStatistic As String = ""
  varQueryTypeStatistic = varQueryType
  Dim varAllLabelStatistic As String = labelnamesearch
  If varCartPage = 1 Then
   varQueryTypeStatistic = "Cart"
  End If
  If varPriceFromStatistic = "0" Then varPriceFromStatistic = ""
  If varPriceToStatistic = "10000" Then varPriceToStatistic = ""
  If varPriceFromStatistic <> "" Then
   varPriceStatistic = "from " & varPriceFromStatistic
  End If
  If varPriceToStatistic <> "" Then
   If varPriceStatistic = "" Then
    varPriceStatistic = "to " & varPriceFromStatistic
   Else
    varPriceStatistic = varPriceStatistic & " to " & varPriceFromStatistic
   End If
  End If

  Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
   SqlConnection.ClearPool(conn)
   conn.Open()
   Dim CMD_AdjustCart As New SqlCommand("spInsertSearchCriteriaStatistics", conn)
   CMD_AdjustCart.CommandType = Data.CommandType.StoredProcedure
   CMD_AdjustCart.Parameters.AddWithValue("@PowerUserName", IsSomething(Session("PowerUserName"), DBNull.Value))
   CMD_AdjustCart.Parameters.AddWithValue("@IPAddress", IsSomething(Left(Request.ServerVariables("HTTP_X_FORWARDED_FOR"), 50), DBNull.Value))
   CMD_AdjustCart.Parameters.AddWithValue("@SessionID", IsSomething(Left(Session.SessionID & Session("CartRandomNumbersExtension"), 50), DBNull.Value))
   CMD_AdjustCart.Parameters.AddWithValue("@UserAgentString", IsSomething(Left(ua, 200), DBNull.Value))
   CMD_AdjustCart.Parameters.AddWithValue("@QueryType", IsSomething(Left(varQueryTypeStatistic, 50), DBNull.Value))
   CMD_AdjustCart.Parameters.AddWithValue("@ArtistTitle", IsSomething(Left(varSearchArtist, 50), DBNull.Value))
   CMD_AdjustCart.Parameters.AddWithValue("@Format", IsSomething(Left(varSearchFormat, 10), DBNull.Value))
   CMD_AdjustCart.Parameters.AddWithValue("@HowRecent", IsSomething(Left(varHowRecentStatistic, 20), DBNull.Value))
   CMD_AdjustCart.Parameters.AddWithValue("@YearRange", IsSomething(Left(varYearStatistic, 20), DBNull.Value))
   CMD_AdjustCart.Parameters.AddWithValue("@PriceRange", IsSomething(Left(varPriceCriteria, 20), DBNull.Value))
   CMD_AdjustCart.Parameters.AddWithValue("@Genre", IsSomething(Left(SearchGenre, 30), DBNull.Value))
   CMD_AdjustCart.Parameters.AddWithValue("@Label", IsSomething(Left(varSearchLabel, 120), DBNull.Value))
   CMD_AdjustCart.Parameters.AddWithValue("@NewOrUsed", IsSomething(Left(varNewOrUsedStatistic, 10), DBNull.Value))
   CMD_AdjustCart.Parameters.AddWithValue("@SortOrder", IsSomething(Left(varSortOrderStatistic, 20), DBNull.Value))
   CMD_AdjustCart.Parameters.AddWithValue("@NumberOfRecords", varXXRecordCount)
   CMD_AdjustCart.Parameters.AddWithValue("@PageOn", varPageOn)
   CMD_AdjustCart.Parameters.AddWithValue("@DisplayType", IsSomething(Left(varDisplayType, 15), DBNull.Value))
   CMD_AdjustCart.Parameters.AddWithValue("@ArtistSelected", IsSomething(Left(varArtistSelected, 100), DBNull.Value))
   CMD_AdjustCart.Parameters.AddWithValue("@LabelSelected", IsSomething(Left(varLabelSelected, 100), DBNull.Value))
   CMD_AdjustCart.Parameters.AddWithValue("@GenreSelected", IsSomething(Left(varGenreSelected, 30), DBNull.Value))
   CMD_AdjustCart.Parameters.AddWithValue("@SearchTypeDescription", IsSomething(Left(varSearchTypeDescription, 255), DBNull.Value))
   CMD_AdjustCart.Parameters.AddWithValue("@SearchID", IsSomething(Left(varSearchID, 50), DBNull.Value))
   CMD_AdjustCart.Parameters.AddWithValue("@CustomerID", varCustomerID)
   CMD_AdjustCart.Parameters.AddWithValue("@CustomerServerCounter", IsSomething(Session("CustomerServerCounter"), "0"))
   CMD_AdjustCart.Parameters.AddWithValue("@AllArtist", IsSomething(Left(varAllArtistName, 100), DBNull.Value))
   CMD_AdjustCart.Parameters.AddWithValue("@AllLabel", IsSomething(Left(varAllLabelName, 100), DBNull.Value))
   CMD_AdjustCart.Parameters.AddWithValue("@AllRhythm", IsSomething(Left(varAllRhythmName, 100), DBNull.Value))
   CMD_AdjustCart.Parameters.AddWithValue("@AllGenre", IsSomething(Left(varAllGenre, 100), DBNull.Value))
   CMD_AdjustCart.Parameters.AddWithValue("@REMOTE_HOST", IsSomething(Left(Request.ServerVariables("REMOTE_HOST"), 300), DBNull.Value))
   CMD_AdjustCart.Parameters.AddWithValue("@HTTP_REFERER", IsSomething(Left(Request.ServerVariables("HTTP_REFERER"), 300), DBNull.Value))
   CMD_AdjustCart.Parameters.AddWithValue("@ButtonColor", IsSomething(Left(varButtonColor, 15), DBNull.Value))
   CMD_AdjustCart.Parameters.AddWithValue("@FromOurSite", IsSomething(Left(varFromOurSite, 1), DBNull.Value))
   CMD_AdjustCart.ExecuteNonQuery()
  End Using
 End If

 ' Quick Search Buttons--------------------------------------------------------------------------------%>
    <table bgcolor="9BAF9B" frame="none" cellpadding="0" cellspacing="0" width="1250" align="center" border="0">
        </form>
        <tr>
            <td width="1250" height="181" valign="top" style="vertical-align: top">

                <%'Genre Searches%>
                <div class="qqg" name="qqgs" id="qqgs" style="border: 13px solid #6995c2; text-align: left; position: absolute; width: 1110px; margin-left: 58px; margin-top: -130px; z-index: 100">
                    <table cellpadding="0" width="100%" cellspacing="0" align="center" border="0">
                        <tr>
                            <td width="1010" height="54" bgcolor="ECECEC" style="vertical-align: middle; text-align: left; background-image: url('<%=AssetsPath()%>/gs-bg.gif'); background-repeat: repeat-x">
                                <div id="divGenreArrow" name="divGenreArrow" style="margin-top: 38px; margin-left: 65px; border: 0px; vertical-align: top; width: 980px; height: 32px; position: absolute; display: inline; visibility: visible; z-index: 1000">
                                    <img alt="" id="imgGenreArrow" style="border: 0px" src="<%=AssetsPath()%>/genre-arrow.gif" /><img alt="" id="imgArtistSortByMostPopular" onclick="varGenreArtistsStartRecord=1;varGenreArtistsSort='P';genreArtistsSortMostPopular()" style="border: 0px; cursor: pointer; margin-top: 15px; margin-left: 390px" src="<%=AssetsPath()%>/sort-by-most-popular.gif" /><img alt="" id="imgArtistSortByAlphabetical" onclick="varGenreArtistsStartRecord=1;varGenreArtistsSort='A';genreArtistsSortAlphabetical()" style="border: 0px; cursor: pointer; margin-top: 15px; margin-left: 50px" src="<%=AssetsPath()%>/sort-by-alphabetical2.gif" />
                                </div>
                                <p class="genre-searches-title" style="margin-left: 38px" name="gs-title" id="gs-title">&nbsp;</p>
                                <p class="genre-searches-subtitle" style="margin-left: 13px" name="gs-subtitle" id="gs-subtitle">&nbsp;</p>
                            </td>
                            <td bgcolor="ECECEC" width="100" valign="middle" align="right" style="background-image: url('<%=AssetsPath()%>/gs-bg.gif'); background-repeat: repeat-x">
                                <img alt="" class="a" style="vertical-align: middle; margin-right: 5px" src="<%=AssetsPath()%>/close33.gif" onclick="HGD('qqgs')" onmouseover="fov(this,'close33')" onmouseout="fou(this,'close33')">
                            </td>
                        </tr>
                    </table>

                    <table cellpadding="0" width="100%" cellspacing="0" align="center" border="0">
                        <tr>
                            <td width="250" style="vertical-align: top">

                                <table cellpadding="0" width="100%" cellspacing="0" align="center" border="0">
                                    <tr>
                                        <td height="30">
                                            <%for intN=1 To 28%>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="td-gSS">
                                            <p class="g-ss" id="gSS<%=intN%>"></p>
                                            <% Next%>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td width="50" height="19">
                                <div id="divGenreSearchesProcessingIcon" name="divGenreSearchesProcessingIcon" style="margin-top: -150px; margin-left: 260px; border: 0px; vertical-align: top; width: 154px; height: 74px; position: absolute; display: inline; visibility: visible; z-index: 1000">
                                    <img alt="" name="imgGenreArtistsTimer" id="imgGenreArtistsTimer" style="border: 0px" src="<%=AssetsPath()%>/loading-processing-0.gif" />
                                </div>

                            </td>
                            <td width="256" valign="top" align="left" style="padding-top: 20px">
                                <% For varQQ = 1 To 35%>
                                <br>
                                <p class="g-a" name="ga<%=varQQ%>" id="ga<%=varQQ%>" onclick="AAg(this)"></p>
                                <% Next%>
                            </td>
                            <td width="10"></td>
                            <td width="257" valign="top" align="left" style="padding-top: 20px">
                                <% For varQQ = 36 To 70%>
                                <br>
                                <p class="g-a" name="ga<%=varQQ%>" id="ga<%=varQQ%>" onclick="AAg(this)"></p>
                                <% Next%>
                            </td>
                            <td width="10"></td>
                            <td width="256" valign="top" align="left" style="padding-top: 20px">
                                <% For varQQ = 71 To 105%>
                                <br>
                                <p class="g-a" name="ga<%=varQQ%>" id="ga<%=varQQ%>" onclick="AAg(this)"></p>
                                <% Next%>
                            </td>
                            <td width="20"></td>
                        </tr>
                    </table>
                    <table cellpadding="0" width="100%" cellspacing="0" align="center" border="0">
                        <tr>
                            <td height="50" style="vertical-align: top; padding-top: 18px">
                                <div id="divNextPageArtists" name="divNextPageArtists" style="margin-top: 0px; margin-left: 880px; border: 0px; vertical-align: top; width: 200px; height: 30px; position: absolute; visibility: hidden; z-index: 2000">
                                    <img alt="" name="imgNextPageArtists" id="imgNextPageArtists" onclick="nextPageArtists()" style="margin-top: -8px; margin-left: 0px; border: 0px; cursor: pointer" src="<%=AssetsPath()%>/next-page-b.gif" />
                                </div>
                                <%For intNN = 65 To 90
  If intNN = 65 Then
   Response.Write("<p class=""p-letters""style=""margin-left:370px""onclick=""genreArtistsLetter('" & Chr(intNN) & "')"">" & Chr(intNN) & "</p>")
  Else
   Response.Write("<p class=""p-letters""style=""margin-left:8px""onclick=""genreArtistsLetter('" & Chr(intNN) & "')"">" & Chr(intNN) & "</p>")
  End If
 Next%>
                            </td>
                        </tr>
                    </table>
                </div>
                <%'More Genre Searches%>
                <div class="qqg" name="qqmgs" id="qqmgs" style="border: 13px solid #6995c2; text-align: left; position: absolute; width: 1110px; margin-left: 58px; margin-top: -130px; z-index: 100">
                    <table cellpadding="0" width="100%" cellspacing="0" align="center" border="0">
                        <tr>
                            <td width="1010" height="54" bgcolor="ECECEC" style="vertical-align: middle; text-align: left; background-image: url('<%=AssetsPath()%>/gs-bg.gif'); background-repeat: repeat-x">
                                <div id="divMoreGenresSort" style="margin-top: 38px; margin-left: 0px; border: 0px; vertical-align: top; width: 900px; height: 32px; position: absolute; display: inline; visibility: visible; z-index: 1000">
                                    <img alt="" id="imgGenreSortByMostPopular" onclick="varGenreArtistsStartRecord=1;varGenreGenresStartRecord=1;varGenreArtistsSort='P';varGenreGenresSort='P';MoreGenresSortMostPopular()" style="border: 0px; cursor: pointer; margin-top: 15px; margin-left: 403px" src="<%=AssetsPath()%>/sort-by-most-popular.gif" /><img alt="" id="imgGenreSortByAlphabetical" onclick="varGenreArtistsStartRecord=1;varGenreGenresStartRecord=1;varGenreArtistsSort='P';varGenreGenresSort='A';MoreGenresSortAlphabetical()" style="border: 0px; cursor: pointer; margin-top: 11px; margin-left: 50px" src="<%=AssetsPath()%>/sort-by-alphabetical2.gif" />
                                </div>
                                <p class="genre-searches-title" style="margin-left: 50px">All Genres</p>
                                <p class="genre-searches-subtitle" style="margin-left: 13px; font-size: 18px">Click on a genre to search for items within that genre</p>
                            </td>
                            <td bgcolor="ECECEC" width="100" valign="middle" align="right" style="background-image: url('<%=AssetsPath()%>/gs-bg.gif'); background-repeat: repeat-x">
                                <img alt="" class="a" style="vertical-align: middle; margin-right: 5px" src="<%=AssetsPath()%>/close33.gif" onclick="HGD('qqmgs')" onmouseover="fov(this,'close33')" onmouseout="fou(this,'close33')">
                            </td>
                        </tr>
                    </table>

                    <table cellpadding="0" width="100%" cellspacing="0" align="center" border="0">
                        <tr>
                            <td width="50" height="24">
                                <div id="divMoreGenresSearchProcessingIcon" name="divMoreGenresSearchProcessingIcon" style="margin-top: -150px; margin-left: 478px; border: 0px; vertical-align: top; text-align: top; width: 154px; height: 74px; position: absolute; display: inline; visibility: visible; z-index: 1000">
                                    <img alt="" name="imgMoreGenresSearchTimer" id="imgMoreGenresSearchTimer" style="border: 0px" src="<%=AssetsPath()%>/loading-processing-0.gif" />
                                </div>
                            </td>
                            <td width="237" valign="top" align="left" style="padding-top: 14px">
                                <% For varQQ = 1 To 35%>
                                <br>
                                <p class="g-a" name="mga<%=varQQ%>" id="mga<%=varQQ%>" onclick="genreSearch('qqgs',this,'-')"></p>
                                <% Next%>
                            </td>
                            <td width="10"></td>
                            <td width="238" valign="top" align="left" style="padding-top: 14px">
                                <% For varQQ = 36 To 70%>
                                <br>
                                <p class="g-a" name="mga<%=varQQ%>" id="mga<%=varQQ%>" onclick="genreSearch('qqgs',this,'-')"></p>
                                <% Next%>
                            </td>
                            <td width="10"></td>
                            <td width="238" valign="top" align="left" style="padding-top: 14px">
                                <% For varQQ = 71 To 105%>
                                <br>
                                <p class="g-a" name="mga<%=varQQ%>" id="mga<%=varQQ%>" onclick="genreSearch('qqgs',this,'-')"></p>
                                <% Next%>
                            </td>
                            <td width="10"></td>
                            <td width="237" valign="top" align="left" style="padding-top: 14px">
                                <% For varQQ = 106 To 140%>
                                <br>
                                <p class="g-a" name="mga<%=varQQ%>" id="mga<%=varQQ%>" onclick="genreSearch('qqgs',this,'-')"></p>
                                <% Next%>
                            </td>
                            <td width="80"></td>
                        </tr>
                    </table>
                    <table cellpadding="0" width="100%" cellspacing="0" align="center" border="0">
                        <tr>
                            <td height="50">
                                <div id="divNextPageMoreGenres" name="divNextPageMoreGenres" style="margin-top: -8px; margin-left: 931px; border: 0px; vertical-align: top; width: 120px; height: 20px; position: absolute; visibility: hidden; z-index: 2000">
                                    <img alt="" name="imgNextPageMoreGenres" id="imgNextPageMoreGenres" onclick="nextPageMoreGenres()" style="border: 0px; cursor: pointer" src="<%=AssetsPath()%>/next-page-b.gif" />
                                </div>
                                <%For intNN = 65 To 90
  If intNN = 65 Then
   Response.Write("<p class=""p-letters""style=""margin-left:315px""onclick=""moreGenresLetter('" & Chr(intNN) & "')"">" & Chr(intNN) & "</p>")
  Else
   Response.Write("<p class=""p-letters""style=""margin-left:8px""onclick=""moreGenresLetter('" & Chr(intNN) & "')"">" & Chr(intNN) & "</p>")
  End If
 Next%>
                            </td>
                        </tr>
                    </table>
                </div>
                <%'All Artists Search%>
                <div class="qqg" name="qqaa" id="qqaa" style="border: 13px solid #6995c2; text-align: left; position: absolute; width: 1110px; margin-left: 58px; margin-top: -130px; z-index: 100">
                    <table cellpadding="0" width="100%" cellspacing="0" align="center" border="0">
                        <tr>
                            <td width="1010" height="54" bgcolor="ECECEC" style="vertical-align: middle; text-align: left; background-image: url('<%=AssetsPath()%>/gs-bg.gif'); background-repeat: repeat-x">
                                <div id="divAllArtistsSort" style="margin-top: 38px; margin-left: 0px; border: 0px; vertical-align: top; width: 900px; height: 32px; position: absolute; display: inline; visibility: visible; z-index: 1000">
                                    <img alt="" id="imgAllArtistsSortByMostPopular" onclick="varAllArtistsStartRecord=1;varAllArtistsSort='P';AllArtistsSortMostPopular()" style="border: 0px; cursor: pointer; margin-top: 15px; margin-left: 403px" src="<%=AssetsPath()%>/sort-by-most-popular.gif" /><img alt="" id="imgAllArtistsSortByAlphabetical" onclick="varAllArtistsStartRecord=1;varAllArtistsSort='A';AllArtistsSortAlphabetical()" style="border: 0px; cursor: pointer; margin-top: 11px; margin-left: 50px" src="<%=AssetsPath()%>/sort-by-alphabetical2.gif" />
                                </div>
                                <p class="genre-searches-title" style="margin-left: 50px">All Artists</p>
                                <p class="genre-searches-subtitle" style="margin-left: 13px; font-size: 18px"></p>
                            </td>
                            <td bgcolor="ECECEC" width="100" valign="middle" align="right" style="background-image: url('<%=AssetsPath()%>/gs-bg.gif'); background-repeat: repeat-x">
                                <img alt="" class="a" style="vertical-align: middle; margin-right: 5px" src="<%=AssetsPath()%>/close33.gif" onclick="HGD('qqaa')" onmouseover="fov(this,'close33')" onmouseout="fou(this,'close33')">
                            </td>
                        </tr>
                    </table>

                    <table cellpadding="0" width="100%" cellspacing="0" align="center" border="0">
                        <tr>
                            <td width="50" height="24">
                                <div id="divAllArtistsSearchProcessingIcon" name="divAllArtistsSearchProcessingIcon" style="margin-top: -150px; margin-left: 478px; border: 0px; vertical-align: top; text-align: top; width: 154px; height: 74px; position: absolute; display: inline; visibility: visible; z-index: 1000">
                                    <img alt="" name="imgAllArtistsSearchTimer" id="imgAllArtistsSearchTimer" style="border: 0px" src="<%=AssetsPath()%>/loading-processing-0.gif" />
                                </div>
                            </td>
                            <td width="237" valign="top" align="left" style="padding-top: 14px">
                                <% For varQQ = 1 To 35%>
                                <br>
                                <p class="g-a" name="qaa<%=varQQ%>" id="qaa<%=varQQ%>" onclick="AAg(this)"></p>
                                <% Next%>
                            </td>
                            <td width="10"></td>
                            <td width="238" valign="top" align="left" style="padding-top: 14px">
                                <% For varQQ = 36 To 70%>
                                <br>
                                <p class="g-a" name="qaa<%=varQQ%>" id="qaa<%=varQQ%>" onclick="AAg(this)"></p>
                                <% Next%>
                            </td>
                            <td width="10"></td>
                            <td width="238" valign="top" align="left" style="padding-top: 14px">
                                <% For varQQ = 71 To 105%>
                                <br>
                                <p class="g-a" name="qaa<%=varQQ%>" id="qaa<%=varQQ%>" onclick="AAg(this)"></p>
                                <% Next%>
                            </td>
                            <td width="10"></td>
                            <td width="237" valign="top" align="left" style="padding-top: 14px">
                                <% For varQQ = 106 To 140%>
                                <br>
                                <p class="g-a" name="qaa<%=varQQ%>" id="qaa<%=varQQ%>" onclick="AAg(this)"></p>
                                <% Next%>
                            </td>
                            <td width="80"></td>
                        </tr>
                    </table>
                    <table cellpadding="0" width="100%" cellspacing="0" align="center" border="0">
                        <tr>
                            <td height="50">
                                <div id="divNextPageAllArtists" name="divNextPageAllArtists" style="margin-top: -8px; margin-left: 931px; border: 0px; vertical-align: top; width: 120px; height: 20px; position: absolute; visibility: hidden; z-index: 2000">
                                    <img alt="" name="imgNextPageAllArtists" id="imgNextAllArtists" onclick="nextPageAllArtists()" style="border: 0px; cursor: pointer" src="<%=AssetsPath()%>/next-page-b.gif" />
                                </div>
                                <%For intNN = 65 To 90
  If intNN = 65 Then
   Response.Write("<p class=""p-letters""style=""margin-left:315px""onclick=""AllArtistsLetter('" & Chr(intNN) & "')"">" & Chr(intNN) & "</p>")
  Else
   Response.Write("<p class=""p-letters""style=""margin-left:8px""onclick=""AllArtistsLetter('" & Chr(intNN) & "')"">" & Chr(intNN) & "</p>")
  End If
 Next%>
                            </td>
                        </tr>
                    </table>
                </div>
                <%'All Labels Search%>
                <div class="qqg" name="qqal" id="qqal" style="border: 13px solid #6995c2; text-align: left; position: absolute; width: 1110px; margin-left: 58px; margin-top: -130px; z-index: 100">
                    <table cellpadding="0" width="100%" cellspacing="0" align="center" border="0">
                        <tr>
                            <td width="1010" height="54" bgcolor="ECECEC" style="vertical-align: middle; text-align: left; background-image: url('<%=AssetsPath()%>/gs-bg.gif'); background-repeat: repeat-x">
                                <div id="divAllLabelsSort" style="margin-top: 38px; margin-left: 0px; border: 0px; vertical-align: top; width: 900px; height: 32px; position: absolute; display: inline; visibility: visible; z-index: 1000">
                                    <img alt="" id="imgAllLabelsSortByMostPopular" onclick="varAllLabelsStartRecord=1;varAllLabelsSort='P';AllLabelsSortMostPopular()" style="border: 0px; cursor: pointer; margin-top: 15px; margin-left: 403px" src="<%=AssetsPath()%>/sort-by-most-popular.gif" /><img alt="" id="imgAllLabelsSortByAlphabetical" onclick="varAllLabelsStartRecord=1;varAllLabelsSort='A';AllLabelsSortAlphabetical()" style="border: 0px; cursor: pointer; margin-top: 11px; margin-left: 50px" src="<%=AssetsPath()%>/sort-by-alphabetical2.gif" />
                                </div>
                                <p class="genre-searches-title" style="margin-left: 50px">All Record Labels</p>
                                <p class="genre-searches-subtitle" style="margin-left: 13px; font-size: 18px"></p>
                            </td>
                            <td bgcolor="ECECEC" width="100" valign="middle" align="right" style="background-image: url('<%=AssetsPath()%>/gs-bg.gif'); background-repeat: repeat-x">
                                <img alt="" class="a" style="vertical-align: middle; margin-right: 5px" src="<%=AssetsPath()%>/close33.gif" onclick="HGD('qqal')" onmouseover="fov(this,'close33')" onmouseout="fou(this,'close33')">
                            </td>
                        </tr>
                    </table>

                    <table cellpadding="0" width="100%" cellspacing="0" align="center" border="0">
                        <tr>
                            <td width="50" height="24">
                                <div id="divAllLabelsSearchProcessingIcon" name="divAllLabelsSearchProcessingIcon" style="margin-top: -150px; margin-left: 478px; border: 0px; vertical-align: top; text-align: top; width: 154px; height: 74px; position: absolute; display: inline; visibility: visible; z-index: 1000">
                                    <img alt="" name="imgAllLabelsSearchTimer" id="imgAllLabelsSearchTimer" style="border: 0px" src="<%=AssetsPath()%>/loading-processing-0.gif" />
                                </div>
                            </td>
                            <td width="237" valign="top" align="left" style="padding-top: 14px">
                                <% For varQQ = 1 To 35%>
                                <br>
                                <p class="g-a" name="qal<%=varQQ%>" id="qal<%=varQQ%>" onclick="ALg(this)"></p>
                                <% Next%>
                            </td>
                            <td width="10"></td>
                            <td width="238" valign="top" align="left" style="padding-top: 14px">
                                <% For varQQ = 36 To 70%>
                                <br>
                                <p class="g-a" name="qal<%=varQQ%>" id="qal<%=varQQ%>" onclick="ALg(this)"></p>
                                <% Next%>
                            </td>
                            <td width="10"></td>
                            <td width="238" valign="top" align="left" style="padding-top: 14px">
                                <% For varQQ = 71 To 105%>
                                <br>
                                <p class="g-a" name="qal<%=varQQ%>" id="qal<%=varQQ%>" onclick="ALg(this)"></p>
                                <% Next%>
                            </td>
                            <td width="10"></td>
                            <td width="237" valign="top" align="left" style="padding-top: 14px">
                                <% For varQQ = 106 To 140%>
                                <br>
                                <p class="g-a" name="qal<%=varQQ%>" id="qal<%=varQQ%>" onclick="ALg(this)"></p>
                                <% Next%>
                            </td>
                            <td width="80"></td>
                        </tr>
                    </table>
                    <table cellpadding="0" width="100%" cellspacing="0" align="center" border="0">
                        <tr>
                            <td height="50">
                                <div id="divNextPageAllLabels" name="divNextPageAllLabels" style="margin-top: -8px; margin-left: 931px; border: 0px; vertical-align: top; width: 120px; height: 20px; position: absolute; visibility: hidden; z-index: 2000">
                                    <img alt="" name="imgNextPageAllLabels" id="imgNextAllLabels" onclick="nextPageAllLabels()" style="border: 0px; cursor: pointer" src="<%=AssetsPath()%>/next-page-b.gif" />
                                </div>
                                <%For intNN = 65 To 90
  If intNN = 65 Then
   Response.Write("<p class=""p-letters""style=""margin-left:315px""onclick=""AllLabelsLetter('" & Chr(intNN) & "')"">" & Chr(intNN) & "</p>")
  Else
   Response.Write("<p class=""p-letters""style=""margin-left:8px""onclick=""AllLabelsLetter('" & Chr(intNN) & "')"">" & Chr(intNN) & "</p>")
  End If
 Next%>
                            </td>
                        </tr>
                    </table>
                </div>



                <div style="position: absolute; margin-left: 115px">
                    <img alt="" style="cursor: pointer" onclick="showMore('New-Release-LPs','green')" src="<%=AssetsPath()%>/qq-NALP2.gif" onmouseover="fov(this,'qq-NALP2')" onmouseout="fou(this,'qq-NALP2')">
                </div>
                <div style="position: absolute; margin-left: 115px; margin-top: 28px">
                    <img alt="" style="cursor: pointer" onclick="showMore('New-Release-CDs','green')" src="<%=AssetsPath()%>/qq-NACD2.gif" onmouseover="fov(this,'qq-NACD2')" onmouseout="fou(this,'qq-NACD2')">
                </div>
                <div style="position: absolute; margin-left: 115px; margin-top: 55px">
                    <img alt="" style="cursor: pointer" onclick="showMore('New-Release-12s-10s','green')" src="<%=AssetsPath()%>/qq-NA12102.gif" onmouseover="fov(this,'qq-NA12102')" onmouseout="fou(this,'qq-NA12102')">
                </div>
                <div style="position: absolute; margin-left: 115px; margin-top: 82px">
                    <img alt="" style="cursor: pointer" onclick="showMore('New-Release-7s','green')" src="<%=AssetsPath()%>/qq-NA72.gif" onmouseover="fov(this,'qq-NA72')" onmouseout="fou(this,'qq-NA72')">
                </div>
                <div style="position: absolute; margin-left: 115px; margin-top: 109px">
                    <img alt="" style="cursor: pointer" onclick="showMore('Jazz-LPs','green')" src="<%=AssetsPath()%>/qq-JazzLPs2.gif" onmouseover="fov(this,'qq-JazzLPs2')" onmouseout="fou(this,'qq-JazzLPs2')">
                </div>
                <div style="position: absolute; margin-left: 115px; margin-top: 136px">
                    <img alt="" style="cursor: pointer" onclick="showMore('Sony-Universal-Warner-LPs','green')" src="<%=AssetsPath()%>/qq-SUW2.gif" onmouseover="fov(this,'qq-SUW2')" onmouseout="fou(this,'qq-SUW2')">
                </div>
                <div style="position: absolute; margin-left: 320px">
                    <img alt="" style="cursor: pointer" onclick="showMore('Best-Selling-LPs','green')" src="<%=AssetsPath()%>/qq-BSLP2.gif" onmouseover="fov(this,'qq-BSLP2')" onmouseout="fou(this,'qq-BSLP2')">
                </div>
                <div style="position: absolute; margin-left: 320px; margin-top: 28px">
                    <img alt="" style="cursor: pointer" onclick="showMore('Best-Selling-CDs','green')" src="<%=AssetsPath()%>/qq-BSCD2.gif" onmouseover="fov(this,'qq-BSCD2')" onmouseout="fou(this,'qq-BSCD2')">
                </div>
                <div style="position: absolute; margin-left: 320px; margin-top: 55px">
                    <img alt="" style="cursor: pointer" onclick="showMore('Best-Selling-12s-10s','green')" src="<%=AssetsPath()%>/qq-BS12102.gif" onmouseover="fov(this,'qq-BS12102')" onmouseout="fou(this,'qq-BS12102')">
                </div>
                <div style="position: absolute; margin-left: 320px; margin-top: 82px">
                    <img alt="" style="cursor: pointer" onclick="showMore('Best-Selling-7s','green')" src="<%=AssetsPath()%>/qq-BS72.gif" onmouseover="fov(this,'qq-BS72')" onmouseout="fou(this,'qq-BS72')">
                </div>
                <div style="position: absolute; margin-left: 320px; margin-top: 109px">
                    <img alt="" style="cursor: pointer" onclick="showMore('Best-Selling-Supplies','green')" src="<%=AssetsPath()%>/qq-BSS2.gif" onmouseover="fov(this,'qq-BSS2')" onmouseout="fou(this,'qq-BSS2')">
                </div>
                <div style="position: absolute; margin-left: 320px; margin-top: 136px">
                    <img alt="" style="cursor: pointer" onclick="showMore('Rock-LPs','green')" src="<%=AssetsPath()%>/qq-RockLPs2.gif" onmouseover="fov(this,'qq-RockLPs2')" onmouseout="fou(this,'qq-RockLPs2')">
                </div>
                <div style="position: absolute; margin-left: 525px">
                    <img alt="" style="cursor: pointer" onclick="showMore('All-LPs','green')" src="<%=AssetsPath()%>/qq-browseALLLP2.gif" onmouseover="fov(this,'qq-browseALLLP2')" onmouseout="fou(this,'qq-browseALLLP2')">
                </div>
                <div style="position: absolute; margin-left: 525px; margin-top: 28px">
                    <img alt="" style="cursor: pointer" onclick="showMore('All-CDs','green')" src="<%=AssetsPath()%>/qq-browseALLCD2.gif" onmouseover="fov(this,'qq-browseALLCD2')" onmouseout="fou(this,'qq-browseALLCD2')">
                </div>
                <div style="position: absolute; margin-left: 525px; margin-top: 55px">
                    <img alt="" style="cursor: pointer" onclick="showMore('All-12s-10s','green')" src="<%=AssetsPath()%>/qq-browseALL12102.gif" onmouseover="fov(this,'qq-browseALL12102')" onmouseout="fou(this,'qq-browseALL12102')">
                </div>
                <div style="position: absolute; margin-left: 525px; margin-top: 82px">
                    <img alt="" style="cursor: pointer" onclick="showMore('All-7s','green')" src="<%=AssetsPath()%>/qq-browseALL72.gif" onmouseover="fov(this,'qq-browseALL72')" onmouseout="fou(this,'qq-browseALL72')">
                </div>
                <div style="position: absolute; margin-left: 525px; margin-top: 109px">
                    <img alt="" style="cursor: pointer" onclick="showMore('All-Supplies','green')" src="<%=AssetsPath()%>/qq-browseALLS2.gif" onmouseover="fov(this,'qq-browseALLS2')" onmouseout="fou(this,'qq-browseALLS2')">
                </div>
                <div style="position: absolute; margin-left: 525px; margin-top: 136px">
                    <a href="/home.aspx?X3QT=ItemFeature&X3AID=7214&BC=green">
                        <img alt="" style="cursor: pointer" src="<%=AssetsPath()%>/qq-180gLPs2.gif" onmouseover="fov(this,'qq-180gLPs2')" onmouseout="fou(this,'qq-180gLPs2')"></a>
                </div>
                <div style="position: absolute; margin-left: 730px">
                    <img alt="" style="cursor: pointer" onclick="showMore('Ace-Records-LPs','green')" src="<%=AssetsPath()%>/qq-ACELP2.gif" onmouseover="fov(this,'qq-ACELP2')" onmouseout="fou(this,'qq-ACELP2')">
                </div>
                <div style="position: absolute; margin-left: 730px; margin-top: 28px">
                    <img alt="" style="cursor: pointer" onclick="showMore('Ace-Records-CDs','green')" src="<%=AssetsPath()%>/qq-ACECD2.gif" onmouseover="fov(this,'qq-ACECD2')" onmouseout="fou(this,'qq-ACECD2')">
                </div>
                <div style="position: absolute; margin-left: 730px; margin-top: 55px">
                    <img alt="" style="cursor: pointer" onclick="showMore('Not-Now-Music-LPs','green')" src="<%=AssetsPath()%>/qq-NNMLP3.gif" onmouseover="fov(this,'qq-NNMLP3')" onmouseout="fou(this,'qq-NNMLP3')">
                </div>
                <div style="position: absolute; margin-left: 730px; margin-top: 82px">
                    <img alt="" style="cursor: pointer" onclick="showMore('Not-Now-Music-CDs','green')" src="<%=AssetsPath()%>/qq-NNMCD2.gif" onmouseover="fov(this,'qq-NNMCD2')" onmouseout="fou(this,'qq-NNMCD2')">
                </div>
                <div style="position: absolute; margin-left: 730px; margin-top: 109px">
                    <img alt="" style="cursor: pointer" onclick="showMore('VP-Greensleeves-LPs','green')" src="<%=AssetsPath()%>/qq-VPGLP2.gif" onmouseover="fov(this,'qq-VPGLP2')" onmouseout="fou(this,'qq-VPGLP2')">
                </div>
                <div style="position: absolute; margin-left: 730px; margin-top: 136px">
                    <img alt="" style="cursor: pointer" onclick="showMore('LPs-1499','green')" src="<%=AssetsPath()%>/qq-LP1499.gif" onmouseover="fov(this,'qq-LP1499')" onmouseout="fou(this,'qq-LP1499')">
                </div>
                <div style="position: absolute; margin-left: 935px">
                    <img alt="" style="cursor: pointer" onclick="showMore('All-Reggae-LPs','green')" src="<%=AssetsPath()%>/qq-browseALLreggaeLP2.gif" onmouseover="fov(this,'qq-browseALLreggaeLP2')" onmouseout="fou(this,'qq-browseALLreggaeLP2')">
                </div>
                <div style="position: absolute; margin-left: 935px; margin-top: 28px">
                    <img alt="" style="cursor: pointer" onclick="showMore('All-Reggae-CDs','green')" src="<%=AssetsPath()%>/qq-browseALLreggaeCD2.gif" onmouseover="fov(this,'qq-browseALLreggaeCD2')" onmouseout="fou(this,'qq-browseALLreggaeCD2')">
                </div>
                <div style="position: absolute; margin-left: 935px; margin-top: 55px">
                    <img alt="" style="cursor: pointer" onclick="showMore('All-Reggae-12s-10s','green')" src="<%=AssetsPath()%>/qq-browseALLreggae12102.gif" onmouseover="fov(this,'qq-browseALLreggae12102')" onmouseout="fou(this,'qq-browseALLreggae12102')">
                </div>
                <div style="position: absolute; margin-left: 935px; margin-top: 82px">
                    <img alt="" style="cursor: pointer" onclick="showMore('Reggae-Essential-Picks','green')" src="<%=AssetsPath()%>/qq-RES2.gif" onmouseover="fov(this,'qq-RES2')" onmouseout="fou(this,'qq-RES2')">
                </div>
                <div style="position: absolute; margin-left: 935px; margin-top: 109px">
                    <img alt="" style="cursor: pointer" onclick="showMore('Used-Reggae-7s','green')" src="<%=AssetsPath()%>/qq-R72.gif" onmouseover="fov(this,'qq-R72')" onmouseout="fou(this,'qq-R72')">
                </div>
                <div style="position: absolute; margin-left: 935px; margin-top: 136px">
                    <img alt="" style="cursor: pointer" onclick="showMore('RCDs-499','green')" src="<%=AssetsPath()%>/qq-RCD4992.gif" onmouseover="fov(this,'qq-RCD4992')" onmouseout="fou(this,'qq-RCD4992')">
                </div>

            </td>
        </tr>
    </table>
    <table cellpadding="0" bgcolor="D4DBD4" cellspacing="0" width="1250" align="center" border="0">
        <td width="100%" align="center" valign="middle">

            <%'URL String
 Dim StartingRecord As Integer = 0
 Dim page1on As Integer = 0
 Dim varNumberOfCriteria As Integer = 0
 Dim varRetailMinimumShippingCharge As Decimal = 0
 Dim varRetailPercentShippingCharge As Decimal = 0
 Dim varNoItemsInStock As Integer = 0
 Dim varWeightInDecimal As Decimal = 0
 Dim varWeight As Decimal = 0
 Dim varWeightInGrams As Integer = 0
 Dim varNumberOf7Inchs As Integer = 0
 Dim varNumberOfDVDs As Integer = 0
 Dim varNumberOfCDs As Integer = 0
 Dim varNumberOfMisc As Integer = 0
 Dim var7InchBoxInCart As Integer = 0
 Dim varNumberOfBoxes As Integer = 0
 Dim varWeightOfOrder As Decimal = 0
 Dim varWeightOfEachBox As Decimal = 0
 Dim varShippingRate As String = ""
 Dim varShippingCharge As Decimal = 0
 Dim varTotalText As String = ""
 Dim varShippingChargeText As String = ""
 Dim varURLString As String = ""
 If IsDBSomething(varLabelExact, "") <> "" Then varURLString = varURLString & "&X3LEL3=" & Server.UrlEncode(varLabelExact)
 If IsDBSomething(varGenreExact, "") <> "" Then varURLString = varURLString & "&X3GEL3=" & Server.UrlEncode(varGenreExact)
 If IsDBSomething(varArtistExact, "") <> "" Then varURLString = varURLString & "&X3AEL3=" & Server.UrlEncode(varArtistExact)
 If IsDBSomething(varArtistSearchType, "") <> "" Then varURLString = varURLString & "&X3ASTL3=" & Server.UrlEncode(varArtistSearchType)
 If IsDBSomething(varArtistSearchTypeCounter, "") <> "" Then varURLString = varURLString & "&X3ASTCL3=" & Server.UrlEncode(varArtistSearchTypeCounter)
 If IsDBSomething(varRhythmExact, "") <> "" Then varURLString = varURLString & "&X3REL3=" & Server.UrlEncode(varRhythmExact)
 If IsDBSomething(varArtistSelected, "") <> "" Then varURLString = varURLString & "&X3ASEL3=" & Server.UrlEncode(varArtistSelected)
 If IsDBSomething(varLabelSelected, "") <> "" Then varURLString = varURLString & "&X3LSEL3=" & Server.UrlEncode(varLabelSelected)
 If IsDBSomething(varGenreSelected, "") <> "" Then varURLString = varURLString & "&X3GSEL3=" & Server.UrlEncode(varGenreSelected)
 If IsDBSomething(varAllID, "") <> "" Then varURLString = varURLString & "&X3AIDL3=" & Server.UrlEncode(varAllID)
 If IsDBSomething(Request.QueryString("genre"), "") <> "" Then varURLString = varURLString & "&genre=" & Server.UrlEncode(Request.QueryString("genre"))
 If IsDBSomething(varAllArtistName, "") <> "" Then varURLString = varURLString & "&X3AANL3=" & Server.UrlEncode(varAllArtistName)
 If IsDBSomething(varQueryType, "") <> "" Then varURLString = varURLString & "&X3QTL3=" & Server.UrlEncode(varQueryType)
 If IsDBSomething(varArtistCriteria, "") <> "" Then varURLString = varURLString & "&X3AL3=" & Server.UrlEncode(varArtistCriteria)
 If IsDBSomething(varFormatCriteria, "") <> "" Then varURLString = varURLString & "&X3FL3=" & Server.UrlEncode(varFormatCriteria)
 If IsDBSomething(varRecentCriteria, "") <> "" Then varURLString = varURLString & "&X3RL3=" & Server.UrlEncode(varRecentCriteria)
 If IsDBSomething(varRhythmCriteria, "") <> "" Then varURLString = varURLString & "&X3RYL3=" & Server.UrlEncode(varRhythmCriteria)
 If IsDBSomething(varlabelCriteria, "") <> "" Then varURLString = varURLString & "&X3LL3=" & Server.UrlEncode(varlabelCriteria)
 If IsDBSomething(varIncludeUsedCriteria, "") <> "" Then varURLString = varURLString & "&X3IUL3=" & Server.UrlEncode(varIncludeUsedCriteria)
 If IsDBSomething(varGenreCriteria, "") <> "" Then varURLString = varURLString & "&X3GL3=" & Server.UrlEncode(varGenreCriteria)
 If IsDBSomething(varYearCriteria, "") <> "" Then varURLString = varURLString & "&X3YL3=" & Server.UrlEncode(varYearCriteria)
 If IsDBSomething(varPriceCriteria, "") <> "" Then varURLString = varURLString & "&X3PRL3=" & Server.UrlEncode(varPriceCriteria)
 If IsDBSomething(varReggaeOrNonReggae, "") <> "" Then varURLString = varURLString & "&X3RONL3=" & Server.UrlEncode(varReggaeOrNonReggae)
 If IsDBSomething(varBSLTxt, "") <> "" Then varURLString = varURLString & "&BSLTxt=" & Server.UrlEncode(varBSLTxt)
 If IsDBSomething(varSongSearchSong, "") <> "" Then varURLString = varURLString & "&SSSTxt=" & Server.UrlEncode(varSongSearchSong)
 If IsDBSomething(varSongSearchFormat, "") <> "" Then varURLString = varURLString & "&SSFTxt=" & Server.UrlEncode(varSongSearchFormat)
 If IsDBSomething(varCustBoughtFormat, "") <> "" Then varURLString = varURLString & "&X3CBFL3=" & Server.UrlEncode(varCustBoughtFormat)
 If IsDBSomething(varCustBoughtDays, "") <> "" Then varURLString = varURLString & "&X3CBDL3=" & Server.UrlEncode(varCustBoughtDays)
 If IsDBSomething(varErnieMessageID, "") <> "" Then varURLString = varURLString & "&X3EMIDL3=" & Server.UrlEncode(varErnieMessageID)
 If varURLString = "" Then varURLString = "&" & varURLString

 'Cart--------------------------------------------------------------------------------------------------------------------------------------
 If varCartPage = 1 Then
  If Session("PowerUserName") <> "" And Session("StoreName") = "" Then%>
            <font class="a" style="font-size: 18px; color: #ff0000">No Customer Is Signed In At The Moment</font><br>
            <br>
            </font>
   <%End If
    If varXXRecordCount > 0 Then
     'Figure Weight
     varWeight = varWeightOfProductInGrams
     varWeightInGrams = varWeightOfProductInGrams
     If varWeight = 0 Then
     Else
      varWeightInDecimal = CDbl(varWeight) / 454
      varWeight = CDbl(varWeight) / 454
      Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
       SqlConnection.ClearPool(conn)
       conn.Open()
       Dim CMD_X As New SqlCommand("spGetWebSHIPX_PackagingWeight", conn)
       CMD_X.CommandType = Data.CommandType.StoredProcedure
       CMD_X.Parameters.AddWithValue("@WeightInGrams", varWeightInGrams)
       CMD_X.Parameters.AddWithValue("@CartName", NameOfCart)
       xx = CMD_X.ExecuteReader
       xx.Read()
       varWeightInGrams = varWeightInGrams + xx("PackagingWeight")
       varWeightInDecimal = varWeightInDecimal + CDbl(xx("PackagingWeight")) / 454
       varWeight = varWeight + CDbl(xx("PackagingWeight")) / 454
      End Using
      'Zip3 and Country
      Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
       SqlConnection.ClearPool(conn)
       conn.Open()
       Dim CMD_X As New SqlCommand("spGetCustomerDetailsByServerCounter", conn)
       CMD_X.CommandType = Data.CommandType.StoredProcedure
       CMD_X.Parameters.AddWithValue("@counter", IsSomething(Session("CustomerServerCounter"), 0))
       xx = CMD_X.ExecuteReader
       If Not xx.HasRows Then
        defaultPostalCode = "95762"
        defaultCountry = "USA"
        defaultStateProvince = "California"
        varZip3 = "957"
       Else
        xx.Read()
        defaultPostalCode = IsDBSomething(xx("PostalCode"), "")
        defaultCountry = xx("Country")
        defaultStateProvince = IsDBSomething(xx("StateProvince"), "")
        If Len(defaultPostalCode) < 3 Then
         varZip3 = ""
        Else
         varZip3 = Left(defaultPostalCode, 3)
        End If
       End If
      End Using
      'Shipping Cost ------------------------------------------------------------------
      varShippingCharge = 0
      varDHLInternationalZone = Z_SHIPX_FigureDHLInternationalZone(defaultCountry, strConnectionStringName)
      varUPSGroundZone = Z_SHIPX_FigureUPSGroundZone(defaultCountry, defaultPostalCode, defaultStateProvince)
      varFedExGroundZone = Z_SHIPX_FigureFedExGroundZone(defaultCountry, defaultPostalCode, defaultStateProvince)
      varUPSGroundCanadaZone = Z_SHIPX_FigureUPSGroundCanadaZone(defaultCountry, defaultPostalCode, strConnectionStringName)
      varPriorityMailZone = Z_SHIPX_FigurePriorityMailZone(defaultCountry, varZip3)
      varExpressMailZone = Z_SHIPX_FigureExpressMailZone(defaultCountry, defaultStateProvince, varPriceGroup, varZip3)
      varMediaMailZone = Z_SHIPX_FigureMediaMailZone(defaultCountry, defaultStateProvince, varPriceGroup, varZip3)
      varAirMailLetterPostZone = Z_SHIPX_FigureAirMailLetterPostZone(defaultCountry, strConnectionStringName)
      varAirParcelPostZone = Z_SHIPX_FigureAirParcelPostZone(defaultCountry, strConnectionStringName)
      varGlobalExpressZone = Z_SHIPX_FigureGlobalExpressZone(defaultCountry, strConnectionStringName)
      varFedExExpressZone = Z_SHIPX_FigureFedExExpressZone(defaultCountry, defaultPostalCode, defaultStateProvince)
      varFedExInternationalPriorityZone = Z_SHIPX_FigureFedExInternationalPriorityZone(defaultCountry, varZip3, strConnectionStringName)
      varFedExInternationalEconomyZone = Z_SHIPX_FigureFedExInternationalEconomyZone(defaultCountry, varZip3, strConnectionStringName)
      'First Class
      If Not varPriorityMailZone = "NA" Then
       varNumberOfBoxes = 1
       varWeightOfEachBox = varWeight
       varLastRateChecked = Z_SHIPX_FigureShippingCost("FC", NameOfCart, defaultPostalCode, CartTotal, varPriorityMailZone, defaultStateProvince, defaultCountry, varWeight, 1, varWeight, "No", varResidentialDelivery, varPriceGroup, strConnectionStringName)
       If varLastRateChecked <> -1 Then
        If varShippingCharge = 0 Or varLastRateChecked < varShippingCharge Then
         varShippingCharge = varLastRateChecked
        End If
       End If
      End If
      'Media Mail
      If Not varMediaMailZone = "NA" Then
       varNumberOfBoxes = Z_SHIPX_FigureNumberOfBoxes(defaultCountry, NameOfCart, "MM", varWeight, strConnectionStringName)
       varWeightOfEachBox = Int((varWeight / varNumberOfBoxes) + 0.9999)
       If varWeightOfEachBox < 1 Then varWeightOfEachBox = 1
       varLastRateChecked = Z_SHIPX_FigureShippingCost("MM", NameOfCart, defaultPostalCode, CartTotal, varMediaMailZone, defaultStateProvince, defaultCountry, varWeightOfEachBox, varNumberOfBoxes, varWeight, "No", varResidentialDelivery, varPriceGroup, strConnectionStringName)
       If varLastRateChecked <> -1 Then
        If varShippingCharge = 0 Or varLastRateChecked < varShippingCharge Then
         varShippingCharge = varLastRateChecked
        End If
       End If
      End If
      'priority Mail
      If Not varPriorityMailZone = "NA" Then
       varNumberOfBoxes = Z_SHIPX_FigureNumberOfBoxes(defaultCountry, NameOfCart, "PM", varWeight, strConnectionStringName)
       varWeightOfEachBox = Int((varWeight / varNumberOfBoxes) + 0.9999)
       If varWeightOfEachBox < 1 Then varWeightOfEachBox = 1
       varLastRateChecked = Z_SHIPX_FigureShippingCost("PM", NameOfCart, defaultPostalCode, CartTotal, varPriorityMailZone, defaultStateProvince, defaultCountry, varWeightOfEachBox, varNumberOfBoxes, varWeight, "No", varResidentialDelivery, varPriceGroup, strConnectionStringName)
       If varLastRateChecked <> -1 Then
        If varShippingCharge = 0 Or varLastRateChecked < varShippingCharge Then
         varShippingCharge = varLastRateChecked
        End If
       End If
      End If
      'Express Mail to Address
      If Not varExpressMailZone = "NA" Then
       varNumberOfBoxes = Z_SHIPX_FigureNumberOfBoxes(defaultCountry, NameOfCart, "EMA", varWeight, strConnectionStringName)
       varWeightOfEachBox = Int((varWeight / varNumberOfBoxes) + 0.9999)
       If varWeightOfEachBox < 1 Then varWeightOfEachBox = 1
       varLastRateChecked = Z_SHIPX_FigureShippingCost("EMA", NameOfCart, defaultPostalCode, CartTotal, varExpressMailZone, defaultStateProvince, defaultCountry, varWeightOfEachBox, varNumberOfBoxes, varWeight, "No", varResidentialDelivery, varPriceGroup, strConnectionStringName)
       If varLastRateChecked <> -1 Then
        If varShippingCharge = 0 Or varLastRateChecked < varShippingCharge Then
         varShippingCharge = varLastRateChecked
        End If
       End If
      End If
      'First Class Mail International
      If Not varAirMailLetterPostZone = "NA" And varWeightInDecimal <= 3 Then
       varNumberOfBoxes = Z_SHIPX_FigureNumberOfBoxes(defaultCountry, NameOfCart, "ALP", varWeightInDecimal, strConnectionStringName)
       varWeightOfEachBox = Int((varWeightInDecimal / varNumberOfBoxes) + 0.9999)
       varLastRateChecked = Z_SHIPX_FigureShippingCost("ALP", NameOfCart, defaultPostalCode, CartTotal, varAirMailLetterPostZone, defaultStateProvince, defaultCountry, varWeightInDecimal, varNumberOfBoxes, varWeightInDecimal, "No", varResidentialDelivery, varPriceGroup, strConnectionStringName)
       If varLastRateChecked <> -1 Then
        If varShippingCharge = 0 Or varLastRateChecked < varShippingCharge Then
         varShippingCharge = varLastRateChecked
        End If
       End If
      End If
      'Priority Mail International
      If Not varAirParcelPostZone = "NA" And varWeightInDecimal > 3 Then
       varNumberOfBoxes = Z_SHIPX_FigureNumberOfBoxes(defaultCountry, NameOfCart, "APP", varWeight, strConnectionStringName)
       varWeightOfEachBox = Int((varWeight / varNumberOfBoxes) + 0.9999)
       If varWeightOfEachBox < 1 Then varWeightOfEachBox = 1
       varLastRateChecked = Z_SHIPX_FigureShippingCost("APP", NameOfCart, defaultPostalCode, CartTotal, varAirParcelPostZone, defaultStateProvince, defaultCountry, varWeightOfEachBox, varNumberOfBoxes, varWeight, "No", varResidentialDelivery, varPriceGroup, strConnectionStringName)
       If varLastRateChecked <> -1 Then
        If varShippingCharge = 0 Or varLastRateChecked < varShippingCharge Then
         varShippingCharge = varLastRateChecked
        End If
       End If
      End If
      'Express Mail International
      If Not varGlobalExpressZone = "NA" Then
       varNumberOfBoxes = Z_SHIPX_FigureNumberOfBoxes(defaultCountry, NameOfCart, "GE", varWeight, strConnectionStringName)
       varWeightOfEachBox = Int((varWeight / varNumberOfBoxes) + 0.9999)
       If varWeightOfEachBox < 1 Then varWeightOfEachBox = 1
       varLastRateChecked = Z_SHIPX_FigureShippingCost("GE", NameOfCart, defaultPostalCode, CartTotal, varGlobalExpressZone, defaultStateProvince, defaultCountry, varWeightOfEachBox, varNumberOfBoxes, varWeight, "No", varResidentialDelivery, varPriceGroup, strConnectionStringName)
       If varLastRateChecked <> -1 Then
        If varShippingCharge = 0 Or varLastRateChecked < varShippingCharge Then
         varShippingCharge = varLastRateChecked
        End If
       End If
      End If
      'UPS Ground
      If Not varUPSGroundZone = "NA" Then
       varNumberOfBoxes = Z_SHIPX_FigureNumberOfBoxes(defaultCountry, NameOfCart, "UPSGR", varWeight, strConnectionStringName)
       varWeightOfEachBox = Int((varWeight / varNumberOfBoxes) + 0.9999)
       If varWeightOfEachBox < 1 Then varWeightOfEachBox = 1
       varLastRateChecked = Z_SHIPX_FigureShippingCost("UPSGR", NameOfCart, defaultPostalCode, CartTotal, varUPSGroundZone, defaultStateProvince, defaultCountry, varWeightOfEachBox, varNumberOfBoxes, varWeight, "No", varResidentialDelivery, varPriceGroup, strConnectionStringName)
       If varLastRateChecked <> -1 Then
        If varShippingCharge = 0 Or varLastRateChecked < varShippingCharge Then
         varShippingCharge = varLastRateChecked
        End If
       End If
      End If
      'DHL International Economy
      If Not varDHLInternationalZone = "NA" Then
       varNumberOfBoxes = 1
       varWeightOfEachBox = Int((varWeight / varNumberOfBoxes) + 0.9999)
       If varWeightOfEachBox < 1 Then varWeightOfEachBox = 1
       varLastRateChecked = Z_SHIPX_FigureShippingCost("DHLIE", NameOfCart, defaultPostalCode, CartTotal, varDHLInternationalZone, defaultStateProvince, defaultCountry, varWeightOfEachBox, varNumberOfBoxes, varWeight, "No", varResidentialDelivery, varPriceGroup, strConnectionStringName)
       If varLastRateChecked <> -1 Then
        If varShippingCharge = 0 Or varLastRateChecked < varShippingCharge Then
         varShippingCharge = varLastRateChecked
        End If
       End If
      End If
      'FedEx Ground
      If Not varFedExGroundZone = "NA" Then
       varNumberOfBoxes = Z_SHIPX_FigureNumberOfBoxes(defaultCountry, NameOfCart, "FEGR", varWeight, strConnectionStringName)
       varWeightOfEachBox = Int((varWeight / varNumberOfBoxes) + 0.9999)
       If varWeightOfEachBox < 1 Then varWeightOfEachBox = 1
       varLastRateChecked = Z_SHIPX_FigureShippingCost("FEGR", NameOfCart, defaultPostalCode, CartTotal, varFedExGroundZone, defaultStateProvince, defaultCountry, varWeightOfEachBox, varNumberOfBoxes, varWeight, "No", varResidentialDelivery, varPriceGroup, strConnectionStringName)
       If varLastRateChecked <> -1 Then
        If varShippingCharge = 0 Or varLastRateChecked < varShippingCharge Then
         varShippingCharge = varLastRateChecked
        End If
       End If
      End If
      'FedEx 2 Day
      If Not varFedExExpressZone = "NA" Then
       varNumberOfBoxes = Z_SHIPX_FigureNumberOfBoxes(defaultCountry, NameOfCart, "FE2D", varWeight, strConnectionStringName)
       varWeightOfEachBox = Int((varWeight / varNumberOfBoxes) + 0.9999)
       If varWeightOfEachBox < 1 Then varWeightOfEachBox = 1
       varLastRateChecked = Z_SHIPX_FigureShippingCost("FE2D", NameOfCart, defaultPostalCode, CartTotal, varFedExExpressZone, defaultStateProvince, defaultCountry, varWeightOfEachBox, varNumberOfBoxes, varWeight, "No", varResidentialDelivery, varPriceGroup, strConnectionStringName)
       If varLastRateChecked <> -1 Then
        If varShippingCharge = 0 Or varLastRateChecked < varShippingCharge Then
         varShippingCharge = varLastRateChecked
        End If
       End If
      End If
      'FedEx International Economy
      If Not varFedExInternationalEconomyZone = "NA" Then
       varNumberOfBoxes = Z_SHIPX_FigureNumberOfBoxes(defaultCountry, NameOfCart, "FEINTE", varWeight, strConnectionStringName)
       varWeightOfEachBox = Int((varWeight / varNumberOfBoxes) + 0.9999)
       If varWeightOfEachBox < 1 Then varWeightOfEachBox = 1
       varLastRateChecked = Z_SHIPX_FigureShippingCost("FEINTE", NameOfCart, defaultPostalCode, CartTotal, varFedExInternationalEconomyZone, defaultStateProvince, defaultCountry, varWeightOfEachBox, varNumberOfBoxes, varWeight, "No", varResidentialDelivery, varPriceGroup, strConnectionStringName)
       If varLastRateChecked <> -1 Then
        If varShippingCharge = 0 Or varLastRateChecked < varShippingCharge Then
         varShippingCharge = varLastRateChecked
        End If
       End If
      End If
      'FedEx International Priority
      If Not varFedExInternationalPriorityZone = "NA" Then
       varNumberOfBoxes = Z_SHIPX_FigureNumberOfBoxes(defaultCountry, NameOfCart, "FEINTP", varWeight, strConnectionStringName)
       varWeightOfEachBox = Int((varWeight / varNumberOfBoxes) + 0.9999)
       If varWeightOfEachBox < 1 Then varWeightOfEachBox = 1
       varLastRateChecked = Z_SHIPX_FigureShippingCost("FEINTP", NameOfCart, defaultPostalCode, CartTotal, varFedExInternationalPriorityZone, defaultStateProvince, defaultCountry, varWeightOfEachBox, varNumberOfBoxes, varWeight, "No", varResidentialDelivery, varPriceGroup, strConnectionStringName)
       If varLastRateChecked <> -1 Then
        If varShippingCharge = 0 Or varLastRateChecked < varShippingCharge Then
         varShippingCharge = varLastRateChecked
        End If
       End If
      End If

      varShippingChargeText = FormatCurrency(FormatNumber(varShippingCharge, 2), 2).ToString
      varTotalText = FormatCurrency(CartTotal + FormatNumber(varShippingCharge, 2), 2).ToString
     End If

     'CART TOP OF PAGE --------------------------------------------------------------------------------%>
            <table bgcolor="D4DBD4" frame="none" cellpadding="0" cellspacing="0" width="1250" height="16" align="center" border="0">
                <tr>
                    <td height="16"></td>
                </tr>
            </table>
            <table bgcolor="D4DBD4" cellpadding="0" cellspacing="0" width="1250" align="center" border="0" style="border-collapse: collapse">
                <tr>
                    <td height="80" valign="top" width="195"></td>
                    <td valign="top" align="center" width="156">
                        <table border="0" cellspacing="0" cellpadding="0" width="156" style="border-collapse: collapse">
                            <div id="ClickToViewDiv" style="display: none; position: absolute; margin-top: 26px; width: 75px; height: 55px; background-color: #e4EAE4">
                                <img src="<%=AssetsPath()%>/click-to-view.gif" title="Click to view cart totals" style="cursor: pointer; margin-top: 3px" onclick="window.location='/Home.aspx?TabH=Cart'" />
                            </div>
                            <tr>
                                <td colspan="2" nowrap height="23" valign="middle" style="border-top: solid 1px #846A29; border-left: solid 1px #846A29; border-right: solid 1px #846A29"
                                    bgcolor="#7D947B" align="center" width="100%"><strong><font class="a" style="font-size: 14px; color: #ffffff">Cart Totals</font></strong>
                                </td>
                            </tr>
                            <tr>
                                <td height="20" width="50%" bgcolor="E4EAE4" valign="middle" align="right" style="border-left: solid 1px; border-left-color: #846A29"><font class="a" style="font-size: 14px">Product:</font>
                                </td>
                                <td valign="middle" bgcolor="E4EAE4" align="right" width="50%" style="border-right: solid 1px; border-right-color: #846A29; padding-right: 2px">
                                    <font class="a" style="font-size: 14px"><span name="Xproduct" id="Xproduct">&nbsp;<%=formatcurrency(CartTotal,2)%></span>&nbsp;</font>
                                </td>
                            </tr>
                            <tr>
                                <td height="16" width="50%" bgcolor="E4EAE4" valign="middle" align="right" style="border-left: solid 1px; border-left-color: #846A29"><font class="a" style="cursor: pointer; font-size: 14px">Shipping:</font>
                                </td>
                                <td valign="middle" bgcolor="E4EAE4" align="right" width="50%" style="border-right: solid 1px; border-right-color: #846A29; padding-right: 2px"><font class="a" style="font-size: 14px"><span name="Xshippingcharge" id="Xshippingcharge">&nbsp;<%=varShippingChargeText%></span>&nbsp;</font>
                                </td>
                            </tr>
                            <tr>
                                <td height="23" width="50%" align="right" bgcolor="E4EAE4" valign="middle" style="border-bottom: solid 1px; border-bottom-color: #846A29; border-left: solid 1px; border-left-color: #846A29"><font class="a" style="font-size: 14px">Total:</font>
                                </td>
                                <td valign="middle" bgcolor="E4EAE4" align="right" width="50%" style="border-bottom: solid 1px; border-bottom-color: #846A29; border-bottom: solid 1px; border-bottom-color: #846A29; border-right: solid 1px; border-right-color: #846A29; padding-right: 2px"><font class="a" style="font-size: 14px"><span name="Xtotal" id="Xtotal" style="color: 000000">&nbsp;<%=varTotalText%></span>&nbsp;</font>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td valign="middle" align="center" width="7"></td>
                    <td valign="top" align="left" width="195">
                        <input type="hidden" name="OrderTotal" id="OrderTotal" value="<%=CartTotal%>">
                        <%If Session("CustomerServerCounter") = "" Then
   Response.Write("<input alt style=""cursor:pointer""ONMOUSEOVER=""fov(this,'checkout20')"" onmouseout=""fou(this,'checkout20')"" ONCLICK=""CheckOut(0," & RandomNumbersFunction(8) & ")"" type=""image"" src=""" + AssetsPath() + "/checkout20.gif"">")
  Else
   Response.Write("<input alt style=""cursor:pointer""ONMOUSEOVER=""fov(this,'checkout20')"" onmouseout=""fou(this,'checkout20')"" ONCLICK=""CheckOut(1," & RandomNumbersFunction(8) & ")"" type=""image"" src=""" + AssetsPath() + "/checkout20.gif"">")
  End If%>
                    </td>
                    <td valign="middle" align="center" width="7"></td>
                    <td valign="top" align="left" width="89"></td>
                    <td valign="middle" align="center" width="7"></td>
                    <td valign="top" align="center" width="140"></td>
                    <td width="488" valign="top" align="left">
                        <%  If Session("SuperPoweruserName") <> "" Then%>
                        <img alt="" src="<%=AssetsPath()%>/empty-the-cart.gif" style="cursor: pointer; margin-left: 240px" onclick="emptyTheCart()">
                        <%  End If%>
                    </td>
                </tr>
            </table>
            <%

'Pages for Cart%>
            <table bgcolor="D4DBD4" frame="none" cellpadding="0" cellspacing="0" width="100%" align="center" border="0">
                <tr>
                    <td align="center" valign="bottom" height="23" width="1250" style="padding-bottom: 4px">
                        <%If varXXRecordCount>NumberOfRecordsLimit then%>
                        <%StartingRecord=1
   n=1%>
                        <img alt="" src="<%=AssetsPath()%>/pa2.gif">
                        <%Do
     If n = Int(varPageOn) Or (varPageOn = "" And page1on <> 1) Then
      page1on = 1%>
                        <img alt="" title="Current page" class="a" src="<%=AssetsPath()%>/px<%=n%>h.gif">
                        <% Else%>
                        <a href="/home.aspx?X3QT=PageSearchForCart&TabH=Cart&X3SO=<%=varSortOrder%>&X3SR=<%=StartingRecord%>&X3P=<%=n%><%=varURLString%>" title="Go to page <%=n%>">
                            <img alt="" class="a" src="<%=AssetsPath()%>/px<%=n%>.gif"></a>
                        <% End If
     n = n + 1
     StartingRecord = StartingRecord + NumberOfRecordsLimit
     If StartingRecord > varXXRecordCount Or n > 99 Then Exit Do
    Loop%>
                    </td>
                </tr>
            </table>
            <%end if%>
            <%else  'Empty Cart%>
            <table bgcolor="D4DBD4" frame="none" cellpadding="10" cellspacing="0" width="100%" align="center" border="0">
                <tr valign="middle">
                    <td width="1250" valign="middle" align="center">
                        <br>
                        <p class="b12" style="font-weight: 600; font-size: 18px">Your Shopping Cart Is Empty</p>
                        <% If Session("PriceGroup") <> "" And Left(Session("CustomerID"), 2) <> "NE" And Session("StoreName") <> "" Then%>
                        <br>
                        <br>
                        <a href="/home.aspx?X3QT=Backorders">
                            <img alt onmouseover="fov(this,'backordersinstock9')" onmouseout="fou(this,'backordersinstock9')" style="border: 0px" title="Click here to order items you previously did not get but are now back in stock." src="<%=AssetsPath()%>/backordersinstock9.gif"></a>
                        <% End If%>
                        <%if session("PoweruserName") <> "" Or session("PriceGroup") = "" Or session("PriceGroup") = "RetailPrice" Then%>
                        <br>
                        <br>
                        <p class="b12"><a title="Click here to retrieve a saved shopping cart." style="font-size: 13px" href="/Options.aspx">Sign in to view YOUR ACCOUNT shopping cart</a></p>
                        <%end if%>
                        <br>
                        <br>
                    </td>
                </tr>
            </table>
            <%end if%>
            <%else 'Not Cart-----------------------------------------------------------------------------------------------------------

  'You Searched For%>
            <%If varQueryType = "NewSearch" Then
   varNumberOfCriteria = 0
   If varYouSearchedForArtist <> "" Then varNumberOfCriteria = varNumberOfCriteria + 1
   If varYouSearchedForFormat <> "" Then varNumberOfCriteria = varNumberOfCriteria + 1
   If varYouSearchedForRecent <> "" Then varNumberOfCriteria = varNumberOfCriteria + 1
   If varYouSearchedForYear <> "" Then varNumberOfCriteria = varNumberOfCriteria + 1
   If varYouSearchedForPrice <> "" Then varNumberOfCriteria = varNumberOfCriteria + 1
   If varYouSearchedForGenre <> "" Then varNumberOfCriteria = varNumberOfCriteria + 1
   If varYouSearchedForLabel <> "" Then varNumberOfCriteria = varNumberOfCriteria + 1
   If varYouSearchedForIncludeUsed <> "" Then varNumberOfCriteria = varNumberOfCriteria + 1
  Else
   varNumberOfCriteria = 0
   varYouSearchedForFormat = ""
   varYouSearchedForRecent = ""
   varYouSearchedForYear = ""
   varYouSearchedForPrice = ""
   varYouSearchedForGenre = ""
   varYouSearchedForLabel = ""
   varYouSearchedForIncludeUsed = ""
  End If%>
            <table bgcolor="D4DBD4" frame="none" cellpadding="0" cellspacing="0" width="1250" align="center" border="0">
                <tr>
                    <td height="30">
                        <div style="margin-left: 215px; margin-top: -20px">
                            <img alt="" style="cursor: pointer" onclick="varGenreArtistsStartRecord=1;varGenreArtistsSort='P';genreSearch('qqgs','Reggae','-')" src="<%=AssetsPath()%>/g-reggae.gif" onmouseover="fov(this,'g-reggae')" onmouseout="fou(this,'g-reggae')"><img alt="" style="cursor: pointer" onclick="varGenreArtistsStartRecord=1;varGenreArtistsSort='P';genreSearch('qqgs','Rock','-')" src="<%=AssetsPath()%>/g-rock.gif" onmouseover="fov(this,'g-rock')" onmouseout="fou(this,'g-rock')"><img alt="" style="cursor: pointer" onclick="varGenreArtistsStartRecord=1;varGenreArtistsSort='P';genreSearch('qqgs','Jazz','-')" src="<%=AssetsPath()%>/g-jazz.gif" onmouseover="fov(this,'g-jazz')" onmouseout="fou(this,'g-jazz')"><img alt="" style="cursor: pointer" onclick="varGenreArtistsStartRecord=1;varGenreArtistsSort='P';genreSearch('qqgs','Soul','-')" src="<%=AssetsPath()%>/g-soul.gif" onmouseover="fov(this,'g-soul')" onmouseout="fou(this,'g-soul')"><img alt="" style="cursor: pointer" onclick="varGenreArtistsStartRecord=1;varGenreArtistsSort='P';genreSearch('qqgs','Blues','-')" src="<%=AssetsPath()%>/g-blues.gif" onmouseover="fov(this,'g-blues')" onmouseout="fou(this,'g-blues')"><img alt="" style="cursor: pointer" onclick="varGenreArtistsStartRecord=1;varGenreArtistsSort='P';genreSearch('qqgs','Electronic','-')" src="<%=AssetsPath()%>/g-electronic.gif" onmouseover="fov(this,'g-electronic')" onmouseout="fou(this,'g-electronic')"><img alt="" style="cursor: pointer" onclick="varGenreArtistsStartRecord=1;varGenreArtistsSort='P';genreSearch('qqgs','Pop','-')" src="<%=AssetsPath()%>/g-pop.gif" onmouseover="fov(this,'g-pop')" onmouseout="fou(this,'g-pop')"><img alt="" style="cursor: pointer" onclick="varGenreArtistsStartRecord=1;varGenreArtistsSort='P';varGenreGenresStartRecord=1;MoreGenresSearch('qqmgs','-')" src="<%=AssetsPath()%>/g-all-genres.gif" onmouseover="fov(this,'g-all-genres')" onmouseout="fou(this,'g-all-genres')"><img alt="" style="cursor: pointer" onclick="AllArtistsSearch('qqaa','-')" src="<%=AssetsPath()%>/g-all-artists.gif" onmouseover="fov(this,'g-all-artists')" onmouseout="fou(this,'g-all-artists')"><img alt="" style="cursor: pointer" onclick="AllLabelsSearch('qqal','-')" src="<%=AssetsPath()%>/g-all-labels.gif" onmouseover="fov(this,'g-all-labels')" onmouseout="fou(this,'g-all-labels')">
                        </div>
                    </td>
                </tr>
            </table>
            <%if varDefaultHomePage<>1 and varDisplayLikeHomePage=0 then%>
            <%'You Searched For Artist%>
            <table bgcolor="D4DBD4" frame="none" cellpadding="0" cellspacing="0" width="1250" align="center" border="0">
                <tr>
                    <td width="90"></td>
                    <td height="25" width="1160" align="left" valign="middle">
                        <%if varYouSearchedForArtist<>"" then%>
                        <p class="ysf" style="vertical-align: middle">"<%=varYouSearchedForArtist%>"&nbsp;<%=NumberOfItemsFound%></p>
                        <%  Else%>
                        <p class="ysf" style="vertical-align: middle"><%=NumberOfItemsFound%> For:</p>
                        <%  End If%>
                    </td>
                </tr>
            </table>
            <%end if%>
            <%'You Searched For Format%>
            <%if varYouSearchedForFormat<>"" then%>
            <table bgcolor="D4DBD4" frame="none" cellpadding="0" cellspacing="0" width="1250" align="center" border="0">
                <tr>
                    <td width="90"></td>
                    <td height="25" width="1160" align="left" valign="middle">
                        <% If varNumberOfCriteria > 1 Then%>
                        <img alt="" title="Perform the search again, but without this search filter criteria" style="vertical-align: middle; cursor: pointer" onmouseover="fov(this,'x-11')" onmouseout="fou(this,'x-11')" onclick="DC('Format')" src="<%=AssetsPath()%>/x-11.gif">
                        <% End If%>
                        <p class="sc" style="vertical-align: middle">Format = <%=varYouSearchedForFormat%></p>
                    </td>
                </tr>
            </table>
            <%  End If%>
            <%'You Searched For Recent%>
            <%if varYouSearchedForRecent<>"" then%>
            <table bgcolor="D4DBD4" frame="none" cellpadding="0" cellspacing="0" width="1250" align="center" border="0">
                <tr>
                    <td width="90"></td>
                    <td height="25" width="1160" align="left" valign="middle">
                        <%if varNumberOfCriteria>1 then%>
                        <img alt="" title="Perform the search again, but without this search filter criteria" style="vertical-align: middle; cursor: pointer" onmouseover="fov(this,'x-11')" onmouseout="fou(this,'x-11')" onclick="DC('Recent')" src="<%=AssetsPath()%>/x-11.gif">
                        <%end if%>
                        <p class="sc" style="vertical-align: middle">Recent = <%=varYouSearchedForRecent%></p>
                    </td>
                </tr>
            </table>
            <%  End If%>
            <%'You Searched For Year%>
            <%if varYouSearchedForYear<>"" then%>
            <table bgcolor="D4DBD4" frame="none" cellpadding="0" cellspacing="0" width="1250" align="center" border="0">
                <tr>
                    <td width="90"></td>
                    <td height="25" width="1160" align="left" valign="middle">
                        <%if varNumberOfCriteria>1 then%>
                        <img alt="" title="Perform the search again, but without this search filter criteria" style="vertical-align: middle; cursor: pointer" onmouseover="fov(this,'x-11')" onmouseout="fou(this,'x-11')" onclick="DC('Year')" src="<%=AssetsPath()%>/x-11.gif">
                        <%end if%>
                        <p class="sc" style="vertical-align: middle">Year = <%=varYouSearchedForYear%></p>
                    </td>
                </tr>
            </table>
            <%  End If%>
            <%'You Searched For Price%>
            <%if varYouSearchedForPrice<>"" then%>
            <table bgcolor="D4DBD4" frame="none" cellpadding="0" cellspacing="0" width="1250" align="center" border="0">
                <tr>
                    <td width="90"></td>
                    <td height="25" width="1160" align="left" valign="middle">
                        <%if varNumberOfCriteria>1 then%>
                        <img alt="" title="Perform the search again, but without this search filter criteria" style="vertical-align: middle; cursor: pointer" onmouseover="fov(this,'x-11')" onmouseout="fou(this,'x-11')" onclick="DC('Price')" src="<%=AssetsPath()%>/x-11.gif">
                        <%end if%>
                        <p class="sc" style="vertical-align: middle">Price = <%=varYouSearchedForPrice%></p>
                    </td>
                </tr>
            </table>
            <%  End If%>
            <%'You Searched For Genre%>
            <%if varYouSearchedForGenre<>"" then%>
            <table bgcolor="D4DBD4" frame="none" cellpadding="0" cellspacing="0" width="1250" align="center" border="0">
                <tr>
                    <td width="90"></td>
                    <td height="25" width="1160" align="left" valign="middle">
                        <%if varNumberOfCriteria>1 then%>
                        <img alt="" title="Perform the search again, but without this search filter criteria" style="vertical-align: middle; cursor: pointer" onmouseover="fov(this,'x-11')" onmouseout="fou(this,'x-11')" onclick="DC('Genre')" src="<%=AssetsPath()%>/x-11.gif">
                        <%end if%>
                        <p class="sc" style="vertical-align: middle">Genre = <%=varYouSearchedForGenre%></p>
                    </td>
                </tr>
            </table>
            <%  End If%>
            <%'You Searched For Label%>
            <%if varYouSearchedForLabel<>"" then%>
            <table bgcolor="D4DBD4" frame="none" cellpadding="0" cellspacing="0" width="1250" align="center" border="0">
                <tr>
                    <td width="90"></td>
                    <td height="25" width="1160" align="left" valign="middle">
                        <%if varNumberOfCriteria>1 then%>
                        <img alt="" title="Perform the search again, but without this search filter criteria" style="vertical-align: middle; cursor: pointer" onmouseover="fov(this,'x-11')" onmouseout="fou(this,'x-11')" onclick="DC('Label')" src="<%=AssetsPath()%>/x-11.gif">
                        <%end if%>
                        <p class="sc" style="vertical-align: middle">Label = <%=varYouSearchedForLabel%></p>
                    </td>
                </tr>
            </table>
            <%  End If%>
            <%'You Searched For IncludeUsed%>
            <%if varYouSearchedForIncludeUsed<>"" and varYouSearchedForIncludeUsed<>"New & Used" then%>
            <table bgcolor="D4DBD4" frame="none" cellpadding="0" cellspacing="0" width="1250" align="center" border="0">
                <tr>
                    <td width="90"></td>
                    <td height="25" width="1160" align="left" valign="middle">
                        <%if varNumberOfCriteria>1 then%>
                        <img alt="" title="Perform the search again, but without this search filter criteria" style="vertical-align: middle; cursor: pointer" onmouseover="fov(this,'x-11')" onmouseout="fou(this,'x-11')" onclick="DC('IncludeUsed')" src="<%=AssetsPath()%>/x-11.gif">
                        <%end if%>
                        <%if varYouSearchedForIncludeUsed="New Items Only" then%>
                        <p class="sc" style="vertical-align: middle; background-color: #ffff00; padding: 1px">&nbsp;Displaying NEW Items Only&nbsp;</p>
                        <%elseif varYouSearchedForIncludeUsed="Used Items Only" then%>
                        <p class="sc" style="vertical-align: middle; background-color: #ffff00; padding: 1px">&nbsp;Displaying USED Items Only&nbsp;</p>
                        <%end if%>
                    </td>
                </tr>
            </table>
            <%end if%>
            <%'Pages
 if varDefaultHomePage=1 or varDisplayLikeHomePage=1 then
  varXXRecordCount=0
 end if
 if varDefaultHomePage=0 and varDisplayLikeHomePage=0 and varXXRecordCount>NumberOfRecordsLimit then%>
            <table bgcolor="D4DBD4" frame="none" cellpadding="0" cellspacing="0" width="100%" align="center" border="0">
                <tr>
                    <td class="p1" align="center" valign="top" height="29" width="1250">
                        <% If varXXRecordCount / NumberOfRecordsLimit >= 160 Then%>
                        <%StartingRecord = 1
    n = 1%>
                        <p class="page">PAGE: </p>
                        <% Do
        If n = Int(varPageOn) Or (varPageOn = "" And page1on <> 1) Then
         page1on = 1%>
                        <p class="page" style="color: #B80202; font-weight: 600; font-size: 14px; margin-left: 2px"><%=n%></strong></p>
                        <%  Else%>
                        <a class="pages" style="margin-left: 2px" href="/home.aspx?X3QT=PageSearch&X3SO=<%=varSortOrder%>&X3SR=<%=StartingRecord%>&X3P=<%=n%><%=varURLString%>" title="Go to page <%=n%>"><%=n%></a>
                        <%  End If
        n = n + 1
        StartingRecord = StartingRecord + NumberOfRecordsLimit
        If StartingRecord > varXXRecordCount Then Exit Do
       Loop%>
                        <%else%>
                        <%StartingRecord=1
   n=1%>
                        <img class="pa" alt="" src="<%=AssetsPath()%>/pa2.gif">
                        <%do
    if n=int(varPageOn) Or (varPageOn = "" And page1on <> 1) Then
     page1on = 1%>
                        <img alt="" title="Current page" src="<%=AssetsPath()%>/px<%=n%>h.gif">
                        <%  Else%>
                        <a href="/home.aspx?X3QT=PageSearch&X3SO=<%=varSortOrder%>&X3SR=<%=StartingRecord%>&X3P=<%=n%><%=varURLString%>" title="Go to page <%=n%>">
                            <img alt="" class="a" src="<%=AssetsPath()%>/px<%=n%>.gif"></a>
                        <%  End If
    n = n + 1
    StartingRecord = StartingRecord + NumberOfRecordsLimit
    If StartingRecord > varXXRecordCount Or n > 99 Then Exit Do
   Loop%>
                        <%end if%>
                        <%else%>
                        <table bgcolor="D4DBD4" frame="none" cellpadding="0" cellspacing="0" width="100%" align="center" border="0">
                            <tr>
                                <td align="center" valign="bottom" height="16" width="1250">
                                    <%end if
 if varSingleItemFound=1 then
  NumberOfItemsFound=""
 end if%>
                                </td>
                            </tr>
                            <%'Backorders Help%>
                            <%if varQueryType="Backorders" then%>
                            <tr>
                                <td align="left">
                                    <% If varXXRecordCount > 0 Then%>
                                    <img alt="" onclick="ShowBODiv('BODiv')" title="Click here for a detailed explanation of how backorders work." style="cursor: pointer" src="<%=AssetsPath()%>/boinfo2.gif">
                                    <%  End If%>
                                </td>
                            </tr>
                            <div class="bo" id="BODiv" style="text-align: left" name="BODiv">
                                <img alt="" class="a" src="<%=AssetsPath()%>/close2.gif" onclick="HideBODiv('BODiv')">
                                <strong>
                                    <p class="b12">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;BACKORDER INFORMATION:</p>
                                </strong>
                                <br>
                                <br>
                                <p class="b12">
                                    This page shows items you previously ordered and did not get, but are now back in stock and available for re-order.  None of these items will be added to your order unless you re-order them here.<br>
                                    <br>
                                    To re-order an item now, click on the
                                    <img alt="" src="<%=AssetsPath()%>/aa5.gif">
                                    button just like you would order any item.<br>
                                    <br>
                                    To delete an item from your backorders list, click on the
                                    <img alt="" src="<%=AssetsPath()%>/xb2.gif">.<br>
                                    <br>
                                </p>
                            </div>
                            <%end if%>
                        </table>
                        <%end if%>
                    </td>
            </table>
            <%
 Dim varIDOn As Integer = 0
 Dim varHowManyRendered As Integer = 0
 Dim varUsingThisID As Integer = 0
 Dim varRightWidth As Integer = 0
 '                                                                                                                                         
 '   DEFAULT HOME PAGE                                                                                                                     
 '                                                                                                                                         
 If varDefaultHomePage=1 Then
  varIDOn = 0

  'Best Selling LPs-------------------------------------------------
  SearchQueryString = "select top 6 * from inventory" _
   & " where Format='LP'" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y' and (UsedItem is null or UsedItem='n')" _
   & " order by [saleslast30days] desc, Inventory desc,id desc"
  Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
   SqlConnection.ClearPool(conn)
   conn.Open()
   Dim CMD_X As New SqlCommand(SearchQueryString, conn)
   CMD_X.CommandType = Data.CommandType.Text
   xx = CMD_X.ExecuteReader
            %>
            <p style="background-color: #fff">Best Selling LPs:[<%=SearchQueryString %>]</p>

            <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
                <tr>
                    <td height="60" align="left" valign="bottom" width="1250">
                        <img src="<%=AssetsPath()%>/b-lps5.gif" style="margin-left: 24px; margin-bottom: 0px; vertical-align: bottom; cursor: pointer" onclick="showMore('Best-Selling-LPs','-')" onmouseover="fov(this,'b-lps5')" onmouseout="fou(this,'b-lps5')">
                        <img src="<%=AssetsPath()%>/show-all.gif" style="margin-left: 10px; margin-bottom: 4px; vertical-align: bottom; cursor: pointer" onclick="showMore('Best-Selling-LPs','-')">
                    </td>
                </tr>
            </table>
            <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
                <tr>
                    <td height="8" align="left" valign="middle" width="1250"></td>
                </tr>
            </table>
            <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
                <tr>
                    <td width="9"></td>
                    <%
   n=0
   Do While xx.Read
    n=n+1
    varIDOn=varIDOn+1
    arrayIDs(varIDOn)=xx("ID")
    Call RenderGridItem(varSearchID, xx("RhythmName"), xx("Genre1"), xx("YearFrom"), xx("YearTo"), xx("Label"), xx("ItemFeatures1"), xx("ItemFeatures2"), xx("ItemFeatures3"), xx("ItemFeatures4"), xx("ItemFeatures5"), xx("ItemFeatures6"), xx("ItemFeatures7"), xx("ItemFeatures8"), xx("ItemFeatures9"), xx("ItemFeatures10"), xx("TracksGroup"), varQueryType, 1, xx("ID"), xx("ArtistTitle"), xx("Format"), xx("StorePrice"), xx("RetailPrice"), xx("Sale_WholesalePrice"), xx("Sale_WholesaleEndDate"), xx("Sale_RetailPrice"), xx("Sale_RetailEndDate"), xx("UsedItem"), xx("MP3FileCompleted"), NameOfCart, strConnectionStringName)
    If n = 4 Then Exit Do
   Loop
  End Using
  varRightWidth = ((4 - n) * 308) + 9%>
        </td>
        <td width="<%=varRightWidth%>" style="vertical-align: top; text-align: left"></td>
        </tr>
    </table>
    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td height="30" align="left" valign="middle" width="1250"></td>
        </tr>
    </table>
    <%'New Release LPs-------------------------------------------------
     SearchQueryString = "select top 24 * from inventory" _
    & " where Format='LP'" _
    & " and inventory>0 and deleted='n' and ShowOnWebsite='y' and (UsedItem is null or UsedItem='n')" _
    & " order by [InStockDate] desc, id desc"
     Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
      SqlConnection.ClearPool(conn)
      conn.Open()
      Dim CMD_X As New SqlCommand(SearchQueryString, conn)
      CMD_X.CommandType = Data.CommandType.Text
      xx = CMD_X.ExecuteReader
    %>
    <p style="background-color: #fff">New Release LPs:[<%=SearchQueryString %>]</p>

    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td height="60" align="left" valign="bottom" width="1250">
                <img src="<%=AssetsPath()%>/nr-lps5.gif" style="margin-left: 24px; vertical-align: bottom; margin-bottom: 0px; cursor: pointer" onclick="showMore('New-Release-LPs','-')" onmouseover="fov(this,'nr-lps5')" onmouseout="fou(this,'nr-lps5')">
                <img src="<%=AssetsPath()%>/show-all.gif" style="margin-left: 10px; vertical-align: bottom; margin-bottom: 4px; cursor: pointer" onclick="showMore('New-Release-LPs','-')">
            </td>
        </tr>
    </table>
    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td height="6" align="left" valign="middle" width="1250"></td>
        </tr>
    </table>
    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td width="9"></td>
            <%
   varHowManyRendered=0
   do While xx.read
    varUsingThisID=0
    for x=1 to varIDOn
     if arrayIDs(x)=xx("ID") then
      varUsingThisID=1
     end if
    next
    if varUsingThisID=0 then
     varIDOn=varIDOn+1
     arrayIDs(varIDOn)=xx("ID")
     Call RenderGridItem(varSearchID, xx("RhythmName"), xx("Genre1"), xx("YearFrom"), xx("YearTo"), xx("Label"), xx("ItemFeatures1"), xx("ItemFeatures2"), xx("ItemFeatures3"), xx("ItemFeatures4"), xx("ItemFeatures5"), xx("ItemFeatures6"), xx("ItemFeatures7"), xx("ItemFeatures8"), xx("ItemFeatures9"), xx("ItemFeatures10"), xx("TracksGroup"), varQueryType, 1, xx("ID"), xx("ArtistTitle"), xx("Format"), xx("StorePrice"), xx("RetailPrice"), xx("Sale_WholesalePrice"), xx("Sale_WholesaleEndDate"), xx("Sale_RetailPrice"), xx("Sale_RetailEndDate"), xx("UsedItem"), xx("MP3FileCompleted"), NameOfCart, strConnectionStringName)
     varHowManyRendered =varHowManyRendered+1
    end if
    if varHowManyRendered=4 then exit do
   loop
  End Using
  varRightWidth = 9%>
 </td><td width="<%=varRightWidth%>" style="vertical-align: top; text-align: left"></td>
        </tr>
    </table>
    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td height="30" align="left" valign="middle" width="1250"></td>
        </tr>
    </table>
    <%'Back In Stock LPs-------------------------------------------------
 SearchQueryString = "select top 24 * from inventory" _
& " where Format='LP'" _
& " and inventory>0 and deleted='n' and ShowOnWebsite='y' and (UsedItem is null or UsedItem='n')" _
& " order by [BackInStockDate] desc, id desc"
 Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
  SqlConnection.ClearPool(conn)
  conn.Open()
  Dim CMD_X As New SqlCommand(SearchQueryString, conn)
  CMD_X.CommandType = Data.CommandType.Text
  xx = CMD_X.ExecuteReader
  If xx.HasRows Then%>
    <p style="background-color: #fff">Back In Stock LPs:[<%=SearchQueryString %>]</p>

    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td height="60" align="left" valign="bottom" width="1250">
                <img src="<%=AssetsPath()%>/bis-lps6.gif" style="margin-left: 24px; vertical-align: bottom; margin-bottom: 0px; cursor: pointer" onclick="showMore('Back-In-Stock-LPs','-')" onmouseover="fov(this,'bis-lps6')" onmouseout="fou(this,'bis-lps6')">
                <img src="<%=AssetsPath()%>/show-all.gif" style="margin-left: 10px; vertical-align: bottom; margin-bottom: 4px; cursor: pointer" onclick="showMore('Back-In-Stock-LPs','-')">
            </td>
        </tr>
    </table>
    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td height="8" align="left" valign="middle" width="1250"></td>
        </tr>
    </table>
    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td width="9"></td>
            <%
   varHowManyRendered=0
   do While xx.read
    varUsingThisID=0
    for x=1 to varIDOn
     if arrayIDs(x)=xx("ID") then
      varUsingThisID=1
     end if
    next
    if varUsingThisID=0 then
     varIDOn=varIDOn+1
     arrayIDs(varIDOn)=xx("ID")
     Call RenderGridItem(varSearchID, xx("RhythmName"), xx("Genre1"), xx("YearFrom"), xx("YearTo"), xx("Label"), xx("ItemFeatures1"), xx("ItemFeatures2"), xx("ItemFeatures3"), xx("ItemFeatures4"), xx("ItemFeatures5"), xx("ItemFeatures6"), xx("ItemFeatures7"), xx("ItemFeatures8"), xx("ItemFeatures9"), xx("ItemFeatures10"), xx("TracksGroup"), varQueryType, 1, xx("ID"), xx("ArtistTitle"), xx("Format"), xx("StorePrice"), xx("RetailPrice"), xx("Sale_WholesalePrice"), xx("Sale_WholesaleEndDate"), xx("Sale_RetailPrice"), xx("Sale_RetailEndDate"), xx("UsedItem"), xx("MP3FileCompleted"), NameOfCart, strConnectionStringName)
     varHowManyRendered =varHowManyRendered+1
    end If
    If varHowManyRendered = 4 Then Exit Do
   Loop
   varRightWidth = ((4 - varHowManyRendered) * 308) + 9%>
 </td><td width="<%=varRightWidth%>" style="vertical-align: top; text-align: left"></td>
        </tr>
    </table>
    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td height="30" align="left" valign="middle" width="1250"></td>
        </tr>
    </table>
    <%End if
 End using%>
    <%'Best Selling CDs-------------------------------------------------
     SearchQueryString = "select top 6 * from inventory" _
      & " where Format='CD'" _
      & " and inventory>0 and deleted='n' and ShowOnWebsite='y' and (UsedItem is null or UsedItem='n')" _
      & " order by [saleslast30days] desc, Inventory desc,id desc"
     Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
      SqlConnection.ClearPool(conn)
      conn.Open()
      Dim CMD_X As New SqlCommand(SearchQueryString, conn)
      CMD_X.CommandType = Data.CommandType.Text
      xx = CMD_X.ExecuteReader
    %>
    <p style="background-color: #fff">Best Selling CDs:[<%=SearchQueryString %>]</p>

    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td height="60" align="left" valign="bottom" width="1250">
                <img src="<%=AssetsPath()%>/b-cds5.gif" style="margin-left: 24px; vertical-align: bottom; margin-bottom: 0px; cursor: pointer" onclick="showMore('Best-Selling-CDs','-')" onmouseover="fov(this,'b-cds5')" onmouseout="fou(this,'b-cds5')">
                <img src="<%=AssetsPath()%>/show-all.gif" style="margin-left: 10px; margin-bottom: 4px; vertical-align: bottom; cursor: pointer" onclick="showMore('Best-Selling-CDs','-')">
            </td>
        </tr>
    </table>
    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td height="8" align="left" valign="middle" width="1250"></td>
        </tr>
    </table>
    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td width="9"></td>
            <%
   n=0
   Do While xx.Read
    n=n+1
    varIDOn=varIDOn+1
    arrayIDs(varIDOn)=xx("ID")
    Call RenderGridItem(varSearchID, xx("RhythmName"), xx("Genre1"), xx("YearFrom"), xx("YearTo"), xx("Label"), xx("ItemFeatures1"), xx("ItemFeatures2"), xx("ItemFeatures3"), xx("ItemFeatures4"), xx("ItemFeatures5"), xx("ItemFeatures6"), xx("ItemFeatures7"), xx("ItemFeatures8"), xx("ItemFeatures9"), xx("ItemFeatures10"), xx("TracksGroup"), varQueryType, 1, xx("ID"), xx("ArtistTitle"), xx("Format"), xx("StorePrice"), xx("RetailPrice"), xx("Sale_WholesalePrice"), xx("Sale_WholesaleEndDate"), xx("Sale_RetailPrice"), xx("Sale_RetailEndDate"), xx("UsedItem"), xx("MP3FileCompleted"), NameOfCart, strConnectionStringName)
    If n = 4 Then Exit Do
   Loop
  End Using
  varRightWidth = ((4 - n) * 308) + 9%>
 </td><td width="<%=varRightWidth%>" style="vertical-align: top; text-align: left"></td>
        </tr>
    </table>
    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td height="30" align="left" valign="middle" width="1250"></td>
        </tr>
    </table>
    <%'New Release CDs-------------------------------------------------
  SearchQueryString = "select top 24 * from inventory" _
 & " where Format='CD'" _
 & " and inventory>0 and deleted='n' and ShowOnWebsite='y' and (UsedItem is null or UsedItem='n')" _
 & " order by [InStockDate] desc, id desc"
  Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
   SqlConnection.ClearPool(conn)
   conn.Open()
   Dim CMD_X As New SqlCommand(SearchQueryString, conn)
   CMD_X.CommandType = Data.CommandType.Text
   xx = CMD_X.ExecuteReader
    %>
    <p style="background-color: #fff">New Release CDs:[<%=SearchQueryString %>]</p>

    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td height="60" align="left" valign="bottom" width="1250">
                <img src="<%=AssetsPath()%>/nr-cds6.gif" style="margin-left: 24px; vertical-align: bottom; margin-bottom: 0px; cursor: pointer" onclick="showMore('New-Release-CDs','-')" onmouseover="fov(this,'nr-cds6')" onmouseout="fou(this,'nr-cds6')">
                <img src="<%=AssetsPath()%>/show-all.gif" style="margin-left: 10px; vertical-align: bottom; margin-bottom: 4px; cursor: pointer" onclick="showMore('New-Release-CDs','-')">
            </td>
        </tr>
    </table>
    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td height="6" align="left" valign="middle" width="1250"></td>
        </tr>
    </table>
    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td width="9"></td>
            <%
   varHowManyRendered=0
   do While xx.read
    varUsingThisID=0
    for x=1 to varIDOn
     if arrayIDs(x)=xx("ID") then
      varUsingThisID=1
     end if
    next
    if varUsingThisID=0 then
     varIDOn=varIDOn+1
     arrayIDs(varIDOn)=xx("ID")
     Call RenderGridItem(varSearchID, xx("RhythmName"), xx("Genre1"), xx("YearFrom"), xx("YearTo"), xx("Label"), xx("ItemFeatures1"), xx("ItemFeatures2"), xx("ItemFeatures3"), xx("ItemFeatures4"), xx("ItemFeatures5"), xx("ItemFeatures6"), xx("ItemFeatures7"), xx("ItemFeatures8"), xx("ItemFeatures9"), xx("ItemFeatures10"), xx("TracksGroup"), varQueryType, 1, xx("ID"), xx("ArtistTitle"), xx("Format"), xx("StorePrice"), xx("RetailPrice"), xx("Sale_WholesalePrice"), xx("Sale_WholesaleEndDate"), xx("Sale_RetailPrice"), xx("Sale_RetailEndDate"), xx("UsedItem"), xx("MP3FileCompleted"), NameOfCart, strConnectionStringName)
     varHowManyRendered =varHowManyRendered+1
    end If
    If varHowManyRendered = 4 Then Exit Do
   Loop
  End Using
  varRightWidth = ((4 - n) * 308) + 9%>
 </td><td width="<%=varRightWidth%>" style="vertical-align: top; text-align: left"></td>
        </tr>
    </table>
    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td height="30" align="left" valign="middle" width="1250"></td>
        </tr>
    </table>
    <%'Back In Stock CDs-------------------------------------------------
  SearchQueryString = "select top 24 * from inventory" _
 & " where Format='CD'" _
 & " and inventory>0 and deleted='n' and ShowOnWebsite='y' and (UsedItem is null or UsedItem='n')" _
 & " order by [BackInStockDate] desc, id desc"
  Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
   SqlConnection.ClearPool(conn)
   conn.Open()
   Dim CMD_X As New SqlCommand(SearchQueryString, conn)
   CMD_X.CommandType = Data.CommandType.Text
   xx = CMD_X.ExecuteReader
   if xx.hasrows then%>
    <p style="background-color: #fff">Back In Stock CDs:[<%=SearchQueryString %>]</p>

    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td height="60" align="left" valign="bottom" width="1250">
                <img src="<%=AssetsPath()%>/bis-cds5.gif" style="margin-left: 24px; vertical-align: bottom; margin-bottom: 0px; cursor: pointer" onclick="showMore('Back-In-Stock-CDs','-')" onmouseover="fov(this,'bis-cds5')" onmouseout="fou(this,'bis-cds5')">
                <img src="<%=AssetsPath()%>/show-all.gif" style="margin-left: 10px; vertical-align: bottom; margin-bottom: 4px; cursor: pointer" onclick="showMore('Back-In-Stock-CDs','-')">
            </td>
        </tr>
    </table>
    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td height="8" align="left" valign="middle" width="1250"></td>
        </tr>
    </table>
    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td width="9"></td>
            <%
   varHowManyRendered=0
   do While xx.read
    varUsingThisID=0
    for x=1 to varIDOn
     if arrayIDs(x)=xx("ID") then
      varUsingThisID=1
     end if
    next
    if varUsingThisID=0 then
     varIDOn=varIDOn+1
     arrayIDs(varIDOn)=xx("ID")
     Call RenderGridItem(varSearchID, xx("RhythmName"), xx("Genre1"), xx("YearFrom"), xx("YearTo"), xx("Label"), xx("ItemFeatures1"), xx("ItemFeatures2"), xx("ItemFeatures3"), xx("ItemFeatures4"), xx("ItemFeatures5"), xx("ItemFeatures6"), xx("ItemFeatures7"), xx("ItemFeatures8"), xx("ItemFeatures9"), xx("ItemFeatures10"), xx("TracksGroup"), varQueryType, 1, xx("ID"), xx("ArtistTitle"), xx("Format"), xx("StorePrice"), xx("RetailPrice"), xx("Sale_WholesalePrice"), xx("Sale_WholesaleEndDate"), xx("Sale_RetailPrice"), xx("Sale_RetailEndDate"), xx("UsedItem"), xx("MP3FileCompleted"), NameOfCart, strConnectionStringName)
     varHowManyRendered =varHowManyRendered+1
    end If
    If varHowManyRendered = 4 Then Exit Do
   Loop
   varRightWidth = ((4 - varHowManyRendered) * 308) + 9%>
 </td><td width="<%=varRightWidth%>" style="vertical-align: top; text-align: left"></td>
        </tr>
    </table>
    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td height="30" align="left" valign="middle" width="1250"></td>
        </tr>
    </table>
    <%End if
 End using%>
    <%'Best Selling 7"-------------------------------------------------
   SearchQueryString = "select top 6 * from inventory" _
& " where Format = '7""'" _
& " and inventory>0 and deleted='n' and ShowOnWebsite='y' and (UsedItem is null or UsedItem='n')" _
& " order by [saleslast30days] desc, Inventory desc,id desc"
   Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
    SqlConnection.ClearPool(conn)
    conn.Open()
    Dim CMD_X As New SqlCommand(SearchQueryString, conn)
    CMD_X.CommandType = Data.CommandType.Text
    xx = CMD_X.ExecuteReader
    %>
    <p style="background-color: #fff">Best Selling 7":[<%=SearchQueryString %>]</p>

    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td height="60" align="left" valign="bottom" width="1250">
                <img src="<%=AssetsPath()%>/b-7s5.gif" style="margin-left: 24px; vertical-align: bottom; margin-bottom: 0px; cursor: pointer" onclick="showMore('Best-Selling-7s','-')" onmouseover="fov(this,'b-7s5')" onmouseout="fou(this,'b-7s5')">
                <img src="<%=AssetsPath()%>/show-all.gif" style="margin-left: 10px; vertical-align: bottom; margin-bottom: 4px; cursor: pointer" onclick="showMore('Best-Selling-7s','-')">
            </td>
        </tr>
    </table>
    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td height="8" align="left" valign="middle" width="1250"></td>
        </tr>
    </table>
    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td width="9"></td>
            <%
   n=0
   Do While xx.Read
    n=n+1
    varIDOn=varIDOn+1
    arrayIDs(varIDOn)=xx("ID")
    Call RenderGridItem(varSearchID, xx("RhythmName"), xx("Genre1"), xx("YearFrom"), xx("YearTo"), xx("Label"), xx("ItemFeatures1"), xx("ItemFeatures2"), xx("ItemFeatures3"), xx("ItemFeatures4"), xx("ItemFeatures5"), xx("ItemFeatures6"), xx("ItemFeatures7"), xx("ItemFeatures8"), xx("ItemFeatures9"), xx("ItemFeatures10"), xx("TracksGroup"), varQueryType, 1, xx("ID"), xx("ArtistTitle"), xx("Format"), xx("StorePrice"), xx("RetailPrice"), xx("Sale_WholesalePrice"), xx("Sale_WholesaleEndDate"), xx("Sale_RetailPrice"), xx("Sale_RetailEndDate"), xx("UsedItem"), xx("MP3FileCompleted"), NameOfCart, strConnectionStringName)
    If n = 4 Then Exit Do
   Loop
  End Using
  varRightWidth = ((4 - n) * 308) + 9%>
  </td><td width="<%=varRightWidth%>" style="vertical-align: top; text-align: left"></td>
        </tr>
    </table>
    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td height="30" align="left" valign="middle" width="1250"></td>
        </tr>
    </table>
    <%'New Release 7"-------------------------------------------------
  SearchQueryString = "select top 24 * from inventory" _
& " where Format='7""'" _
& " and inventory>0 and deleted='n' and ShowOnWebsite='y' and (UsedItem is null or UsedItem='n')" _
& " order by [InStockDate] desc, id desc"
  Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
   SqlConnection.ClearPool(conn)
   conn.Open()
   Dim CMD_X As New SqlCommand(SearchQueryString, conn)
   CMD_X.CommandType = Data.CommandType.Text
   xx = CMD_X.ExecuteReader%>
    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td height="60" align="left" valign="bottom" width="1250">
                <img src="<%=AssetsPath()%>/nr-7s6.gif" style="margin-left: 24px; vertical-align: bottom; margin-bottom: 0px; cursor: pointer" onclick="showMore('New-Release-7s','-')" onmouseover="fov(this,'nr-7s6')" onmouseout="fou(this,'nr-7s6')">
                <img src="<%=AssetsPath()%>/show-all.gif" style="margin-left: 10px; vertical-align: bottom; margin-bottom: 4px; cursor: pointer" onclick="showMore('New-Release-7s','-')">
            </td>
        </tr>
    </table>
    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td height="8" align="left" valign="middle" width="1250"></td>
        </tr>
    </table>
    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td width="9"></td>
            <%
    varHowManyRendered = 0
    Do While xx.Read
     varUsingThisID = 0
     For x = 1 To varIDOn
      If arrayIDs(x) = xx("ID") Then
       varUsingThisID = 1
      End If
     Next
     If varUsingThisID = 0 Then
      varIDOn = varIDOn + 1
      arrayIDs(varIDOn) = xx("ID")
      Call RenderGridItem(varSearchID, xx("RhythmName"), xx("Genre1"), xx("YearFrom"), xx("YearTo"), xx("Label"), xx("ItemFeatures1"), xx("ItemFeatures2"), xx("ItemFeatures3"), xx("ItemFeatures4"), xx("ItemFeatures5"), xx("ItemFeatures6"), xx("ItemFeatures7"), xx("ItemFeatures8"), xx("ItemFeatures9"), xx("ItemFeatures10"), xx("TracksGroup"), varQueryType, 1, xx("ID"), xx("ArtistTitle"), xx("Format"), xx("StorePrice"), xx("RetailPrice"), xx("Sale_WholesalePrice"), xx("Sale_WholesaleEndDate"), xx("Sale_RetailPrice"), xx("Sale_RetailEndDate"), xx("UsedItem"), xx("MP3FileCompleted"), NameOfCart, strConnectionStringName)
      varHowManyRendered = varHowManyRendered + 1
     End If
     If varHowManyRendered = 4 Then Exit Do
    Loop
   End Using
   varRightWidth = ((4 - varHowManyRendered) * 308) + 9%>
  </td><td width="<%=varRightWidth%>" style="vertical-align: top; text-align: left"></td>
        </tr>
    </table>
    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td height="30" align="left" valign="middle" width="1250"></td>
        </tr>
    </table>
    <%'Used/Collectible 7"-------------------------------------------------
  SearchQueryString = "select top 24 * from inventory" _
& " where Format='7""'" _
& " and inventory>0 and deleted='n' and ShowOnWebsite='y' and UsedItem ='y'" _
& " order by [InStockDate] desc, id desc"
  Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
   SqlConnection.ClearPool(conn)
   conn.Open()
   Dim CMD_X As New SqlCommand(SearchQueryString, conn)
   CMD_X.CommandType = Data.CommandType.Text
   xx = CMD_X.ExecuteReader
   if xx.hasrows then%>
    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td height="60" align="left" valign="bottom" width="1250">
                <img src="<%=AssetsPath()%>/uc-7s5.gif" style="margin-left: 24px; vertical-align: bottom; margin-bottom: 0px; cursor: pointer" onclick="showMore('Used-Collectible-7s','-')" onmouseover="fov(this,'uc-7s5')" onmouseout="fou(this,'uc-7s5')">
                <img src="<%=AssetsPath()%>/show-all.gif" style="margin-left: 10px; vertical-align: bottom; margin-bottom: 4px; cursor: pointer" onclick="showMore('Used-Collectible-7s','-')">
            </td>
        </tr>
    </table>
    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td height="8" align="left" valign="middle" width="1250"></td>
        </tr>
    </table>
    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td width="9"></td>
            <%
   varHowManyRendered=0
   do While xx.read
    varUsingThisID=0
    for x=1 to varIDOn
     if arrayIDs(x)=xx("ID") then
      varUsingThisID=1
     end if
    next
    if varUsingThisID=0 then
     varIDOn=varIDOn+1
     arrayIDs(varIDOn)=xx("ID")
     Call RenderGridItem(varSearchID, xx("RhythmName"), xx("Genre1"), xx("YearFrom"), xx("YearTo"), xx("Label"), xx("ItemFeatures1"), xx("ItemFeatures2"), xx("ItemFeatures3"), xx("ItemFeatures4"), xx("ItemFeatures5"), xx("ItemFeatures6"), xx("ItemFeatures7"), xx("ItemFeatures8"), xx("ItemFeatures9"), xx("ItemFeatures10"), xx("TracksGroup"), varQueryType, 1, xx("ID"), xx("ArtistTitle"), xx("Format"), xx("StorePrice"), xx("RetailPrice"), xx("Sale_WholesalePrice"), xx("Sale_WholesaleEndDate"), xx("Sale_RetailPrice"), xx("Sale_RetailEndDate"), xx("UsedItem"), xx("MP3FileCompleted"), NameOfCart, strConnectionStringName)
     varHowManyRendered =varHowManyRendered+1
    end If
    If varHowManyRendered = 4 Then Exit Do
   Loop
   varRightWidth = ((4 - varHowManyRendered) * 308) + 9%>
  </td><td width="<%=varRightWidth%>" style="vertical-align: top; text-align: left"></td>
        </tr>
    </table>
    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td height="30" align="left" valign="middle" width="1250"></td>
        </tr>
    </table>
    <%end if
 End using%>
    <%'Back In Stock 7"-------------------------------------------------
  SearchQueryString = "select top 24 * from inventory" _
& " where Format='7""'" _
& " and inventory>0 and deleted='n' and ShowOnWebsite='y' and (UsedItem is null or UsedItem='n')" _
& " order by [BackInStockDate] desc, id desc"
  Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
   SqlConnection.ClearPool(conn)
   conn.Open()
   Dim CMD_X As New SqlCommand(SearchQueryString, conn)
   CMD_X.CommandType = Data.CommandType.Text
   xx = CMD_X.ExecuteReader
   if xx.hasrows then%>
    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td height="60" align="left" valign="bottom" width="1250">
                <img src="<%=AssetsPath()%>/bis-7s5.gif" style="margin-left: 24px; vertical-align: bottom; margin-bottom: 0px; cursor: pointer" onclick="showMore('Back-In-Stock-7s','-')" onmouseover="fov(this,'bis-7s5')" onmouseout="fou(this,'bis-7s5')">
                <img src="<%=AssetsPath()%>/show-all.gif" style="margin-left: 10px; vertical-align: bottom; margin-bottom: 4px; cursor: pointer" onclick="showMore('Back-In-Stock-7s','-')">
            </td>
        </tr>
    </table>
    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td height="8" align="left" valign="middle" width="1250"></td>
        </tr>
    </table>
    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td width="9"></td>
            <%
   varHowManyRendered=0
   do While xx.read
    varUsingThisID=0
    for x=1 to varIDOn
     if arrayIDs(x)=xx("ID") then
      varUsingThisID=1
     end if
    next
    if varUsingThisID=0 then
     varIDOn=varIDOn+1
     arrayIDs(varIDOn)=xx("ID")
     Call RenderGridItem(varSearchID, xx("RhythmName"), xx("Genre1"), xx("YearFrom"), xx("YearTo"), xx("Label"), xx("ItemFeatures1"), xx("ItemFeatures2"), xx("ItemFeatures3"), xx("ItemFeatures4"), xx("ItemFeatures5"), xx("ItemFeatures6"), xx("ItemFeatures7"), xx("ItemFeatures8"), xx("ItemFeatures9"), xx("ItemFeatures10"), xx("TracksGroup"), varQueryType, 1, xx("ID"), xx("ArtistTitle"), xx("Format"), xx("StorePrice"), xx("RetailPrice"), xx("Sale_WholesalePrice"), xx("Sale_WholesaleEndDate"), xx("Sale_RetailPrice"), xx("Sale_RetailEndDate"), xx("UsedItem"), xx("MP3FileCompleted"), NameOfCart, strConnectionStringName)
     varHowManyRendered =varHowManyRendered+1
    end If
    If varHowManyRendered = 4 Then Exit Do
   Loop
   varRightWidth = ((4 - varHowManyRendered) * 308) + 9%>
  </td><td width="<%=varRightWidth%>" style="vertical-align: top; text-align: left"></td>
        </tr>
    </table>
    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td height="30" align="left" valign="middle" width="1250"></td>
        </tr>
    </table>
    <%End if
 End using%>
    <%'Best Selling 12" / 10"-------------------------------------------------
  SearchQueryString = "select top 6 * from inventory" _
   & " where (Format = '12""' or Format = '10""')" _
   & " and inventory>0 and deleted='n' and ShowOnWebsite='y' and (UsedItem is null or UsedItem='n')" _
   & " order by [saleslast30days] desc, Inventory desc,id desc"
  Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
   SqlConnection.ClearPool(conn)
   conn.Open()
   Dim CMD_X As New SqlCommand(SearchQueryString, conn)
   CMD_X.CommandType = Data.CommandType.Text
   xx = CMD_X.ExecuteReader
    %>
    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td height="60" align="left" valign="bottom" width="1250">
                <img src="<%=AssetsPath()%>/b-12s10s5.gif" style="margin-left: 24px; vertical-align: bottom; margin-bottom: 0px; cursor: pointer" onclick="showMore('Best-Selling-12s-10s','-')" onmouseover="fov(this,'b-12s10s5')" onmouseout="fou(this,'b-12s10s5')">
                <img src="<%=AssetsPath()%>/show-all.gif" style="margin-left: 10px; vertical-align: bottom; margin-bottom: 4px; cursor: pointer" onclick="showMore('Best-Selling-12s-10s','-')">
            </td>
        </tr>
    </table>
    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td height="8" align="left" valign="middle" width="1250"></td>
        </tr>
    </table>
    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td width="9"></td>
            <%
   n=0
   Do While xx.Read
    n=n+1
    varIDOn=varIDOn+1
    arrayIDs(varIDOn)=xx("ID")
    Call RenderGridItem(varSearchID, xx("RhythmName"), xx("Genre1"), xx("YearFrom"), xx("YearTo"), xx("Label"), xx("ItemFeatures1"), xx("ItemFeatures2"), xx("ItemFeatures3"), xx("ItemFeatures4"), xx("ItemFeatures5"), xx("ItemFeatures6"), xx("ItemFeatures7"), xx("ItemFeatures8"), xx("ItemFeatures9"), xx("ItemFeatures10"), xx("TracksGroup"), varQueryType, 1, xx("ID"), xx("ArtistTitle"), xx("Format"), xx("StorePrice"), xx("RetailPrice"), xx("Sale_WholesalePrice"), xx("Sale_WholesaleEndDate"), xx("Sale_RetailPrice"), xx("Sale_RetailEndDate"), xx("UsedItem"), xx("MP3FileCompleted"), NameOfCart, strConnectionStringName)
    If n = 4 Then Exit Do
   Loop
  End Using
  varRightWidth = ((4 - n) * 308) + 9%>
  </td><td width="<%=varRightWidth%>" style="vertical-align: top; text-align: left"></td>
        </tr>
    </table>
    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td height="30" align="left" valign="middle" width="1250"></td>
        </tr>
    </table>
    </td><td width="<%=varRightWidth%>" style="vertical-align: top; text-align: left"></td>
    </tr></table>
 <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
     <tr>
         <td height="30" align="left" valign="middle" width="1250"></td>
     </tr>
 </table>
    <%'New Release 12"/10"-------------------------------------------------
  SearchQueryString = "select top 24 * from inventory" _
 & " where (format='12""' or format='10""')" _
 & " and inventory>0 and deleted='n' and ShowOnWebsite='y' and (UsedItem is null or UsedItem='n')" _
 & " order by [InStockDate] desc, id desc"
  Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
   SqlConnection.ClearPool(conn)
   conn.Open()
   Dim CMD_X As New SqlCommand(SearchQueryString, conn)
   CMD_X.CommandType = Data.CommandType.Text
   xx = CMD_X.ExecuteReader%>
    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td height="60" align="left" valign="bottom" width="1250">
                <img src="<%=AssetsPath()%>/nr-12s10s6.gif" style="margin-left: 24px; vertical-align: bottom; margin-bottom: 0px; cursor: pointer" onclick="showMore('New-Release-12s-10s','-')" onmouseover="fov(this,'nr-12s10s6')" onmouseout="fou(this,'nr-12s10s6')">
                <img src="<%=AssetsPath()%>/show-all.gif" style="margin-left: 10px; vertical-align: bottom; margin-bottom: 4px; cursor: pointer" onclick="showMore('New-Release-12s-10s','-')">
            </td>
        </tr>
    </table>
    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td height="8" align="left" valign="middle" width="1250"></td>
        </tr>
    </table>
    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td width="9"></td>
            <%
    varHowManyRendered = 0
    Do While xx.Read
     varUsingThisID = 0
     For x = 1 To varIDOn
      If arrayIDs(x) = xx("ID") Then
       varUsingThisID = 1
      End If
     Next
     If varUsingThisID = 0 Then
      varIDOn = varIDOn + 1
      arrayIDs(varIDOn) = xx("ID")
      Call RenderGridItem(varSearchID, xx("RhythmName"), xx("Genre1"), xx("YearFrom"), xx("YearTo"), xx("Label"), xx("ItemFeatures1"), xx("ItemFeatures2"), xx("ItemFeatures3"), xx("ItemFeatures4"), xx("ItemFeatures5"), xx("ItemFeatures6"), xx("ItemFeatures7"), xx("ItemFeatures8"), xx("ItemFeatures9"), xx("ItemFeatures10"), xx("TracksGroup"), varQueryType, 1, xx("ID"), xx("ArtistTitle"), xx("Format"), xx("StorePrice"), xx("RetailPrice"), xx("Sale_WholesalePrice"), xx("Sale_WholesaleEndDate"), xx("Sale_RetailPrice"), xx("Sale_RetailEndDate"), xx("UsedItem"), xx("MP3FileCompleted"), NameOfCart, strConnectionStringName)
      varHowManyRendered = varHowManyRendered + 1
     End If
     If varHowManyRendered = 4 Then Exit Do
    Loop
   End Using
   varRightWidth = ((4 - varHowManyRendered) * 308) + 9%>
  </td><td width="<%=varRightWidth%>" style="vertical-align: top; text-align: left"></td>
        </tr>
    </table>
    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td height="30" align="left" valign="middle" width="1250"></td>
        </tr>
    </table>
    <%'Back In Stock 12"/10"-------------------------------------------------
   SearchQueryString = "select top 24 * from inventory" _
& " where (Format='12""' or Format='10""')" _
& " and inventory>0 and deleted='n' and ShowOnWebsite='y' and (UsedItem is null or UsedItem='n')" _
& " order by [BackInStockDate] desc, id desc"
   Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
    SqlConnection.ClearPool(conn)
    conn.Open()
    Dim CMD_X As New SqlCommand(SearchQueryString, conn)
    CMD_X.CommandType = Data.CommandType.Text
    xx = CMD_X.ExecuteReader
    if xx.hasrows then%>
    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td height="60" align="left" valign="bottom" width="1250">
                <img src="<%=AssetsPath()%>/bis-12s10s6.gif" style="margin-left: 24px; vertical-align: bottom; margin-bottom: 0px; cursor: pointer" onclick="showMore('Back-In-Stock-12s-10s','-')" onmouseover="fov(this,'bis-12s10s6')" onmouseout="fou(this,'bis-12s10s6')">
                <img src="<%=AssetsPath()%>/show-all.gif" style="margin-left: 10px; vertical-align: bottom; margin-bottom: 4px; cursor: pointer" onclick="showMore('Back-In-Stock-12s-10s','-')">
            </td>
        </tr>
    </table>
    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td height="8" align="left" valign="middle" width="1250"></td>
        </tr>
    </table>
    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td width="9"></td>
            <%
   varHowManyRendered=0
   do While xx.read
    varUsingThisID=0
    for x=1 to varIDOn
     if arrayIDs(x)=xx("ID") then
      varUsingThisID=1
     end if
    next
    if varUsingThisID=0 then
     varIDOn=varIDOn+1
     arrayIDs(varIDOn)=xx("ID")
     Call RenderGridItem(varSearchID, xx("RhythmName"), xx("Genre1"), xx("YearFrom"), xx("YearTo"), xx("Label"), xx("ItemFeatures1"), xx("ItemFeatures2"), xx("ItemFeatures3"), xx("ItemFeatures4"), xx("ItemFeatures5"), xx("ItemFeatures6"), xx("ItemFeatures7"), xx("ItemFeatures8"), xx("ItemFeatures9"), xx("ItemFeatures10"), xx("TracksGroup"), varQueryType, 1, xx("ID"), xx("ArtistTitle"), xx("Format"), xx("StorePrice"), xx("RetailPrice"), xx("Sale_WholesalePrice"), xx("Sale_WholesaleEndDate"), xx("Sale_RetailPrice"), xx("Sale_RetailEndDate"), xx("UsedItem"), xx("MP3FileCompleted"), NameOfCart, strConnectionStringName)
     varHowManyRendered =varHowManyRendered+1
    end If
    If varHowManyRendered = 4 Then Exit Do
   Loop
   varRightWidth = ((4 - varHowManyRendered) * 308) + 9%>
  </td><td width="<%=varRightWidth%>" style="vertical-align: top; text-align: left"></td>
        </tr>
    </table>
    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td height="30" align="left" valign="middle" width="1250"></td>
        </tr>
    </table>
    <%End if
 End using%>
    <%'                                                                                                             
 '  Search Results Page                                                                                        
 '                                                                                                             
 ElseIf varDefaultHomePage=0 and varXXRecordCount>0 then
  if instr(1,varYouSearchedForArtist,"recent")>0 and (instr(1,varYouSearchedForArtist,"Days back")>0 or instr(1,varYouSearchedForArtist,"Day back")>0) and SearchArtist="" then SortRhythm="yes"
  varRecordsLimit=(Request.Cookies("RecordsLimit").value)
  if not isnumeric(varRecordsLimit) Then
   varRecordsLimit = 160
  End If
  If varRecordsLimit = 0 Then varRecordsLimit = 160
  If varRecordsLimit=15 then var15PerPageSelected="selected"
  if varRecordsLimit=25 then var25PerPageSelected="selected"
  if varRecordsLimit=50 then var50PerPageSelected="selected"
  if varRecordsLimit=100 then var100PerPageSelected="selected"
  if varRecordsLimit=200 then var200PerPageSelected="selected"
  if varSortOrder="FA" or varSortOrder="" then varSortSelectedFormatArtist="selected"
  if varSortOrder="FL" then varSortSelectedFormatLabel="selected"
  if varSortOrder="FBS" then varSortSelectedFormatBestSellers="selected"
  if varSortOrder="FPH" then varSortSelectedFormatPriceHighest="selected"
  if varSortOrder="FPL" then varSortSelectedFormatPriceLowest="selected"
  If varSortOrder = "RAD" Or varSortOrder = "RABIS" Then varSortSelectedRecentArrivalDate = "selected"
  ' Bar above search results %>
    <%If varCartPage=0 then%>
    <table cellpadding="0" bgcolor="758973" cellspacing="0" width="1250" align="center" valign="middle" border="0" style="background-image: url('<%=AssetsPath()%>/bu2.gif')">
        <tr>
            <td height="34" width="230" style="vertical-align: middle; text-align: right">
                <%'Sort Order%>
                <%if varAllowSortOrders=1 then%>
                <div class="sort" name="sort-div" id="sort-div">
                    <table cellpadding="0" cellspacing="0" width="100%" align="center" border="0" style="margin-top: 6px">
                        <tr>
                            <td width="100%" height="28" style="vertical-align: middle; text-align: center">
                                <img style="cursor: pointer; vertical-align: middle" src="<%=AssetsPath()%>/go-sort-fa.gif" onclick="ChangeSort('FA')" onmouseover="fov(this,'go-sort-fa')" onmouseout="fou(this,'go-sort-fa')">
                            </td>
                        </tr>
                        <tr>
                            <td width="100%" height="28" style="vertical-align: middle; text-align: center">
                                <img style="cursor: pointer; vertical-align: middle" src="<%=AssetsPath()%>/go-sort-rad.gif" onclick="ChangeSort('RAD')" onmouseover="fov(this,'go-sort-rad')" onmouseout="fou(this,'go-sort-rad')">
                            </td>
                        </tr>
                        <tr>
                            <td width="100%" height="28" style="vertical-align: middle; text-align: center">
                                <img style="cursor: pointer; vertical-align: middle" src="<%=AssetsPath()%>/go-sort-fbs.gif" onclick="ChangeSort('FBS')" onmouseover="fov(this,'go-sort-fbs')" onmouseout="fou(this,'go-sort-fbs')">
                            </td>
                        </tr>
                        <tr>
                            <td width="100%" height="28" style="vertical-align: middle; text-align: center">
                                <img style="cursor: pointer; vertical-align: middle" src="<%=AssetsPath()%>/go-sort-fl.gif" onclick="ChangeSort('FL')" onmouseover="fov(this,'go-sort-fl')" onmouseout="fou(this,'go-sort-fl')">
                            </td>
                        </tr>
                        <tr>
                            <td width="100%" height="28" style="vertical-align: middle; text-align: center">
                                <img style="cursor: pointer; vertical-align: middle" src="<%=AssetsPath()%>/go-sort-fph.gif" onclick="ChangeSort('FPH')" onmouseover="fov(this,'go-sort-fph')" onmouseout="fou(this,'go-sort-fph')">
                            </td>
                        </tr>
                        <tr>
                            <td width="100%" height="28" style="vertical-align: middle; text-align: center">
                                <img style="cursor: pointer; vertical-align: middle" src="<%=AssetsPath()%>/go-sort-fpl.gif" onclick="ChangeSort('FPL')" onmouseover="fov(this,'go-sort-fpl')" onmouseout="fou(this,'go-sort-fpl')">
                            </td>
                        </tr>
                    </table>
                </div>
                <div name="sort-close-div" id="sort-close-div" style="position: absolute; width: 30px; height: 30px; margin-left: 338px; background-color: #676767; margin-top: 17px; visibility: hidden; display: none; text-align: center; vertical-align: middle; z-index: 20; border-radius: 15px">
                    <img style="cursor: pointer; vertical-align: middle" src="<%=AssetsPath()%>/close-2.gif" onclick="HideSortOptions()">
                </div>
                <p class="white" style="vertical-align: middle; text-align: center; font-size: 17px">Sort Search Results By</p>
                <%end if%>
            </td>
            <td width="165" style="vertical-align: middle; text-align: left">
                <%if varAllowSortOrders=1 then%>
                <% If varSortOrder = "FA" Or IsDBSomething(varSortOrder, "") = "" Then%>
                <img style="cursor: pointer; vertical-align: middle; margin-left: 8px" src="<%=AssetsPath()%>/sort-fa2.gif" onclick="ShowSortOptions()">
                <%elseif varSortOrder="RAD" or varSortOrder="RABIS" then%>
                <img style="cursor: pointer; vertical-align: middle; margin-left: 8px" src="<%=AssetsPath()%>/sort-rad2.gif" onclick="ShowSortOptions()">
                <%elseif varSortOrder="FBS" then%>
                <img style="cursor: pointer; vertical-align: middle; margin-left: 8px" src="<%=AssetsPath()%>/sort-fbs2.gif" onclick="ShowSortOptions()">
                <%elseif varSortOrder="FL" then%>
                <img style="cursor: pointer; vertical-align: middle; margin-left: 8px" src="<%=AssetsPath()%>/sort-fl2.gif" onclick="ShowSortOptions()">
                <%elseif varSortOrder="FPH" then%>
                <img style="cursor: pointer; vertical-align: middle; margin-left: 8px" src="<%=AssetsPath()%>/sort-fph2.gif" onclick="ShowSortOptions()">
                <%elseif varSortOrder="FPL" then%>
                <img style="cursor: pointer; vertical-align: middle; margin-left: 8px" src="<%=AssetsPath()%>/sort-fpl2.gif" onclick="ShowSortOptions()">
                <%end if%>
                <%end if%>
                <%'Display Type%>
            </td>
            <td width="90" style="vertical-align: middle; text-align: right">
                <%if varCartPage=0 then%>
                <div class="dt" name="display-type-div" id="display-type-div">
                    <table cellpadding="0" cellspacing="0" width="100%" align="center" border="0" style="margin-top: 6px">
                        <tr>
                            <td width="100%" height="28" style="vertical-align: middle; text-align: center">
                                <img style="cursor: pointer; vertical-align: middle" src="<%=AssetsPath()%>/go-display-large2.gif" onclick="GoGalleryView('')" onmouseover="fov(this,'go-display-large2')" onmouseout="fou(this,'go-display-large2')">
                            </td>
                        </tr>
                        <tr>
                            <td width="100%" height="28" style="vertical-align: middle; text-align: center">
                                <img style="cursor: pointer; vertical-align: middle" src="<%=AssetsPath()%>/go-display-medium2.gif" onclick="GoListView('')" onmouseover="fov(this,'go-display-medium2')" onmouseout="fou(this,'go-display-medium2')">
                            </td>
                        </tr>
                        <tr>
                            <td width="100%" height="28" style="vertical-align: middle; text-align: center">
                                <img style="cursor: pointer; vertical-align: middle" src="<%=AssetsPath()%>/go-display-small2.gif" onclick="GoThumbnailsView('')" onmouseover="fov(this,'go-display-small2')" onmouseout="fou(this,'go-display-small2')">
                            </td>
                        </tr>
                    </table>
                </div>
                <div name="display-close-div" id="display-close-div" style="position: absolute; width: 30px; height: 30px; margin-left: 234px; background-color: #676767; margin-top: 17px; visibility: hidden; display: none; text-align: center; vertical-align: middle; z-index: 20; border-radius: 15px">
                    <img style="cursor: pointer; vertical-align: middle" src="<%=AssetsPath()%>/close-2.gif" onclick="HideDisplayOptions()">
                </div>
                <!--p class="white"style="vertical-align:middle;font-size:17px">Image Size</p-->
                <%end if%> 
            </td>
            <td width="160" style="vertical-align: middle; text-align: left">
                <%if varCartPage=0 then%>
                <%if varDisplayType="Grid" then%>
                <!--img style="cursor:pointer;vertical-align:middle;margin-left:8px" src="<%=AssetsPath()%>/gallery-view1.gif"onclick="ShowDisplayTypes()"-->
                <%elseif varDisplayType="List" then%>
                <img style="cursor: pointer; vertical-align: middle; margin-left: 8px" src="<%=AssetsPath()%>/list-view1.gif" onclick="ShowDisplayTypes()">
                <%else%>
                <img style="cursor: pointer; vertical-align: middle; margin-left: 8px" src="<%=AssetsPath()%>/thumbnail-view1.gif" onclick="ShowDisplayTypes()">
                <%end if%>
                <%end if%>
            </td>
            <td width="605" style="vertical-align: middle; text-align: right">
                <%'PowerUser buttons%>
                <%if session("PriceGroup") = "StorePrice" Or Session("PriceGroup") = "ExportPrice" Or Session("PowerUserName") <> "" Then%>
                <% If Session("SuperPowerUserName") <> "" Then%>
                <% If Session("ShowOrHideZeroInStock") = "y" Or (Request.QueryString("ShowOrHideZeroInStock") = "y" And Session("PowerUserName") <> "") Then%>
                <img alt="" class="a" src="<%=AssetsPath()%>/SI2.gif" title="Click to hide out of stock items." onclick="window.location='/Home.aspx?ShowOrHideZeroInStock=n'">
                <% Else%>
                <img alt="" class="a" src="<%=AssetsPath()%>/SIN2.gif" title="Click to show out of stock items." onclick="window.location='/Home.aspx?ShowOrHideZeroInStock=y'">
                <%end if%>
                <%if Request.Cookies("SD7").Value = "y" Then%>
                <img alt="" class="a" src="<%=AssetsPath()%>/SD3.gif" title="Click to hide deleted items." onclick="document.cookie='SD7=n;path=/';window.location.reload()">
                <%  Else%>
                <img alt="" class="a" src="<%=AssetsPath()%>/SDN2.gif" title="Click to show deleted items." onclick="document.cookie='SD7=y;path=/';window.location.reload()">
                <%end if%>
                <%if Request.Cookies("Sold7").Value = "y" Then%>
                <img alt="" class="a" src="<%=AssetsPath()%>/Sold.gif" title="Click to hide date customer last bought item." onclick="document.cookie='Sold7=n;path=/';window.location.reload()">
                <%  Else%>
                <img alt="" class="a" src="<%=AssetsPath()%>/SoldN.gif" title="Click to show date customer last bought item." onclick="document.cookie='Sold7=y;path=/';window.location.reload()">
                <%end if%>
                <%end if%>
                <%end if%> 
            </td>
        </tr>
    </table>
    <%else%>
    <table cellpadding="0" border="0" cellspacing="0" width="1250" align="center" bgcolor="DCDCDC">
        <tr>
            <td height="63" style="vertical-align: middle; padding-top: 5px">
                <img style="vertrical-align: middle; margin-left: 170px; margin-bottom: 8px" src="<%=AssetsPath()%>/your-shopping-cart.gif" />
            </td>
        </tr>
    </table>
    <table cellpadding="0" border="0" cellspacing="0" width="1250" align="center" bgcolor="ffffff">
        <tr>
            <td height="8"></td>
        </tr>
    </table>
    <%End if%>

    <%
  varShowSales = 0
  Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
   SqlConnection.ClearPool(conn)
   conn.Open()
   Dim CMD_X As New SqlCommand(SearchQueryString, conn)
   CMD_X.CommandType = Data.CommandType.Text
   xx = CMD_X.ExecuteReader
   RecordNumber = 0
   If varStartRecord <> 1 And varPageQuery = "y" Then
    n = 0
    Do While xx.Read
     n = n + 1
     If n = varStartRecord - 1 Then Exit Do
    Loop
    RecordNumber = varStartRecord - 1
   End If
   z = 0
   Do While xx.Read
    'Similar Items
    varSimilarItemsAvailable = 0
    If IsDBSomething(xx("YearFrom"), "") <> "" Then
     If varListYearToOriginal <> "" Then
      If Not IsDBNull(xx("Genre1")) And IsNumeric(IsDBSomething(xx("YearFrom"), "")) And IsNumeric(IsDBSomething(xx("YearTo"), "")) Then
       If CInt(IsDBSomething(xx("YearTo"), "")) - CInt(IsDBSomething(xx("YearFrom"), "")) < 6 Then
        varSimilarItemsAvailable = 1
       End If
      End If
     Else
      If Not IsDBNull(xx("Genre1")) And IsNumeric(IsDBSomething(xx("YearFrom"), "")) Then
       varSimilarItemsAvailable = 1
      End If
     End If
    End If
    z = z + 1
    RecordNumber = RecordNumber + 1
    If varSimilarItemsAvailable = 1 Then
     If IsDBSomething(xx("FormatOrder"), 0) < varCVFormatOrder Then
      varCVFormatOrder = IsDBSomething(xx("FormatOrder"), 0)
      varCVSalesLast30Days = IsDBSomething(xx("SalesLast30Days"), 0)
      varCVItemID = xx("ID")
     End If
     If IsDBSomething(xx("SalesLast30Days"), 0) > varCVSalesLast30Days And IsDBSomething(xx("FormatOrder"), 0) <= varCVFormatOrder Then
      varCVFormatOrder = IsDBSomething(xx("FormatOrder"), 0)
      varCVSalesLast30Days = IsDBSomething(xx("SalesLast30Days"), 0)
      varCVItemID = xx("ID")
     End If
    End If
    'SHOW THUMBNAIL IMAGES LAYOUT                                                                                                                 
    '                                                                                                                                             
    If varDisplayType = "Thumbnails" Then
     varFormat = xx("Format")
     'Image sources
     If ScanPath(xx("ID"), "medium", "a") <> "" Then
      varThumbnailImageSource = ScanPath(xx("ID"), "medium", "A")
      varSupersizeButton = 1
      If ScanPath(xx("ID"), "medium", "b") <> "" Then
       varNumberOfImages = 2
       varFirstImageSource = ScanPath(xx("ID"), "medium", "A")
       varFirstImageSourceForSupersize = "a"
       varSecondImageSource = ScanPath(xx("ID"), "medium", "B")
       varSecondImageSourceForSupersize = "b"
      Else
       varNumberOfImages = 1
       varFirstImageSource = ScanPath(xx("ID"), "medium", "A")
       varFirstImageSourceForSupersize = "a"
       varSecondImageSource = ""
      End If
     Else
      varThumbnailImageSource = AssetsPath() + "/x54b.jpg"
      varNumberOfImages = 1
      If xx("inventory") = 0 Then
       varFirstImageSource = AssetsPath() + "/n180out.jpg"
      Else
       varFirstImageSource = AssetsPath() + "/n180b.jpg"
      End If
      varSecondImageSource = ""
      varSupersizeButton = 0
     End If
     'Loading Image Source
     If xx("Format") = "CD" Then
      varLoadingImageSource = AssetsPath() + "/LI180X157.gif"
     ElseIf xx("Format") = "DVD" Then
      varLoadingImageSource = AssetsPath() + "/LI180X253.gif"
     Else
      varLoadingImageSource = AssetsPath() + "/LI180X180.gif"
     End If
     'Image Border
     If xx("Format") = "CD" Then
      varImageBorder = "border:solid 1px #735E5E"
     Else
      varImageBorder = "border:ridge 1px #000000"
     End If
     'Format Icon
     If xx("Format") = "CD" Then
      varFormatIcon = "cz10"
     ElseIf xx("Format") = "LP" Then
      varFormatIcon = "lz7"
     ElseIf xx("Format") = "CS" Then
      varFormatIcon = "casz6"
     ElseIf Left(xx("Format"), 1) = "V" Then
      varFormatIcon = "vz7"
     ElseIf Left(xx("Format"), 1) = "7" Then
      varFormatIcon = "7z7"
     ElseIf Left(xx("Format"), 2) = "12" Then
      varFormatIcon = "12z7"
     ElseIf Left(xx("Format"), 2) = "10" Then
      varFormatIcon = "10z9"
     ElseIf xx("Format") = "DVD" Then
      varFormatIcon = "dvdz8"
     ElseIf xx("Format") = "B" Then
      varFormatIcon = "bookz7"
     Else
      varFormatIcon = "othz7"
     End If
     'Is Item In Cart Query
     intQuantityInCart = 0
     Using conn2 As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
      SqlConnection.ClearPool(conn2)
      conn2.Open()
      Dim CMD_X2 As New SqlCommand("spIsItemInCart", conn2)
      CMD_X2.CommandType = Data.CommandType.StoredProcedure
      CMD_X2.Parameters.AddWithValue("@NameOfCart", NameOfCart)
      CMD_X2.Parameters.AddWithValue("@ItemID", CLng(xx("ID")))
      Dim readerX2 As SqlDataReader
      readerX2 = CMD_X2.ExecuteReader
      intQuantityInCart = 0
      If readerX2.HasRows Then
       readerX2.Read()
       intQuantityInCart = readerX2("Quantity")
       varCartPrice = readerX2("Price")
       varCartDateTime = readerX2("DateTime")
      End If
     End Using
     'Most Recent Date Bought Item
     If varShowSales = 1 Then
      Using conn3 As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
       SqlConnection.ClearPool(conn3)
       conn3.Open()
       Dim CMD_X3 As New SqlCommand("spMostRecentDateBoughtItem", conn3)
       CMD_X3.CommandType = Data.CommandType.StoredProcedure
       CMD_X3.Parameters.AddWithValue("@ItemID", CLng(xx("ID")))
       CMD_X3.Parameters.AddWithValue("@CustomerID", CLng(varCustomerID))
       Dim readerX3 As SqlDataReader
       readerX3 = CMD_X3.ExecuteReader
       If readerX3.HasRows Then
        readerX3.Read()
        strMostRecentDateBoughtItem = readerX3("MaxDate").ToString
        strQuantityBought = readerX3("SumOfQuantity").ToString
       Else
        strMostRecentDateBoughtItem = "-"
        strQuantityBought = ""
       End If
      End Using
     End If
     'Cost And Cart Price
     varSaleItem = 0
     If Session("PriceGroup") = "StorePrice" Or Session("PriceGroup") = "ExportPrice" Then
      If Not IsDBNull(xx("Sale_WholesalePrice")) And Not IsDBNull(xx("Sale_WholesaleEndDate")) Then
       If DateDiff("d", Date.Now, xx("Sale_WholesaleEndDate")) >= 0 Then
        varSaleItem = 1
       End If
      End If
     Else
      If Not IsDBNull(xx("Sale_RetailPrice")) And Not IsDBNull(xx("Sale_RetailEndDate")) Then
       If DateDiff("d", Date.Now, xx("Sale_RetailEndDate")) >= 0 Then
        varSaleItem = 1
       End If
      End If
     End If
     If Session("PriceGroup") = "StorePrice" Then
      varPriceGroupPrice = xx("StorePrice")
      If varSaleItem = 1 Then
       varPriceUsing = xx("Sale_WholesalePrice")
      Else
       varPriceUsing = xx("StorePrice")
      End If
     ElseIf Session("PriceGroup") = "ExportPrice" Then
      varPriceGroupPrice = xx("ExportPrice")
      If varSaleItem = 1 Then
       varPriceUsing = xx("Sale_WholesalePrice")
      Else
       varPriceUsing = xx("ExportPrice")
      End If
     Else
      varPriceGroupPrice = xx("RetailPrice")
      If varSaleItem = 1 Then
       varPriceUsing = xx("Sale_RetailPrice")
      Else
       varPriceUsing = xx("RetailPrice")
      End If
     End If

     If intQuantityInCart > 0 Then
      If CDbl(varPriceUsing) > CDbl(varCartPrice) And DateDiff("d", varCartDateTime, Date.Now) <= 30 Then
       varPriceUsing = varCartPrice
      End If
     End If
     If Session("PowerUserName") <> "" Then
      varPriceForCartAddText = "document.getElementById('PR' + " & xx("id") & ").value"
      If intQuantityInCart > 0 Then
       varCartPrice = varCartPrice
      Else
       varCartPrice = varPriceUsing
      End If
      If CDbl(varCartPrice) <> CDbl(varPriceUsing) Then
       varCartFColor = "FFFFC8"
      Else
       varCartFColor = "ffffff"
      End If
     Else
      varPriceForCartAddText = varPriceUsing
     End If
     'Inventory
     varInStock = 1
     If xx("Inventory") = 0 Then
      varInStock = 0
     End If
     varStockText = " Item&nbsp;" & xx("ID")
     If Not IsDBNull(xx("UPC")) Then
      If Len(Trim(xx("UPC"))) > 8 Then
       varStockText = varStockText & " &nbsp;UPC&nbsp;" & xx("UPC")
      End If
     End If
     If UCase(IsDBSomething(xx("UsedItem"), "")) = "Y" Then
      varUsedItem = "y"
     Else
      varUsedItem = "n"
     End If
     varAT = FigureArtistTitleWebHTML(xx("UsedItem"), xx("Format"), xx("ArtistTitle"))
     varDefaultImageSource = AssetsPath() + "/li1.gif"
     'MP3 File
     varxxMP3FileCompleted = IsDBSomething(xx("MP3FileCompleted"), "")
     'Blank space above first record
     If z = 1 Then%>
    <table cellpadding="0" border="0" cellspacing="0" width="1250" align="center" bgcolor="ffffff">
        <tr>
            <td height="5"></td>
        </tr>
    </table>
    <%End If
       'Saved For Later Header
       If varSavedForLaterHeaderChecked = 0 And varCartPage = 1 Then
        If IsDBSomething(xx("SaveForLater"), "") = "y" Then
         varSavedForLaterHeaderChecked = 1%>
    <table cellpadding="0" border="0" cellspacing="0" width="1250" align="center" bgcolor="ffffff">
        <tr>
            <td height="30"></td>
        </tr>
    </table>
    <table cellpadding="0" border="0" cellspacing="0" width="1250" align="center" bgcolor="DCDCDC">
        <tr>
            <td height="75" style="vertical-align: middle; padding-top: 5px">
                <img style="vertrical-align: middle; margin-left: 170px" src="<%=AssetsPath()%>/saved-for-later.gif" />
                <p style="font-family: arial,verdana,helvetica,sans-serif; font-size: 16px; color: #ff0000; font-weight: 600; margin-left: 3px">
                    To purchase these items below, you must first move them to your shopping cart.
                </p>
            </td>
        </tr>
    </table>
    <table cellpadding="0" border="0" cellspacing="0" width="1250" align="center" bgcolor="ffffff">
        <tr>
            <td height="12"></td>
        </tr>
    </table>
    <% End If
       End If
       'Div Block Catalog Info SHOW THUMBNAIL IMAGES
       If xx("Format") = "CD" Or xx("Format") = "LP" Then 'CD or LP%>
    <table cellpadding="0" border="0" cellspacing="0" width="1250" align="center" bgcolor="C0CAC0">
        <%  If Session("PowerUserName") <> "" Then%>
        <td width="400"></td>
        <td width="950">
            <%  Else%>
        <td width="335"></td>
        <td width="885">
            <%end if%>
            <div class="q" id="I<%=xx("id")%>T">
                <table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
                    <tr>
                        <td height="28" style="background: url('<%=AssetsPath()%>/div10.gif'); background-repeat: no-repeat" onclick="ICP(<%=xx("id")%>,'<%=varFormatIcon%>')" onmouseup="document.getElementById('OAB<%=xx("id")%>').focus()">&nbsp;
                        </td>
                    </tr>
                </table>
                <table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
                    <tr>
                        <td style="background: url('<%=AssetsPath()%>/div11.gif'); background-repeat: repeat-y">
                            <table width="891" bgcolor="EAD5AD" cellpadding="0" style="border-bottom: 1px solid #B29F7C" cellspacing="0" align="center" border="0">
                                <tr>
                                    <td width="63" style="padding-top: 4px" align="left" valign="top">
                                        <%Response.Write("<input border=""0""type=""image"" src=""" + AssetsPath() + "/ic3.gif""style=""cursor: pointer"" onclick=""ICP(" & xx("id") & ",'" & varFormatIcon & "');VS=0"">")%>
                                    </td>
                                    <td width="608" valign="top" style="line-height: 75%; padding-left: 5px; padding-top: 8px; padding-bottom: 11px">
                                        <p class="et" style="color: #242424"><%=varAT%></p>
                                        <span class="f2">&nbsp;<%=varStockText%></span>
                                    </td>
                                    <td width="90" align="right" valign="top" style="padding-top: 4px">
                                        <%  If xx("Inventory") > 0 Then%>
                                        <img alt src="<%=AssetsPath()%>/ins5.gif">
                                        <%  End If%>
                                    </td>
                                </tr>
                            </table>
                            <table width="891" cellpadding="0" style="border-top: 1px solid #FCF5E8" cellspacing="0" align="center" border="0">
                                <tr>
                                    <td width="491" valign="top" align="left" style="border-right: 1px solid #B6A28F; padding-top: 10px">
                                        <%'InventoryItemFeatures
     If Not IsDBNull(xx("ItemFeatures1")) Then%>
                                        <table align="center" bgcolor="F0DEBE" cellpadding="0" cellspacing="0" width="491" border="0">
                                            <%For intIF = 1 To 10
        If IsDBNull(xx("ItemFeatures" & intIF)) Then Exit For
        strItemFeature = xx("ItemFeatures" & intIF)
        intPipe1 = InStr(xx("ItemFeatures" & intIF), "|1|")
        intPipe2 = InStr(xx("ItemFeatures" & intIF), "|2|")
        intPipe3 = InStr(xx("ItemFeatures" & intIF), "|3|")
        intPipe4 = InStr(xx("ItemFeatures" & intIF), "|4|")
        intPipe5 = InStr(xx("ItemFeatures" & intIF), "|5|")
        If intPipe2 - intPipe1 > 3 Then
         strItemFeatureIDText = Mid(strItemFeature, intPipe1 + 3, intPipe2 - intPipe1 - 3)
        Else
         strItemFeatureIDText = ""
        End If
        If intPipe3 - intPipe2 > 3 Then
         strItemFeatureWebProductDetailsPageHyperlinkText = Mid(strItemFeature, intPipe2 + 3, intPipe3 - intPipe2 - 3)
        Else
         strItemFeatureWebProductDetailsPageHyperlinkText = ""
        End If
        If intPipe4 - intPipe3 > 3 Then
         strItemFeatureWebProductDetailsPageText = Mid(strItemFeature, intPipe3 + 3, intPipe4 - intPipe3 - 3)
        Else
         strItemFeatureWebProductDetailsPageText = ""
        End If
        If intPipe5 - intPipe4 > 3 Then
         strItemFeatureWebGalleryText = Mid(strItemFeature, intPipe4 + 3, intPipe5 - intPipe4 - 3)
        Else
         strItemFeatureWebGalleryText = ""
        End If
                                            %>
                                            <tr>
                                                <td width="20" height="19" style="vertical-align: top; text-align: left">
                                                    <img src="<%=AssetsPath()%>/wt.gif" style="vertical-align: top" />
                                                </td>
                                                <td width="471" style="vertical-align: top; text-align: left">
                                                    <%If strItemFeatureWebProductDetailsPageHyperlinkText <> "" Then%>
                                                    <div class="fdt" style="z-index: 2000" id="IF<%=xx("id")%>-<%=strItemFeatureIDText%>" onclick="hideItemFeaturesDiv('<%=xx("id")%>-<%=strItemFeatureIDText%>')">
                                                        <p class="item-features-div-thumbnaildiv"><%=Replace(Replace(strItemFeatureWebProductDetailsPageHyperlinkText, "NEW PARAGRAPH ", "<br/><br/>"), """", "'")%></p>
                                                    </div>
                                                    <%End If%>
                                                    <a class="if-thd" href="/home.aspx?X3QT=ItemFeature&X3AID=<%=strItemFeatureIDText%>"><%=strItemFeatureWebProductDetailsPageText%></a>
                                                    <%If strItemFeatureWebProductDetailsPageHyperlinkText <> "" Then%>
                                                    <p class="whats-this-thumbnail" onclick="showItemFeaturesDiv('<%=xx("id")%>-<%=strItemFeatureIDText%>')">What's&nbsp;this?</p>
                                                    <%End If%>
                                                </td>
                                            </tr>
                                            <%next%>
                                        </table>
                                        <table align="center" bgcolor="F0DEBE" cellpadding="0" cellspacing="0" width="491" border="0">
                                            <tr>
                                                <td height="8"></td>
                                            </tr>
                                        </table>
                                        <%End If%>

                                        <p class="tracks">
                                            <%varxxTracksGroup = IsDBSomething(xx("TracksGroup"), "")
       varxxNumberOfTracks = FigureNumberOfTracks(IsDBSomething(xx("TracksGroup"), ""))
       If UCase(varxxMP3FileCompleted) = "Y" And InStr(1, varxxTracksGroup, "  1) ") > 0 And varxxNumberOfTracks > 0 Then%>
                                            <img alt="Tracks Listing" src="<%=AssetsPath()%>/yt2.gif"><br>
                                            <%varSongEnd = 1
       varTrackNumber = 0
       varEndOfTracks = 0
       varSongEnd = 1
       For n = 1 To varxxNumberOfTracks
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
        varSongTitle = Trim(Mid(varxxTracksGroup, varSongStart, varSongEnd - varSongStart + 1))%>
                                            <img name="T<%=xx("id")%>T<%=varLeadingZero%><%=n%>" id="T<%=xx("id")%>T<%=varLeadingZero%><%=n%>" class="img-sound" src="<%=AssetsPath()%>/ps4.gif" alt="Play song" title="Play sound sample" onclick="T('T<%=xx("id")%>T<%=varLeadingZero%><%=n%>','<%=MP3Folder(xx("id"))%>','ps4')" onmouseover="fov(this,'ps4')" onmouseout="fou(this,'ps4')"><%=n%>. <%=varSongTitle%><br>
                                            <%If varEndOfTracks = 1 Then Exit For
        Next
       ElseIf InStr(1, varxxTracksGroup, "  1) ") > 0 And varxxNumberOfTracks > 0 Then%>
                                            <img alt="Tracks Listing" src="<%=AssetsPath()%>/yt2.gif"><br>
                                            <%varSongEnd = 1
       varTrackNumber = 0
       varEndOfTracks = 0
       For n = 1 To varxxNumberOfTracks
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
                                            <img style="vertical-align: middle" src="<%=AssetsPath()%>/td8.gif"><%=n%>. <%=varSongTitle%><br>
                                            <%If varEndOfTracks = 1 Then Exit For
        Next
       Else%>
                                            <img alt="Tracks Listing" src="<%=AssetsPath()%>/yt.gif"><br>
                                            <%If varNumberOfImages > 1 Then%>
        Please click on the artwork to the right to view the tracks.  If there is a track listing on the back of the item, you may be able to read it by clicking on the artwork.  We apologize for not uploading the track listing yet.
       <%End If%>
                                            <%end if%>
                                        </p>
                                    </td>
                                    <td width="400" valign="top" align="left" style="border-left: 1px solid #FCF5E8; padding-top: 10px; padding-left: 10px">
                                        <%If varNumberOfImages = 1 Then
        If varSupersizeButton = 1 Then%>
                                        <img id="S<%=xx("id")%>" onmouseover="io(this)" onmouseout="iu(this)" onclick="TS(<%=xx("id")%>,'<%=varFirstImageSourceForSupersize%>')" title="Supersize image..." style="max-height: 180px; max-width: 180px; cursor: pointer; <%=varImageBorder%>" src="<%=varLoadingImageSource%>" onerror="this.onerror=null;this.src='<%=var_err_img%>'">
                                        <br>
                                        <img onclick="TS(<%=xx("id")%>,'<%=varFirstImageSourceForSupersize%>')" onmouseover="fov(this,'e6')" onmouseout="fou(this,'e6')" style="margin-bottom: 5px; cursor: pointer" src="<%=AssetsPath()%>/e6.gif">
                                        <%Else%>
                                        <img id="S<%=xx("id")%>" title="This item is IN STOCK NOW." style="<%=varImageBorder%>" src="<%=varFirstImageSource%>">
                                        <%End If%>
                                        <%else%>
                                        <table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
                                            <tr></tr>
                                        <td width="190" align="left" valign="top">
                                            <img id="S<%=xx("id")%>" onmouseover="io(this)" onmouseout="iu(this)" onclick="TS(<%=xx("id")%>,'<%=varFirstImageSourceForSupersize%>') " title="Supersize image..." style="max-height: 180px; max-width: 180px; cursor: pointer; <%=varImageBorder%>" src="<%=varLoadingImageSource%>" onerror="this.onerror=null;this.src='<%=var_err_img%>'">
                                            <br>
                                            <img onclick="TS(<%=xx("id")%>,'<%=varFirstImageSourceForSupersize%>')" onmouseover="fov(this,'e6')" onmouseout="fou(this,'e6')" style="margin-bottom: 5px; cursor: pointer" src="<%=AssetsPath()%>/e6.gif">
                                        </td>
                                    <td width="190" align="left" valign="top">
                                        <img id="SB<%=xx("id")%>" onmouseover="io(this)" onmouseout="iu(this)" onclick="TS(<%=xx("id")%>,'<%=varSecondImageSourceForSupersize%>') " title="Supersize image..." style="max-height: 180px; max-width: 180px; cursor: pointer; <%=varImageBorder%>" src="<%=varLoadingImageSource%>" onerror="this.onerror=null;this.src='<%=var_err_img%>'">
                                        <br>
                                        <img onclick="TS(<%=xx("id")%>,'<%=varSecondImageSourceForSupersize%>')" onmouseover="fov(this,'e6')" onmouseout="fou(this,'e6')" style="margin-bottom: 5px; cursor: pointer" src="<%=AssetsPath()%>/e6.gif">
                                    </td>
                                </tr>
                            </table>
                            <%  End If%>
                            <br>
                            <p class="tracks">
                                <%  If IsDBSomething(xx("WebEssential"), "") = "y" Then%>
                                <img alt src="<%=AssetsPath()%>/ye2.gif"><br>
                                <%  End If
       If Not IsDBNull(xx("WebReviewHTML")) Then%>
                                <img src="<%=AssetsPath()%>/yr2.gif" /><br />
                                <%=FigureWebReviewText(xx("WebReviewHTML"))%><br />
                                <%  End If%>
                                <%  If Not IsDBNull(xx("musiciangroup")) Then%>
                                <img src="<%=AssetsPath()%>/ym1.gif" /><br />
                                <%=FigureMusiciansText(xx("musiciangroup"))%><br />
                                <%End If
       If Len(IsDBSomething(xx("producegroup"), "")) > 0 Then%>
                                <img src="<%=AssetsPath()%>/yp1.gif" /><br />
                                <%=FigureProduceText(xx("producegroup"))%><br />
                                <%End If
       If UCase(xx("UsedItem")) = "Y" Then%>
                                <img src="<%=AssetsPath()%>/condition6.gif"><br />
                                <%If xx("Format") = "CD" Then%>
                                <p class="tracks">All used CDs play perfectly And have brand-New jewel cases. Backed by our 100% money-back guarantee.</p>
                                <br />
                                <%ElseIf xx("Format") = "DVD" Then%>
                                <p class="tracks">All used DVDs play perfectly And are backed by our 100% money-back guarantee.</p>
                                <br />
                                <%ElseIf xx("Format") = "VHS" Then%>
                                <p class="tracks">All used VHS (videotapes) play perfectly And are backed by our 100% money-back guarantee.</p>
                                <br />
                                <%ElseIf xx("Format") = "CS" Then%>
                                <p class="tracks">All used cassette tapes play perfectly And are backed by our 100% money-back guarantee.</p>
                                <br />
                                <%Else%>
                                <%If IsDBSomething(xx("ConditionJacket"), "") <> "" Then%>
                                <p class="tracks">Jacket Condition = <%=xx("ConditionJacket")%></p>
                                <%If IsDBSomething(xx("ConditionText"), "") <> "" Then%>
                                <div class="ctd" style="z-index: 2000" id="CJD<%=xx("id")%>" onclick="hideConditionTextDiv('CJD<%=xx("id")%>')">
                                    <p class="condition-text-div"><%=xx("ConditionText")%></p>
                                </div>
                                <img onclick="showConditionTextDiv('CJD<%=xx("id")%>')" style="cursor: pointer; margin-top: 2px; margin-left: 5px; vertical-align: top" src="<%=AssetsPath()%>/qb.gif" />
                                <%End If%>
                                <br />
                                <%End If%>
                                <%End If%>

                                <%If IsDBSomething(xx("ConditionVinylOrCD"), "") <> "" And (xx("Format") = "LP" Or xx("Format") = "12""" Or xx("Format") = "10""" Or xx("Format") = "7""") Then%>
                                <p class="tracks">Vinyl Condition &nbsp;&nbsp;= <%=xx("ConditionVinylOrCD")%></p>
                                <%If IsDBSomething(xx("ConditionText"), "") <> "" Then%>
                                <div class="ctd" style="z-index: 2000" id="CVD<%=xx("id")%>" onclick="hideConditionTextDiv('CVD<%=xx("id")%>')">
                                    <p class="condition-text-div"><%=xx("ConditionText")%></p>
                                </div>
                                <img onclick="showConditionTextDiv('CVD<%=xx("id")%>')" style="cursor: pointer; margin-top: 2px; margin-left: 5px; vertical-align: top" src="<%=AssetsPath()%>/qb.gif" />
                                <%End If%>
                                <br />
                                <%End If%>

                                <%If IsDBSomething(xx("ConditionNotes"), "") <> "" Then%>
                                <p class="tracks"><%=xx("ConditionNotes")%></p>
                                <br />
                                <%End If%>
                                <%End If%>
                            </p>
                        </td>
                    </tr>
                </table>
        </td>
        </tr>
    </table>
    <table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
        <tr>
            <td height="28" style="background: url('<%=AssetsPath()%>/div12.gif'); background-repeat: no-repeat">&nbsp;
            </td>
        </tr>
    </table>
    </div>
    <input type="hidden" name="Y<%=xx("id")%>" id="Y<%=xx("id")%>">
    <%  Else  'Not CD or LP%>
    <table cellpadding="0" border="0" cellspacing="0" width="1250" align="center" bgcolor="C0CAC0">
        <%  If Session("PowerUserName") <> "" Then%>
        <td width="400"></td>
        <td width="950">
            <%  Else%>
        <td width="335"></td>
        <td width="885">
            <%end if%>
            <div class="q" id="I<%=xx("id")%>T">
                <table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
                    <tr>
                        <td height="28" style="background: url('<%=AssetsPath()%>/div10.gif'); background-repeat: no-repeat" onclick="ICP(<%=xx("id")%>,'<%=varFormatIcon%>')" onmouseup="document.getElementById('OAB<%=xx("id")%>').focus()">&nbsp;
                        </td>
                    </tr>
                </table>
                <table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
                    <tr>
                        <td style="background: url('<%=AssetsPath()%>/div11.gif'); background-repeat: repeat-y">
                            <table width="891" bgcolor="EAD5AD" cellpadding="0" style="border-bottom: 1px solid #B29F7C" cellspacing="0" align="center" border="0">
                            <td width="63" style="padding-top: 4px" align="left" valign="top">
                                <%Response.Write("<input border=""0""type=""image"" src=""" + AssetsPath() + "/ic3.gif""style=""cursor: pointer"" onclick=""ICP(" & xx("id") & ",'" & varFormatIcon & "');VS=0"">")%>
                            </td>
                        <td width="608" valign="top" style="line-height: 75%; padding-left: 5px; padding-top: 8px; padding-bottom: 11px">
                            <p class="et" style="color: #242424"><%=varAT%></p>
                            <span class="f2">&nbsp;<%=varStockText%></span>
                        </td>
                        <td width="90" align="right" valign="top" style="padding-top: 4px">
                            <%  If xx("Inventory") > 0 Then%>
                            <img alt src="<%=AssetsPath()%>/ins5.gif">
                            <%  End If%>
                        </td>
                    </tr>
                </table>
                <table width="891" cellpadding="0" style="border-top: 1px solid #FCF5E8" cellspacing="0" align="center" border="0">
                    <tr>
                        <td width="491" valign="top" align="left" style="border-right: 1px solid #B6A28F; padding-top: 10px">
                            <%'InventoryItemFeatures
 If Not IsDBNull(xx("ItemFeatures1")) Then%>
                            <table align="center" bgcolor="F0DEBE" cellpadding="0" cellspacing="0" width="491" border="0">
                                <%For intIF = 1 To 10
        If IsDBNull(xx("ItemFeatures" & intIF)) Then Exit For
        strItemFeature = xx("ItemFeatures" & intIF)
        intPipe1 = InStr(xx("ItemFeatures" & intIF), "|1|")
        intPipe2 = InStr(xx("ItemFeatures" & intIF), "|2|")
        intPipe3 = InStr(xx("ItemFeatures" & intIF), "|3|")
        intPipe4 = InStr(xx("ItemFeatures" & intIF), "|4|")
        intPipe5 = InStr(xx("ItemFeatures" & intIF), "|5|")
        If intPipe2 - intPipe1 > 3 Then
         strItemFeatureIDText = Mid(strItemFeature, intPipe1 + 3, intPipe2 - intPipe1 - 3)
        Else
         strItemFeatureIDText = ""
        End If
        If intPipe3 - intPipe2 > 3 Then
         strItemFeatureWebProductDetailsPageHyperlinkText = Mid(strItemFeature, intPipe2 + 3, intPipe3 - intPipe2 - 3)
        Else
         strItemFeatureWebProductDetailsPageHyperlinkText = ""
        End If
        If intPipe4 - intPipe3 > 3 Then
         strItemFeatureWebProductDetailsPageText = Mid(strItemFeature, intPipe3 + 3, intPipe4 - intPipe3 - 3)
        Else
         strItemFeatureWebProductDetailsPageText = ""
        End If
        If intPipe5 - intPipe4 > 3 Then
         strItemFeatureWebGalleryText = Mid(strItemFeature, intPipe4 + 3, intPipe5 - intPipe4 - 3)
        Else
         strItemFeatureWebGalleryText = ""
        End If%>
                                <tr>
                                    <td width="20" height="19" style="vertical-align: top; text-align: left">
                                        <img src="<%=AssetsPath()%>/wt.gif" style="vertical-align: top" />
                                    </td>
                                    <td width="471" style="vertical-align: top; text-align: left">
                                        <%If strItemFeatureWebProductDetailsPageHyperlinkText <> "" Then%>
                                        <div class="fdt" style="z-index: 2000" id="IF<%=xx("id")%>-<%=strItemFeatureIDText%>" onclick="hideItemFeaturesDiv('<%=xx("id")%>-<%=strItemFeatureIDText%>')">
                                            <p class="item-features-div-thumbnaildiv"><%=Replace(Replace(strItemFeatureWebProductDetailsPageHyperlinkText, "NEW PARAGRAPH ", "<br/><br/>"), """", "'")%></p>
                                        </div>
                                        <%End If%>
                                        <a class="if-thd" href="/home.aspx?X3QT=ItemFeature&X3AID=<%=strItemFeatureIDText%>"><%=strItemFeatureWebProductDetailsPageText%></a>
                                        <%If strItemFeatureWebProductDetailsPageHyperlinkText <> "" Then%>
                                        <p class="whats-this-thumbnail" onclick="showItemFeaturesDiv('<%=xx("id")%>-<%=strItemFeatureIDText%>')">What's&nbsp;this?</p>
                                        <%End If%>
                                    </td>
                                </tr>
                                <%next%>
                            </table>
                            <table align="center" bgcolor="F0DEBE" cellpadding="0" cellspacing="0" width="491" border="0">
                                <tr>
                                    <td height="8"></td>
                                </tr>
                            </table>
                            <%End If%>
                            <p class="tracks">
                                <%varxxTracksGroup = IsDBSomething(xx("TracksGroup"), "")
       If IsDBNull(xx("NumberOfTracks")) Then
        varxxNumberOfTracks = 0
       Else
        varxxNumberOfTracks = xx("NumberOfTracks")
       End If
       If UCase(varxxMP3FileCompleted) = "Y" And InStr(1, varxxTracksGroup, "  1) ") > 0 And varxxNumberOfTracks > 0 Then%>
                                <img alt="Tracks Listing" src="<%=AssetsPath()%>/yt2.gif"><br>
                                <%varSongEnd = 1
       varTrackNumber = 0
       varEndOfTracks = 0
       For n = 1 To varxxNumberOfTracks
        varLeadingZero = ""
        varTrackNumber = n
        If varTrackNumber < 10 Then varLeadingZero = "0"
        varSongStart = InStr(varSongEnd, varxxTracksGroup, varTrackNumber & ") ") + 3
        varSongEnd = InStr(varSongStart, varxxTracksGroup, "  ") - 1
        If varSongEnd <= 0 Then
         varSongEnd = Len(varxxTracksGroup)
         varEndOfTracks = 1
        End If
        varSongTitle = Mid(varxxTracksGroup, varSongStart, varSongEnd - varSongStart + 1)%>
                                <img name="T<%=xx("id")%>T<%=varLeadingZero%><%=n%>" id="T<%=xx("id")%>T<%=varLeadingZero%><%=n%>" class="img-sound" src="<%=AssetsPath()%>/ps4.gif" alt="Play song" title="Play sound sample" onclick="T('T<%=xx("id")%>T<%=varLeadingZero%><%=n%>','<%=MP3Folder(xx("id"))%>','ps4')" onmouseover="fov(this,'ps4')" onmouseout="fou(this,'ps4')"><%=n%>. <%=varSongTitle%><br>
                                <%If varEndOfTracks = 1 Then Exit For
        Next
       ElseIf InStr(1, varxxTracksGroup, "  1) ") > 0 And varxxNumberOfTracks > 0 Then%>
                                <img alt="Tracks Listing" src="<%=AssetsPath()%>/yt2.gif"><br>
                                <%varSongEnd = 1
       varTrackNumber = 0
       varEndOfTracks = 0
       For n = 1 To varxxNumberOfTracks
        varLeadingZero = ""
        varTrackNumber = n
        If varTrackNumber < 10 Then varLeadingZero = "0"
        varSongStart = InStr(varSongEnd, varxxTracksGroup, varTrackNumber & ") ") + 3
        varSongEnd = InStr(varSongStart, varxxTracksGroup, "  ") - 1
        If varSongEnd <= 0 Then
         varSongEnd = Len(varxxTracksGroup)
         varEndOfTracks = 1
        End If
        varSongTitle = Mid(varxxTracksGroup, varSongStart, varSongEnd - varSongStart + 1)%>
                                <img style="vertical-align: middle" src="<%=AssetsPath()%>/td8.gif"><%=n%>. <%=varSongTitle%><br>
                                <%If varEndOfTracks = 1 Then Exit For
          Next
         End If%>
                                <%   If IsDBSomething(xx("WebEssential"), "") = "y" Then%>
                                <img alt src="<%=AssetsPath()%>/ye2.gif"><br>
                                <%  End If
       If Not IsDBNull(xx("WebReviewHTML")) Then%>
                                <img src="<%=AssetsPath()%>/yr2.gif" /><br />
                                <%=FigureWebReviewText(xx("WebReviewHTML"))%><br>
                                <%  End If%>
                                <%  If Not IsDBNull(xx("musiciangroup")) Then%>
                                <img src="<%=AssetsPath()%>/ym1.gif" /><br />
                                <%=FigureMusiciansText(xx("musiciangroup"))%><br>
                                <%  End If
         If Len(IsDBSomething(xx("producegroup"), "")) > 0 Then%>
                                <img src="<%=AssetsPath()%>/yp1.gif" /><br />
                                <%=FigureProduceText(xx("producegroup"))%><br>
                                <%  End If
       If UCase(xx("UsedItem")) = "Y" Then%>
                                <img src="<%=AssetsPath()%>/condition6.gif"><br />
                                <%If xx("Format") = "CD" Then%>
                            <p class="tracks">All used CDs play perfectly and have brand-new jewel cases. Backed by our 100% money-back guarantee.</p>
                            <br />
                            <%ElseIf xx("Format") = "DVD" Then%>
                            <p class="tracks">All used DVDs play perfectly and are backed by our 100% money-back guarantee.</p>
                            <br />
                            <%ElseIf xx("Format") = "VHS" Then%>
                            <p class="tracks">All used VHS (videotapes) play perfectly and are backed by our 100% money-back guarantee.</p>
                            <br />
                            <%ElseIf xx("Format") = "CS" Then%>
                            <p class="tracks">All used cassette tapes play perfectly and are backed by our 100% money-back guarantee.</p>
                            <br />
                            <%Else%>
                            <%If IsDBSomething(xx("ConditionJacket"), "") <> "" Then%>
                            <p class="tracks">Jacket Condition = <%=xx("ConditionJacket")%></p>
                            <%If IsDBSomething(xx("ConditionText"), "") <> "" Then%>
                            <div class="ctd" style="z-index: 2000" id="CJD<%=xx("id")%>" onclick="hideConditionTextDiv('CJD<%=xx("id")%>')">
                                <p class="condition-text-div"><%=xx("ConditionText")%></p>
                            </div>
                            <img onclick="showConditionTextDiv('CJD<%=xx("id")%>')" style="cursor: pointer; margin-top: 2px; margin-left: 5px; vertical-align: top" src="<%=AssetsPath()%>/qb.gif" />
                            <%End If%>
                            <br />
                            <%End If%>
                            <%End If%>

                            <%If IsDBSomething(xx("ConditionVinylOrCD"), "") <> "" And (xx("Format") = "LP" Or xx("Format") = "12""" Or xx("Format") = "10""" Or xx("Format") = "7""") Then%>
                            <p class="tracks">Vinyl Condition &nbsp;&nbsp;= <%=xx("ConditionVinylOrCD")%></p>
                            <%If IsDBSomething(xx("ConditionText"), "") <> "" Then%>
                            <div class="ctd" style="z-index: 2000" id="CVD<%=xx("id")%>" onclick="hideConditionTextDiv('CVD<%=xx("id")%>')">
                                <p class="condition-text-div"><%=xx("ConditionText")%></p>
                            </div>
                            <img onclick="showConditionTextDiv('CVD<%=xx("id")%>')" style="cursor: pointer; margin-top: 2px; margin-left: 5px; vertical-align: top" src="<%=AssetsPath()%>/qb.gif" />
                            <%End If%>
                            <br />
                            <%End If%>

                            <%If IsDBSomething(xx("ConditionNotes"), "") <> "" Then%>
                            <p class="tracks"><%=xx("ConditionNotes")%></p>
                            <br />
                            <%End If%>
                            <%End If%>
    </font>
                        </td>
                        <td width="400" valign="top" align="left" style="border-left: 1px solid #FCF5E8; padding-top: 10px; padding-left: 10px">
                            <%if varNumberOfImages=1 then
     if varSupersizeButton=1 then%>
                            <img id="S<%=xx("id")%>" onmouseover="io(this)" onmouseout="iu(this)" onclick="TS(<%=xx("id")%>,'<%=varFirstImageSourceForSupersize%>')" title="Supersize image..." style="width: 180px; cursor: pointer; <%=varImageBorder%>" src="<%=varLoadingImageSource%>" onerror="this.onerror=null;this.src='<%=var_err_img%>'">
                            <%  Else%>
                            <img id="S<%=xx("id")%>" title="This item is IN STOCK NOW." style="<%=varImageBorder%>" src="<%=varFirstImageSource%>">
                            <%  End If%>
                            <%if varSupersizeButton=1 then%>
                            <br>
                            <img onclick="TS(<%=xx("id")%>,'<%=varFirstImageSourceForSupersize%>')" onmouseover="fov(this,'e6')" onmouseout="fou(this,'e6')" style="margin-bottom: 5px; cursor: pointer" src="<%=AssetsPath()%>/e6.gif">
                            <%  End If%>
                            <%else%>
                            <table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
                                <tr></tr>
                            <td width="190" align="left" valign="top">
                                <img id="S<%=xx("id")%>" onmouseover="io(this)" onmouseout="iu(this)" onclick="TS(<%=xx("id")%>,'<%=varFirstImageSourceForSupersize%>')" title="Supersize image..." style="max-height: 180px; max-width: 180px; cursor: pointer; <%=varImageBorder%>" src="<%=varLoadingImageSource%>" onerror="this.onerror=null;this.src='<%=var_err_img%>'">
                                <br>
                                <img onclick="TS(<%=xx("id")%>,'<%=varFirstImageSourceForSupersize%>')" onmouseover="fov(this,'e6')" onmouseout="fou(this,'e6')" style="margin-bottom: 5px; cursor: pointer" src="<%=AssetsPath()%>/e6.gif">
                            </td>
                        <td width="190" align="left" valign="top">
                            <img id="SB<%=xx("id")%>" onmouseover="io(this)" onmouseout="iu(this)" onclick="TS(<%=xx("id")%>,'<%=varSecondImageSourceForSupersize%>')" title="Supersize image..." style="max-height: 180px; max-width: 180px; cursor: pointer; <%=varImageBorder%>" src="<%=varLoadingImageSource%>" onerror="this.onerror=null;this.src='<%=var_err_img%>'">
                            <br>
                            <img onclick="TS(<%=xx("id")%>,'<%=varSecondImageSourceForSupersize%>')" onmouseover="fov(this,'e6')" onmouseout="fou(this,'e6')" style="margin-bottom: 5px; cursor: pointer" src="<%=AssetsPath()%>/e6.gif">
                        </td>
                    </tr>
                </table>
                <%  End If%>
        </td>
        </tr>
    </table>
    </td></tr></table>
    <table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
        <tr>
            <td height="28" style="background: url('<%=AssetsPath()%>/div12.gif'); background-repeat: no-repeat">&nbsp;
            </td>
        </tr>
    </table>
    </div>
    </td></table>
    <input type="hidden" name="Y<%=xx("id")%>" id="Y<%=xx("id")%>">
    <%  End If%>
   </td></table>
   <table class="z" align="center" cellpadding="0" cellspacing="0" border="0">

       <tr>
           <td class="x_foot" height="100">
               <%'Price %>
               <%If session("SuperPowerUserName")<>"" then%>
               <font class="b" title="Cost" style="font-size: 10px; color: #000000; text-decoration: underline; cursor: default"><%=FormatNumber(xx("Cost"), 2)%></font>
               <br>
               <font class="b" title="Price before any price adjustments" style="font-size: 10px; color: #000000; cursor: default"><%=FormatNumber(varPriceUsing, 2)%></font>
               <%if varSaleItem=1 then
     if session("PriceGroup")="StorePrice" or session("PriceGroup")="ExportPrice" then%>
               <font class="b-strike" style="font-size: 11px"><%=formatcurrency(varPriceGroupPrice,2)%></font><br>
               <%else%>
               <font class="b-strike" style="font-size: 11px"><%=formatcurrency(varPriceGroupPrice,2)%></font><br>
               <%end if%>
               <%end if%>
               <input type="text" title="Price (editable for this customer)" value="<%=formatnumber(varCartPrice,2)%>" style="width: 40px; font-size: 9px; margin-top: 2px; background-color: #<%=varCartFColor%>" id="PR<%=xx("id")%>" class="x" onkeydown="Sc();VS=0" tabindex="0" onchange="CQ(<%=xx("id")%>,this.value,0,0)" name="PR<%=xx("id")%>" maxlength="6">
               <%else%>
               <%if varInStock=0 and varCartPage=1 then%>
               <p class="t-price" style="color: #5B685B"><%=formatcurrency(varPriceUsing,2)%></p>
               <%else%>
               <%if varSaleItem=1 then
      if session("PriceGroup")="StorePrice" or session("PriceGroup")="ExportPrice" then%>
               <font class="b-strike" style="padding-right: 0px"><%=formatcurrency(varPriceGroupPrice,2)%></font>
               <br>
               <font class="b" style="padding-right: 0px; color: #ff0000"><%=formatcurrency(xx("Sale_WholesalePrice"),2)%></font>
               <%else%>
               <font class="b-strike" style="padding-right: 0px"><%=formatcurrency(varPriceGroupPrice,2)%></font>
               <br>
               <font class="b" style="padding-right: 0px; color: #ff0000"><%=formatcurrency(xx("Sale_RetailPrice"),2)%></font>
               <%end if%>
               <%else%>
               <p class="t-price"><%=formatcurrency(varPriceUsing,2)%></p>
               <%end if%>
               <%end if%>
               <%end if%>
               <%'Similar Items%>
               <%If varSimilarItemsAvailable = 1 Then%>
               <br />
               <p class="thumbnail-similar" title="Show similar items." onclick="SI('<%=xx("ID")%>')">
                   Show<br />
                   Similar Items
               </p>
               <%End If
    If UCase(IsDBSomething(xx("MP3FileCompleted"), "")) = "Y" And InStr(1, varxxTracksGroup, "  1) ") > 0 And varxxNumberOfTracks > 0 Then%>
               <% Response.Write("<br/><img alt title=""Play sound.""style=""cursor:pointer;margin-top:8px"" name=""ST" & xx("id") & """ id=""ST" & xx("id") & """ align=""top"" ONCLICK=""T2('T" & xx("id") & "T01','" & xx("id") & "'," & varNumberOfImages & ",'" & varFirstImageSource & "','" & varSecondImageSource & "','" & MP3Folder(xx("id")) & "','ps4');VS=0"" src=""" + AssetsPath() + "si9.gif""/>")%>
               <%  End If%>
               <%'Add To Cart Buttons, Format, Save For Later%>
           </td>
           <td class="X_add" style="background-image: url(<%=AssetsPath()%>/t-bg2.gif); background-color: #ffffff; background-repeat: no-repeat">
               <div class="yc1" style="z-index: 2000; margin-left: -126px; margin-top: 29px" name="YC<%=xx("ID")%>" id="YC<%=xx("ID")%>">
                   <img src="<%=AssetsPath()%>/f-ych2.gif">
               </div>
               <%If varCartPage = 1 And Session("StoreName") <> "" Then %>
               <%If IsDBSomething(xx("SaveForLater"), "") = "y" Then %>
               <div style="position: absolute; text-align: center; visibility: hidden; width: 127px; height: 46px; z-index: 1000; margin-left: 0px; margin-top: 59px" name="SFL<%=xx("ID")%>" id="SFL<%=xx("ID")%>">
                   <%Response.Write("<img src='" + AssetsPath() + "/sfl3.gif'title=""Click here to save this item for a future purchase.""style=""cursor:pointer""onclick=""SFL(" & xx("id") & ",1)""onmouseover=""fov(this,'sfl3')"" onmouseout=""fou(this,'sfl3')"">")%>
               </div>
               <div style="position: absolute; text-align: center; visibility: visible; width: 127px; height: 45px; z-index: 1000; margin-left: 0px; margin-top: 45px" name="SDFL<%=xx("ID")%>" id="SDFL<%=xx("ID")%>">
                   <%Response.Write("<img src='" + AssetsPath() + "/sdfl7.gif'title=""Click here to move this item back into your shopping cart.""style=""cursor:pointer""onclick=""SFL(" & xx("id") & ",0)""onmouseover=""fov(this,'sdfl7')"" onmouseout=""fou(this,'sdfl7')"">")%>
               </div>
               <%  Else%>
               <div style="position: absolute; text-align: center; visibility: visible; width: 127px; height: 46px; z-index: 1000; margin-left: 0px; margin-top: 59px" name="SFL<%=xx("ID")%>" id="SFL<%=xx("ID")%>">
                   <%Response.Write("<img src='" + AssetsPath() + "/sfl3.gif'title=""Click here to save this item for a future purchase.""style=""cursor:pointer""onclick=""SFL(" & xx("id") & ",1)""onmouseover=""fov(this,'sfl3')"" onmouseout=""fou(this,'sfl3')"">")%>
               </div>
               <div style="position: absolute; text-align: center; visibility: hidden; width: 127px; height: 45px; z-index: 1000; margin-left: 0px; margin-top: 45px" name="SDFL<%=xx("ID")%>" id="SDFL<%=xx("ID")%>">
                   <%Response.Write("<img src='" + AssetsPath() + "/sdfl7.gif'title=""Click here to move this item back into your shopping cart.""style=""cursor:pointer""onclick=""SFL(" & xx("id") & ",0)""onmouseover=""fov(this,'sdfl7')"" onmouseout=""fou(this,'sdfl7')"">")%>
               </div>
               <%  End If%>
               <%end if%>
               <table cellpadding="0" border="0" cellspacing="0" width="127" align="center" style="vertical-align: top">
                   <tr>
                       <td width="32" style="text-align: right; vertical-align: top; padding-top: 13px">
                           <%  Response.Write("<input alt border=""0"" align=""top"" type=""image"" title=""Remove item from cart."" ONCLICK=""CQ(" & xx("id") & "," & varPriceForCartAddText & ",-1,'OA',0)""onmouseover=""fov(this,'f-x2')"" onmouseout=""fou(this,'f-x2')"" style=""border-width:0px;cursor:pointer"" src=""" + AssetsPath() + "/f-x2.gif"">")%>
                       </td>
                       <td width="28" style="text-align: center; vertical-align: top; padding-top: 14px">
                           <%  If intQuantityInCart > 0 Then%>
                           <input type="text" id="OA<%=xx("id")%>" name="OA<%=xx("id")%>" class="oa_x" onkeydown="Sc();VS=0" tabindex="<%=z%>" onkeyup="CQ(<%=xx("id")%>,<%=varPriceForCartAddText%>,0,'OA',1)" value="<%=intQuantityInCart%>" maxlength="3">
                           <%  Else%>
                           <input type="text" id="OA<%=xx("id")%>" name="OA<%=xx("id")%>" class="oa" onkeydown="Sc();VS=0" tabindex="<%=z%>" onkeyup="CQ(<%=xx("id")%>,<%=varPriceForCartAddText%>,0,'OA',1)" maxlength="3">
                           <%  End If%>
                       </td>
                       <td width="22" style="text-align: left; vertical-align: top; padding-top: 13px">
                           <%  Response.Write("<input alt border=""0"" align=""top"" type=""image"" title=""Add 1 to quantity in cart."" ONCLICK=""CQ(" & xx("id") & "," & varPriceForCartAddText & ",1,'OA',0)""onmouseover=""fov(this,'f-add2')"" onmouseout=""fou(this,'f-add2')"" style=""border-width:0px;cursor:pointer"" src=""" + AssetsPath() + "/f-add2.gif"">")%>
                       </td>
                       <td width="45" style="text-align: left; vertical-align: top; padding-top: 12px">
                           <%  If xx("Format") = "CD" Then%>
                           <img title="CD (Compact Disc)" style="margin-left: 3px" src="<%=AssetsPath()%>/g-cd2.gif">
                           <%  ElseIf xx("Format") = "LP" Then%>
                           <img title="LP (Vinyl Record)" style="margin-left: 3px" src="<%=AssetsPath()%>/g-lp2.gif">
                           <%  ElseIf xx("Format") = "CS" Then%>
                           <img title="Audio Cassette Tape" style="margin-left: 3px" src="<%=AssetsPath()%>/g-cs2.gif">
                           <%  ElseIf Left(xx("Format"), 1) = "V" Then%>
                           <img title="Video" style="margin-left: 3px" src="<%=AssetsPath()%>/g-vhs2.gif">
                           <%  ElseIf Left(xx("Format"), 1) = "7" Then%>
                           <img title="7 Inch Vinyl Record" style="margin-left: 3px" src="<%=AssetsPath()%>/g-72.gif">
                           <%  ElseIf Left(xx("Format"), 2) = "12" Then%>
                           <img title="12 Inch Vinyl Record" style="margin-left: 3px" src="<%=AssetsPath()%>/g-122.gif">
                           <%  ElseIf Left(xx("Format"), 2) = "10" Then%>
                           <img title="10 Inch Vinyl Record" style="margin-left: 3px" src="<%=AssetsPath()%>/g-102.gif">
                           <%  ElseIf xx("Format") = "CDS" Then%>
                           <img title="CD Single" style="margin-left: 3px" src="<%=AssetsPath()%>/g-cd2.gif">
                           <%  ElseIf xx("Format") = "DVD" Then%>
                           <img title="DVD (Video)" style="margin-left: 3px" src="<%=AssetsPath()%>/g-dvd2.gif">
                           <%  End If%>

                       </td>
                   </tr>
               </table>

               <%'Image%>
           </td>
           <td class="x_I">
               <img src="<%=varThumbnailImageSource%>" class="x_II" onclick="ICI(<%=xx("id")%>,<%=varNumberOfImages%>,'<%=varFirstImageSource%>','<%=varSecondImageSource%>');VS=0" onmouseover="iover(this,<%=xx("id")%>)" onmouseout="iout(this,<%=xx("id")%>)" onerror="this.onerror=null;this.src='<%=var_err_img%>'">
               <%' Inventory and Date Last Bought
       If Session("SuperPowerUserName") <> "" Then
        If xx("Deleted") = "y" Then
         varInv = "DEL"
         varFC = "ff0000"
        Else
         If xx("Inventory") = 0 Then
          varInv = "0"
          varFC = "ff0000"
         Else
          varFC = "000000"
          varInv = xx("Inventory")
         End If
        End If
        If strMostRecentDateBoughtItem <> "" Then
         varPadTop = "0"
         intDaysSinceBought = DateDiff("d", strMostRecentDateBoughtItem, Date.Now)
        Else
         varPadTop = "7"
        End If%>
           </td>
           <td class="k" style="width: 30; background-color: #ffffff; text-align: center; border-right: 1px solid #C0CAC0; padding-top: <%=varPadTop%>px; padding-left: 2px; line-height: 65%">
               <%   If strMostRecentDateBoughtItem <> "" Then%>
               <font class="b" style="font-size: 9px; color: #<%=varFC%>; cursor: default"><span title="Inventory"><%=varInv%></span><br>
                   <span title="Days since last bought" style="color: #ff0000; margin-left: 0px; cursor: default"><%=intDaysSinceBought%></span>
                   <%   Else%>
                   <font class="b" style="font-size: 9px; color: #<%=varFC%>; cursor: default"><span title="Inventory"><%=varInv%></span>
                       <%   End If%>
                   </font>
                   <%end if%>
                   <%'Pointer%>
           </td>
           <td class="x_PO" style="background-image: url(<%=AssetsPath()%>/b4.gif); background-repeat: repeat-x; background-position: top" name="PB<%=xx("ID")%>" id="PB<%=xx("ID")%>">
               <img src="<%=AssetsPath()%>/pr3s.gif" style="margin-left: -3px" name="PO<%=xx("id")%>" id="PO<%=xx("id")%>">
               <%' Description 
    If Session("SuperPowerUserName") <> "" Then%>
           </td>
           <td class="pow_descr" style="background-image: url(<%=AssetsPath()%>/b4.gif); background-repeat: repeat-x; background-position: top">
               <%   Else%>
           </td>
           <td class="x_AT" style="background-image: url(<%=AssetsPath()%>/b4.gif); background-repeat: repeat-x; background-position: top" name="DB<%=xx("ID")%>" id="DB<%=xx("ID")%>">
               <%   End If
       If varInStock = 0 And varCartPage = 1 Then%>
               <strong><font class="b" style="font-size: 11px; color: #ffffff; background-color: #ff0000">&nbsp;OUT OF STOCK&nbsp;</font></strong>&nbsp;<font title="Click here for more information on how this item bacame out of stock." class="b"><a href='/outofstock.aspx' style="font-size: 9px; color: #ff0000">more info</a></font>
               <%   End If%>
               <p class="at"><%=varAT%></p>
               <%'InventoryItemFeatures
       If Not IsDBNull(xx("ItemFeatures1")) Then
        Response.Write("<p Class=""at"">")
        For intIF = 1 To 10
         If IsDBNull(xx("ItemFeatures" & intIF)) Then Exit For
         strItemFeature = xx("ItemFeatures" & intIF)
         intPipe1 = InStr(xx("ItemFeatures" & intIF), "|1|")
         intPipe2 = InStr(xx("ItemFeatures" & intIF), "|2|")
         intPipe3 = InStr(xx("ItemFeatures" & intIF), "|3|")
         intPipe4 = InStr(xx("ItemFeatures" & intIF), "|4|")
         intPipe5 = InStr(xx("ItemFeatures" & intIF), "|5|")
         intPipe6 = InStr(xx("ItemFeatures" & intIF), "|6|")
         If intPipe2 - intPipe1 > 3 Then
          strItemFeatureIDText = Mid(strItemFeature, intPipe1 + 3, intPipe2 - intPipe1 - 3)
         Else
          strItemFeatureIDText = ""
         End If
         If intPipe3 - intPipe2 > 3 Then
          strItemFeatureWebProductDetailsPageHyperlinkText = Mid(strItemFeature, intPipe2 + 3, intPipe3 - intPipe2 - 3)
         Else
          strItemFeatureWebProductDetailsPageHyperlinkText = ""
         End If
         If intPipe4 - intPipe3 > 3 Then
          strItemFeatureWebProductDetailsPageText = Mid(strItemFeature, intPipe3 + 3, intPipe4 - intPipe3 - 3)
         Else
          strItemFeatureWebProductDetailsPageText = ""
         End If
         If intPipe5 - intPipe4 > 3 Then
          strItemFeatureWebGalleryText = Mid(strItemFeature, intPipe4 + 3, intPipe5 - intPipe4 - 3)
         Else
          strItemFeatureWebGalleryText = ""
         End If
         If intPipe6 - intPipe5 > 3 Then
          strItemFeatureHoverText = Mid(strItemFeature, intPipe5 + 3, intPipe6 - intPipe5 - 3)
         Else
          strItemFeatureHoverText = ""
         End If
         If strItemFeatureWebGalleryText <> "" Then
          varItemFeatureTextThumbnailView = strItemFeatureWebGalleryText
         Else
          varItemFeatureTextThumbnailView = strItemFeatureWebProductDetailsPageText
         End If
         If strItemFeatureWebGalleryText <> "" Then%>
     (<a class="if-th" title="<%=Replace(strItemFeatureHoverText, """", " inch")%>" href="/home.aspx?X3QT=ItemFeature&X3AID=<%=strItemFeatureIDText%>"><%=Replace(strItemFeatureWebGalleryText, " ", "&nbsp;")%></a>)
    <%End If
        Next
        Response.Write("</p>")
       End If%>
   &nbsp;
   <p class="zl" title="Show all on this label" onclick="AL(<%=xx("id")%>)"><%=Trim(xx("Label"))%></p>
               <%  If Not IsDBNull(xx("Catalog")) And (Session("PriceGroup") = "StorePrice" Or Session("PriceGroup") = "ExportPrice") Then%>
               <font class="e"><%=" " & xx("Catalog")%></font>
               <%   End If
       If Not IsDBSomething(xx("rhythmname"), "") = "" And IsDBSomething(xx("rhythmname"), "") <> "zz" Then%>
    &nbsp;&nbsp;<p class="zl" title="Show all on this rhythm" onclick="AR(<%=xx("id")%>)"><%=Trim(xx("rhythmname"))%> rhythm</p>
               <%   End If
       If Not IsDBNull(xx("yearfrom")) Then
        If Not IsDBNull(xx("yearto")) And IsDBSomething(xx("yearto"), "") <> IsDBSomething(xx("yearfrom"), "") Then
         varYearString = Trim(xx("yearfrom")) & "-" & Trim(xx("yearto"))
        Else
         varYearString = xx("yearfrom")
        End If%>
               <font class="b" title="The years on our website refer to when the music was recorded. Most other websites show the year the item was released." style="color: #000000; cursor: default">&nbsp;<%=varYearString%></font>
               <%end if
   if varShowSales=1 then%>
               <font class="e" title="Date and quantity item last bought" style="cursor: default; color: #ff0000; font-size: 9px">&nbsp;&nbsp;<%=strMostRecentDateBoughtItem%>&nbsp;<%=strQuantityBought%></font>
               <%end If
          If varQueryType = "UPC" Then%>
               <br>
               <font class="e" style="color: #5555EF; font-size: 11px"><%=xx("UPC")%></font>
               <%  End If%>
               <%if varQueryType="ID" then%>
               <br>
               <font class="e" style="color: #5555EF; font-size: 11px">Item# <%=xx("ID")%></font>
               <%   End If%>
           </td>
   </table>
    <%elseif varDisplayType="Grid" then
       'Grid View                                                                                                          
       '                                                                                                                   %>
    <%if (z - 1) / 4 = Int((z - 1) / 4) Then%>
    <%if z<>1 then%>
     </td><td width="9" style="vertical-align: top; text-align: left"></td>
    </tr></table>
     <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
         <tr>
             <td height="13" align="left" valign="middle" width="1250"></td>
         </tr>
     </table>
    <%end if%>
    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td height="20" align="left" valign="middle" width="1250"></td>
        </tr>
    </table>
    <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td width="9"></td>
            <%end If
     Call RenderGridItem(varSearchID, xx("RhythmName"), xx("Genre1"), xx("YearFrom"), xx("YearTo"), xx("Label"), xx("ItemFeatures1"), xx("ItemFeatures2"), xx("ItemFeatures3"), xx("ItemFeatures4"), xx("ItemFeatures5"), xx("ItemFeatures6"), xx("ItemFeatures7"), xx("ItemFeatures8"), xx("ItemFeatures9"), xx("ItemFeatures10"), xx("TracksGroup"), varQueryType, 0, xx("ID"), xx("ArtistTitle"), xx("Format"), xx("StorePrice"), xx("RetailPrice"), xx("Sale_WholesalePrice"), xx("Sale_WholesaleEndDate"), xx("Sale_RetailPrice"), xx("Sale_RetailEndDate"), xx("UsedItem"), xx("MP3FileCompleted"), NameOfCart, strConnectionStringName)
    ElseIf varDisplayType="List" then
     'List View                                                                                                          
     '                                                                                                                   %>
            <%if z=1 then%>
            <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
                <tr>
                    <td height="13" width="1250"></td>
                </tr>
            </table>
            <table cellpadding="0" bgcolor="EBEBEB" cellspacing="0" width="1250" align="center" border="0">
                <tr>
                    <td bgcolor="DEDEDE" width="240" valign="top">
                        <table cellpadding="0" bgcolor="DEDEDE" valign="top" cellspacing="0" width="240" align="center" border="0">
                            <tr>
                                <td width="240" height="650" valign="top" align="center">
                                    <table cellpadding="0" bgcolor="DEDEDE" valign="top" align="center" cellspacing="0" width="240" border="0">
                                        <tr>
                                            <td width="225" height="37" valign="top" align="center" bgcolor="A9A8A8">
                                                <img alt="" style="cursor: pointer; margin-top: 10px" src="<%=AssetsPath()%>/b-reggae.gif" onclick="genreSearch('qqgs','Reggae','-')" onmouseover="fov(this,'b-reggae')" onmouseout="fou(this,'b-reggae')">
                                            </td>
                                            <td width="15"></td>
                                        </tr>
                                        <tr>
                                            <td width="225" height="37" valign="top" align="center" bgcolor="A9A8A8">
                                                <img alt="" style="cursor: pointer" src="<%=AssetsPath()%>/b-rock.gif" onclick="genreSearch('qqgs','Rock','-')" onmouseover="fov(this,'b-rock')" onmouseout="fou(this,'b-rock')">
                                            </td>
                                            <td width="15"></td>
                                        </tr>
                                        <tr>
                                            <td width="225" height="37" valign="top" align="center" bgcolor="A9A8A8">
                                                <img alt="" style="cursor: pointer" src="<%=AssetsPath()%>/b-jazz.gif" onclick="genreSearch('qqgs','Jazz','-')" onmouseover="fov(this,'b-jazz')" onmouseout="fou(this,'b-jazz')">
                                            </td>
                                            <td width="15"></td>
                                        </tr>
                                        <tr>
                                            <td width="225" height="37" valign="top" align="center" bgcolor="A9A8A8">
                                                <img alt="" style="cursor: pointer" src="<%=AssetsPath()%>/b-soul.gif" onclick="genreSearch('qqgs','Soul','-')" onmouseover="fov(this,'b-soul')" onmouseout="fou(this,'b-soul')">
                                            </td>
                                            <td width="15"></td>
                                        </tr>
                                        <tr>
                                            <td width="225" height="37" valign="top" align="center" bgcolor="A9A8A8">
                                                <img alt="" style="cursor: pointer" src="<%=AssetsPath()%>/b-blues.gif" onclick="genreSearch('qqgs','Blues','-')" onmouseover="fov(this,'b-blues')" onmouseout="fou(this,'b-blues')">
                                            </td>
                                            <td width="15"></td>
                                        </tr>
                                        <tr>
                                            <td width="225" height="37" valign="top" align="center" bgcolor="A9A8A8">
                                                <img alt="" style="cursor: pointer" src="<%=AssetsPath()%>/b-electronic.gif" onclick="genreSearch('qqgs','Electronic','-')" onmouseover="fov(this,'b-electronic')" onmouseout="fou(this,'b-electronic')">
                                            </td>
                                            <td width="15"></td>
                                        </tr>
                                        <tr>
                                            <td width="225" height="37" valign="top" align="center" bgcolor="A9A8A8">
                                                <img alt="" style="cursor: pointer" src="<%=AssetsPath()%>/b-funk.gif" onclick="genreSearch('qqgs','Funk','-')" onmouseover="fov(this,'b-funk')" onmouseout="fou(this,'b-funk')">
                                            </td>
                                            <td width="15"></td>
                                        </tr>
                                        <tr>
                                            <td width="225" height="37" valign="top" align="center" bgcolor="A9A8A8">
                                                <img alt="" style="cursor: pointer" src="<%=AssetsPath()%>/b-pop.gif" onclick="genreSearch('qqgs','Pop','-')" onmouseover="fov(this,'b-pop')" onmouseout="fou(this,'b-pop')">
                                            </td>
                                            <td width="15"></td>
                                        </tr>
                                        <tr>
                                            <td width="225" height="37" valign="top" align="center" bgcolor="A9A8A8">
                                                <img alt="" style="cursor: pointer" src="<%=AssetsPath()%>/b-rock-n-roll.gif" onclick="genreSearch('qqgs','Rock N Roll','-')" onmouseover="fov(this,'b-rock-n-roll')" onmouseout="fou(this,'b-rock-n-roll')">
                                            </td>
                                            <td width="15"></td>
                                        </tr>
                                        <tr>
                                            <td width="225" height="37" valign="top" align="center" bgcolor="A9A8A8">
                                                <img alt="" style="cursor: pointer" src="<%=AssetsPath()%>/b-r-b.gif" onclick="genreSearch('qqgs','R&B','-')" onmouseover="fov(this,'b-r-b')" onmouseout="fou(this,'b-r-b')">
                                            </td>
                                            <td width="15"></td>
                                        </tr>
                                        <tr>
                                            <td width="225" height="37" valign="top" align="center" bgcolor="A9A8A8">
                                                <img alt="" style="cursor: pointer" src="<%=AssetsPath()%>/b-brazilian.gif" onclick="genreSearch('qqgs','Brazilian','-')" onmouseover="fov(this,'b-brazilian')" onmouseout="fou(this,'b-brazilian')">
                                            </td>
                                            <td width="15"></td>
                                        </tr>
                                        <tr>
                                            <td width="225" height="37" valign="top" align="center" bgcolor="A9A8A8">
                                                <img alt="" style="cursor: pointer" src="<%=AssetsPath()%>/b-punk.gif" onclick="genreSearch('qqgs','Punk','-')" onmouseover="fov(this,'b-punk')" onmouseout="fou(this,'b-punk')">
                                            </td>
                                            <td width="15"></td>
                                        </tr>
                                        <tr>
                                            <td width="225" height="37" valign="top" align="center" bgcolor="A9A8A8">
                                                <img alt="" style="cursor: pointer" src="<%=AssetsPath()%>/b-country.gif" onclick="genreSearch('qqgs','Country','-')" onmouseover="fov(this,'b-country')" onmouseout="fou(this,'b-country')">
                                            </td>
                                            <td width="15"></td>
                                        </tr>
                                        <tr>
                                            <td width="225" height="37" valign="top" align="center" bgcolor="A9A8A8">
                                                <img alt="" style="cursor: pointer" src="<%=AssetsPath()%>/b-soul-jazz.gif" onclick="genreSearch('qqgs','Soul-Jazz','-')" onmouseover="fov(this,'b-soul-jazz')" onmouseout="fou(this,'b-soul-jazz')">
                                            </td>
                                            <td width="15"></td>
                                        </tr>
                                        <tr>
                                            <td width="225" height="37" valign="top" align="center" bgcolor="A9A8A8">
                                                <img alt="" style="cursor: pointer" src="<%=AssetsPath()%>/b-world.gif" onclick="genreSearch('qqgs','World','-')" onmouseover="fov(this,'b-world')" onmouseout="fou(this,'b-world')">
                                            </td>
                                            <td width="15"></td>
                                        </tr>
                                        <tr>
                                            <td width="225" height="37" valign="top" align="center" bgcolor="A9A8A8">
                                                <img alt="" style="cursor: pointer" src="<%=AssetsPath()%>/b-surf.gif" onclick="genreSearch('qqgs','Surf','-')" onmouseover="fov(this,'b-surf')" onmouseout="fou(this,'b-surf')">
                                            </td>
                                            <td width="15"></td>
                                        </tr>
                                        <tr>
                                            <td width="225" height="37" valign="top" align="center" bgcolor="A9A8A8">
                                                <img alt="" style="cursor: pointer" src="<%=AssetsPath()%>/b-hip-hop.gif" onclick="genreSearch('qqgs','Hip Hop','-')" onmouseover="fov(this,'b-hip-hop')" onmouseout="fou(this,'b-hip-hop')">
                                            </td>
                                            <td width="15"></td>
                                        </tr>
                                        <tr>
                                            <td width="225" height="37" valign="top" align="center" bgcolor="A9A8A8">
                                                <img alt="" style="cursor: pointer" src="<%=AssetsPath()%>/b-japanese.gif" onclick="genreSearch('qqgs','Japanese','-')" onmouseover="fov(this,'b-japanese')" onmouseout="fou(this,'b-japanese')">
                                            </td>
                                            <td width="15"></td>
                                        </tr>
                                        <tr>
                                            <td width="225" height="37" valign="top" align="center" bgcolor="A9A8A8">
                                                <img alt="" style="cursor: pointer" src="<%=AssetsPath()%>/b-garage.gif" onclick="genreSearch('qqgs','Garage','-')" onmouseover="fov(this,'b-garage')" onmouseout="fou(this,'b-garage')">
                                            </td>
                                            <td width="15"></td>
                                        </tr>
                                        <tr>
                                            <td width="225" height="37" valign="top" align="center" bgcolor="A9A8A8">
                                                <img alt="" style="cursor: pointer" src="<%=AssetsPath()%>/b-french-pop.gif" onclick="genreSearch('qqgs','French Pop','-')" onmouseover="fov(this,'b-french-pop')" onmouseout="fou(this,'b-french-pop')">
                                            </td>
                                            <td width="15"></td>
                                        </tr>
                                        <tr>
                                            <td width="225" height="37" valign="top" align="center" bgcolor="A9A8A8">
                                                <img alt="" style="cursor: pointer" src="<%=AssetsPath()%>/b-alternative-rock.gif" onclick="genreSearch('qqgs','Alternative Rock','-')" onmouseover="fov(this,'b-alternative-rock')" onmouseout="fou(this,'b-alternative-rock')">
                                            </td>
                                            <td width="15"></td>
                                        </tr>
                                        <tr>
                                            <td width="225" height="37" valign="top" align="center" bgcolor="A9A8A8">
                                                <img alt="" style="cursor: pointer" src="<%=AssetsPath()%>/b-vocal.gif" onclick="genreSearch('qqgs','Vocal','-')" onmouseover="fov(this,'b-vocal')" onmouseout="fou(this,'b-vocal')">
                                            </td>
                                            <td width="15"></td>
                                        </tr>
                                        <tr>
                                            <td width="225" height="37" valign="top" align="center" bgcolor="A9A8A8">
                                                <img alt="" style="cursor: pointer" src="<%=AssetsPath()%>/b-doo-wop.gif" onclick="genreSearch('qqgs','Doo Wop','-')" onmouseover="fov(this,'b-doo-wop')" onmouseout="fou(this,'b-doo-wop')">
                                            </td>
                                            <td width="15"></td>
                                        </tr>
                                        <tr>
                                            <td width="225" height="44" valign="top" align="center" bgcolor="A9A8A8">
                                                <img alt="" style="cursor: pointer" src="<%=AssetsPath()%>/b-rockabilly.gif" onclick="genreSearch('qqgs','Rockabilly','-')" onmouseover="fov(this,'b-rockabilly')" onmouseout="fou(this,'b-rockabilly')">
                                            </td>
                                            <td width="15"></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td width="1000" align="left" valign="top" style="background-color: #ffffff; text-align: left; vertical-align: top">
                        <table cellpadding="0" bgcolor="EBEBEB" cellspacing="0" width="1000" align="center" valign="top" border="0" style="background-color: #ffffff; text-align: left; vertical-align: top">
                            <tr>
                                <td width="1000" height="58" align="left" valign="top" style="background-color: #ffffff; text-align: left; vertical-align: top; background-image: url('<%=AssetsPath()%>/list-bg2.gif')"></td>
                            </tr>
                        </table>
                        <%end If
    varImageHoverText = xx("ArtistTitle")
    'Price
    varSaleItem =0
    if session("PriceGroup")="StorePrice" or session("PriceGroup")="ExportPrice" then
     if not isdbnull(xx("Sale_WholesalePrice")) and not isdbnull(xx("Sale_WholesaleEndDate")) then
      if datediff("d",Date.now,xx("Sale_WholesaleEndDate"))>=0 then
       varSaleItem=1
      end if
     end if
    else
     if not isdbnull(xx("Sale_RetailPrice")) and not isdbnull(xx("Sale_RetailEndDate")) then
      if datediff("d",Date.now,xx("Sale_RetailEndDate"))>=0 then
       varSaleItem=1
      end if
     end if
    end if
    if session("PriceGroup")="StorePrice" or session("PriceGroup")="ExportPrice" then
     varPriceGroupPrice=xx("StorePrice")
     if varSaleItem=1 then
      varPriceUsing=xx("Sale_WholesalePrice")
     else
      varPriceUsing=xx("StorePrice")
     end if
    else
     varPriceGroupPrice=xx("RetailPrice")
     if varSaleItem=1 then
      varPriceUsing=xx("Sale_RetailPrice")
     else
      varPriceUsing=xx("RetailPrice")
     end if
    end if
    varPriceForCartAddText=varPriceUsing
    intQuantityInCart=0
    Using conn2 As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
     SqlConnection.ClearPool(conn2)
     conn2.Open()
     Dim CMD_X2 As New SqlCommand("spIsItemInCart", conn2)
     CMD_X2.CommandType = Data.CommandType.StoredProcedure
     CMD_X2.Parameters.AddWithValue("@NameOfCart", NameOfCart)
     CMD_X2.Parameters.AddWithValue("@ItemID",  clng(xx("ID")))
     Dim readerX2 As SqlDataReader
     readerX2 = CMD_X2.ExecuteReader
     intQuantityInCart=0
     If readerX2.HasRows Then
      readerX2.Read
      intQuantityInCart=readerX2("Quantity")
      varCartPrice=readerX2("Price")
      If CDbl(varPriceUsing) > CDbl(varCartPrice) And DateDiff("d", readerX2("DateTime"), Date.Now) <= 30 Then
       varPriceUsing = varCartPrice
      End If
     End If
    End using
    'Year
    varListYearFrom=IsDBSomething(xx("YearFrom"),"")
    varListYearFromOriginal=IsDBSomething(xx("YearFrom"),"")
    varListYearToOriginal=IsDBSomething(xx("YearTo"),"")
    if not isdbnull(xx("YearFrom")) and not isdbnull(xx("YearTo")) then
     varListYearFrom=xx("YearFrom") & "-" & xx("YearTo")
    end If
    varAT = FigureArtistTitleWebHTMLForListView(xx("UsedItem"), xx("Format"), xx("ArtistTitle"))
                        %>
                        <table border="0" cellspacing="0" cellpadding="0" width="1000" style="border-collapse: collapse">
                            <tr>
                                <td width="1000" align="left" valign="top">
                                    <table border="0" cellspacing="0" cellpadding="0" width="1000" style="border-collapse: collapse">
                                        <tr>
                                            <td width="15" align="left" valign="top" style="background-image: url('<%=AssetsPath()%>/list-bg-left.gif'); background-repeat: repeat-y"></td>
                                            <td width="60" align="right" valign="top">
                                                <%if xx("Format")="CD" then%>
                                                <img style="margin-top: 0px; margin-right: 0px" title="CD (Compact Disc)" src="<%=AssetsPath()%>/l-cd.gif">
                                                <%elseif xx("Format")="LP" then%>
                                                <img style="margin-top: 0px; margin-right: 0px" title="LP (Vinyl Record)" src="<%=AssetsPath()%>/l-lp.gif">
                                                <%elseif xx("Format")="CS" then%>
                                                <img style="margin-top: 0px; margin-right: 0px" title="CS (Audio Cassette Tape)" src="<%=AssetsPath()%>/l-cs.gif">
                                                <%elseif left(xx("Format"),1)="V" then%>
                                                <img style="margin-top: 0px; margin-right: 0px" title="VHS (Video)" src="<%=AssetsPath()%>/l-vhs.gif">
                                                <%elseif left(xx("Format"),1)="7" then%>
                                                <img style="margin-top: 0px; margin-right: 0px" title="7 Inch Vinyl Record" src="<%=AssetsPath()%>/l-7.gif">
                                                <%elseif left(xx("Format"),2)="12" then%>
                                                <img style="margin-top: 0px; margin-right: 0px" title="12 Inch Vinyl Record" src="<%=AssetsPath()%>/l-12.gif">
                                                <%elseif left(xx("Format"),2)="10" then%>
                                                <img style="margin-top: 0px; margin-right: 0px" title="10 Inch Vinyl Record" src="<%=AssetsPath()%>/l-10.gif">
                                                <%elseif xx("Format")="CDS" then%>
                                                <img style="margin-top: 0px; margin-right: 0px" title="CD Single" src="<%=AssetsPath()%>/l-cd.gif">
                                                <%elseif xx("Format")="DVD" then%>
                                                <img style="margin-top: 0px; margin-right: 0px" title="DVD (Video)" src="<%=AssetsPath()%>/l-dvd.gif">
                                                <%else%>
                                                <p class="p_format" style="margin-top: 0px; margin-right: 0px" title="Miscellaneous Item" src="<%=AssetsPath()%>/l-misc.gif"></p>
                                                <%end If
    'Sound Icon
    varxxTracksGroup = IsDBSomething(xx("TracksGroup"), "")
    If strShowSound = "y" And UCase(IsDBSomething(xx("MP3FileCompleted"), "")) = "Y" And InStr(1, varxxTracksGroup, "  1) ") > 0 And IsDBSomething(xx("NumberOfTracks"), 0) > 0 Then%>
                                                <br />
                                                <%Response.Write("<img alt=""Play sound""name=""T" & xx("ID") & "T01""id=""T" & xx("ID") & "T01""title=""Play sound sample""style=""margin-right:2px;cursor:pointer;vertical-align:bottom;margin-top:10px""onclick=""T('T" & xx("ID") & "T01','" & MP3Folder(xx("ID")) & "','ps6')""src=""" + AssetsPath() + "/ps6.gif""onmouseover=""fov(this,'ps6')""onmouseout=""fou(this,'ps6')"">") %>
                                                <% End If%>
                                            </td>
                                            <td width="180" height="160" align="center" valign="top">
                                                <%If ScanPath(xx("ID"), "medium", "a") <> "" Then%>
                                                <a href="<%=SEOPageNameText(xx("ArtistTitle"), xx("Format"), xx("ID"), IsDBSomething(xx("UsedItem"), ""))%>">
                                                    <img title="<%=varImageHoverText%>" src="<%=ScanPath(xx("ID"), "medium", "a")%>" style="border: 1px solid #393939; cursor: pointer; max-width: 150px; max-height: 150px"></a>
                                                <%Else%>
                                                <a href="<%=SEOPageNameText(xx("ArtistTitle"), xx("Format"), xx("ID"), IsDBSomething(xx("UsedItem"), ""))%>">
                                                    <img title="<%=varImageHoverText%>" width="150" src="<%=AssetsPath()%>/out-180.jpg" style="border: 0px; cursor: pointer"></a>
                                                <%end if%>
                                            </td>
                                            <td width="10" align="left" valign="top"></td>
                                            <td width="490" align="left" valign="top">
                                                <table border="0" cellspacing="0" cellpadding="0" width="490" style="border-collapse: collapse">
                                                    <tr>
                                                        <td width="465" align="left" valign="top">
                                                            <%'Artist Title %>
                                                            <p class="list-at"><%=varAT%></p>
                                                            <%'InventoryItemDetails%>
                                                            <%If Not IsDBNull(xx("ItemFeatures1")) Then%>
                                                            <table align="center" bgcolor="ffffff" cellpadding="0" cellspacing="0" width="465" border="0">
                                                                <tr>
                                                                    <td height="5"></td>
                                                                </tr>
                                                            </table>
                                                            <table align="center" bgcolor="ffffff" cellpadding="0" cellspacing="0" width="465" border="0">
                                                                <%For intIF = 1 To 10
      If IsDBNull(xx("ItemFeatures" & intIF)) Then Exit For
      strItemFeature = xx("ItemFeatures" & intIF)
      intPipe1 = InStr(xx("ItemFeatures" & intIF), "|1|")
      intPipe2 = InStr(xx("ItemFeatures" & intIF), "|2|")
      intPipe3 = InStr(xx("ItemFeatures" & intIF), "|3|")
      intPipe4 = InStr(xx("ItemFeatures" & intIF), "|4|")
      intPipe5 = InStr(xx("ItemFeatures" & intIF), "|5|")
      If intPipe2 - intPipe1 > 3 Then
       strItemFeatureIDText = Mid(strItemFeature, intPipe1 + 3, intPipe2 - intPipe1 - 3)
      Else
       strItemFeatureIDText = ""
      End If
      If intPipe3 - intPipe2 > 3 Then
       strItemFeatureWebProductDetailsPageHyperlinkText = Mid(strItemFeature, intPipe2 + 3, intPipe3 - intPipe2 - 3)
      Else
       strItemFeatureWebProductDetailsPageHyperlinkText = ""
      End If
      If intPipe4 - intPipe3 > 3 Then
       strItemFeatureWebProductDetailsPageText = Mid(strItemFeature, intPipe3 + 3, intPipe4 - intPipe3 - 3)
      Else
       strItemFeatureWebProductDetailsPageText = ""
      End If
      If intPipe5 - intPipe4 > 3 Then
       strItemFeatureWebGalleryText = Mid(strItemFeature, intPipe4 + 3, intPipe5 - intPipe4 - 3)
      Else
       strItemFeatureWebGalleryText = ""
      End If%>
                                                                <tr>
                                                                    <td width="20" height="19" style="vertical-align: top; text-align: left">
                                                                        <img src="<%=AssetsPath()%>/wtw.gif" style="vertical-align: top" />
                                                                    </td>
                                                                    <td width="445" style="vertical-align: top; text-align: left">
                                                                        <%If strItemFeatureWebProductDetailsPageHyperlinkText <> "" Then%>
                                                                        <div class="fdt2" style="z-index: 2000" id="IF<%=xx("id")%>-<%=strItemFeatureIDText%>" onclick="hideItemFeaturesDiv('<%=xx("id")%>-<%=strItemFeatureIDText%>')">
                                                                            <p class="item-features-div-thumbnaildiv"><%=Replace(Replace(strItemFeatureWebProductDetailsPageHyperlinkText, "NEW PARAGRAPH ", "<br/><br/>"), """", "'")%></p>
                                                                        </div>
                                                                        <%End If%>
                                                                        <a class="if-l" style="vertical-align: top" href="/home.aspx?X3QT=ItemFeature&X3AID=<%=strItemFeatureIDText%>"><%=strItemFeatureWebProductDetailsPageText%></a>
                                                                        <%If strItemFeatureWebProductDetailsPageHyperlinkText <> "" Then%>
                                                                        <p class="whats-this-thumbnail" onclick="showItemFeaturesDiv('<%=xx("id")%>-<%=strItemFeatureIDText%>')">What's&nbsp;this?</p>
                                                                        <%End If%>
                                                                    </td>
                                                                </tr>
                                                                <%next%>
                                                            </table>
                                                            <%End If%>

                                                        </td>
                                                        <td width="25"></td>
                                                    </tr>
                                                </table>
                                                <table border="0" cellspacing="0" cellpadding="0" width="490" style="border-collapse: collapse">
                                                    <tr>
                                                        <td width="490" height="14"></td>
                                                    </tr>
                                                </table>
                                                <table border="0" cellspacing="0" cellpadding="0" width="490" style="border-collapse: collapse">
                                                    <tr>
                                                        <td width="60" height="19" align="left" valign="top">
                                                            <p class="list-labels">Label:</p>
                                                        </td>
                                                        <td width="210" align="left" valign="top">
                                                            <p class="list-links" title="Show all on this label" onclick="AL(<%=xx("ID")%>)"><%=Trim(xx("Label"))%></p>
                                                        </td>
                                                        <td width="20"></td>
                                                        <td width="80" align="left" valign="top">
                                                            <p class="list-labels">Weight:</p>
                                                        </td>
                                                        <td width="80" align="right" valign="top">
                                                            <p class="list-data"><%=xx("WeightInGrams")%> grams</p>
                                                        </td>
                                                        <td width="40">
                                                    </tr>
                                                    <tr>
                                                        <td width="60" height="18" align="left" valign="top">
                                                            <p class="list-labels">Item #:</p>
                                                        </td>
                                                        <td width="210" align="left" valign="top">
                                                            <p class="list-data"><%=xx("ID")%></p>
                                                        </td>
                                                        <td width="20"></td>
                                                        <td width="80" align="left" valign="top">
                                                            <%if not isdbnull(xx("YearFrom")) then%>
                                                            <p class="list-labels">Recorded:</p>
                                                            <%end if%>
                                                        </td>
                                                        <td width="80" align="right" valign="top">
                                                            <%if not isdbnull(xx("YearFrom")) then%>
                                                            <p class="list-data"><%=varListYearFrom%></p>
                                                            <%  End if%>
                                                        </td>
                                                        <td width="40"></td>
                                                    </tr>
                                                </table>
                                                <table border="0" cellspacing="0" cellpadding="0" width="490" style="border-collapse: collapse">
                                                    <tr>
                                                        <td width="60" height="18" align="left" valign="top">
                                                            <%if not isdbnull(xx("Genre1")) then%>
                                                            <p class="list-labels">Genre:</p>
                                                            <%end if%>
                                                        </td>
                                                        <td width="210" align="left" valign="top">
                                                            <%if not isdbnull(xx("Genre1")) then%>
                                                            <p class="list-data"><%=xx("Genre1")%></p>
                                                            <%end if%>
                                                        </td>
                                                        <td width="20"></td>
                                                        <td width="40" align="left" valign="top">
                                                            <%if not isdbnull(xx("UPC")) then%>
                                                            <p class="list-labels">UPC:</p>
                                                            <%end if%>
                                                        </td>
                                                        <td width="120" align="right" valign="top">
                                                            <%if not isdbnull(xx("UPC")) then%>
                                                            <p class="list-data"><%=xx("UPC")%></p>
                                                            <%end if%>
                                                        </td>
                                                        <td width="40"></td>
                                                    </tr>
                                                </table>
                                                <%  If Not IsDBNull(xx("RhythmName")) Then%>
                                                <table border="0" cellspacing="0" cellpadding="0" width="490" style="border-collapse: collapse">
                                                    <tr>
                                                        <td width="60" height="20" align="left" valign="top">
                                                            <p class="list-labels">Rhythm:</p>
                                                        </td>
                                                        <td width="430" align="left" valign="top">
                                                            <p class="list-links" title="Show all on this rhythm" onclick="AR(<%=xx("ID")%>)"><%=xx("RhythmName")%></p>
                                                        </td>
                                                    </tr>
                                                </table>
                                                <%  End if%>
                                                <table border="0" cellspacing="0" cellpadding="0" width="490" style="border-collapse: collapse">
                                                    <tr>
                                                        <td width="60" height="30" align="left" valign="bottom"></td>
                                                        <td width="390" align="right" valign="bottom">
                                                            <%  If varSimilarItemsAvailable = 1 Then%>
                                                            <p class="list-similar" title="Show similar items." onclick="SI('<%=xx("ID")%>')">Show Similar Items</p>
                                                            <%end if%>
                                                        </td>
                                                        <td width="40"></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="180" align="center" valign="top" style="background-image: url('<%=AssetsPath()%>/list-add-bg.gif'); background-repeat: no-repeat">
                                                <table border="0" cellspacing="0" cellpadding="0" width="180" style="border-collapse: collapse">
                                                    <tr>
                                                        <td width="33" height="30"></td>
                                                        <td width="147" align="left" valign="bottom">
                                                            <%if varSaleItem=1 then
    if session("PriceGroup")="StorePrice" or session("PriceGroup")="ExportPrice" then%>
                                                            <p class="l-price-x"><%=formatcurrency(varPriceGroupPrice,2)%></p>
                                                            &nbsp;<p class="l-price"><%=formatcurrency(xx("Sale_WholesalePrice"),2)%></p>
                                                            <%else%>
                                                            <p class="l-price-x"><%=formatcurrency(varPriceGroupPrice,2)%></p>
                                                            &nbsp;<p class="l-price"><%=formatcurrency(xx("Sale_RetailPrice"),2)%></p>
                                                            <%end if%>
                                                            <%else%>
                                                            <p class="l-price"><%=formatcurrency(varPriceUsing,2)%></p>
                                                            <%end if%>
                                                        </td>
                                                    </tr>
                                                </table>
                                                <table border="0" cellspacing="0" cellpadding="0" width="180" style="border-collapse: collapse">
                                                    <tr>
                                                        <td width="31" height="100" valign="top" align="left">
                                                            <div class="yc2" style="z-index: 1000" name="YC<%=xx("ID")%>" id="YC<%=xx("ID")%>">
                                                                <img style="cursor: pointer" src="<%=AssetsPath()%>/l-ych.gif" onclick="gtcart()">
                                                            </div>
                                                        </td>
                                                        <td width="31" align="center" valign="bottom">
                                                            <%  If intQuantityInCart > 0 Then%>
                                                            <input type="text" id="OA<%=xx("id")%>" name="OA<%=xx("id")%>" class="list-qty-x" onkeydown="Sc();VS=0" tabindex="<%=z%>" onkeyup="CQ(<%=xx("ID")%>,<%=varPriceForCartAddText%>,0,'OA',1)" value="<%=intQuantityInCart%>" maxlength="3">
                                                            <%  Else%>
                                                            <input type="text" id="OA<%=xx("id")%>" name="OA<%=xx("id")%>" class="list-qty" onkeydown="Sc();VS=0" tabindex="<%=z%>" onkeyup="CQ(<%=xx("ID")%>,<%=varPriceForCartAddText%>,0,'OA',1)" maxlength="3">
                                                            <%end if%>
                                                        </td>
                                                        <td width="22" align="right" valign="bottom">
                                                            <%  If varQueryType = "Backorders" Then
     Response.Write("<input alt border=""0"" align=""top"" type=""image"" title=""Delete this backorder"" style=""margin-right:2px""ONCLICK=""CQ(" & xx("ID") & "," & varPriceForCartAddText & ",-2,'-',0)"" src=""" + AssetsPath() + "/xb2.gif"">")
    Else%>
                                                            <img style="border-width: 0px; cursor: pointer" title="Remove item from cart." onclick="CQ(<%=xx("ID")%>,<%=varPriceForCartAddText%>,-1,'OA',0)" onmouseover="fov(this,'l-x')" onmouseout="fou(this,'l-x')" src="<%=AssetsPath()%>/l-x.gif">
                                                            <%end if%>
                                                        </td>
                                                        <td width="65" align="left" valign="bottom">
                                                            <img style="border-width: 0px; cursor: pointer" title="Add 1 to quantity in cart." onclick="CQ(<%=xx("ID")%>,<%=varPriceForCartAddText%>,1,'OA',0)" onmouseover="fov(this,'l-add')" onmouseout="fou(this,'l-add')" src="<%=AssetsPath()%>/l-add.gif">
                                                        </td>
                                                        <td width="31" align="left" valign="bottom"></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="50" align="center" valign="top"></td>
                                            <td width="15" align="right" valign="top" style="background-image: url('<%=AssetsPath()%>/list-bg-right.gif'); background-repeat: repeat-y"></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                        <table border="0" cellspacing="0" cellpadding="0" width="1000" style="border-collapse: collapse">
                            <tr>
                                <td width="15" align="left" valign="top" style="background-image: url('<%=AssetsPath()%>/list-bg-left.gif'); background-repeat: repeat-y"></td>
                                <td width="60"></td>
                                <td width="180"></td>
                                <td width="10"></td>
                                <td width="490" valign="top" height="10" style="background-image: url('<%=AssetsPath()%>/l-divider.gif'); background-repeat: no-repeat"></td>
                                <td width="180"></td>
                                <td width="50" align="center" valign="top"></td>
                                <td width="15" align="right" valign="top" style="background-image: url('<%=AssetsPath()%>/list-bg-right.gif'); background-repeat: repeat-y"></td>
                            </tr>
                        </table>
                        <%end if
   if recordnumber=varXXrecordcount Or z>=NumberOfRecordsLimit then
    if varDisplayType="Grid" Then
     If z < 5 Then
      varRightWidth = ((4 - ((z) Mod 4)) * 308) + 9
     Else
      If z >= NumberOfRecordsLimit Or z / 4 = Int(z / 4) Then
       varRightWidth = 9
      Else
       varRightWidth = ((4 - ((z) Mod 4)) * 308) + 9
      End If
     End If
                        %>
                    </td>
                    <td width="<%=varRightWidth%>" style="vertical-align: top; text-align: left"></td>
                </tr>
            </table>
            <table cellpadding="0" bgcolor="ffffff" cellspacing="0" width="1250" align="center" border="0">
                <tr>
                    <td height="23" align="left" valign="middle" width="1250"></td>
                </tr>
            </table>
            <%elseif varDisplayType="List" then%>
            <table cellpadding="0" bgcolor="EBEBEB" cellspacing="0" width="1000" align="center" valign="top" border="0" style="background-color: #ffffff; text-align: left; vertical-align: top">
                <tr>
                    <td width="1000" height="75" align="left" valign="top" style="background-color: #ffffff; text-align: left; vertical-align: top; background-image: url('<%=AssetsPath()%>/list-bg-bottom.gif')"></td>
                </tr>
            </table>
            </td><td bgcolor="DEDEDE" width="10"></td>
        </tr>
    </table>
    <%end if
   exit do
  end if
 loop
 End using
end if%>
    <%'Next Button%>
    <%if varCartPage=1 then
 if varXXRecordCount>0 then
  varBGForHere="ffffff"
 else
  varBGForHere="D4DBD4"
 end if
else
 varBGForHere="ffffff"
end if%>
    <table bgcolor="<%=varBGForHere%>" align="center" frame="none" cellpadding="0" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td width="60" height="30"></td>
            <td width="350" style="vertical-align: middle; text-align: center">
                <%if varXXrecordcount>recordnumber then
  pagenumbernext=varPageOn+1
  if len(varPageOn)=0 or varPageOn=0 then pagenumbernext=2
  varURLString = ""
  if IsDBSomething(varLabelExact,"")<>"" then varURLString = varURLString & "&X3LEL3=" & server.URLEncode(varLabelExact)
  if IsDBSomething(varGenreExact,"")<>"" then varURLString = varURLString & "&X3GEL3=" & server.URLEncode(varGenreExact)
  If IsDBSomething(varArtistExact, "") <> "" Then varURLString = varURLString & "&X3AEL3=" & Server.UrlEncode(varArtistExact)
  If IsDBSomething(varArtistSearchType, "") <> "" Then varURLString = varURLString & "&X3ASTL3=" & Server.UrlEncode(varArtistSearchType)
  If IsDBSomething(varArtistSearchTypeCounter, "") <> "" Then varURLString = varURLString & "&X3ASTCL3=" & Server.UrlEncode(varArtistSearchTypeCounter)
  If IsDBSomething(varRhythmExact, "") <> "" Then varURLString = varURLString & "&X3REL3=" & Server.UrlEncode(varRhythmExact)
  If IsDBSomething(varArtistSelected,"")<>"" then varURLString = varURLString & "&X3ASEL3=" & server.URLEncode(varArtistSelected)
  if IsDBSomething(varLabelSelected,"")<>"" then varURLString = varURLString & "&X3LSEL3=" & server.URLEncode(varLabelSelected)
  if IsDBSomething(varGenreSelected,"")<>"" then varURLString = varURLString & "&X3GSEL3=" & server.URLEncode(varGenreSelected)
  If IsDBSomething(varAllID, "") <> "" Then varURLString = varURLString & "&X3AIDL3=" & Server.UrlEncode(varAllID)
  If IsDBSomething(Request.QueryString("genre"),"")<>"" then varURLString = varURLString & "&genre=" & server.URLEncode(Request.QueryString("genre"))
  if IsDBSomething(varAllArtistName,"")<>"" then varURLString = varURLString & "&X3AANL3=" & server.URLEncode(varAllArtistName)
  if IsDBSomething(varQueryType,"")<>"" then varURLString = varURLString & "&X3QTL3=" & server.URLEncode(varQueryType)
  if IsDBSomething(varArtistCriteria,"")<>"" then varURLString = varURLString & "&X3AL3=" & server.URLEncode(varArtistCriteria)
  if IsDBSomething(varFormatCriteria,"")<>"" then varURLString = varURLString & "&X3FL3=" & server.URLEncode(varFormatCriteria)
  if IsDBSomething(varRecentCriteria,"")<>"" then varURLString = varURLString & "&X3RL3=" & server.URLEncode(varRecentCriteria)
  if IsDBSomething(varRhythmCriteria,"")<>"" then varURLString = varURLString & "&X3RYL3=" & server.URLEncode(varRhythmCriteria)
  if IsDBSomething(varlabelCriteria,"")<>"" then varURLString = varURLString & "&X3LL3=" & server.URLEncode(varlabelCriteria)
  if IsDBSomething(varIncludeUsedCriteria,"")<>"" then varURLString = varURLString & "&X3IUL3=" & server.URLEncode(varIncludeUsedCriteria)
  if IsDBSomething(varGenreCriteria,"")<>"" then varURLString = varURLString & "&X3GL3=" & server.URLEncode(varGenreCriteria)
  if IsDBSomething(varYearCriteria,"")<>"" then varURLString = varURLString & "&X3YL3=" & server.URLEncode(varYearCriteria)
  if IsDBSomething(varPriceCriteria,"")<>"" then varURLString = varURLString & "&X3PRL3=" & server.URLEncode(varPriceCriteria)
  if IsDBSomething(varReggaeOrNonReggae,"")<>"" then varURLString = varURLString & "&X3RONL3=" & server.URLEncode(varReggaeOrNonReggae)
  If IsDBSomething(varBSLTxt, "") <> "" Then varURLString = varURLString & "&BSLTxt=" & Server.UrlEncode(varBSLTxt)
  If IsDBSomething(varSongSearchSong,"")<>"" then varURLString = varURLString & "&SSSTxt=" & server.URLEncode(varSongSearchSong)
  if IsDBSomething(varSongSearchFormat,"")<>"" then varURLString = varURLString & "&SSFTxt=" & server.URLEncode(varSongSearchFormat)
  if IsDBSomething(varCustBoughtFormat,"")<>"" then varURLString = varURLString & "&X3CBFL3=" & server.URLEncode(varCustBoughtFormat)
  if IsDBSomething(varCustBoughtDays,"")<>"" then varURLString = varURLString & "&X3CBDL3=" & server.URLEncode(varCustBoughtDays)
  if IsDBSomething(varErnieMessageID,"")<>"" then varURLString = varURLString & "&X3EMIDL3=" & server.URLEncode(varErnieMessageID)
  if varURLString = "" then varURLString="&" & varURLString
  if varCartPage=1 then%>
                <a href="/home.aspx?X3QT=PageSearchForCart&TabH=Cart&X3SO=<%=varSortOrder%>&X3SR=<%=recordnumber+1%>&X3P=<%=pagenumbernext%><%=varURLString%>" title="Go to next page">
                    <img class="a" src="<%=AssetsPath()%>/nextpage2.gif"></a>
                <%else%>
                <a href="/home.aspx?X3QT=PageSearch&X3SO=<%=varSortOrder%>&X3SR=<%=recordnumber+1%>&X3P=<%=pagenumbernext%><%=varURLString%>" title="Go to next page">
                    <img class="a" src="<%=AssetsPath()%>/g-next-page3.gif" onmouseover="fov(this,'g-next-page3')" onmouseout="fou(this,'g-next-page3')"></a>
                <%end if
end if%>
            </td>
            <td width="900" style="vertical-align: middle; text-align: left">
                <%if varXXRecordCount>6 or varDefaultHomePage=1 then%>
                <a href="#top" class="top-link" style="margin-left: 162px; font-size: 15px; vertical-align: middle">GO TO TOP OF PAGE</a>
                <%end if%>
            </td>
        </tr>
    </table>

    <%'Table Bottom
if varCartPage=1 then
 if varXXRecordCount>0 then
  session("WebOrderNumberJustPurchased")="" %>
    <table class="z" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td align="center" height="50" valign="middle">
                <img alt title="We accept all these payment methods (including Debit Cards)." src="<%=AssetsPath()%>/accept42.gif">
            </td>
        </tr>
    </table>
    <%else%>
    <%end if%>
    <%else%>
    <table bgcolor="ffffff" cellpadding="0" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td align="center" height="8" valign="bottom"></td>
        </tr>
    </table>
    <%end if%>

    <%'Customers Also Viewed Array----------------------------------------------------------------------------------------------------------
  Dim intImportantCartItemExists As Integer = 0
  Dim strSimilarImportantRhythm As String = ""
  Dim ns2 As Integer = 0
  Dim x12 As Integer = 0
  Dim strCustomersAlsoViewedSQL As String = ""
  Dim strFormatSQL As String = ""
  Dim strFormat As String = ""
  Dim CVid(100)
  Dim CVimg(100)
  Dim CVat(100)
  Dim strCVArrayString As String = ""
  Dim CVImageHeight As String = ""
  Dim varCVFormatText As String = ""
  Dim CVPrice As String = ""
  If varKnownSearchEngineUserAgent = 0 And (varCartPage = 1 Or (RecordNumber < 21 And varCVItemID <> 0)) Then
   If varCartPage = 1 Then
    Using connA As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
     SqlConnection.ClearPool(connA)
     connA.Open()
     Dim CMD_A As New SqlCommand("spGetImportantCartItem", connA)
     CMD_A.CommandType = Data.CommandType.StoredProcedure
     CMD_A.Parameters.AddWithValue("@Cartname", NameOfCart)
     Dim readerA As SqlDataReader
     readerA = CMD_A.ExecuteReader
     If readerA.HasRows Then
      readerA.Read()
      intImportantCartItemExists = 1
      strFormat = IsDBSomething(readerA("Format"), "")
      intInventoryID = readerA("ID")
      varSimilarGenre = IsDBSomething(readerA("Genre1"), "")
      varSimilarGenre = Replace(varSimilarGenre, "'", "''")
      varSimilarYearFrom = IsDBSomething(readerA("YearFrom"), "")
      varSimilarYearTo = IsDBSomething(readerA("YearTo"), "")
      strSimilarImportantRhythm = IsDBSomething(readerA("RhythmName"), "")
      strSimilarImportantRhythm = Replace(strSimilarImportantRhythm, "'", "''")
     End If
    End Using
   ElseIf varCVItemID <> 0 Then
    Using connA As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
     SqlConnection.ClearPool(connA)
     connA.Open()
     Dim CMD_A As New SqlCommand("spGetInventoryItem", connA)
     CMD_A.CommandType = Data.CommandType.StoredProcedure
     CMD_A.Parameters.AddWithValue("@ID", varCVItemID)
     Dim readerA As SqlDataReader
     readerA = CMD_A.ExecuteReader
     If readerA.HasRows Then
      readerA.Read()
      intImportantCartItemExists = 1
      strFormat = IsDBSomething(readerA("Format"), "")
      intInventoryID = readerA("ID")
      varSimilarGenre = IsDBSomething(readerA("Genre1"), "")
      varSimilarGenre = Replace(varSimilarGenre, "'", "''")
      varSimilarYearFrom = IsDBSomething(readerA("YearFrom"), "")
      varSimilarYearTo = IsDBSomething(readerA("YearTo"), "")
      strSimilarImportantRhythm = IsDBSomething(readerA("RhythmName"), "")
      strSimilarImportantRhythm = Replace(strSimilarImportantRhythm, "'", "''")
     End If
    End Using
   End If
   If intImportantCartItemExists = 1 Then
    intImportantCartItemExists = 0
    CVImageHeight = 201
    If strFormat = "7""" Then
     strFormatSQL = " and Inventory.Format like '7%'"
    ElseIf strFormat = "12""" Then
     strFormatSQL = " and (Inventory.Format like '12%' or Inventory.Format like '10%')"
    ElseIf strFormat = "10""" Then
     strFormatSQL = " and (Inventory.Format like '12%' or Inventory.Format like '10%')"
    Else
     strFormatSQL = " and Inventory.Format ='" & strFormat & "'"
     If strFormat = "CD" Then
      CVImageHeight = 175
     End If
    End If
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
    If varSimilarGenre = "" Then
     varSimilarGenre = "asdfafsdaf"
    End If
    ns2 = 0
    If varSimilarYearFrom <> "" Then
     If varSimilarYearTo <> "" Then
      If varSimilarGenre <> "" And IsNumeric(varSimilarYearFrom) And IsNumeric(varSimilarYearTo) Then
       If CInt(varSimilarYearFrom) - CInt(varSimilarYearTo) < 6 Then
        intImportantCartItemExists = 1
       End If
      End If
     Else
      If varSimilarGenre <> "" And IsNumeric(varSimilarYearFrom) Then
       intImportantCartItemExists = 1
      End If
     End If
    End If
   End If
   If intImportantCartItemExists = 1 Then
    strCustomersAlsoViewedSQL = "select ID,ArtistTitle,SalesLast30Days,Format,RetailPrice,ExportPrice from inventory where ID in (select ID from inventory" _
   & " where (((Genre1='" & varSimilarGenre & "' or Genre2='" & varSimilarGenre & "' or Genre3='" & varSimilarGenre & "' or Genre4='" & varSimilarGenre & "' or Genre5='" & varSimilarGenre & "' or Genre6='" & varSimilarGenre & "' or Genre7='" & varSimilarGenre & "' or Genre8='" & varSimilarGenre & "' or Genre9='" & varSimilarGenre & "')" _
   & " and ((YearFrom >= " & varSimilarYearFrom & " and YearFrom <= " & varSimilarYearTo & ") or (YearTo >= " & varSimilarYearFrom & " and YearTo <= " & varSimilarYearTo & ")))" _
   & " or RhythmName='" & strSimilarImportantRhythm & "')" _
   & " and inventory >0 and ShowOnWebsite='y' and useditem='n'" _
   & strFormatSQL _
   & " and Inventory.ID<>" & intInventoryID _
   & " Order by SalesLast30Days desc, Inventory.ID desc offset 0 rows fetch next 15 rows only) Order by NEWID()"
    Using connA As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
     SqlConnection.ClearPool(connA)
     connA.Open()
     Dim CMD_A As New SqlCommand(strCustomersAlsoViewedSQL, connA)
     CMD_A.CommandType = Data.CommandType.Text
     Dim readerA As SqlDataReader
     readerA = CMD_A.ExecuteReader
     If readerA.HasRows Then
      ns2 = 0
      x12 = 0
      Do While readerA.Read
       If ScanPath(readerA("ID"), "320", "A") <> "" Then
        If Session("PriceGroup") = "StorePrice" Or Session("PriceGroup") = "ExportPrice" Then
         CVPrice = FormatNumber(readerA("ExportPrice"), 2)
        Else
         CVPrice = FormatNumber(readerA("RetailPrice"), 2)
        End If
        CVid(ns2) = readerA("ID")
        CVimg(ns2) = ScanPath(readerA("ID"), "320", "A")
        CVat(ns2) = "<b>" & Replace(readerA("Format"), Chr(34), " Inch") & " $" & CVPrice & " </b>" & FigureLength(Replace(readerA("ArtistTitle"), Chr(34), " Inch"))
        ns2 = ns2 + 1
       End If
       If ns2 = 50 Then Exit Do
       x12 = x12 + 1
      Loop
     End If
    End Using

    strCustomersAlsoViewedSQL = "select ID,ArtistTitle,SalesLast30Days,Format,RetailPrice,ExportPrice from inventory where ID in (select ID from inventory" _
     & " where (((Genre1='" & varSimilarGenre & "' or Genre2='" & varSimilarGenre & "' or Genre3='" & varSimilarGenre & "' or Genre4='" & varSimilarGenre & "' or Genre5='" & varSimilarGenre & "' or Genre6='" & varSimilarGenre & "' or Genre7='" & varSimilarGenre & "' or Genre8='" & varSimilarGenre & "' or Genre9='" & varSimilarGenre & "')" _
     & " and ((YearFrom >= " & varSimilarYearFrom & " and YearFrom <= " & varSimilarYearTo & ") or (YearTo >= " & varSimilarYearFrom & " and YearTo <= " & varSimilarYearTo & ")))" _
     & " or RhythmName='" & strSimilarImportantRhythm & "')" _
     & " and inventory >0 and ShowOnWebsite='y' and useditem='n'" _
     & strFormatSQL _
     & " and Inventory.ID<>" & intInventoryID _
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
        CVid(ns2) = readerA("ID")
        CVimg(ns2) = ScanPath(readerA("ID"), "320", "A")
        CVat(ns2) = "<b>" & Replace(readerA("Format"), Chr(34), " Inch") & " $" & CVPrice & " </b>" & FigureLength(Replace(readerA("ArtistTitle"), Chr(34), " Inch"))
        ns2 = ns2 + 1
       End If
       If ns2 = 50 Then Exit Do
       x12 = x12 + 1
      Loop
     End If
    End Using
    Response.Write("<script language=""javascript"">")
    If ns2 < 4 Then
     Response.Write(vbCrLf & "CVnumberon=" & ns2)
    Else
     Response.Write(vbCrLf & "CVnumberon=4")
    End If
    strCVArrayString = vbCrLf & "let CVid = ["
    For x1 = 0 To ns2 - 1
     If x1 <> 0 Then strCVArrayString = strCVArrayString & ","
     strCVArrayString = strCVArrayString & """" & CVid(x1) & """"
    Next
    strCVArrayString = strCVArrayString & "]"
    Response.Write(strCVArrayString)
    strCVArrayString = vbCrLf & "let CVimg = ["
    For x1 = 0 To ns2 - 1
     If x1 <> 0 Then strCVArrayString = strCVArrayString & ","
     strCVArrayString = strCVArrayString & """" & CVimg(x1) & """"
    Next
    strCVArrayString = strCVArrayString & "]"
    Response.Write(strCVArrayString)
    strCVArrayString = vbCrLf & "CVat=[];"
    For x1 = 0 To ns2 - 1
     strCVArrayString = strCVArrayString & vbCrLf & "CVat[" & x1 & "]=""" & CVat(x1) & """;"
    Next
    Response.Write(strCVArrayString)
    Response.Write(vbCrLf & "</script>")
   End If
  End If
  If ns2 > 1 And varKnownSearchEngineUserAgent = 0 Then%>
    <table align="center" bgcolor="ffffff" cellpadding="0" cellspacing="0" width="1250" border="0">
        <tr>
            <td height="60" style="vertical-align: bottom">
                <p style="font-size: 22px; font-weight: 600; color: #c74100; margin-left: 75px">
                    You may also be interested in...
                </p>
            </td>
        </tr>
    </table>
    <table align="center" bgcolor="ffffff" cellpadding="0" cellspacing="0" width="1250" border="0" style="border-collapse: collapse">
        <tr>
            <td height="218" width="62" style="vertical-align: middle; text-align: right">
                <%If CVid(5) > 0 Then%>
                <img alt="" id="imgCVPrevious" onclick="CVnextbatch('-')" onmouseover="fov(this,'arrow-previous')" onmouseout="fou(this,'arrow-previous')" style="visibility: hidden; cursor: pointer; margin-top: 0px; margin-right: 0px" src="<%=AssetsPath()%>/arrow-previous.gif" />
                <%End If%>
            </td>
            <td width="225" style="vertical-align: bottom; text-align: center">
                <%If CVid(0) > 0 Then%>
                <a id="CVhref1" href="/itemdetails.aspx?ID=<%=CVid(0)%>">
                    <img alt="" title="" id="CVimg1" class="CVimg" width="" height="<%=CVImageHeight%>" src="<%=ScanPath(CInt(CVid(0)), "320", "A")%>" onerror="this.onerror=null;this.src='<%=var_err_img%>'" /></a>
                <%  End If%>
            </td>
            <td width="225" style="vertical-align: bottom; text-align: center">
                <%If CVid(1) > 0 Then%>
                <a id="CVhref2" href="/itemdetails.aspx?ID=<%=CVid(1)%>">
                    <img alt="" title="" id="CVimg2" class="CVimg" width="" height="<%=CVImageHeight%>" src="<%=ScanPath(CInt(CVid(1)), "320", "A")%>" onerror="this.onerror=null;this.src='<%=var_err_img%>'" /></a>
                <%  End If%>
            </td>
            <td width="225" style="vertical-align: bottom; text-align: center">
                <%If CVid(2) > 0 Then%>
                <a id="CVhref3" href="/itemdetails.aspx?ID=<%=CVid(2)%>">
                    <img alt="" title="" id="CVimg3" class="CVimg" width="" height="<%=CVImageHeight%>" src="<%=ScanPath(CInt(CVid(2)), "320", "A")%>" onerror="this.onerror=null;this.src='<%=var_err_img%>'" /></a>
                <%  End If%>
            </td>
            <td width="225" style="vertical-align: bottom; text-align: center">
                <%If CVid(3) > 0 Then%>
                <a id="CVhref4" href="/itemdetails.aspx?ID=<%=CVid(3)%>">
                    <img alt="" title="" id="CVimg4" class="CVimg" width="" height="<%=CVImageHeight%>" src="<%=ScanPath(CInt(CVid(3)), "320", "A")%>" onerror="this.onerror=null;this.src='<%=var_err_img%>'" /></a>
                <%  End If%>
            </td>
            <td width="225" style="vertical-align: bottom; text-align: center">
                <%If CVid(4) > 0 Then%>
                <a id="CVhref5" href="/itemdetails.aspx?ID=<%=CVid(4)%>">
                    <img alt="" title="" id="CVimg5" class="CVimg" width="" height="<%=CVImageHeight%>" src="<%=ScanPath(CInt(CVid(4)), "320", "A")%>" onerror="this.onerror=null;this.src='<%=var_err_img%>'" /></a>
                <%  End If%>
            </td>
            <td width="63" style="vertical-align: middle; text-align: left">
                <%If CVid(5) > 0 Then%>
                <img alt="" id="imgCVNext" onclick="CVnextbatch('+')" onmouseover="fov(this,'arrow-next')" onmouseout="fou(this,'arrow-next')" style="cursor: pointer; margin-top: 0px; margin-left: 0px" src="<%=AssetsPath()%>/arrow-next.gif" />
                <%End If%>
            </td>
        </tr>
    </table>
    <table align="center" bgcolor="ffffff" cellpadding="0" cellspacing="0" width="1250" border="0" style="border-collapse: collapse; vertical-align: top">
        <tr>
            <td width="74"></td>
            <td width="201" height="70" style="vertical-align: top; text-align: center">
                <div class="CV" id="CVdiv1">
                    <p id="CVp1" class="CV"><%=CVat(0)%></p>
                </div>
            </td>
            <td width="24"></td>
            <td width="201" style="vertical-align: top; text-align: center">
                <div class="CV" id="CVdiv2">
                    <p id="CVp2" class="CV"><%=CVat(1)%></p>
                </div>
            </td>
            <td width="24"></td>
            <td width="201" style="vertical-align: top; text-align: center">
                <div class="CV" id="CVdiv3">
                    <p id="CVp3" class="CV"><%=CVat(2)%></p>
                </div>
            </td>
            <td width="24"></td>
            <td width="201" style="vertical-align: top; text-align: center">
                <div class="CV" id="CVdiv4">
                    <p id="CVp4" class="CV"><%=CVat(3)%></p>
                </div>
            </td>
            <td width="24"></td>
            <td width="201" style="vertical-align: top; text-align: center">
                <div class="CV" id="CVdiv5">
                    <p id="CVp5" class="CV"><%=CVat(4)%></p>
                </div>
            </td>
            <td width="75"></td>
        </tr>
    </table>
    <%End If


 '-----------------------------------------------------------------------------------------------------------------------------------

 'Table Bottom
 If varCartPage = 1 Then%>
    <table bgcolor="ffffff" cellpadding="0" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td height="24"></td>
        </tr>
    </table>
    <table bgcolor="000000" cellpadding="0" cellspacing="0" width="1250" align="center" border="0">
        <td width="3">
            <img alt src="<%=AssetsPath()%>/tblwhite.gif" width="8" height="7"></td>
        <td bgcolor="ffffff" width="99%"></td>
        <td width="3">
            <img alt src="<%=AssetsPath()%>/tbrwhite.gif" width="8" height="7"></td>
    </table>
    <%else%>
    <table bgcolor="ffffff" cellpadding="0" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td height="14"></td>
        </tr>
    </table>
    <table bgcolor="000000" cellpadding="0" cellspacing="0" width="1250" align="center" border="0">
        <td width="3">
            <img alt src="<%=AssetsPath()%>/tblwhite.gif" width="8" height="7"></td>
        <td bgcolor="ffffff" width="99%"></td>
        <td width="3">
            <img alt src="<%=AssetsPath()%>/tbrwhite.gif" width="8" height="7"></td>
    </table>
    <%end if%>
    <table bgcolor="000000" cellpadding="0" cellspacing="0" width="1250" align="center" border="0">
        <tr>
            <td align="center"><font face="arial" style="font-size: 13px" color="ffffff"><%=CopyrightFooter()%></font>
            </td>
        </tr>
        <table>
</body>
</html>

<script runat="server" language="vb">
  'Grid Item Rendering----------------------------------------------------------------------
  Public Sub RenderGridItem(varGridSearchID, varGridRhythmName, varGridGenre1, varGridYearFrom, varGridYearTo, varGridLabel, varItemFeatures1, varItemFeatures2, varItemFeatures3, varItemFeatures4, varItemFeatures5, varItemFeatures6, varItemFeatures7, varItemFeatures8, varItemFeatures9, varItemFeatures10, varTracksGroup, varQueryType, varIsHomePage, varGridID, varGridArtistTitle, varGridFormat, varGridStorePrice, varGridRetailPrice, varGridSale_WholesalePrice, varGridSale_WholesaleEndDate, varGridSale_RetailPrice, varGridSale_RetailEndDate, varGridUsedItem, varGridMP3FileCompleted, varGridItemDetailsWebNameOfCart, strConnectionStringName)
   varTracksGroup = IsDBSomething(varTracksGroup, "")
   Dim varGridSimilarItemsAvailable As Integer = 0
   Dim varGridImageTDHeight As Integer = 0
   Dim varGridImageHeight As Integer = 0
   Dim varGridImageWidth As String = ""
   Dim varGridTableHeight As Integer = 0
   Dim varAT As String = ""
   Dim varGridTitle As String = ""
   Dim varGridArtistHoverText As String = ""
   Dim varGridTitleHoverText As String = ""
   Dim varImageHoverText As String = ""
   Dim varSaleItem As Integer = 0
   Dim varPriceGroupPrice As Decimal = 0
   Dim varPriceUsing As Decimal = 0
   Dim varPriceForCartAddText As String = ""
   Dim varGridItemIsInCart As Integer = 0
   Dim varQuantityInCart As Integer = 0
   Dim varRhythmnNameToShow As String = 0
   Dim strShowSoundGrid As String="n"
   If varGridFormat = "CD" Then
    If varIsHomePage = 1 Then
     varGridImageTDHeight = 253
    Else
     varGridImageTDHeight = 290
    End If
    varGridImageHeight = 251
    varGridImageWidth = ""
    varGridTableHeight = 277
   ElseIf varGridFormat = "DVD" Or varGridFormat = "CS" Or varGridFormat = "V" Then
    varGridImageTDHeight = 290
    varGridImageHeight = 288
    varGridImageWidth = ""
    varGridTableHeight = 396
   Else
    varGridImageTDHeight = 290
    varGridImageHeight = 288
    varGridImageWidth = ""
    varGridTableHeight = 396
   End If
   varAT = FigureArtistTitleWebHTMLForGridView(varGridUsedItem, varGridFormat, varGridArtistTitle)
   varGridTitle = FigureGridTitle(varGridArtistTitle)
   varGridArtistHoverText = FigureGridArtistHoverText(varGridArtistTitle)
   varGridTitleHoverText = FigureGridTitleHoverText(IsDBSomething(varGridArtistTitle, ""))
   varImageHoverText = varGridArtistTitle
   'Similar Items
   varGridSimilarItemsAvailable = 0
   If IsDBSomething(varGridYearFrom, "") <> "" Then
    If IsDBSomething(varGridYearTo, "") <> "" Then
     If Not IsDBNull(varGridGenre1) And IsNumeric(IsDBSomething(varGridYearFrom, "")) And IsNumeric(IsDBSomething(varGridYearTo, "")) Then
      If CInt(IsDBSomething(varGridYearFrom, "")) - CInt(IsDBSomething(varGridYearTo, "")) < 6 Then
       varGridSimilarItemsAvailable = 1
      End If
     End If
    Else
     If Not IsDBNull(varGridGenre1) And IsNumeric(IsDBSomething(varGridYearFrom, "")) Then
      varGridSimilarItemsAvailable = 1
     End If
    End If
   End If
   'Price
   varSaleItem = 0
   If Session("PriceGroup") = "StorePrice" Or Session("PriceGroup") = "ExportPrice" Then
    If Not IsDBNull(varGridSale_WholesalePrice) And Not IsDBNull(varGridSale_WholesaleEndDate) Then
     If DateDiff("d", Date.Now, varGridSale_WholesaleEndDate) >= 0 Then
      varSaleItem = 1
     End If
    End If
   Else
    If Not IsDBNull(varGridSale_RetailPrice) And Not IsDBNull(varGridSale_RetailEndDate) Then
     If DateDiff("d", Date.Now, varGridSale_RetailEndDate) >= 0 Then
      varSaleItem = 1
     End If
    End If
   End If
   If Session("PriceGroup") = "StorePrice" Or Session("PriceGroup") = "ExportPrice" Then
    varPriceGroupPrice = varGridStorePrice
    If varSaleItem = 1 Then
     varPriceUsing = varGridSale_WholesalePrice
    Else
     varPriceUsing = varGridStorePrice
    End If
   Else
    varPriceGroupPrice = varGridRetailPrice
    If varSaleItem = 1 Then
     varPriceUsing = varGridSale_RetailPrice
    Else
     varPriceUsing = varGridRetailPrice
    End If
   End If
   varPriceForCartAddText = varPriceUsing.ToString
   varGridItemIsInCart = 0
   Using conn2 As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
    SqlConnection.ClearPool(conn2)
    conn2.Open()
    Dim CMD_X2 As New SqlCommand("spIsItemInCart", conn2)
    CMD_X2.CommandType = Data.CommandType.StoredProcedure
    CMD_X2.Parameters.AddWithValue("@NameOfCart", varGridItemDetailsWebNameOfCart)
    CMD_X2.Parameters.AddWithValue("@ItemID", CLng(varGridID))
    Dim readerX2 As SqlDataReader
    readerX2 = CMD_X2.ExecuteReader
    If readerX2.HasRows Then
     readerX2.Read()
     varGridItemIsInCart = 1
     varQuantityInCart = readerX2("Quantity")
     If CDbl(varPriceUsing) > CDbl(readerX2("Price")) And DateDiff("d", readerX2("DateTime"), Date.Now) <= 30 Then
      varPriceUsing = readerX2("Price")
     End If
    End If
   End Using

   Response.Write("<td width=""308""height=""" & varGridTableHeight & """align=""center""valign=""top""style=""background-color:  # ffffff;text-align:center;vertical-align:top"">")
   Response.Write("<table border=""0""cellspacing=""0"" cellpadding=""0"" width=""308""style=""border-collapse:collapse"">")
   Response.Write("<tr><td width=""308""height=""" & varGridImageTDHeight & """align=""center""valign=""bottom""style=""text-align:center;vertical-align:bottom"">")


   'If ScanPath(varGridID, "320", "A") <> "" Then
   ' Response.Write("<a href=""" & SEOPageNameText(varGridArtistTitle, varGridFormat, varGridID, IsDBSomething(varGridUsedItem, "")) & "?searchid=" & varGridSearchID & """><img title=""" & varImageHoverText & """height=""" & varGridImageHeight & """width=""" & varGridImageWidth & """src=""" & ScanPath(varGridID, "320", "A") & """ class=""g-img""></a>")
   'Else
   ' If varGridFormat = "CD" Then
   '  Response.Write("<a href=""" & SEOPageNameText(varGridArtistTitle, varGridFormat, varGridID, IsDBSomething(varGridUsedItem, "")) & "?searchid=" & varGridSearchID & """><img title=""" & varImageHoverText & """height=""" & varGridImageHeight & """width=""" & varGridImageWidth & """src=""" + AssetsPath() + "/out-cd-288.jpg"" style=""border:1px solid #C4C4C4;cursor:pointer""></a>")
   ' Else
   '  Response.Write("<a href=""" & SEOPageNameText(varGridArtistTitle, varGridFormat, varGridID, IsDBSomething(varGridUsedItem, "")) & "?searchid=" & varGridSearchID & """><img title=""" & varImageHoverText & """height=""" & varGridImageHeight & """width=""" & varGridImageWidth & """src=""" + AssetsPath() + "/out-288.jpg"" style=""border:1px solid #C4C4C4;cursor:pointer""></a>")
   ' End If
   'End If

   Dim on_err_img As String = AssetsPath() & "/out-288.jpg"
   If varGridFormat = "CD" Then
    on_err_img = AssetsPath() & "/out-cd-288.jpg"
   End If
   Response.Write("<a href=""" & SEOPageNameText(varGridArtistTitle, varGridFormat, varGridID, IsDBSomething(varGridUsedItem, "")) _
    & "?searchid=" & varGridSearchID & """><img title=""" & varImageHoverText & """height=""" & varGridImageHeight & """width=""" & varGridImageWidth _
    & """src=""" & ScanPath(varGridID, "320", "A") & """ class=""g-img""" _
    & "onerror=""this.onerror=null;this.src='" & on_err_img & "'""" _
    & "></a>")


   Response.Write("</td></tr><tr><td width=""308""height=""8"">")
   Response.Write("</td></tr><tr>")
   Response.Write("<td width=""308""height=""160""align=""center""valign=""top""style=""text-align:center;vertical-align:top;background-image:url('" + AssetsPath() + "/grid-bg13.gif');background-repeat:no-repeat"">")
   Response.Write("<table border=""0""cellspacing=""0"" cellpadding=""0"" width=""308""style=""border-collapse:collapse"">")
   If UCase(IsDBSomething(varGridUsedItem, "")) = "Y" Then
    Response.Write("<div class=""banner""style=""z-index:10""id=""BA" & varGridID & """>")
    Response.Write("<img title=""This is a used item.""src=""" + AssetsPath() + "/g-used-item5.gif"">")
    Response.Write("</div>")
   End If
   Response.Write("<div class=""yc2""style=""z-index:1000""name=""YC" & varGridID & """id=""YC" & varGridID & """>")
   Response.Write("<img style=""cursor:pointer""src=""" + AssetsPath() + "/g-ych6.gif""onclick=""gtcart()"">")
   Response.Write("</div>")
   Response.Write("<tr><td width=""308""height=""25""style=""text-align:center;vertical-align:bottom;padding-bottom:1px"">")
   Response.Write("<p class=""grid-artist"">" & varAT & "</p>")
   Response.Write("</td></tr><tr><td width=""308""height=""16""style=""text-align:center;vertical-align:top;padding-top:1px"">")
   Response.Write("<p class=""p-grid-title""title=""" & varImageHoverText & """>" & varGridTitle & "</p>")
   Response.Write("</td></tr><tr><td width=""308""height=""10"">")
   Response.Write("</td></tr><tr><td width=""308""height=""36""style=""text-align:center;vertical-align:top"">")
   Response.Write("<table border=""0""cellspacing=""0"" cellpadding=""0"" width=""308""style=""border-collapse:collapse"">")
   Response.Write("<tr><td width=""74""style=""text-align:right;vertical-align:top"">")
   If strShowSoundGrid = "y" And (IsDBSomething(varGridMP3FileCompleted, "")) = "Y" And InStr(1, varTracksGroup, "  1) ") > 0 Then
    Response.Write("<img alt=""Play sound""name=""T" & varGridID & "T01""id=""T" & varGridID & "T01""title=""Play sound sample""style=""margin-right:5px;cursor:pointer;vertical-align:top;margin-top:3px""onclick=""T('T" & varGridID & "T01','" & MP3Folder(varGridID) & "','ps6')""src=""" + AssetsPath() + "/ps6.gif""onmouseover=""fov(this,'ps6')""onmouseout=""fou(this,'ps6')"">")
   End If
   Response.Write("</td><td width=""36""style=""text-align:right;vertical-align:top"">")
   If varGridFormat = "CD" Then
    Response.Write("<a href=""/ItemDetails.aspx?ID=" & varGridID & """><img style=""margin-top:-1px""title=""CD (Compact Disc)""src=""" + AssetsPath() + "/g-cd2.gif""></a>")
   ElseIf varGridFormat = "LP" Then
    Response.Write("<a href=""/ItemDetails.aspx?ID=" & varGridID & """><img style=""margin-top:-1px""title=""LP (Vinyl Record)""src=""" + AssetsPath() + "/g-lp2.gif""></a>")
   ElseIf varGridFormat = "CS" Then
    Response.Write("<a href=""/ItemDetails.aspx?ID=" & varGridID & """><img style=""margin-top:-1px""title=""CS (Audio Cassette Tape)""src=""" + AssetsPath() + "/g-cs2.gif""></a>")
   ElseIf Left(varGridFormat, 1) = "V" Then
    Response.Write("<a href=""/ItemDetails.aspx?ID=" & varGridID & """><img title=""VHS (Video)""src=""" + AssetsPath() + "g-vhs2.gif""></a>")
   ElseIf Left(varGridFormat, 1) = "7" Then
    Response.Write("<a href=""/ItemDetails.aspx?ID=" & varGridID & """><img style=""margin-top:-1px""title=""7 Inch Vinyl Record""src=""" + AssetsPath() + "/g-72.gif""></a>")
   ElseIf Left(varGridFormat, 2) = "12" Then
    Response.Write("<a href=""/ItemDetails.aspx?ID=" & varGridID & """><img style=""margin-top:-1px""title=""12 Inch Vinyl Record""src=""" + AssetsPath() + "/g-122.gif""</a>")
   ElseIf Left(varGridFormat, 2) = "10" Then
    Response.Write("<a href=""/ItemDetails.aspx?ID=" & varGridID & """><img style=""margin-top:-1px""title=""10 Inch Vinyl Record""src=""" + AssetsPath() + "/g-102.gif""</a>")
   ElseIf varGridFormat = "CDS" Then
    Response.Write("<a href=""/ItemDetails.aspx?ID=" & varGridID & """><img style=""margin-top:-1px""title=""CD Single""src=""" + AssetsPath() + "/g-cd2.gif""></a>")
   ElseIf varGridFormat = "DVD" Then
    Response.Write("<a href=""/ItemDetails.aspx?ID=" & varGridID & """><img style=""margin-top:-1px""title=""DVD (Video)""src=""" + AssetsPath() + "/g-dvd2.gif""></a>")
   Else
    Response.Write("<a href=""/ItemDetails.aspx?ID=" & varGridID & """><img style=""margin-top:-1px""title=""Miscellaneous Item""src=""" + AssetsPath() + "/g-misc5.gif""></a>")
   End If
   Response.Write("</td><td width=""30""style=""text-align:center;vertical-align:top"">")
   If varGridItemIsInCart = 1 Then
    Response.Write("<input TYPE=""text"" id=""OA" & varGridID & """ name=""OA" & varGridID & """ class=""grid-qty-x""ONKEYDOWN=""Sc();VS=0""onkeyup=""CQ(" & varGridID & "," & varPriceForCartAddText & ",0,'OA',1)"" VALUE=""" & varQuantityInCart & """ maxlength=""3"">")
   Else
    Response.Write("<input TYPE=""text""id=""OA" & varGridID & """ name=""OA" & varGridID & """ class=""grid-qty""ONKEYDOWN=""Sc();VS=0""onkeyup=""CQ(" & varGridID & "," & varPriceForCartAddText & ",0,'OA',1)"" maxlength=""3"">")
   End If
   Response.Write("</td><td width=""20""style=""text-align:center;vertical-align:top"">")
   If varQueryType = "Backorders" Then
    Response.Write("<input alt border=""0"" align=""top"" type=""image"" title=""Delete this backorder"" style=""margin-top:5px""ONCLICK=""CQ(" & varGridID & "," & varPriceForCartAddText & ",-2,'-',0)"" src=""" + AssetsPath() + "/xb2.gif"">")
   Else
    Response.Write("<img style=""border-width:0px;cursor:pointer""title=""Remove item from cart."" ONCLICK=""CQ(" & varGridID & "," & varPriceForCartAddText & ",-1,'OA',0)""onmouseover=""fov(this,'g-x2')"" onmouseout=""fou(this,'g-x2')"" src=""" + AssetsPath() + "/g-x2.gif"">")
   End If
   Response.Write("</td><td width=""58""style=""text-align:left;vertical-align:top"">")
   Response.Write("<img style=""border-width:0px;cursor:pointer""title=""Add 1 to quantity in cart."" ONCLICK=""CQ(" & varGridID & "," & varPriceForCartAddText & ",1,'OA',0)""onmouseover=""fov(this,'g-add')"" onmouseout=""fou(this,'g-add')"" src=""" + AssetsPath() + "/g-add.gif"">")
   Response.Write("</td><td width=""90""style=""text-align:left;vertical-align:middle"">")
   If varSaleItem = 1 Then
    If Session("PriceGroup") = "StorePrice" Or Session("PriceGroup") = "ExportPrice" Then
     Response.Write("<p class=""g-price-x"">" & FormatCurrency(varPriceGroupPrice, 2) & "</p>")
     Response.Write("&nbsp;<p class=""g-price"">" & FormatCurrency(varGridSale_WholesalePrice, 2) & "</p>")
    Else
     Response.Write("<p class=""g-price-x"">" & FormatCurrency(varPriceGroupPrice, 2) & "</p>")
     Response.Write("&nbsp;<p class=""g-price"">" & FormatCurrency(varGridSale_RetailPrice, 2) & "</p>")
    End If
   Else
    Response.Write("<p class=""g-price"">" & FormatCurrency(varPriceUsing, 2) & "</p>")
   End If
   Response.Write("</td></tr></table>")
   If Not IsDBNull(varGridRhythmName) Then
    If Not IsDBNull(varItemFeatures1) Then
     Response.Write("</td></tr><tr><td width=""308""height=""17""style=""text-align:center;vertical-align:top;padding-left:0px;padding-right:0px"">")
     Response.Write(FigureItemFeaturesTextForGridView(IsDBSomething(varGridRhythmName, ""), IsDBSomething(varItemFeatures1, ""), IsDBSomething(varItemFeatures2, ""), IsDBSomething(varItemFeatures3, ""), IsDBSomething(varItemFeatures4, ""), IsDBSomething(varItemFeatures5, ""), IsDBSomething(varItemFeatures6, ""), IsDBSomething(varItemFeatures7, ""), IsDBSomething(varItemFeatures8, ""), IsDBSomething(varItemFeatures9, ""), IsDBSomething(varItemFeatures10, "")))
     Response.Write("</td></tr><tr><td width=""308""height=""14""style=""text-align:center;vertical-align:bottom;padding-left:0px;padding-right:0px"">")
     If Len(varGridRhythmName) > 31 Then
      varRhythmnNameToShow = Left(varGridRhythmName, 28) & "..."
     Else
      varRhythmnNameToShow = varGridRhythmName
     End If
     Response.Write("<p class=""p.r-grid"">RHYTHM: <span Class=""grid-if"" title=""Show all on this rhythm""ONCLICK=""AR(" & varGridID & ")"">" & varRhythmnNameToShow & "</span></p>")
    Else
     Response.Write("</td></tr><tr><td width=""308""height=""31""style=""text-align:center;vertical-align:middle;padding-left:0px;padding-right:0px"">")
     If Len(varGridRhythmName) > 76 Then
      varRhythmnNameToShow = Left(varGridRhythmName, 73) & "..."
     Else
      varRhythmnNameToShow = varGridRhythmName
     End If
     Response.Write("<p class=""p.r-grid"">RHYTHM: <span Class=""grid-if"" title=""Show all on this rhythm""ONCLICK=""AR(" & varGridID & ")"">" & varRhythmnNameToShow & "</span></p>")
    End If
   Else
    Response.Write("</td></tr><tr><td width=""308""height=""31""style=""text-align:center;vertical-align:top;padding-left:0px;padding-right:0px"">")
    If Not IsDBNull(varItemFeatures1) Then
     Response.Write(FigureItemFeaturesTextForGridView(IsDBSomething(varGridRhythmName, ""), IsDBSomething(varItemFeatures1, ""), IsDBSomething(varItemFeatures2, ""), IsDBSomething(varItemFeatures3, ""), IsDBSomething(varItemFeatures4, ""), IsDBSomething(varItemFeatures5, ""), IsDBSomething(varItemFeatures6, ""), IsDBSomething(varItemFeatures7, ""), IsDBSomething(varItemFeatures8, ""), IsDBSomething(varItemFeatures9, ""), IsDBSomething(varItemFeatures10, "")))
    End If
   End If
   Response.Write("</td></tr><tr><td width=""308""height=""42""style=""text-align:center;vertical-align:middle"">")
   Response.Write("<table border=""0""cellspacing=""0"" cellpadding=""0"" width=""308""style=""border-collapse:collapse"">")
   Response.Write("<tr><td width=""20""style=""text-align:left;vertical-align:middle"">")
   Response.Write("</td><td width=""185""style=""text-align:left;vertical-align:middle"">")
   Response.Write("<p Class=""grid-l""title=""Show all on this label""ONCLICK=""AL(" & varGridID & ")"">" & Trim(varGridLabel) & "</p>")
   Response.Write("</td><td width=""103""style=""text-align:left;vertical-align:middle"">")
   If varGridSimilarItemsAvailable = 1 Then
    Response.Write("<img style=""border-width:0px;cursor:pointer""title=""" & varGridID & """ onclick=""SI('" & varGridID & "')""onmouseover=""fov(this,'grid-ss3')"" onmouseout=""fou(this,'grid-ss3')""src=""" + AssetsPath() + "/grid-ss3.gif"">")
   End If
   Response.Write("</td></tr></table>")
   Response.Write("</td></tr></table>")
   Response.Write("</td></tr></table>")
   Response.Write("</td>")
  End Sub
</script>
