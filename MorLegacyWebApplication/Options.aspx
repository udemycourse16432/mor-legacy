<%@ Page Language="VB" MasterPageFile="~/Site.Master" Debug="true" AutoEventWireup="false" EnableViewState="false" Title="Account Login | Millions Of Records" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Web" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">

<script language="javascript" type="text/javascript">
    img7 = new Image()
    img7.src = "<%=AssetsPath()%>/forgot-password-btnh.gif"
    img23 = new Image()
    img23.src = "<%=AssetsPath()%>/loading-processing-0.gif"
    img24 = new Image()
    img24.src = "<%=AssetsPath()%>/loading-processing-1.gif"
    img25 = new Image()
    img25.src = "<%=AssetsPath()%>/loading-processing-2.gif"
    img26 = new Image()
    img26.src = "<%=AssetsPath()%>/loading-processing-3.gif"
    img27 = new Image()
    img27.src = "<%=AssetsPath()%>/loading-processing-4.gif"
    img28 = new Image()
    img28.src = "<%=AssetsPath()%>/loading-processing-5.gif"
    img29 = new Image()
    img29.src = "<%=AssetsPath()%>/loading-processing-6.gif"
    img30 = new Image()
    img30.src = "<%=AssetsPath()%>/loading-processing-7.gif"
    img31 = new Image()
    img31.src = "<%=AssetsPath()%>/loading-processing-8.gif"
    img32 = new Image()
    img32.src = "<%=AssetsPath()%>/close-forgot-passwordh.gif"
    img33 = new Image()
    img33.src = "<%=AssetsPath()%>/forgot-password-submith.gif"
    img34 = new Image()
    img34.src = "<%=AssetsPath()%>/close-this-windowh.gif"
    img41 = new Image()
    img41.src = "<%=AssetsPath()%>/forgot-password-bg.gif"
    img42 = new Image()
    img42.src = "<%=AssetsPath()%>/forgot-password-text-bg.gif"
    img43 = new Image()
    img43.src = "<%=AssetsPath()%>/checkout-error-bg.gif"
    img44 = new Image()
    img44.src = "<%=AssetsPath()%>/checkmark-green.gif"
    img45 = new Image()
    img45.src = "<%=AssetsPath()%>/exclamation.gif"
