
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

 'Wholesale or Retail
 Dim varWholesaleOrRetail As String = ""
 If Request.QueryString("wr") = "r" Then
  varWholesaleOrRetail = "retail"
 ElseIf Request.QueryString("wr") = "w" Then
  varWholesaleOrRetail = "wholesale"
 Else
  varWholesaleOrRetail = Request("WholesaleOrRetailTxt")
 End If
 If varWholesaleOrRetail = "" Then varWholesaleOrRetail = "retail"
 'Continue To Purchase Page Variable
 Dim varContinueToPurchasePage As String = ""
 If Request.QueryString("ContinueToPurchasePage") = "y" Or Request("ContinueToPurchasePage") = "y" Then
  varContinueToPurchasePage = "y"
 Else
  varContinueToPurchasePage = "no"
 End If
 %>

<html xmlns="https://www.w3.org/1999/xhtml">
<head>
<title>Country | Millions of Records</title>
<link rel="shortcut icon" href="favicon.ico?"/>
<link rel="icon" href="/favicon.ico?" type="image/x-icon"/>

<style type="text/css">
 P {font-family:arial,verdana,helvetica,sans-serif;font-size:12px;color:#000000;display:inline}
 p.pow {font-family:verdana,arial,helvetica;font-size:12px;color:#ffffff;background-color:#566BEC;min-height:20px;padding-bottom:2px;cursor:pointer}
 p.title {font-family:arial,verdana,helvetica,sans-serif;font-size:20px;color:#000000;font-weight:600}
 input {}
  .i {color:#000000;background-color:#FFFFFF;font-size:13px}
  .u {font-weight:900;color:#FF0000;background-color:#FFFF00;font-size:13px}
 font {font-family:arial,verdana,helvetica}
  .a {font-weight:0;font-size:12px;color:#000000}
  .b {font-weight:900;background-color:#FFFF00;font-size:12px;color:#FF0000}
  .c {font-size:10px;color:#000000}
  .d {font-weight:900;background-color:#647864;font-size:13px;color:#FFFFFF}
  .e {font-size:12px;color:#000078}
  .f {font-size:12px;color:#000078}
 div {}
  .q {position:absolute;width:350;height:200;background-color:#F5D7A0;padding:8;visibility:hidden;font: 11px verdana;border-style:solid;border-color:#D69669;border-width:4px;border-style:ridge}
  .r {position:absolute;align:center;width:22%;height:100;background-color:#F5D7A0;padding:8;visibility:hidden;font: 11px verdana;border-style:solid;border-color:#C8E6C8;border-width:4px;border-style:ridge}
</style>

<script type="text/javascript"language="javascript">
var isW3C=(document.getElementById) ? true : false;
function countrychosen(){
 varElem=(isW3C) ? document.getElementById("CountryListCode"):document.all("CountryListCode");
 document.shiptocounty.submit()
}
function submitform(){
 document.shiptocounty.submit()
}
function fov(a,q){
 a.src = '<%=AssetsPath()%>/' + q + "h.gif"
}
function fou(a,q){
 a.src = '<%=AssetsPath()%>/' + q + ".gif"
}
function fovs(a, q) {
 a.src = '<%=AssetsPath()%>/' + q + "l.gif"
}
function fous(a, q) {
 a.src = '<%=AssetsPath()%>/' + q + ".gif"
}

</script>
</head>


<body leftmargin="0" rightmargin="0" link="000000" alink="000000" vlink="000000" bgcolor="000000">
<form name="shiptocounty" action="/NewCustomer.aspx" method="post">
<input type="hidden"value="<%=varWholesaleOrRetail%>"id="WholesaleOrRetailTxt"name="WholesaleOrRetailTxt" />
<input type="hidden"value="<%=varContinueToPurchasePage%>"id="ContinueToPurchasePage"name="ContinueToPurchasePage" />

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
<td align="center"height="50"valign="top">
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
<p style="font-size:28px;font-weight:600;color:#ffffff">Select Your Country</p>
</td></tr></table>
<table width="1250"align="center"style="background-color:#D4DBD4;text-align:left"border="0"cellpadding="0"cellspacing="0"frame="void">
<tr><td height="35">
</td></tr></table>

<%'Country%>
<table bgcolor="D4DBD4" frame="none" cellpadding="0" cellspacing="0" WIDTH="1250" align="center" BORDER="0">
<tr><td width="170"height="456">
</td><td width="910"style="text-align:center;vertical-align:top;padding-top:130px;background-image:url('<%=AssetsPath()%>/country-bg.gif');background-repeat:no-repeat">
<p class="title">Please select the country your orders will be shipping to:</p>
<br><br>
<select onchange="countrychosen()" style="border-radius:12px;width:450px;height:50px;background-color:#EEF6EE;vertical-align:middle;padding-left:7px;font-size:16px;border:1px solid #AAB0AA" id="CountryListCode" name="CountryListCode">
<%
 Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
  SqlConnection.ClearPool(conn)
  conn.Open()
  Dim CMD_GetCountryList As New SqlCommand("spGetCountryList", conn)
  CMD_GetCountryList.CommandType = Data.CommandType.StoredProcedure
  Dim readerMessages As SqlDataReader
  readerMessages = CMD_GetCountryList.ExecuteReader
  Do While readerMessages.Read
   Response.Write("<option value='" & readerMessages("counter") & "'>" & readerMessages("CountryText"))
  Loop
 End Using
%>
</select></form>
<br><br>
<img onclick="submitform()"onmouseover="fovs(this,'continue')"onmouseout="fous(this,'continue')"style="margin-top:5px;border:0px;cursor:pointer"src="<%=AssetsPath()%>/continue.gif"/>
</td><td width="170">
</td></tr></table>

<table align="center" bgcolor="D4DBD4" WIDTH="1250">
<tr><td height="20">
</td></tr></table>

<table align="center" bgcolor="D4DBD4" WIDTH="1250">
<tr><td width="210" height="140">
</td><td width="830"align="left" style="border:1px solid #565656;vertical-align:top;padding-top:20px;padding-left:40px;padding-right:40px;padding-bottom:20px">
<p style="font-size:15px" color="000000">
PLEASE NOTE:
<br />1) If you reside outside of the USA and want orders shipped to the USA then select "USA (50 States)".
<br />2) If you want orders shipped to a US military address (APO, FPO, DPO) then select your military address from the country drop-down list above.
</p>
</td><td width="210">
</td></tr></table>


<% ' Table Bottom%>
<table bgcolor="D4DBD4" cellpadding="0" cellspacing="0" WIDTH="1250" align="center" BORDER="0">
<td height="370"></td>
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










