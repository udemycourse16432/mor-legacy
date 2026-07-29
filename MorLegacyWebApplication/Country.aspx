<%@ Page Language="VB" MasterPageFile="~/Site.Master" Debug="true" AutoEventWireup="false" EnableViewState="false" Title="Country | Millions of Records" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">

<style type="text/css">
 p.title {font-family:arial,verdana,helvetica,sans-serif;font-size:20px;color:#000000;font-weight:600}
 input {}
  .i {color:#000000;background-color:#FFFFFF;font-size:13px}
  .u {font-weight:900;color:#FF0000;background-color:#FFFF00;font-size:13px}
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

<script type="text/javascript" language="javascript">
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
</script>

</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="BodyContent" runat="server">

<%
 Dim strConnectionStringName As String = ""
 If Context.IsDebuggingEnabled OrElse Request.ServerVariables("HTTP_X_FORWARDED_FOR") = "1.1.1.27" then
  strConnectionStringName = "MillionsOfRecordsConnectionStringDevelopment"
 Else
  strConnectionStringName = "MillionsOfRecordsConnectionStringProduction"
 End If

 Dim varWholesaleOrRetail As String = ""
 If Request.QueryString("wr") = "r" Then
  varWholesaleOrRetail = "retail"
 ElseIf Request.QueryString("wr") = "w" Then
  varWholesaleOrRetail = "wholesale"
 Else
  varWholesaleOrRetail = Request("WholesaleOrRetailTxt")
 End If
 If varWholesaleOrRetail = "" Then varWholesaleOrRetail = "retail"

 Dim varContinueToPurchasePage As String = ""
 If Request.QueryString("ContinueToPurchasePage") = "y" Or Request("ContinueToPurchasePage") = "y" Then
  varContinueToPurchasePage = "y"
 Else
  varContinueToPurchasePage = "no"
 End If
%>

<form name="shiptocounty" action="/NewCustomer.aspx" method="post">
<input type="hidden" value="<%=varWholesaleOrRetail%>" id="WholesaleOrRetailTxt" name="WholesaleOrRetailTxt" />
<input type="hidden" value="<%=varContinueToPurchasePage%>" id="ContinueToPurchasePage" name="ContinueToPurchasePage" />

<table bgcolor="9BAF9B" cellpadding="0" cellspacing="0" WIDTH="1250" align="center" BORDER="0">
<tr><td align="center" height="45" valign="top">
<p style="font-size:28px;font-weight:600;color:#ffffff">Select Your Country</p>
</td></tr></table>
<table width="1250" align="center" style="background-color:#D4DBD4;text-align:left" border="0" cellpadding="0" cellspacing="0" frame="void">
<tr><td height="35">
</td></tr></table>

<table bgcolor="D4DBD4" frame="none" cellpadding="0" cellspacing="0" WIDTH="1250" align="center" BORDER="0">
<tr><td width="170" height="456">
</td><td width="910" style="text-align:center;vertical-align:top;padding-top:130px;background-image:url('<%=AssetsPath()%>/country-bg.gif');background-repeat:no-repeat">
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
<img onclick="submitform()" onmouseover="fovs(this,'continue')" onmouseout="fous(this,'continue')" style="margin-top:5px;border:0px;cursor:pointer" src="<%=AssetsPath()%>/continue.gif"/>
</td><td width="170">
</td></tr></table>

<table align="center" bgcolor="D4DBD4" WIDTH="1250">
<tr><td height="20">
</td></tr></table>

<table align="center" bgcolor="D4DBD4" WIDTH="1250">
<tr><td width="210" height="140">
</td><td width="830" align="left" style="border:1px solid #565656;vertical-align:top;padding-top:20px;padding-left:40px;padding-right:40px;padding-bottom:20px">
<p style="font-size:15px" color="000000">
PLEASE NOTE:
<br />1) If you reside outside of the USA and want orders shipped to the USA then select "USA (50 States)".
<br />2) If you want orders shipped to a US military address (APO, FPO, DPO) then select your military address from the country drop-down list above.
</p>
</td><td width="210">
</td></tr></table>

<table bgcolor="D4DBD4" cellpadding="0" cellspacing="0" WIDTH="1250" align="center" BORDER="0">
<td height="370"></td>
</table>

</asp:Content>
