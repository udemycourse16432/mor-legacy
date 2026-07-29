<%@ Page Language="VB" MasterPageFile="~/Site.Master" Debug="true" AutoEventWireup="false" EnableViewState="false" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web" %>
<%@ MasterType VirtualPath="~/Site.Master" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">

<script type="text/javascript"language="javascript">
var timer_is_on=0
var tmrA
var intX=0
var loadingID
var runningScript=0
VS=0
var showingname="a"
var isW3C = (document.getElementById) ? true : false;
var intNLast = -1

function removePaymentMethod(x) {
document.location.href='/CustomerInfo.aspx?rpm='+x
}
function addPaymentMethod(x) {
 document.location.href = '/CustomerInfo.aspx?apm=' + x
}

function copySignInCredentials() {
 var copySuccess = document.getElementById("SignInCredentialsSuccess")
 var copyDiv = document.getElementById("SignInCredentialsEmailDiv")
 var copyText = document.getElementById("SignInCredentialsEmailText")
 copyDiv.style.visibility = "visible"
 copyText.select()
 document.execCommand("copy")
 copyDiv.style.visibility = "hidden"
 copySuccess.style.visibility="visible"
}
function UseLastCustomerRep(){
 elemCINotes=(isW3C) ? document.getElementById("CINotes"):document.all("CINotes");
 elemCICustomerRep=(isW3C) ? document.getElementById("CICustomerRep"):document.all("CICustomerRep");
 elemCILastCustomerRep=(isW3C) ? document.getElementById("CILastCustomerRep"):document.all("CILastCustomerRep");
 elemCICustomerRep.value=elemCILastCustomerRep.value
 elemCINotes.focus()
}
function MarkAsInactive(){
 varElem=(isW3C) ? document.getElementById("CINotes"):document.all("CINotes");
 varElem.value="INACTIVE:  This account is no longer active, so do not use this account.  Please use this customer's active account instead."
 UpdateCIEntry('0','0')
}
function UpdateCIEntry(counter,JRN){
 if (counter.indexOf("delete") == -1 && counter!="0"){
  varElem=(isW3C) ? document.getElementById("CIEBRep"+counter):document.all("CIEBRep"+counter);
  if (varElem.value==""){
   alert('Please enter the "EBRep" field.')
   varElem.focus()
   return
  }
  varElem=(isW3C) ? document.getElementById("CINotes"+counter):document.all("CINotes"+counter);
  if (varElem.value==""){
   alert('Please enter something in the "Notes" field.')
   varElem.focus()
   return
  }
 }
 if (counter.indexOf("delete") != -1){
  var r=confirm("CLICK 'OK' TO DELETE THIS ENTRY.")
  if (r==false){
   return false
  }
 }
 elemRand=(isW3C) ? document.getElementById("JavascriptRandomNumber"):document.all("JavascriptRandomNumber");
 varElem=(isW3C) ? document.getElementById("CICounter"):document.all("CICounter");
 varElem.value=counter
 varElemJRN=(isW3C) ? document.getElementById("CIJavascriptRandomNumber"):document.all("CIJavascriptRandomNumber");
 varElemJRN.value=JRN
 elemRand.value=Math.round(Math.random()*1000000000)
 document.CI.submit()
}
function EscapeTotal(x){
 x=escape(x)
 while (x.indexOf("*") != -1){
  x=x.replace("*","%2A")
 }
 while (x.indexOf("@") != -1){
  x=x.replace("@","%40")
 }
 while (x.indexOf("-") != -1){
  x=x.replace("-","%2D")
 }
 while (x.indexOf("_") != -1){
  x=x.replace("_","%5F")
 }
 while (x.indexOf("+") != -1){
  x=x.replace("+","%2B")
 }
 while (x.indexOf(".") != -1){
  x=x.replace(".","%2E")
 }
 while (x.indexOf("/") != -1){
  x=x.replace("/","%2F")
 }
 return x
}
function EmailErnieSavedCart(email){
 if (window.XMLHttpRequest){
  xmlhttp=new XMLHttpRequest()
 }else{
  xmlhttp=new ActiveXObject("Microsoft.XMLHTTP")
 }
 xmlhttp.onreadystatechange=function(){
  if (xmlhttp.readyState==4 && xmlhttp.status==200){
   if (xmlhttp.responseText.indexOf("ERROR:")!=-1){
   
   }else{
    alert('Email sent successfully: '+xmlhttp.responseText+' cart(s).')
   }
  }
 }
 xmlhttp.open("POST","/EmailErnieSavedCarts.aspx",true)
 xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded")
 xmlhttp.send("Email="+EscapeTotal(email))
}
function HideDiv(yy){
 varElem=(isW3C) ? document.getElementById(yy):document.all(yy);
 varElem.style.visibility='hidden'
}
function SavedRetailCarts(x){
 var ElemX=(isW3C) ? document.getElementById('SavedRetailCartEmail'):document.all('SavedRetailCartEmail');
 ElemX.value=x
 document.PU.submit()
}
function SavedRetailCartsInput(){
 var ElemX=(isW3C) ? document.getElementById('SavedRetailCartEmail'):document.all('SavedRetailCartEmail');
 var ElemInput=(isW3C) ? document.getElementById('EmailInputForSavedRetailCart'):document.all('EmailInputForSavedRetailCart');
 if(ElemInput.value==''){
  alert('Please enter the E-mail you want to check.')
  return
 }
 ElemX.value=ElemInput.value
 document.PU.submit()
}
function fovs(a,q){
 a.src = '<%=AssetsPath()%>/' + q + "l.gif"
}
function fous(a,q){
 a.src = '<%=AssetsPath()%>/' + q + ".gif"
}
function fov(a,q){
 a.src = '<%=AssetsPath()%>/' + q + "h.gif"
}
function fou(a,q){
 a.src = '<%=AssetsPath()%>/' + q + ".gif"
}