</script>
<script language="javascript">
    var timer_is_on = 0
    var tmrA
    var intX = 0
    var loadingID
    var runningScript = 0
    var isW3C = (document.getElementById) ? true : false;

    function EscapeTotal(x) {
        x = escape(x)
        while (x.indexOf("*") != -1) { x = x.replace("*", "%2A") }
        while (x.indexOf("@") != -1) { x = x.replace("@", "%40") }
        while (x.indexOf("-") != -1) { x = x.replace("-", "%2D") }
        while (x.indexOf("_") != -1) { x = x.replace("_", "%5F") }
        while (x.indexOf("+") != -1) { x = x.replace("+", "%2B") }
        while (x.indexOf(".") != -1) { x = x.replace(".", "%2E") }
        while (x.indexOf("/") != -1) { x = x.replace("/", "%2F") }
        return x
    }
    function fov(a, q) { a.src = '<%=AssetsPath()%>/' + q + "h.gif" }
    function fou(a, q) { a.src = '<%=AssetsPath()%>/' + q + ".gif" }
    function nocart() { alert('There are currently no items in your shopping cart.  If you wish, you can add items to your shopping cart and then save it to use at a later date.') }
    function recordslimit() { varElem = (isW3C) ? document.getElementById('ItemsPerPage') : document.all('ItemsPerPage'); document.cookie = "RecordsLimit=" + varElem.value + "; path=/" }
    function submitform() {
        varElem = (isW3C) ? document.getElementById('LogInEmail') : document.all('LogInEmail');
        if (varElem.value == "") { alert('Please enter your Email.'); varElem.focus(); return false }
        if (varElem.value.indexOf("@") == -1) { alert('Please enter a valid Email Address. The Email address must contain an @ character.'); varElem.focus(); return false }
        if (varElem.value.indexOf(".") == -1) { alert('Please enter a valid Email Address. The Email address must contain a period (dot) character.'); varElem.focus(); return false }
        varElem = (isW3C) ? document.getElementById('Pword') : document.all('Pword');
        if (varElem.value == "") { alert('Please enter your Password.'); varElem.focus(); return false }
        document.SignInForm.submit()
    }
    function createPersonalAccount() { varElem = (isW3C) ? document.getElementById('WholesaleOrRetailTxt') : document.all('WholesaleOrRetailTxt'); varElem.value = "retail"; document.NewCustomerForm.action = "/country.aspx"; document.NewCustomerForm.submit() }
    function createResellerAccount() { varElem = (isW3C) ? document.getElementById('WholesaleOrRetailTxt') : document.all('WholesaleOrRetailTxt'); varElem.value = "wholesale"; document.NewCustomerForm.action = "/country.aspx"; document.NewCustomerForm.submit() }
    function txtForgotPasswordEmailKeyDown(evt) { var unicode = evt.keyCode ? evt.keyCode : evt.charCode; if (unicode == 13) { forgotPasswordSubmit() } }
    function showContactUsDiv() {
        elemE = (isW3C) ? document.getElementById("divForgotEmail") : (document.all("divForgotEmail")); elemE.style.display = "none"; elemE.style.visibility = "hidden"
        elemE = (isW3C) ? document.getElementById("divForgotPassword") : (document.all("divForgotPassword")); elemE.style.display = "none"; elemE.style.visibility = "hidden"
        elem = (isW3C) ? document.getElementById("divContactUs") : (document.all("divContactUs")); elemTxt = (isW3C) ? document.getElementById("txtContactUsYourName") : (document.all("txtContactUsYourName"))
        elem.style.display = "inline"; elem.style.visibility = "visible"; elemTxt.focus()
    }
    function hideContactUsDiv() {
        elem = (isW3C) ? document.getElementById("divContactUs") : (document.all("divContactUs")); elem2 = (isW3C) ? document.getElementById("divContactUsEmailSent") : (document.all("divContactUsEmailSent"))
        elem3 = (isW3C) ? document.getElementById("divContactUsBadEmail") : (document.all("divContactUsBadEmail")); elem4 = (isW3C) ? document.getElementById("divContactUsProcessingIcon") : (document.all("divContactUsProcessingIcon"))
        elem.style.display = "none"; elem.style.visibility = "hidden"; elem2.style.display = "none"; elem2.style.visibility = "hidden"
        elem3.style.display = "none"; elem3.style.visibility = "hidden"; elem4.style.display = "none"; elem4.style.visibility = "hidden"
    }
    function showForgotPasswordDiv() {
        elemE = (isW3C) ? document.getElementById("divForgotEmail") : (document.all("divForgotEmail")); elemE.style.display = "none"; elemE.style.visibility = "hidden"
        elemE = (isW3C) ? document.getElementById("divContactUs") : (document.all("divContactUs")); elemE.style.display = "none"; elemE.style.visibility = "hidden"
        elem = (isW3C) ? document.getElementById("divForgotPassword") : (document.all("divForgotPassword")); elemTxt = (isW3C) ? document.getElementById("txtForgotPasswordEmail") : (document.all("txtForgotPasswordEmail"))
        elem.style.display = "inline"; elem.style.visibility = "visible"; elemTxt.focus()
    }
    function hideForgotPasswordDiv() {
        elem = (isW3C) ? document.getElementById("divForgotPassword") : (document.all("divForgotPassword")); elem2 = (isW3C) ? document.getElementById("divEmailSent") : (document.all("divEmailSent"))
        elem3 = (isW3C) ? document.getElementById("divNoAccount") : (document.all("divNoAccount")); elem4 = (isW3C) ? document.getElementById("divProcessingIcon") : (document.all("divProcessingIcon"))
        elemTxt = (isW3C) ? document.getElementById("Pword") : (document.all("Pword")); elemTxt.focus()
        elem.style.display = "none"; elem.style.visibility = "hidden"; elem2.style.display = "none"; elem2.style.visibility = "hidden"
        elem3.style.display = "none"; elem3.style.visibility = "hidden"; elem4.style.display = "none"; elem4.style.visibility = "hidden"
    }
    function txtForgotEmailPasswordKeyDown(evt) { var unicode = evt.keyCode ? evt.keyCode : evt.charCode; if (unicode == 13) { forgotEmailSubmit() } }
    function showForgotEmailDiv() {
        elemP = (isW3C) ? document.getElementById("divForgotPassword") : (document.all("divForgotPassword")); elemP.style.display = "none"; elemP.style.visibility = "hidden"
        elemP = (isW3C) ? document.getElementById("divContactUs") : (document.all("divContactUs")); elemP.style.display = "none"; elemP.style.visibility = "hidden"
        elem = (isW3C) ? document.getElementById("divForgotEmail") : (document.all("divForgotEmail")); elemTxt = (isW3C) ? document.getElementById("txtForgotEmailPassword") : (document.all("txtForgotEmailPassword"))
        elem.style.display = "inline"; elem.style.visibility = "visible"; elemTxt.focus()
    }
    function hideForgotEmailDiv() {
        elem = (isW3C) ? document.getElementById("divForgotEmail") : (document.all("divForgotEmail")); elem2 = (isW3C) ? document.getElementById("divEmailSent") : (document.all("divEmailSent"))
        elem3 = (isW3C) ? document.getElementById("divNoAccount") : (document.all("divNoAccount")); elem4 = (isW3C) ? document.getElementById("divProcessingIcon") : (document.all("divProcessingIcon"))
        elemTxt = (isW3C) ? document.getElementById("LogInEmail") : (document.all("LogInEmail")); elemTxt.focus()
        elem.style.display = "none"; elem.style.visibility = "hidden"; elem2.style.display = "none"; elem2.style.visibility = "hidden"
        elem3.style.display = "none"; elem3.style.visibility = "hidden"; elem4.style.display = "none"; elem4.style.visibility = "hidden"
    }
    function ProcessingTimerContactUs() { eLoadingImg = (isW3C) ? document.getElementById("imgContactUsLoadingImage") : document.all("imgContactUsLoadingImage"); intX = intX + 1; if (intX == 9) { intX = 1 }; eLoadingImg.src = "<%=AssetsPath()%>/loading-processing-" + intX + ".gif"; tmrA = setTimeout("ProcessingTimerContactUs()", 100) }
    function EndProcessingTimerContactUs() { clearTimeout(tmrA); timer_is_on = 0 }
    function ProcessingTimer() { eLoadingImg = (isW3C) ? document.getElementById("imgLoadingImage") : document.all("imgLoadingImage"); intX = intX + 1; if (intX == 9) { intX = 1 }; eLoadingImg.src = "<%=AssetsPath()%>/loading-processing-" + intX + ".gif"; tmrA = setTimeout("ProcessingTimer()", 100) }
    function EndProcessingTimer() { clearTimeout(tmrA); timer_is_on = 0 }
    function ProcessingTimerForgotEmail() { eLoadingImg = (isW3C) ? document.getElementById("imgForgotEmailLoadingImage") : document.all("imgForgotEmailLoadingImage"); intX = intX + 1; if (intX == 9) { intX = 1 }; eLoadingImg.src = "<%=AssetsPath()%>/loading-processing-" + intX + ".gif"; tmrA = setTimeout("ProcessingTimerForgotEmail()", 100) }
    function EndProcessingTimerForgotEmail() { clearTimeout(tmrA); timer_is_on = 0 }
    function txtSignInPasswordKeyDown(evt) { var unicode = evt.keyCode ? evt.keyCode : evt.charCode; if (unicode == 13) { submitform() } }
    function contactUsSubmit() {
        elemYN = (isW3C) ? document.getElementById("txtContactUsYourName") : (document.all("txtContactUsYourName"));
        if (elemYN.value == "") { elemYN.focus(); alert('Please enter "Your Name" before submitting.'); return false }
        elemYE = (isW3C) ? document.getElementById("txtContactUsEmail") : (document.all("txtContactUsEmail"));
        if (elemYE.value == "") { elemYE.focus(); alert('Please enter "Your Email Address" before submitting.'); return false }
        elemYP = (isW3C) ? document.getElementById("txtContactUsYourPhone") : (document.all("txtContactUsYourPhone"));
        if (elemYP.value == "") { elemYP.focus(); alert('Please enter "Your Phone" before submitting.'); return false }
        elemM = (isW3C) ? document.getElementById("txtContactUsMessage") : (document.all("txtContactUsMessage"));
        if (elemM.value == "") { elemM.focus(); alert('Please enter your "Message" before submitting.'); return false }
        if (elemYE.value.indexOf("@") == -1) { elemYE.focus(); alert('Please enter a valid "Your Email Address".  It may be missing the required "@" character.'); return false }
        if (elemYE.value.indexOf(".") == -1) { elemYE.focus(); alert('Please enter a valid "Your Email Address".  It may be missing the required dot "." character.'); return false }
        if (window.XMLHttpRequest) { xmlhttp = new XMLHttpRequest() } else { xmlhttp = new ActiveXObject("Microsoft.XMLHTTP") }
        elem2 = (isW3C) ? document.getElementById("divContactUsEmailSent") : (document.all("divContactUsEmailSent"));
        elem3 = (isW3C) ? document.getElementById("divContactUsBadEmail") : (document.all("divContactUsBadEmail"));
        elem4 = (isW3C) ? document.getElementById("divContactUsProcessingIcon") : (document.all("divContactUsProcessingIcon"));
        elem2.style.display = "none"; elem2.style.visibility = "hidden"; elem3.style.display = "none"; elem3.style.visibility = "hidden"; elem4.style.display = "none"; elem4.style.visibility = "hidden"
        if (!timer_is_on) { elem4.style.display = "inline"; elem4.style.visibility = "visible"; timer_is_on = 1; ProcessingTimerContactUs() }
        var ran = Math.floor((Math.random() * 1000000) + 1)
        xmlhttp.open("GET", "/HTTPContactUs.aspx?YN=" + EscapeTotal(elemYN.value) + "&YE=" + EscapeTotal(elemYE.value) + "&YP=" + EscapeTotal(elemYP.value) + "&M=" + EscapeTotal(elemM.value) + "&ran=" + ran, true)
        xmlhttp.onreadystatechange = function () {
            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                EndProcessingTimerContactUs(); elem4.style.display = "none"; elem4.style.visibility = "hidden"
                if (xmlhttp.responseText == "none") { elem3.style.display = "inline"; elem3.style.visibility = "visible" }
                else { elemYN.value = ""; elemYE.value = ""; elemYP.value = ""; elemM.value = ""; elem2.style.display = "inline"; elem2.style.visibility = "visible" }
            }
        }
        xmlhttp.send(null)
    }
    function forgotPasswordSubmit() {
        elem = (isW3C) ? document.getElementById("txtForgotPasswordEmail") : (document.all("txtForgotPasswordEmail"));
        if (elem.value == "") { elem.focus(); alert('Please enter your "Email Address" so we can email your password to that address.'); return false }
        if (elem.value.indexOf("@") == -1) { elem.focus(); alert('Please enter a valid "Email Address".  It may be missing the required "@" character.'); return false }
        if (elem.value.indexOf(".") == -1) { elem.focus(); alert('Please enter a valid "Email Address".  It may be missing the required dot "." character.'); return false }
        if (window.XMLHttpRequest) { xmlhttp = new XMLHttpRequest() } else { xmlhttp = new ActiveXObject("Microsoft.XMLHTTP") }
        elem2 = (isW3C) ? document.getElementById("divEmailSent") : (document.all("divEmailSent"));
        elem3 = (isW3C) ? document.getElementById("divNoAccount") : (document.all("divNoAccount"));
        elem4 = (isW3C) ? document.getElementById("divProcessingIcon") : (document.all("divProcessingIcon"));
        elem2.style.display = "none"; elem2.style.visibility = "hidden"; elem3.style.display = "none"; elem3.style.visibility = "hidden"; elem4.style.display = "none"; elem4.style.visibility = "hidden"
        if (!timer_is_on) { elem4.style.display = "inline"; elem4.style.visibility = "visible"; timer_is_on = 1; ProcessingTimer() }
        var ran = Math.floor((Math.random() * 1000000) + 1)
        xmlhttp.open("GET", "/HTTPForgotPassword.aspx?E=" + EscapeTotal(elem.value) + "&PF=Checkout" + "&ran=" + ran, true)
        xmlhttp.onreadystatechange = function () {
            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                EndProcessingTimer(); elem4.style.display = "none"; elem4.style.visibility = "hidden"
                if (xmlhttp.responseText == "none") { elem3.style.display = "inline"; elem3.style.visibility = "visible" }
                else { elem.value = ""; elem2.style.display = "inline"; elem2.style.visibility = "visible" }
            }
        }
        xmlhttp.send(null)
    }
    function forgotEmailSubmit() {
        elem = (isW3C) ? document.getElementById("txtForgotEmailPassword") : (document.all("txtForgotEmailPassword"));
        if (elem.value == "") { elem.focus(); alert('Please enter your "Password" so we can show your Email to allow you to sign in.'); return false }
        if (window.XMLHttpRequest) { xmlhttp = new XMLHttpRequest() } else { xmlhttp = new ActiveXObject("Microsoft.XMLHTTP") }
        elem2 = (isW3C) ? document.getElementById("divForgotEmailEmailSent") : (document.all("divForgotEmailEmailSent"));
        elem3 = (isW3C) ? document.getElementById("divForgotEmailNoAccount") : (document.all("divForgotEmailNoAccount"));
        elem4 = (isW3C) ? document.getElementById("divForgotEmailProcessingIcon") : (document.all("divForgotEmailProcessingIcon"));
        elem5 = (isW3C) ? document.getElementById("divForgotEmailAccountWeak") : (document.all("divForgotEmailAccountWeak"));
        elem2.style.display = "none"; elem2.style.visibility = "hidden"; elem3.style.display = "none"; elem3.style.visibility = "hidden"
        elem4.style.display = "none"; elem4.style.visibility = "hidden"; elem5.style.display = "none"; elem5.style.visibility = "hidden"
        if (!timer_is_on) { elem4.style.display = "inline"; elem4.style.visibility = "visible"; timer_is_on = 1; ProcessingTimerForgotEmail() }
        var ran = Math.floor((Math.random() * 1000000) + 1)
        xmlhttp.open("GET", "/HTTPForgotEmail.aspx?P=" + EscapeTotal(elem.value) + "&PF=Checkout" + "&ran=" + ran, true)
        xmlhttp.onreadystatechange = function () {
            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                EndProcessingTimerForgotEmail(); elem4.style.display = "none"; elem4.style.visibility = "hidden"
                if (xmlhttp.responseText == "none") { elem3.style.display = "inline"; elem3.style.visibility = "visible" }
                else if (xmlhttp.responseText == "weak") { elem5.style.display = "inline"; elem5.style.visibility = "visible" }
                else {
                    elem.value = ""; elem2.style.display = "inline"; elem2.style.visibility = "visible"
                    eMessage = (isW3C) ? document.getElementById("pEmailMessage") : (document.all("pEmailMessage"));
                    eMessage.innerHTML = "Your Email is " + xmlhttp.responseText
                    eMessage.firstChild.nodeValue = "Your Email to sign into your account is " + xmlhttp.responseText
                    eLogInEmail = (isW3C) ? document.getElementById("LogInEmail") : (document.all("LogInEmail"));
                    eLogInEmail.value = xmlhttp.responseText
                }
            }
        }
        xmlhttp.send(null)
    }
    function rememberMeSignIn() { elem = (isW3C) ? document.getElementById("chkRememberMeSignIn") : (document.all("chkRememberMeSignIn")); elem2 = (isW3C) ? document.getElementById("txtRememberMeSignIn") : (document.all("txtRememberMeSignIn")); if (elem.checked == true) { elem2.value = "y" } else { elem2.value = "n" } }
    function SD(z) { varElem = (isW3C) ? document.getElementById(z) : document.all(z); varElem.style.visibility = 'visible'; varElem.style.display = 'inline' }
    function HD(z) { sn10 = "a"; varElem = (isW3C) ? document.getElementById(z) : document.all(z); varElem.style.visibility = 'hidden' }
