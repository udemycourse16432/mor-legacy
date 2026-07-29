Public Class Site
    Inherits System.Web.UI.MasterPage

    Private _priceGroup As String
    Private _connectionStringName As String
    Private _cartName As String

    Public ReadOnly Property PriceGroup As String
        Get
            Return _priceGroup
        End Get
    End Property

    Public ReadOnly Property ConnectionStringName As String
        Get
            Return _connectionStringName
        End Get
    End Property

    Public ReadOnly Property CartName As String
        Get
            Return _cartName
        End Get
    End Property

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim varRequireWebsitePassword As String = "no"
        If InStr(1, UCase(Request.ServerVariables("HTTP_HOST")), "MILLIONSTEST.COM") > 0 Then
            varRequireWebsitePassword = "yes"
        End If
        If varRequireWebsitePassword = "yes" Then
            If Session("WebsitePassword") <> "test2019" Then
                Response.Redirect("/submit-password.aspx")
            End If
        End If

        If Not String.IsNullOrEmpty(Request.QueryString.ToString) Then
            If Len(Request.QueryString.ToString) > 1000 Or CheckSQLInjectionText(Request.QueryString.ToString) = 1 Then
                Response.Write("Please click your browser's back button to go to the previous page.")
                Response.End()
            End If
        End If

        If Context.IsDebuggingEnabled OrElse Request.ServerVariables("HTTP_X_FORWARDED_FOR") = "1.1.1.27" Then
            _connectionStringName = "MillionsOfRecordsConnectionStringDevelopment"
        Else
            _connectionStringName = "MillionsOfRecordsConnectionStringProduction"
        End If

        Dim varServerCounter As String = ""
        If Session("StoreName") <> "" Then
            varServerCounter = Session("CustomerServerCounter")
            _cartName = "W_CART_" & varServerCounter
            _priceGroup = Session("PriceGroup")
        Else
            _cartName = "CART" & Session.SessionID & Session("CartRandomNumbersExtension")
            _priceGroup = "RetailPrice"
        End If
    End Sub

End Class