function CountryChanged(){
 VS=0
 document.PU.CountryChangedTxt.value='yes'
 document.PU.submit()
}
function BillingCountryChanged(){
 VS=0
 document.PU.BillingCountryChangedTxt.value='yes'
 document.PU.submit()
}
function Validation(x){
 if (VS==1){
  return true
 }
 else if (VS==0){
  return false
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
function SubmitFcn() {
 VS=1
 document.PU.submit()
}
function sameAsShipping(){
 elemS=document.getElementById('Country')
 elemB=document.getElementById('BillingCountry')
 if (elemS.value != elemB.value){
  alert('Please change your "Billing Country" to '+ elemS.value + ' before clicking the "Same As Shipping" button.  Thank you.')
  return
 }
 elemS=document.getElementById('FullName')
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
 elemS=document.getElementById('StoreName')
 elemB=document.getElementById('BillingStoreName')
 if (elemS){
  elemB.value=elemS.value
 }
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
 elemS=document.getElementById('Country')
 elemB=document.getElementById('BillingCountry')
 elemB.value=elemS.value
 sch()
}
function sch(){
 elem = document.getElementById('dontforgetdiv')
 elem.style.visibility="visible"
 elem2 = document.getElementById('divChangesSaved')
 elem2.style.visibility = "hidden"
 elem2.style.display = "none"
 elem3 = document.getElementById('divChangesSavedCC')
 elem3.style.visibility = "hidden"
 elem3.style.display = "none"

 elem.style.display="inline"
}
function EditCCNumber(OrderProcessChoice, ccnumber, cvv2, expmonth, expyear, intN, intCCCounter) {
 varCreditCardDiv = document.getElementById('CreditCardDiv')
 varCreditCardDiv.style.display = "inline"
 varCreditCardDiv.style.visibility = "visible"
 varCreditCardDiv = intCCCounter
 document.getElementById('CCNumber').value = ccnumber
 document.getElementById('txtCVV2').value = cvv2
 document.getElementById('ExpMonth').value = expmonth
 document.getElementById('ExpYear').value = expyear
 document.getElementById('CCCounterTxt').value = intCCCounter
}
function AddNewCard() {
 varElemCCCounter = document.getElementById('CCCounterTxt')
 varCreditCardDiv = document.getElementById('CreditCardDiv')
 varCreditCardDiv.style.display = "inline"
 varCreditCardDiv.style.visibility = "visible"
 document.getElementById('CCNumber').value = ""
 document.getElementById('txtCVV2').value = ""
 document.getElementById('ExpMonth').value = ""
 document.getElementById('ExpYear').value = ""
 document.getElementById('CCCounterTxt').value = "0"
 document.getElementById('CCNumber').focus()
}
function SubmitCC() {
 elem = document.getElementById("CCNumber")
 if (elem.value == "") {
  alert('Please enter your "Credit Card Number".')
  return false
 }
 if (!checkCCNumber(elem.value)) {
  alert('Please double-check the Credit Card Number you entered.  It is coming back as an invalid number.  This typically happens when the Credit Card Number is entered incorrectly.  Thank you.')
  return false
 }
 elemM = document.getElementById("ExpMonth")
 if (elemM.value == "") {
  alert('You must enter the month of the "Expiration Date" for your credit card.  It appears you are missing the Expiration "Month"')
  return false
 }
 elemY = document.getElementById("ExpYear")
 if (elemY.value == "") {
  alert('You must enter the year of the "Expiration Date" for your credit card.  It appears you are missing the Expiration "Year"')
  return false
 }
 if (elemY.value == new Date().getFullYear()) {
  monthselected = elemM.value.substr(0, 2)
  if (monthselected.substr(0, 1) == "0") {
   monthselected = monthselected.substr(1, 1)
  }
  if (parseInt(monthselected) <= parseInt(new Date().getMonth())) {
   elemM.focus()
   alert('The "Expiration Date" entered is in the past.  Please enter a valid "Expiration Date".')
   document.getElementById('CreditCardDiv').style.visibility = "visible"
   return false
  }
 }
 elem = document.getElementById("txtCVV2")
 if (elem.value == "") {
  alert('You must enter the 3 or 4 digit security code (CVV2) that is printed on your credit card. For American Express, this is a 4 digit code that is printed on the front of your credit card just above the credit card number.  For all other credit cards, it is the last 3 digits of the number that is printed on the signature panel on the back of your credit card.')
  return false
 }
 if (elem.value.length != 3 && elem.value.length != 4) {
  elem.focus()
  alert('You must enter the 3 or 4 digit security code (CVV2) that is printed on your credit card. For American Express, this is a 4 digit code that is printed on the front of your credit card just above the credit card number.  For all other credit cards, it is the last 3 digits of the number that is printed on the signature panel on the back of your credit card.')
  return false
 }
 if (isNaN(elem.value)) {
  elem.focus()
  alert('You must enter the 3 or 4 digit security code (CVV2) that is printed on your credit card. For American Express, this is a 4 digit code that is printed on the front of your credit card just above the credit card number.  For all other credit cards, it is the last 3 digits of the number that is printed on the signature panel on the back of your credit card.')
  return false
 }
 document.frmCreditCards.submit()
}
function checkCCNumber(CCNumber) {
 if (CCNumber.length < 13) {
  return false
 } else {
  return true
 }
}

function showCVV2HelpDiv() {
 elem = (isW3C) ? document.getElementById("divCVV2Help") : (document.all("divCVV2Help"));
 elem2 = (isW3C) ? document.getElementById("txtCVV2") : (document.all("txtCVV2"));
 elem.style.display = "inline"
 elem.style.visibility = "visible"
 elem2.focus()
}
function hideCVV2HelpDiv() {
 elem = (isW3C) ? document.getElementById("divCVV2Help") : (document.all("divCVV2Help"));
 elem2 = (isW3C) ? document.getElementById("txtCVV2") : (document.all("txtCVV2"));
 elem2.focus()
 elem.style.display = "none"
 elem.style.visibility = "hidden"
}
function DeleteCard(x) {
 window.location = '/customerinfo.aspx?deletecard=' + x
}
function hideCreditCardDiv() {
 elem = (isW3C) ? document.getElementById("CreditCardDiv") : (document.all("CreditCardDiv"));
 elem2 = (isW3C) ? document.getElementById("divCVV2Help") : (document.all("divCVV2Help"));
 elem.style.display = "none"
 elem.style.visibility = "hidden"
 elem2.style.display = "none"
 elem2.style.visibility = "hidden"
}

</script>

<% If Session("PowerUserName") <> "" Then%>
 <script type="text/javascript" src="/JS38/ELC.js?x=5"></script>
<%end if%>

<style type="text/css">
 P {font-family:arial,verdana,helvetica,sans-serif;font-size:12px;color:#000000;display:inline}
 p.pow {font-family:arial,verdana,helvetica;font-size:12px;color:#ffffff;background-color:#566BEC;min-height:20px;padding-bottom:2px;cursor:pointer}
 p.redo {font-size:13px;color:#ff0000;background-color:#ffff00}
 p.title {font-family:arial,verdana,helvetica,sans-serif;font-size:18px;color:#3F3F3F;font-weight:600}
 p.p-title-2 {font-size:20px;color:#000000;font-weight:600}
 p.use-card {font-size:20px;color:#000000;vertical-align:middle}
 p.add-card {font-weight:600;font-size:19px;color:#1B67B7;vertical-align:middle;cursor:pointer;text-decoration:underline}
 p.delete-card {font-size:12px;color:#333333;vertical-align:middle;text-decoration:underline;cursor:pointer}
 input {font-family:arial,verdana,helvetica}
  .i {color:#000000;background-color:#FFFFFF;font-size:14px;border-radius:8px;border:1px solid #96A496;height:27px;width:250;margin-left:7px;padding-left:6px}
  .input-1 {font-size:14px;text-align:left;vertical-align:middle;border:0px;color:#000000;outline:none}
 font {font-family:arial,verdanal,helvetica}
  .a {font-size:14px;color:#000000}
  .a-credit-card {font-weight:0;font-size:12px;color:000000}
  .b {font-size:14px;background-color:#FFFF00;color:#FF0000}
  .c {font-size:11px;color:#000000}
  .d {font-size:11px;color:#000000}
  .e {font-weight:600;font-size:13px;background-color:#E15677;color:#FFFFFF}
  .h {font-weight:600;background-color:#647864;font-size:14px;color:#FFFFFF;padding-top:2px;padding-bottom:1px}
  .j {font-size:13px;color:#000000}
  .k {font-weight:600;text-decoration:underline;font-size:14px;color:#2A4029;padding-top:2px;padding-bottom:1px}
 div {}
  .q {position:absolute;left:62%;width:35%;background-color:#F5D7A0;padding:8;visibility:hidden;font: 12px verdana;border-style:solid;border-color:#D69669;border-width:4px;border-style:ridge}
  .s {text-align:left;position:absolute;width:280;background-color:#F5D7A0;padding:8;padding-top:12px;padding-bottom:12px;visibility:hidden;font: 12px verdana;border-style:solid;border-color:#D69669;border-width:4px;border-style:ridge}
 ul {}
 .ul-redo {font-family:arial,verdana,helvetica,sans-serif;font-size:14px;color:#ff0000;background-color:#ffff00}
 
 
</style>

</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="BodyContent" runat="server">

<% log_request(Request) %>

<%
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
  strPageTitle = " Millions Of Records | Customer Profile"
 End If
 Page.Title = strPageTitle

 Dim strConnectionStringName As String = Master.ConnectionStringName

 Dim varServerCounter As String = ""
 Dim NameOfCart As String = Master.CartName
 Dim varPriceGroup As String = Master.PriceGroup
 Dim varServerCounter As String = ""
 'BroadcastLinkURL Variable
 Dim varBroadcastLinkURL As String = ""
 If Request("BroadcastLinkURL") <> "" Then
  varBroadcastLinkURL = Request("BroadcastLinkURL")
 Else
  varBroadcastLinkURL = ""
 End If

 'Credit Card Variables
 Dim intN As Integer = 0
 Dim strPreviousCCNumber As String = ""
 Dim strPreviousCVV2 As String = ""
 Dim strPreviousExpMonth As String = ""
 Dim strPreviousExpYear As String = ""
 Dim intCCCounter As Integer = 0
 Dim DefaultCCCounter As String = "0"
 Dim varVisible As String = ""
 Dim defaultExpMonth As String = ""
 Dim defaultExpYear As String = ""
 Dim DefaultCCNumber As String = "0"
 Dim DefaultCVV2Number As String = ""
 Dim strDeletedCard As String = ""
 Dim strCreditCardNumberForDisplay As String = ""
 Dim strHeightOfAddCardTD As String = ""
 Dim strBodyForCC As String = ""

 'Add or Edit Credit Card Number
 If Request("FromCreditCardsForm") = "yes" Then
  DefaultCCNumber = Request("CCNumber")
  defaultExpMonth = Request("ExpMonth")
  defaultExpYear = Request("ExpYear")
  DefaultCVV2Number = Request("txtCVV2")
  DefaultCCCounter = Request("CCCounterTxt")

  'Get CC Number for Edit CC Number
  If (InStr(DefaultCCNumber, "x") > 0 Or InStr(DefaultCCNumber, "X") > 0) And DefaultCCCounter > 0 Then
   Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
    SqlConnection.ClearPool(conn)
    conn.Open()
    Dim CMD_X As New SqlCommand("spDecryptPreviousCreditCardUsed", conn)
    CMD_X.CommandType = Data.CommandType.StoredProcedure
    CMD_X.Parameters.AddWithValue("@counter", DefaultCCCounter)
    CMD_X.Parameters.AddWithValue("@EncryptionKey", ConfigurationManager.AppSettings("EncryptionKey").ToString)
    Dim xx As SqlDataReader
    xx = CMD_X.ExecuteReader
    If xx.HasRows Then
     xx.Read()
     DefaultCCNumber = xx("CCNumber")
    End If
   End Using
  End If

  Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
   SqlConnection.ClearPool(conn)
   conn.Open()
   Dim CMD_X As New SqlCommand("spInsertCreditCards", conn)
   CMD_X.CommandType = Data.CommandType.StoredProcedure
   CMD_X.Parameters.AddWithValue("@ExpirationDate", Left(defaultExpMonth, 2) & Right(defaultExpYear, 2))
   CMD_X.Parameters.AddWithValue("@RightFour", Right(Replace(DefaultCCNumber, " ", ""), 4))
   CMD_X.Parameters.AddWithValue("@Account", Replace(DefaultCCNumber, " ", ""))
   CMD_X.Parameters.AddWithValue("@CVV2", DefaultCVV2Number)
   CMD_X.Parameters.AddWithValue("@CustomerServerCounter", Session("CustomerServerCounter"))
   CMD_X.Parameters.AddWithValue("@WebOrderNumber", DBNull.Value)
   CMD_X.Parameters.AddWithValue("@EncryptionKey", ConfigurationManager.AppSettings("EncryptionKey").ToString)
   CMD_X.ExecuteNonQuery()
  End Using

  Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
   SqlConnection.ClearPool(conn)
   conn.Open()
   Dim CMD_X As New SqlCommand("spGetCustomerDetailsByServerCounter", conn)
   CMD_X.CommandType = Data.CommandType.StoredProcedure
   CMD_X.Parameters.AddWithValue("@counter", Session("CustomerServerCounter"))
   Dim xx As SqlDataReader
   xx = CMD_X.ExecuteReader
   If xx.HasRows Then
    xx.Read()
    strBodyForCC = "Credit card added/edited on website"
    strBodyForCC = strBodyForCC & vbCrLf & "Customer ID: " & Session("CustomerID")
    strBodyForCC = strBodyForCC & vbCrLf & "Last 4: " & Right(Replace(DefaultCCNumber, " ", ""), 4)
    strBodyForCC = strBodyForCC & vbCrLf & "BILL TO:"
    strBodyForCC = strBodyForCC & vbCrLf & xx("BillingFullName")
    strBodyForCC = strBodyForCC & vbCrLf & xx("BillingStreetAddress1")
    If IsDBSomething(xx("BillingStreetAddress2"), "") <> "" Then
     strBodyForCC = strBodyForCC & vbCrLf & xx("BillingStreetAddress2")
    End If
    If IsDBSomething(xx("BillingCity"), "") <> "" Then
     strBodyForCC = strBodyForCC & vbCrLf & xx("BillingCity")
    End If
    If IsDBSomething(xx("BillingStateProvince"), "") <> "" Then
     strBodyForCC = strBodyForCC & vbCrLf & xx("BillingStateProvince")
    End If
    If IsDBSomething(xx("BillingPostalCode"), "") <> "" Then
     strBodyForCC = strBodyForCC & vbCrLf & xx("BillingPostalCode")
    End If
    If IsDBSomething(xx("BillingCountry"), "") <> "" Then
     strBodyForCC = strBodyForCC & vbCrLf & xx("BillingCountry")
    End If
    strBodyForCC = strBodyForCC & vbCrLf & "SHIP TO:"
    strBodyForCC = strBodyForCC & vbCrLf & xx("FullName")
    strBodyForCC = strBodyForCC & vbCrLf & xx("StreetAddress1")
    If IsDBSomething(xx("StreetAddress2"), "") <> "" Then
     strBodyForCC = strBodyForCC & vbCrLf & xx("StreetAddress2")
    End If
    If IsDBSomething(xx("City"), "") <> "" Then
     strBodyForCC = strBodyForCC & vbCrLf & xx("City")
    End If
    If IsDBSomething(xx("StateProvince"), "") <> "" Then
     strBodyForCC = strBodyForCC & vbCrLf & xx("StateProvince")
    End If
    If IsDBSomething(xx("PostalCode"), "") <> "" Then
     strBodyForCC = strBodyForCC & vbCrLf & xx("PostalCode")
    End If
    If IsDBSomething(xx("Country"), "") <> "" Then
     strBodyForCC = strBodyForCC & vbCrLf & xx("Country")
    End If
    strBodyForCC = strBodyForCC & vbCrLf & "Email Address: " & xx("Email")
    'subSendEmail("ernie@millionsofrecords.com", "ernieb12345@gmail.com", "ZWEB - Card Added " & Session("StoreName"), strBodyForCC, 1, 0, strConnectionStringName)
   End If
  End Using
 End If


 'Delete Credit Card
 If Request.QueryString("deletecard") <> "" Then
  If IsNumeric(Request.QueryString("deletecard")) Then
   If Len(Request.QueryString("deletecard")) = 4 Then
    Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
     SqlConnection.ClearPool(conn)
     conn.Open()
     Dim CMD_X As New SqlCommand("spDeleteCreditCard", conn)
     CMD_X.CommandType = Data.CommandType.StoredProcedure
     CMD_X.Parameters.AddWithValue("@RightFour", Request.QueryString("deletecard"))
     CMD_X.Parameters.AddWithValue("@CustomerServerCounter", Session("CustomerServerCounter"))
     CMD_X.ExecuteNonQuery()
     strDeletedCard = "yes"
    End Using
   End If
  End If
 End If

 'Variables
 Dim varReturnToPurchase As String = ""
 If Request.QueryString("ReturnToPurchase") = "y" Or Request("ReturnToPurchase1") = "y" Or Request("ReturnToPurchase2") = "y" Or Request("ReturnToPurchase3") = "y" Then
  varReturnToPurchase = "y"
 End If

 Dim strCurrentEmail As String = ""
 Dim intCustomerIDForEmailChange As Integer = 0
 Dim strRememberMe As String = ""
 Dim strRememberMeQueryString As String = ""
 Dim strRememberMeSignIn As String = ""
 Dim strRememberMeSignInQueryString As String = ""

 Dim varNameOfCart As String = ""

 Dim xxPassword As String = ""
 Dim xxLogInEmail As String = ""
 Dim xxFullName As String = ""
 Dim xxPriceGroup As String = ""
 Dim xxCity As String = ""
 Dim xxCounter As Integer = 0
 Dim xxSuperPowerUserName As String = ""
 Dim xxPowerUserName As String = ""
 Dim xxCustomerID As String = ""
 Dim xxCountry As String = ""
 Dim xxPostalCode As String = ""
 Dim xxBillingCountry As String = ""
 Dim xxBillingPostalCode As String = ""
 Dim xxMinimumOrder As String = ""
 Dim xxResidentialDelivery As String = ""
 Dim strXXHasRows As Integer = 0
 Dim strXXLogInEmailExists As Integer = 0
 Dim strPasswordFromCustomersTable As String = ""
 Dim strBody As String = ""
 Dim strSubject As String = ""
 Dim strCustomerNameFromCustomersTable As String = ""
 Dim varSaleItem As Integer = 0
 Dim WholesalePrice As Double = 0
 Dim defaultCountry As String = ""
 Dim defaultPostalCode As String = ""
 Dim divChangesMadeVisibility As String = "hidden"
 Dim divChangesMadeDisplay As String = "none"
 Dim divChangesMadeVisibilityCC As String = "hidden"
 Dim divChangesMadeDisplayCC As String = "none"


 'Remove Payment Method
 If Session("PowerUserName") <> "" And Request.QueryString("rpm") <> "" And Session("CustomerID") <> "" Then
  If IsNumeric(Session("CustomerID")) Then
   Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
    SqlConnection.ClearPool(conn)
    conn.Open()
    Dim CMD_xx As New SqlCommand("spRemovePaymentMethod", conn)
    CMD_xx.CommandType = Data.CommandType.StoredProcedure
    CMD_xx.Parameters.AddWithValue("@CustomerID", Session("CustomerID"))
    CMD_xx.Parameters.AddWithValue("@Type", Request.QueryString("rpm"))
    CMD_xx.ExecuteNonQuery()
   End Using
  End If
 End If
 'Add Payment Method
 If Session("PowerUserName") <> "" And Request.QueryString("apm") <> "" And Session("CustomerID") <> "" Then
  If IsNumeric(Session("CustomerID")) Then
   Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
    SqlConnection.ClearPool(conn)
    conn.Open()
    Dim CMD_xx As New SqlCommand("spAddPaymentMethod", conn)
    CMD_xx.CommandType = Data.CommandType.StoredProcedure
    CMD_xx.Parameters.AddWithValue("@CustomerID", Session("CustomerID"))
    CMD_xx.Parameters.AddWithValue("@Type", Request.QueryString("apm"))
    CMD_xx.ExecuteNonQuery()
   End Using
  End If
 End If

 'Sign In Customer-----------------------------------------------------------------------------------
 If (Request("FromOptionsCustomerID") = "yes") Or (Request("InsertTagCustomerCounter") <> "" And Session("PowerUserName") <> "") Then
  If Request("FromOptionsCustomerID") = "yes" Then
   strRememberMeSignIn = Left(Request("txtRememberMeSignIn"), 1)
   If strRememberMeSignIn = "y" Then
    strRememberMeSignInQueryString = "&RM=y"
    Response.Cookies("RememberMeSignIn").Value = Request("LogInEmail")
    Response.Cookies("RememberMeSignIn").Domain = "millionsofrecords.com"
    Response.Cookies("RememberMeSignIn").Path = "/"
    Response.Cookies("RememberMeSignIn").Expires = Date.Now.AddDays(3)
   Else
    strRememberMeSignInQueryString = "&RM=n"
    Response.Cookies("RememberMeSignIn").Value = "no"
    Response.Cookies("RememberMeSignIn").Domain = "millionsofrecords.com"
    Response.Cookies("RememberMeSignIn").Path = "/"
    Response.Cookies("RememberMeSignIn").Expires = Date.Now.AddDays(3)
   End If
  End If
  'Company Sign In
  If Request("LogInEmail") = "@." And UCase(Request("Pword")) = "AMESSAGE3921" Then
   Session("EditAMessageFromErnieOK") = "yes"
   Response.Redirect("/AMessageFromErnie.aspx")
  ElseIf Request("LogInEmail") = "@." And UCase(Request("Pword")) = "SCANS3921" Then
   Session("ScansCheckOK") = "yes"
   Response.Redirect("/ScansCheck.aspx")
  End If
  'Find Customer
  Dim varLogInEmailMaster As String = ""
  Dim varPasswordMaster As String = ""
  Dim strCustomerSP As String = ""
  Dim varInsertTagCustomerCounter As Integer = 0
  If Request("FromOptionsCustomerID") = "yes" Then
   varLogInEmailMaster = Replace(Request("LogInEmail"), " ", "")
   varPasswordMaster = Replace(Request("Pword"), " ", "")
   strCustomerSP = "spGetCustomerDetails"
  Else
   varInsertTagCustomerCounter = Request("InsertTagCustomerCounter")
   If Not IsNumeric(varInsertTagCustomerCounter) Then varInsertTagCustomerCounter = 0
   strCustomerSP = "spGetCustomerDetailsByServerCounter"
  End If
  Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
   SqlConnection.ClearPool(conn)
   conn.Open()
   Dim CMD_xx As New SqlCommand(strCustomerSP, conn)
   CMD_xx.CommandType = Data.CommandType.StoredProcedure
   If Request("FromOptionsCustomerID") = "yes" Then
    CMD_xx.Parameters.AddWithValue("@LogInEmail", varLogInEmailMaster)
    CMD_xx.Parameters.AddWithValue("@Password", varPasswordMaster)
   Else
    CMD_xx.Parameters.AddWithValue("@counter", varInsertTagCustomerCounter)
   End If
   Dim readerXX As SqlDataReader
   readerXX = CMD_xx.ExecuteReader
   If readerXX.HasRows Then
    strXXHasRows = 1
    readerXX.Read()
    varNameOfCart = "W_CART_" & readerXX("counter")
    xxPassword = IsDBSomething(readerXX("Password"), "")
    xxLogInEmail = IsDBSomething(readerXX("LogInEmail"), "")
    xxFullName = IsDBSomething(readerXX("FullName"), "")
    xxPriceGroup = IsDBSomething(readerXX("PriceGroup"), "")
    xxCity = IsDBSomething(readerXX("City"), "")
    xxCounter = IsDBSomething(readerXX("Counter"), 0)
    xxSuperPowerUserName = IsDBSomething(readerXX("SuperPowerUserName"), "")
    xxPowerUserName = IsDBSomething(readerXX("PowerUserName"), "")
    xxCustomerID = IsDBSomething(readerXX("CustomerID"), "")
    xxCountry = IsDBSomething(readerXX("Country"), "")
    xxPostalCode = IsDBSomething(readerXX("PostalCode"), "")
    xxBillingCountry = IsDBSomething(readerXX("BillingCountry"), "")
    xxBillingPostalCode = IsDBSomething(readerXX("BillingPostalCode"), "")
    xxMinimumOrder = IsDBSomething(readerXX("MinimumOrder"), 0)
    xxResidentialDelivery = IsDBSomething(readerXX("ResidentialDelivery"), "")
    'Record Successful LogOn Attempt
    Dim varCartQuantity As Integer = 0
    Using conn2 As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
     SqlConnection.ClearPool(conn2)
     conn2.Open()
     Dim CMD_D As New SqlCommand("CartNumberOfItems", conn2)
     CMD_D.CommandType = Data.CommandType.StoredProcedure
     CMD_D.Parameters.AddWithValue("@Cartname", IsDBSomething(varNameOfCart, "z"))
     varCartQuantity = IsDBSomething(CMD_D.ExecuteScalar(), 0)
    End Using

    Using conn2 As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
     SqlConnection.ClearPool(conn2)
     conn2.Open()
     Dim CMD_D As New SqlCommand("spInsertStoreLogOnAccessedSuccessful", conn2)
     CMD_D.CommandType = Data.CommandType.StoredProcedure
     CMD_D.Parameters.AddWithValue("@DateTime", Date.Now)
     CMD_D.Parameters.AddWithValue("@IPAddress", IsSomething(Left(Request.ServerVariables("HTTP_X_FORWARDED_FOR"), 50), DBNull.Value))
     CMD_D.Parameters.AddWithValue("@LoggedOnSuccessful", "yes")
     CMD_D.Parameters.AddWithValue("@CartQuantity", varCartQuantity)
     CMD_D.Parameters.AddWithValue("@Password", IsSomething(Request("Pword"), DBNull.Value))
     CMD_D.Parameters.AddWithValue("@LogInEmail", IsSomething(Request("LogInEmail"), DBNull.Value))
     CMD_D.Parameters.AddWithValue("@PowerUserName", IsSomething(Session("PoweruserName"), DBNull.Value))
     CMD_D.Parameters.AddWithValue("@Storename", IsSomething(xxFullName, DBNull.Value))
     CMD_D.Parameters.AddWithValue("@PriceGroup", IsSomething(xxPriceGroup, DBNull.Value))
     CMD_D.Parameters.AddWithValue("@City", IsSomething(xxCity, DBNull.Value))
     CMD_D.Parameters.AddWithValue("@CustomerServerCounter", xxCounter)
     CMD_D.ExecuteNonQuery()
    End Using
   Else
    strXXHasRows = 0
    'Check for LogInEmail exists
    Using conn11 As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
     SqlConnection.ClearPool(conn11)
     conn11.Open()
     Dim CMD_xxL As New SqlCommand("spCheckLogInEmailExists", conn11)
     CMD_xxL.CommandType = Data.CommandType.StoredProcedure
     CMD_xxL.Parameters.AddWithValue("@LogInEmail", varLogInEmailMaster)
     Dim readerXXL As SqlDataReader
     readerXXL = CMD_xxL.ExecuteReader
     If readerXXL.HasRows Then
      strXXLogInEmailExists = 1
      readerXXL.Read()
      strPasswordFromCustomersTable = readerXXL("Password")
      strCustomerNameFromCustomersTable = readerXXL("FullName")
     Else
      strXXLogInEmailExists = 0
     End If
    End Using
    'Record Unsuccessful LogOn Attempt
    Using conn2 As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
     SqlConnection.ClearPool(conn2)
     conn2.Open()
     Dim CMD_D As New SqlCommand("spInsertStoreLogOnAccessedUnsuccessful", conn2)
     CMD_D.CommandType = Data.CommandType.StoredProcedure
     CMD_D.Parameters.AddWithValue("@DateTime", Date.Now)
     CMD_D.Parameters.AddWithValue("@IPAddress", Request.ServerVariables("HTTP_X_FORWARDED_FOR"))
     CMD_D.Parameters.AddWithValue("@LoggedOnSuccessful", "no")
     CMD_D.Parameters.AddWithValue("@Password", IsSomething(Request("Pword"), DBNull.Value))
     CMD_D.Parameters.AddWithValue("@LogInEmail", IsSomething(Request("LogInEmail"), DBNull.Value))
     CMD_D.Parameters.AddWithValue("@PowerUserName", IsSomething(Session("PoweruserName"), DBNull.Value))
     CMD_D.ExecuteNonQuery()
    End Using
   End If
  End Using

  'Redirect for failed log on
  If strXXHasRows = 0 Then
   Session("SignInFailedLogInEmail") = Request("LogInEmail")
   If strXXLogInEmailExists = 1 Then
    strSubject = "Millions Of Records Sign-In Password"
    strBody = "Hello " & strCustomerNameFromCustomersTable & ","
    strBody = strBody & vbCrLf & vbCrLf & "Here are your sign-in credentials:"
    strBody = strBody & vbCrLf & "Email: " & varLogInEmailMaster
    strBody = strBody & vbCrLf & "Password: " & strPasswordFromCustomersTable
    strBody = strBody & vbCrLf & vbCrLf & "Note: After you sign in, if you would like to change your email and/or your password then please go to the My Account page."
    strBody = strBody & vbCrLf & vbCrLf & "Click here to sign in: https://millionsofrecords.com/Options.aspx"
    strBody = strBody & vbCrLf & vbCrLf & "If you don't wish to click the link above, then simply go to www.millionsofrecords.com and sign in with your password above."
    strBody = strBody & vbCrLf & vbCrLf & "Sincerely,"
    strBody = strBody & vbCrLf & vbCrLf & "Customer Service"
    strBody = strBody & Z_EmailFooter(strConnectionStringName)
    'E-mail It
    subSendEmail("ernie@millionsofrecords.com", Request("LogInEmail"), strSubject, strBody, 1, 0, strConnectionStringName)
    Response.Redirect("/Options.aspx?BI=y&LE=y&CC=" & Request("CC") & strRememberMeSignInQueryString)
   Else
    Response.Redirect("/Options.aspx?BI=y&CC=" & Request("CC") & strRememberMeSignInQueryString)
   End If
   'Successful log on----------------------------------------------------------------
  Else
   'PowerUser
   If Len(xxSuperPowerUserName) > 0 Or Len(xxPowerUserName) > 0 Then
    If xxSuperPowerUserName <> "" Then
     Session("SuperPowerUserName") = xxSuperPowerUserName
    End If
    Session("PowerUserName") = xxPowerUserName
    Response.Cookies("SD7").Value = "n"
    Response.Cookies("SD7").Path = "/"
    Session("PriceGroup") = ""
    If Session("CustomerID") = "" Then
     Session("CustomerID") = xxCustomerID
     Session("CustomerServerCounter") = xxCounter.ToString
    End If
    If Session("Country") = "" Then
     Session("Country") = xxCountry
     Session("PostalCode") = xxPostalCode
    End If
    If Session("BillingCountry") = "" Then
     Session("BillingCountry") = xxBillingCountry
     Session("BillingPostalCode") = xxBillingPostalCode
    End If

    Using conn2 As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
     SqlConnection.ClearPool(conn2)
     conn2.Open()
     Dim CMD_D As New SqlCommand("spInsertPowerUserLogOns", conn2)
     CMD_D.CommandType = Data.CommandType.StoredProcedure
     CMD_D.Parameters.AddWithValue("@DateTime", Date.Now)
     CMD_D.Parameters.AddWithValue("@IPAddress", Request.ServerVariables("HTTP_X_FORWARDED_FOR"))
     CMD_D.Parameters.AddWithValue("@Password", IsDBSomething(Request("Pword"), DBNull.Value))
     CMD_D.Parameters.AddWithValue("@PowerUserName", IsDBSomething(Session("PoweruserName"), DBNull.Value))
     CMD_D.ExecuteNonQuery()
    End Using

    Response.Redirect("/Wholesale.aspx")
    'Non-PowerUser
   Else
    Session("PriceGroup") = xxPriceGroup
    Session("CustomerServerCounter") = xxCounter.ToString
    Session("CustomerID") = xxCustomerID
    Session("LogInEmailMaster") = xxLogInEmail
    Session("PasswordMaster") = xxPassword
    Session("Country") = xxCountry
    Session("PostalCode") = xxPostalCode
    Session("BillingCountry") = xxBillingCountry
    Session("BillingPostalCode") = xxBillingPostalCode
    Session("StoreName") = FigureCustomerName(xxFullName)
    Session("ShippingCartCountry") = xxCountry
    Session("PostalCodeHelpShipping") = ""
    'Update DateOfLastLogin, TotalSignIns fields in Customers table
    If Session("PowerUserName") = "" And Request.ServerVariables("HTTP_X_FORWARDED_FOR") <> "104.53.90.206" Then
     Using conn2 As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
      SqlConnection.ClearPool(conn2)
      conn2.Open()
      Dim CMD_D As New SqlCommand("spUpdateCustomerDateOfLastLogin", conn2)
      CMD_D.CommandType = Data.CommandType.StoredProcedure
      CMD_D.Parameters.AddWithValue("@counter", xxCounter)
      CMD_D.ExecuteNonQuery()
      Dim CMD_TS As New SqlCommand("spUpdateCustomerTotalSignIns", conn2)
      CMD_TS.CommandType = Data.CommandType.StoredProcedure
      CMD_TS.Parameters.AddWithValue("@counter", xxCounter)
      CMD_TS.ExecuteNonQuery()
     End Using

    End If
    'Shipping Cart variables
    Dim varZip3 As String = ""
    Dim varStateProvince As String = ""
    Using conn2 As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
     SqlConnection.ClearPool(conn2)
     conn2.Open()
     Dim CMD_o As New SqlCommand("spGetOrdersByCustomerServerCounter", conn2)
     CMD_o.CommandType = Data.CommandType.StoredProcedure
     CMD_o.Parameters.AddWithValue("@counter", xxCounter)
     Dim readerO As SqlDataReader
     readerO = CMD_o.ExecuteReader
     If readerO.HasRows Then
      readerO.Read()
      'Session("ShippingCartShippingMethod") = readerO("ShippingMethod")
      Session("ShippingCartShippingMethod") = ""
      If Len(Session("ShippingCartShippingMethod")) = 0 Then Session("ShippingCartShippingMethod") = ""
      If Session("ShippingCartShippingMethod") <> "" Then
       defaultCountry = Session("Country")
       defaultPostalCode = Session("PostalCode")
       If Len(defaultPostalCode) > 5 And Session("Country") = "USA" Then
        defaultPostalCode = Left(defaultPostalCode, 5)
       End If
       varZip3 = Session("PostalCode")
       If Len(Session("PostalCode")) >= 3 And Session("Country") = "USA" Then
        varZip3 = Left(Session("PostalCode"), 3)
       End If
       varStateProvince = ""
       If Session("Country") = "USA" Then
        varStateProvince = Z_SHIPX_FigureStateProvinceFromZipCode(defaultPostalCode)
       End If
       Select Case Session("ShippingCartShippingMethod")
        Case "UPSGR"
         Session("ShippingCartZone") = Z_SHIPX_FigureUPSGroundZone(defaultCountry, defaultPostalCode, varStateProvince)
        Case "FEGR"
         Session("ShippingCartZone") = Z_SHIPX_FigureUPSGroundZone(defaultCountry, defaultPostalCode, varStateProvince)
        Case "MM"
         Session("ShippingCartZone") = Z_SHIPX_FigureMediaMailZone(defaultCountry, varStateProvince, "ExportPrice", varZip3)
        Case "PM"
         Session("ShippingCartZone") = Z_SHIPX_FigurePriorityMailZone(defaultCountry, varZip3)
        Case "EMP"
         Session("ShippingCartZone") = Z_SHIPX_FigureExpressMailZone(defaultCountry, varStateProvince, varPriceGroup, varZip3)
        Case "EMA"
         Session("ShippingCartZone") = Z_SHIPX_FigureExpressMailZone(defaultCountry, varStateProvince, varPriceGroup, varZip3)
        Case "ALP"
         Session("ShippingCartZone") = Z_SHIPX_FigureAirMailLetterPostZone(defaultCountry, strConnectionStringName)
        Case "APP"
         Session("ShippingCartZone") = Z_SHIPX_FigureAirParcelPostZone(defaultCountry, strConnectionStringName)
        Case "GE"
         Session("ShippingCartZone") = Z_SHIPX_FigureGlobalExpressZone(defaultCountry, strConnectionStringName)
        Case "FE2D"
         Session("ShippingCartZone") = Z_SHIPX_FigureFedExExpressZone(defaultCountry, defaultPostalCode, varStateProvince)
        Case "FEES"
         Session("ShippingCartZone") = Z_SHIPX_FigureFedExExpressZone(defaultCountry, defaultPostalCode, varStateProvince)
        Case "FEPO"
         Session("ShippingCartZone") = Z_SHIPX_FigureFedExExpressZone(defaultCountry, defaultPostalCode, varStateProvince)
        Case "FESO"
         Session("ShippingCartZone") = Z_SHIPX_FigureFedExExpressZone(defaultCountry, defaultPostalCode, varStateProvince)
        Case "FEPOSAT"
         Session("ShippingCartZone") = Z_SHIPX_FigureFedExExpressZone(defaultCountry, defaultPostalCode, varStateProvince)
        Case "FESOSAT"
         Session("ShippingCartZone") = Z_SHIPX_FigureFedExExpressZone(defaultCountry, defaultPostalCode, varStateProvince)
        Case "FEINTP"
         Session("ShippingCartZone") = Z_SHIPX_FigureFedExInternationalPriorityZone(defaultCountry, varZip3, strConnectionStringName)
        Case "FEINTE"
         Session("ShippingCartZone") = Z_SHIPX_FigureFedExInternationalEconomyZone(defaultCountry, varZip3, strConnectionStringName)
        Case Else
         Session("ShippingCartZone") = "NA"
       End Select
       If Session("ShippingCartZone") = "NA" Or Session("ShippingCartZone") = "" Then
        Session("ShippingCartZone") = ""
        Session("ShippingCartShippingMethod") = ""
       End If
      End If
     Else
      Session("ShippingCartShippingMethod") = ""
      Session("ShippingCartZone") = ""
      If xxResidentialDelivery = "" Then
       Session("ResidentialDelivery") = "NO"
      Else
       Session("ResidentialDelivery") = "YES"
      End If
     End If
    End Using
    Session("ShippingCartCountry") = Session("Country")
    Session("ShippingCartPostalCode") = Session("PostalCode")
    If Len(Session("ShippingCartPostalCode")) = 0 Then Session("ShippingCartPostalCode") = ""
    Session("WebOrderNumberJustPurchased") = ""
    Session("CustomerID") = IsDBSomething(Session("CustomerID"), "")
   End If

   'Empty Retail Cart Into Wholesale Cart (if not a PowerUser) 
   Dim RetailNameOfCart As String = ""
   Dim WholesaleNameOfCart As String = ""
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
          If xxPriceGroup = "StorePrice" Then
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
           If xxPriceGroup = "StorePrice" Then
            If IsDBNull(readerInv("Sale_WholesalePrice")) Then
             WholesalePrice = 0
            Else
             WholesalePrice = readerInv("Sale_WholesalePrice")
            End If
           Else
            If IsDBNull(readerInv("Sale_RetailPrice")) Then
             WholesalePrice = 0
            Else
             WholesalePrice = readerInv("Sale_RetailPrice")
            End If
           End If
          ElseIf Session("PriceGroup") = "StorePrice" Then
           WholesalePrice = readerInv("StorePrice")
          ElseIf Session("PriceGroup") = "RetailPrice" Then
           WholesalePrice = readerInv("RetailPrice")
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
   'Redirect Successful Log In
   If varBroadcastLinkURL <> "" Then
    Response.Redirect("/home.aspx?" & varBroadcastLinkURL)
   ElseIf Session("PowerUserName") <> "" Then
    If Request.QueryString("OrderSearchResultsHoldPileNumber") <> "" Then
     Response.Redirect("/CustomerOrders.aspx?OrderSearchResultsHoldPileNumber=" & Request.QueryString("OrderSearchResultsHoldPileNumber"))
    ElseIf Request.QueryString("ViewInvoices") = "yes" Then
     Response.Redirect("/CustomerOrders.aspx")
    Else
     Response.Redirect("/CustomerInfo.aspx")
    End If
   Else
    If UCase(varLogInEmailMaster) = "POTATOKID2004@GMAIL.COM" Or UCase(varLogInEmailMaster) = "KDOGROSS06@GMAIL.COM" Or UCase(varLogInEmailMaster) = "HECHARLOTTE31@GMAIL.COM" Then
     Response.Redirect("/EnterStock.aspx")
    Else
     Response.Redirect("/WholesaleAccepted.aspx")
    End If
   End If
  End If
 End If

 'Redirect to CustomerOrders.aspx if From OrderSearchResults Log In
 If Request("OrderSearchResultsHoldPileNumber") <> "" Then
  Response.Redirect("/CustomerOrders.aspx?OrderSearchResultsHoldPileNumber=" & Request("OrderSearchResultsHoldPileNumber"))
 End If

 Dim strServerCounter As String = ""

 If IsSomething(Session("CustomerServerCounter"), "") = "" Then
  strServerCounter = "0"
 Else
  strServerCounter = Session("CustomerServerCounter")
 End If

 'Check for not logged in anymore
 If strServerCounter = "0" Then
  Response.Redirect("/Options.aspx")
 End If

 'Country and Postal Code
 Dim defaultBillingCountry As String = ""
 Dim defaultBillingPostalCode As String = ""

 If Request("FromCustomerInfoPage") = "yes" Then
  defaultCountry = Request("Country")
  defaultPostalCode = Request("PostalCode")
  defaultBillingCountry = Request("BillingCountry")
  defaultBillingPostalCode = Request("BillingPostalCode")
 Else
  defaultCountry = Session("Country")
  defaultPostalCode = Session("PostalCode")
  defaultBillingCountry = Session("BillingCountry")
  defaultBillingPostalCode = Session("BillingPostalCode")
 End If
 'Customer Shipping Address Boxes to Show
 If Session("country") = "" Then
  Response.Redirect("/home.aspx")
 End If
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
  Dim CMD_Y As New SqlCommand("spGetWebCountryShippingZonesTRow", conn)
  CMD_Y.CommandType = Data.CommandType.StoredProcedure
  CMD_Y.Parameters.AddWithValue("@Country", defaultCountry)
  Dim readerY As SqlDataReader
  readerY = CMD_Y.ExecuteReader
  If readerY.HasRows Then
   readerY.Read()
   varPostalCodeRequired = readerY("PostalCodeRequired")
   varStateProvinceRequired = readerY("StateProvinceRequired")
   varCityRequired = readerY("CityRequired")
   varIslandRequired = readerY("IslandRequired")
   varStateProvinceWord = readerY("StateProvinceWord")
   varIslandWord = readerY("IslandWord")
   varPostalCodeWord = readerY("PostalCodeWord")
   varCityWord = readerY("CityWord")
   varFullPostalCodeFormat = IsDBSomething(readerY("PostalCodeFormat"), "")
  Else
   Session("Country") = ""
   varPostalCodeRequired = "y"
   varStateProvinceRequired = "o"
   varCityRequired = "y"
   varIslandRequired = "n"
   varStateProvinceWord = "State/Province"
   varIslandWord = ""
   varPostalCodeWord = "Postal Code"
   varCityWord = "City"
  End If
 End Using

 Dim varStateProvinceList As String = ""
 Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
  SqlConnection.ClearPool(conn)
  conn.Open()
  Dim CMD_Y As New SqlCommand("spGetWebCountryStateProvincesList", conn)
  CMD_Y.CommandType = Data.CommandType.StoredProcedure
  CMD_Y.Parameters.AddWithValue("@Country", defaultCountry)
  Dim readerY As SqlDataReader
  readerY = CMD_Y.ExecuteReader
  If Not readerY.HasRows Then
   varStateProvinceList = "n"
  Else
   varStateProvinceList = "y"
  End If
 End Using
 'Customer Billing Address Boxes to Show
 If Session("BillingCountry") = "" Then
  Response.Redirect("/home.aspx")
 End If
 Dim varBillingPostalCodeRequired As String = ""
 Dim varBillingStateProvinceRequired As String = ""
 Dim varBillingCityRequired As String = ""
 Dim varBillingIslandRequired As String = ""
 Dim varBillingStateProvinceWord As String = ""
 Dim varBillingIslandWord As String = ""
 Dim varBillingPostalCodeWord As String = ""
 Dim varBillingCityWord As String = ""
 Dim varBillingFullPostalCodeFormat As String = ""

 Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
  SqlConnection.ClearPool(conn)
  conn.Open()
  Dim CMD_Y As New SqlCommand("spGetWebCountryShippingZonesTRow", conn)
  CMD_Y.CommandType = Data.CommandType.StoredProcedure
  CMD_Y.Parameters.AddWithValue("@Country", defaultBillingCountry)
  Dim readerY As SqlDataReader
  readerY = CMD_Y.ExecuteReader
  If readerY.HasRows Then
   readerY.Read()
   varBillingPostalCodeRequired = readerY("PostalCodeRequired")
   varBillingStateProvinceRequired = readerY("StateProvinceRequired")
   varBillingCityRequired = readerY("CityRequired")
   varBillingIslandRequired = readerY("IslandRequired")
   varBillingStateProvinceWord = readerY("StateProvinceWord")
   varBillingIslandWord = readerY("IslandWord")
   varBillingPostalCodeWord = readerY("PostalCodeWord")
   varBillingCityWord = readerY("CityWord")
   varBillingFullPostalCodeFormat = IsDBSomething(readerY("PostalCodeFormat"), "")
  Else
   Session("BillingCountry") = ""
   varBillingPostalCodeRequired = "y"
   varBillingStateProvinceRequired = "o"
   varBillingCityRequired = "y"
   varBillingIslandRequired = "n"
   varBillingStateProvinceWord = "State/Province"
   varBillingIslandWord = ""
   varBillingPostalCodeWord = "Postal Code"
   varBillingCityWord = "City"
  End If
 End Using

 Dim varBillingStateProvinceList As String = ""
 Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
  SqlConnection.ClearPool(conn)
  conn.Open()
  Dim CMD_Y As New SqlCommand("spGetCountOfWebCountryStateProvinces", conn)
  CMD_Y.CommandType = Data.CommandType.StoredProcedure
  CMD_Y.Parameters.AddWithValue("@Country", defaultBillingCountry)
  Dim readerY As SqlDataReader
  readerY = CMD_Y.ExecuteReader
  readerY.Read()
  If readerY("ccc") = 0 Then
   varBillingStateProvinceList = "n"
  Else
   varBillingStateProvinceList = "y"
  End If
 End Using

 Dim varFromThisPage As Integer = 0
 Dim varNewReleaseYesSelected As String = ""

 'Name of Cart
 If Session("StoreName") <> "" Then
  varServerCounter = Session("CustomerServerCounter")
  NameOfCart = "W_CART_" & varServerCounter
  varPriceGroup = Session("PriceGroup")
 Else
  NameOfCart = "CART" & Session.SessionID & Session("CartRandomNumbersExtension")
  varPriceGroup = "RetailPrice"
 End If

 'CustomerID
 Dim varCustomerID As String = Session("CustomerID")
 If Not IsNumeric(varCustomerID) Then varCustomerID = ""

 'LastSearchID
 Dim varLastSearchID As String = Session.SessionID & Session("CartRandomNumbersExtension") & Session("SearchID")
 If Len(varLastSearchID) > 50 Then varLastSearchID = Left(varLastSearchID, 50)
 Dim varLastSearchIDTxt As String = Request("LastSearchIDTxt")
 If Len(varLastSearchIDTxt) > 50 Then varLastSearchIDTxt = Left(varLastSearchIDTxt, 50)

 Dim varxIPAddress As String = Request.ServerVariables("HTTP_X_FORWARDED_FOR")
 If Len(varxIPAddress) = 0 Then varxIPAddress = ""

 If Request("asppage") = "i" Then Response.Redirect("/CustomerOrders.aspx")
 If Request("asppage") = "h" Then Response.Redirect("/home.aspx")

 ' Cart Total 
 Dim CartTotal As Decimal = 0
 Dim quantitytotal As Integer = 0
 Dim strQuantityText As String = ""
 Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
  SqlConnection.ClearPool(conn)
  conn.Open()
  Dim CMD_Y As New SqlCommand("spGetCartTotals", conn)
  CMD_Y.CommandType = Data.CommandType.StoredProcedure
  CMD_Y.Parameters.AddWithValue("@CartName", NameOfCart)
  Dim readerY As SqlDataReader
  readerY = CMD_Y.ExecuteReader
  If readerY.HasRows Then
   readerY.Read()
   If IsDBNull(readerY("sumprice")) Then
    CartTotal = 0
   Else
    CartTotal = readerY("sumprice")
   End If
   If IsDBNull(readerY("sumquantity")) Then
    quantitytotal = 0
   Else
    quantitytotal = readerY("sumquantity")
   End If
  End If
 End Using
 If quantitytotal = 1 Then
  strQuantityText = " Item"
 Else
  strQuantityText = " Items"
 End If

 'Update Customer Interaction
 Dim varCIEBRep As String = Left(Request("CIEBRep"), 50)
 Dim varCICustomerRep As String = Left(Request("CICustomerRep"), 75)
 Dim varCINotes As String = Request("CINotes")
 varCustomerID = Session("CustomerID")
 Dim varCICustomerServerCounter As String = Session("CustomerServerCounter")
 If varCustomerID = "" Then varCustomerID = 0
 If Not IsNumeric(varCustomerID) Then varCustomerID = 0
 If varCICustomerServerCounter = "" Then varCICustomerServerCounter = "0"
 If Not IsNumeric(varCICustomerServerCounter) Then varCICustomerServerCounter = "0"
 Dim varCIJavascriptRandomNumber As String = Request("JavascriptRandomNumber")
 If Request("CICounter") <> "" And (IsNumeric(Request("CICounter")) Or InStr(1, Request("CICounter"), "delete") > 0) And Request("JavascriptRandomNumber") <> "" And IsNumeric(Request("JavascriptRandomNumber")) And Session("PowerUserName") <> "" And Session("CustomerServerCounter") <> "" Then
  'Insert Entry
  If Request("CICounter") = "0" Then
   Using conn2 As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
    SqlConnection.ClearPool(conn2)
    conn2.Open()
    Dim CMD_D As New SqlCommand("spInsertCustomerInteraction", conn2)
    CMD_D.CommandType = Data.CommandType.StoredProcedure
    CMD_D.Parameters.AddWithValue("@JavascriptRandomNumber", varCIJavascriptRandomNumber)
    CMD_D.Parameters.AddWithValue("@EBRep", IsDBSomething(varCIEBRep, DBNull.Value))
    CMD_D.Parameters.AddWithValue("@CustomerRep", IsDBSomething(varCICustomerRep, DBNull.Value))
    CMD_D.Parameters.AddWithValue("@Notes", IsDBSomething(varCINotes, DBNull.Value))
    CMD_D.Parameters.AddWithValue("@CustomerID", IsDBSomething(varCustomerID, DBNull.Value))
    CMD_D.Parameters.AddWithValue("@CustomerTableName", "Customers")
    CMD_D.Parameters.AddWithValue("@CustomerServerCounter", CLng(varCICustomerServerCounter))
    CMD_D.ExecuteNonQuery()
   End Using
   'DateOfLastCustomerInteraction field in Customers table
   Using conn2 As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
    SqlConnection.ClearPool(conn2)
    conn2.Open()
    Dim CMD_D As New SqlCommand("spUpdateDateOfLastCustomerInteraction", conn2)
    CMD_D.CommandType = Data.CommandType.StoredProcedure
    CMD_D.Parameters.AddWithValue("@CustomerServerCounter", CLng(varCICustomerServerCounter))
    CMD_D.ExecuteNonQuery()
   End Using
   'Delete Entry
  ElseIf InStr(Request("CICounter"), "delete") > 0 Then
   Using conn2 As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
    SqlConnection.ClearPool(conn2)
    conn2.Open()
    Dim CMD_D As New SqlCommand("spDeleteCustomerInteractionRow", conn2)
    CMD_D.CommandType = Data.CommandType.StoredProcedure
    CMD_D.Parameters.AddWithValue("@Counter", Replace(Request("CICounter"), "delete", ""))
    CMD_D.Parameters.AddWithValue("@JavascriptRandomNumber", Request("CIJavascriptRandomNumber"))
    CMD_D.ExecuteNonQuery()
   End Using
   'Update Entry
  Else
   varCIEBRep = Left(Request("CIEBRep" & Request("CICounter")), 50)
   varCICustomerRep = Left(Request("CICustomerRep" & Request("CICounter")), 75)
   varCINotes = Request("CINotes" & Request("CICounter"))
   varCustomerID = Session("CustomerID")
   If varCustomerID = "" Then varCustomerID = 0
   If Not IsNumeric(varCustomerID) Then varCustomerID = 0
   Using conn2 As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
    SqlConnection.ClearPool(conn2)
    conn2.Open()
    Dim CMD_D As New SqlCommand("spUpdateCustomerInteractionRow", conn2)
    CMD_D.CommandType = Data.CommandType.StoredProcedure
    CMD_D.Parameters.AddWithValue("@Counter", Request("CICounter"))
    CMD_D.Parameters.AddWithValue("@JavascriptRandomNumber", varCIJavascriptRandomNumber)
    CMD_D.Parameters.AddWithValue("@EBRep", IsDBSomething(varCIEBRep, DBNull.Value))
    CMD_D.Parameters.AddWithValue("@CustomerRep", IsDBSomething(varCICustomerRep, DBNull.Value))
    CMD_D.Parameters.AddWithValue("@Notes", IsDBSomething(varCINotes, DBNull.Value))
    CMD_D.Parameters.AddWithValue("@CustomerID", IsDBSomething(varCustomerID, DBNull.Value))
    CMD_D.Parameters.AddWithValue("@CustomerTableName", "Customers")
    CMD_D.ExecuteNonQuery()
   End Using
  End If
 End If
 ' From this page
 Dim BadInfo As Integer = 0
 Dim FullNameMessage As String = ""
 Dim DefaultFullName As String = ""
 Dim defaultStreetAddress1 As String = ""
 Dim StreetAddress1Message As String = ""
 Dim defaultStreetAddress2 As String = ""
 Dim DefaultCity As String = ""
 Dim CityMessage As String = ""
 Dim DefaultStateProvince As String = ""
 Dim StateProvinceMessage As String = ""
 Dim DefaultIsland As String = ""
 Dim IslandMessage As String = ""
 Dim PostalCodeMessage As String = ""
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
 Dim CountryMessage As String = ""
 Dim MilitaryAddressMessage As String = ""
 Dim BillingFullNameMessage As String = ""
 Dim DefaultBillingFullName As String = ""
 Dim defaultBillingStreetAddress1 As String = ""
 Dim BillingStreetAddress1Message As String = ""
 Dim defaultBillingStreetAddress2 As String = ""
 Dim BillingStreetAddress2Message As String = ""
 Dim DefaultBillingCity As String = ""
 Dim BillingCityMessage As String = ""
 Dim DefaultBillingStateProvince As String = ""
 Dim BillingStateProvinceMessage As String = ""
 Dim DefaultBillingIsland As String = ""
 Dim BillingIslandMessage As String = ""
 Dim BillingPostalCodeMessage As String = ""
 Dim varCheckedBillingPostalCode As Integer = 0
 Dim varBillingPostalCodeFormat As String = ""
 Dim varBillingPostalCode As String = ""
 Dim varCustomerBillingPostalCodeFormat As String = ""
 Dim varCustomerBillingPostalCode As String = ""
 Dim BillingCountryMessage As String = ""
 Dim defaultSignInEmail As String = ""
 Dim SignInEmailMessage As String = ""
 Dim defaultSignInPassword As String = ""
 Dim defaultPword As String = ""
 Dim PwordMessage As String = ""
 Dim BillingMilitaryAddressMessage As String = ""
 Dim DefaultPhone As String = ""
 Dim EmailMessage As String = ""
 Dim PhoneMessage As String = ""
 Dim DefaultEmail As String = ""
 Dim DefaultResidentialDelivery As String = ""
 Dim DefaultBlockedFromCheckout As String = "n"
 Dim ResidentialDeliveryMessage As String = ""
 Dim BlockedFromCheckoutMessage As String = ""
 Dim DefaultChargeSalesTax As String = ""
 Dim ChargeSalesTaxMessage As String = ""
 Dim DefaultPriceGroup As String = ""
 Dim PriceGroupMessage As String = ""
 Dim varNewReleaseNoSelected As String = ""
 Dim varAccountCreatedDate As String = ""
 Dim varOptIn As String = ""

 If Request("FromCustomerInfoPage") = "yes" Then
  varFromThisPage = 1
  'Check Shipping Address----------------------------------------------------------------------------
  'FullName
  FullNameMessage = ""
  DefaultFullName = CapFirstLetter(SanitizeNameAndAddress(Request("FullName")))
  If Len(DefaultFullName) > 100 Then
   DefaultFullName = Left(DefaultFullName, 100)
  End If
  If DefaultFullName = "" Then
   BadInfo = 1
   FullNameMessage = "<b>Full Name - </b>You did not enter your full name."
  End If
  'StreetAddress1
  defaultStreetAddress1 = CapFirstLetter(SanitizeNameAndAddress(Request("StreetAddress1")))
  StreetAddress1Message = ""
  If Len(defaultStreetAddress1) > 100 Then
   defaultStreetAddress1 = Left(defaultStreetAddress1, 100)
  End If
  If defaultStreetAddress1 = "" Then
   BadInfo = 1
   StreetAddress1Message = "<b>Street Address Line 1 - </b>You did not fill out the address 1 line."
  End If
  'StreetAddress2
  defaultStreetAddress2 = SanitizeNameAndAddress(Request("StreetAddress2"))
  If Len(defaultStreetAddress2) > 100 Then
   defaultStreetAddress2 = Left(defaultStreetAddress2, 100)
  End If
  'City
  DefaultCity = CapFirstLetter(SanitizeNameAndAddress(Request("City")))
  CityMessage = ""
  If Len(DefaultCity) > 100 Then
   DefaultCity = Left(DefaultCity, 100)
  End If
  If varCityRequired = "y" Then
   If LCase(DefaultCity) = "apo" Then
    DefaultCity = "APO"
   ElseIf LCase(DefaultCity) = "fpo" Then
    DefaultCity = "FPO"
   End If
   If varCityRequired = "y" Then
    If DefaultCity = "" Then
     BadInfo = 1
     CityMessage = "You did not enter your " & varCityWord & "."
    End If
   End If
  End If
  'StateProvince
  DefaultStateProvince = CapFirstLetter(SanitizeNameAndAddress(Request("StateProvince")))
  StateProvinceMessage = ""
  If Len(DefaultStateProvince) > 70 Then
   DefaultStateProvince = Left(DefaultStateProvince, 70)
  End If
  If varStateProvinceRequired = "y" Then
   If DefaultStateProvince = "" Then
    BadInfo = 1
    StateProvinceMessage = "You did not enter your " & varStateProvinceWord & "."
   End If
  End If
  'Island
  DefaultIsland = CapFirstLetter(SanitizeNameAndAddress(Request("Island")))
  IslandMessage = ""
  If Len(DefaultIsland) > 50 Then
   DefaultIsland = Left(DefaultIsland, 50)
  End If
  If DefaultStateProvince = "Virgin Islands (U.S.)" Or varIslandRequired <> "n" Then
   If DefaultIsland = "" Then
    BadInfo = 1
    IslandMessage = "You did not enter your " & varIslandWord & "."
   End If
  End If
  'PostalCode
  defaultPostalCode = SanitizeNameAndAddress(Request("PostalCode"))
  PostalCodeMessage = ""
  PostalCodeMessage = ""
  If Len(defaultPostalCode) > 25 Then
   defaultPostalCode = Left(defaultPostalCode, 25)
  End If
  If varPostalCodeRequired = "y" Then
   varCheckedPostalCode = 0
   If defaultPostalCode = "" Then
    BadInfo = 1
    PostalCodeMessage = "You did not enter your " & varPostalCodeWord & "."
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
    varCustomerPostalCode = UCase(defaultPostalCode)
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
       BadInfo = 1
       PostalCodeMessage = "Please re-check your " & varPostalCodeWord & ".  It should be a combination of " & Len(varPostalCodeFormat) & " letters and numbers."
      Else
       If Request("CheckedPostalCode") = "no" Then
        varCheckedPostalCode = 1
        BadInfo = 1
        PostalCodeMessage = "Please re-check your " & varPostalCodeWord & ".  If you are sure it is correct then ignore this message and submit your information again."
       End If
      End If
     Else
      If varRequiredFormat = "R" Then
       BadInfo = 1
       PostalCodeMessage = "Your " & varPostalCodeWord & " needs to be " & Len(varPostalCodeFormat) & " numbers long (no letters)."
      Else
       If Request("CheckedPostalCode") = "no" Then
        varCheckedPostalCode = 1
        BadInfo = 1
        PostalCodeMessage = "Please re-check your " & varPostalCodeWord & ".  If you are sure it is correct then ignore this message and submit your information again."
       End If
      End If
     End If
    End If
    'Check For Small O Instead Of A Zero
    If PostalCodeMessage = "" Then
     If varSmallO = 1 Then
      If Mid(varPostalCodeFormat, varSmallOPosition, 1) <> "L" Then
       If varRequiredFormat = "R" Then
        BadInfo = 1
        PostalCodeMessage = "Please re-check your " & varPostalCodeWord & ".  There is a letter 'O' where a number should be (maybe the number zero?)."
       Else
        If Request("CheckedPostalCode") = "no" Then
         varCheckedPostalCode = 1
         BadInfo = 1
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
         BadInfo = 1
         PostalCodeMessage = "Please re-check your " & varPostalCodeWord & ".  It needs to be a combination of letters and numbers matching this format: " _
          & Right(varFullPostalCodeFormat, Len(varFullPostalCodeFormat) - 1) & " (where 'n' is a number and 'L' is a letter."
        Else
         If Request("CheckedPostalCode") = "no" Then
          varCheckedPostalCode = 1
          BadInfo = 1
          PostalCodeMessage = "Please re-check your " & varPostalCodeWord & ".  If you are sure it is correct then ignore this message and submit your information again."
         End If
        End If
       Else
        If varRequiredFormat = "R" Then
         BadInfo = 1
         PostalCodeMessage = "Your " & varPostalCodeWord & " needs to be " & Len(varPostalCodeFormat) & " numbers long (no letters)."
        Else
         If Request("CheckedPostalCode") = "no" Then
          varCheckedPostalCode = 1
          BadInfo = 1
          PostalCodeMessage = "Please re-check your " & varPostalCodeWord & ".  If you are sure it is correct then ignore this message and submit your information again."
         End If
        End If
       End If
      End If
     Next
    End If
   End If
  End If
  'Country
  CountryMessage = ""
  If Session("Country") = "" Then
   BadInfo = 1
   CountryMessage = "You did not enter your country."
  End If
  'Check Military Address
  MilitaryAddressMessage = ""
  If Request("StateProvince") = "AA (Military)" Or Request("StateProvince") = "AE (Military)" Or Request("StateProvince") = "AP (Military)" Then
   If UCase(Request("City")) <> "APO" And UCase(Request("City")) <> "FPO" Then
    BadInfo = 1
    MilitaryAddressMessage = "City must be 'APO' or FPO' for military addresses."
   End If
  Else
   If UCase(Request("City")) = "APO" Or UCase(Request("City")) = "FPO" Then
    BadInfo = 1
    MilitaryAddressMessage = "City must NOT be 'APO' or FPO' for NON-military addresses."
   End If
  End If

  'Check Billing Address----------------------------------------------------------------------------

  'BillingFullName
  BillingFullNameMessage = ""
  DefaultBillingFullName = CapFirstLetter(SanitizeNameAndAddress(Request("BillingFullName")))
  If Len(DefaultBillingFullName) > 100 Then
   DefaultBillingFullName = Left(DefaultBillingFullName, 100)
  End If
  If DefaultBillingFullName = "" Then
   BadInfo = 1
   BillingFullNameMessage = "<b>Billing Full Name - </b>You did not enter your Billing Full Name."
  End If
  'BillingStreetAddress1
  defaultBillingStreetAddress1 = CapFirstLetter(SanitizeNameAndAddress(Request("BillingStreetAddress1")))
  BillingStreetAddress1Message = ""
  If Len(defaultBillingStreetAddress1) > 100 Then
   defaultBillingStreetAddress1 = Left(defaultBillingStreetAddress1, 100)
  End If
  If defaultBillingStreetAddress1 = "" Then
   BadInfo = 1
   BillingStreetAddress1Message = "<b>Billing Street Address Line 1 - </b>You did not fill out the Billing Street Address Line 1."
  End If
  'BillingStreetAddress2
  defaultBillingStreetAddress2 = SanitizeNameAndAddress(Request("BillingStreetAddress2"))
  If Len(defaultBillingStreetAddress2) > 100 Then
   defaultBillingStreetAddress2 = Left(defaultBillingStreetAddress2, 100)
  End If
  'BillingCity
  DefaultBillingCity = CapFirstLetter(SanitizeNameAndAddress(Request("BillingCity")))
  BillingCityMessage = ""
  If Len(DefaultBillingCity) > 100 Then
   DefaultBillingCity = Left(DefaultBillingCity, 100)
  End If
  If varBillingCityRequired = "y" Then
   If LCase(DefaultBillingCity) = "apo" Then
    DefaultBillingCity = "APO"
   ElseIf LCase(DefaultBillingCity) = "fpo" Then
    DefaultBillingCity = "FPO"
   End If
   If varBillingCityRequired = "y" Then
    If DefaultBillingCity = "" Then
     BadInfo = 1
     BillingCityMessage = "You did not enter your Billing " & varCityWord & "."
    End If
   End If
  End If
  'BillingStateProvince
  DefaultBillingStateProvince = CapFirstLetter(SanitizeNameAndAddress(Request("BillingStateProvince")))
  BillingStateProvinceMessage = ""
  If Len(DefaultBillingStateProvince) > 70 Then
   DefaultBillingStateProvince = Left(DefaultBillingStateProvince, 70)
  End If
  If varBillingStateProvinceRequired = "y" Then
   If DefaultBillingStateProvince = "" Then
    BadInfo = 1
    BillingStateProvinceMessage = "You did not enter your Billing " & varStateProvinceWord & "."
   End If
  End If
  'BillingIsland
  DefaultBillingIsland = CapFirstLetter(SanitizeNameAndAddress(Request("BillingIsland")))
  BillingIslandMessage = ""
  If Len(DefaultBillingIsland) > 50 Then
   DefaultBillingIsland = Left(DefaultBillingIsland, 50)
  End If
  If DefaultBillingStateProvince = "Virgin Islands (U.S.)" Or varBillingIslandRequired <> "n" Then
   If DefaultBillingIsland = "" Then
    BadInfo = 1
    BillingIslandMessage = "You did not enter your Billing " & varIslandWord & "."
   End If
  End If
  'BillingPostalCode
  defaultBillingPostalCode = LCase(SanitizeNameAndAddress(Request("BillingPostalCode")))
  BillingPostalCodeMessage = ""
  If Len(defaultBillingPostalCode) > 25 Then
   defaultBillingPostalCode = Left(defaultBillingPostalCode, 25)
  End If
  If varBillingPostalCodeRequired = "y" Then
   varCheckedBillingPostalCode = 0
   If defaultBillingPostalCode = "" Then
    BadInfo = 1
    BillingPostalCodeMessage = "You did not enter your Billing " & varPostalCodeWord & "."
   ElseIf Len(varBillingFullPostalCodeFormat) > 0 Then
    varRequiredFormat = UCase(Left(varBillingFullPostalCodeFormat, 1))
    'Get PostalCodeFormat To n & L Characters
    varBillingPostalCodeFormat = ""
    varBillingPostalCode = Right(varBillingFullPostalCodeFormat, Len(varBillingFullPostalCodeFormat) - 1)
    For n30 = 1 To Len(varBillingPostalCode)
     x30 = Mid(varBillingPostalCode, n30, 1)
     If Mid(varBillingPostalCode, n30, 1) = "n" Or Mid(varBillingPostalCode, n30, 1) = "L" Then
      varBillingPostalCodeFormat = varBillingPostalCodeFormat & Mid(varBillingPostalCode, n30, 1)
     End If
    Next
    'Get Customer PostalCode To n & L Characters
    xx10 = 0
    varSmallO = 0
    varSmallOPosition = 0
    varCustomerBillingPostalCodeFormat = ""
    varCustomerBillingPostalCode = UCase(defaultBillingPostalCode)
    For n10 = 1 To Len(varCustomerBillingPostalCode)
     x10 = Mid(varCustomerBillingPostalCode, n10, 1)
     If Asc(x10) >= 65 And Asc(x10) <= 90 Then
      xx10 = xx10 + 1
      varCustomerBillingPostalCodeFormat = varCustomerBillingPostalCodeFormat & "L"
      If Asc(x10) = 79 Then
       varSmallO = 1
       varSmallOPosition = xx10
      End If
     ElseIf Asc(x10) >= 48 And Asc(x10) <= 57 Then
      xx10 = xx10 + 1
      varCustomerBillingPostalCodeFormat = varCustomerBillingPostalCodeFormat & "n"
     End If
    Next
    'Check For Correct Length
    If Len(varCustomerBillingPostalCodeFormat) <> Len(varBillingPostalCodeFormat) Then
     If InStr(1, varBillingPostalCodeFormat, "L") > 0 Then
      If varRequiredFormat = "R" Then
       BadInfo = 1
       BillingPostalCodeMessage = "Please re-check your Billing " & varBillingPostalCodeWord & ".  It should be a combination of " & Len(varBillingPostalCodeFormat) & " letters and numbers."
      Else
       If Request("CheckedBillingPostalCode") = "no" Then
        varCheckedBillingPostalCode = 1
        BadInfo = 1
        BillingPostalCodeMessage = "Please re-check your Billing " & varBillingPostalCodeWord & ".  If you are sure it is correct then ignore this message and submit your information again."
       End If
      End If
     Else
      If varRequiredFormat = "R" Then
       BadInfo = 1
       BillingPostalCodeMessage = "Your Billing " & varBillingPostalCodeWord & " needs to be " & Len(varBillingPostalCodeFormat) & " numbers long (no letters)."
      Else
       If Request("CheckedBillingPostalCode") = "no" Then
        varCheckedBillingPostalCode = 1
        BadInfo = 1
        BillingPostalCodeMessage = "Please re-check your Billing " & varBillingPostalCodeWord & ".  If you are sure it is correct then ignore this message and submit your information again."
       End If
      End If
     End If
    End If
    'Check For Small O Instead Of A Zero
    If BillingPostalCodeMessage = "" Then
     If varSmallO = 1 Then
      If Mid(varBillingPostalCodeFormat, varSmallOPosition, 1) <> "L" Then
       If varRequiredFormat = "R" Then
        BadInfo = 1
        BillingPostalCodeMessage = "Please re-check your Billing " & varBillingPostalCodeWord & ".  There is a letter 'O' where a number should be (maybe the number zero?)."
       Else
        If Request("CheckedBillingPostalCode") = "no" Then
         varCheckedBillingPostalCode = 1
         BadInfo = 1
         BillingPostalCodeMessage = "Please re-check your Billing " & varBillingPostalCodeWord & ".  If you are sure it is correct then ignore this message and submit your information again."
        End If
       End If
      End If
     End If
    End If
    'Check For Numbers and Letters Where They Should Be
    If BillingPostalCodeMessage = "" Then
     For n20 = 1 To Len(varBillingPostalCodeFormat)
      If Mid(varBillingPostalCodeFormat, n20, 1) <> Mid(varCustomerBillingPostalCodeFormat, n20, 1) Then
       If InStr(1, varBillingPostalCodeFormat, "L") > 0 Then
        If varRequiredFormat = "R" Then
         BadInfo = 1
         BillingPostalCodeMessage = "Please re-check your Billing " & varBillingPostalCodeWord & ".  It needs to be a combination of letters and numbers matching this format: " _
          & Right(varBillingFullPostalCodeFormat, Len(varBillingFullPostalCodeFormat) - 1) & " (where 'n' is a number and 'L' is a letter."
        Else
         If Request("CheckedBillingPostalCode") = "no" Then
          varCheckedBillingPostalCode = 1
          BadInfo = 1
          BillingPostalCodeMessage = "Please re-check your Billing " & varBillingPostalCodeWord & ".  If you are sure it is correct then ignore this message and submit your information again."
         End If
        End If
       Else
        If varRequiredFormat = "R" Then
         BadInfo = 1
         BillingPostalCodeMessage = "Your Billing " & varBillingPostalCodeWord & " needs to be " & Len(varBillingPostalCodeFormat) & " numbers long (no letters)."
        Else
         If Request("CheckedBillingPostalCode") = "no" Then
          varCheckedBillingPostalCode = 1
          BadInfo = 1
          BillingPostalCodeMessage = "Please re-check your Billing " & varBillingPostalCodeWord & ".  If you are sure it is correct then ignore this message and submit your information again."
         End If
        End If
       End If
      End If
     Next
    End If
   End If
  End If
  'BillingCountry
  BillingCountryMessage = ""
  If Session("BillingCountry") = "" Then
   BadInfo = 1
   BillingCountryMessage = "You did not enter your Billing Country."
  End If
  'Check Military Address
  BillingMilitaryAddressMessage = ""
  If Request("BillingStateProvince") = "AA (Military)" Or Request("BillingStateProvince") = "AE (Military)" Or Request("BillingStateProvince") = "AP (Military)" Then
   If UCase(Request("BillingCity")) <> "APO" And UCase(Request("BillingCity")) <> "FPO" Then
    BadInfo = 1
    BillingMilitaryAddressMessage = "Billing City must be 'APO' or FPO' for military addresses."
   End If
  Else
   If UCase(Request("BillingCity")) = "APO" Or UCase(Request("BillingCity")) = "FPO" Then
    BadInfo = 1
    BillingMilitaryAddressMessage = "Billing City must NOT be 'APO' or FPO' for NON-military addresses."
   End If
  End If

  'Check Contact Information------------------------------------------------------------
  'Phone
  DefaultPhone = SanitizeNameAndAddress(Request("Phone"))
  PhoneMessage = ""
  If Len(DefaultPhone) > 25 Then
   DefaultPhone = Left(DefaultPhone, 25)
  End If
  If DefaultPhone = "" Then
   BadInfo = 1
   PhoneMessage = "Please enter your phone number."
  End If
  'Email
  DefaultEmail = SanitizeNameAndAddress(FixEmail(Request("Email")))
  If Len(DefaultEmail) > 100 Then
   DefaultEmail = Left(DefaultEmail, 100)
  End If
  DefaultEmail = Replace(DefaultEmail, "   ", "")
  DefaultEmail = Replace(DefaultEmail, "  ", "")
  DefaultEmail = Replace(DefaultEmail, " ", "")
  If Len(DefaultEmail) > 4 And UCase(Left(DefaultEmail, 4)) = "WWW." Then
   DefaultEmail = Right(DefaultEmail, Len(DefaultEmail) - 4)
  End If
  If InStr(1, DefaultEmail, "@.") > 0 Then
   BadInfo = 1
   EmailMessage = "<b>E-mail - </b>Please enter a valid Email address. A period can not immediately follow the '@' character."
  End If
  If InStr(1, DefaultEmail, ".@") > 0 Then
   BadInfo = 1
   EmailMessage = "<b>E-mail - </b>Please enter a valid Email address. A period can not immediately precede the '@' character."
  End If
  If DefaultEmail = "" Then
   BadInfo = 1
   EmailMessage = "<b>E-Mail - </b>You did not enter your E-Mail."
  End If

  If Session("PowerUSerName") <> "" Then
   'ResidentialDelivery
   DefaultResidentialDelivery = SanitizeNameAndAddress(Request("ResidentialDelivery"))
   ResidentialDeliveryMessage = ""
   If Len(DefaultResidentialDelivery) > 1 Then
    DefaultResidentialDelivery = Left(DefaultResidentialDelivery, 1)
   End If
   If UCase(DefaultResidentialDelivery) <> "Y" And UCase(DefaultResidentialDelivery) <> "N" Then
    BadInfo = 1
    ResidentialDeliveryMessage = "Residential Delivery must be 'y' or 'n'."
   End If
   'BlockedFromCheckout
   DefaultBlockedFromCheckout = SanitizeNameAndAddress(Request("BlockedFromCheckout"))
   BlockedFromCheckoutMessage = ""
   If Len(DefaultBlockedFromCheckout) > 1 Then
    DefaultBlockedFromCheckout = Left(DefaultBlockedFromCheckout, 1)
   End If
   If UCase(DefaultBlockedFromCheckout) <> "Y" And UCase(DefaultBlockedFromCheckout) <> "N" Then
    BadInfo = 1
    BlockedFromCheckoutMessage = "Blocked From Checkout must be 'y' or 'n'."
   End If

   'ChargeSalesTax
   DefaultChargeSalesTax = SanitizeNameAndAddress(Request("ChargeSalesTax"))
   ChargeSalesTaxMessage = ""
   If Len(DefaultChargeSalesTax) > 1 Then
    DefaultChargeSalesTax = Left(DefaultChargeSalesTax, 1)
   End If
   If DefaultChargeSalesTax <> "" And UCase(DefaultChargeSalesTax) <> "N" Then
    BadInfo = 1
    ChargeSalesTaxMessage = "ChargeSalesTax must be 'n' or left blank."
   End If
   'PriceGroup
   DefaultPriceGroup = SanitizeNameAndAddress(Request("PriceGroup"))
   PriceGroupMessage = ""
   If Len(DefaultPriceGroup) > 15 Then
    DefaultPriceGroup = Left(DefaultPriceGroup, 15)
   End If
   If DefaultPriceGroup <> "RetailPrice" And DefaultPriceGroup <> "StorePrice" And DefaultPriceGroup <> "ExportPrice" Then
    BadInfo = 1
    PriceGroupMessage = "PriceGroup must be 'RetailPrice' or 'StorePrice' or 'ExportPrice'."
   End If
  Else
   'ResidentialDelivery
   DefaultResidentialDelivery = SanitizeNameAndAddress(Request("ResidentialDelivery"))
   If UCase(DefaultResidentialDelivery) <> "Y" And UCase(DefaultResidentialDelivery) <> "N" Then
    DefaultResidentialDelivery = "N"
   End If
   'BlockedFromCheckout
   DefaultBlockedFromCheckout = SanitizeNameAndAddress(Request("BlockedFromCheckout"))
   If UCase(DefaultBlockedFromCheckout) <> "Y" And UCase(DefaultBlockedFromCheckout) <> "N" Then
    DefaultBlockedFromCheckout = "N"
   End If
   'ChargeSalesTax
   DefaultChargeSalesTax = SanitizeNameAndAddress(Request("ChargeSalesTax"))
   If DefaultChargeSalesTax <> "" And UCase(DefaultChargeSalesTax) <> "N" Then
    DefaultChargeSalesTax = ""
   End If
   'PriceGroup
   DefaultPriceGroup = SanitizeNameAndAddress(Request("PriceGroup"))
   If DefaultPriceGroup <> "RetailPrice" And DefaultPriceGroup <> "StorePrice" And DefaultPriceGroup <> "ExportPrice" Then
    DefaultPriceGroup = "StorePrice"
   End If
  End If
  'Account Created Date
  varAccountCreatedDate = Request("AccountCreatedDate")
  'New Release Email Opt In Or Out
  If Request("NewReleaseEmailRadio") = "yes" Then
   varNewReleaseYesSelected = "checked"
   varNewReleaseNoSelected = ""
  ElseIf Request("NewReleaseEmailRadio") = "no" Then
   varNewReleaseYesSelected = ""
   varNewReleaseNoSelected = "checked"
  End If

  'Check Sign-In Credentials------------------------------------------------------------

  'Sign-In Email
  defaultSignInEmail = SanitizeNameAndAddress(FixEmail(Request("SignInEmail")))
  If Len(defaultSignInEmail) > 100 Then
   defaultSignInEmail = Left(defaultSignInEmail, 100)
  End If
  defaultSignInEmail = Replace(defaultSignInEmail, "   ", "")
  defaultSignInEmail = Replace(defaultSignInEmail, "  ", "")
  defaultSignInEmail = Replace(defaultSignInEmail, " ", "")
  If InStr(1, defaultSignInEmail, " ") > 0 Then
   BadInfo = 1
   SignInEmailMessage = "<b>Sign-In Email - </b>Can not contain any spaces."
  ElseIf Len(defaultSignInEmail) < 6 Then
   BadInfo = 1
   SignInEmailMessage = "<b>Sign-In Email - </b>Your Sign-In Email must be at least 6 characters long."
  End If
  'Password
  defaultPword = SanitizeNameAndAddress(FixEmail(Request("Pword")))
  If Len(defaultPword) > 100 Then
   defaultPword = Left(defaultPword, 100)
  End If
  defaultPword = Replace(defaultPword, "   ", "")
  defaultPword = Replace(defaultPword, "  ", "")
  defaultPword = Replace(defaultPword, " ", "")
  If InStr(1, defaultPword, " ") > 0 Then
   BadInfo = 1
   SignInEmailMessage = "<b>Password - </b>Can not contain any spaces."
  ElseIf Len(defaultPword) < 6 Then
   BadInfo = 1
   PwordMessage = "<b>Password - </b>Your Password must be at least 6 characters long."
  End If
  'Check if Sign-In Email Already Exists
  If BadInfo = 0 Then
   Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
    SqlConnection.ClearPool(conn)
    conn.Open()
    Dim CMD_X As New SqlCommand("spCheckIfLogInEmailExists", conn)
    CMD_X.CommandType = Data.CommandType.StoredProcedure
    CMD_X.Parameters.AddWithValue("@LogInEmail", defaultSignInEmail)
    CMD_X.Parameters.AddWithValue("@Counter", Session("CustomerServerCounter"))
    Dim xx As SqlDataReader
    xx = CMD_X.ExecuteReader
    If xx.HasRows Then
     BadInfo = 1
     SignInEmailMessage = "<b>Sign-In Email - </b>This Sign-In Email already exists for another customer. Please enter a different Sign-In Email."
    End If
   End Using
  End If


  'Country Changed
  If Request("CountryChangedTxt") = "yes" Then
   defaultStreetAddress1 = ""
   defaultStreetAddress2 = ""
   DefaultCity = ""
   DefaultStateProvince = ""
   defaultPostalCode = ""
   DefaultIsland = ""
  End If

  'BillingCountry Changed
  If Request("BillingCountryChangedTxt") = "yes" Then
   defaultBillingStreetAddress1 = ""
   defaultBillingStreetAddress2 = ""
   DefaultBillingCity = ""
   DefaultBillingStateProvince = ""
   defaultBillingPostalCode = ""
   DefaultBillingIsland = ""
  End If

  ' Record Customer Info Changes If Info Is OK 
  If BadInfo = 0 And Request("FromCustomerInfoPage") = "yes" And Request("CountryChangedTxt") <> "yes" And Request("BillingCountryChangedTxt") <> "yes" Then

   'Check for changed Email
   Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
    SqlConnection.ClearPool(conn)
    conn.Open()
    Dim CMD_xx As New SqlCommand("spGetCustomerDetailsByServerCounter", conn)
    CMD_xx.CommandType = Data.CommandType.StoredProcedure
    CMD_xx.Parameters.AddWithValue("@counter", Session("CustomerServerCounter"))
    Dim readerXX As SqlDataReader
    readerXX = CMD_xx.ExecuteReader
    If readerXX.HasRows Then
     readerXX.Read()
     strCurrentEmail = IsDBSomething(readerXX("Email"), "")
    End If
   End Using
   If strCurrentEmail <> DefaultEmail Then
    If IsNumeric(Session("CustomerID")) Then
     intCustomerIDForEmailChange = CLng(Session("CustomerID"))
    End If
    Using conn2 As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
     SqlConnection.ClearPool(conn2)
     conn2.Open()
     Dim CMD_D As New SqlCommand("spInsertCustomerEmailChanges", conn2)
     CMD_D.CommandType = Data.CommandType.StoredProcedure
     CMD_D.Parameters.AddWithValue("@CustomerID", intCustomerIDForEmailChange)
     CMD_D.Parameters.AddWithValue("@CustomerServerCounter", IsSomething(Session("CustomerServerCounter"), DBNull.Value))
     CMD_D.Parameters.AddWithValue("@OldEmail", IsSomething(strCurrentEmail, DBNull.Value))
     CMD_D.Parameters.AddWithValue("@NewEmail", IsSomething(DefaultEmail, DBNull.Value))
     CMD_D.ExecuteNonQuery()
    End Using
   End If
   'Update Customers table  
   Using conn2 As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
    SqlConnection.ClearPool(conn2)
    conn2.Open()
    Dim CMD_D As New SqlCommand("spUpdateCustomers", conn2)
    CMD_D.CommandType = Data.CommandType.StoredProcedure
    CMD_D.Parameters.AddWithValue("@Email", IsSomething(DefaultEmail, DBNull.Value))
    CMD_D.Parameters.AddWithValue("@Phone", IsSomething(DefaultPhone, DBNull.Value))
    CMD_D.Parameters.AddWithValue("@ResidentialDelivery", IsSomething(DefaultResidentialDelivery, DBNull.Value))
    CMD_D.Parameters.AddWithValue("@BlockedFromCheckout", IsSomething(DefaultBlockedFromCheckout, DBNull.Value))
    CMD_D.Parameters.AddWithValue("@ChargeSalesTax", IsSomething(DefaultChargeSalesTax, DBNull.Value))
    CMD_D.Parameters.AddWithValue("@PriceGroup", IsSomething(DefaultPriceGroup, DBNull.Value))
    CMD_D.Parameters.AddWithValue("@FullName", IsSomething(DefaultFullName, DBNull.Value))
    CMD_D.Parameters.AddWithValue("@StreetAddress1", IsSomething(defaultStreetAddress1, DBNull.Value))
    CMD_D.Parameters.AddWithValue("@StreetAddress2", IsSomething(defaultStreetAddress2, DBNull.Value))
    CMD_D.Parameters.AddWithValue("@City", IsSomething(DefaultCity, DBNull.Value))
    CMD_D.Parameters.AddWithValue("@StateProvince", IsSomething(DefaultStateProvince, DBNull.Value))
    CMD_D.Parameters.AddWithValue("@PostalCode", IsSomething(defaultPostalCode, DBNull.Value))
    CMD_D.Parameters.AddWithValue("@Island", IsSomething(DefaultIsland, DBNull.Value))
    CMD_D.Parameters.AddWithValue("@Country", IsSomething(Session("Country"), DBNull.Value))
    CMD_D.Parameters.AddWithValue("@BillingFullName", IsSomething(DefaultBillingFullName, DBNull.Value))
    CMD_D.Parameters.AddWithValue("@BillingStreetAddress1", IsSomething(defaultBillingStreetAddress1, DBNull.Value))
    CMD_D.Parameters.AddWithValue("@BillingStreetAddress2", IsSomething(defaultBillingStreetAddress2, DBNull.Value))
    CMD_D.Parameters.AddWithValue("@BillingCity", IsSomething(DefaultBillingCity, DBNull.Value))
    CMD_D.Parameters.AddWithValue("@BillingStateProvince", IsSomething(DefaultBillingStateProvince, DBNull.Value))
    CMD_D.Parameters.AddWithValue("@BillingPostalCode", IsSomething(defaultBillingPostalCode, DBNull.Value))
    CMD_D.Parameters.AddWithValue("@BillingIsland", IsSomething(DefaultBillingIsland, DBNull.Value))
    CMD_D.Parameters.AddWithValue("@BillingCountry", IsSomething(defaultBillingCountry, DBNull.Value))
    CMD_D.Parameters.AddWithValue("@LogInEmail", IsSomething(defaultSignInEmail, DBNull.Value))
    CMD_D.Parameters.AddWithValue("@Password", IsSomething(defaultPword, DBNull.Value))
    CMD_D.Parameters.AddWithValue("@Counter", CLng(strServerCounter))
    CMD_D.ExecuteNonQuery()
   End Using

  End If
  'Record New Release Email Opt In Or Out if any given
  If varNewReleaseYesSelected = "checked" Or varNewReleaseNoSelected = "checked" And Session("PriceGroup") = "RetailPrice" Then
   If varNewReleaseYesSelected = "checked" Then
    varOptIn = "yes"
   Else
    varOptIn = "no"
   End If
   Using conn2 As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
    SqlConnection.ClearPool(conn2)
    conn2.Open()
    Dim CMD_D As New SqlCommand("spInsertNewReleaseEmailOptInOrOut", conn2)
    CMD_D.CommandType = Data.CommandType.StoredProcedure
    CMD_D.Parameters.AddWithValue("@Email", IsDBSomething(DefaultEmail, DBNull.Value))
    CMD_D.Parameters.AddWithValue("@FullName", IsDBSomething(DefaultFullName, DBNull.Value))
    CMD_D.Parameters.AddWithValue("@Password", IsDBSomething(defaultPword, DBNull.Value))
    CMD_D.ExecuteNonQuery()
   End Using
  End If
  'Set Session Variables
  Session("Country") = defaultCountry
  Session("PostalCode") = defaultPostalCode
  Session("BillingCountry") = defaultBillingCountry
  Session("BillingPostalCode") = defaultBillingPostalCode
 Else
  'From other page
  Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
   SqlConnection.ClearPool(conn)
   conn.Open()
   Dim CMD_Y As New SqlCommand("spGetCustomerDetailsByServerCounter", conn)
   CMD_Y.CommandType = Data.CommandType.StoredProcedure
   CMD_Y.Parameters.AddWithValue("@counter", strServerCounter)
   Dim readerY As SqlDataReader
   readerY = CMD_Y.ExecuteReader
   If readerY.HasRows Then
    readerY.Read()
    varCustomerID = readerY("CustomerID")
    If IsDBNull(readerY("DateTime")) Then
     varAccountCreatedDate = ""
    Else
     varAccountCreatedDate = FormatDateTime(readerY("DateTime"), vbShortDate)
    End If
    defaultPword = IsDBSomething(readerY("Password"), "")
    defaultSignInEmail = IsDBSomething(readerY("LogInEmail"), "")
    DefaultPhone = IsDBSomething(readerY("Phone"), "")
    DefaultEmail = IsDBSomething(readerY("Email"), "")
    DefaultResidentialDelivery = IsDBSomething(readerY("ResidentialDelivery"), "")
    DefaultBlockedFromCheckout = IsDBSomething(readerY("BlockedFromCheckout"), "")
    DefaultChargeSalesTax = IsDBSomething(readerY("ChargeSalesTax"), "")
    DefaultPriceGroup = IsDBSomething(readerY("PriceGroup"), "")
    DefaultFullName = IsDBSomething(readerY("FullName"), "")
    defaultStreetAddress1 = IsDBSomething(readerY("StreetAddress1"), "")
    defaultStreetAddress2 = IsDBSomething(readerY("StreetAddress2"), "")
    DefaultCity = IsDBSomething(readerY("City"), "")
    DefaultStateProvince = IsDBSomething(readerY("StateProvince"), "")
    defaultPostalCode = IsDBSomething(readerY("PostalCode"), "")
    DefaultIsland = IsDBSomething(readerY("Island"), "")
    defaultCountry = IsDBSomething(readerY("Country"), "")
    DefaultBillingFullName = IsDBSomething(readerY("BillingFullName"), "")
    defaultBillingStreetAddress1 = IsDBSomething(readerY("BillingStreetAddress1"), "")
    defaultBillingStreetAddress2 = IsDBSomething(readerY("BillingStreetAddress2"), "")
    DefaultBillingCity = IsDBSomething(readerY("BillingCity"), "")
    DefaultBillingStateProvince = IsDBSomething(readerY("BillingStateProvince"), "")
    defaultBillingPostalCode = IsDBSomething(readerY("BillingPostalCode"), "")
    DefaultBillingIsland = IsDBSomething(readerY("BillingIsland"), "")
    defaultBillingCountry = IsDBSomething(readerY("BillingCountry"), "")
    Session("ShippingCartPostalCode") = IsDBSomething(readerY("PostalCode"), "")
    Session("ShippingCartCountry") = IsDBSomething(readerY("Country"), "")
    Session("CountryHelpShipping") = IsDBSomething(readerY("Country"), "")
    Session("CountryTextHelpShipping") = IsDBSomething(readerY("Country"), "")
    Session("PostalCodeHelpShipping") = IsDBSomething(readerY("PostalCode"), "")
   Else
    Response.Redirect("/home.aspx")
   End If
  End Using
 End If
 %>
<%If varReturnToPurchase = "y" And BadInfo = 0 And Request.QueryString("ReturnToPurchase") = "" Then
  Response.Redirect("/purchase.aspx")
 End If%>
<form name="PU"id="PU" onsubmit="return Validation(this)" action="/CustomerInfo.aspx" method="post">
<input type="hidden" name="FromCustomerInfoPage"id="FromCustomerInfoPage" value="yes">
<input type="hidden" name="CountryChangedTxt" id="CountryChangedTxt"value="no">
<input type="hidden" name="BillingCountryChangedTxt"id="BillingCountryChangedTxt" value="no">
<input type="hidden" name="CreditCardInfoTry" id="CreditCardInfoTry" value="no">
<input type="hidden" name="ChAdd"id="ChAdd" value="no">
<input type="hidden" name="ReturnToPurchase1"id="ReturnToPurchase1" value="<%=varReturnToPurchase%>">
<% If session("PowerUserName")<>"" then%>
 <input type="hidden" name="SavedRetailCartEmail" id="SavedRetailCartEmail" value="">
<%end if%>
<%if varCheckedPostalCode=1 then%>
 <input type="hidden" name="CheckedPostalCode"id="CheckedPostalCode" value="yes">
<%else%>
 <input type="hidden" name="CheckedPostalCode"id="CheckedPostalCode" value="no">
<%end if%>

<table cellpadding="0" cellspacing="0" align="center" bgcolor="9BAF9B" width="1250">
<td align="center"height="30"valign="top">
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
</td><td align="left"width="156">
<%'Customer Login Data
 If Session("PowerUserName") <> "" And Session("CustomerServerCounter") <> "" Then%>
 <div style="margin-left:-265px;border-radius:11px;border:1px solid #A5A5A3;margin-top:27px;width:400px;padding:5px;padding-left:8px;position:absolute;text-align:left;background-color:#FAFAFA">
 <p style="font-size:12px;font-weight:900">Customer Sign-Ins (doesn't include PowerUsers):</p>
 <table width="100%"style="background-color:#FAFAFA"cellpadding="0" cellspacing="0"BORDER="0">
 <%Dim strNumberOfSignInsText As String = ""
  Using conn2 As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
   SqlConnection.ClearPool(conn2)
   conn2.Open()
   Dim CMD_o As New SqlCommand("spNumberOfCustomerLogins", conn2)
   CMD_o.CommandType = Data.CommandType.StoredProcedure
   CMD_o.Parameters.AddWithValue("@CustomerServerCounter", Session("CustomerServerCounter"))
   Dim readerO As SqlDataReader
   readerO = CMD_o.ExecuteReader
   readerO.Read()
   strNumberOfSignInsText = readerO("Total")
  End Using%>  
 <tr><td width="250"align="left">
 <p style="font-size:11px">Number of Sign-Ins Ever:</p>
 </td><td width="150"align="left">
 <p><%=strNumberOfSignInsText%></p>
 </td></tr>
 <tr><td width="250"align="left">
 </td><td width="150"align="left">
 </td></tr></table>
 </div>
<% End If%>
</td></table>
<table bgcolor="9BAF9B"cellpadding="0" cellspacing="0" WIDTH="1250" align="center" BORDER="0">
<tr><td align="center"height="50"valign="top">
<div style="position:absolute;width:160px;margin-left:100px;margin-top:1px">
<img alt="" title="Click here to view your orders and invoices."onclick="window.location='/CustomerOrders.aspx'" style="border:0px;cursor:pointer" onmouseover="fovs(this,'view-your-orders')" onmouseout="fous(this,'view-your-orders')"src="<%=AssetsPath()%>/view-your-orders.gif" id=image7 name=image7>
</div>

<p class="a"style="font-family:Verdana,Arial;font-size:28px;font-weight:600;color:#ffffff">Your Account</p>
</td></tr></table>



<%' PowerUser Forgot Password Div
 If session("PowerUserName") <> "" Then%>
 <div id="divForgotPassword"name="divForgotPassword"style="margin-left:678px;margin-top:-20px;background-image:url('<%=AssetsPath()%>/forgot-password-bg.gif');background-repeat:no-repeat;vertical-align:top;text-align:left;width:530px;height:480px;border:0px;position:absolute;display:none;visibility:hidden">
 <table width="530"align="left"style="text-align:left"border="0"cellpadding="0"cellspacing="0"frame="void">
 <tr><td>
 <table width="530"align="left"style="text-align:left"border="0"cellpadding="0"cellspacing="0"frame="void">
 <tr><td width="40"></td>
 <td width="450" align="center"valign="top"style="padding-top:30px;vertical-align:middle;text-align:center">
 <p class="p-title-2">Email Sign-In Credentials</p>
 </td><td width="40"align="right"valign="top"style="vertical-align:top;text-align:right">
 <img alt=""title="Close this window."style="margin-top:20px;margin-right:20px;cursor:pointer"onclick="hideForgotPasswordDiv()"onmouseover="fov(this,'close-forgot-password')"onmouseout="fou(this,'close-forgot-password')"src="<%=AssetsPath()%>/close-forgot-password.gif" />
 </td></tr></table>
 </td></tr><tr><td>
 <table width="530"align="left"style="text-align:left"border="0"cellpadding="0"cellspacing="0"frame="void">
 <tr><td width="40"></td>
 <td width="450" align="center"valign="top"style="padding-top:5px;vertical-align:middle;text-align:center">
 <p class="p-text-2">Please select or enter the email address that you want to send this customer's Sign-In Credentials to.</p>
 </td><td width="40">
 </td></tr></table>
 </td></tr><tr><td>
 <table width="530"align="left"style="text-align:left"border="0"cellpadding="0"cellspacing="0"frame="void">
 <tr><td width="40"height="60"></td>
 <td width="450" align="center"valign="top"style="padding-top:5px;vertical-align:middle;text-align:center">
 <img alt=""style="cursor:pointer"onmouseover="fovs(this,'primary-email')"onmouseout="fous(this,'primary-email')"id="btnPrimaryEmail"name="btnPrimaryEmail"onclick="UseThisEmail('<%=defaultEmail%>')"src="<%=AssetsPath()%>/primary-email.gif" />
 <img alt=""style="cursor:pointer"onmouseover="fovs(this,'sign-in-email')"onmouseout="fous(this,'sign-in-email')"id="btnSignInEmail"name="btnSignInEmail"onclick="UseThisEmail('<%=Session("LogInEmailMaster")%>')"src="<%=AssetsPath()%>/sign-in-email.gif" />
 </td><td width="40">
 </td></tr></table>
 </td></tr><tr><td>
 <table width="530"align="left"style="text-align:left"border="0"cellpadding="0"cellspacing="0"frame="void">
 <tr><td width="67"></td>
 <td width="296" height="30"align="left"valign="bottom"style="padding-bottom:2px;vertical-align:bottom;text-align:left">
 <p class="p-text-2-b"style="margin-left:2px">Email Address:</p>
 </td><td width="167">
 </tr><tr><td width="67"></td>
 <td width="296" height="32"align="left"valign="middle"style="vertical-align:middle;text-align:left;background-image:url('<%=AssetsPath()%>/forgot-password-text-bg.gif');background-repeat:no-repeat">
 <input type="text"autocomplete="off" maxlength="100"class="input-1" style="width:270px;margin-left:10px" id="txtForgotPasswordEmail" name="txtForgotPasswordEmail"onkeydown="txtForgotPasswordEmailKeyDown(event)" />
 </td><td width="167"align="left"valign="middle"style="vertical-align:middle;text-align:left">
 <img alt=""style="cursor:pointer"onmouseover="fov(this,'forgot-password-submit')"onmouseout="fou(this,'forgot-password-submit')"id="btnForgotPasswordSubmit"name="btnForgotPasswordSubmit"onclick="forgotPasswordSubmit('<%=Session("CustomerServerCounter")%>')"src="<%=AssetsPath()%>/forgot-password-submit.gif" />
 </td></tr></table>
 </td></tr><tr><td>
 <table width="530"align="left"style="text-align:left"border="0"cellpadding="0"cellspacing="0"frame="void">
 <tr><td width="67"></td>
 <td width="396" height="130"align="left"valign="top"style="vertical-align:top;text-align:left">
 <div id="divEmailSent"name="divEmailSent"style="margin-top:30px;border:0px;vertical-align:top;text-align:center;width:396px;height:140px;position:absolute;display:none;visibility:hidden">
 <table width="396"align="left"cellpadding="10"style="text-align:left;border:1px"cellspacing="0"frame="void">
 <tr><td width="55"height="80"align="left"valign="middle"style="vertical-align:middle;text-align:left;border-left:1px solid #252525;border-top:1px solid #252525;border-bottom:1px solid #252525">
 <img alt=""src="<%=AssetsPath()%>/checkmark-green.gif" />
 </td><td width="341"align="left"valign="middle"style="vertical-align:middle;text-align:left;border-right:1px solid #252525;border-top:1px solid #252525;border-bottom:1px solid #252525">
 <p class="p-text-2"style="font-size:13px;color:#000000">Sign-In Credentials emailed successfuly.</p>
 </td></tr><tr><td width="55">
 </td><td width="341"align="left"valign="top"style="padding-left:67px">
 <img alt=""style="cursor:pointer"onclick="hideForgotPasswordDiv()"onmouseover="fov(this,'close-this-window')"onmouseout="fou(this,'close-this-window')"src="<%=AssetsPath()%>/close-this-window.gif" />
 </td></tr></table>
 </div>
 <div id="divNoAccount"name="divNoAccount"style="margin-top:30px;border:0px;vertical-align:top;text-align:center;width:396px;height:140px;position:absolute;display:none;visibility:hidden">
 <table width="396"align="left"cellpadding="10"style="text-align:left;border:1px"cellspacing="0"frame="void">
 <tr><td width="55"height="80"align="left"valign="middle"style="vertical-align:middle;text-align:left;border-left:1px solid #252525;border-top:1px solid #252525;border-bottom:1px solid #252525">
 <img alt=""src="<%=AssetsPath()%>/exclamaition-orange.gif" />
 </td><td width="341"align="left"valign="middle"style="vertical-align:middle;text-align:left;border-right:1px solid #252525;border-top:1px solid #252525;border-bottom:1px solid #252525">
 <p class="p-text-2"style="font-size:14px;color:#000000">The Log In Email has not been set up for this customer yet.  Email NOT sent.</p>
 </td></tr><tr><td width="55">
 </td><td width="341"align="left"valign="top"style="padding-left:67px">
 </td></tr><tr>
 <td colspan="2"width="391"height="60"align="center"valign="bottom">
 </td></tr></table>
 </div>
 <div id="divBadEmailAddress"name="divBadEmailAddress"style="margin-top:30px;border:0px;vertical-align:top;text-align:center;width:396px;height:140px;position:absolute;display:none;visibility:hidden">
 <table width="396"align="left"cellpadding="10"style="text-align:left;border:1px"cellspacing="0"frame="void">
 <tr><td width="55"height="80"align="left"valign="middle"style="vertical-align:middle;text-align:left;border-left:1px solid #252525;border-top:1px solid #252525;border-bottom:1px solid #252525">
 <img alt=""src="<%=AssetsPath()%>/exclamaition-orange.gif" />
 </td><td width="341"align="left"valign="middle"style="vertical-align:middle;text-align:left;border-right:1px solid #252525;border-top:1px solid #252525;border-bottom:1px solid #252525">
 <p class="p-text-2"style="font-size:14px;color:#000000">The email address that you entered is not a valid email address.  The email was NOT sent.</p>
 </td></tr><tr><td width="55">
 </td><td width="341"align="left"valign="top"style="padding-left:67px">
 </td></tr><tr>
 <td colspan="2"width="391"height="60"align="center"valign="bottom">
 </td></tr></table>
 </div>
 <div id="divProcessingIcon"name="divProcessingIcon"style="margin-top:30px;border:0px;vertical-align:top;text-align:center;width:396px;height:140px;position:absolute;display:none;visibility:hidden">
 <table width="396"align="left"cellpadding="10"style="text-align:left;border:1px"cellspacing="0"frame="void">
 <tr><td width="396"height="80"align="center"valign="middle"style="vertical-align:middle;text-align:center">
 <img alt=""name="imgLoadingImage"id="imgLoadingImage"style="border:0px;margin-top:3px;"src="<%=AssetsPath()%>/loading-processing-0.gif" />
 </td></tr></table>
 </div>
 </td><td width="67">
 </td></tr></table>
 </td></tr></table>
 </div>
<% End If%>

<%if session("PowerUserName") <> "" Then%>
 <table cellpadding="0" border="0" cellspacing="0" width="1250" align="center" bgcolor="D4DBD4">
 <td height="20"align="center"valign="bottom">
 </td></table>
<%else%>
 <table cellpadding="0" border="0" cellspacing="0" width="1250" align="center" bgcolor="D4DBD4">
 <td height="33"align="left"valign="bottom"style="padding-left:150px">
 </td></table>

<%end if%>

<%'Bad Customer Info
if BadInfo=1 then%>
 <table border="0" cellpadding="0" cellspacing="0" align="center" bgcolor="D4DBD4" width="1250">
 <tr>
 </td><td height="60"width="1250" valign="middle" align="center">
 <b><p style="background-color:#ff0000;font-face:airal,verdana;font-size:22px;color:ffffff;padding:5px">&nbsp;&nbsp;Please re-do these items:&nbsp;&nbsp;</p></b>
 </td></tr>
 </table>
 <table border="0" align="center" bgcolor="D4DBD4" width="1250">
 <tr><td align="left" width="18%"></td>
 <td bgcolor="ffff00" width="64%" valign="top" align="left">
 <p class="redo">
 <ul style="padding-top:10px"class="ul-redo">
 <%
  If PhoneMessage <> "" Then Response.Write("<li>" & PhoneMessage)
  If EmailMessage <> "" Then Response.Write("<li>" & EmailMessage)
  If ResidentialDeliveryMessage <> "" Then Response.Write("<li>" & ResidentialDeliveryMessage)
  If BlockedFromCheckoutMessage <> "" Then Response.Write("<li>" & BlockedFromCheckoutMessage)
  If ChargeSalesTaxMessage <> "" Then Response.Write("<li>" & ChargeSalesTaxMessage)
  If PriceGroupMessage <> "" Then Response.Write("<li>" & PriceGroupMessage)
  If FullNameMessage <> "" Then Response.Write("<li>" & FullNameMessage)
  If StreetAddress1Message <> "" Then Response.Write("<li>" & StreetAddress1Message)
  If CityMessage <> "" Then Response.Write("<li><b> " & varCityWord & ": </b>" & CityMessage)
  If StateProvinceMessage <> "" Then Response.Write("<li><b> " & varStateProvinceWord & ": </b>" & StateProvinceMessage)
  If PostalCodeMessage <> "" Then Response.Write("<li><b> " & varPostalCodeWord & ": </b>" & PostalCodeMessage)
  If IslandMessage <> "" Then Response.Write("<li><b> " & varIslandWord & ": </b>" & IslandMessage)
  If MilitaryAddressMessage <> "" Then Response.Write("<li><b> City: </b>" & MilitaryAddressMessage)
  If CountryMessage <> "" Then Response.Write("<li>" & CountryMessage)
  If BillingFullNameMessage <> "" Then Response.Write("<li>" & BillingFullNameMessage)
  If BillingStreetAddress1Message <> "" Then Response.Write("<li>" & BillingStreetAddress1Message)
  If BillingCityMessage <> "" Then Response.Write("<li><b> " & varBillingCityWord & ": </b>" & BillingCityMessage)
  If BillingStateProvinceMessage <> "" Then Response.Write("<li><b> " & varBillingStateProvinceWord & ": </b>" & BillingStateProvinceMessage)
  If BillingPostalCodeMessage <> "" Then Response.Write("<li><b> " & varBillingPostalCodeWord & ": </b>" & BillingPostalCodeMessage)
  If BillingIslandMessage <> "" Then Response.Write("<li><b> " & varBillingIslandWord & ": </b>" & BillingIslandMessage)
  If BillingMilitaryAddressMessage <> "" Then Response.Write("<li><b> City: </b>" & BillingMilitaryAddressMessage)
  If BillingCountryMessage <> "" Then Response.Write("<li>" & BillingCountryMessage)
  If SignInEmailMessage <> "" Then Response.Write("<li>" & SignInEmailMessage)
  If PwordMessage <> "" Then Response.Write("<li>" & PwordMessage)

%></ul></p>
 </td><td width="18%"></td></tr></table>
 <table width="1250"border="0" frame="none" cellpadding="0" cellspacing="0" align="center" bgcolor="D4DBD4">
 <tr><td height="10">
 </td></tr></table>
<% End if%>

<%'Customer Shipping Address--------------------------------------------------------------------------------------%>
<table width="1250"border="0" frame="none" cellpadding="0" cellspacing="0" align="center" bgcolor="D4DBD4"style="background-image:url('<%=AssetsPath()%>/customer-info-bg3.gif');background-repeat:no-repeat">
<tr><td width="545"valign="top"height="543">
<% ' Submit %>
<%if BadInfo=0 and request("FromCustomerInfoPage") = "yes" And Request("CountryChangedTxt") <> "yes" And Request("BillingCountryChangedTxt") <> "yes" And request("SavedRetailCartEmail") = "" Then
  divChangesMadeVisibility = "visible"
  divChangesMadeDisplay = "inline"
 End If%>
 <%
  Dim intButtonsDivMarginTop As Integer = 0
  If Session("PowerUserName") <> "" Then
   intButtonsDivMarginTop = 504
  Else
   intButtonsDivMarginTop = 454
  End If%>
 <div id="divChangesSaved"name="divChangesSaved"style="z-index:20000;margin-left:300px;margin-top:<%=intButtonsDivMarginTop+2%>px;border:0px;vertical-align:top;text-align:left;width:116px;height:84px;position:absolute;display:<%=divChangesMadeDisplay%>;visibility:<%=divChangesMadeVisibility%>">
 <img alt=""title="Your changes have been saved"src="<%=AssetsPath()%>/changes-saved.gif" />
 </div>
 <div style="position:absolute;margin-left:260px;margin-top:<%=intButtonsDivMarginTop%>px;visibility:hidden;display:none"id="dontforgetdiv">
 <img src="<%=AssetsPath()%>/dont-forget3.gif">
 </div>
 <div style="margin-left:450px;margin-top:<%=intButtonsDivMarginTop%>px;vertical-align:top;text-align:left;width:350px;height:55px;border:0px;position:absolute">
 <img title="Click here to save any changes made to your customer information."src="<%=AssetsPath()%>/save-changes2.gif"onclick="SubmitFcn()" style="cursor:pointer" id="savechangesbtn" name="savechangesbtn">
 <img src="<%=AssetsPath()%>/cancel2.gif"onclick="location.reload()" style="cursor:pointer">
 </div>
 <div style="margin-left:450px;margin-top:<%=intButtonsDivMarginTop%>px;vertical-align:top;text-align:left;width:350px;height:55px;border:0px;position:absolute">
 <img title="Click here to save any changes made to your customer information."src="<%=AssetsPath()%>/save-changes2.gif"onclick="SubmitFcn()" style="cursor:pointer" id="savechangesbtn" name="savechangesbtn">
 <img src="<%=AssetsPath()%>/cancel2.gif"onclick="location.reload()" style="cursor:pointer">
 </div>
<table width="545"border="0" frame="none" cellpadding="0" cellspacing="0">
<tr><td width="270"height="55">
</td><td width="275"></td>
</tr><tr><td width="270">

<%'Copy Sign-in Credentials Textarea
    If Session("SuperPowerUserName") <> "" Then
     Dim varCopyText As String = ""
     varCopyText = "Here are your sign-in credentials:"
     varCopyText = varCopyText & vbCrLf & vbCrLf & "Email: " & defaultSignInEmail
     varCopyText = varCopyText & vbCrLf & "Password: " & defaultPword
     varCopyText = varCopyText & vbCrLf & vbCrLf & "The password is not case-sensitive (you can type lowercase or uppercase letters)."
     varCopyText = varCopyText & vbCrLf & vbCrLf & "You can sign in at https://www.millionsofrecords.com/options.aspx"

%>
 <div style="position:absolute;visibility:hidden"id="SignInCredentialsEmailDiv">
 <textarea style="width:400px;height:190px"id="SignInCredentialsEmailText"><%=varCopyText%></textarea>
 </div>
<% End If%>

</td><td width="275"height="30"align="left"valign="top">
<p class="title"style="margin-left:7px">Shipping Address</p>
<%'Full Name%>
</td></tr><tr><td width="270"align="right">
<font class="a"style="color:#FA0006">*</font>
<%if FullNameMessage= "" then%>
 <font class="a">Full Name</font>
<%else%>
 <font class="b">Full Name</font>
<%end if%>
</td><td width="275" align="left">
<input autocomplete="something-new" class="i" type="text" maxlength="120" onkeyup="sch()"value="<%=defaultFullName%>" name="FullName"id="FullName">
</td></tr><tr>
<%'StreetAddress1 %>
<td width="270" align="right">
<font class="a"style="color:#FA0006">*</font>
<font class="a">Street Address Line 1</font>
</td><td width="275" align="left">
<input autocomplete="something-new" class="i" type="text" maxlength="100" onkeyup="sch()"value="<%=defaultStreetAddress1%>" name="StreetAddress1"id="StreetAddress1">
</td></tr><tr>
<%'StreetAddress2 %>
<td width="270" align="right">
<font class="a">Street Address Line 2</font>
</td><td width="275" align="left">
<input autocomplete="something-new" class="i" type="text" maxlength="100" onkeyup="sch()"value="<%=defaultStreetAddress2%>" name="StreetAddress2"id="StreetAddress2">
</td></tr>
<%'City %>
<%if varCityRequired<>"n" then%>
 <tr><td width="270" align="right">
 <font class="a"style="color:#FA0006">*</font>
 <%if CityMessage= "" and MilitaryAddressMessage="" then%>
  <font class="a"><%=varCityWord%></font>
 <%else%>
  <font class="b"><%=varCityWord%></font>
 <%end if%>
 </td><td width="275"align="left">
 <input autocomplete="something-new" class="i" type="text" maxlength="100" onkeyup="sch()"value="<%=defaultCity%>" name="City"id="City">
 </td></tr>
<%end if%>
<%'Island %>
<%if defaultStateProvince="Virgin Islands (U.S.)" or varIslandRequired<>"n" then%>
 </td></tr><tr><td width="270"align="right">
 <%if defaultStateProvince="Virgin Islands (U.S.)" then%>
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
  <input autocomplete="something-new" class="i"  maxlength="50" type="text" onkeyup="sch()"value="<%=DefaultIsland%>" name="Island"id="Island">
 <%end if%>
<%end if%>
<%'StateProvince %>
<%if varStateProvinceRequired<>"n" then%>
 <tr><td width="270" align="right">
 <font class="a"style="color:#FA0006">*</font>
 <%if StateProvinceMessage= "" then%>
  <font class="a"><%=varStateProvinceWord%></font>
 <%else%>
  <font class="b"><%=varStateProvinceWord%></font>
 <%end if%>
 </td><td width="275"align="left">
 <% If varStateProvinceList = "y" Then%>
  <select class="i" onchange="sch()"name="StateProvince"id="StateProvince">
  <option value="<%=DefaultStateProvince%>"><%=DefaultStateProvince%>
  <%Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
    SqlConnection.ClearPool(conn)
    conn.Open()
    Dim CMD_Y As New SqlCommand("spGetWebCountryStateProvincesList", conn)
    CMD_Y.CommandType = Data.CommandType.StoredProcedure
    CMD_Y.Parameters.AddWithValue("@Country", defaultCountry)
    Dim readerY As SqlDataReader
    readerY = CMD_Y.ExecuteReader
    Do While readerY.Read%>
     <option value = "<%=readerY("StateProvince")%>"><%=readerY("StateProvince")%>
    <%Loop%>
  <%End Using%>
  </select>
 <%else%>
  <input autocomplete="something-new" class="i" maxlength="100" type="text" value="<%=DefaultStateProvince%>" name="StateProvince"id="StateProvince">
 <% End If%>
 </td></tr>
<%end if%>
<%'PostalCode %>
<%if varPostalCodeRequired<>"n" then%>
 <tr><td width="270" align="right">
 <font class="a"style="color:#FA0006">*</font>
 <%if PostalCodeMessage= "" Then%>
  <font class="a"><%=varPostalCodeWord%></font>
 <% Else%>
  <font class="b"><%=varPostalCodeWord%></font>
 <% End If%>
 </td><td width="275"align="left">
 <input autocomplete="something-new" class="i" maxlength="25" type="text" onkeyup="sch()"value="<%=DefaultPostalCode%>" name="PostalCode"id="PostalCode">
 </td></tr>
<% End If%>

<%'Country%>
<tr><td width="270" align="right">
<font class="a"style="color:#FA0006">*</font>
<%if CountryMessage= "" Then%>
 <font class="a">Country</font>
<%else%>
 <font class="b">Country</font>
<%end if%>
</td><td width="275"align="left">
<%if defaultCountry="" then%>
 <select onchange="CountryChanged()" class="i" name="Country"id="Country"><option>
<%else%>
 <select onchange="CountryChanged()" class="i" name="Country"id="Country"><option>USA
<%end If%>
<%
 Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
  SqlConnection.ClearPool(conn)
  conn.Open()
  Dim CMD_Y As New SqlCommand("spGetWebCountryShippingZonesT", conn)
  CMD_Y.CommandType = Data.CommandType.StoredProcedure
  Dim readerY As SqlDataReader
  readerY = CMD_Y.ExecuteReader
  Do While readerY.Read
   If defaultCountry = readerY("country") Then%>
    <option selected value="<%=readerY("country")%>"><%=readerY("country")%>
   <%Else%>
    <option value="<%=readerY("country")%>"><%=readerY("country")%>
   <%End If
  Loop
 End Using%>
</select></td></tr>
<%'Contact Information------------------- %>
<tr><td width="270">
</td><td width="275"height="35"align="left"valign="top">
</td></tr><tr><td width="270">
</td><td width="275"height="30"align="left"valign="top">
<p class="title"style="margin-left:7px">Contact Information</p>
<%'Email%>
</td></tr><td width="270" align="right">
<font class="a"style="color:#FA0006">*</font>
<%if EmailMessage= "" Then%>
 <font class="a">Email</font>
<%else%>
 <font class="b">Email</font>
<%end if%>
</td><td width="275" align="left">
<input autocomplete="something-new" class="i" type="text" maxlength="100" onkeyup="sch()"value="<%=DefaultEmail%>" name="Email"id="Email">
</td></tr><tr>
<%'Phone1%>
<tr><td width="270" align="right">
<font class="a"style="color:#FA0006">*</font>
<%if PhoneMessage= "" then%>
 <font class="a">Phone</font>
<%else%>
 <font class="b">Phone</font>
<%end if%>
</td><td width="275" align="left">
<input autocomplete="something-new" class="i" maxlength="25" type="text" onkeyup="sch()"value="<%=DefaultPhone%>" name="Phone"id="Phone">
</td></tr><tr>
<td width="270" align="right">
<%'Email and Phone Help Divs%>
<div onclick="HideHelpDivs()" class="s" style="margin-left:90px"id="PrimaryEmailDiv">
<font class="h">E-mail</font>
&nbsp;<font class="h"style="cursor:pointer;background-color:#EDED22;color:#000000">&nbsp;Close&nbsp;</font>
<br><br>
<font class="j">
Please enter the best E-mail address to reach you. When we need to E-mail you we'll try this E-mail first. If we can't reach you then we'll try the Secondary or Third E-mail.
</font>
</div>
<div onclick="HideHelpDivs()" class="s" style="margin-left:90px"id="PrimaryPhoneDiv">
<font class="h">&nbsp;Phone&nbsp;</font>
&nbsp;<font class="h"style="cursor:pointer;background-color:#EDED22;color:#000000">&nbsp;Close&nbsp;</font>
<br><br>
<font class="j">
Please enter the best phone number to reach you. When we need to phone you, we'll try this number first. If we can't reach you then we'll try the Secondary or Third phones.
</font>
</div>
</td><td width="275" align="left">
<%'CustomerID, etc ------------------------------------------
 If session("PowerUserName") <> "" Then%>
  </td></tr><tr>
  <td width="270" height="30">
  </td><td width="275" align="left">
  </td></tr><tr>
  <td width="270" align="right">
  <font class="a">Customer ID</font>
  </td><td width="275" align="left">
  <font class="a"style="margin-left:12px"><%=varCustomerID%></font>
  </td></tr><tr>
  <td width="270" align="right">
  <font class="a">Cust. Server Counter</font>
  </td><td width="275" align="left">
  <font class="a"style="margin-left:12px"><%=Session("CustomerServerCounter")%></font>
  </td></tr><tr>
  <td width="270" align="right">
  <font class="a">Account Created</font>
  </td><td width="275" align="left">
  <font class="a"style="margin-left:12px"><%=varAccountCreatedDate%></font>
  <input type="hidden"value="<%=varAccountCreatedDate%>"name="AccountCreatedDate"id="AccountCreatedDate">
 <%End If%>

</td></tr></table></td>
<td width="700"valign="top">
<%'Customer Billing Address--------------------------------------------------------------------------------------%>
<table width="700"border="0" frame="none" cellpadding="0" cellspacing="0" >
<%'Billing Full Name%>
<tr><td width="190"height="55">
</td><td width="510"></td>
</tr><tr><td width="190">
</td><td width="510"height="35"align="left"valign="top">
<table width="510"border="0" frame="none" cellpadding="0" cellspacing="0">
<tr><td width="158" align="left"valign="top">
<p class="title"style="margin-left:7px">Billing Address</p>
</td><td width="352" align="left"valign="top">
<img onclick="sameAsShipping()"title="Click here if your Billing Address is the same as your Shipping Address."style="border:0px;margin-left:0px;cursor:pointer;vertical-align:top;margin-top:2px"onmouseover="fovs(this,'same-as-shipping')"onmouseout="fous(this,'same-as-shipping')"src="<%=AssetsPath()%>/same-as-shipping.gif"></img>
</td></tr></table>
</td></tr><tr><td width="190"align="right">
<font class="a"style="color:#FA0006">*</font>
<%if BillingFullNameMessage= "" then%>
 <font class="a">Full Name</font>
<%else%>
 <font class="b">Full Name</font>
<%end if%>
</td><td width="510" align="left">
<input autocomplete="something-new" class="i" type="text" maxlength="120" onkeyup="sch()"value="<%=defaultBillingFullName%>" name="BillingFullName"id="BillingFullName">
</td></tr><tr>
<%'BillingStreetAddress1 %>
<td width="190" align="right">
<font class="a"style="color:#FA0006">*</font>
<font class="a">Street Address Line 1</font>
</td><td width="510" align="left">
<input autocomplete="something-new" class="i" type="text" maxlength="100" onkeyup="sch()"value="<%=defaultBillingStreetAddress1%>" name="BillingStreetAddress1"id="BillingStreetAddress1">
</td></tr><tr>
<%'BillingStreetAddress2 %>
<td width="190" align="right">
<font class="a">Street Address Line 2</font>
</td><td width="510" align="left">
<input autocomplete="something-new" class="i" type="text" maxlength="100" onkeyup="sch()"value="<%=defaultBillingStreetAddress2%>" name="BillingStreetAddress2"id="BillingStreetAddress2">
</td></tr>
<%'BillingCity %>
<%if varBillingCityRequired<>"n" then%>
 <tr><td width="190" align="right">
 <font class="a"style="color:#FA0006">*</font>
 <%if BillingCityMessage= "" and BillingMilitaryAddressMessage="" then%>
  <font class="a"><%=varBillingCityWord%></font>
 <%else%>
  <font class="b"><%=varBillingCityWord%></font>
 <%end if%>
 </td><td width="510"align="left">
 <input autocomplete="something-new" class="i" type="text" maxlength="100" onkeyup="sch()"value="<%=defaultBillingCity%>" name="BillingCity"id="BillingCity">
 </td></tr>
<%end if%>
<%'BillingIsland %>
<%if defaultBillingStateProvince="Virgin Islands (U.S.)" or varBillingIslandRequired<>"n" then%>
 </td></tr><tr><td width="190"align="right">
 <%if defaultBillingStateProvince="Virgin Islands (U.S.)" then%>
  <font class="a"style="color:#FA0006">*</font>
  <%if BillingIslandMessage= "" then%>
   <font class="a">Island</font>
  <%else%>
   <font class="b">Island</font>
  <%end if%>
  </td><td width="275"align="left">
  <select class="i"  onkeyup="sch()"name="BillingIsland"id="BillingIsland">
  <option value="<%=DefaultBillingIsland%>"><%=DefaultBillingIsland%>
  <option value="St. Croix">St. Croix
  <option value="St. John">St. John
  <option value="St. Thomas">St. Thomas
  </select>
 <%else%>
  <font class="a"style="color:#FA0006">*</font>
  <%if BillingIslandMessage= "" then%>
   <font class="a"><%=varBillingIslandWord%></font>
  <%else%>
   <font class="b"><%=varBillingIslandWord%></font>
  <%end if%>
  </td><td width="275"align="left">
  <input autocomplete="something-new" class="i"  maxlength="50" type="text" value="<%=DefaultBillingIsland%>" name="BillingIsland"id="BillingIsland">
 <%end if%>
<%end if%>
<%'BillingStateProvince %>
<%if varBillingStateProvinceRequired<>"n" then%>
 <tr><td width="190" align="right">
 <font class="a"style="color:#FA0006">*</font>
 <%if BillingStateProvinceMessage= "" Then%>
  <font class="a"><%=varBillingStateProvinceWord%></font>
 <% Else%>
  <font class="b"><%=varBillingStateProvinceWord%></font>
 <% End If%>
 </td><td width="510"align="left">
 <%if varBillingStateProvinceList="y" then%>
  <select class="i" onchange="sch()"name="BillingStateProvince"id="BillingStateProvince">
  <option value="<%=DefaultBillingStateProvince%>"><%=DefaultBillingStateProvince%>
  <%Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
    SqlConnection.ClearPool(conn)
    conn.Open()
    Dim CMD_Y As New SqlCommand("spGetWebCountryStateProvincesList", conn)
    CMD_Y.CommandType = Data.CommandType.StoredProcedure
    CMD_Y.Parameters.AddWithValue("@Country", defaultBillingCountry)
    Dim readerY As SqlDataReader
    readerY = CMD_Y.ExecuteReader
    Do While readerY.Read%>
     <option value="<%=readerY("StateProvince")%>"><%=readerY("StateProvince")%>
    <%Loop%>
  <%End Using%>
  </select>
 <%else%>
  <input autocomplete="something-new" class="i" maxlength="100" type="text" value="<%=DefaultBillingStateProvince%>" name="BillingStateProvince"id="BillingStateProvince">
 <% End If%>
 </td></tr>
<%end if%>
<%'BillingPostalCode %>
<%if varBillingPostalCodeRequired<>"n" then%>
 <tr><td width="190" align="right">
 <font class="a"style="color:#FA0006">*</font>
 <%if BillingPostalCodeMessage= "" then%>
  <font class="a"><%=varBillingPostalCodeWord%></font>
 <%else%>
  <font class="b"><%=varBillingPostalCodeWord%></font>
 <%end if%>
 </td><td width="510"align="left">
 <input autocomplete="something-new" class="i" maxlength="25" type="text" onkeyup="sch()"value="<%=DefaultBillingPostalCode%>" name="BillingPostalCode"id="BillingPostalCode">
 </td></tr>
<%end if%>

<%'BillingCountry%>
<tr><td width="190" align="right">
<font class="a"style="color:#FA0006">*</font>
<%if BillingCountryMessage= "" then%>
 <font class="a">Country</font>
<%else%>
 <font class="b">Country</font>
<%end if%>
</td><td width="510"align="left">
<% If defaultBillingCountry = "" Then%>
 <select onchange="BillingCountryChanged()" class="i" name="BillingCountry"id="BillingCountry"><option>
<%else%>
 <select onchange="BillingCountryChanged()" class="i" name="BillingCountry"id="BillingCountry"><option>USA
<%end If
  Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
   SqlConnection.ClearPool(conn)
   conn.Open()
   Dim CMD_Y As New SqlCommand("spGetWebCountryShippingZonesT", conn)
   CMD_Y.CommandType = Data.CommandType.StoredProcedure
   Dim readerY As SqlDataReader
   readerY = CMD_Y.ExecuteReader
   Do While readerY.Read
    If defaultBillingCountry = readerY("country") Then%>
   <option selected value="<%=readerY("country")%>"><%=readerY("country")%>
   <%Else%>
    <option value="<%=readerY("country")%>"><%=readerY("country")%>
   <%End If
   Loop
  End Using%>
</select>
</td></tr>
 <%'Sign-In Credentials-------------%>

 <%'Sign In Email%>
 <tr><td width="190">
 </td><td width="510"height="30"align="left"valign="top">
 </td></tr><tr><td width="190">
 </td><td width="510"height="30"align="left"valign="top">
 <p class="title"style="margin-left:7px">Sign-In Credentials</p>
 </tr><tr><td width="190" align="right">
 <font class="a"style="color:#FA0006">*</font>
 <%if SignInEmailMessage= "" Then%>
  <font class="a">Sign-In Email</font>
 <% Else%>
  <font class="b">Sign-In Email</font>
 <%end if%>
 </td><td width="510"align="left">
 <input autocomplete="something-new" class="i" type="text" maxlength="100" onkeyup="sch()"value="<%=defaultSignInEmail%>" name="SignInEmail"id="SignInEmail">
 <%If Session("SuperPowerUserName") <> "" Then%>
  <div style="position:absolute;margin-left:195px;margin-top:-60px">
  <img src="<%=AssetsPath()%>/copy.gif"style="cursor:pointer;vertical-align:bottom"onclick="copySignInCredentials()" /><img src="<%=AssetsPath()%>/success.gif"style="margin-left:5px;visibility:hidden;vertical-align:bottom"id="SignInCredentialsSuccess" />
  </div>
  <font class="a"style="margin-left:2px;margin-top:30px;color:#5459FD;font-size:12px;text-decoration:underline;cursor:pointer"onclick="showForgotPasswordDiv()">Email Sign-In Credentials</font>
 <%End If%>
 </td></tr>
 <%'Password%>
 <tr><td width="190" align="right">
 <font class="a"style="color:#FA0006">*</font>
 <%if PwordMessage= "" Then%>
  <font class="a">Password</font>
 <%Else%>
  <font class="b">Password</font>
 <%end if%>
 </td><td width="510"align="left">
 <input autocomplete="something-new" class="i" type="password" maxlength="50" onkeyup="sch()"value="<%=defaultPword%>" name="PWord"id="PWord">
 </td></tr>
<%'Residential Delivery, etc ------------------------------------------
 If Session("PowerUserName") <> "" Then%>
 <tr><td width="190" height="30"align="right">
 </td><td width="510"align="left">
 </td></tr>
 <%'Residential Delivery%>
 <tr><td width="190" align="right">
 <%if ResidentialDeliveryMessage= "" Then%>
  <font class="a">Residential Delivery?</font>
 <% Else%>
  <font class="b">Residential Delivery?</font>
 <%end if%>
 </td><td width="510"align="left">
 <input autocomplete="something-new" class="i"style="width:30px" type="text" maxlength="1" onkeyup="sch()"value="<%=DefaultResidentialDelivery%>" name="ResidentialDelivery"id="ResidentialDelivery">
 <font class="a">[y or n]</font>
 <% If BlockedFromCheckoutMessage = "" Then%>
  <font class="a">
 <% Else%>
  <font class="b">
 <%end if%>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Blocked From Checkout?</font><input autocomplete="something-new" class="i"style="width:30px" type="text" maxlength="1" onkeyup="sch()"value="<%=DefaultBlockedFromCheckout%>" name="BlockedFromCheckout"id="BlockedFromCheckout">
 <font class="a">[y or n]</font>
 </td></tr>
 <%'Charge Sales Tax%>
 <tr><td width="190" align="right">
 <%if ChargeSalesTaxMessage= "" Then%>
  <font class="a">Charge Sales Tax?</font>
 <% Else%>
  <font class="b">Charge Sales Tax?</font>
 <%end if%>
 </td><td width="510"align="left">
 <input autocomplete="something-new" class="i"style="width:100px" type="text" maxlength="1" onkeyup="sch()"value="<%=defaultChargeSalesTax%>" name="ChargeSalesTax"id="ChargeSalesTax">
 <font class="a">[n or blank]</font>
 </td></tr>
 <%'Price Group%>
 <tr><td width="190" align="right">
 <%if PriceGroupMessage= "" Then%>
  <font class="a">Price Group</font>
 <%else%>
  <font class="b">Price Group</font>
 <%end if%>
 </td><td width="510"align="left">
 <input autocomplete="something-new" class="i"style="width:100px" type="text" maxlength="20" onkeyup="sch()"value="<%=DefaultPriceGroup%>" name="PriceGroup"id="PriceGroup">
 </td></tr>
<%else%>
 <input type="hidden"value="<%=DefaultResidentialDelivery%>"name="ResidentialDelivery"id="ResidentialDelivery">
 <input type="hidden"value="<%=DefaultBlockedFromCheckout%>"name="BlockedFromCheckout"id="BlockedFromCheckout">
 <input type="hidden"value="<%=defaultChargeSalesTax%>"name="ChargeSalesTax"id="ChargeSalesTax">
 <input type="hidden"value="<%=DefaultPriceGroup%>"name="PriceGroup"id="PriceGroup">
<% End If%>

 <%If Session("PowerUserName") <> "" Then%>
  <tr><td width="190" height="20"align="right">
  </td><td width="510"align="left">
  </td></tr>
 <%End If%>
 <tr><td width="190" align="right">
 </td><td width="510"align="left">
 </form>
 </td></tr></table>
 </td></tr></table>


<%'PowerUser Payment Options---------------------------------------------------------------------------
 If session("PowerUserName") <> "" Then%>
 <table width="1250"border="0" cellpadding="0" cellspacing="0" bgcolor="D4DBD4"align="center"valign="middle">
 <tr><td width="1250"height="85">
 </td></tr><tr><td width="1250"height="28"align="center"valign="middle">
 <p Class="title"style="text-align:center;vertical-align:middle">Payment Options</p>
 </td></tr></table>

 <%
  If defaultCountry = "NA" Then
   defaultCountry = defaultCountry
  End If
  Dim varTermsOfSale201 As Integer = 0
  Dim varTermsOfSale301 As Integer = 0
  Dim varTermsOfSale501 As Integer = 0
  Dim varTermsOfSale601 As Integer = 0
  Dim varTermsOfSale707 As Integer = 0
  Dim varTermsOfSale710 As Integer = 0
  Dim varTermsOfSale715 As Integer = 0
  Dim varTermsOfSale730 As Integer = 0
  Dim varNumberOfPaymentMethods As Integer = 0
  Dim xType As Integer = 0
  Dim strSQL As String = ""
  Dim varCustomerIDForPaymentOptions As String = varCustomerID
  Dim varLastType As Integer = 0
  Dim varLegitRemoval As Integer = 0
  Dim varSideWidth As Integer = 0

  'TermsOfSaleTypes Table
  If varPriceGroup = "RetailPrice" Then
   If defaultCountry = "USA" Then
    strSQL = "select [Type] from TermsOfSaleTypes" _
     & " where RetailUSA='y'"
   Else
    strSQL = "select [Type] from TermsOfSaleTypes" _
     & " where RetailInternational='y'"
   End If
  Else
   If defaultCountry = "USA" Then
    strSQL = "select [Type] from TermsOfSaleTypes" _
     & " where WholesaleUSA='y'"
   Else
    strSQL = "select [Type] from TermsOfSaleTypes" _
   & " where WholesaleInternational='y'"
   End If
  End If
  Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
   SqlConnection.ClearPool(conn)
   conn.Open()
   Dim CMD_X As New SqlCommand(strSQL, conn)
   CMD_X.CommandType = Data.CommandType.Text
   Dim xx As SqlDataReader
   xx = CMD_X.ExecuteReader
   Do While xx.Read
    xType = xx("Type")
    If xType = 201 Then
     varTermsOfSale201 = 1
     varNumberOfPaymentMethods = varNumberOfPaymentMethods + 1
    ElseIf xType = 301 Then
     varTermsOfSale301 = 1
     varNumberOfPaymentMethods = varNumberOfPaymentMethods + 1
    ElseIf xType = 501 Then
     varTermsOfSale501 = 1
     varNumberOfPaymentMethods = varNumberOfPaymentMethods + 1
    ElseIf xType = 601 Then
     varTermsOfSale601 = 1
     varNumberOfPaymentMethods = varNumberOfPaymentMethods + 1
    ElseIf xType = 707 Then
     varTermsOfSale707 = 1
     varNumberOfPaymentMethods = varNumberOfPaymentMethods + 1
    ElseIf xType = 710 Then
     varTermsOfSale710 = 1
     varNumberOfPaymentMethods = varNumberOfPaymentMethods + 1
    ElseIf xType = 715 Then
     varTermsOfSale715 = 1
     varNumberOfPaymentMethods = varNumberOfPaymentMethods + 1
    ElseIf xType = 730 Then
     varTermsOfSale730 = 1
     varNumberOfPaymentMethods = varNumberOfPaymentMethods + 1
    End If
   Loop
  End Using
  'TermsOfSaleTypesAdditions
  If Not IsNumeric(varCustomerID) Then varCustomerIDForPaymentOptions = "0"
  Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
   SqlConnection.ClearPool(conn)
   conn.Open()
   Dim CMD_X As New SqlCommand("spTermsOfSaleTypesAdditions", conn)
   CMD_X.CommandType = Data.CommandType.StoredProcedure
   CMD_X.Parameters.AddWithValue("@CustID", varCustomerIDForPaymentOptions)
   Dim xx As SqlDataReader
   xx = CMD_X.ExecuteReader
   If xx.HasRows Then
    Do While xx.Read
     xType = xx("Type")
     If xType = 201 Then
      If varTermsOfSale201 = 0 Then varNumberOfPaymentMethods = varNumberOfPaymentMethods + 1
      varTermsOfSale201 = 1
     ElseIf xType = 301 Then
      If varTermsOfSale301 = 0 Then varNumberOfPaymentMethods = varNumberOfPaymentMethods + 1
      varTermsOfSale301 = 1
     ElseIf xType = 501 Then
      If varTermsOfSale501 = 0 Then varNumberOfPaymentMethods = varNumberOfPaymentMethods + 1
      varTermsOfSale501 = 1
     ElseIf xType = 601 Then
      If varTermsOfSale601 = 0 Then varNumberOfPaymentMethods = varNumberOfPaymentMethods + 1
      varTermsOfSale601 = 1
     ElseIf xType = 707 Then
      If varTermsOfSale707 = 0 Then varNumberOfPaymentMethods = varNumberOfPaymentMethods + 1
      varTermsOfSale707 = 1
     ElseIf xType = 710 Then
      If varTermsOfSale710 = 0 Then varNumberOfPaymentMethods = varNumberOfPaymentMethods + 1
      varTermsOfSale710 = 1
     ElseIf xType = 715 Then
      If varTermsOfSale715 = 0 Then varNumberOfPaymentMethods = varNumberOfPaymentMethods + 1
      varTermsOfSale715 = 1
     ElseIf xType = 730 Then
      If varTermsOfSale730 = 0 Then varNumberOfPaymentMethods = varNumberOfPaymentMethods + 1
      varTermsOfSale730 = 1
     End If
    Loop
   End If
  End Using
  'TermsOfSaleTypesRemovals
  Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
   SqlConnection.ClearPool(conn)
   conn.Open()
   Dim CMD_X As New SqlCommand("spTermsOfSaleTypesRemovals", conn)
   CMD_X.CommandType = Data.CommandType.StoredProcedure
   CMD_X.Parameters.AddWithValue("@CustID", varCustomerIDForPaymentOptions)
   Dim xx As SqlDataReader
   xx = CMD_X.ExecuteReader
   If xx.HasRows Then
    varLastType = 0
    Do While xx.Read
     varLegitRemoval = 0
     If UCase(xx("AddOrRemove")) = "REMOVE" And Int(xx("Type")) <> Int(varLastType) Then
      varLegitRemoval = 1
     End If
     xType = Int(xx("Type"))
     If varLegitRemoval = 1 Then
      If xType = 201 Then
       If varTermsOfSale201 = 1 Then varNumberOfPaymentMethods = varNumberOfPaymentMethods - 1
       varTermsOfSale201 = 0
      ElseIf xType = 301 Then
       If varTermsOfSale301 = 1 Then varNumberOfPaymentMethods = varNumberOfPaymentMethods - 1
       varTermsOfSale301 = 0
      ElseIf xType = 501 Then
       If varTermsOfSale501 = 1 Then varNumberOfPaymentMethods = varNumberOfPaymentMethods - 1
       varTermsOfSale501 = 0
      ElseIf xType = 601 Then
       If varTermsOfSale601 = 1 Then varNumberOfPaymentMethods = varNumberOfPaymentMethods - 1
       varTermsOfSale601 = 0
      ElseIf xType = 707 Then
       If varTermsOfSale707 = 1 Then varNumberOfPaymentMethods = varNumberOfPaymentMethods - 1
       varTermsOfSale707 = 0
      ElseIf xType = 710 Then
       If varTermsOfSale710 = 1 Then varNumberOfPaymentMethods = varNumberOfPaymentMethods - 1
       varTermsOfSale710 = 0
      ElseIf xType = 715 Then
       If varTermsOfSale715 = 1 Then varNumberOfPaymentMethods = varNumberOfPaymentMethods - 1
       varTermsOfSale715 = 0
      ElseIf xType = 730 Then
       If varTermsOfSale730 = 1 Then varNumberOfPaymentMethods = varNumberOfPaymentMethods - 1
       varTermsOfSale730 = 0
      End If
     End If
     varLastType = xx("Type")
    Loop
   End If
  End Using
  varSideWidth = Int((1250 - varNumberOfPaymentMethods * 132 - (varNumberOfPaymentMethods - 1) * 6) / 2)
 %>
<table border="0" cellpadding="0" cellspacing="0" border="0" align="center" width="1250" bgcolor="D4DBD4">
<tr valign="top">
 <td valign="top" height="105"width="1250" align="left">
 <div style="position:absolute;visibility:hidden;display:none;width:1250px;text-align:center;vertical-align:middle"name="ZeroDueDiv"id="ZeroDueDiv">
 <img src="<%=AssetsPath()%>/processorderzerodue4.gif"title="Click here to process this order (your amount due is $0.00)."style="cursor:pointer"onclick="ProcessOrderZeroDueFnc()">
 </div>
 <div style="position:absolute;visibility:visible;display:inline;width:1250px;text-align:center;vertical-align:top;padding-top:5px"name="PaymentButtonsDiv"id="PaymentButtonsDiv">
 <table width="1250" cellpadding="0"cellspacing="0" align="center" border="0">
 <tr valign="top">
 <td align="left">
 <%
   'Credit Card
   If varTermsOfSale201 = 1 Then%>
  </td><td align="center" nowrap width="132"style="text-align:center;vertical-align:middle">
  <img alt border="0" name="PayByCreditCardBtn" id="PayByCreditCardBtn" onclick="removePaymentMethod('201')"style="cursor:pointer" title="Click here to remove this payment method" src="<%=AssetsPath()%>/paybycreditcard4h.gif">
 <%Else%>
  </td><td align="center" nowrap width="132"style="text-align:center;vertical-align:middle">
  <img alt border="0" name="PayByCreditCardBtn" id="PayByCreditCardBtn" onclick="addPaymentMethod('201')"style="cursor:pointer" title="Click here to add this payment method" src="<%=AssetsPath()%>/paybycreditcard4.gif">
 <%end if
 'PayPal
 if varTermsOfSale301=1 then%>
  </td><td align="center" nowrap width="132"style="text-align:center;vertical-align:middle">
  <img alt border="0" name="PayByPayPalBtn" id="PayByPayPalBtn" onclick="removePaymentMethod('301')"style="cursor:pointer" title="Click here to remove this payment method" src="<%=AssetsPath()%>/PayByPayPal4h.gif">
 <%Else%>
  </td><td align="center" nowrap width="132"style="text-align:center;vertical-align:middle">
  <img alt border="0" name="PayByPayPalBtn" id="PayByPayPalBtn" onclick="addPaymentMethod('301')"style="cursor:pointer" title="Click here to add this payment method" src="<%=AssetsPath()%>/PayByPayPal4.gif">
 <% End If
  'Bank Transfer
  If varTermsOfSale501 = 1 Then%>
  </td><td align="center" nowrap width="132"style="text-align:center;vertical-align:middle">
  <img alt border="0" name="PayByBankWireBtn" id="PayByBankWireBtn" onclick="removePaymentMethod('501')"style="cursor:pointer" title="Click here to remove this payment method" src="<%=AssetsPath()%>/paybybanktransfer4h.gif">
 <%Else%>
  </td><td align="center" nowrap width="132"style="text-align:center;vertical-align:middle">
  <img alt border="0" name="PayByBankWireBtn" id="PayByBankWireBtn" onclick="addPaymentMethod('501')"style="cursor:pointer" title="Click here to add this payment method" src="<%=AssetsPath()%>/paybybanktransfer4.gif">
 <% End If
  'Pre-pay By Mail
  If varTermsOfSale601 = 1 Then%>
  </td><td align="center" nowrap width="132"style="text-align:center;vertical-align:middle">
  <img alt border="0" name="PayByCheckCashOrMoneyOrderBtn" id="PayByCheckCashOrMoneyOrderBtn" onclick="removePaymentMethod('601')" style="cursor:pointer" title="Click here to remove this payment method" src="<%=AssetsPath()%>/paybymail4h.gif">
  <%Else%>
  </td><td align="center" nowrap width="132"style="text-align:center;vertical-align:middle">
  <img alt border="0" name="PayByCheckCashOrMoneyOrderBtn" id="PayByCheckCashOrMoneyOrderBtn" onclick="addPaymentMethod('601')" style="cursor:pointer" title="Click here to add this payment method" src="<%=AssetsPath()%>/paybymail4.gif">
 <% End If
  '7 Days Net
  If varTermsOfSale707 = 1 Then%>
  </td><td align="center" nowrap width="132"style="text-align:center;vertical-align:middle">
  <img alt border="0" name="PayBy7DaysNetBtn" id="PayBy7DaysNetBtn" onclick="removePaymentMethod('707')" style="cursor:pointer" title="Click here to remove this payment method" src="<%=AssetsPath()%>/payby7daysnet4h.gif">
  <%Else%>
  </td><td align="center" nowrap width="132"style="text-align:center;vertical-align:middle">
  <img alt border="0" name="PayBy7DaysNetBtn" id="PayBy7DaysNetBtn" onclick="addPaymentMethod('707')" style="cursor:pointer" title="Click here to add this payment method" src="<%=AssetsPath()%>/payby7daysnet4.gif">
 <% End If
  '10 Days Net
  If varTermsOfSale710 = 1 Then%>
  </td><td align="center" nowrap width="132"style="text-align:center;vertical-align:middle">
  <img alt border="0" name="PayBy10DaysNetBtn" id="PayBy10DaysNetBtn" onclick="removePaymentMethod('710')" style="cursor:pointer" title="Click here to remove this payment method" src="<%=AssetsPath()%>/payby10daysnet4h.gif">
  <%Else%>
  </td><td align="center" nowrap width="132"style="text-align:center;vertical-align:middle">
  <img alt border="0" name="PayBy10DaysNetBtn" id="PayBy10DaysNetBtn" onclick="addPaymentMethod('710')" style="cursor:pointer" title="Click here to add this payment method" src="<%=AssetsPath()%>/payby10daysnet4.gif">
 <%end If
  '15 Days Net
  If varTermsOfSale715 = 1 Then%>
  </td><td align="center" nowrap width="132"style="text-align:center;vertical-align:middle">
  <img alt border="0" name="PayBy15DaysNetBtn" id="PayBy15DaysNetBtn" onclick="removePaymentMethod('715')" style="cursor:pointer" title="Click here to remove this payment method" src="<%=AssetsPath()%>/payby15daysnet4h.gif">
   <%Else%>
  </td><td align="center" nowrap width="132"style="text-align:center;vertical-align:middle">
  <img alt border="0" name="PayBy15DaysNetBtn" id="PayBy15DaysNetBtn" onclick="addPaymentMethod('715')" style="cursor:pointer" title="Click here to add this payment method" src="<%=AssetsPath()%>/payby15daysnet4.gif">
 <%end If
   '30 Days Net
   If varTermsOfSale730 = 1 Then%>
  </td><td align="center" nowrap width="132"style="text-align:center;vertical-align:middle">
  <img alt border="0" name="PayBy30DaysNetBtn" id="PayBy30DaysNetBtn" onclick="removePaymentMethod('730')"style="cursor:pointer" title="Click here to remove this payment method" src="<%=AssetsPath()%>/payby30daysnet4h.gif">
   <%Else%>
  </td><td align="center" nowrap width="132"style="text-align:center;vertical-align:middle">
  <img alt border="0" name="PayBy30DaysNetBtn" id="PayBy30DaysNetBtn" onclick="addPaymentMethod('730')"style="cursor:pointer" title="Click here to add this payment method" src="<%=AssetsPath()%>/payby30daysnet4.gif">
 <% End If%>
 </td><td align="center">
 </td></tr>
 </table>
 </div>
</td></tr></table>

<%end if%>

<%'Credit Cards------------------------------------------------------------------------------------------------------------------------------- 
 If Request("FromCreditCardsForm") = "yes" Or Request.QueryString("deletecard") <> "" Then
  divChangesMadeVisibilityCC = "visible"
  divChangesMadeDisplayCC = "inline"
 End If%>
<table width="1250"border="0" cellpadding="0" cellspacing="0" bgcolor="D4DBD4"align="center"valign="bottom">
<tr><td height="25">
</td></tr></table>
<table width="1250"border="0" cellpadding="0" cellspacing="0" bgcolor="D4DBD4"align="center"valign="bottom">
<form name="frmCreditCards" onsubmit="return Validation(this)" action="/CustomerInfo.aspx" method="post">
<input type="hidden" name="CCCounterTxt"id="CCCounterTxt" value="<%=DefaultCCCounter%>">
<input type="hidden" name="FromCreditCardsForm" id="FromCreditCardsForm"value="yes">
<input type="hidden" name="ReturnToPurchase2"id="ReturnToPurchase2" value="<%=varReturnToPurchase%>">
<tr><td width="320">
</td><td width="610"style="text-align:left;vertical-align:top">
<div id="divChangesSavedCC"name="divChangesSavedCC"style="z-index:20000;margin-left:-130px;margin-top:0px;border:0px;vertical-align:top;text-align:left;width:116px;height:84px;position:absolute;display:<%=divChangesMadeDisplayCC%>;visibility:<%=divChangesMadeVisibilityCC%>">
<img alt=""title="Your changes have been saved"src="<%=AssetsPath()%>/changes-saved.gif" />
</div>
<table align="center" bgcolor="9BAF9B" width="610"style="border-top:1px solid #6C746B;border-left:1px solid #474646;border-right:1px solid #474646;border-radius:3px">
<tr><td height="33"style="text-align:center;vertical-align:middle">
<p style="font-weight:600;font-size:18px;color:#000000">Your Credit Cards</p>
</td></tr></table>
<table align="center" bgcolor="D4DBD4" WIDTH="610"style="border-top:1px solid #6C746B;border-bottom:1px solid #6C746B;border-left:1px solid #6C746B;border-right:1px solid #6C746B;border-radius:3px">
 <%Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
     SqlConnection.ClearPool(conn)
     conn.Open()
     Dim CMD_X As New SqlCommand("spPreviousCreditCardsUsed", conn)
     CMD_X.CommandType = Data.CommandType.StoredProcedure
     CMD_X.Parameters.AddWithValue("@CustomerServerCounter", Session("CustomerServerCounter"))
     Dim xx As SqlDataReader
     xx = CMD_X.ExecuteReader
     strHeightOfAddCardTD = "70"
     If xx.HasRows Then
      strHeightOfAddCardTD = "44" %>
    <tr><td width="145"height="9"></td><td width="70"></td><td width="10"></td><td width="385"></td></tr>
    <%Do While xx.Read
     intN = intN + 1
     intCCCounter = xx("MaxOfCounter")
     Using conn2 As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
      SqlConnection.ClearPool(conn2)
      conn2.Open()
      Dim CMD_X2 As New SqlCommand("spDecryptPreviousCreditCardUsed", conn2)
      CMD_X2.CommandType = Data.CommandType.StoredProcedure
      CMD_X2.Parameters.AddWithValue("@counter", xx("MaxOfCounter"))
      CMD_X2.Parameters.AddWithValue("@EncryptionKey", ConfigurationManager.AppSettings("EncryptionKey").ToString)
      Dim xx2 As SqlDataReader
      xx2 = CMD_X2.ExecuteReader
      xx2.Read()
      strPreviousCCNumber = xx2("CCNumber")
      strPreviousCVV2 = xx2("CVV2")
      strPreviousExpMonth = Left(xx2("ExpDate"), 2)
      If strPreviousExpMonth = "01" Then
       strPreviousExpMonth = "01 (Jan)"
      ElseIf strPreviousExpMonth = "02" Then
       strPreviousExpMonth = "02 (Feb)"
      ElseIf strPreviousExpMonth = "03" Then
       strPreviousExpMonth = "03 (Mar)"
      ElseIf strPreviousExpMonth = "04" Then
       strPreviousExpMonth = "04 (Apr)"
      ElseIf strPreviousExpMonth = "05" Then
       strPreviousExpMonth = "05 (May)"
      ElseIf strPreviousExpMonth = "06" Then
       strPreviousExpMonth = "06 (Jun)"
      ElseIf strPreviousExpMonth = "07" Then
       strPreviousExpMonth = "07 (Jul)"
      ElseIf strPreviousExpMonth = "08" Then
       strPreviousExpMonth = "08 (Aug)"
      ElseIf strPreviousExpMonth = "09" Then
       strPreviousExpMonth = "09 (Sep)"
      ElseIf strPreviousExpMonth = "10" Then
       strPreviousExpMonth = "10 (Oct)"
      ElseIf strPreviousExpMonth = "11" Then
       strPreviousExpMonth = "11 (Nov)"
      ElseIf strPreviousExpMonth = "12" Then
       strPreviousExpMonth = "12 (Dec)"
      End If
      strPreviousExpYear = "20" & Right(xx2("ExpDate"), 2)
     End Using
     If Session("SuperPowerUserName") <> "" Then
      strCreditCardNumberForDisplay = strPreviousCCNumber
     Else
      strCreditCardNumberForDisplay = "xxxx xxxx xxxx " & xx("RightFour")
     End If
      %>
     <tr><td width="145"style="text-align:right;vertical-align:middle">
     <%Response.Write("<img src=""" + AssetsPath() + "/delete-this-card.gif"" style=""cursor:pointer;vertical-align:middle""onclick=""DeleteCard('" & xx("RightFour") & "')"">")%>
     </td><td width="70"style="text-align:right;vertical-align:middle">
     <%Response.Write("<img src=""" + AssetsPath() + "/edit4.gif"" style=""cursor:pointer;vertical-align:middle""onclick=""EditCCNumber('201','" & strCreditCardNumberForDisplay & "','" & strPreviousCVV2 & "','" & strPreviousExpMonth & "','" & strPreviousExpYear & "','" & intN & "','" & intCCCounter & "')"">")%>
     </td><td width="10">
     </td><td width="385"style="text-align:left;vertical-align:middle">
     <p Class="use-card"style="vertical-align:middle">Credit/Debit Card ending ...<%=xx("RightFour")%></p>
     </td></tr>
      <%If intN = 4 Then Exit Do
     Loop%>
     <%End If%>
     </tr><tr><td width="145"height="<%=strHeightOfAddCardTD%>"></td><td width="70"></td><td width="10"></td><td width="385"style="vertical-align:middle;text-align:left">
     <img onclick="AddNewCard()"src="<%=AssetsPath()%>/add-new-card.gif"style="cursor:pointer"/>
     </td></tr><tr><td width="145"height="9"></td><td width="70"></td><td width="10"></td><td width="385"></td></tr>
    <%End Using%>
    </table>
    </td><td width="320">
     </td></tr></table>


<%'Credit Card Div
    If Request("FromCreditCardsForm") = "yes" Then
     varVisible = "hidden"
    Else
     varVisible = "hidden"
    End If%>
<table align="center" bgcolor="D4DBD4" WIDTH="1250">
<tr><td align="left">
<div name="CreditCardDiv" id="CreditCardDiv" style="margin-left:445px;margin-top:-311px;background-color:#EAF2EA;padding:0px;border:2px solid #516B51;border-radius:12px;text-align:left;z-index:10000;vertical-align:top;position:absolute;width:380px;height:250px;display:none;visibility:<%=varVisible%>">
<table border="0" cellspacing="0" align="left" cellpadding="0" width="380">
<tr><td height="30" width="380"style="vertical-align:bottom;text-align:right">
<img alt=""title="Close this window."style="margin-bottom:0px;margin-right:14px;cursor:pointer"onclick="hideCreditCardDiv()"onmouseover="fovs(this,'close-new-credit-card')"onmouseout="fous(this,'close-new-credit-card')"src="<%=AssetsPath()%>/close-new-credit-card.gif" />
</td></tr><tr><td height="50" width="380"style="vertical-align:bottom;text-align:left">
&nbsp;<font class="a-credit-card" style="font-size:13px;margin-left:45px">Credit Card Number</font>
<br/><input autocomplete="off" style="vertical-align:top;color:#000000;font-size:14px;width:240px;border-radius:8px;border:1px solid #6D7A6D;height:29px;padding-left:6px;margin-top:2px;margin-left:45px" type="text" maxlength="30" value="<%=DefaultCCNumber%>" name="CCNumber"id="CCNumber">
</td></tr><tr><td height="75" width="380"style="vertical-align:bottom;text-align:left">
<table border="0" cellspacing="0" align="left" cellpadding="0" width="380">
<tr><td height="65"width="200"style="vertical-align:bottom;text-align:left">
&nbsp;<font class="a-credit-card" style="font-size:13px;margin-left:45px">Expiration Date</font>
<br/>
<select ONCHANGE="document.PU.submit1.focus()" style="vertical-align:top;color:#000000;font-size:14px;width:96px;border-radius:8px;border:1px solid #6D7A6D;height:29px;padding-left:6px;margin-top:2px;margin-left:45px" name="ExpMonth"id="ExpMonth">
<%
    Response.Write("<option><option>01 (Jan)<option>02 (Feb)<option>03 (Mar)<option>04 (Apr)<option>05 (May)<option>06 (Jun)<option>07 (Jul)<option>08 (Aug)<option>09 (Sep)<option>10 (Oct)<option>11 (Nov)<option>12 (Dec)</select>")
 %>
<select ONCHANGE="document.PU.submit1.focus()" style="vertical-align:top;color:#000000;font-size:14px;width:70px;border-radius:8px;border:1px solid #6D7A6D;height:29px;padding-left:6px;margin-top:2px" name="ExpYear"id="ExpYear"><option>
<% For n = 0 To 20
     Response.Write("<option>" & Year(Now) + n)
    Next%>
   </select>
</td><td width="150"style="vertical-align:bottom;text-align:left">
&nbsp;<font class="a-credit-card" style="font-size:13px;vertical-align:bottom;margin-left:30px">CVV2</font>
<img onclick="showCVV2HelpDiv()" title="What is a CVV2 Code?" style="vertical-align:bottom;margin-left:3px;margin-bottom:0px;cursor:pointer" src="<%=AssetsPath()%>/cvv2-question2.gif"/>
<br/><input style="vertical-align:top;color:#000000;font-size:14px;width:80px;border-radius:8px;border:1px solid #6D7A6D;height:29px;padding-left:6px;margin-top:2px;margin-left:30px" type="text" autocomplete="off"maxlength="5" value="<%=DefaultCVV2Number%>" name="txtCVV2"id="txtCVV2">
</td></tr><tr><td height="60" width="200"style="vertical-align:bottom;text-align:left">
<input type="image" style="margin-left:45px"ONCLICK="SubmitCC()" src="<%=AssetsPath()%>/submit20.gif" id="SubmitCCBtn" name="SubmitCCBtn">
</td><td width="150"></td></tr></table>
</td></tr></table>
</div>
<%'CVV2 Help Div%>
<div id="divCVV2Help"name="divCVV2Help"onclick="hideCVV2HelpDiv()"style="z-index:20000;cursor:pointer;margin-left:363px;margin-top:-790px;border:0px;vertical-align:top;text-align:left;width:525;height:470px;position:absolute;display:none;visibility:hidden"onclick="hideCVV2HelpDiv()">
<table width="525"style="text-align:left;vertical-align:top;background-image:url('<%=AssetsPath()%>/cvv2-help-bg.gif');background-repeat:no-repeat"border="0"cellpadding="0"cellspacing="0"frame="void">
<tr><td width="525"height="470"align="right"valign="top"style="text-align:right;vertical-align:top">
<img alt=""title="Close this window."style="margin-top:12px;margin-right:16px;cursor:pointer"onclick="hideCVV2HelpDiv()"onmouseover="fovs(this,'close-cvv2-help')"onmouseout="fous(this,'close-cvv2-help')"src="<%=AssetsPath()%>/close-cvv2-help.gif" />
</td></tr></table>
</div>

</td></tr></table>










</form>
</td></tr></table>

<%'PowerUser Customer Interaction Notes--------------------------------------------------------------------------------------------------------
    If session("PowerUserName") <> "" And Session("StoreName") <> "" Then%>
 <table width="1250"border="0" cellpadding="0" cellspacing="0" bgcolor="D4DBD4"align="center"valign="bottom">
 <tr><td height="10">
 </td></tr></table>
 <table width="1250"border="0" cellpadding="0" cellspacing="0" bgcolor="D4DBD4"align="center"valign="bottom">
 <form name="CI" id="CI"action="/CustomerInfo.aspx" method="post">
 <input type="hidden"name="CICounter"id="CICounter"value="">
 <input type="hidden"name="JavascriptRandomNumber"id="JavascriptRandomNumber"value="">
 <input type="hidden"name="CIJavascriptRandomNumber"id="CIJavascriptRandomNumber"value="">
<input type="hidden" name="ReturnToPurchase3"id="ReturnToPurchase3" value="<%=varReturnToPurchase%>">
 <tr><td width="50%"align="left"valign="bottom">
 <font class="a"style="font-weight:900;font-size:16px;padding-left:50px">Customer Interaction:</font>
 </td><td width="50%"align="right"valign="bottom">
 </tr></table>
 <table style="padding-top:3px"border="0" cellpadding="0" cellspacing="0" align="center" bgcolor="D4DBD4" width="1250">
 <tr><td width="50"valign="top"align="left">
 </td><td width="880">
 <table style="border-collapse:collapse;border:1px solid #869786"bgcolor="E8F5E8"width="100%"border="1" cellpadding="0" cellspacing="0" align="center" bgcolor="D4DBD4">
 <tr bgcolor="ADCAAD">
 <td height="26"align="left"valign="middle"width="640"style="padding-left:8px;padding-bottom:4px;border-right:0px">
 <font class="a"style="font-size:12px">EB Rep:</font>
 <input type="text"name="CIEBRep"id="CIEBRep"style="padding-bottom:3px;color:#C80101;font-family:verdana,arial,helvetica,sans-serif;font-size:12px;width:70px;border:0px;background-color:#D0DFD0;border-left:3px solid #D0DFD0"maxlength="50"value="<%=session("PowerUserName")%>"></input>
 <font class="a"style="font-size:12px">Customer Rep:</font>
 <input type="text"name="CICustomerRep"id="CICustomerRep"style="padding-bottom:3px;color:#C80101;font-family:verdana,arial,helvetica,sans-serif;font-size:12px;width:200px;border:0px;background-color:#D0DFD0;border-left:3px solid #D0DFD0"maxlength="75"value=""></input>
  
<%
 Dim varCICount As Integer = 0
 Dim varAlreadyHadLast As Integer = 0
 Dim varCILastCustomerRep As String = ""
 Dim strPCustomerServerCounter As String = Session("CustomerServerCounter")
 If IsSomething(strPCustomerServerCounter, "") = "" Then
  strPCustomerServerCounter = "0"
 End If
 Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
  SqlConnection.ClearPool(conn)
  conn.Open()
  Dim CMD_Y As New SqlCommand("spGetCustomerInteractionForCustomer", conn)
  CMD_Y.CommandType = Data.CommandType.StoredProcedure
  CMD_Y.Parameters.AddWithValue("@CustomerServerCounter", CLng(strPCustomerServerCounter))
  Dim readerY As SqlDataReader
  readerY = CMD_Y.ExecuteReader
  If readerY.HasRows Then%>
   <img onclick="UseLastCustomerRep()"src="<%=AssetsPath()%>/samecustomerrep.gif"style="border:0px;vertical-align:middle;cursor:pointer"title="Copy the Customer Rep name from the most recent entry">
  <%End If%>
  </td><td height="26"align="right"valign="middle"width="240"style="padding-right:2px;padding-bottom:1px;border-left:0px">
  </td></tr></table>
  <table style="border-collapse:collapse;border-left:1px solid #869886;border-right:1px solid #869886;border-bottom:1px solid #869886"bgcolor="D4DBD4"width="100%"border="0" cellpadding="0" cellspacing="0" align="center" bgcolor="D4DBD4">
  <tr bgcolor="D4DBD4"><td height="60"align="left"valign="top"width="100%"style="padding:4px">
  <textarea onchange="UpdateCIEntry('0','0')"src="<%=AssetsPath()%>/insert.gif"wrap="physical"name="CINotes"id="CINotes"style="color:#C80101;font-family:verdana,arial,helvetica,sans-serif;font-size:12px;width:870px;height:60px;border:0px;background-color:#D4DBD4"></textarea>
  </td></tr></table>
  </td><td width="50"></td>
  </tr>
  </table>
  <%If readerY.HasRows Then
   varAlreadyHadLast = 0
   Do While readerY.Read%>
     <table border="0" cellpadding="0" cellspacing="0" align="center" bgcolor="D4DBD4" width="1250">
     <tr><td width="50">
     <%varCILastCustomerRep = IsDBSomething(readerY("CustomerRep"), "")
  If varCILastCustomerRep <> "" And varAlreadyHadLast = 0 Then
   varAlreadyHadLast = 1%>
      <input type="hidden"name="CILastCustomerRep"id="CILastCustomerRep"value="<%=varCILastCustomerRep%>">
     <%End If%>
     </td><td width="880">
     <br>
     <table style="border-collapse:collapse;border:1px solid #869786"bgcolor="E8F5E8"width="100%"border="1" cellpadding="0" cellspacing="0" align="center" bgcolor="D4DBD4">
     <tr bgcolor="ADCAAD">
     <td height="26"align="left"valign="middle"width="640"style="padding-left:8px;padding-bottom:4px;border-right:0px">
     <input type="text"onchange="UpdateCIEntry('<%=readerY("counter")%>','<%=readerY("JavascriptRandomNumber")%>')"name="CIDateTime<%=readerY("counter")%>"id="CIDateTime<%=readerY("counter")%>"style="color:#2C2C2C;font-weight:900;font-family:verdana,arial,helvetica,sans-serif;font-size:11px;width:170px;border:0px;background-color:#ADCAAD"maxlength="60"value="<%=readerY("DateTime")%>"></input>
     <input type="text"onchange="UpdateCIEntry('<%=readerY("counter")%>','<%=readerY("JavascriptRandomNumber")%>')"name="CIEBRep<%=readerY("counter")%>"id="CIEBRep<%=readerY("counter")%>"style="color:#2C2C2C;font-weight:900;font-family:verdana,arial,helvetica,sans-serif;font-size:11px;width:80px;border:0px;background-color:#ADCAAD"maxlength="50"value="<%=readerY("EBRep")%>"></input>
     <input type="text"onchange="UpdateCIEntry('<%=readerY("counter")%>','<%=readerY("JavascriptRandomNumber")%>')"name="CICustomerRep<%=readerY("counter")%>"id="CICustomerRep<%=readerY("counter")%>"style="color:#2C2C2C;font-weight:900;font-family:verdana,arial,helvetica,sans-serif;font-size:11px;width:200px;border:0px;background-color:#ADCAAD"maxlength="75"value="<%=readerY("CustomerRep")%>"></input>
     </td><td height="26"align="right"valign="bottom"width="240"style="padding-right:2px;border-left:0px">
     <img onclick="UpdateCIEntry('<%=readerY("counter")%>delete','<%=readerY("JavascriptRandomNumber")%>')"src="<%=AssetsPath()%>/delete.gif"style="border:0px;cursor:pointer"title="Delete this entry">
     </td></tr></table>
     <table style="border-collapse:collapse;border-left:1px solid #869886;border-right:1px solid #869886;border-bottom:1px solid #869886"bgcolor="D4DBD4"width="100%"border="0" cellpadding="0" cellspacing="0" align="center" bgcolor="D4DBD4">
     <tr bgcolor="D4DBD4"><td height="60"align="left"valign="top"width="100%"style="padding:4px">
     <textarea onchange="UpdateCIEntry('<%=readerY("counter")%>','<%=readerY("JavascriptRandomNumber")%>')"wrap="physical"name="CINotes<%=readerY("counter")%>"id="CINotes<%=readerY("counter")%>"style="font-family:verdana,arial,helvetica,sans-serif;font-size:12px;width:870px;height:60px;border:0px;background-color:#D4DBD4"><%=readerY("Notes")%></textarea>
     </td></tr></table>
     </td><td width="50"></td>
     </tr>
     </table>
   <%Loop
   End If
  End Using%>
<%end if%>

<table  bgcolor="D4DBD4"align="center" cellpadding="0" cellspacing="0" width="1250" BORDER="0">
</form>
<td height="300"></td>
</table>

</asp:Content>