</script>

<style type="text/css">
    p.a-blue {font-size:12px;color:#4285EC}
    p.a-blue:hover {text-decoration:underline;color:#4285EC}
    p.p-title-2 {font-size:22px;color:#000000;font-weight:600}
    p.p-text-2-b {font-size:14px;color:#393939;font-weight:600}
    p.p-link-1 {font-size:14px;color:#FF0000;text-decoration:underline;cursor:pointer}
    p.p-link-1-h {font-size:14px;color:#5B91D3;text-decoration:underline;cursor:pointer}
    p.p-error {font-size:13px;color:#000000}
    p.p-ok-message {font-size:13px;color:#000000}
    p.p-text-1 {font-size:14px;color:#343434}
    p.link {color:#000000;font-size:11px;text-decoration:underline;cursor:pointer}
    p.p-text-1-b {font-size:14px;color:#292929;font-weight:600}
    p.p-text-3 {font-size:13px;color:#3D3D3D}
    input.input-1 {font-size:15px;text-align:left;vertical-align:middle;border:0px;color:#000000;outline:none}
    .b {font-size:13px;color:#000000}
    .b-a {font-family:arial,verdana,helvetica,sans-serif;font-size:13px;color:#000000}
    .d {font-weight:900;font-size:14px;background-color:#F4F471;color:#FF0000}
    .c {font-size:11px;cursor:pointer;color:#0000FF}
    a.a-blue {font-size:13px;color:#4285EC}
    a.a-blue:hover {text-decoration:underline;color:#4285EC}
    div.qq {position:absolute;width:220;background-color:#F0DEBE;visibility:hidden;display:none;font:11px verdana;border-top:9px solid #DF7816;border-left:9px solid #DF7816;border-right:9px solid #DF7816;border-bottom:9px solid #DF7816;text-align:left;z-index:10}
</style>

<script type="text/javascript">
    (function (c, l, a, r, i, t, y) {
        c[a] = c[a] || function () { (c[a].q = c[a].q || []).push(arguments) };
        t = l.createElement(r); t.async = 1; t.src = "https://www.clarity.ms/tag/" + i;
        y = l.getElementsByTagName(r)[0]; y.parentNode.insertBefore(t, y);
    })(window, document, "clarity", "script", "floxa3fecs");
</script>

</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="BodyContent" runat="server">

<%
    Dim varBroadcastLinkURL As String = ""
    If (Request.QueryString("from-email") <> "" Or Request.QueryString("from-excel") <> "") And (IsNumeric(Request.QueryString("broadcast-list")) Or IsNumeric(Request.QueryString("itemid"))) Then
        Response.Redirect("/home.aspx?" & Request.QueryString.ToString)
    End If

    Dim varContinueToPurchasePage As String = ""
    Dim strURI As String = ""
    If Request.QueryString("ContinueToPurchasePage") = "" Then
        varContinueToPurchasePage = "no"
    Else
        varContinueToPurchasePage = "y"
        strURI = "&ContinueToPurchasePage=y"
    End If

    Dim strLogInEmail As String = ""
    Dim strRememberMeSignIn As String = "y"
    Dim strRememberMeSignInChecked As String = "checked"

    If Not IsNothing(Request.Cookies("RememberMeSignIn")) Then
        If Request.Cookies("RememberMeSignIn").Value <> "" Then
            If Request.Cookies("RememberMeSignIn").Value = "no" Then
                strRememberMeSignInChecked = ""
            Else
                strLogInEmail = Request.Cookies("RememberMeSignIn").Value
            End If
        End If
    End If
    If Request.QueryString("RM") = "n" Then
        strRememberMeSignIn = "n"
        strRememberMeSignInChecked = ""
    End If

    Dim defaultCC As String = Request("CC")

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

<table bgcolor="9BAF9B" cellpadding="0" cellspacing="0" WIDTH="1250" align="center" BORDER="0">
<tr><td align="center" height="45" valign="top">
<p style="font-size:28px;font-weight:600;color:#ffffff">Sign In or Create Account</p>
</td></tr></table>

<table width="1250" align="center" style="background-color:#D4DBD4;text-align:left" border="0" cellpadding="0" cellspacing="0" frame="void">
<tr><td width="50">
</td><td width="900" height="20" valign="top">

<div id="divForgotEmail" name="divForgotEmail" style="margin-left:295px;margin-top:-22px;background-image:url('<%=AssetsPath()%>/forgot-password-bg.gif');background-repeat:no-repeat;vertical-align:top;text-align:left;width:530px;height:480px;border:0px;position:absolute;display:none;visibility:hidden">
<table width="530" align="left" style="text-align:left" border="0" cellpadding="0" cellspacing="0" frame="void">
<tr><td>
<table width="530" align="left" style="text-align:left" border="0" cellpadding="0" cellspacing="0" frame="void">
<tr><td width="40"></td>
<td width="450" align="center" valign="top" style="padding-top:40px;vertical-align:middle;text-align:center">
<p class="p-title-2">Forgot Your Email?</p>
</td><td width="40" align="right" valign="top" style="vertical-align:top;text-align:right">
<img alt="" title="Close this window." style="margin-top:20px;margin-right:20px;cursor:pointer" onclick="hideForgotEmailDiv()" onmouseover="fov(this,'close-forgot-password')" onmouseout="fou(this,'close-forgot-password')" src="<%=AssetsPath()%>/close-forgot-password.gif" />
</td></tr></table>
</td></tr><tr><td>
<table width="530" align="left" style="text-align:left" border="0" cellpadding="0" cellspacing="0" frame="void">
<tr><td width="40"></td>
<td width="450" align="center" valign="top" style="padding-top:20px;vertical-align:middle;text-align:center">
<p class="p-text-2">Enter the password associated with your account, then click Submit. We'll display your email address so you can use it to sign in.</p>
</td><td width="40">
</td></tr></table>
</td></tr><tr><td>
<table width="530" align="left" style="text-align:left" border="0" cellpadding="0" cellspacing="0" frame="void">
<tr><td width="67"></td>
<td width="296" height="50" align="left" valign="bottom" style="padding-bottom:2px;vertical-align:bottom;text-align:left">
<p class="p-text-2-b" style="margin-left:2px">Your Password:</p>
</td><td width="167">
</tr><tr><td width="67"></td>
<td width="296" height="32" align="left" valign="middle" style="vertical-align:middle;text-align:left;background-image:url('<%=AssetsPath()%>/forgot-password-text-bg.gif');background-repeat:no-repeat">
<input type="text" autocomplete="off" maxlength="50" class="input-1" style="width:270px;margin-left:10px" id="txtForgotEmailPassword" name="txtForgotEmailPassword" onkeydown="txtForgotEmailPasswordKeyDown(event)" />
</td><td width="167" align="left" valign="middle" style="vertical-align:middle;text-align:left">
<img alt="" style="cursor:pointer" onmouseover="fov(this,'forgot-password-submit')" onmouseout="fou(this,'forgot-password-submit')" id="btnForgotEmailSubmit" name="btnForgotEmailSubmit" onclick="forgotEmailSubmit()" src="<%=AssetsPath()%>/forgot-password-submit.gif" />
</td></tr></table>
</td></tr><tr><td>
<table width="530" align="left" style="text-align:left" border="0" cellpadding="0" cellspacing="0" frame="void">
<tr><td width="67"></td>
<td width="396" height="130" align="left" valign="top" style="vertical-align:top;text-align:left">
<div id="divForgotEmailEmailSent" name="divForgotEmailEmailSent" style="margin-top:30px;border:0px;vertical-align:top;text-align:center;width:396px;height:140px;position:absolute;display:none;visibility:hidden">
<table width="396" align="left" cellpadding="10" style="text-align:left;border:1px" cellspacing="0" frame="void">
<tr><td width="55" height="80" align="left" valign="middle" style="vertical-align:middle;text-align:left;border-left:1px solid #252525;border-top:1px solid #252525;border-bottom:1px solid #252525">
<img alt="" src="<%=AssetsPath()%>/checkmark-green.gif" />
</td><td width="341" align="left" valign="middle" style="vertical-align:middle;text-align:left;border-right:1px solid #252525;border-top:1px solid #252525;border-bottom:1px solid #252525">
<p class="p-text-2" style="font-size:15px;color:#000000;font-weight:600" name="pEmailMessage" id="pEmailMessage"></p>
</td></tr><tr><td width="55">
</td><td width="341" align="left" valign="top" style="padding-left:67px">
</td></tr></table>
</div>
<div id="divForgotEmailNoAccount" name="divForgotEmailNoAccount" style="margin-top:30px;border:0px;vertical-align:top;text-align:center;width:396px;height:140px;position:absolute;display:none;visibility:hidden">
<table width="396" align="left" cellpadding="10" style="text-align:left;border:1px" cellspacing="0" frame="void">
<tr><td width="55" height="80" align="left" valign="middle" style="vertical-align:middle;text-align:left;border-left:1px solid #252525;border-top:1px solid #252525;border-bottom:1px solid #252525">
<img alt="" src="<%=AssetsPath()%>/exclamaition-orange.gif" />
</td><td width="341" align="left" valign="middle" style="vertical-align:middle;text-align:left;border-right:1px solid #252525;border-top:1px solid #252525;border-bottom:1px solid #252525">
<p class="p-text-2" style="font-size:14px;color:#000000">We're sorry, the password you entered does not match any accounts.</p>
</td></tr><tr><td width="55">
</td><td width="341" align="left" valign="top" style="padding-left:67px">
</td></tr><tr>
<td colspan="2" width="391" height="60" align="center" valign="bottom">
<font class="b-a" style="color:#363636;font-size:13px">
Can't sign in? For a quick response, <a class="a-blue" style="font-size:13px;text-decoration:underline" href="mailto:ernieb12345@gmail.com?Subject=Sign%20In%20Problem" target="_top">email customer service</a> and we will reply with your email/password so you can sign in.
</font>
</td></tr></table>
</div>
<div id="divForgotEmailAccountWeak" name="divForgotEmailAccountWeak" style="margin-top:30px;border:0px;vertical-align:top;text-align:center;width:396px;height:140px;position:absolute;display:none;visibility:hidden">
<table width="396" align="left" cellpadding="10" style="text-align:left;border:1px" cellspacing="0" frame="void">
<tr><td width="55" height="70" align="left" valign="middle" style="vertical-align:middle;text-align:left;border-left:1px solid #252525;border-top:1px solid #252525;border-bottom:1px solid #252525">
<img alt="" src="<%=AssetsPath()%>/exclamaition-orange.gif" />
</td><td width="341" align="left" valign="middle" style="vertical-align:middle;text-align:left;border-right:1px solid #252525;border-top:1px solid #252525;border-bottom:1px solid #252525">
<p class="p-text-2" style="font-size:13px;color:#000000">We're sorry, the email recovery feature is not valid for the account linked to this password. We recognize the password, however the password is not secure enough to prove positive authentication. Therefore, if you can't remember your email then you must <a class="a-blue" style="font-size:13px;text-decoration:underline" href="mailto:ernieb12345@gmail.com?Subject=Sign%20In%20Problem" target="_top">contact us</a> us to sign in, or you can simply create a new account instead.</p>
</td></tr><tr><td width="55">
</td><td width="341" align="left" valign="top" style="padding-left:67px">
</td></tr><tr>
<td colspan="2" width="391" align="center" valign="top">
<font class="b-a" style="color:#363636;font-size:13px">
Can't sign in? For a quick response, <a class="a-blue" style="font-size:13px;text-decoration:underline" href="mailto:ernieb12345@gmail.com?Subject=Sign%20In%20Problem" target="_top">email customer service</a> and we will reply with your email/password so you can sign in.
</font>
</td></tr></table>
</div>
<div id="divForgotEmailProcessingIcon" name="divForgotEmailProcessingIcon" style="margin-top:30px;border:0px;vertical-align:top;text-align:center;width:396px;height:140px;position:absolute;display:none;visibility:hidden">
<table width="396" align="left" cellpadding="10" style="text-align:left;border:1px" cellspacing="0" frame="void">
<tr><td width="396" height="80" align="center" valign="middle" style="vertical-align:middle;text-align:center">
<img alt="" name="imgForgotEmailLoadingImage" id="imgForgotEmailLoadingImage" style="border:0px;margin-top:3px;" src="<%=AssetsPath()%>/loading-processing-0.gif" />
</td></tr></table>
</div>
</td><td width="67">
</td></tr></table>
</td></tr></table>
</div>

<div id="divForgotPassword" name="divForgotPassword" style="margin-left:280px;margin-top:-22px;background-image:url('<%=AssetsPath()%>/forgot-password-bg3.gif');background-repeat:no-repeat;vertical-align:top;text-align:left;width:560px;height:480px;border:0px;position:absolute;display:none;visibility:hidden">
<table width="560" align="left" style="text-align:left" border="0" cellpadding="0" cellspacing="0" frame="void">
<tr><td>
<table width="560" align="left" style="text-align:left" border="0" cellpadding="0" cellspacing="0" frame="void">
<tr><td width="40"></td>
<td width="480" align="center" valign="top" style="padding-top:40px;vertical-align:middle;text-align:center">
<p class="p-title-2">Forgot Your Password?</p>
</td><td width="40" align="right" valign="top" style="vertical-align:top;text-align:right">
<img alt="" title="Close this window." style="margin-top:20px;margin-right:20px;cursor:pointer" onclick="hideForgotPasswordDiv()" onmouseover="fov(this,'close-forgot-password')" onmouseout="fou(this,'close-forgot-password')" src="<%=AssetsPath()%>/close-forgot-password.gif" />
</td></tr></table>
</td></tr><tr><td>
<table width="560" align="left" style="text-align:left" border="0" cellpadding="0" cellspacing="0" frame="void">
<tr><td width="50"></td>
<td width="460" valign="top" style="padding-top:20px;vertical-align:middle;text-align:justify">
<p class="p-text-2">Enter the email address associated with your account, then click Submit. We'll instantly email your password so you can use it to sign in. If you don't receive the email immediately then please check your spam folder. Please add ernie@millionsofrecords.com to your email contacts to prevent spam filtering.</p>
</td><td width="50">
</td></tr></table>
</td></tr><tr><td>
<table width="560" align="left" style="text-align:left" border="0" cellpadding="0" cellspacing="0" frame="void">
<tr><td width="67"></td>
<td width="316" height="70" align="left" valign="bottom" style="padding-bottom:2px;vertical-align:bottom;text-align:left">
<p class="p-text-2-b" style="margin-left:2px">Your Email Address</p><font class="b-a" style="color:#363636;font-size:12px">&nbsp;&nbsp;(The one you sign in with)</p>
</td><td width="167">
</tr><tr><td width="67"></td>
<td width="316" height="32" align="left" valign="middle" style="vertical-align:middle;text-align:left;background-image:url('<%=AssetsPath()%>/forgot-password-text-bg.gif');background-repeat:no-repeat">
<input type="text" autocomplete="off" maxlength="100" style="border-radius:7px;width:310px;height:32px;padding-left:10px;font-size:14px;text-align:left;vertical-align:middle;border:1px solid #84AAD9;color:#000000;outline:none" id="txtForgotPasswordEmail" name="txtForgotPasswordEmail" onkeydown="txtForgotPasswordEmailKeyDown(event)" />
</td><td width="167" align="left" valign="middle" style="vertical-align:middle;text-align:left">
<img alt="" style="cursor:pointer" onmouseover="fov(this,'forgot-password-submit')" onmouseout="fou(this,'forgot-password-submit')" id="btnForgotPasswordSubmit" name="btnForgotPasswordSubmit" onclick="forgotPasswordSubmit()" src="<%=AssetsPath()%>/forgot-password-submit.gif" />
</td></tr></table>
</td></tr><tr><td>
<table width="560" align="left" style="text-align:left" border="0" cellpadding="0" cellspacing="0" frame="void">
<tr><td width="67"></td>
<td width="426" height="130" align="left" valign="top" style="vertical-align:top;text-align:left">
<div id="divEmailSent" name="divEmailSent" style="margin-top:30px;border:0px;vertical-align:top;text-align:center;width:426px;height:140px;position:absolute;display:none;visibility:hidden">
<table width="426" align="left" cellpadding="10" style="text-align:left;border:1px" cellspacing="0" frame="void">
<tr><td width="55" height="80" align="left" valign="middle" style="vertical-align:middle;text-align:left;border-left:1px solid #252525;border-top:1px solid #252525;border-bottom:1px solid #252525">
<img alt="" src="<%=AssetsPath()%>/checkmark-green.gif" />
</td><td width="341" align="left" valign="middle" style="vertical-align:middle;text-align:left;border-right:1px solid #252525;border-top:1px solid #252525;border-bottom:1px solid #252525">
<p class="p-text-2" style="font-size:13px;color:#000000">Check your email.  We have sent a message to this email address containing your Password. If you don't receive it, then please check your spam/bulk email folder.</p>
</td></tr><tr><td width="55">
</td><td width="341" align="left" valign="top" style="padding-left:67px">
<img alt="" style="cursor:pointer" onclick="hideForgotPasswordDiv()" onmouseover="fov(this,'close-this-window')" onmouseout="fou(this,'close-this-window')" src="<%=AssetsPath()%>/close-this-window.gif" />
</td></tr></table>
</div>
<div id="divNoAccount" name="divNoAccount" style="margin-top:30px;border:0px;vertical-align:top;text-align:center;width:426px;height:140px;position:absolute;display:none;visibility:hidden">
<table width="426" align="left" cellpadding="10" style="text-align:left;border:1px" cellspacing="0" frame="void">
<tr><td width="55" height="80" align="left" valign="middle" style="vertical-align:middle;text-align:left;border-left:1px solid #252525;border-top:1px solid #252525;border-bottom:1px solid #252525">
<img alt="" src="<%=AssetsPath()%>/exclamaition-orange.gif" />
</td><td width="341" align="left" valign="middle" style="vertical-align:middle;text-align:left;border-right:1px solid #252525;border-top:1px solid #252525;border-bottom:1px solid #252525">
<p class="p-text-2" style="font-size:14px;color:#000000">We could not find an account associated with that email address.  We suggest that you create a new account using that email address by clicking one of the buttons below.  Thank you.</p>
</td></tr><tr><td width="55">
</td><td width="341" align="left" valign="top" style="padding-left:67px">
</td></tr><tr>
<td colspan="2" width="391" height="40" align="center" valign="bottom">
</td></tr></table>
<br/><br/>
<font class="b-a" style="color:#363636;font-size:12px">
Can't sign in? For a quick response, <a class="a-blue" style="font-size:14px" onclick="showContactUsDiv()" href="#">contact us</a> and we will reply with your email/password so you can sign in.  Thank you.
</font>
</div>
<div id="divProcessingIcon" name="divProcessingIcon" style="margin-top:30px;border:0px;vertical-align:top;text-align:center;width:426px;height:140px;position:absolute;display:none;visibility:hidden">
<table width="426" align="left" cellpadding="10" style="text-align:left;border:1px" cellspacing="0" frame="void">
<tr><td width="426" height="80" align="center" valign="middle" style="vertical-align:middle;text-align:center">
<img alt="" name="imgLoadingImage" id="imgLoadingImage" style="border:0px;margin-top:3px;" src="<%=AssetsPath()%>/loading-processing-0.gif" />
</td></tr></table>
</div>
</td><td width="67">
</td></tr></table>
</td></tr></table>
</div>

<div id="divContactUs" name="divContactUs" style="margin-left:160px;margin-top:-22px;background-image:url('<%=AssetsPath()%>/contact-us-bg2.gif');background-repeat:no-repeat;vertical-align:top;text-align:left;width:800px;height:650px;border:0px;position:absolute;display:none;visibility:hidden">
<table width="800" align="left" style="text-align:left" border="0" cellpadding="0" cellspacing="0" frame="void">
<tr><td><table width="800" align="left" style="text-align:left" border="0" cellpadding="0" cellspacing="0" frame="void">
<tr><td width="40"></td>
<td width="720" align="center" valign="top" style="padding-top:40px;vertical-align:middle;text-align:center">
<p class="p-title-2">Contact Us</p>
</td><td width="40" align="right" valign="top" style="vertical-align:top;text-align:right">
<img alt="" title="Close this window." style="margin-top:20px;margin-right:20px;cursor:pointer" onclick="hideContactUsDiv()" onmouseover="fov(this,'close-forgot-password')" onmouseout="fou(this,'close-forgot-password')" src="<%=AssetsPath()%>/close-forgot-password.gif" />
</td></tr></table>
</td></tr><tr><td>
<table width="800" align="left" style="text-align:left" border="0" cellpadding="0" cellspacing="0" frame="void">
<tr><td width="40">
</td><td width="720" valign="top" style="padding-top:20px;padding-bottom:40px;vertical-align:middle;text-align:center">
<p class="p-text-2">Enter your contact information and your message for us, then click Submit.</p>
</td><td width="40">
</td></tr></table>
</td></tr><tr><td>
<table width="800" align="left" style="text-align:left" border="0" cellpadding="0" cellspacing="0" frame="void">
<tr><td width="65">
</td><td width="190" height="32" align="right" valign="middle" style="vertical-align:middle;text-align:right">
<p class="p-text-2-b" style="vertical-align:middle">Your Name:</p>
</td><td width="545" align="left" valign="middle" style="vertical-align:middle;text-align:left">
<input type="text" autocomplete="off" maxlength="100" class="input-1" style="width:270px;margin-left:10px;border:1px solid #82A9D8;border-radius:8px;height:27px;vertical-align:middle;padding-left:8px" id="txtContactUsYourName" name="txtContactUsYourName" />
</td></tr><tr><td width="65">
</td><td width="190" height="32" align="right" valign="middle" style="vertical-align:middle;text-align:right">
<p class="p-text-2-b" style="vertical-align:middle">Your Email Address:</p>
</td><td width="545" align="left" valign="middle" style="vertical-align:middle;text-align:left">
<input type="text" autocomplete="off" maxlength="100" class="input-1" style="width:270px;margin-left:10px;border:1px solid #82A9D8;border-radius:8px;height:27px;vertical-align:middle;padding-left:8px" id="txtContactUsEmail" name="txtContactUsEmail" />
</td></tr><tr><td width="65">
</td><td width="190" height="32" align="right" valign="middle" style="vertical-align:middle;text-align:right">
<p class="p-text-2-b" style="vertical-align:middle">Your Phone (optional):</p>
</td><td width="545" align="left" valign="middle" style="vertical-align:middle;text-align:left">
<input type="text" autocomplete="off" maxlength="100" class="input-1" style="width:270px;margin-left:10px;border:1px solid #82A9D8;border-radius:8px;height:27px;vertical-align:middle;padding-left:8px" id="txtContactUsYourPhone" name="txtContactUsYourPhone" />
</td></tr></table>
</td></tr><tr><td>
<table width="800" align="left" style="text-align:left" border="0" cellpadding="0" cellspacing="0" frame="void">
<tr><td width="60">
</td><td width="680" valign="bottom" style="padding-top:20px;padding-bottom:4px;vertical-align:bottom;text-align:left">
<p class="p-text-2-b">Message:</p>
</td><td width="60">
</tr><tr><td width="60">
</td><td width="680" valign="top" style="vertical-align:top;text-align:left">
<textarea wrap="physical" maxlength="1000" style="background-color:#ffffff;font-size:14px;width:680px;height:100px;padding:8px" name="txtContactUsMessage" id="txtContactUsMessage"></textarea>
</td><td width="60">
</td></tr></table>
<table width="800" align="left" style="text-align:left" border="0" cellpadding="0" cellspacing="0" frame="void">
<tr><td width="60">
</td><td width="740">
<img alt="" style="cursor:pointer;margin-top:8px" onmouseover="fov(this,'forgot-password-submit')" onmouseout="fou(this,'forgot-password-submit')" id="btnContactUsSubmit" name="btnContactUsSubmit" onclick="contactUsSubmit()" src="<%=AssetsPath()%>/forgot-password-submit.gif" />
</td></tr></table>
</td></tr><tr><td>
<table width="800" align="left" style="text-align:left" border="0" cellpadding="0" cellspacing="0" frame="void">
<tr><td width="40"></td>
<td width="720" height="130" align="left" valign="top" style="vertical-align:top;text-align:left">
<div id="divContactUsEmailSent" name="divContactUsEmailSent" style="margin-top:30px;border:0px;vertical-align:top;text-align:center;width:720px;height:140px;position:absolute;display:none;visibility:hidden">
<table width="720" align="left" cellpadding="10" style="text-align:left;border:1px" cellspacing="0" frame="void">
<tr><td width="55" height="80" align="left" valign="middle" style="vertical-align:middle;text-align:left;border-left:1px solid #252525;border-top:1px solid #252525;border-bottom:1px solid #252525">
<img alt="" src="<%=AssetsPath()%>/checkmark-green.gif" />
</td><td width="665" align="left" valign="middle" style="vertical-align:middle;text-align:left;border-right:1px solid #252525;border-top:1px solid #252525;border-bottom:1px solid #252525">
<p class="p-text-2" style="font-size:13px;color:#000000">Thank you.  An email has been sent to our customer service department and you will be hearing back from us soon.</p>
</td></tr><tr><td width="55">
</td><td width="665" align="center" valign="top">
<img alt="" style="cursor:pointer" onclick="hideContactUsDiv()" onmouseover="fov(this,'close-this-window')" onmouseout="fou(this,'close-this-window')" src="<%=AssetsPath()%>/close-this-window.gif" />
</td></tr></table>
</div>
<div id="divContactUsBadEmail" name="divContactUsBadEmail" style="margin-top:30px;border:0px;vertical-align:top;text-align:center;width:720px;height:140px;position:absolute;display:none;visibility:hidden">
<table width="720" align="left" cellpadding="10" style="text-align:left;border:1px" cellspacing="0" frame="void">
<tr><td width="55" height="80" align="left" valign="middle" style="vertical-align:middle;text-align:left;border-left:1px solid #252525;border-top:1px solid #252525;border-bottom:1px solid #252525">
<img alt="" src="<%=AssetsPath()%>/exclamaition-orange.gif" />
</td><td width="665" align="left" valign="middle" style="vertical-align:middle;text-align:left;border-right:1px solid #252525;border-top:1px solid #252525;border-bottom:1px solid #252525">
<p class="p-text-2" style="font-size:14px;color:#000000">Please enter a valid Email Address.  Thank you.</p>
</td></tr><tr><td width="55">
</td><td width="665" align="left" valign="top" style="padding-left:67px">
</td></tr></table>
</div>
<div id="divContactUsProcessingIcon" name="divContactUsProcessingIcon" style="margin-top:30px;border:0px;vertical-align:top;text-align:center;width:720px;height:140px;position:absolute;display:none;visibility:hidden">
<table width="720" align="left" cellpadding="10" style="text-align:left;border:1px" cellspacing="0" frame="void">
<tr><td width="720" height="80" align="center" valign="middle" style="vertical-align:middle;text-align:center">
<img alt="" name="imgContactUsLoadingImage" id="imgContactUsLoadingImage" style="border:0px;margin-top:3px;" src="<%=AssetsPath()%>/loading-processing-0.gif" />
</td></tr></table>
</div>
</td><td width="40">
</td></tr></table>
</td></tr></table>
</div>

</td><td width="30"></td>
<form name="SignInForm" id="SignInForm" action="/CustomerInfo.aspx" method="post">
</tr></table>

<% If Request("BI") = "y" Then
   strLogInEmail = Session("SignInFailedLogInEmail")
   If Request("LE") = "y" Then %>
<table width="1250" align="center" style="background-color:#D4DBD4;text-align:left" border="0" cellpadding="0" cellspacing="0" frame="void">
<tr><td height="15">
</td></tr></table>
<table width="1250" align="center" style="background-color:#D4DBD4;text-align:left" border="0" cellpadding="0" cellspacing="0" frame="void">
<tr><td width="370">
</td><td width="510" height="110" valign="top" style="vertical-align:top;text-align:left;background-image:url('<%=AssetsPath()%>/checkout-error-LE-bg.gif');background-repeat:no-repeat">
<table width="510" align="center" border="0" cellpadding="0" cellspacing="0" frame="void">
<tr><td width="70">
</td><td width="430" valign="top" style="vertical-align:top;text-align:left;padding-top:14px">
<p class="p-error">We recognized your email address, but you are trying to sign in with your OLD password.  <span style="font-weight:600;color:#ff0000">We just sent an email to <%=strLogInEmail%> with your current password.</span>  If you didn't receive the email then please contact us.  Thank you.</p>
</td><td width="10">
</td></tr></table>
</td><td width="370">
</td></tr></table>
<% Else %>
<table width="1250" align="center" style="background-color:#D4DBD4;text-align:left" border="0" cellpadding="0" cellspacing="0" frame="void">
<tr><td height="15">
</td></tr></table>
<table width="1250" align="center" style="background-color:#D4DBD4;text-align:left" border="0" cellpadding="0" cellspacing="0" frame="void">
<tr><td width="300">
</td><td width="650" height="120" valign="top" style="vertical-align:top;text-align:left;background-image:url('<%=AssetsPath()%>/checkout-error-LE2-bg.gif');background-repeat:no-repeat">
<table width="650" align="center" border="0" cellpadding="0" cellspacing="0" frame="void">
<tr><td width="70">
</td><td width="570" valign="top" style="vertical-align:middle;text-align:left;padding-top:14px">
<p class="p-error">There is no account using that email address for sign-in, so please create a new account below. If you think that you already have an account with us, then please go to <a class="a-blue" onclick="showForgotPasswordDiv()" tabindex="-1" style="font-size:13px" href="#">Forgot&nbsp;Password</a> and enter a different email address that may have been used for sign-in. Note: It's OK to have more than one account with us, but each account must have a unique email address.</p>
</td><td width="10">
</td></tr></table>
</td><td width="300">
</td></tr></table>
<% End If
End If %>

<% If Request.QueryString("BI") <> "y" And varBroadcastLinkURL <> "" Then %>
<table width="1250" align="center" style="background-color:#D4DBD4;text-align:left" border="0" cellpadding="0" cellspacing="0" frame="void">
<tr><td height="15">
</td></tr></table>
<table width="1250" align="center" style="background-color:#D4DBD4;text-align:left" border="0" cellpadding="0" cellspacing="0" frame="void">
<tr><td width="370">
</td><td width="510" height="150" valign="top" style="vertical-align:middle;text-align:left;background-image:url('<%=AssetsPath()%>/please-sign-in-bg.gif');background-repeat:no-repeat">
<table width="510" align="center" border="0" cellpadding="0" cellspacing="0" frame="void">
<tr><td width="70">
</td><td width="430" valign="middle" style="vertical-align:middle;text-align:left">
<p class="p-error" style="font-size:14px">Please Sign In.<br/><br/>If you view items on our website without signing in, then you won't see your discounted (wholesale) prices.  Please sign in now and then the website will display your wholesale prices.  Thank you.</p>
</td><td width="10">
</td></tr></table>
</td><td width="370">
</td></tr></table>
<% End If %>

<table width="1250" align="center" style="background-color:#D4DBD4;text-align:left" border="0" cellpadding="0" cellspacing="0" frame="void">
<tr><td height="15">
</td></tr></table>

<table bgcolor="D4DBD4" frame="none" cellpadding="0" cellspacing="0" WIDTH="1250" align="center" BORDER="0">
<input type="hidden" name="BroadcastLinkURL" id="BroadcastLinkURL" value="<%=varBroadcastLinkURL%>">
<input type="hidden" name="CC" id="CC" value="<%=defaultCC%>">
<input type="hidden" id="txtRememberMeSignIn" name="txtRememberMeSignIn" value="<%=strRememberMeSignIn%>" />
<input type="hidden" name="FromOptionsCustomerID" id="FromOptionsCustomerID" value="yes">
<tr><td width="170" height="456">
</td><td width="910" style="text-align:center;background-image:url('<%=AssetsPath()%>/sign-in-bg5.gif');background-repeat:no-repeat">
<table width="900" style="text-align:left" border="0" cellpadding="0" cellspacing="0" frame="void">
<tr><td width="450" style="vertical-align:top">
<table width="450" style="text-align:left;vertical-align:top" border="0" cellpadding="0" cellspacing="0" frame="void">
<tr><td width="65">
</td><td height="44" width="345" style="text-align:left;vertical-align:bottom">
<p class="p-title-2">Returning Customers</p>
</td><td width="40">
</td></tr><tr><td width="65">
</td><td height="16" width="345" style="text-align:left;vertical-align:bottom">
<% If varContinueToPurchasePage = "no" Then %>
<p class="p-text-1">Sign in to your existing account.</p>
<% Else %>
<p class="p-text-1">Sign in to your account for a speedy checkout.</p>
<% End If %>
</td><td width="40">
</td></tr><tr><td width="65">
</td><td height="40" width="345" style="text-align:left;vertical-align:bottom;padding-bottom:1px">
<p class="p-text-1-b" style="color:#3D3D3D">&nbsp;Email:</p>
</td><td width="40">
</td></tr><tr><td width="65">
</td><td height="32" width="345" style="text-align:left;vertical-align:middle">
<input type="text" maxlength="100" style="border-radius:7px;width:333px;height:32px;padding-left:10px;font-size:15px;text-align:left;vertical-align:middle;border:1px solid #84AAD9;color:#000000;outline:none" name="LogInEmail" id="LogInEmail" value="<%=strLogInEmail%>">
</td><td width="40">
</td></tr><tr><td width="65">
</td><td height="38" width="345" style="text-align:left;vertical-align:bottom;padding-bottom:1px">
<p class="p-text-1-b" style="color:#3D3D3D">&nbsp;Password:</p>
</td><td width="40">
</td></tr><tr><td width="65">
</td><td height="32" width="345" style="text-align:left;vertical-align:middle">
<input type="password" onkeydown="txtSignInPasswordKeyDown(event)" maxlength="50" style="border-radius:7px;width:333px;height:32px;padding-left:10px;font-size:15px;text-align:left;vertical-align:middle;border:1px solid #84AAD9;color:#000000;outline:none" name="Pword" id="Pword">
</td><td width="40">
<% If strLogInEmail = "" Then %>
<script language="javascript" type="text/javascript">document.SignInForm.LogInEmail.focus()</script>
<% Else %>
<script language="javascript" type="text/javascript">document.SignInForm.Pword.focus()</script>
<% End If %>
</td></tr><tr><td width="65">
</td><td height="32" width="345" style="text-align:left;vertical-align:bottom">
<img alt="" title="Click here to retrieve your password." style="cursor:pointer" onmouseover="fov(this,'forgot-password-btn')" onmouseout="fou(this,'forgot-password-btn')" onclick="showForgotPasswordDiv()" src="<%=AssetsPath()%>/forgot-password-btn.gif" />
</td><td width="40">
</td></tr><tr><td width="65">
</td><td height="72" width="345" style="text-align:left;vertical-align:bottom;padding-bottom:15px">
<img alt="Submit" title="Submit" src="<%=AssetsPath()%>/sign-in-button2.gif" onclick="submitform()" onmouseover="fovs(this,'sign-in-button2')" onmouseout="fous(this,'sign-in-button2')" style="cursor:pointer;border:0px" />
</td><td width="50">
</td></tr><tr><td width="65">
</td><td height="75" width="345" style="text-align:left;vertical-align:bottom;padding-bottom:15px">
<font class="b-a" style="color:#363636;font-size:12px">Can't sign in? For a quick response, <a class="a-blue" style="font-size:14px" onclick="showContactUsDiv()" href="#">contact us</a> and we will reply with your email/password so you can sign in.  Thank you.</font>
</td><td width="40">
</form>
</td></tr>
</table>
</td><td width="450" style="vertical-align:top">
<table width="450" style="text-align:left;vertical-align:top" border="0" cellpadding="0" cellspacing="0" frame="void">
<form name="NewCustomerForm" id="NewCustomerForm" action="/Country.aspx" method="post">
<input type="hidden" name="WholesaleOrRetailTxt" id="WholesaleOrRetailTxt" value="retail">
<input type="hidden" name="ContinueToPurchasePage" id="ContinueToPurchasePage" value="<%=varContinueToPurchasePage%>">
<tr><td width="45">
</td><td height="44" width="345" style="text-align:left;vertical-align:bottom">
<p class="p-title-2">New Customers</p>
</td><td width="60">
</td></tr><tr><td width="45">
</td><td height="135" width="345" style="text-align:left;vertical-align:bottom">
<p class="p-text-1" style="font-size:15px">Note: If you are a record store or other type of reseller (Facebook, eBay, etc.), you can create your wholesale account by clicking <a class="a-blue" style="font-size:15px;text-decoration:underline" onclick="createResellerAccount()" href="#">here</a>.  Your wholesale account will be opened instantly so you can begin ordering today.</p>
</td><td width="60">
</td></tr><tr><td width="45">
</td><td height="112" width="345" style="text-align:left;vertical-align:bottom">
<img onclick="createPersonalAccount()" onmouseover="fovs(this,'create-account-btn2')" onmouseout="fous(this,'create-account-btn2')" style="border:0px;cursor:pointer" src="<%=AssetsPath()%>/create-account-btn2.gif"/>
</td></tr></table>
</td></tr></table>

</td><td width="170">
</td></tr></table>

<table cellpadding="0" cellspacing="0" WIDTH="1250" align="center" BORDER="0">
<td height="500" bgcolor="D4DBD4" width="100%" valign="middle" align="center">
</td>
</table>

</asp:Content>
