
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

    'Page Title
    Dim strPageTitle As String = ""
    If Session("PowerUserName") <> "" Then
        If Session("StoreName") <> "" Then
            strPageTitle = NoQuotes(Session("StoreName"))
        ElseIf Session("RetailCustomerName") <> "" Then
            strPageTitle = NoQuotes(Session("RetailCustomerName"))
        Else
            strPageTitle = Session("PowerUserName")
        End If
    Else
        strPageTitle = "MillionsOfRecords - About Us"
    End If%>

<html xmlns="https://www.w3.org/1999/xhtml">

<head>

<title><%=strPageTitle%></title>

<link rel="shortcut icon" href="favicon.ico?"/>
<link rel="icon" href="/favicon.ico?" type="image/x-icon"/>
<script type="text/javascript"language="javascript">
function C(){
 document.ShipInfo.submit()
}
VS = 0
function FFV(){
 if (VS==0) {
  return false;
  }
 else if (VS==3){
   document.TT.TabH.value="Cart"
   return true
  }
 else if (VS==31){
   document.TT.action="Options.aspx"
   return true
  }
 else if (VS==32){
   document.TT.action="AboutUs.aspx"
   return true
  }
 else if (VS==33){
   document.TT.action="HelpFrequently.aspx"
   return true
  }
 else if (VS==34){
   document.TT.action="Links.aspx"
   return true
  }
 else if (VS==35){
   document.TT.action="Wholesale.aspx"
   return true
  }
}
function fovs(a,q){
 a.src = '<%=AssetsPath()%>/' + q + "l.gif"
}
function fous(a,q){
 a.src = '<%=AssetsPath()%>/' + q + ".gif"
}

</script>

<style type="text/css">
 P {font-family:arial,verdana,helvetica,sans-serif;font-size:12px;color:#000000;display:inline}
 p.pow {font-family:arial,verdana,helvetica;font-size:12px;color:#ffffff;background-color:#566BEC;min-height:20px;padding-bottom:2px;cursor:pointer}
 input {}
  .i {color:#000000;background-color:#FFFFFF;font-size:13px}
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
<td><img alt border="0" src="<%=AssetsPath()%>/aboutus5h.gif" style="cursor:pointer" onclick="window.location='/AboutUs.aspx'"></td>
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

<table cellpadding="0" cellspacing="0" border="0" align="center" bgcolor="D4DBD4" width="1250">
<tr><td align="center">
<img alt border="0" src="<%=AssetsPath()%>/abus5.gif">
</td></tr></table>

<table cellpadding="0" cellspacing="0" border="0" align="center" bgcolor="D4DBD4" width="1250">
<tr><td width="30" bgcolor="D4DBD4"></td>
<td style="text-align:justify;padding-left:10px;padding-right:10px;padding-top:15px;padding-bottom:15px;border:1px solid #B3B7B3" width="920">
<font face="verdana,arial" style="font-size:14px">
Millions of Records is a worldwide mail-order and one-stop distribution company based in El Dorado Hills, California, selling records, CDs, tapes and other music products. The company is owned and operated by Ernie Boetius (founder of Ernie B's Reggae Distribution, later known as EBreggae and EBrecords). At Millions of Records all genres are represented, with special attention to reggae music.
<br /><br />
We offer a vast selection of rare and obscure CDs, records & tapes, as well as supplying the full line of releases by key labels such as Ace Records, Waxtime, VP Records, Greensleeves, Not Now Music and many more.
<br /><br />
You will receive unbeatable, first-rate service - always at a reasonable price. We look forward to serving you.
</font>
</td><td width="30" bgcolor="D4DBD4"></td>
</tr></table>



<table cellpadding="0" cellspacing="0" align="center" bgcolor="D4DBD4" width="1250">
<tr><td width="30" bgcolor="D4DBD4"></td>
<td style="text-align:justify" width="920">



<%'Ordering & Payment%>
<br/><br/>
<img alt src="<%=AssetsPath()%>/ordering50.gif">
<br/>
<font face="verdana,arial" style="font-size:14px"><a href="/HelpShipping.aspx">Payment & Shipping Info</a>
</font>

<br/><br/>
<img alt src="<%=AssetsPath()%>/policies50.gif">
<br/><font face="verdana,arial" style="font-size:14px"><a href="/helpfrequently.aspx">Returns & Customer Service</a>
<br/><font face="verdana,arial" style="font-size:14px"><a href="/helpfrequently.aspx">Satisfaction Guarantee</a>
<br/><font face="verdana,arial" style="font-size:14px"><a href="/helpfrequently.aspx">Packaging Guarantee</a>
<br/><font face="verdana,arial" style="font-size:14px"><a href="/helpfrequently.aspx">Delivery Guarantee</a>

<br/><br/>
<img alt src="<%=AssetsPath()%>/legal50.gif">
<br/><font face="verdana,arial" style="font-size:14px"><a href="/privacy-policy.aspx">Privacy Policy</a>
<br/><font face="verdana,arial" style="font-size:14px"><a href="/website-usage.aspx">Website Usage Terms & Conditions</a>


</td>
</tr>
</table>
<table cellpadding="0" cellspacing="0" border="0" frame="0" align="center" bgcolor="D4DBD4" width="1250">
<tr><td height="330">
</td></table>
<% ' Table Bottom%>
<table cellpadding="0" cellspacing="0" WIDTH="1250" align="center" BORDER="0">
<td width="7"><img alt src="<%=AssetsPath()%>/tbld.gif" WIDTH="8" HEIGHT="7"></td>
<td bgcolor="D4DBD4" width="99%"></td>
<td width="7"><img alt src="<%=AssetsPath()%>/tbrd.gif" WIDTH="8" HEIGHT="7"></td>
</table> 
<table cellpadding="0" cellspacing="0" width="1250" align="center" BORDER="0">
<tr><td align="center"><font face="arial" style="font-size:13px"color="ffffff"><%=CopyrightFooter()%></font>
</td></tr><table>

</body>

</html>









