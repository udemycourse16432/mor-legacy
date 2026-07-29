<%@ Page Language="VB" MasterPageFile="~/Site.Master" Debug="true" AutoEventWireup="false" EnableViewState="false" Title="Wholesale Accepted | Millions of Records" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web" %>
<%@ MasterType VirtualPath="~/Site.Master" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">

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

</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="BodyContent" runat="server">

<%
 Dim strConnectionStringName As String = Master.ConnectionStringName

 Dim varServerCounter As String = ""
 Dim NameOfCart As String = Master.CartName
 Dim varPriceGroup As String = Master.PriceGroup

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

<table bgcolor="9BAF9B"cellpadding="0" cellspacing="0" WIDTH="1250" align="center" BORDER="0">
<tr><td align="center"height="45"valign="top">
<p style="font-size:28px;font-weight:600;color:#ffffff">Sign In Successful</p>
</td></tr></table>

<table align="center" bgcolor="D4DBD4"cellpadding="0" cellspacing="0" WIDTH="1250" BORDER="0">
<tr><td width="1250"valign="top"align="center"style="padding-top:80px">

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

<table bgcolor="D4DBD4" cellpadding="0" cellspacing="0" WIDTH="1250" align="center" BORDER="0">
<td height="420"></td>
</table>

</asp:Content>
