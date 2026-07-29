<%@ Page Language="VB" MasterPageFile="~/Site.Master" Debug="true" AutoEventWireup="false" EnableViewState="false" Title="MillionsOfRecords - About Us" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Web" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="BodyContent" runat="server">

<%
    If Session("PowerUserName") <> "" Then
        If Session("StoreName") <> "" Then
            Page.Title = NoQuotes(Session("StoreName"))
        ElseIf Session("RetailCustomerName") <> "" Then
            Page.Title = NoQuotes(Session("RetailCustomerName"))
        Else
            Page.Title = Session("PowerUserName")
        End If
    End If
%>

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
We offer a vast selection of rare and obscure CDs, records &amp; tapes, as well as supplying the full line of releases by key labels such as Ace Records, Waxtime, VP Records, Greensleeves, Not Now Music and many more.
<br /><br />
You will receive unbeatable, first-rate service - always at a reasonable price. We look forward to serving you.
</font>
</td><td width="30" bgcolor="D4DBD4"></td>
</tr></table>

<table cellpadding="0" cellspacing="0" align="center" bgcolor="D4DBD4" width="1250">
<tr><td width="30" bgcolor="D4DBD4"></td>
<td style="text-align:justify" width="920">

<br/><br/>
<img alt src="<%=AssetsPath()%>/ordering50.gif">
<br/>
<font face="verdana,arial" style="font-size:14px"><a href="/HelpShipping.aspx">Payment &amp; Shipping Info</a>
</font>

<br/><br/>
<img alt src="<%=AssetsPath()%>/policies50.gif">
<br/><font face="verdana,arial" style="font-size:14px"><a href="/helpfrequently.aspx">Returns &amp; Customer Service</a>
<br/><font face="verdana,arial" style="font-size:14px"><a href="/helpfrequently.aspx">Satisfaction Guarantee</a>
<br/><font face="verdana,arial" style="font-size:14px"><a href="/helpfrequently.aspx">Packaging Guarantee</a>
<br/><font face="verdana,arial" style="font-size:14px"><a href="/helpfrequently.aspx">Delivery Guarantee</a>

<br/><br/>
<img alt src="<%=AssetsPath()%>/legal50.gif">
<br/><font face="verdana,arial" style="font-size:14px"><a href="/privacy-policy.aspx">Privacy Policy</a>
<br/><font face="verdana,arial" style="font-size:14px"><a href="/website-usage.aspx">Website Usage Terms &amp; Conditions</a>

</td>
</tr>
</table>
<table cellpadding="0" cellspacing="0" border="0" frame="0" align="center" bgcolor="D4DBD4" width="1250">
<tr><td height="330">
</td></table>

</asp:Content>
