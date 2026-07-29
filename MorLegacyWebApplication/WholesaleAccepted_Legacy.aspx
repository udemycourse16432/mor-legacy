
<%@ Page Language="VB" Debug="true" AutoEventWireup="false" EnableViewState="false" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web" %>


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

 'Empty Retail Cart Into Wholesale Cart (if not a PowerUser) 
 Dim varSaleItem As Integer = 0
 Dim WholesalePrice As Decimal = 0
 Dim RetailNameOfCart As String = ""
 Dim WholesaleNameOfCart As String = ""
 RetailNameOfCart = "CART" & Session.SessionID & Session("CartRandomNumbersExtension")
 WholesaleNameOfCart = "W_CART_" & Session("CustomerServerCounter")
 If Session("PowerUserName") = "" And (Session("PriceGroup") = "StorePrice" Or Session("PriceGroup") = "ExportPrice") Then
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
       CMD_D.Parameters.AddWithValue("@ItemID", readerRC("ItemID"))
       Dim readerInv As SqlDataReader
       readerInv = CMD_D.ExecuteReader
       If readerInv.HasRows Then
        readerInv.Read()
        If Not IsDBNull(readerInv("Sale_WholesalePrice")) And Not IsDBNull(readerInv("Sale_WholesaleEndDate")) Then
         If DateDiff(DateInterval.Day, Date.Now, readerInv("Sale_WholesaleEndDate")) >= 0 Then
          varSaleItem = 1
         End If
        End If
        If varSaleItem = 1 Then
         If IsDBNull(readerInv("Sale_WholesalePrice")) Then
          WholesalePrice = 0
         Else
          WholesalePrice = readerInv("Sale_WholesalePrice")
         End If
        ElseIf Session("PriceGroup") = "StorePrice" Then
         WholesalePrice = readerInv("StorePrice")
        ElseIf Session("PriceGroup") = "ExportPrice" Then
         WholesalePrice = readerInv("ExportPrice")
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
       CMD_D.Parameters.AddWithValue("@WholesalePrice", WholesalePrice)
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
 'Cart Totals
 Dim quantitytotal As Integer = 0
 Dim strItems As String = ""
 Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
  SqlConnection.ClearPool(conn)
  conn.Open()
  Dim CMD_X As New SqlCommand("spGetCartTotalsWholesalePrice", conn)
  CMD_X.CommandType = Data.CommandType.StoredProcedure
  CMD_X.Parameters.AddWithValue("@CartName", NameOfCart)
  Dim readerX As SqlDataReader
  readerX = CMD_X.ExecuteReader
  If readerX.HasRows Then
   Do While readerX.Read
    quantitytotal = quantitytotal + readerX("Quantity")
   Loop
  End If
 End Using

%>

<html xmlns="https://www.w3.org/1999/xhtml">
<head>
<title>Wholesale Accepted | Millions of Records</title>
<link rel="shortcut icon" href="favicon.ico?"/>
<link rel="icon" href="/favicon.ico?" type="image/x-icon"/>

<script type="text/javascript"language="javascript">

function fovs(a,q){
 a.src = '<%=AssetsPath()%>/' + q + "l.gif"
}
function fous(a,q){
 a.src = '<%=AssetsPath()%>/' + q + ".gif"
}

</script>
<style type="text/css">
 P {font-family:verdana,arial,helvetica,sans-serif;font-size:12px;color:#000000;display:inline}
 p.pow {font-family:verdana,arial,helvetica;font-size:12px;color:#ffffff;background-color:#566BEC;min-height:20px;padding-bottom:2px;cursor:pointer}
 p.b {font-weight:900;font-size:12px;color:#000000}
 input {}
  .i {color:#000000;background-color:#FFFFFF;font-size:13px}
 font {font-family:verdana,arial,helvetica}
  .a {font-weight:0;font-size:12px;color:#000000}
 a {font-family:verdana,arial,helvetica;color:#000000;font-size:13px}
</style>

</head>

<body leftmargin="0" rightmargin="0" link="000000" alink="000000" vlink="000000" bgcolor="000000">

<% ' Top Of Page %>
<table bgcolor="000000" bordercolorlight="879B87" bordercolordark="D4DBD4" cellpadding="0" cellspacing="0" width="1250" align="center" BORDER="0">
<tr valign="bottom">
<td width="216"height="32"align="center"valign="bottom">
<div style="position:absolute;width:216px;margin-left:-4px;margin-top:1px;cursor:pointer"onclick="window.location='/home.aspx'">
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

<table cellpadding="0" cellspacing="0" align="center" bgcolor="9BAF9B" width="1250">
<td align="center"height="45"valign="top">
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

<table bgcolor="9BAF9B"cellpadding="0" cellspacing="0" WIDTH="1250" align="center" BORDER="0">
<tr><td align="center"height="45"valign="top">
<p style="font-size:28px;font-weight:600;color:#ffffff">Sign In Successful</p>
</td></tr></table>

<table align="center" bgcolor="D4DBD4"cellpadding="0" cellspacing="0" WIDTH="1250" BORDER="0">
<tr><td width="1250"valign="top"align="center"style="padding-top:80px">
<%'Link Buttons%>

<a href="/Home.aspx"><img style="border:0px"src="<%=AssetsPath()%>/continue-shopping-big2.gif"title="Click here to return to our home page and begin ordering product"onmouseover="fovs(this,'continue-shopping-big2')" onmouseout="fous(this,'continue-shopping-big2')"></a>
<a href="/Home.aspx?TabH=Cart"><img style="border:0px"src="<%=AssetsPath()%>/view-cart-checkout5.gif"title="Click here to view your shopping cart / checkout."onmouseover="fovs(this,'view-cart-checkout5')" onmouseout="fous(this,'view-cart-checkout5')"></a>
<a href="/CustomerInfo.aspx"><img style="border:0px"src="<%=AssetsPath()%>/your-account-big.gif"title="Click here to view your customer details (shipping address, orders, etc)"onmouseover="fovs(this,'your-account-big')" onmouseout="fous(this,'your-account-big')"></a>
<a href="/CustomerOrders.aspx"><img style="border:0px"src="<%=AssetsPath()%>/your-orders-big.gif"title="Click here to view your orders and invoices"onmouseover="fovs(this,'your-orders-big')" onmouseout="fous(this,'your-orders-big')"></a>
<%if quantitytotal=1 then
  strItems=quantitytotal & " Item"
 ElseIf quantitytotal = 0 Then
  strItems = "Cart: $0.00"
 Else
  strItems =quantitytotal & " Items"
 end if%>
<br><b><font face="verdana"style="font-size:16px;color:#000000;margin-right:144px"><%=strItems%></font></b>
<br>
<br><br>
</td></tr></table>

<table cellpadding="20"align="center" bgcolor="D4DBD4" WIDTH="1250">
<td valign="middle"align="left"height="80"style="padding-left:200px;padding-right:200px">
<font face="arial"style="font-size:14px" color="000000">
PLEASE NOTE:
<br />1) You must sign in every time you add items to your cart, or the items will be lost.
<br />2) Items will remain in your cart until you purchase, so you can work on your order for several days or weeks before purchasing.
<br />3) There is no minimum order. You can order as much or as little as you like.
<br />4) To view shipping options and prices, please view the cart page after you have added items to your cart.
</td></table>


<% ' Table Bottom%>
<table bgcolor="D4DBD4" cellpadding="0" cellspacing="0" WIDTH="1250" align="center" BORDER="0">
<td height="420"></td>
</table>
<table cellpadding="0" cellspacing="0" WIDTH="1250" align="center" BORDER="0">
<td width="8"><img alt src="<%=AssetsPath()%>/tbld.gif" WIDTH="8" HEIGHT="7"></td>
<td bgcolor="D4DBD4" width="99%"></td>
<td width="8"><img alt src="<%=AssetsPath()%>/tbrd.gif" WIDTH="8" HEIGHT="7"></td>
</table> 
<table cellpadding="0" cellspacing="0" width="1250" align="center" BORDER="0">
<tr><td align="center"><font face="arial" style="font-size:13px"color="ffffff"><%=CopyrightFooter()%></font>
</td></tr><table>

</body>

</html>










