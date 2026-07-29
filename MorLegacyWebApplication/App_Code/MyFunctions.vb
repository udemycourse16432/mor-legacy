Imports System
Imports System.Data.SqlClient
Imports System.Net.Mail
Imports Microsoft.VisualBasic
Imports System.IO
Imports System.Web
Imports System.Net

Public Module MyFunctions
    Public Function FigureArtistsTextFromArtist(strArtistMain, strArtistTitleText) As String
        FigureArtistsTextFromArtist = strArtistTitleText
        Dim Artists(15)
        Dim intDash As Integer = 0
        Dim strTitle As String = ""
        Dim strNewArtist As String = ""
        Dim strArtistToSwitch As String = ""
        Dim strArtist As String = ""

        intDash = InStr(strArtistTitleText, " - ")
        strNewArtist = ""
        strArtist = Trim(Left(strArtistTitleText, intDash - 1))
        If InStr(strArtist, ", ") > 0 Then
            strTitle = Trim(Strings.Right(strArtistTitleText, Len(strArtistTitleText) - intDash - 1))
            Artists = FigureArtistsFromArtistTitle(strArtist & " - Title")
            For nA = 1 To 6
                If InStr(UCase(Artists(nA)), UCase(strArtistMain)) > 0 Then
                    strArtistToSwitch = Artists(1)
                    Artists(1) = Artists(nA)
                    Artists(nA) = strArtistToSwitch
                    Exit For
                End If
                If Artists(nA) = "---" Then Exit For
            Next
            For nA = 1 To 3
                If Artists(nA) <> "---" Then
                    strNewArtist = strNewArtist & " " & Artists(nA) & ","
                End If
            Next
            FigureArtistsTextFromArtist = Left(strNewArtist, Len(strNewArtist) - 1) & " - " & strTitle
        End If

    End Function
    Public Function Z_URLDecode(subVarText As String) As String
        Dim Pos As Integer = 0
        Z_URLDecode = IsDBSomething(subVarText, "")
        If Z_URLDecode = "" Then
            Exit Function
        End If
        Z_URLDecode = Replace(Z_URLDecode, "+", " ")
        Z_URLDecode = Replace(Z_URLDecode, "%25", "@@@@@@")
        Pos = InStr(1, Z_URLDecode, "%")
        Do While Pos > 0
            Z_URLDecode = Left(Z_URLDecode, Pos - 1) & Chr(CLng("&H" & Mid(Z_URLDecode, Pos + 1, 2))) & Mid(Z_URLDecode, Pos + 3)
            Pos = InStr(1, Z_URLDecode, "%")
        Loop
        Z_URLDecode = Replace(Z_URLDecode, "@@@@@@", "%")
    End Function
    Public Function FigureItemFeaturesTextForGridView(varRhythmName As String, varItemFeatures1 As String, varItemFeatures2 As String, varItemFeatures3 As String, varItemFeatures4 As String, varItemFeatures5 As String, varItemFeatures6 As String, varItemFeatures7 As String, varItemFeatures8 As String, varItemFeatures9 As String, varItemFeatures10 As String) As String
        FigureItemFeaturesTextForGridView = ""
        Dim intSecondLine As Integer = 0
        Dim intTextLength As Integer = 0
        Dim intPipe1 As Integer = 0
        Dim intPipe2 As Integer = 0
        Dim intPipe4 As Integer = 0
        Dim intPipe5 As Integer = 0
        Dim intPipe6 As Integer = 0
        Dim intIF As Integer = 0
        Dim strItemFeature As String = ""
        Dim strItemFeatureText As String = ""
        Dim strItemFeatureTextTOTAL As String = ""
        Dim strItemFeatureID As String = ""
        Dim strItemFeatureHoverText As String = ""
        Dim intMaxTextLengthLine1 As Integer = 0
        If varRhythmName = "" Then
            intMaxTextLengthLine1 = 33
        Else
            intMaxTextLengthLine1 = 48
        End If
        For intIF = 1 To 10
            If intIF = 1 Then
                strItemFeature = varItemFeatures1
            ElseIf intIF = 2 Then
                strItemFeature = varItemFeatures2
            ElseIf intIF = 3 Then
                strItemFeature = varItemFeatures3
            ElseIf intIF = 4 Then
                strItemFeature = varItemFeatures4
            ElseIf intIF = 5 Then
                strItemFeature = varItemFeatures5
            ElseIf intIF = 6 Then
                strItemFeature = varItemFeatures6
            ElseIf intIF = 7 Then
                strItemFeature = varItemFeatures7
            ElseIf intIF = 8 Then
                strItemFeature = varItemFeatures8
            ElseIf intIF = 9 Then
                strItemFeature = varItemFeatures9
            ElseIf intIF = 10 Then
                strItemFeature = varItemFeatures10
            End If
            If strItemFeature = "" Then Exit For
            intPipe1 = InStr(strItemFeature, "|1|")
            intPipe2 = InStr(strItemFeature, "|2|")
            If intPipe2 - intPipe1 > 3 Then
                strItemFeatureID = Mid(strItemFeature, intPipe1 + 3, intPipe2 - intPipe1 - 3)
            Else
                strItemFeatureID = ""
            End If
            intPipe4 = InStr(strItemFeature, "|4|")
            intPipe5 = InStr(strItemFeature, "|5|")
            If intPipe5 - intPipe4 > 3 Then
                strItemFeatureText = Mid(strItemFeature, intPipe4 + 3, intPipe5 - intPipe4 - 3)
            Else
                strItemFeatureText = ""
            End If
            intPipe5 = InStr(strItemFeature, "|5|")
            intPipe6 = InStr(strItemFeature, "|6|")
            If intPipe6 - intPipe5 > 3 Then
                strItemFeatureHoverText = Mid(strItemFeature, intPipe5 + 3, intPipe6 - intPipe5 - 3)
            Else
                strItemFeatureHoverText = ""
            End If
            If strItemFeatureText <> "" Then
                intTextLength = intTextLength + Len(strItemFeatureText) + 2
                If CInt(intTextLength) > CInt(intMaxTextLengthLine1) Then
                    If varRhythmName <> "" Then
                        FigureItemFeaturesTextForGridView = strItemFeatureTextTOTAL
                        Exit Function
                    Else
                        If intSecondLine = 0 Then
                            strItemFeatureTextTOTAL = strItemFeatureTextTOTAL & "<br/>"
                            intTextLength = 0
                            intSecondLine = 1
                        Else
                            Exit For
                        End If
                    End If
                End If
                strItemFeatureTextTOTAL = strItemFeatureTextTOTAL & "(<span class=""grid-if""title=""" & Replace(strItemFeatureHoverText, """", " inch") & """onclick=""IF('" & strItemFeatureID & "')"">" & strItemFeatureText & "</span>)"
            End If
        Next
        If strItemFeatureTextTOTAL <> "" Then
            strItemFeatureTextTOTAL = "<p class='p-ifg'>" & strItemFeatureTextTOTAL & "</p>"
        End If
        FigureItemFeaturesTextForGridView = strItemFeatureTextTOTAL

    End Function


    Public Function FigureNumberOfTracks(strTracksGroup As String) As Integer
        Dim intSpace As Integer = 0
        Dim strNumberOfTracksText As String = ""
        If strTracksGroup = "" Then
            FigureNumberOfTracks = 0
        Else
            intSpace = InStr(strTracksGroup, " ")
            If intSpace = 0 Then
                FigureNumberOfTracks = 0
            Else
                strNumberOfTracksText = Trim(Left(strTracksGroup, intSpace - 1))
                If IsNumeric(strNumberOfTracksText) Then
                    FigureNumberOfTracks = CInt(strNumberOfTracksText)
                Else
                    FigureNumberOfTracks = 0
                End If
            End If
        End If
    End Function
    Public Function TakeOutBeginningTHEText(varArtist)
        TakeOutBeginningTHEText = varArtist
        If Len(TakeOutBeginningTHEText) > 5 Then
            If UCase(Left(TakeOutBeginningTHEText, 4)) = "THE " Then
                TakeOutBeginningTHEText = Trim(Right(TakeOutBeginningTHEText, Len(TakeOutBeginningTHEText) - 4))
            End If
        End If
    End Function

    Public Function TakeOutEndingTHEText(varArtist)
        TakeOutEndingTHEText = varArtist
        If Len(TakeOutEndingTHEText) > 5 Then
            If UCase(Right(TakeOutEndingTHEText, 5)) = ", THE" Then
                TakeOutEndingTHEText = Trim(Left(TakeOutEndingTHEText, Len(TakeOutEndingTHEText) - 5))
            End If
        End If

    End Function
    Public Function FigureFedExAPIRates(strCartName As String, intCustomerServerCounter As Integer, strConnectionStringName As String)
        Dim FedExAPIRates(20) As Double
        For Each x In FedExAPIRates
            FedExAPIRates(x) = 0
        Next
        Dim strCity As String = ""
        Dim strStateProvince As String = ""
        Dim strStatProvinceCode As String = ""
        Dim strPostalCode As String = ""
        Dim strCountry As String = ""
        Dim strCountryCode As String = ""

        'Customer Address
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
            SqlConnection.ClearPool(conn)
            conn.Open()
            Dim CMD_Y As New SqlCommand("spGetCustomerDetailsByServerCounter", conn)
            CMD_Y.CommandType = Data.CommandType.StoredProcedure
            CMD_Y.Parameters.AddWithValue("@counter", intCustomerServerCounter)
            Dim readerY As SqlDataReader
            readerY = CMD_Y.ExecuteReader
            If readerY.HasRows Then
                readerY.Read()
                strCity = readerY("City")
                strStateProvince = readerY("StateProvince")
                strPostalCode = readerY("PostalCode")
                strCountry = readerY("Country")
            End If
        End Using
        'CustomerStateProvinceCode
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
            SqlConnection.ClearPool(conn)
            conn.Open()
            Dim CMD_Y As New SqlCommand("spGetStateProvinceCode", conn)
            CMD_Y.CommandType = Data.CommandType.StoredProcedure
            CMD_Y.Parameters.AddWithValue("@Country", strCountry)
            CMD_Y.Parameters.AddWithValue("@StateProvince", strStateProvince)
            Dim readerY As SqlDataReader
            readerY = CMD_Y.ExecuteReader
            If readerY.HasRows Then
                readerY.Read()
                strStatProvinceCode = readerY("StateProvinceAbbreviation")
            End If
        End Using
        'CountryCode
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
            SqlConnection.ClearPool(conn)
            conn.Open()
            Dim CMD_Y As New SqlCommand("select FedExCountryCode from webCountryShippingZonesT where Country='" & strCountry & "'", conn)
            CMD_Y.CommandType = Data.CommandType.text
            Dim readerY As SqlDataReader
            readerY = CMD_Y.ExecuteReader
            If readerY.HasRows Then
                readerY.Read()
                strCountryCode = readerY("FedExCountryCode")
            End If
        End Using



        'Shipment Weight
        Dim varWeightOfProductInGrams As Integer = 0
        Dim varWeightInPounds As Decimal = 0
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
            SqlConnection.ClearPool(conn)
            conn.Open()
            Dim CMD_Y As New SqlCommand("spGetWeightOfProduct", conn)
            CMD_Y.CommandType = Data.CommandType.StoredProcedure
            CMD_Y.Parameters.AddWithValue("@CartName", strCartName)
            Dim readerY As SqlDataReader
            readerY = CMD_Y.ExecuteReader
            If readerY.HasRows Then
                readerY.Read()
                varWeightOfProductInGrams = readerY("sumweight")
            End If
        End Using
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
            SqlConnection.ClearPool(conn)
            conn.Open()
            Dim CMD_X As New SqlCommand("spGetWebSHIPX_PackagingWeight", conn)
            CMD_X.CommandType = Data.CommandType.StoredProcedure
            CMD_X.Parameters.AddWithValue("@WeightInGrams", varWeightOfProductInGrams)
            CMD_X.Parameters.AddWithValue("@CartName", strCartName)
            Dim xx As SqlDataReader
            xx = CMD_X.ExecuteReader
            xx.Read()
            varWeightInPounds = CDec(varWeightOfProductInGrams) / 454 + CDbl(xx("PackagingWeight")) / 454
        End Using





    End Function
    Public Function FigureArtistsFromArtistTitle(varArtistTitle)
        Dim varTrack(6) As String
        Dim Artists(15) As String
        Dim varNumberOfTracks As Integer = 0
        Dim varSideA As String = ""
        Dim varSideB As String = ""
        Dim varSideASecond As String = ""
        Dim varSideBSecond As String = ""
        Dim varSemiColon As Integer = 0
        Dim varSemiColon2 As Integer = 0
        varTrack(1) = ""
        varTrack(2) = ""
        varTrack(3) = ""
        varTrack(4) = ""
        varTrack(5) = ""
        varTrack(6) = ""
        varArtistTitle = Trim(varArtistTitle)
        Dim varSlash As Integer = 0
        Dim varSpot As Integer = 0
        Dim x As Integer = 0
        Dim varArtistString As String = ""
        Dim varComma As Integer = 0
        Dim varArtist As String = ""
        Dim varAmp As Integer = 0
        Dim varArtist1 As String = ""
        Dim varArtist2 As String = ""
        'Figure Tracks
        varSlash = InStr(1, varArtistTitle, "/")
        If varSlash = 0 Or varSlash = Len(varArtistTitle) Then
            varNumberOfTracks = varNumberOfTracks + 1
            varTrack(varNumberOfTracks) = Trim(varArtistTitle)
        Else
            varSideA = Trim(Left(varArtistTitle, varSlash - 1))
            varSemiColon = InStr(1, varSideA, ";")
            If varSemiColon = 0 Or varSemiColon = Len(varSideA) Then
                varNumberOfTracks = varNumberOfTracks + 1
                varTrack(varNumberOfTracks) = Trim(varSideA)
            Else
                varNumberOfTracks = varNumberOfTracks + 1
                varTrack(varNumberOfTracks) = Trim(Left(varSideA, varSemiColon - 1))
                varSemiColon2 = InStr(varSemiColon + 1, varSideA, ";")
                If varSemiColon2 = 0 Or varSemiColon2 = Len(varSideA) Then
                    varNumberOfTracks = varNumberOfTracks + 1
                    varTrack(varNumberOfTracks) = Trim(Right(varSideA, Len(varSideA) - varSemiColon))
                Else
                    varSideASecond = Trim(Right(varSideA, Len(varSideA) - varSemiColon))
                    varNumberOfTracks = varNumberOfTracks + 1
                    varTrack(varNumberOfTracks) = Trim(Mid(varSideA, varSemiColon + 1, varSemiColon2 - varSemiColon - 1))
                    varNumberOfTracks = varNumberOfTracks + 1
                    varTrack(varNumberOfTracks) = Trim(Right(varSideASecond, Len(varSideA) - varSemiColon2))
                End If
            End If
            varSideB = Trim(Right(varArtistTitle, Len(varArtistTitle) - varSlash))
            varSemiColon = InStr(1, varSideB, ";")
            If varSemiColon = 0 Or varSemiColon = Len(varSideB) Then
                varNumberOfTracks = varNumberOfTracks + 1
                varTrack(varNumberOfTracks) = Trim(varSideB)
            Else
                varNumberOfTracks = varNumberOfTracks + 1
                varTrack(varNumberOfTracks) = Trim(Left(varSideB, varSemiColon - 1))
                varSemiColon2 = InStr(varSemiColon + 1, varSideB, ";")
                If varSemiColon2 = 0 Or varSemiColon2 = Len(varSideB) Then
                    varNumberOfTracks = varNumberOfTracks + 1
                    varTrack(varNumberOfTracks) = Trim(Right(varSideB, Len(varSideB) - varSemiColon))
                Else
                    varSideBSecond = Trim(Right(varSideB, Len(varSideB) - varSemiColon))
                    varNumberOfTracks = varNumberOfTracks + 1
                    varTrack(varNumberOfTracks) = Trim(Mid(varSideB, varSemiColon + 1, varSemiColon2 - varSemiColon - 1))
                    varNumberOfTracks = varNumberOfTracks + 1
                    varTrack(varNumberOfTracks) = Trim(Right(varSideBSecond, Len(varSideB) - varSemiColon2))
                End If
            End If
        End If
        'Take Out Bogus Text
        For n = 1 To 6
            If varTrack(n) <> "" Then
                If Len(varTrack(n)) > 6 Then
                    varTrack(n) = Replace(varTrack(n), "(USED ITEM)", "")
                    varTrack(n) = Replace(varTrack(n), "(ORIGINAL PRESS)", "")
                    varTrack(n) = Replace(varTrack(n), "(COLORED VINYL)", "")
                    varTrack(n) = Replace(varTrack(n), "(PICTURE SLEEVE)", "")
                    varTrack(n) = Replace(varTrack(n), "(REISSUE)", "")
                    varTrack(n) = Replace(varTrack(n), "USED ITEM:", "")
                    varTrack(n) = Replace(varTrack(n), "(", "")
                    varTrack(n) = Replace(varTrack(n), ")", "")
                End If
            End If
            varTrack(n) = Trim(varTrack(n))
        Next
        'Figure Artists
        For n = 1 To 15
            Artists(n) = "---"
        Next
        x = 0
        For n = 1 To 6
            If varTrack(n) = "" Then Exit For
            If InStr(1, varTrack(n), " - ") > 0 Then
                varArtistString = Trim(Left(varTrack(n), InStr(1, varTrack(n), " - ") - 1))
                Do
                    varComma = InStr(1, varArtistString, ",")
                    If varComma > 0 Then
                        varArtist = Trim(Left(varArtistString, varComma - 1))
                        varArtistString = Trim(Right(varArtistString, Len(varArtistString) - varComma))
                        If varArtist <> "" And varArtist <> "The" And varArtist <> "Etc." And varArtist <> "Etc" And varArtist <> Artists(1) And varArtist <> Artists(2) And varArtist <> Artists(3) And varArtist <> Artists(4) And varArtist <> Artists(5) And varArtist <> Artists(6) And varArtist <> Artists(7) And varArtist <> Artists(8) And varArtist <> Artists(9) And varArtist <> Artists(10) And varArtist <> Artists(11) And varArtist <> Artists(12) And varArtist <> Artists(13) And varArtist <> Artists(14) And varArtist <> Artists(15) Then
                            x = x + 1
                            Artists(x) = varArtist
                            varAmp = InStr(1, varArtist, "&")
                            If varAmp > 0 Then
                                varArtist1 = Trim(Left(varArtist, varAmp - 1))
                                If varArtist1 <> Artists(1) And varArtist1 <> Artists(2) And varArtist1 <> Artists(3) And varArtist1 <> Artists(4) And varArtist1 <> Artists(5) And varArtist1 <> Artists(6) And varArtist1 <> Artists(7) And varArtist1 <> Artists(8) And varArtist1 <> Artists(9) And varArtist1 <> Artists(10) And varArtist1 <> Artists(11) And varArtist1 <> Artists(12) And varArtist1 <> Artists(13) And varArtist1 <> Artists(14) And varArtist1 <> Artists(15) Then
                                    x = x + 1
                                    Artists(x) = varArtist1
                                End If
                                varArtist2 = Trim(Right(varArtist, Len(varArtist) - varAmp - 1))
                                If varArtist2 <> Artists(1) And varArtist2 <> Artists(2) And varArtist2 <> Artists(3) And varArtist2 <> Artists(4) And varArtist2 <> Artists(5) And varArtist2 <> Artists(6) And varArtist2 <> Artists(7) And varArtist2 <> Artists(8) And varArtist2 <> Artists(9) And varArtist2 <> Artists(10) And varArtist2 <> Artists(11) And varArtist2 <> Artists(12) And varArtist2 <> Artists(13) And varArtist2 <> Artists(14) And varArtist2 <> Artists(15) Then
                                    x = x + 1
                                    Artists(x) = varArtist2
                                End If
                            End If
                        End If
                    Else
                        varArtist = varArtistString
                        If varArtist <> "" And varArtist <> "The" And varArtist <> "Etc." And varArtist <> "Etc" And varArtist <> Artists(1) And varArtist <> Artists(2) And varArtist <> Artists(3) And varArtist <> Artists(4) And varArtist <> Artists(5) And varArtist <> Artists(6) And varArtist <> Artists(7) And varArtist <> Artists(8) And varArtist <> Artists(9) And varArtist <> Artists(10) And varArtist <> Artists(11) And varArtist <> Artists(12) And varArtist <> Artists(13) And varArtist <> Artists(14) And varArtist <> Artists(15) Then
                            x = x + 1
                            Artists(x) = varArtist
                            varAmp = InStr(1, varArtist, "&")
                            If varAmp > 0 Then
                                varArtist1 = Trim(Left(varArtist, varAmp - 1))
                                If varArtist1 <> Artists(1) And varArtist1 <> Artists(2) And varArtist1 <> Artists(3) And varArtist1 <> Artists(4) And varArtist1 <> Artists(5) And varArtist1 <> Artists(6) And varArtist1 <> Artists(7) And varArtist1 <> Artists(8) And varArtist1 <> Artists(9) And varArtist1 <> Artists(10) And varArtist1 <> Artists(11) And varArtist1 <> Artists(12) And varArtist1 <> Artists(13) And varArtist1 <> Artists(14) And varArtist1 <> Artists(15) Then
                                    x = x + 1
                                    Artists(x) = varArtist1
                                End If
                                varArtist2 = Trim(Right(varArtist, Len(varArtist) - varAmp - 1))
                                If varArtist2 <> Artists(1) And varArtist2 <> Artists(2) And varArtist2 <> Artists(3) And varArtist2 <> Artists(4) And varArtist2 <> Artists(5) And varArtist2 <> Artists(6) And varArtist2 <> Artists(7) And varArtist2 <> Artists(8) And varArtist2 <> Artists(9) And varArtist2 <> Artists(10) And varArtist2 <> Artists(11) And varArtist2 <> Artists(12) And varArtist2 <> Artists(13) And varArtist2 <> Artists(14) And varArtist2 <> Artists(15) Then
                                    x = x + 1
                                    Artists(x) = varArtist2
                                End If
                            End If
                        End If
                        Exit Do
                    End If
                Loop
            End If
        Next
        FigureArtistsFromArtistTitle = Artists
    End Function
    Public Function AssetsPath() As String
        AssetsPath = ConfigurationManager.appSettings("AssetsPath")
    End Function
    Public Function ImagesPath() As String
        ImagesPath = ConfigurationManager.appSettings("ImagesPath")
    End Function
    Public Function MP3sPath() As String
        MP3sPath = ConfigurationManager.appSettings("MP3sPath")
    End Function
    Public Function ScanPath(intID As Integer, strSize As String, strLetter As String) As String
        ScanPath = ""
        Dim strFolder As String = ""
        Dim strFolderZeros As String = "0000000"
        Dim intFolderNumbers As Integer = 0
        Dim intLengthOfFolderNumbers As Integer = 0
        intFolderNumbers = (Int(intID / 1000)) * 1000
        strFolder = intFolderNumbers.ToString
        intLengthOfFolderNumbers = Len(strFolder)
        strFolder = Left(strFolderZeros, 7 - intLengthOfFolderNumbers) & strFolder
        If UCase(strSize) = "LARGE" Then
            'If File.Exists(HttpContext.Current.Server.MapPath("/scans/" & "/" & strFolder & "/" & intID.ToString & strLetter & ".jpg")) Then
            ScanPath = ConfigurationManager.appSettings("ImagesPath") & "/" & strFolder & "/" & intID.ToString & strLetter & "-595.jpg"
            'End If
        ElseIf UCase(strSize) = "1130" Then
            'If File.Exists(HttpContext.Current.Server.MapPath("/scans/" & "/" & strFolder & "/" & intID.ToString & strLetter & "-1130.jpg")) Then
            ScanPath = ConfigurationManager.appSettings("ImagesPath") & "/" & strFolder & "/" & intID.ToString & strLetter & "-1130.jpg"
            'End If
        ElseIf UCase(strSize) = "320" Then
            'If File.Exists(HttpContext.Current.Server.MapPath("/scans/" & "/" & strFolder & "/" & intID.ToString & strLetter & "-320.jpg")) Then
            ScanPath = ConfigurationManager.appSettings("ImagesPath") & "/" & strFolder & "/" & intID.ToString & strLetter & "-320.jpg"
            'End If
        ElseIf UCase(strSize) = "MEDIUM" Then
            'If File.Exists(HttpContext.Current.Server.MapPath("/scans/" & "/" & strFolder & "/" & intID.ToString & strLetter & "-m.jpg")) Then
            ScanPath = ConfigurationManager.appSettings("ImagesPath") & "/" & strFolder & "/" & intID.ToString & strLetter & "-180.jpg"
            'End If
        ElseIf UCase(strSize) = "SMALL" Then
            'If File.Exists(HttpContext.Current.Server.MapPath("/scans/" & "/" & strFolder & "/" & intID.ToString & strLetter & "-s.jpg")) Then
            ScanPath = ConfigurationManager.appSettings("ImagesPath") & "/" & strFolder & "/" & intID.ToString & strLetter & "-54.jpg"
            'End If
        End If
    End Function
    Public Function MP3Folder(intID As Integer) As String
        MP3Folder = ""
        Dim strFolder As String = ""
        Dim strFolderZeros As String = "0000000"
        Dim intFolderNumbers As Integer = 0
        Dim intLengthOfFolderNumbers As Integer = 0
        intFolderNumbers = (Int(intID / 1000)) * 1000
        strFolder = intFolderNumbers.ToString
        intLengthOfFolderNumbers = Len(strFolder)
        MP3Folder = Left(strFolderZeros, 7 - intLengthOfFolderNumbers) & strFolder
    End Function

    Public Function FigureGridArtist(varGridArtist As String) As String
        Dim varSpace As Integer = 0
        Dim varDash As Integer = InStr(1, varGridArtist, " - ")
        FigureGridArtist = Trim(Left(varGridArtist, varDash))
        If Left(FigureGridArtist, 10) = "USED ITEM:" Then
            FigureGridArtist = Trim(Right(FigureGridArtist, Len(FigureGridArtist) - 10))
        End If
        If Len(FigureGridArtist) > 22 Then
            FigureGridArtist = Left(FigureGridArtist, 22)
            varSpace = InStrRev(varGridArtist, " ")
            If varSpace > 0 Then
                FigureGridArtist = Trim(Left(FigureGridArtist, varSpace))
                If Right(FigureGridArtist, 1) = "," Then
                    FigureGridArtist = Trim(Left(FigureGridArtist, Len(FigureGridArtist) - 1))
                End If
                FigureGridArtist = FigureGridArtist & "..."
            End If
        End If
    End Function
    Public Function FigureLength(x As String) As String
        FigureLength = x
        Dim varSpace As Integer = 0
        If Len(FigureLength) > 120 Then
            FigureLength = Left(FigureLength, 120)
            varSpace = InStrRev(FigureLength, " ")
            If varSpace > 0 Then
                FigureLength = Trim(Left(FigureLength, varSpace))
                If Right(FigureLength, 1) = "," Then
                    FigureLength = Trim(Left(FigureLength, Len(FigureLength) - 1))
                End If
                FigureLength = FigureLength & "..."
            End If
        End If
    End Function

    Public Function FigureGridArtistHoverText(varGridArtist As String) As String
        Dim varDash As Integer = InStr(1, varGridArtist, " - ")
        FigureGridArtistHoverText = Trim(Left(varGridArtist, varDash))
    End Function
    Public Function FigureGridTitleHoverText(varGridTitle As String) As String
        Dim varDash As Integer = InStr(1, varGridTitle, " - ")
        FigureGridTitleHoverText = Trim(Right(varGridTitle, Len(varGridTitle) - varDash - 2))
    End Function
    Public Function FigureWebOrderNumberLinks(strWebOrderNumbers As String, strInvoiceNumber As String) As String
        FigureWebOrderNumberLinks = ""
        strWebOrderNumbers = Trim(Replace(strWebOrderNumbers, " ", ""))
        Dim strWebOrderNumber As String = ""
        Dim strWebOrderNumberRemaining As String = ""
        Dim strWebOrderNumberToLookUp As String = ""
        Dim strOrderDate As String = ""
        Dim z As Integer = 0
        Dim intSemi As Integer = 0
        strWebOrderNumber = ""
        strWebOrderNumberRemaining = ""
        strOrderDate = ""
        If InStr(strWebOrderNumbers, ";") = 0 Then
            strWebOrderNumber = strWebOrderNumbers
            If strInvoiceNumber <> "" Then
                FigureWebOrderNumberLinks = "<p class='order-number-link'>" & strWebOrderNumber & "</p>"
            Else
                FigureWebOrderNumberLinks = "<a class='on'title='View order'href='/OrderReceived.aspx?WebOrderNumber=" & strWebOrderNumber & "'>" & strWebOrderNumber & "</a>"
            End If
        Else
            z = 0
            strWebOrderNumberRemaining = strWebOrderNumbers
            Do
                If Left(strWebOrderNumberRemaining, 1) = ";" Then
                    strWebOrderNumberRemaining = Right(strWebOrderNumberRemaining, Len(strWebOrderNumberRemaining) - 1)
                End If
                intSemi = InStr(strWebOrderNumberRemaining, ";")
                If intSemi = 0 Then
                    If strInvoiceNumber <> "" Then
                        FigureWebOrderNumberLinks = FigureWebOrderNumberLinks & "<br/><p class='order-number-link'>" & strWebOrderNumberRemaining & "</p>"
                    Else
                        FigureWebOrderNumberLinks = FigureWebOrderNumberLinks & "<br/><a class='on'title='View order'href='/OrderReceived.aspx?WebOrderNumber=" & strWebOrderNumberRemaining & "'>" & strWebOrderNumberRemaining & "</a>"
                    End If
                    Exit Do
                End If
                If Len(strWebOrderNumberRemaining) < 5 Then Exit Do
                strWebOrderNumber = Trim(Left(strWebOrderNumberRemaining, intSemi - 1))
                If strInvoiceNumber <> "" Then
                    FigureWebOrderNumberLinks = FigureWebOrderNumberLinks & "<br/><p class='order-number-link'>" & strWebOrderNumber & "</p>"
                Else
                    FigureWebOrderNumberLinks = FigureWebOrderNumberLinks & "<br/><a class='on'title='View order'href='/OrderReceived.aspx?WebOrderNumber=" & strWebOrderNumber & "'>" & strWebOrderNumber & "</a>"
                End If
                strWebOrderNumberRemaining = Trim(Right(strWebOrderNumberRemaining, Len(strWebOrderNumberRemaining) - intSemi))
            Loop
            If Left(FigureWebOrderNumberLinks, 5) = "<br/>" Then
                FigureWebOrderNumberLinks = Right(FigureWebOrderNumberLinks, Len(FigureWebOrderNumberLinks) - 5)
            End If
        End If

    End Function
    Public Function XYZ_FigureWebOrderNumberLinks(strWebOrderNumbers As String, strInvoiceNumber As String) As String
        XYZ_FigureWebOrderNumberLinks = ""
        strWebOrderNumbers = Trim(Replace(strWebOrderNumbers, " ", ""))
        Dim strWebOrderNumber As String = ""
        Dim strWebOrderNumberRemaining As String = ""
        Dim strWebOrderNumberToLookUp As String = ""
        Dim strOrderDate As String = ""
        Dim z As Integer = 0
        Dim intSemi As Integer = 0
        strWebOrderNumber = ""
        strWebOrderNumberRemaining = ""
        strOrderDate = ""
        If InStr(strWebOrderNumbers, ";") = 0 Then
            strWebOrderNumber = strWebOrderNumbers
            If strInvoiceNumber <> "" Then
                XYZ_FigureWebOrderNumberLinks = "<p class='order-number-link'>" & strWebOrderNumber & "</p>"
            Else
                XYZ_FigureWebOrderNumberLinks = "<a class='on'title='View order'onclick='showModalOverlay()'href='/XYZ-OrderReceived.aspx?WebOrderNumber=" & strWebOrderNumber & "'>" & strWebOrderNumber & "</a>"
            End If
        Else
            z = 0
            strWebOrderNumberRemaining = strWebOrderNumbers
            Do
                If Left(strWebOrderNumberRemaining, 1) = ";" Then
                    strWebOrderNumberRemaining = Right(strWebOrderNumberRemaining, Len(strWebOrderNumberRemaining) - 1)
                End If
                intSemi = InStr(strWebOrderNumberRemaining, ";")
                If intSemi = 0 Then
                    If strInvoiceNumber <> "" Then
                        XYZ_FigureWebOrderNumberLinks = XYZ_FigureWebOrderNumberLinks & "<br/><p class='order-number-link'>" & strWebOrderNumberRemaining & "</p>"
                    Else
                        XYZ_FigureWebOrderNumberLinks = XYZ_FigureWebOrderNumberLinks & "<br/><a class='on'title='View order'onclick='showModalOverlay()'href='/XYZ-OrderReceived.aspx?WebOrderNumber=" & strWebOrderNumberRemaining & "'>" & strWebOrderNumberRemaining & "</a>"
                    End If
                    Exit Do
                End If
                If Len(strWebOrderNumberRemaining) < 5 Then Exit Do
                strWebOrderNumber = Trim(Left(strWebOrderNumberRemaining, intSemi - 1))
                If strInvoiceNumber <> "" Then
                    XYZ_FigureWebOrderNumberLinks = XYZ_FigureWebOrderNumberLinks & "<br/><p class='order-number-link'>" & strWebOrderNumber & "</p>"
                Else
                    XYZ_FigureWebOrderNumberLinks = XYZ_FigureWebOrderNumberLinks & "<br/><a class='on'title='View order'onclick='showModalOverlay()'href='/XYZ-OrderReceived.aspx?WebOrderNumber=" & strWebOrderNumber & "'>" & strWebOrderNumber & "</a>"
                End If
                strWebOrderNumberRemaining = Trim(Right(strWebOrderNumberRemaining, Len(strWebOrderNumberRemaining) - intSemi))
            Loop
            If Left(XYZ_FigureWebOrderNumberLinks, 5) = "<br/>" Then
                XYZ_FigureWebOrderNumberLinks = Right(XYZ_FigureWebOrderNumberLinks, Len(XYZ_FigureWebOrderNumberLinks) - 5)
            End If
        End If

    End Function
    Public Function FigureGridTitle(varGridTitle As String) As String
        Dim varSpace As Integer = 0
        Dim varParen As Integer = 0
        Dim varDash As Integer = InStr(1, varGridTitle, " - ")
        FigureGridTitle = Trim(Right(varGridTitle, Len(varGridTitle) - varDash - 2))
        varDash = InStr(1, FigureGridTitle, " -")
        If Len(FigureGridTitle) > 40 Then
            FigureGridTitle = Left(FigureGridTitle, 40)
            varSpace = InStrRev(varGridTitle, " ")
            If varSpace > 0 Then
                FigureGridTitle = Trim(Left(FigureGridTitle, varSpace))
            End If
            If Right(FigureGridTitle, 1) = "-" Or Right(FigureGridTitle, 1) = "/" Or Right(FigureGridTitle, 1) = "&" Or Right(FigureGridTitle, 1) = "(" Or Right(FigureGridTitle, 1) = "+" Then
                FigureGridTitle = Trim(Left(FigureGridTitle, Len(FigureGridTitle) - 1))
            End If
            FigureGridTitle = Trim(FigureGridTitle) & "..."
        End If
    End Function
    Public Function RandomNumbersFunction(ByVal intNumberOfDigits As Integer) As String
        Dim nrand3 As Integer = 0
        Dim varXrandom3 As Integer = 0
        For nrand3 = 1 To Date.Today.Second + 1
            Randomize()
            varXrandom3 = Rnd(2000)
        Next
        RandomNumbersFunction = Int(Rnd() * (10 ^ (intNumberOfDigits) - 1))
    End Function
    Public Function NoQuotes(ByVal strText As String) As String
        Dim position As Integer = 1
        NoQuotes = Trim(strText)
        If Len(NoQuotes) > 0 Then
            position = InStr(1, NoQuotes, """")
            If position > 0 Then
                Do
                    NoQuotes = Left(NoQuotes, position - 1) & "'" & Right(NoQuotes, Len(NoQuotes) - position)
                    If position + 1 > Len(NoQuotes) Then Exit Do
                    position = InStr(position + 1, NoQuotes, """")
                    If position = 0 Then Exit Do
                Loop
            End If
        End If
    End Function
    Public Function FigureSignedInName(varCustomerName As String) As String
        FigureSignedInName = varCustomerName
        If FigureSignedInName = "" Then Exit Function
        Dim varComma As Integer = 0
        Do
            varComma = InStr(1, FigureSignedInName, ", cust.")
            If varComma = 0 Then
                Exit Do
            Else
                FigureSignedInName = Left(FigureSignedInName, varComma - 1)
            End If
        Loop
        If Len(FigureSignedInName) > 18 Then
            FigureSignedInName = Left(FigureSignedInName, 17) & "..."
        End If
    End Function

    Public Function FigureCustomerName(varCustomerName As String) As String
        FigureCustomerName = varCustomerName
        If FigureCustomerName = "" Then Exit Function
        Dim varComma As Integer = 0
        Do
            varComma = InStr(1, FigureCustomerName, ", cust.")
            If varComma = 0 Then
                Exit Do
            Else
                FigureCustomerName = Left(FigureCustomerName, varComma - 1)
            End If
        Loop
    End Function
    Public Function FigureShipViaServiceText(strTrackingNumber As String) As String
        FigureShipViaServiceText = strTrackingNumber
        If strTrackingNumber = "" Then
            Exit Function
        End If
        If Len(strTrackingNumber) < 3 Then Exit Function
        If Len(FigureShipViaServiceText) > 18 Then
            If Right(strTrackingNumber, 18) = "Mail International" Then
                FigureShipViaServiceText = Left(FigureShipViaServiceText, Len(FigureShipViaServiceText) - 18) & "Mail<BR>International"
            End If
        End If
    End Function
    Public Function FigureTrackingNumbers(strTrackingNumber As String) As String
        Dim plussignplace As Integer = 0
        Dim lastplussignplace As Integer = 0

        FigureTrackingNumbers = strTrackingNumber
        If strTrackingNumber = "" Then
            Exit Function
        End If
        If Len(strTrackingNumber) < 3 Then Exit Function
        Do
            If Len(strTrackingNumber) < 3 Then Exit Function
            If Right(strTrackingNumber, 1) = ";" Then
                strTrackingNumber = Left(strTrackingNumber, Len(strTrackingNumber) - 1)
            Else
                Exit Do
            End If
        Loop
        If InStr(1, strTrackingNumber, ";") = 0 Then
            Exit Function
        Else
            plussignplace = InStr(1, strTrackingNumber, ";")
            FigureTrackingNumbers = Trim(Left(strTrackingNumber, plussignplace - 1))
            lastplussignplace = plussignplace
            Do
                plussignplace = InStr(lastplussignplace + 1, strTrackingNumber, ";")
                If plussignplace > 0 Then
                    FigureTrackingNumbers = FigureTrackingNumbers & "<br>" & Trim(Mid(strTrackingNumber, lastplussignplace + 1, plussignplace - lastplussignplace - 1))
                Else
                    FigureTrackingNumbers = FigureTrackingNumbers & "<br>" & Trim(Right(strTrackingNumber, Len(strTrackingNumber) - lastplussignplace))
                    Exit Do
                End If
                lastplussignplace = plussignplace
            Loop
        End If
    End Function
    Public Function WebSiteSEOCode(txt As String) As String
        Dim varETC As Integer = 0
        txt = Trim(txt)
        WebSiteSEOCode = txt
        If WebSiteSEOCode = "" Then Exit Function
        If Left(UCase(WebSiteSEOCode), 9) = "VARIOUS -" Then
            WebSiteSEOCode = Trim(Right(WebSiteSEOCode, Len(WebSiteSEOCode) - 9))
        End If
        varETC = InStr(1, UCase(WebSiteSEOCode), ", ETC.")
        If varETC > 0 And Len(WebSiteSEOCode) > varETC + 8 Then
            WebSiteSEOCode = Trim(Right(WebSiteSEOCode, Len(WebSiteSEOCode) - varETC - 8))
        End If
        varETC = InStr(1, UCase(WebSiteSEOCode), ", ETC,")
        If varETC > 0 And Len(WebSiteSEOCode) > varETC + 8 Then
            WebSiteSEOCode = Trim(Right(WebSiteSEOCode, Len(WebSiteSEOCode) - varETC - 8))
        End If
    End Function
    Public Function SEOImagePath(txt As String, fmt As String, ID As String, FrontOrBack As String) As String
        Dim SEOFileName As String = ""
        Dim varAndSign As Integer = 0
        Dim varPlusSign As Integer = 0
        Dim varASC As Integer = 0
        Dim var2Dashes As Integer = 0

        txt = Trim(txt)
        SEOFileName = ""
        Do
            varAndSign = InStr(1, txt, " & ")
            If varAndSign > 0 Then
                txt = Trim(Left(txt, varAndSign - 1)) & " And " & Trim(Right(txt, Len(txt) - varAndSign - 2))
            Else
                Exit Do
            End If
        Loop
        Do
            varPlusSign = InStr(1, txt, " + ")
            If varPlusSign > 0 Then
                txt = Trim(Left(txt, varPlusSign - 1)) & " Plus " & Trim(Right(txt, Len(txt) - varPlusSign - 2))
            Else
                Exit Do
            End If
        Loop
        For n = 1 To Len(txt)
            varASC = Asc(Mid(txt, n, 1))
            If (varASC >= 65 And varASC <= 90) Or (varASC >= 97 And varASC <= 122) Or (varASC >= 48 And varASC <= 57) Or varASC = 32 Then
                If varASC = 32 Then
                    SEOFileName = SEOFileName & "-"
                Else
                    SEOFileName = SEOFileName & Mid(txt, n, 1)
                End If
            End If
        Next
        Do
            var2Dashes = InStr(1, SEOFileName, "--")
            If var2Dashes > 0 Then
                SEOFileName = Trim(Left(SEOFileName, var2Dashes - 1)) & "-" & Trim(Right(SEOFileName, Len(SEOFileName) - var2Dashes - 1))
            Else
                Exit Do
            End If
        Loop
        If FrontOrBack = "F" Then
            SEOImagePath = "/big-images/front/"
        Else
            SEOImagePath = "/big-images/back/"
        End If
        If fmt = "CD" Then
            SEOImagePath = SEOImagePath & "CD/"
        ElseIf fmt = "LP" Then
            SEOImagePath = SEOImagePath & "Vinyl/"
        ElseIf fmt = "CS" Then
            SEOImagePath = SEOImagePath & "Tapes/"
        ElseIf Left(fmt, 1) = "V" Then
            SEOImagePath = SEOImagePath & "VHS/"
        ElseIf Left(fmt, 1) = "7" Then
            SEOImagePath = SEOImagePath & "Vinyl/"
        ElseIf Left(fmt, 2) = "12" Then
            SEOImagePath = SEOImagePath & "Vinyl/"
        ElseIf Left(fmt, 2) = "10" Then
            SEOImagePath = SEOImagePath & "Vinyl/"
        ElseIf fmt = "CDS" Then
            SEOImagePath = SEOImagePath & "CD/"
        ElseIf fmt = "DVD" Then
            SEOImagePath = SEOImagePath & "DVD/"
        ElseIf fmt = "B" Then
            SEOImagePath = SEOImagePath & "Books/"
        Else
            SEOImagePath = SEOImagePath & "Miscellaneous/"
        End If
        SEOImagePath = SEOImagePath & ID & "/" & SEOFileName & ".jpg"
    End Function
    Public Function ItemDetails_FigureArtistWebHTML(varFormat As String, varArtistTitle As String, varItemDetailsWeb As String) As String
        Dim varUsedItemText As String = ""
        Dim varUsedItem As Integer = 0
        Dim strArtistTitleHTML As String = ""
        Dim varDash As Integer = 0
        Dim n As Integer = 0
        Dim varArtistString As String = ""
        Dim varRestOfArtistTitle As String = ""
        Dim varComma As Integer = 0

        'Used Items text ---------------------------------------------------------------------------------------------------
        If InStr(1, varArtistTitle, "USED ITEM:") > 0 Then
            varUsedItemText = "<span style='color:#000000;cursor:default'title='This item is not factory new. Please click on the item to view condition details. Satisfaction 100% guaranteed.'>USED ITEM:</span>" & " "
            varArtistTitle = Trim(Right(varArtistTitle, Len(varArtistTitle) - 10))
            varUsedItem = 1
        Else
            varUsedItemText = ""
            varUsedItem = 0
        End If

        'Artist Hyperlinks -------------------------------------------------------------------------------------------------
        Dim varTrack(15)
        Dim varArtists(15)
        n = 0
        strArtistTitleHTML = ""
        varTrack(n) = varArtistTitle
        varDash = InStr(1, varTrack(n), " - ")
        If varDash > 0 Then
            varArtistString = Trim(Left(varTrack(n), varDash - 1))
            varRestOfArtistTitle = Right(varTrack(n), Len(varTrack(n)) - varDash + 1)
            Do
                varComma = InStr(1, varArtistString, ",")
                If varComma > 0 Then
                    n = n + 1
                    varArtists(n) = Trim(Left(varArtistString, varComma - 1))
                    varArtistString = Trim(Right(varArtistString, Len(varArtistString) - varComma))
                Else
                    n = n + 1
                    varArtists(n) = Trim(varArtistString)
                    If n = 1 Then
                        If varArtists(n) = "Various" Then
                            strArtistTitleHTML = strArtistTitleHTML & "Various" & varRestOfArtistTitle
                        Else
                            strArtistTitleHTML = "<a class=""z""title=""Show all by this artist""href=""/home.aspx?i=1&artist=" & varArtists(n) & """>" & varArtists(n) & "</a>" & varRestOfArtistTitle
                        End If
                    Else
                        For x = 1 To n
                            If x < n Then
                                If varArtists(x + 1) = "The" Then
                                    strArtistTitleHTML = strArtistTitleHTML & "<a class=""z""title=""Show all by this artist""href=""/home.aspx?i=1&artist=" & varArtists(x) & ", The" & """>" & varArtists(x) & ", The" & "</a>" & ", "
                                    x = x + 1
                                Else
                                    strArtistTitleHTML = strArtistTitleHTML & "<a class=""z""title=""Show all by this artist""href=""/home.aspx?i=1&artist=" & varArtists(x) & """>" & varArtists(x) & "</a>" & ", "
                                End If
                            Else
                                If varArtists(x) = "Etc." Then
                                    strArtistTitleHTML = strArtistTitleHTML & "Etc."
                                ElseIf varArtists(x) = "Various" Then
                                    strArtistTitleHTML = strArtistTitleHTML & "Various"
                                Else
                                    strArtistTitleHTML = strArtistTitleHTML & "<a class=""z""title=""Show all by this artist""href=""/home.aspx?i=1&artist=" & varArtists(x) & """>" & varArtists(x) & "</a>"
                                End If
                            End If
                        Next
                        If Right(strArtistTitleHTML, 2) = ", " Then
                            strArtistTitleHTML = Left(strArtistTitleHTML, Len(strArtistTitleHTML) - 2) & " "
                        End If
                        strArtistTitleHTML = strArtistTitleHTML & varRestOfArtistTitle
                    End If
                    Exit Do
                End If
            Loop
        Else
            strArtistTitleHTML = varArtistTitle
        End If
        ItemDetails_FigureArtistWebHTML = strArtistTitleHTML
    End Function
    Public Function XYZ_ItemDetails_FigureArtistWebHTML(varFormat As String, varArtistTitle As String, varItemDetailsWeb As String) As String
        Dim varUsedItemText As String = ""
        Dim varUsedItem As Integer = 0
        Dim strArtistTitleHTML As String = ""
        Dim varDash As Integer = 0
        Dim n As Integer = 0
        Dim varArtistString As String = ""
        Dim varRestOfArtistTitle As String = ""
        Dim varComma As Integer = 0

        'Used Items text ---------------------------------------------------------------------------------------------------
        If InStr(1, varArtistTitle, "USED ITEM:") > 0 Then
            varUsedItemText = "<span style='color:#000000;cursor:default'title='This item is not factory new. Please click on the item to view condition details. Satisfaction 100% guaranteed.'>USED ITEM:</span>" & " "
            varArtistTitle = Trim(Right(varArtistTitle, Len(varArtistTitle) - 10))
            varUsedItem = 1
        Else
            varUsedItemText = ""
            varUsedItem = 0
        End If

        'Artist Hyperlinks -------------------------------------------------------------------------------------------------
        Dim varTrack(15)
        Dim varArtists(15)
        n = 0
        strArtistTitleHTML = ""
        varTrack(n) = varArtistTitle
        varDash = InStr(1, varTrack(n), " - ")
        If varDash > 0 Then
            varArtistString = Trim(Left(varTrack(n), varDash - 1))
            varRestOfArtistTitle = Right(varTrack(n), Len(varTrack(n)) - varDash + 1)
            Do
                varComma = InStr(1, varArtistString, ",")
                If varComma > 0 Then
                    n = n + 1
                    varArtists(n) = Trim(Left(varArtistString, varComma - 1))
                    varArtistString = Trim(Right(varArtistString, Len(varArtistString) - varComma))
                Else
                    n = n + 1
                    varArtists(n) = Trim(varArtistString)
                    If n = 1 Then
                        If varArtists(n) = "Various" Then
                            strArtistTitleHTML = strArtistTitleHTML & "Various" & varRestOfArtistTitle
                        Else
                            strArtistTitleHTML = "<a class=""z""title=""Show all by this artist""href=""/XYZ-home.aspx?i=1&artist=" & varArtists(n) & """>" & varArtists(n) & "</a>" & varRestOfArtistTitle
                        End If
                    Else
                        For x = 1 To n
                            If x < n Then
                                If varArtists(x + 1) = "The" Then
                                    strArtistTitleHTML = strArtistTitleHTML & "<a class=""z""title=""Show all by this artist""href=""/XYZ-home.aspx?i=1&artist=" & varArtists(x) & ", The" & """>" & varArtists(x) & ", The" & "</a>" & ", "
                                    x = x + 1
                                Else
                                    strArtistTitleHTML = strArtistTitleHTML & "<a class=""z""title=""Show all by this artist""href=""/XYZ-home.aspx?i=1&artist=" & varArtists(x) & """>" & varArtists(x) & "</a>" & ", "
                                End If
                            Else
                                If varArtists(x) = "Etc." Then
                                    strArtistTitleHTML = strArtistTitleHTML & "Etc."
                                ElseIf varArtists(x) = "Various" Then
                                    strArtistTitleHTML = strArtistTitleHTML & "Various"
                                Else
                                    strArtistTitleHTML = strArtistTitleHTML & "<a class=""z""title=""Show all by this artist""href=""/XYZ-home.aspx?i=1&artist=" & varArtists(x) & """>" & varArtists(x) & "</a>"
                                End If
                            End If
                        Next
                        If Right(strArtistTitleHTML, 2) = ", " Then
                            strArtistTitleHTML = Left(strArtistTitleHTML, Len(strArtistTitleHTML) - 2) & " "
                        End If
                        strArtistTitleHTML = strArtistTitleHTML & varRestOfArtistTitle
                    End If
                    Exit Do
                End If
            Loop
        Else
            strArtistTitleHTML = varArtistTitle
        End If
        XYZ_ItemDetails_FigureArtistWebHTML = strArtistTitleHTML
    End Function
    Public Function ST(varSTText As String) As String
        Dim position As Integer = 0
        ST = varSTText
        position = InStr(1, ST, "'")
        If position > 0 Then
            Do
                ST = Left(ST, position - 1) & "`" & Right(ST, Len(ST) - position)
                position = InStr(position + 1, ST, "'")
                If position = 0 Then Exit Do
            Loop
        End If
        position = InStr(1, ST, "-")
        If position > 0 Then
            Do
                ST = Left(ST, position - 1) & Right(ST, Len(ST) - position)
                position = InStr(position + 1, ST, "-")
                If position = 0 Then Exit Do
            Loop
        End If
        position = InStr(1, ST, ";")
        If position > 0 Then
            Do
                ST = Left(ST, position - 1) & Right(ST, Len(ST) - position)
                position = InStr(position + 1, ST, ";")
                If position = 0 Then Exit Do
            Loop
        End If
    End Function

    Public Function FixSQLText(ByVal txt As String) As String
        FixSQLText = txt
        If FixSQLText = "" Then Exit Function

        FixSQLText = Replace(FixSQLText, "[", "")
        FixSQLText = Replace(FixSQLText, "]", "")
        If FixSQLText = "" Then Exit Function

        Dim intASC As Integer = 0
        Dim n As Integer = 0
        Dim strNewText As String = ""
        For n = 1 To Len(FixSQLText)
            If Asc(Mid(FixSQLText, n, 1)) < 123 Then
                strNewText = strNewText & Mid(FixSQLText, n, 1)
            End If
        Next
        FixSQLText = strNewText
        If FixSQLText = "" Then Exit Function

        FixSQLText = Replace(FixSQLText, "'", "''")
        FixSQLText = Replace(FixSQLText, "%", "[%]")
        FixSQLText = Replace(FixSQLText, """", "[""]")

    End Function

    Public Function CheckSQLInjectionText(ByVal varText As String) As String
        CheckSQLInjectionText = 0
        varText = UCase(varText)
        If InStr(1, varText, "CHAR%28") > 0 Or InStr(1, varText, "CHAR(") > 0 Then
            CheckSQLInjectionText = 1
        ElseIf InStr(1, varText, "--") > 0 Then
            CheckSQLInjectionText = 1
        ElseIf InStr(1, varText, "EXEC%28") > 0 Or InStr(1, varText, "EXEC(") > 0 Then
            CheckSQLInjectionText = 1
        End If
    End Function
    Public Function EmptyStringToDBNull(ByVal strText As String)
        If strText = "" Then
            EmptyStringToDBNull = DBNull.Value
        Else
            EmptyStringToDBNull = strText
        End If
    End Function
    Public Function FigureSpacesForCCNumber(ByVal strText As String)
        FigureSpacesForCCNumber = ""
        strText = Replace(strText, " ", "")
        If strText = "" Then Exit Function
        If Left(strText, 1) = "3" Then
            If Len(strText) <= 4 Then
            ElseIf Len(strText) <= 10 Then
                strText = Left(strText, 4) & " " & Right(strText, Len(strText) - 4)
            Else
                strText = Left(strText, 4) & " " & Mid(strText, 5, 6) & " " & Right(strText, Len(strText) - 10)
            End If
        Else
            If Len(strText) <= 4 Then
            ElseIf Len(strText) <= 8 Then
                strText = Left(strText, 4) & " " & Right(strText, Len(strText) - 4)
            ElseIf Len(strText) <= 12 Then
                strText = Left(strText, 4) & " " & Mid(strText, 5, 4) & " " & Right(strText, Len(strText) - 8)
            Else
                strText = Left(strText, 4) & " " & Mid(strText, 5, 4) & " " & Mid(strText, 9, 4) & " " & Right(strText, Len(strText) - 12)
            End If
        End If
        FigureSpacesForCCNumber = strText
    End Function
    Public Function ZeroToDBNull(ByVal varNumber)
        If varNumber = 0 Then
            ZeroToDBNull = DBNull.Value
        Else
            ZeroToDBNull = varNumber
        End If
    End Function
    Public Function DateDBNullToString(ByVal varDate As DateTime) As DateTime
        If IsDBNull(varDate) Then
            DateDBNullToString = ""
        Else
            DateDBNullToString = varDate
        End If
    End Function

    Public Function IsDBSomething(ByVal varSomeVariable, ByVal varAlternateValue)
        If IsDBNull(varSomeVariable) Then
            IsDBSomething = varAlternateValue
        Else
            IsDBSomething = varSomeVariable
        End If
    End Function
    Public Function IsSomething(ByVal varSomeVariable, ByVal varAlternateValue)
        If String.IsNullOrEmpty(varSomeVariable) Then
            IsSomething = varAlternateValue
        Else
            If varSomeVariable = "" Then
                IsSomething = varAlternateValue
            Else
                IsSomething = varSomeVariable
            End If
        End If
    End Function


    Public Function Z_EmailFooter(strConnectionStringName As String) As String
        Z_EmailFooter = ""
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
            SqlConnection.ClearPool(conn)
            conn.Open()
            Dim CMD_EmailFooter As New SqlCommand("spGetEmailFooter", conn)
            CMD_EmailFooter.CommandType = Data.CommandType.StoredProcedure
            Dim readerEmailFooter As SqlDataReader
            readerEmailFooter = CMD_EmailFooter.ExecuteReader
            If readerEmailFooter.HasRows Then
                readerEmailFooter.Read()
                Z_EmailFooter = readerEmailFooter("Footer")
            End If
        End Using
    End Function
    Public Function Z_SHIPX_FigureAirParcelPostZone(subVarCountry As String, strConnectionStringName As String) As String
        If subVarCountry = "USA" Then
            Z_SHIPX_FigureAirParcelPostZone = "NA"
        Else
            Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
                SqlConnection.ClearPool(conn)
                conn.Open()
                Dim CMD_X As New SqlCommand("spUSPSNotShippingTo", conn)
                CMD_X.CommandType = Data.CommandType.StoredProcedure
                CMD_X.Parameters.AddWithValue("@Country", subVarCountry)
                Dim readerX As SqlDataReader
                readerX = CMD_X.ExecuteReader
                If readerX.HasRows Then
                    Return "NA"
                End If
            End Using

            Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
                SqlConnection.ClearPool(conn)
                conn.Open()
                Dim CMD_X As New SqlCommand("spGetAirParcelPostZone", conn)
                CMD_X.CommandType = Data.CommandType.StoredProcedure
                CMD_X.Parameters.AddWithValue("@Country", subVarCountry)
                Dim readerX As SqlDataReader
                readerX = CMD_X.ExecuteReader
                If readerX.HasRows Then
                    readerX.Read()
                    Z_SHIPX_FigureAirParcelPostZone = readerX("AirParcelPostZone")
                End If
            End Using
        End If
    End Function
    Public Function Z_SHIPX_FigureExpressMailZone(subVarCountry As String, subVarState As String, subVarPriceGroup As String, subVarZip As String) As String
        Z_SHIPX_FigureExpressMailZone = "NA"
        Exit Function
        If subVarCountry = "USA" Then
            If subVarState = "American Samoa" Or subVarState = "Guam" Or subVarState = "Marshall Islands" Or subVarState = "Micronesia" Or subVarState = "Northern Mariana Islands" Or subVarState = "Palau" Or subVarState = "Puerto Rico" Or subVarState = "Virgin Islands (U.S.)" Then
                Z_SHIPX_FigureExpressMailZone = "1"
            End If
        End If
    End Function
    Public Function Z_SHIPX_FigureDHLInternationalZone(subVarCountry As String, strConnectionStringName As String) As String
        Z_SHIPX_FigureDHLInternationalZone = "NA"
        If subVarCountry = "USA" Then
            Z_SHIPX_FigureDHLInternationalZone = "NA"
        Else
            Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
                SqlConnection.ClearPool(conn)
                conn.Open()
                Dim CMD_X As New SqlCommand("spGetAirParcelPostZone", conn)
                CMD_X.CommandType = Data.CommandType.StoredProcedure
                CMD_X.Parameters.AddWithValue("@Country", subVarCountry)
                Dim readerX As SqlDataReader
                readerX = CMD_X.ExecuteReader
                If readerX.HasRows Then
                    readerX.Read()
                    If readerX("DHLFlatRate") <> 0 Then
                        Z_SHIPX_FigureDHLInternationalZone = readerX("DHLInternationalExpressZone")
                    End If
                End If
            End Using
        End If
    End Function

    Public Function Z_SHIPX_FigureFedExInternationalPriorityZone(subVarCountry As String, subVarZip As String, strConnectionStringName As String) As String
        If subVarCountry = "USA" Then
            Z_SHIPX_FigureFedExInternationalPriorityZone = "NA"
        Else
            Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
                SqlConnection.ClearPool(conn)
                conn.Open()
                Dim CMD_X As New SqlCommand("spGetAirParcelPostZone", conn)
                CMD_X.CommandType = Data.CommandType.StoredProcedure
                CMD_X.Parameters.AddWithValue("@Country", subVarCountry)
                Dim readerX As SqlDataReader
                readerX = CMD_X.ExecuteReader
                If readerX.HasRows Then
                    readerX.Read()
                    Z_SHIPX_FigureFedExInternationalPriorityZone = readerX("FedExInternationalPriorityZone")
                End If
            End Using
            Dim subVarZipString As String = ""
            If subVarCountry = "Canada" Then
                subVarZipString = Left(subVarZip, 3)
                If subVarZipString <= "G9Z" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "B"
                ElseIf subVarZipString <= "H9Z" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "A"
                ElseIf subVarZipString <= "J2W" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "B"
                ElseIf subVarZipString <= "J3G" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "A"
                ElseIf subVarZipString <= "J3K" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "B"
                ElseIf subVarZipString <= "J3N" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "A"
                ElseIf subVarZipString <= "J3T" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "B"
                ElseIf subVarZipString <= "J4Z" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "A"
                ElseIf subVarZipString <= "J6H" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "B"
                ElseIf subVarZipString <= "J6R" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "A"
                ElseIf subVarZipString <= "J6V" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "B"
                ElseIf subVarZipString <= "J7R" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "A"
                ElseIf subVarZipString <= "J8N" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "B"
                ElseIf subVarZipString <= "J9C" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "A"
                ElseIf subVarZipString <= "J9Z" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "B"
                ElseIf subVarZipString <= "K0Z" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "B"
                ElseIf subVarZipString <= "K2R" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "A"
                ElseIf subVarZipString <= "L0H" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "B"
                ElseIf subVarZipString <= "L0J" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "A"
                ElseIf subVarZipString <= "L0N" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "B"
                ElseIf subVarZipString <= "L0P" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "A"
                ElseIf subVarZipString <= "L1E" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "B"
                ElseIf subVarZipString <= "L1Z" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "A"
                ElseIf subVarZipString <= "L2C" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "B"
                ElseIf subVarZipString <= "L2W" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "A"
                ElseIf subVarZipString <= "L3N" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "B"
                ElseIf subVarZipString <= "L3T" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "A"
                ElseIf subVarZipString <= "L3W" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "B"
                ElseIf subVarZipString <= "L9T" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "A"
                ElseIf subVarZipString <= "L9Z" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "B"
                ElseIf subVarZipString <= "M9Z" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "A"
                ElseIf subVarZipString <= "N1Z" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "B"
                ElseIf subVarZipString <= "N2V" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "A"
                ElseIf subVarZipString <= "N5T" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "B"
                ElseIf subVarZipString <= "N6N" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "A"
                ElseIf subVarZipString <= "N8M" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "B"
                ElseIf subVarZipString <= "N9K" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "A"
                ElseIf subVarZipString <= "P9Z" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "B"
                ElseIf subVarZipString <= "R2B" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "B"
                ElseIf subVarZipString <= "R4A" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "A"
                ElseIf subVarZipString <= "R9Z" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "B"
                ElseIf subVarZipString <= "S9Z" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "B"
                ElseIf subVarZipString <= "T1X" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "B"
                ElseIf subVarZipString <= "T3L" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "A"
                ElseIf subVarZipString <= "T9Z" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "B"
                ElseIf subVarZipString <= "V1L" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "B"
                ElseIf subVarZipString <= "V1M" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "A"
                ElseIf subVarZipString <= "V2V" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "B"
                ElseIf subVarZipString <= "V3E" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "A"
                ElseIf subVarZipString <= "V3G" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "B"
                ElseIf subVarZipString <= "V4S" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "A"
                ElseIf subVarZipString <= "V4T" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "B"
                ElseIf subVarZipString <= "V7Z" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "A"
                ElseIf subVarZipString <= "V9Z" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "B"
                ElseIf subVarZipString <= "X9Z" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "B"
                ElseIf subVarZipString <= "Y9Z" Then
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "B"
                Else
                    Z_SHIPX_FigureFedExInternationalPriorityZone = "B"
                End If
            End If
        End If
    End Function
    Public Function Z_SHIPX_FigureZipCodeFromStateProvince(subVarStateProvince As String) As String
        Z_SHIPX_FigureZipCodeFromStateProvince = "95762"
        If subVarStateProvince = "American Samoa" Then
            Z_SHIPX_FigureZipCodeFromStateProvince = "96799"
        End If
    End Function
    Public Function Z_SHIPX_FigureIfPOBoxAllowed(subVarShippingMethod As String, strConnectionStringName As String) As String
        Z_SHIPX_FigureIfPOBoxAllowed = "N"
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
            SqlConnection.ClearPool(conn)
            conn.Open()
            Dim CMD_X As New SqlCommand("spGetShippingMethodsRow", conn)
            CMD_X.CommandType = Data.CommandType.StoredProcedure
            CMD_X.Parameters.AddWithValue("@ShippingMethodCode", subVarShippingMethod)
            Dim readerX As SqlDataReader
            readerX = CMD_X.ExecuteReader
            If readerX.HasRows Then
                readerX.Read()
                Z_SHIPX_FigureIfPOBoxAllowed = readerX("POBoxOK")
            End If
        End Using
    End Function
    Public Function Z_SHIPX_FigureArrivalDate(subVarShipDate As Date, subVarDays As String, subVarShippingMethod As String, strConnectionStringName As String)
        If Len(subVarShipDate) = 0 Or Len(subVarDays) = 0 Or Len(subVarShippingMethod) = 0 Then
            Z_SHIPX_FigureArrivalDate = ""
            Exit Function
        End If

        If subVarDays = "" Or subVarDays = "NA" Then
            Z_SHIPX_FigureArrivalDate = ""
            Exit Function
        End If

        Dim varFirstArrivalDate As Date
        Dim varSecondArrivalDate As Date
        Dim intFirstDays As Integer = 0
        Dim intSecondDays As Integer = 0
        Dim subN As Integer = 0

        Dim subVarHolidayColumnName As String = ""
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
            SqlConnection.ClearPool(conn)
            conn.Open()
            Dim CMD_X As New SqlCommand("spGetShippingMethodsRow", conn)
            CMD_X.CommandType = Data.CommandType.StoredProcedure
            CMD_X.Parameters.AddWithValue("@ShippingMethodCode", subVarShippingMethod)
            Dim readerX As SqlDataReader
            readerX = CMD_X.ExecuteReader
            If readerX.HasRows Then
                readerX.Read()
                subVarHolidayColumnName = readerX("HolidayColumnName")
            End If
        End Using

        'Fedex And UPS and DHL ----------------------------------------------------------------------------------------------------------------------
        If Left(UCase(subVarShippingMethod), 2) = "FE" Or Left(UCase(subVarShippingMethod), 2) = "UP" Then

            'Exact Date---------------
            If InStr(1, subVarDays, "-") = 0 Then
                'Ship Date
                Z_SHIPX_FigureArrivalDate = subVarShipDate
                Do
                    If Weekday(Z_SHIPX_FigureArrivalDate) = 1 Then
                        Z_SHIPX_FigureArrivalDate = Z_SHIPX_FigureArrivalDate.AddDays(1)
                    ElseIf Weekday(Z_SHIPX_FigureArrivalDate) = 7 Then
                        Z_SHIPX_FigureArrivalDate = Z_SHIPX_FigureArrivalDate.AddDays(2)
                    Else
                        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
                            SqlConnection.ClearPool(conn)
                            conn.Open()
                            Dim CMD_D As New SqlCommand("spGetWebSHIPX_ShippingHolidaysOutboundRow", conn)
                            CMD_D.CommandType = Data.CommandType.StoredProcedure
                            CMD_D.Parameters.AddWithValue("@Date", Z_SHIPX_FigureArrivalDate)
                            Dim readerD As SqlDataReader
                            readerD = CMD_D.ExecuteReader
                            readerD.Read()
                            If IsDBSomething(readerD(subVarHolidayColumnName), "") = "y" Or IsDBSomething(readerD("WorkHoliday"), "") = "y" Then
                                Z_SHIPX_FigureArrivalDate = Z_SHIPX_FigureArrivalDate.AddDays(1)
                            Else
                                Exit Do
                            End If
                        End Using
                    End If
                Loop

                'Transit Days
                For subN = 1 To subVarDays
                    Z_SHIPX_FigureArrivalDate = Z_SHIPX_FigureArrivalDate.AddDays(1)
                    Do
                        If Weekday(Z_SHIPX_FigureArrivalDate) = 1 Then
                            Z_SHIPX_FigureArrivalDate = Z_SHIPX_FigureArrivalDate.AddDays(1)
                        ElseIf Weekday(Z_SHIPX_FigureArrivalDate) = 7 Then
                            Z_SHIPX_FigureArrivalDate = Z_SHIPX_FigureArrivalDate.AddDays(2)
                        Else
                            Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
                                SqlConnection.ClearPool(conn)
                                conn.Open()
                                Dim CMD_D As New SqlCommand("spGetWebSHIPX_ShippingHolidaysOutboundRow", conn)
                                CMD_D.CommandType = Data.CommandType.StoredProcedure
                                CMD_D.Parameters.AddWithValue("@Date", Z_SHIPX_FigureArrivalDate)
                                Dim readerD As SqlDataReader
                                readerD = CMD_D.ExecuteReader
                                readerD.Read()
                                If IsDBSomething(readerD(subVarHolidayColumnName), "") = "y" Then
                                    Z_SHIPX_FigureArrivalDate = Z_SHIPX_FigureArrivalDate.AddDays(1)
                                Else
                                    Exit Do
                                End If
                            End Using
                        End If
                    Loop
                Next
                Return "Arrives " & Format(Z_SHIPX_FigureArrivalDate, "MMMM") & " " & Day(Z_SHIPX_FigureArrivalDate)
                'Date Range------------
            Else
                intFirstDays = CInt(Left(subVarDays, InStr(1, subVarDays, "-") - 1))
                intSecondDays = CInt(Trim(Right(subVarDays, Len(subVarDays) - InStr(1, subVarDays, "-"))))

                'Ship Date
                varFirstArrivalDate = subVarShipDate
                Do
                    If Weekday(Z_SHIPX_FigureArrivalDate) = 1 Then
                        varFirstArrivalDate = varFirstArrivalDate.AddDays(1)
                    ElseIf Weekday(Z_SHIPX_FigureArrivalDate) = 7 Then
                        varFirstArrivalDate = varFirstArrivalDate.AddDays(2)
                    Else
                        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
                            SqlConnection.ClearPool(conn)
                            conn.Open()
                            Dim CMD_D As New SqlCommand("spGetWebSHIPX_ShippingHolidaysOutboundRow", conn)
                            CMD_D.CommandType = Data.CommandType.StoredProcedure
                            CMD_D.Parameters.AddWithValue("@Date", varFirstArrivalDate)
                            Dim readerD As SqlDataReader
                            readerD = CMD_D.ExecuteReader
                            readerD.Read()
                            If IsDBSomething(readerD(subVarHolidayColumnName), "") = "y" Or IsDBSomething(readerD("WorkHoliday"), "") = "y" Then
                                varFirstArrivalDate = varFirstArrivalDate.AddDays(1)
                            Else
                                Exit Do
                            End If
                        End Using
                    End If
                Loop
                varSecondArrivalDate = varFirstArrivalDate
                'First Transit Days
                For subN = 1 To intFirstDays
                    varFirstArrivalDate = varFirstArrivalDate.AddDays(1)
                    Do
                        If Weekday(varFirstArrivalDate) = 1 Then
                            varFirstArrivalDate = varFirstArrivalDate.AddDays(1)
                        ElseIf Weekday(varFirstArrivalDate) = 7 Then
                            varFirstArrivalDate = varFirstArrivalDate.AddDays(2)
                        Else
                            Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
                                SqlConnection.ClearPool(conn)
                                conn.Open()
                                Dim CMD_D As New SqlCommand("spGetWebSHIPX_ShippingHolidaysOutboundRow", conn)
                                CMD_D.CommandType = Data.CommandType.StoredProcedure
                                CMD_D.Parameters.AddWithValue("@Date", varFirstArrivalDate)
                                Dim readerD As SqlDataReader
                                readerD = CMD_D.ExecuteReader
                                readerD.Read()
                                If IsDBSomething(readerD(subVarHolidayColumnName), "") = "y" Then
                                    varFirstArrivalDate = varFirstArrivalDate.AddDays(1)
                                Else
                                    Exit Do
                                End If
                            End Using
                        End If
                    Loop
                Next
                'Second Transit Days
                For subN = 1 To intSecondDays
                    varSecondArrivalDate = varSecondArrivalDate.AddDays(1)
                    Do
                        If Weekday(varSecondArrivalDate) = 1 Then
                            varSecondArrivalDate = varSecondArrivalDate.AddDays(1)
                        ElseIf Weekday(varSecondArrivalDate) = 7 Then
                            varSecondArrivalDate = varSecondArrivalDate.AddDays(2)
                        Else
                            Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
                                SqlConnection.ClearPool(conn)
                                conn.Open()
                                Dim CMD_D As New SqlCommand("spGetWebSHIPX_ShippingHolidaysOutboundRow", conn)
                                CMD_D.CommandType = Data.CommandType.StoredProcedure
                                CMD_D.Parameters.AddWithValue("@Date", varSecondArrivalDate)
                                Dim readerD As SqlDataReader
                                readerD = CMD_D.ExecuteReader
                                readerD.Read()
                                If IsDBSomething(readerD(subVarHolidayColumnName), "") = "y" Then
                                    varSecondArrivalDate = varSecondArrivalDate.AddDays(1)
                                Else
                                    Exit Do
                                End If
                            End Using
                        End If
                    Loop
                Next
                Return "Arrives " & Format(varFirstArrivalDate, "MMMM") & " " & Day(varFirstArrivalDate) & " - " & Format(varSecondArrivalDate, "MMMM") & " " & Day(varSecondArrivalDate)
            End If

            'US Mail ---------------------------------------------------------------------------------------------------------------------------------
        Else

            'Exact Date---------------
            If InStr(1, subVarDays, "-") = 0 Then
                'Ship Date
                Z_SHIPX_FigureArrivalDate = subVarShipDate
                Do
                    If Weekday(Z_SHIPX_FigureArrivalDate) = 1 Then
                        Z_SHIPX_FigureArrivalDate = Z_SHIPX_FigureArrivalDate.AddDays(1)
                    Else
                        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
                            SqlConnection.ClearPool(conn)
                            conn.Open()
                            Dim CMD_D As New SqlCommand("spGetWebSHIPX_ShippingHolidaysOutboundRow", conn)
                            CMD_D.CommandType = Data.CommandType.StoredProcedure
                            CMD_D.Parameters.AddWithValue("@Date", Z_SHIPX_FigureArrivalDate)
                            Dim readerD As SqlDataReader
                            readerD = CMD_D.ExecuteReader
                            readerD.Read()
                            If IsDBSomething(readerD(subVarHolidayColumnName), "") = "y" Or IsDBSomething(readerD("WorkHoliday"), "") = "y" Then
                                Z_SHIPX_FigureArrivalDate = Z_SHIPX_FigureArrivalDate.AddDays(1)
                            Else
                                Exit Do
                            End If
                        End Using
                    End If
                Loop

                'Transit Days
                For subN = 1 To subVarDays
                    Z_SHIPX_FigureArrivalDate = Z_SHIPX_FigureArrivalDate.AddDays(1)
                    Do
                        If Weekday(Z_SHIPX_FigureArrivalDate) = 1 Then
                            Z_SHIPX_FigureArrivalDate = Z_SHIPX_FigureArrivalDate.AddDays(1)
                        Else
                            Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
                                SqlConnection.ClearPool(conn)
                                conn.Open()
                                Dim CMD_D As New SqlCommand("spGetWebSHIPX_ShippingHolidaysOutboundRow", conn)
                                CMD_D.CommandType = Data.CommandType.StoredProcedure
                                CMD_D.Parameters.AddWithValue("@Date", Z_SHIPX_FigureArrivalDate)
                                Dim readerD As SqlDataReader
                                readerD = CMD_D.ExecuteReader
                                readerD.Read()
                                If IsDBSomething(readerD(subVarHolidayColumnName), "") = "y" Then
                                    Z_SHIPX_FigureArrivalDate = Z_SHIPX_FigureArrivalDate.AddDays(1)
                                Else
                                    Exit Do
                                End If
                            End Using
                        End If
                    Loop
                Next
                Return "Arrives " & Format(Z_SHIPX_FigureArrivalDate, "MMMM") & " " & Day(Z_SHIPX_FigureArrivalDate)
                'Date Range------------
            Else
                intFirstDays = CInt(Left(subVarDays, InStr(1, subVarDays, "-") - 1))
                intSecondDays = CInt(Trim(Right(subVarDays, Len(subVarDays) - InStr(1, subVarDays, "-"))))

                'Ship Date
                varFirstArrivalDate = subVarShipDate
                Do
                    If Weekday(Z_SHIPX_FigureArrivalDate) = 1 Then
                        varFirstArrivalDate = varFirstArrivalDate.AddDays(1)
                    Else
                        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
                            SqlConnection.ClearPool(conn)
                            conn.Open()
                            Dim CMD_D As New SqlCommand("spGetWebSHIPX_ShippingHolidaysOutboundRow", conn)
                            CMD_D.CommandType = Data.CommandType.StoredProcedure
                            CMD_D.Parameters.AddWithValue("@Date", varFirstArrivalDate)
                            Dim readerD As SqlDataReader
                            readerD = CMD_D.ExecuteReader
                            readerD.Read()
                            If IsDBSomething(readerD(subVarHolidayColumnName), "") = "y" Or IsDBSomething(readerD("WorkHoliday"), "") = "y" Then
                                varFirstArrivalDate = varFirstArrivalDate.AddDays(1)
                            Else
                                Exit Do
                            End If
                        End Using
                    End If
                Loop
                varSecondArrivalDate = varFirstArrivalDate
                'First Transit Days
                For subN = 1 To intFirstDays
                    varFirstArrivalDate = varFirstArrivalDate.AddDays(1)
                    Do
                        If Weekday(varFirstArrivalDate) = 1 Then
                            varFirstArrivalDate = varFirstArrivalDate.AddDays(1)
                        Else
                            Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
                                SqlConnection.ClearPool(conn)
                                conn.Open()
                                Dim CMD_D As New SqlCommand("spGetWebSHIPX_ShippingHolidaysOutboundRow", conn)
                                CMD_D.CommandType = Data.CommandType.StoredProcedure
                                CMD_D.Parameters.AddWithValue("@Date", varFirstArrivalDate)
                                Dim readerD As SqlDataReader
                                readerD = CMD_D.ExecuteReader
                                readerD.Read()
                                If IsDBSomething(readerD(subVarHolidayColumnName), "") = "y" Then
                                    varFirstArrivalDate = varFirstArrivalDate.AddDays(1)
                                Else
                                    Exit Do
                                End If
                            End Using
                        End If
                    Loop
                Next
                'Second Transit Days
                For subN = 1 To intSecondDays
                    varSecondArrivalDate = varSecondArrivalDate.AddDays(1)
                    Do
                        If Weekday(varSecondArrivalDate) = 1 Then
                            varSecondArrivalDate = varSecondArrivalDate.AddDays(1)
                        Else
                            Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
                                SqlConnection.ClearPool(conn)
                                conn.Open()
                                Dim CMD_D As New SqlCommand("spGetWebSHIPX_ShippingHolidaysOutboundRow", conn)
                                CMD_D.CommandType = Data.CommandType.StoredProcedure
                                CMD_D.Parameters.AddWithValue("@Date", varSecondArrivalDate)
                                Dim readerD As SqlDataReader
                                readerD = CMD_D.ExecuteReader
                                readerD.Read()
                                If IsDBSomething(readerD(subVarHolidayColumnName), "") = "y" Then
                                    varSecondArrivalDate = varSecondArrivalDate.AddDays(1)
                                Else
                                    Exit Do
                                End If
                            End Using
                        End If
                    Loop
                Next
                Return "Arrives " & Format(varFirstArrivalDate, "MMMM") & " " & Day(varFirstArrivalDate) & " - " & Format(varSecondArrivalDate, "MMMM") & " " & Day(varSecondArrivalDate)
            End If
        End If

    End Function
    Public Function Z_CheckForPOBox(subVarStreetAddress1 As String, subVarStreetAddress2 As String) As String
        Z_CheckForPOBox = "N"
        If Len(subVarStreetAddress1) > 0 Then
            If InStr(1, UCase(subVarStreetAddress1), "BOX ") > 0 Then
                Z_CheckForPOBox = "Y"
            End If
            If InStr(1, UCase(subVarStreetAddress1), "POB ") > 0 Then
                Z_CheckForPOBox = "Y"
            End If
        End If
        If Len(subVarStreetAddress2) > 0 Then
            If InStr(1, UCase(subVarStreetAddress2), "BOX ") > 0 Then
                Z_CheckForPOBox = "Y"
            End If
            If InStr(1, UCase(subVarStreetAddress2), "POB ") > 0 Then
                Z_CheckForPOBox = "Y"
            End If
        End If

    End Function

    Public Function SEOPageNameText(txt As String, fmt As String, ID As Integer, varUsedForSEO As String) As String
        Dim varAndSign As Integer = 0
        Dim varPlusSign As Integer = 0
        Dim varASC As Integer = 0
        Dim var2Dashes As Integer = 0
        txt = Trim(txt)
        SEOPageNameText = ""
        Do
            varAndSign = InStr(1, txt, " & ")
            If varAndSign > 0 Then
                txt = Trim(Left(txt, varAndSign - 1)) & " And " & Trim(Right(txt, Len(txt) - varAndSign - 2))
            Else
                Exit Do
            End If
        Loop
        Do
            varPlusSign = InStr(1, txt, " + ")
            If varPlusSign > 0 Then
                txt = Trim(Left(txt, varPlusSign - 1)) & " Plus " & Trim(Right(txt, Len(txt) - varPlusSign - 2))
            Else
                Exit Do
            End If
        Loop
        For nSEO = 1 To Len(txt)
            varASC = Asc(Mid(txt, nSEO, 1))
            If (varASC >= 65 And varASC <= 90) Or (varASC >= 97 And varASC <= 122) Or (varASC >= 48 And varASC <= 57) Or varASC = 32 Then
                If varASC = 32 Then
                    SEOPageNameText = SEOPageNameText & "-"
                Else
                    SEOPageNameText = SEOPageNameText & Mid(txt, nSEO, 1)
                End If
            End If
        Next
        Do
            var2Dashes = InStr(1, SEOPageNameText, "--")
            If var2Dashes > 0 Then
                SEOPageNameText = Trim(Left(SEOPageNameText, var2Dashes - 1)) & "-" & Trim(Right(SEOPageNameText, Len(SEOPageNameText) - var2Dashes - 1))
            Else
                Exit Do
            End If
        Loop
        SEOPageNameText = ID & "/" & SEOPageNameText
        If fmt = "CD" Then
            SEOPageNameText = "CD/" & SEOPageNameText
        ElseIf fmt = "LP" Then
            SEOPageNameText = "Vinyl/" & SEOPageNameText
        ElseIf fmt = "CS" Then
            SEOPageNameText = "Tapes/" & SEOPageNameText
        ElseIf Microsoft.VisualBasic.Strings.Left(fmt, 1) = "V" Then
            SEOPageNameText = "VHS/" & SEOPageNameText
        ElseIf Microsoft.VisualBasic.Strings.Left(fmt, 1) = "7" Then
            SEOPageNameText = "Vinyl/" & SEOPageNameText
        ElseIf Microsoft.VisualBasic.Strings.Left(fmt, 2) = "12" Then
            SEOPageNameText = "Vinyl/" & SEOPageNameText
        ElseIf Microsoft.VisualBasic.Strings.Left(fmt, 2) = "10" Then
            SEOPageNameText = "Vinyl/" & SEOPageNameText
        ElseIf fmt = "CDS" Then
            SEOPageNameText = "CD/" & SEOPageNameText
        ElseIf fmt = "DVD" Then
            SEOPageNameText = "DVD/" & SEOPageNameText
        ElseIf fmt = "B" Then
            SEOPageNameText = "Books/" & SEOPageNameText
        Else
            SEOPageNameText = "Miscellaneous/" & SEOPageNameText
        End If
        SEOPageNameText = "/ItemDetails/" & SEOPageNameText
    End Function
    Public Function XYZSEOPageNameText(txt As String, fmt As String, ID As Integer, varUsedForSEO As String) As String
        Dim varAndSign As Integer = 0
        Dim varPlusSign As Integer = 0
        Dim varASC As Integer = 0
        Dim var2Dashes As Integer = 0
        txt = Trim(txt)
        XYZSEOPageNameText = ""
        Do
            varAndSign = InStr(1, txt, " & ")
            If varAndSign > 0 Then
                txt = Trim(Left(txt, varAndSign - 1)) & " And " & Trim(Right(txt, Len(txt) - varAndSign - 2))
            Else
                Exit Do
            End If
        Loop
        Do
            varPlusSign = InStr(1, txt, " + ")
            If varPlusSign > 0 Then
                txt = Trim(Left(txt, varPlusSign - 1)) & " Plus " & Trim(Right(txt, Len(txt) - varPlusSign - 2))
            Else
                Exit Do
            End If
        Loop
        For nSEO = 1 To Len(txt)
            varASC = Asc(Mid(txt, nSEO, 1))
            If (varASC >= 65 And varASC <= 90) Or (varASC >= 97 And varASC <= 122) Or (varASC >= 48 And varASC <= 57) Or varASC = 32 Then
                If varASC = 32 Then
                    XYZSEOPageNameText = XYZSEOPageNameText & "-"
                Else
                    XYZSEOPageNameText = XYZSEOPageNameText & Mid(txt, nSEO, 1)
                End If
            End If
        Next
        Do
            var2Dashes = InStr(1, XYZSEOPageNameText, "--")
            If var2Dashes > 0 Then
                XYZSEOPageNameText = Trim(Left(XYZSEOPageNameText, var2Dashes - 1)) & "-" & Trim(Right(XYZSEOPageNameText, Len(XYZSEOPageNameText) - var2Dashes - 1))
            Else
                Exit Do
            End If
        Loop
        XYZSEOPageNameText = ID & "/" & XYZSEOPageNameText
        If fmt = "CD" Then
            XYZSEOPageNameText = "CD/" & XYZSEOPageNameText
        ElseIf fmt = "LP" Then
            XYZSEOPageNameText = "Vinyl/" & XYZSEOPageNameText
        ElseIf fmt = "CS" Then
            XYZSEOPageNameText = "Tapes/" & XYZSEOPageNameText
        ElseIf Microsoft.VisualBasic.Strings.Left(fmt, 1) = "V" Then
            XYZSEOPageNameText = "VHS/" & XYZSEOPageNameText
        ElseIf Microsoft.VisualBasic.Strings.Left(fmt, 1) = "7" Then
            XYZSEOPageNameText = "Vinyl/" & XYZSEOPageNameText
        ElseIf Microsoft.VisualBasic.Strings.Left(fmt, 2) = "12" Then
            XYZSEOPageNameText = "Vinyl/" & XYZSEOPageNameText
        ElseIf Microsoft.VisualBasic.Strings.Left(fmt, 2) = "10" Then
            XYZSEOPageNameText = "Vinyl/" & XYZSEOPageNameText
        ElseIf fmt = "CDS" Then
            XYZSEOPageNameText = "CD/" & XYZSEOPageNameText
        ElseIf fmt = "DVD" Then
            XYZSEOPageNameText = "DVD/" & XYZSEOPageNameText
        ElseIf fmt = "B" Then
            XYZSEOPageNameText = "Books/" & XYZSEOPageNameText
        Else
            XYZSEOPageNameText = "Miscellaneous/" & XYZSEOPageNameText
        End If
        XYZSEOPageNameText = "/XYZ-ItemDetails/" & XYZSEOPageNameText
    End Function
    Public Function GeneratePassword(strConnectionStringName As String) As String
        Dim varXrandom As Double = 0
        Dim varFirstCharacter As String = ""
        Dim varSecondCharacter As String = ""
        Dim varThirdCharacter As String = ""
        Dim varFourthCharacter As String = ""
        Dim varFifthCharacter As String = ""
        Dim varSixthCharacter As String = ""
        Dim varSeventhCharacter As String = ""
        Dim varEighthCharacter As String = ""

        Do
            GeneratePassword = ""
            For nrand = 1 To Date.Now.Second + 1
                Randomize()
                varXrandom = Rnd(2000)
            Next
            Do
                varFirstCharacter = Int((25) * Rnd() + 65)
                If Chr(varFirstCharacter) <> "I" And Chr(varFirstCharacter) <> "O" And Chr(varFirstCharacter) <> "Z" And Chr(varFirstCharacter) <> "J" And Chr(varFirstCharacter) <> "L" And Chr(varFirstCharacter) <> "Q" Then
                    Exit Do
                End If
            Loop
            Do
                varSecondCharacter = Int((25) * Rnd() + 65)
                If Chr(varSecondCharacter) <> "I" And Chr(varSecondCharacter) <> "O" And Chr(varSecondCharacter) <> "Z" And Chr(varSecondCharacter) <> "J" And Chr(varSecondCharacter) <> "L" And Chr(varSecondCharacter) <> "Q" Then
                    Exit Do
                End If
            Loop
            Do
                varThirdCharacter = Int((7) * Rnd() + 2)
                If varThirdCharacter <> 5 Then
                    Exit Do
                End If
            Loop
            Do
                varFourthCharacter = Int((7) * Rnd() + 2)
                If varFourthCharacter <> 5 Then
                    Exit Do
                End If
            Loop
            Do
                varFifthCharacter = Int((7) * Rnd() + 2)
                If varFifthCharacter <> 5 Then
                    Exit Do
                End If
            Loop
            Do
                varSixthCharacter = Int((7) * Rnd() + 2)
                If varSixthCharacter <> 5 Then
                    Exit Do
                End If
            Loop
            Do
                varSeventhCharacter = Int((25) * Rnd() + 65)
                If Chr(varSeventhCharacter) <> "I" And Chr(varSeventhCharacter) <> "O" And Chr(varSeventhCharacter) <> "Z" And Chr(varSeventhCharacter) <> "J" And Chr(varSeventhCharacter) <> "L" And Chr(varSeventhCharacter) <> "Q" Then
                    Exit Do
                End If
            Loop
            Do
                varEighthCharacter = Int((25) * Rnd() + 65)
                If Chr(varEighthCharacter) <> "I" And Chr(varEighthCharacter) <> "O" And Chr(varEighthCharacter) <> "Z" And Chr(varEighthCharacter) <> "J" And Chr(varEighthCharacter) <> "L" And Chr(varEighthCharacter) <> "Q" Then
                    Exit Do
                End If
            Loop
            GeneratePassword = Chr(varFirstCharacter) & Chr(varSecondCharacter) & varThirdCharacter & varFourthCharacter & varFifthCharacter & varSixthCharacter & Chr(varSeventhCharacter) & Chr(varEighthCharacter)
            Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
                SqlConnection.ClearPool(conn)
                conn.Open()
                Dim CMD_X As New SqlCommand("spCheckIfPasswordExists", conn)
                CMD_X.CommandType = Data.CommandType.StoredProcedure
                CMD_X.Parameters.AddWithValue("@Password", GeneratePassword)
                Dim readerX As SqlDataReader
                readerX = CMD_X.ExecuteReader
                If Not readerX.HasRows Then
                    Exit Do
                End If
            End Using
        Loop
    End Function
    Public Sub Z_EmailWholesalePassword(subVarCounter As Integer, strConnectionStringName As String)
        Dim strCountry As String = ""
        Dim strEmail As String = ""
        Dim strLogInEmail As String = ""
        Dim strPriceGroup As String = ""
        Dim strFullName As String = ""
        Dim strPassword As String = ""
        Dim varID As Integer = 0
        Dim varSubject As String = ""
        Dim varBody1 As String = ""
        Dim varBody2 As String = ""
        Dim varBody3 As String = ""
        Dim varBody4 As String = ""
        Dim varBody5 As String = ""
        Dim varBody6 As String = ""
        Dim varFooter As String = ""
        Dim strbody As String = ""

        'Customer Info
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
            SqlConnection.ClearPool(conn)
            conn.Open()
            Dim CMD_X As New SqlCommand("spGetCustomerDetailsByServerCounter", conn)
            CMD_X.CommandType = Data.CommandType.StoredProcedure
            CMD_X.Parameters.AddWithValue("@counter", subVarCounter)
            Dim readerX As SqlDataReader
            readerX = CMD_X.ExecuteReader
            readerX.Read()
            strCountry = readerX("Country")
            strEmail = readerX("Email")
            strLogInEmail = readerX("LogInEmail")
            strPriceGroup = readerX("PriceGroup")
            strFullName = readerX("FullName")
            strPassword = readerX("Password")
        End Using
        'Get Email data from table
        If strCountry = "USA" Then
            varID = 9
        ElseIf strCountry = "Canada" And strPriceGroup = "StorePrice" Then
            varID = 10
        ElseIf strCountry = "Canada" And strPriceGroup = "ExportPrice" Then
            varID = 11
        Else
            varID = 12
        End If
        strbody = "Dear " & strFullName & ","
        strbody = strbody & vbCrLf & vbCrLf & "Your wholesale account is open. You may begin ordering. No paperwork is necessary."
        strbody = strbody & vbCrLf & vbCrLf & "Here are the instructions for ordering on the website."
        strbody = strbody & vbCrLf & vbCrLf & "SIGN-IN TO THE WEBSITE"
        strbody = strbody & vbCrLf & "Your sign-in credentials are:"
        strbody = strbody & vbCrLf & "Email:  " & strLogInEmail
        strbody = strbody & vbCrLf & "Password:  " & strPassword
        strbody = strbody & vbCrLf & vbCrLf & "(Your email and password aren't case sensitive)"
        strbody = strbody & vbCrLf & vbCrLf & "HOW TO ORDER"
        strbody = strbody & vbCrLf & "You must sign in before adding items to your cart. Otherwise, your cart might not be saved. "
        strbody = strbody & vbCrLf & "After signing-in, add items to the cart as usual. Click the Cart tab to view the cart and to check out. The website displays inventory in real time, so everything you see is in stock."
        strbody = strbody & vbCrLf & vbCrLf & "PAYMENT/SHIPPING"
        strbody = strbody & vbCrLf & "The checkout page lists the payment options (Credit Card, PayPal, Net Terms, etc.)  Shipping is based on the weight of the items and your location. You can view your shipping options by clicking the Cart tab."
        strbody = strbody & vbCrLf & vbCrLf & "SALES TAX"
        strbody = strbody & vbCrLf & "If you are outside of California, you won't be charged sales tax. You will be charged sales tax if you are in California and you don't have a resale number."
        strbody = strbody & vbCrLf & vbCrLf & "RETURNS, DEFECTS, DAMAGE"
        strbody = strbody & vbCrLf & "Everything we sell is 100% guaranteed. Returns are allowed on all products that are defective or damaged. In most cases we will refund you without asking you to return the goods."
        strbody = strbody & vbCrLf & vbCrLf & "ORDERING BY EMAIL"
        strbody = strbody & vbCrLf & "You also have the option of emailing your order. You might find our Excel inventory lists helpful. You can download these using the links from our new release emails. You can download our entire inventory, or partial lists such as 'all CDs', 'Ace Records LPs', 'all Reggae LPs', etc. "
        strbody = strbody & vbCrLf & "Download the Excel file(s) and then email them to us with your order quantities."
        strbody = strbody & vbCrLf & vbCrLf & "QUESTIONS"
        strbody = strbody & vbCrLf & "If you have any questions, please contact Ernie by email or phone. "
        strbody = strbody & vbCrLf & "Ernieb12345@gmail.com"
        strbody = strbody & vbCrLf & "(916) 586-9410 (7 days)"
        strbody = strbody & vbCrLf & vbCrLf & "We look forward to serving you."
        strbody = strbody & vbCrLf & vbCrLf & "Sincerely,"
        strbody = strbody & vbCrLf & vbCrLf & "Ernie Boetius"
        strbody = strbody & vbCrLf & "Owner, Millions of Records"
        strbody = strbody & vbCrLf & "Founder, Ernie B's Reggae Distribution"
        strbody = strbody & Z_EmailFooter(strConnectionStringName)
        'E-mail It
        subSendEmail("ernie@millionsofrecords.com", strEmail, varSubject, strbody, 1, 0, strConnectionStringName)
    End Sub
    Public Function FigureGiftCardNumberNoSpaces(x As String) As String
        Dim intChar As Integer = 0
        FigureGiftCardNumberNoSpaces = ""
        If x = "" Then
            Exit Function
        End If
        FigureGiftCardNumberNoSpaces = ""
        For n = 1 To Len(x)
            intChar = Asc(Mid(x, n, 1))
            If intChar >= 48 And intChar <= 57 Then
                FigureGiftCardNumberNoSpaces = FigureGiftCardNumberNoSpaces & Chr(intChar)
            End If
        Next
    End Function
    Public Function CheckForBadPhone(varPhoneText As String) As Integer
        CheckForBadPhone = 0
        Dim varSameNumberRepeated As Integer = 0
        Dim varLastCharacter As String = ""
        Dim x100 As Integer = 0
        Dim x200 As Integer = 0
        x100 = 0
        x200 = 1
        If Len(varPhoneText) < 7 Then
            CheckForBadPhone = 1
        End If
        For n = 1 To Len(varPhoneText)
            If Mid(varPhoneText, n, 1) = varLastCharacter Then
                x200 = x200 + 1
                If x200 >= 6 Then
                    varSameNumberRepeated = 1
                Else
                    varSameNumberRepeated = 0
                End If
            Else
                x200 = 1
            End If
            If Asc(Mid(varPhoneText, n, 1)) >= 48 And Asc(Mid(varPhoneText, n, 1)) <= 57 Then
                x100 = x100 + 1
            End If
            varLastCharacter = Mid(varPhoneText, n, 1)
        Next
        If x100 <= 6 Then CheckForBadPhone = 1
        If varSameNumberRepeated = 1 Then CheckForBadPhone = 1
        If InStr(1, varPhoneText, "@") > 0 Then
            CheckForBadPhone = 1
        End If

    End Function


    Public Function FigureArtistTitleWebHTML(varUsedItem As String, varFormat As String, varArtistTitle As String) As String
        Dim varUsedItemText As String = ""
        Dim n As Integer = 0
        Dim varTrack(15)
        Dim varArtists(15)
        Dim strArtistTitleHTML As String = ""
        Dim varDash As Integer = 0
        Dim varArtistString As String = ""
        Dim varRestOfArtistTitle As String = ""
        Dim varComma As Integer = 0
        Dim varReplaceText As String = ""

        'Used Items text ---------------------------------------------------------------------------------------------------
        If InStr(1, varArtistTitle, "USED ITEM:") > 0 Or UCase(varUsedItem) = "Y" Then
            varUsedItemText = "<span style='color:#ff0000;cursor:default'title='This item is not factory new. Please click on the item to view condition details. Satisfaction 100% guaranteed.'>USED ITEM:</span>" & " "
            If InStr(1, varArtistTitle, "USED ITEM:") > 0 Then
                varArtistTitle = Trim(Right(varArtistTitle, Len(varArtistTitle) - 10))
            End If
        Else
            varUsedItemText = ""
        End If

        'Artist Hyperlinks -------------------------------------------------------------------------------------------------
        strArtistTitleHTML = ""
        varTrack(n) = varArtistTitle
        varDash = InStr(1, varTrack(n), " - ")
        If varDash > 0 Then
            varArtistString = Trim(Left(varTrack(n), varDash - 1))
            varRestOfArtistTitle = Right(varTrack(n), Len(varTrack(n)) - varDash + 1)
            Do
                varComma = InStr(1, varArtistString, ",")
                If varComma > 0 Then
                    n = n + 1
                    varArtists(n) = Trim(Left(varArtistString, varComma - 1))
                    varArtistString = Trim(Right(varArtistString, Len(varArtistString) - varComma))
                Else
                    n = n + 1
                    varArtists(n) = Trim(varArtistString)
                    If n = 1 Then
                        If varArtists(n) = "Various" Then
                            strArtistTitleHTML = strArtistTitleHTML & "Various" & varRestOfArtistTitle
                        Else
                            strArtistTitleHTML = "<span class=""z""title=""Show all by this artist""onclick=""AA('" & Replace(varArtists(n), "'", "|") & "')"">" & varArtists(n) & "</span>" & varRestOfArtistTitle
                        End If
                    Else
                        For x = 1 To n
                            If x < n Then
                                If varArtists(x + 1) = "The" Then
                                    strArtistTitleHTML = strArtistTitleHTML & "<span class=""z""title=""Show all by this artist""onclick=""AA('" & varArtists(x) & ", The" & "')"">" & varArtists(x) & ", The" & "</span>" & ", "
                                    x = x + 1
                                Else
                                    strArtistTitleHTML = strArtistTitleHTML & "<span class=""z""title=""Show all by this artist""onclick=""AA('" & varArtists(x) & "')"">" & varArtists(x) & "</span>" & ", "
                                End If
                            Else
                                If varArtists(x) = "Etc." Then
                                    strArtistTitleHTML = strArtistTitleHTML & "Etc."
                                ElseIf varArtists(x) = "Various" Then
                                    strArtistTitleHTML = strArtistTitleHTML & "Various"
                                Else
                                    strArtistTitleHTML = strArtistTitleHTML & "<span class=""z""title=""Show all by this artist""onclick=""AA('" & varArtists(x) & "')"">" & varArtists(x) & "</span>"
                                End If
                            End If
                        Next
                        If Right(strArtistTitleHTML, 2) = ", " Then
                            strArtistTitleHTML = Left(strArtistTitleHTML, Len(strArtistTitleHTML) - 2) & " "
                        End If
                        strArtistTitleHTML = strArtistTitleHTML & varRestOfArtistTitle
                    End If
                    Exit Do
                End If
            Loop
        Else
            strArtistTitleHTML = varArtistTitle
        End If

        FigureArtistTitleWebHTML = strArtistTitleHTML
        FigureArtistTitleWebHTML = varUsedItemText & FigureArtistTitleWebHTML
    End Function
    Public Function FigureWebReviewText(strText As String) As String
        If strText = "" Then
            FigureWebReviewText = ""
            Exit Function
        End If

        Dim varGif As Integer = 0
        Dim varGif2 As Integer = 0

        varGif = InStr(1, strText, "yr1.gif")
        varGif2 = InStr(1, strText, "yrd.gif")
        If varGif > 0 Then
            FigureWebReviewText = Trim(Right(strText, Len(strText) - varGif - 12))
        Else
            If varGif2 > 0 Then
                FigureWebReviewText = Trim(Right(strText, Len(strText) - varGif2 - 12))
            Else
                FigureWebReviewText = strText
            End If
        End If
    End Function


    Public Sub EmailOWEB(strOrderNumber As String, strConnectionStringName As String, strPayPalPaymentStatus As String)
        Dim varShippingMethodForOrder As String = ""
        Dim varShippingMethodText As String = ""
        Dim varPaymentMethodForReceipt As String = ""
        Dim varEmailBody As String = ""
        Dim strSpaces As String = "                       "
        Dim strFormat As String = ""
        Dim strQuantity As String = ""
        Dim strPrice As String = ""
        Dim strInventory As String = ""
        Dim strOWEBText As String = "OWEB"
        If UCase(strPayPalPaymentStatus) = "PENDING" Then
            strOWEBText = "PendingOWEB"
        End If

        'Orders Row
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
            SqlConnection.ClearPool(conn)
            conn.Open()
            Dim CMD_X As New SqlCommand("spGetOrdersRow", conn)
            CMD_X.CommandType = Data.CommandType.StoredProcedure
            CMD_X.Parameters.AddWithValue("@OrderNumber", strOrderNumber)
            Dim xx As SqlDataReader
            xx = CMD_X.ExecuteReader
            If Not xx.HasRows Then
                Exit Sub
            Else
                xx.Read()
            End If
            'Shipping Method and Payment Method
            Using conn2 As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
                SqlConnection.ClearPool(conn2)
                conn2.Open()
                Dim CMD_X2 As New SqlCommand("spGetWebSHIPX_ShippingMethodsRow", conn2)
                CMD_X2.CommandType = Data.CommandType.StoredProcedure
                CMD_X2.Parameters.AddWithValue("@ShippingMethodCode", xx("ShippingMethod"))
                Dim xx2 As SqlDataReader
                xx2 = CMD_X2.ExecuteReader
                xx2.Read()
                varShippingMethodForOrder = xx2("ShippingViaCompany") & " (" & xx2("ShipViaService") & ")"
                If xx2("ShippingViaCompany") = "Federal Express" Then
                    If xx2("ShipViaService") = "Ground" Then
                        varShippingMethodText = "FedexGround"
                    Else
                        varShippingMethodText = "FedexAir"
                    End If
                ElseIf xx2("ShippingViaCompany") = "US Mail" Then
                    varShippingMethodText = "USPS"
                ElseIf xx2("ShippingViaCompany") = "UPS" And xx2("ShipViaService") = "Ground" Then
                    varShippingMethodText = "UPSGround"
                End If
            End Using
            'Terms Of Sale Text
            If IsNumeric(xx("orderprocesschoice")) Then
                Using conn2 As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
                    SqlConnection.ClearPool(conn2)
                    conn2.Open()
                    Dim CMD_X2 As New SqlCommand("spGetTermsOfSaleTypesRow", conn2)
                    CMD_X2.CommandType = Data.CommandType.StoredProcedure
                    CMD_X2.Parameters.AddWithValue("@Type", xx("orderprocesschoice"))
                    Dim xx2 As SqlDataReader
                    xx2 = CMD_X2.ExecuteReader
                    xx2.Read()
                    varPaymentMethodForReceipt = xx2("TextOnInvoice")
                End Using
            Else
                varPaymentMethodForReceipt = ""
            End If
            Using conn2 As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
                SqlConnection.ClearPool(conn2)
                conn2.Open()
                Dim CMD_X2 As New SqlCommand("spGetOrderItems", conn2)
                CMD_X2.CommandType = Data.CommandType.StoredProcedure
                CMD_X2.Parameters.AddWithValue("@OrderNumber", strOrderNumber)
                Dim xxItems As SqlDataReader
                xxItems = CMD_X2.ExecuteReader
                If Not xxItems.HasRows Then
                    Exit Sub
                End If
                'Email Body Main
                varEmailBody = strOrderNumber & " | " & xx("TotalQuantity") & " | " & xx("FullName")
                varEmailBody = varEmailBody & Chr(10) & Chr(10) & xx("DateTime")
                varEmailBody = varEmailBody & Chr(10) & xx("FullName")
                varEmailBody = varEmailBody & Chr(10) & IsDBSomething(xx("IPAddress"), "")
                varEmailBody = varEmailBody & Chr(10) & xx("PriceGroup")
                varEmailBody = varEmailBody & Chr(10) & xx("Email")
                varEmailBody = varEmailBody & Chr(10) & xx("Phone") & Chr(10)
                If Len(IsDBSomething(xx("OrderNotes"), "")) > 0 Then
                    varEmailBody = varEmailBody & Chr(10)
                    varEmailBody = varEmailBody & Chr(10) & "Order Notes:  " & xx("OrderNotes")
                    varEmailBody = varEmailBody & Chr(10) & Chr(10)
                End If
                varEmailBody = varEmailBody & Chr(10) & varPaymentMethodForReceipt
                varEmailBody = varEmailBody & Chr(10) & Chr(10) & xx("ShippingMethod")
                varEmailBody = varEmailBody & Chr(10) & xx("ShippingMethodPullSheetText")
                varEmailBody = varEmailBody & Chr(10) & xx("StreetAddress1")
                varEmailBody = varEmailBody & Chr(10) & xx("StreetAddress2")
                varEmailBody = varEmailBody & Chr(10) & xx("City")
                varEmailBody = varEmailBody & Chr(10) & xx("StateProvince")
                varEmailBody = varEmailBody & Chr(10) & xx("PostalCode")
                varEmailBody = varEmailBody & Chr(10) & xx("Island")
                varEmailBody = varEmailBody & Chr(10) & xx("Country") & Chr(10)
                If Len(IsDBSomething(xx("CreditCardNumber"), "")) > 0 Or Len(IsDBSomething(xx("ExpDate"), "")) > 0 Then
                    varEmailBody = varEmailBody & Chr(10) & "CreditCard#:  " & Right(xx("CreditCardNumber"), 4)
                    varEmailBody = varEmailBody & Chr(10) & "ExpDate:  " & xx("ExpDate") & Chr(10)
                End If
                varEmailBody = varEmailBody & Chr(10) & "CostOfGoods:  " & FormatNumber(CDbl(xx("TotalPrice")), 2)
                varEmailBody = varEmailBody & Chr(10) & "Shipping:  " & FormatNumber(CDbl(xx("Shipping")), 2)
                varEmailBody = varEmailBody & Chr(10) & "Tax:  " & FormatNumber(CDbl(xx("Tax")), 2)
                varEmailBody = varEmailBody & Chr(10) & "OrderTotal:  " & FormatNumber(CDbl(xx("OrderTotal")), 2)
                varEmailBody = varEmailBody & Chr(10) & Chr(10)
                'Email Body Items
                Do While xxItems.Read
                    strFormat = xxItems("Format")
                    If strFormat = "7""" Then
                        strFormat = Left(strSpaces, 4) & strFormat
                    ElseIf strFormat = "LP" Then
                        strFormat = Left(strSpaces, 4) & strFormat
                    ElseIf strFormat = "CD" Then
                        strFormat = Left(strSpaces, 3) & strFormat
                    ElseIf strFormat = "B" Then
                        strFormat = Left(strSpaces, 5) & strFormat
                    ElseIf strFormat = "DVD" Then
                        strFormat = Left(strSpaces, 3) & strFormat
                    ElseIf strFormat = "VHS" Then
                        strFormat = Left(strSpaces, 3) & strFormat
                    ElseIf strFormat = "10""" Then
                        strFormat = Left(strSpaces, 3) & strFormat
                    ElseIf strFormat = "12""" Then
                        strFormat = Left(strSpaces, 3) & strFormat
                    Else
                        strFormat = Left(strSpaces, 3) & strFormat
                    End If
                    strQuantity = xxItems("Quantity").ToString
                    strQuantity = Left(strSpaces, (6 - Len(strQuantity)) * 2) & strQuantity
                    strPrice = Math.Round(xxItems("Price"), 2).ToString
                    strPrice = Left(strSpaces, (8 - Len(strPrice)) * 2) & strPrice
                    strInventory = xxItems("Inventory").ToString
                    strInventory = Left(strSpaces, (6 - Len(strInventory)) * 2) & strInventory
                    varEmailBody = varEmailBody & vbCrLf & strFormat & "  " & strPrice & "  " & strQuantity & "  " & strInventory & "   " & Trim(xxItems("Description"))
                Loop
                subSendEmail("ernie@millionsofrecords.com", "ernieb12345@gmail.com", strOWEBText & " | $" & xx("OrderTotal") & " | " & xx("TotalQuantity") & " | " & varShippingMethodText & " | " & xx("FullName"), varEmailBody, 1, 0, strConnectionStringName)
            End Using
        End Using
    End Sub


    Public Function FigureMusiciansText(strText As String) As String
        If strText = "" Then
            FigureMusiciansText = ""
            Exit Function
        End If

        Dim varGif As Integer = 0

        varGif = InStr(1, strText, "ym1.gif")
        If varGif > 0 Then
            FigureMusiciansText = Trim(Right(strText, Len(strText) - varGif - 12))
        Else
            FigureMusiciansText = strText
        End If
    End Function
    Public Function FigureProduceText(strText As String) As String
        If strText = "" Then
            FigureProduceText = ""
            Exit Function
        End If

        Dim varGif As Integer = 0

        varGif = InStr(1, strText, "yp1.gif")
        If varGif > 0 Then
            FigureProduceText = Trim(Right(strText, Len(strText) - varGif - 12))
        Else
            FigureProduceText = strText
        End If
    End Function
    Public Function ThumbnailView_FigureConditionText(varConditionJacket As String, varConditionVinylOrCD As String, varConditionNotes As String, varFormat As String) As String
        ThumbnailView_FigureConditionText = ""
        If varFormat = "CD" Then
            ThumbnailView_FigureConditionText = "All used CDs play perfectly and have brand-new jewel cases. Backed by our 100% money-back guarantee."
        ElseIf varFormat = "DVD" Then
            ThumbnailView_FigureConditionText = "All used DVDs play perfectly and are backed by our 100% money-back guarantee."
        ElseIf varFormat = "VHS" Then
            ThumbnailView_FigureConditionText = "All used VHS (videotapes) play perfectly and are backed by our 100% money-back guarantee."
        ElseIf varFormat = "CS" Then
            ThumbnailView_FigureConditionText = "All used cassette tapes play perfectly and are backed by our 100% money-back guarantee."
        Else
            If varConditionJacket <> "" Then
                ThumbnailView_FigureConditionText = "Jacket Condition = " & varConditionJacket
            End If
            If varConditionVinylOrCD <> "" Then
                If varFormat = "LP" Or varFormat = "12""" Or varFormat = "10""" Or varFormat = "7""" Then
                    If ThumbnailView_FigureConditionText = "" Then
                        ThumbnailView_FigureConditionText = "Vinyl Condition &nbsp;&nbsp;= " & varConditionVinylOrCD
                    Else
                        ThumbnailView_FigureConditionText = ThumbnailView_FigureConditionText & "<BR>Vinyl Condition &nbsp;&nbsp;= " & varConditionVinylOrCD
                    End If
                End If
            End If
            If varConditionNotes <> "" Then
                If ThumbnailView_FigureConditionText = "" Then
                    ThumbnailView_FigureConditionText = varConditionNotes
                Else
                    ThumbnailView_FigureConditionText = ThumbnailView_FigureConditionText & "<BR>" & varConditionNotes
                End If
            End If
        End If
    End Function


    Public Function ItemDetails_FigureConditionText(varConditionJacket As String, varConditionVinylOrCD As String, varConditionNotes As String, varFormat As String) As String
        ItemDetails_FigureConditionText = ""
        If varFormat = "CD" Then
            ItemDetails_FigureConditionText = "All used CDs play perfectly and have brand-new jewel cases. Backed by our 100% money-back guarantee."
        ElseIf varFormat = "DVD" Then
            ItemDetails_FigureConditionText = "All used DVDs play perfectly and are backed by our 100% money-back guarantee."
        ElseIf varFormat = "VHS" Then
            ItemDetails_FigureConditionText = "All used VHS (videotapes) play perfectly and are backed by our 100% money-back guarantee."
        ElseIf varFormat = "CS" Then
            ItemDetails_FigureConditionText = "All used cassette tapes play perfectly and are backed by our 100% money-back guarantee."
        Else
            If varConditionJacket <> "" Then
                ItemDetails_FigureConditionText = "Jacket Condition = " & varConditionJacket
            End If
            If varConditionVinylOrCD <> "" Then
                If varFormat = "LP" Or varFormat = "12""" Or varFormat = "10""" Or varFormat = "7""" Then
                    If ItemDetails_FigureConditionText = "" Then
                        ItemDetails_FigureConditionText = "Vinyl Condition &nbsp;&nbsp;= " & varConditionVinylOrCD
                    Else
                        ItemDetails_FigureConditionText = ItemDetails_FigureConditionText & "<BR>Vinyl Condition &nbsp;&nbsp;= " & varConditionVinylOrCD
                    End If
                End If
            End If
            If varConditionNotes <> "" Then
                If ItemDetails_FigureConditionText = "" Then
                    ItemDetails_FigureConditionText = varConditionNotes
                Else
                    ItemDetails_FigureConditionText = ItemDetails_FigureConditionText & "<BR>" & varConditionNotes
                End If
            End If
        End If
    End Function
    Public Function FigureArtistTitleWebHTMLForListView(varUsedItem As String, varFormat As String, varArtistTitle As String) As String
        Dim varUsedItemText As String = ""
        Dim n As Integer = 0
        Dim varTrack(15)
        Dim varArtists(15)
        Dim strArtistTitleHTML As String = ""
        Dim varDash As Integer = 0
        Dim varArtistString As String = ""
        Dim varRestOfArtistTitle As String = ""
        Dim varComma As Integer = 0
        Dim varReplaceText As String = ""
        Dim strArtistHTML As String = ""

        'Used Items text ---------------------------------------------------------------------------------------------------
        If InStr(1, varArtistTitle, "USED ITEM:") > 0 Or UCase(varUsedItem) = "Y" Then
            varUsedItemText = "<span style='color:#ff0000;cursor:default'title='This item is not factory new. Please click on the item to view condition details. Satisfaction 100% guaranteed.'>USED ITEM:</span>" & " "
            If InStr(1, varArtistTitle, "USED ITEM:") > 0 Then
                varArtistTitle = Trim(Right(varArtistTitle, Len(varArtistTitle) - 10))
            End If
        Else
            varUsedItemText = ""
        End If

        'Artist Hyperlinks -------------------------------------------------------------------------------------------------
        n = 0
        strArtistHTML = ""
        varTrack(n) = varArtistTitle
        varDash = InStr(1, varTrack(n), " - ")
        If varDash > 0 Then
            varArtistString = Trim(Left(varTrack(n), varDash - 1))
            varRestOfArtistTitle = Right(varTrack(n), Len(varTrack(n)) - varDash + 1)
            Do
                varComma = InStr(1, varArtistString, ",")
                If varComma > 0 Then
                    n = n + 1
                    varArtists(n) = Trim(Left(varArtistString, varComma - 1))
                    varArtistString = Trim(Right(varArtistString, Len(varArtistString) - varComma))
                Else
                    n = n + 1
                    varArtists(n) = Trim(varArtistString)
                    If n = 1 Then
                        If varArtists(n) = "Various" Then
                            strArtistHTML = strArtistHTML & "Various" & varRestOfArtistTitle
                        Else
                            strArtistHTML = "<span class=""list-z""title=""Show all by this artist""onclick=""AA('" & Replace(varArtists(n), "'", "|") & "')"">" & varArtists(n) & "</span>" & varRestOfArtistTitle
                        End If
                    Else
                        For x = 1 To n
                            If x < n Then
                                If varArtists(x + 1) = "The" Then
                                    strArtistHTML = strArtistHTML & "<span class=""list-z""title=""Show all by this artist""onclick=""AA('" & varArtists(x) & ", The" & "')"">" & varArtists(x) & ", The" & "</span>" & ", "
                                    x = x + 1
                                Else
                                    strArtistHTML = strArtistHTML & "<span class=""list-z""title=""Show all by this artist""onclick=""AA('" & varArtists(x) & "')"">" & varArtists(x) & "</span>" & ", "
                                End If
                            Else
                                If varArtists(x) = "Etc." Then
                                    strArtistHTML = strArtistHTML & "Etc."
                                ElseIf varArtists(x) = "Various" Then
                                    strArtistHTML = strArtistHTML & "Various"
                                Else
                                    strArtistHTML = strArtistHTML & "<span class=""list-z""title=""Show all by this artist""onclick=""AA('" & varArtists(x) & "')"">" & varArtists(x) & "</span>"
                                End If
                            End If
                        Next
                        If Right(strArtistHTML, 2) = ", " Then
                            strArtistHTML = Left(strArtistHTML, Len(strArtistHTML) - 2) & " "
                        End If
                        strArtistHTML = strArtistHTML & varRestOfArtistTitle
                    End If
                    Exit Do
                End If
            Loop
        Else
            strArtistHTML = varArtistTitle
        End If
        FigureArtistTitleWebHTMLForListView = varUsedItemText & strArtistHTML
    End Function
    Public Function FigureArtistTitleWebHTMLForGridView(varUsedItem As String, varFormat As String, varArtistTitle As String) As String
        Dim n As Integer = 0
        Dim varTrack(15)
        Dim varArtists(15)
        Dim strArtistTitleHTML As String = ""
        Dim varDash As Integer = 0
        Dim varArtistString As String = ""
        Dim varComma As Integer = 0
        Dim varReplaceText As String = ""
        Dim varCurrentShowingTextLength As Integer = 0
        Dim varShowingTextLength As Integer = 0
        Dim varArtistLinkTextToShow As String = ""

        'Used Items text ---------------------------------------------------------------------------------------------------
        If InStr(1, varArtistTitle, "USED ITEM:") > 0 Then
            varArtistTitle = Trim(Right(varArtistTitle, Len(varArtistTitle) - 10))
        End If

        'Artist Hyperlinks -------------------------------------------------------------------------------------------------
        strArtistTitleHTML = ""
        varTrack(n) = varArtistTitle
        varDash = InStr(1, varTrack(n), " - ")
        If varDash > 0 Then
            varArtistString = Trim(Left(varTrack(n), varDash - 1))
            Do
                varComma = InStr(1, varArtistString, ",")
                If varComma > 0 Then
                    n = n + 1
                    varArtists(n) = Trim(Left(varArtistString, varComma - 1))
                    varArtistString = Trim(Right(varArtistString, Len(varArtistString) - varComma))
                Else
                    n = n + 1
                    varArtists(n) = Trim(varArtistString)
                    If n = 1 Then
                        If varArtists(n) = "Various" Then
                            strArtistTitleHTML = strArtistTitleHTML & "Various"
                        Else
                            If Len(varArtists(n)) > 42 Then
                                varArtistLinkTextToShow = Left(varArtists(n), 42) & "..."
                            Else
                                varArtistLinkTextToShow = varArtists(n)
                            End If
                            strArtistTitleHTML = "<span class=""grid-z""title=""Show all by this artist""onclick=""AA('" & Replace(varArtists(n), "'", "|") & "')"">" & varArtistLinkTextToShow & "</span>"
                        End If
                    Else
                        For x = 1 To n
                            varCurrentShowingTextLength = varShowingTextLength
                            If x = 1 Then
                                varShowingTextLength = varShowingTextLength + Len(varArtists(x))
                            Else
                                varShowingTextLength = varShowingTextLength + Len(varArtists(x)) + 2
                            End If
                            If varShowingTextLength > 42 Then
                                If x = 2 Then
                                    strArtistTitleHTML = strArtistTitleHTML & " Etc."
                                End If
                                Exit For
                            End If
                            If x < n Then
                                strArtistTitleHTML = strArtistTitleHTML & "<span class=""grid-z""title=""Show all by this artist""onclick=""AA('" & varArtists(x) & "')"">" & varArtists(x) & "</span>" & ", "
                            Else
                                If varArtists(x) <> "Etc." And varArtists(x) <> "Various" Then
                                    strArtistTitleHTML = strArtistTitleHTML & "<span class=""grid-z""title=""Show all by this artist""onclick=""AA('" & varArtists(x) & "')"">" & varArtists(x) & "</span>"
                                End If
                            End If
                        Next
                        If Right(strArtistTitleHTML, 2) = ", " Then
                            strArtistTitleHTML = Left(strArtistTitleHTML, Len(strArtistTitleHTML) - 2) & " "
                        End If
                    End If
                    Exit Do
                End If
            Loop
        Else
            strArtistTitleHTML = varArtistTitle
        End If

        FigureArtistTitleWebHTMLForGridView = strArtistTitleHTML
    End Function

    Public Function FigureArtistWebHTMLForGridViewOLD(varArtist As String) As String
        'Artist Hyperlink -------------------------------------------------------------------------------------------------
        Dim strArtistHTML As String = ""
        Dim varComma As Integer = 0
        Dim varDots As Integer = 0
        If Right(varArtist, 5) <> ", The" Then
            varComma = InStr(1, varArtist, ",")
            If varComma > 0 Then
                varArtist = Trim(Left(varArtist, varComma - 1))
            End If
        End If
        varDots = InStr(1, varArtist, "...")
        strArtistHTML = varArtist
        If varDots = 0 And varArtist <> "Various" Then
            strArtistHTML = "<span class=""grid-z""title=""Show all by this artist""onclick=""AA('" & Replace(varArtist, "'", "|") & "')"">" & varArtist & "</span>"
        End If
        FigureArtistWebHTMLForGridViewOLD = strArtistHTML
    End Function

    Public Function Z_CheckValidEmail(subVarEmail As String) As String
        Z_CheckValidEmail = "no"
        If subVarEmail <> "" Then
            If Len(subVarEmail) > 3 Then
                If UCase(Left(subVarEmail, 3)) = "WWW" Or InStr(1, subVarEmail, " ") > 0 Or InStr(1, subVarEmail, ",") > 0 Or InStr(1, subVarEmail, ";") > 0 Then
                    Exit Function
                Else
                    If InStr(1, subVarEmail, "@") > 0 And InStr(1, subVarEmail, ".") > 0 Then
                        If Asc(UCase(Right(subVarEmail, 1))) >= 65 And Asc(UCase(Right(subVarEmail, 1))) <= 90 Then
                            Z_CheckValidEmail = "yes"
                        End If
                    End If
                End If
            End If
        End If
    End Function


    Public Function Z_SHIPX_FigureGlobalExpressZone(subVarCountry As String, strConnectionStringName As String) As String
        Z_SHIPX_FigureGlobalExpressZone = "NA"
        Exit Function
        If subVarCountry = "USA" Then
            Z_SHIPX_FigureGlobalExpressZone = "NA"
        Else
            Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
                SqlConnection.ClearPool(conn)
                conn.Open()
                Dim CMD_X As New SqlCommand("spGetGlobalExpressZone", conn)
                CMD_X.CommandType = Data.CommandType.StoredProcedure
                CMD_X.Parameters.AddWithValue("@Country", subVarCountry)
                Dim readerX As SqlDataReader
                readerX = CMD_X.ExecuteReader
                If readerX.HasRows Then
                    readerX.Read()
                    Z_SHIPX_FigureGlobalExpressZone = readerX("GlobalExpressZone")
                End If
            End Using
        End If
    End Function
    Public Function Z_SHIPX_FigurePriorityMailZone(subVarCountry As String, subVarZip As String) As String

        If Len(subVarZip) < 3 Then
            Z_SHIPX_FigurePriorityMailZone = "NA"
            Exit Function
        End If
        If Not IsNumeric(subVarZip) Then
            Z_SHIPX_FigurePriorityMailZone = "NA"
            Exit Function
        End If
        If subVarCountry = "USA" Then
            subVarZip = Left(subVarZip, 3)
            If subVarZip >= 5 And subVarZip <= 98 Then
                Z_SHIPX_FigurePriorityMailZone = 8
            ElseIf subVarZip >= 100 And subVarZip <= 212 Then
                Z_SHIPX_FigurePriorityMailZone = 8
            ElseIf subVarZip >= 214 And subVarZip <= 268 Then
                Z_SHIPX_FigurePriorityMailZone = 8
            ElseIf subVarZip >= 270 And subVarZip <= 342 Then
                Z_SHIPX_FigurePriorityMailZone = 8
            ElseIf subVarZip = 344 Then
                Z_SHIPX_FigurePriorityMailZone = 8
            ElseIf subVarZip >= 346 And subVarZip <= 347 Then
                Z_SHIPX_FigurePriorityMailZone = 8
            ElseIf subVarZip >= 349 And subVarZip <= 352 Then
                Z_SHIPX_FigurePriorityMailZone = 8
            ElseIf subVarZip >= 354 And subVarZip <= 374 Then
                Z_SHIPX_FigurePriorityMailZone = 8
            ElseIf subVarZip = 375 Then
                Z_SHIPX_FigurePriorityMailZone = 7
            ElseIf subVarZip >= 376 And subVarZip <= 379 Then
                Z_SHIPX_FigurePriorityMailZone = 8
            ElseIf subVarZip >= 380 And subVarZip <= 383 Then
                Z_SHIPX_FigurePriorityMailZone = 7
            ElseIf subVarZip >= 384 And subVarZip <= 385 Then
                Z_SHIPX_FigurePriorityMailZone = 8
            ElseIf subVarZip >= 386 And subVarZip <= 387 Then
                Z_SHIPX_FigurePriorityMailZone = 7
            ElseIf subVarZip = 388 Then
                Z_SHIPX_FigurePriorityMailZone = 8
            ElseIf subVarZip >= 389 And subVarZip <= 392 Then
                Z_SHIPX_FigurePriorityMailZone = 7
            ElseIf subVarZip >= 393 And subVarZip <= 395 Then
                Z_SHIPX_FigurePriorityMailZone = 8
            ElseIf subVarZip = 396 Then
                Z_SHIPX_FigurePriorityMailZone = 7
            ElseIf subVarZip >= 397 And subVarZip <= 418 Then
                Z_SHIPX_FigurePriorityMailZone = 8
            ElseIf subVarZip = 420 Then
                Z_SHIPX_FigurePriorityMailZone = 7
            ElseIf subVarZip >= 421 And subVarZip <= 423 Then
                Z_SHIPX_FigurePriorityMailZone = 8
            ElseIf subVarZip = 424 Then
                Z_SHIPX_FigurePriorityMailZone = 7
            ElseIf subVarZip >= 425 And subVarZip <= 427 Then
                Z_SHIPX_FigurePriorityMailZone = 8
            ElseIf subVarZip >= 430 And subVarZip <= 462 Then
                Z_SHIPX_FigurePriorityMailZone = 8
            ElseIf subVarZip >= 463 And subVarZip <= 464 Then
                Z_SHIPX_FigurePriorityMailZone = 7
            ElseIf subVarZip >= 465 And subVarZip <= 475 Then
                Z_SHIPX_FigurePriorityMailZone = 8
            ElseIf subVarZip >= 476 And subVarZip <= 477 Then
                Z_SHIPX_FigurePriorityMailZone = 7
            ElseIf subVarZip >= 478 And subVarZip <= 497 Then
                Z_SHIPX_FigurePriorityMailZone = 8
            ElseIf subVarZip >= 498 And subVarZip <= 509 Then
                Z_SHIPX_FigurePriorityMailZone = 7
            ElseIf subVarZip >= 510 And subVarZip <= 516 Then
                Z_SHIPX_FigurePriorityMailZone = 6
            ElseIf subVarZip >= 520 And subVarZip <= 528 Then
                Z_SHIPX_FigurePriorityMailZone = 7
            ElseIf subVarZip >= 530 And subVarZip <= 532 Then
                Z_SHIPX_FigurePriorityMailZone = 7
            ElseIf subVarZip >= 534 And subVarZip <= 535 Then
                Z_SHIPX_FigurePriorityMailZone = 7
            ElseIf subVarZip >= 537 And subVarZip <= 561 Then
                Z_SHIPX_FigurePriorityMailZone = 7
            ElseIf subVarZip = 562 Then
                Z_SHIPX_FigurePriorityMailZone = 6
            ElseIf subVarZip >= 563 And subVarZip <= 564 Then
                Z_SHIPX_FigurePriorityMailZone = 7
            ElseIf subVarZip = 565 Then
                Z_SHIPX_FigurePriorityMailZone = 6
            ElseIf subVarZip = 566 Then
                Z_SHIPX_FigurePriorityMailZone = 7
            ElseIf subVarZip = 567 Then
                Z_SHIPX_FigurePriorityMailZone = 6
            ElseIf subVarZip >= 570 And subVarZip <= 576 Then
                Z_SHIPX_FigurePriorityMailZone = 6
            ElseIf subVarZip = 577 Then
                Z_SHIPX_FigurePriorityMailZone = 5
            ElseIf subVarZip >= 580 And subVarZip <= 588 Then
                Z_SHIPX_FigurePriorityMailZone = 6
            ElseIf subVarZip >= 590 And subVarZip <= 599 Then
                Z_SHIPX_FigurePriorityMailZone = 5
            ElseIf subVarZip >= 600 And subVarZip <= 620 Then
                Z_SHIPX_FigurePriorityMailZone = 7
            ElseIf subVarZip >= 622 And subVarZip <= 642 Then
                Z_SHIPX_FigurePriorityMailZone = 7
            ElseIf subVarZip >= 644 And subVarZip <= 658 Then
                Z_SHIPX_FigurePriorityMailZone = 7
            ElseIf subVarZip >= 660 And subVarZip <= 663 Then
                Z_SHIPX_FigurePriorityMailZone = 7
            ElseIf subVarZip >= 664 And subVarZip <= 666 Then
                Z_SHIPX_FigurePriorityMailZone = 6
            ElseIf subVarZip = 667 Then
                Z_SHIPX_FigurePriorityMailZone = 7
            ElseIf subVarZip >= 668 And subVarZip <= 681 Then
                Z_SHIPX_FigurePriorityMailZone = 6
            ElseIf subVarZip >= 683 And subVarZip <= 692 Then
                Z_SHIPX_FigurePriorityMailZone = 6
            ElseIf subVarZip = 693 Then
                Z_SHIPX_FigurePriorityMailZone = 5
            ElseIf subVarZip >= 700 And subVarZip <= 701 Then
                Z_SHIPX_FigurePriorityMailZone = 8
            ElseIf subVarZip >= 703 And subVarZip <= 704 Then
                Z_SHIPX_FigurePriorityMailZone = 8
            ElseIf subVarZip >= 705 And subVarZip <= 708 Then
                Z_SHIPX_FigurePriorityMailZone = 7
            ElseIf subVarZip >= 710 And subVarZip <= 714 Then
                Z_SHIPX_FigurePriorityMailZone = 7
            ElseIf subVarZip >= 716 And subVarZip <= 729 Then
                Z_SHIPX_FigurePriorityMailZone = 7
            ElseIf subVarZip >= 730 And subVarZip <= 731 Then
                Z_SHIPX_FigurePriorityMailZone = 6
            ElseIf subVarZip = 733 Then
                Z_SHIPX_FigurePriorityMailZone = 7
            ElseIf subVarZip >= 734 And subVarZip <= 741 Then
                Z_SHIPX_FigurePriorityMailZone = 6
            ElseIf subVarZip >= 743 And subVarZip <= 743 Then
                Z_SHIPX_FigurePriorityMailZone = 6
            ElseIf subVarZip >= 744 And subVarZip <= 745 Then
                Z_SHIPX_FigurePriorityMailZone = 7
            ElseIf subVarZip = 746 Then
                Z_SHIPX_FigurePriorityMailZone = 6
            ElseIf subVarZip = 747 Then
                Z_SHIPX_FigurePriorityMailZone = 7
            ElseIf subVarZip = 748 Then
                Z_SHIPX_FigurePriorityMailZone = 6
            ElseIf subVarZip >= 749 And subVarZip <= 759 Then
                Z_SHIPX_FigurePriorityMailZone = 7
            ElseIf subVarZip >= 760 And subVarZip <= 764 Then
                Z_SHIPX_FigurePriorityMailZone = 6
            ElseIf subVarZip >= 765 And subVarZip <= 767 Then
                Z_SHIPX_FigurePriorityMailZone = 7
            ElseIf subVarZip >= 768 And subVarZip <= 769 Then
                Z_SHIPX_FigurePriorityMailZone = 6
            ElseIf subVarZip >= 770 And subVarZip <= 789 Then
                Z_SHIPX_FigurePriorityMailZone = 7
            ElseIf subVarZip >= 790 And subVarZip <= 797 Then
                Z_SHIPX_FigurePriorityMailZone = 6
            ElseIf subVarZip >= 798 And subVarZip <= 816 Then
                Z_SHIPX_FigurePriorityMailZone = 5
            ElseIf subVarZip >= 820 And subVarZip <= 831 Then
                Z_SHIPX_FigurePriorityMailZone = 5
            ElseIf subVarZip >= 831 And subVarZip <= 837 Then
                Z_SHIPX_FigurePriorityMailZone = 4
            ElseIf subVarZip = 838 Then
                Z_SHIPX_FigurePriorityMailZone = 5
            ElseIf subVarZip >= 840 And subVarZip <= 847 Then
                Z_SHIPX_FigurePriorityMailZone = 4
            ElseIf subVarZip >= 850 And subVarZip <= 853 Then
                Z_SHIPX_FigurePriorityMailZone = 5
            ElseIf subVarZip >= 855 And subVarZip <= 857 Then
                Z_SHIPX_FigurePriorityMailZone = 5
            ElseIf subVarZip = 859 Then
                Z_SHIPX_FigurePriorityMailZone = 5
            ElseIf subVarZip = 860 Then
                Z_SHIPX_FigurePriorityMailZone = 4
            ElseIf subVarZip >= 863 And subVarZip <= 864 Then
                Z_SHIPX_FigurePriorityMailZone = 4
            ElseIf subVarZip = 865 Then
                Z_SHIPX_FigurePriorityMailZone = 5
            ElseIf subVarZip >= 870 And subVarZip <= 875 Then
                Z_SHIPX_FigurePriorityMailZone = 5
            ElseIf subVarZip >= 877 And subVarZip <= 880 Then
                Z_SHIPX_FigurePriorityMailZone = 5
            ElseIf subVarZip = 881 Then
                Z_SHIPX_FigurePriorityMailZone = 6
            ElseIf subVarZip >= 882 And subVarZip <= 885 Then
                Z_SHIPX_FigurePriorityMailZone = 5
            ElseIf subVarZip >= 889 And subVarZip <= 891 Then
                Z_SHIPX_FigurePriorityMailZone = 4
            ElseIf subVarZip = 893 Then
                Z_SHIPX_FigurePriorityMailZone = 4
            ElseIf subVarZip >= 894 And subVarZip <= 895 Then
                Z_SHIPX_FigurePriorityMailZone = 2
            ElseIf subVarZip = 897 Then
                Z_SHIPX_FigurePriorityMailZone = 2
            ElseIf subVarZip = 898 Then
                Z_SHIPX_FigurePriorityMailZone = 4
            ElseIf subVarZip >= 900 And subVarZip <= 908 Then
                Z_SHIPX_FigurePriorityMailZone = 4
            ElseIf subVarZip >= 910 And subVarZip <= 928 Then
                Z_SHIPX_FigurePriorityMailZone = 4
            ElseIf subVarZip >= 930 And subVarZip <= 931 Then
                Z_SHIPX_FigurePriorityMailZone = 4
            ElseIf subVarZip >= 932 And subVarZip <= 933 Then
                Z_SHIPX_FigurePriorityMailZone = 3
            ElseIf subVarZip = 934 Then
                Z_SHIPX_FigurePriorityMailZone = 4
            ElseIf subVarZip = 935 Then
                Z_SHIPX_FigurePriorityMailZone = 3
            ElseIf subVarZip >= 936 And subVarZip <= 941 Then
                Z_SHIPX_FigurePriorityMailZone = 2
            ElseIf subVarZip = 942 Then
                Z_SHIPX_FigurePriorityMailZone = 1
            ElseIf subVarZip >= 943 And subVarZip <= 954 Then
                Z_SHIPX_FigurePriorityMailZone = 2
            ElseIf subVarZip = 955 Then
                Z_SHIPX_FigurePriorityMailZone = 3
            ElseIf subVarZip >= 956 And subVarZip <= 959 Then
                Z_SHIPX_FigurePriorityMailZone = 1
            ElseIf subVarZip >= 960 And subVarZip <= 966 Then
                Z_SHIPX_FigurePriorityMailZone = 2
            ElseIf subVarZip >= 967 And subVarZip <= 969 Then
                Z_SHIPX_FigurePriorityMailZone = 8
            ElseIf subVarZip >= 970 And subVarZip <= 974 Then
                Z_SHIPX_FigurePriorityMailZone = 4
            ElseIf subVarZip >= 975 And subVarZip <= 976 Then
                Z_SHIPX_FigurePriorityMailZone = 3
            ElseIf subVarZip >= 977 And subVarZip <= 979 Then
                Z_SHIPX_FigurePriorityMailZone = 4
            ElseIf subVarZip >= 980 And subVarZip <= 982 Then
                Z_SHIPX_FigurePriorityMailZone = 5
            ElseIf subVarZip >= 983 And subVarZip <= 986 Then
                Z_SHIPX_FigurePriorityMailZone = 4
            ElseIf subVarZip >= 988 And subVarZip <= 989 Then
                Z_SHIPX_FigurePriorityMailZone = 4
            ElseIf subVarZip >= 990 And subVarZip <= 992 Then
                Z_SHIPX_FigurePriorityMailZone = 5
            ElseIf subVarZip >= 993 And subVarZip <= 994 Then
                Z_SHIPX_FigurePriorityMailZone = 4
            ElseIf subVarZip >= 995 And subVarZip <= 997 Then
                Z_SHIPX_FigurePriorityMailZone = 8
            ElseIf subVarZip = 998 Then
                Z_SHIPX_FigurePriorityMailZone = 7
            ElseIf subVarZip = 999 Then
                Z_SHIPX_FigurePriorityMailZone = 6
            Else
                Z_SHIPX_FigurePriorityMailZone = "NA"
            End If
        Else
            Z_SHIPX_FigurePriorityMailZone = "NA"
        End If

    End Function

    Public Function Z_SHIPX_FigureFedExInternationalEconomyZone(subVarCountry As String, subVarZip As String, strConnectionStringName As String) As String
        If subVarCountry = "USA" Then
            Z_SHIPX_FigureFedExInternationalEconomyZone = "NA"
        Else
            Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
                SqlConnection.ClearPool(conn)
                conn.Open()
                Dim CMD_X As New SqlCommand("spGetAirParcelPostZone", conn)
                CMD_X.CommandType = Data.CommandType.StoredProcedure
                CMD_X.Parameters.AddWithValue("@Country", subVarCountry)
                Dim readerX As SqlDataReader
                readerX = CMD_X.ExecuteReader
                If readerX.HasRows Then
                    readerX.Read()
                    Z_SHIPX_FigureFedExInternationalEconomyZone = readerX("FedExInternationalEconomyZone")
                End If
            End Using
            Dim subVarZipString As String = ""
            If subVarCountry = "Canada" Then
                subVarZipString = Left(subVarZip, 3)
                If subVarZipString <= "G9Z" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "B"
                ElseIf subVarZipString <= "H9Z" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "A"
                ElseIf subVarZipString <= "J2W" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "B"
                ElseIf subVarZipString <= "J3G" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "A"
                ElseIf subVarZipString <= "J3K" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "B"
                ElseIf subVarZipString <= "J3N" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "A"
                ElseIf subVarZipString <= "J3T" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "B"
                ElseIf subVarZipString <= "J4Z" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "A"
                ElseIf subVarZipString <= "J6H" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "B"
                ElseIf subVarZipString <= "J6R" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "A"
                ElseIf subVarZipString <= "J6V" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "B"
                ElseIf subVarZipString <= "J7R" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "A"
                ElseIf subVarZipString <= "J8N" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "B"
                ElseIf subVarZipString <= "J9C" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "A"
                ElseIf subVarZipString <= "J9Z" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "B"
                ElseIf subVarZipString <= "K0Z" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "B"
                ElseIf subVarZipString <= "K2R" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "A"
                ElseIf subVarZipString <= "L0H" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "B"
                ElseIf subVarZipString <= "L0J" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "A"
                ElseIf subVarZipString <= "L0N" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "B"
                ElseIf subVarZipString <= "L0P" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "A"
                ElseIf subVarZipString <= "L1E" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "B"
                ElseIf subVarZipString <= "L1Z" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "A"
                ElseIf subVarZipString <= "L2C" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "B"
                ElseIf subVarZipString <= "L2W" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "A"
                ElseIf subVarZipString <= "L3N" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "B"
                ElseIf subVarZipString <= "L3T" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "A"
                ElseIf subVarZipString <= "L3W" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "B"
                ElseIf subVarZipString <= "L9T" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "A"
                ElseIf subVarZipString <= "L9Z" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "B"
                ElseIf subVarZipString <= "M9Z" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "A"
                ElseIf subVarZipString <= "N1Z" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "B"
                ElseIf subVarZipString <= "N2V" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "A"
                ElseIf subVarZipString <= "N5T" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "B"
                ElseIf subVarZipString <= "N6N" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "A"
                ElseIf subVarZipString <= "N8M" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "B"
                ElseIf subVarZipString <= "N9K" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "A"
                ElseIf subVarZipString <= "P9Z" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "B"
                ElseIf subVarZipString <= "R2B" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "B"
                ElseIf subVarZipString <= "R4A" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "A"
                ElseIf subVarZipString <= "R9Z" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "B"
                ElseIf subVarZipString <= "S9Z" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "B"
                ElseIf subVarZipString <= "T1X" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "B"
                ElseIf subVarZipString <= "T3L" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "A"
                ElseIf subVarZipString <= "T9Z" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "B"
                ElseIf subVarZipString <= "V1L" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "B"
                ElseIf subVarZipString <= "V1M" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "A"
                ElseIf subVarZipString <= "V2V" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "B"
                ElseIf subVarZipString <= "V3E" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "A"
                ElseIf subVarZipString <= "V3G" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "B"
                ElseIf subVarZipString <= "V4S" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "A"
                ElseIf subVarZipString <= "V4T" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "B"
                ElseIf subVarZipString <= "V7Z" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "A"
                ElseIf subVarZipString <= "V9Z" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "B"
                ElseIf subVarZipString <= "X9Z" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "B"
                ElseIf subVarZipString <= "Y9Z" Then
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "B"
                Else
                    Z_SHIPX_FigureFedExInternationalEconomyZone = "B"
                End If
            End If
        End If
    End Function

    Public Function Z_SHIPX_FigureUPSGroundZone(subVarCountry As String, subVarZipCode As String, subVarState As String) As String
        Z_SHIPX_FigureUPSGroundZone = "NA"
        Exit Function
        If Len(subVarZipCode) < 5 Then
            Z_SHIPX_FigureUPSGroundZone = "NA"
            Exit Function
        End If
        If Not IsNumeric(subVarZipCode) Then
            Z_SHIPX_FigureUPSGroundZone = "NA"
            Exit Function
        End If
        If subVarState = "AA (Military)" Or subVarState = "AE (Military)" Or subVarState = "AP (Military)" Or subVarState = "American Samoa" Or subVarState = "Guam" Or subVarState = "Marshall Islands" Or subVarState = "Micronesia" Or subVarState = "Northern Mariana Islands" Or subVarState = "Palau" Or subVarState = "Puerto Rico" Or subVarState = "Virgin Islands (U.S.)" Then
            Z_SHIPX_FigureUPSGroundZone = "NA"
            Exit Function
        End If
        Dim subVarZip As String = ""
        If subVarCountry = "USA" Then
            If Not IsNumeric(subVarZipCode) Then
                Z_SHIPX_FigureUPSGroundZone = "NA"
                Exit Function
            End If
            subVarZip = Left(subVarZipCode, 3)
            subVarZipCode = Left(subVarZipCode, 5)
            If subVarZip <= 3 Then
                Z_SHIPX_FigureUPSGroundZone = "NA"
            ElseIf subVarZip <= 5 Then
                Z_SHIPX_FigureUPSGroundZone = 8
            ElseIf subVarZip <= 9 Then
                Z_SHIPX_FigureUPSGroundZone = "NA"
            ElseIf subVarZip <= 374 Then
                Z_SHIPX_FigureUPSGroundZone = 8
            ElseIf subVarZip <= 375 Then
                Z_SHIPX_FigureUPSGroundZone = 7
            ElseIf subVarZip <= 379 Then
                Z_SHIPX_FigureUPSGroundZone = 8
            ElseIf subVarZip <= 383 Then
                Z_SHIPX_FigureUPSGroundZone = 7
            ElseIf subVarZip <= 385 Then
                Z_SHIPX_FigureUPSGroundZone = 8
            ElseIf subVarZip <= 387 Then
                Z_SHIPX_FigureUPSGroundZone = 7
            ElseIf subVarZip <= 388 Then
                Z_SHIPX_FigureUPSGroundZone = 8
            ElseIf subVarZip <= 392 Then
                Z_SHIPX_FigureUPSGroundZone = 7
            ElseIf subVarZip <= 395 Then
                Z_SHIPX_FigureUPSGroundZone = 8
            ElseIf subVarZip <= 396 Then
                Z_SHIPX_FigureUPSGroundZone = 7
            ElseIf subVarZip <= 418 Then
                Z_SHIPX_FigureUPSGroundZone = 8
            ElseIf subVarZip <= 419 Then
                Z_SHIPX_FigureUPSGroundZone = "NA"
            ElseIf subVarZip <= 420 Then
                Z_SHIPX_FigureUPSGroundZone = 7
            ElseIf subVarZip <= 423 Then
                Z_SHIPX_FigureUPSGroundZone = 8
            ElseIf subVarZip <= 424 Then
                Z_SHIPX_FigureUPSGroundZone = 7
            ElseIf subVarZip <= 462 Then
                Z_SHIPX_FigureUPSGroundZone = 8
            ElseIf subVarZip <= 464 Then
                Z_SHIPX_FigureUPSGroundZone = 7
            ElseIf subVarZip <= 475 Then
                Z_SHIPX_FigureUPSGroundZone = 8
            ElseIf subVarZip <= 477 Then
                Z_SHIPX_FigureUPSGroundZone = 7
            ElseIf subVarZip <= 497 Then
                Z_SHIPX_FigureUPSGroundZone = 8
            ElseIf subVarZip <= 509 Then
                Z_SHIPX_FigureUPSGroundZone = 7
            ElseIf subVarZip <= 516 Then
                Z_SHIPX_FigureUPSGroundZone = 6
            ElseIf subVarZip <= 519 Then
                Z_SHIPX_FigureUPSGroundZone = "NA"
            ElseIf subVarZip <= 560 Then
                Z_SHIPX_FigureUPSGroundZone = 7
            ElseIf subVarZip <= 562 Then
                Z_SHIPX_FigureUPSGroundZone = 6
            ElseIf subVarZip <= 564 Then
                Z_SHIPX_FigureUPSGroundZone = 7
            ElseIf subVarZip <= 565 Then
                Z_SHIPX_FigureUPSGroundZone = 6
            ElseIf subVarZip <= 566 Then
                Z_SHIPX_FigureUPSGroundZone = 7
            ElseIf subVarZip <= 576 Then
                Z_SHIPX_FigureUPSGroundZone = 6
            ElseIf subVarZip <= 577 Then
                Z_SHIPX_FigureUPSGroundZone = 5
            ElseIf subVarZip <= 579 Then
                Z_SHIPX_FigureUPSGroundZone = "NA"
            ElseIf subVarZip <= 588 Then
                Z_SHIPX_FigureUPSGroundZone = 6
            ElseIf subVarZip <= 589 Then
                Z_SHIPX_FigureUPSGroundZone = "NA"
            ElseIf subVarZip <= 599 Then
                Z_SHIPX_FigureUPSGroundZone = 5
            ElseIf subVarZip <= 663 Then
                Z_SHIPX_FigureUPSGroundZone = 7
            ElseIf subVarZip <= 666 Then
                Z_SHIPX_FigureUPSGroundZone = 6
            ElseIf subVarZip <= 667 Then
                Z_SHIPX_FigureUPSGroundZone = 7
            ElseIf subVarZip <= 692 Then
                Z_SHIPX_FigureUPSGroundZone = 6
            ElseIf subVarZip <= 693 Then
                Z_SHIPX_FigureUPSGroundZone = 5
            ElseIf subVarZip <= 699 Then
                Z_SHIPX_FigureUPSGroundZone = "NA"
            ElseIf subVarZip <= 704 Then
                Z_SHIPX_FigureUPSGroundZone = 8
            ElseIf subVarZip <= 729 Then
                Z_SHIPX_FigureUPSGroundZone = 7
            ElseIf subVarZip <= 732 Then
                Z_SHIPX_FigureUPSGroundZone = 6
            ElseIf subVarZip <= 733 Then
                Z_SHIPX_FigureUPSGroundZone = 7
            ElseIf subVarZip <= 742 Then
                Z_SHIPX_FigureUPSGroundZone = 6
            ElseIf subVarZip <= 745 Then
                Z_SHIPX_FigureUPSGroundZone = 7
            ElseIf subVarZip <= 746 Then
                Z_SHIPX_FigureUPSGroundZone = 6
            ElseIf subVarZip <= 747 Then
                Z_SHIPX_FigureUPSGroundZone = 7
            ElseIf subVarZip <= 748 Then
                Z_SHIPX_FigureUPSGroundZone = 6
            ElseIf subVarZip <= 759 Then
                Z_SHIPX_FigureUPSGroundZone = 7
            ElseIf subVarZip <= 764 Then
                Z_SHIPX_FigureUPSGroundZone = 6
            ElseIf subVarZip <= 767 Then
                Z_SHIPX_FigureUPSGroundZone = 7
            ElseIf subVarZip <= 769 Then
                Z_SHIPX_FigureUPSGroundZone = 6
            ElseIf subVarZip <= 787 Then
                Z_SHIPX_FigureUPSGroundZone = 7
            ElseIf subVarZip <= 788 Then
                Z_SHIPX_FigureUPSGroundZone = 6
            ElseIf subVarZip <= 789 Then
                Z_SHIPX_FigureUPSGroundZone = 7
            ElseIf subVarZip <= 797 Then
                Z_SHIPX_FigureUPSGroundZone = 6
            ElseIf subVarZip <= 830 Then
                Z_SHIPX_FigureUPSGroundZone = 5
            ElseIf subVarZip <= 837 Then
                Z_SHIPX_FigureUPSGroundZone = 4
            ElseIf subVarZip <= 838 Then
                Z_SHIPX_FigureUPSGroundZone = 5
            ElseIf subVarZip <= 839 Then
                Z_SHIPX_FigureUPSGroundZone = "NA"
            ElseIf subVarZip <= 847 Then
                Z_SHIPX_FigureUPSGroundZone = 4
            ElseIf subVarZip <= 849 Then
                Z_SHIPX_FigureUPSGroundZone = "NA"
            ElseIf subVarZip <= 852 Then
                Z_SHIPX_FigureUPSGroundZone = 5
            ElseIf subVarZip <= 854 Then
                Z_SHIPX_FigureUPSGroundZone = 4
            ElseIf subVarZip <= 859 Then
                Z_SHIPX_FigureUPSGroundZone = 5
            ElseIf subVarZip <= 864 Then
                Z_SHIPX_FigureUPSGroundZone = 4
            ElseIf subVarZip <= 880 Then
                Z_SHIPX_FigureUPSGroundZone = 5
            ElseIf subVarZip <= 881 Then
                Z_SHIPX_FigureUPSGroundZone = 6
            ElseIf subVarZip <= 885 Then
                Z_SHIPX_FigureUPSGroundZone = 5
            ElseIf subVarZip <= 888 Then
                Z_SHIPX_FigureUPSGroundZone = "NA"
            ElseIf subVarZip <= 893 Then
                Z_SHIPX_FigureUPSGroundZone = 4
            ElseIf subVarZip <= 897 Then
                Z_SHIPX_FigureUPSGroundZone = 2
            ElseIf subVarZip <= 931 Then
                Z_SHIPX_FigureUPSGroundZone = 4
            ElseIf subVarZip <= 935 Then
                Z_SHIPX_FigureUPSGroundZone = 3
            ElseIf subVarZip <= 954 Then
                Z_SHIPX_FigureUPSGroundZone = 2
            ElseIf subVarZip <= 955 Then
                Z_SHIPX_FigureUPSGroundZone = 3
            ElseIf subVarZip <= 961 Then
                Z_SHIPX_FigureUPSGroundZone = 2
            ElseIf subVarZip <= 969 Then
                Z_SHIPX_FigureUPSGroundZone = "NA"
            ElseIf subVarZip <= 974 Then
                Z_SHIPX_FigureUPSGroundZone = 4
            ElseIf subVarZip <= 976 Then
                Z_SHIPX_FigureUPSGroundZone = 3
            ElseIf subVarZip <= 979 Then
                Z_SHIPX_FigureUPSGroundZone = 4
            ElseIf subVarZip <= 982 Then
                Z_SHIPX_FigureUPSGroundZone = 5
            ElseIf subVarZip <= 989 Then
                Z_SHIPX_FigureUPSGroundZone = 4
            ElseIf subVarZip <= 992 Then
                Z_SHIPX_FigureUPSGroundZone = 5
            ElseIf subVarZip <= 994 Then
                Z_SHIPX_FigureUPSGroundZone = 4
            Else
                Z_SHIPX_FigureUPSGroundZone = "NA"
            End If
        Else
            Z_SHIPX_FigureUPSGroundZone = "NA"
        End If

    End Function
    Public Function Z_SHIPX_FigureFedExExpressZone(subVarCountry As String, subVarZipCode As String, subVarState As String) As String
        If Len(subVarZipCode) < 5 Then
            Z_SHIPX_FigureFedExExpressZone = "NA"
            Exit Function
        End If
        If Not IsNumeric(subVarZipCode) Then
            Z_SHIPX_FigureFedExExpressZone = "NA"
            Exit Function
        End If
        If subVarState = "AA (Military)" Or subVarState = "AE (Military)" Or subVarState = "AP (Military)" Or subVarState = "American Samoa" Or subVarState = "Guam" Or subVarState = "Marshall Islands" Or subVarState = "Micronesia" Or subVarState = "Northern Mariana Islands" Or subVarState = "Palau" Or subVarState = "Puerto Rico" Or subVarState = "Virgin Islands (U.S.)" Then
            Z_SHIPX_FigureFedExExpressZone = "NA"
            Exit Function
        End If
        Dim subVarZip As String = ""
        If subVarCountry = "USA" Then
            subVarZip = Left(subVarZipCode, 3)
            subVarZipCode = Left(subVarZipCode, 5)
            If subVarZip <= 4 Then
                Z_SHIPX_FigureFedExExpressZone = "NA"
            ElseIf subVarZip <= 5 Then
                Z_SHIPX_FigureFedExExpressZone = 8
            ElseIf subVarZip <= 9 Then
                Z_SHIPX_FigureFedExExpressZone = "NA"
            ElseIf subVarZip <= 212 Then
                Z_SHIPX_FigureFedExExpressZone = 8
            ElseIf subVarZip = 213 Then
                Z_SHIPX_FigureFedExExpressZone = "NA"
            ElseIf subVarZip <= 268 Then
                Z_SHIPX_FigureFedExExpressZone = 8
            ElseIf subVarZip = 269 Then
                Z_SHIPX_FigureFedExExpressZone = "NA"
            ElseIf subVarZip <= 342 Then
                Z_SHIPX_FigureFedExExpressZone = 8
            ElseIf subVarZip = 343 Then
                Z_SHIPX_FigureFedExExpressZone = "NA"
            ElseIf subVarZip = 344 Then
                Z_SHIPX_FigureFedExExpressZone = 8
            ElseIf subVarZip = 345 Then
                Z_SHIPX_FigureFedExExpressZone = "NA"
            ElseIf subVarZip <= 347 Then
                Z_SHIPX_FigureFedExExpressZone = 8
            ElseIf subVarZip = 348 Then
                Z_SHIPX_FigureFedExExpressZone = "NA"
            ElseIf subVarZip <= 352 Then
                Z_SHIPX_FigureFedExExpressZone = 8
            ElseIf subVarZip = 353 Then
                Z_SHIPX_FigureFedExExpressZone = "NA"
            ElseIf subVarZip <= 374 Then
                Z_SHIPX_FigureFedExExpressZone = 8
            ElseIf subVarZip <= 375 Then
                Z_SHIPX_FigureFedExExpressZone = 7
            ElseIf subVarZip <= 379 Then
                Z_SHIPX_FigureFedExExpressZone = 8
            ElseIf subVarZip <= 383 Then
                Z_SHIPX_FigureFedExExpressZone = 7
            ElseIf subVarZip <= 385 Then
                Z_SHIPX_FigureFedExExpressZone = 8
            ElseIf subVarZip <= 387 Then
                Z_SHIPX_FigureFedExExpressZone = 7
            ElseIf subVarZip <= 388 Then
                Z_SHIPX_FigureFedExExpressZone = 8
            ElseIf subVarZip <= 392 Then
                Z_SHIPX_FigureFedExExpressZone = 7
            ElseIf subVarZip <= 395 Then
                Z_SHIPX_FigureFedExExpressZone = 8
            ElseIf subVarZip <= 396 Then
                Z_SHIPX_FigureFedExExpressZone = 7
            ElseIf subVarZip <= 418 Then
                Z_SHIPX_FigureFedExExpressZone = 8
            ElseIf subVarZip <= 419 Then
                Z_SHIPX_FigureFedExExpressZone = "NA"
            ElseIf subVarZip <= 420 Then
                Z_SHIPX_FigureFedExExpressZone = 7
            ElseIf subVarZip <= 423 Then
                Z_SHIPX_FigureFedExExpressZone = 8
            ElseIf subVarZip <= 424 Then
                Z_SHIPX_FigureFedExExpressZone = 7
            ElseIf subVarZip <= 427 Then
                Z_SHIPX_FigureFedExExpressZone = 8
            ElseIf subVarZip <= 429 Then
                Z_SHIPX_FigureFedExExpressZone = "NA"
            ElseIf subVarZip <= 462 Then
                Z_SHIPX_FigureFedExExpressZone = 8
            ElseIf subVarZip <= 464 Then
                Z_SHIPX_FigureFedExExpressZone = 7
            ElseIf subVarZip <= 475 Then
                Z_SHIPX_FigureFedExExpressZone = 8
            ElseIf subVarZip <= 477 Then
                Z_SHIPX_FigureFedExExpressZone = 7
            ElseIf subVarZip <= 497 Then
                Z_SHIPX_FigureFedExExpressZone = 8
            ElseIf subVarZip <= 509 Then
                Z_SHIPX_FigureFedExExpressZone = 7
            ElseIf subVarZip <= 516 Then
                Z_SHIPX_FigureFedExExpressZone = 6
            ElseIf subVarZip <= 519 Then
                Z_SHIPX_FigureFedExExpressZone = "NA"
            ElseIf subVarZip <= 528 Then
                Z_SHIPX_FigureFedExExpressZone = 7
            ElseIf subVarZip = 529 Then
                Z_SHIPX_FigureFedExExpressZone = "NA"
            ElseIf subVarZip <= 532 Then
                Z_SHIPX_FigureFedExExpressZone = 7
            ElseIf subVarZip = 533 Then
                Z_SHIPX_FigureFedExExpressZone = "NA"
            ElseIf subVarZip <= 535 Then
                Z_SHIPX_FigureFedExExpressZone = 7
            ElseIf subVarZip = 536 Then
                Z_SHIPX_FigureFedExExpressZone = "NA"
            ElseIf subVarZip <= 551 Then
                Z_SHIPX_FigureFedExExpressZone = 7
            ElseIf subVarZip = 552 Then
                Z_SHIPX_FigureFedExExpressZone = "NA"
            ElseIf subVarZip <= 560 Then
                Z_SHIPX_FigureFedExExpressZone = 7
            ElseIf subVarZip <= 562 Then
                Z_SHIPX_FigureFedExExpressZone = 6
            ElseIf subVarZip <= 564 Then
                Z_SHIPX_FigureFedExExpressZone = 7
            ElseIf subVarZip <= 565 Then
                Z_SHIPX_FigureFedExExpressZone = 6
            ElseIf subVarZip <= 566 Then
                Z_SHIPX_FigureFedExExpressZone = 7
            ElseIf subVarZip <= 576 Then
                Z_SHIPX_FigureFedExExpressZone = 6
            ElseIf subVarZip <= 577 Then
                Z_SHIPX_FigureFedExExpressZone = 5
            ElseIf subVarZip <= 579 Then
                Z_SHIPX_FigureFedExExpressZone = "NA"
            ElseIf subVarZip <= 588 Then
                Z_SHIPX_FigureFedExExpressZone = 6
            ElseIf subVarZip <= 589 Then
                Z_SHIPX_FigureFedExExpressZone = "NA"
            ElseIf subVarZip <= 599 Then
                Z_SHIPX_FigureFedExExpressZone = 5
            ElseIf subVarZip <= 620 Then
                Z_SHIPX_FigureFedExExpressZone = 7
            ElseIf subVarZip = 621 Then
                Z_SHIPX_FigureFedExExpressZone = "NA"
            ElseIf subVarZip <= 631 Then
                Z_SHIPX_FigureFedExExpressZone = 7
            ElseIf subVarZip = 632 Then
                Z_SHIPX_FigureFedExExpressZone = "NA"
            ElseIf subVarZip <= 641 Then
                Z_SHIPX_FigureFedExExpressZone = 7
            ElseIf subVarZip <= 643 Then
                Z_SHIPX_FigureFedExExpressZone = "NA"
            ElseIf subVarZip <= 658 Then
                Z_SHIPX_FigureFedExExpressZone = 7
            ElseIf subVarZip = 659 Then
                Z_SHIPX_FigureFedExExpressZone = "NA"
            ElseIf subVarZip <= 662 Then
                Z_SHIPX_FigureFedExExpressZone = 7
            ElseIf subVarZip = 663 Then
                Z_SHIPX_FigureFedExExpressZone = "NA"
            ElseIf subVarZip <= 666 Then
                Z_SHIPX_FigureFedExExpressZone = 6
            ElseIf subVarZip <= 667 Then
                Z_SHIPX_FigureFedExExpressZone = 7
            ElseIf subVarZip <= 681 Then
                Z_SHIPX_FigureFedExExpressZone = 6
            ElseIf subVarZip = 682 Then
                Z_SHIPX_FigureFedExExpressZone = "NA"
            ElseIf subVarZip <= 692 Then
                Z_SHIPX_FigureFedExExpressZone = 6
            ElseIf subVarZip <= 693 Then
                Z_SHIPX_FigureFedExExpressZone = 5
            ElseIf subVarZip <= 699 Then
                Z_SHIPX_FigureFedExExpressZone = "NA"
            ElseIf subVarZip <= 701 Then
                Z_SHIPX_FigureFedExExpressZone = 8
            ElseIf subVarZip = 702 Then
                Z_SHIPX_FigureFedExExpressZone = "NA"
            ElseIf subVarZip <= 704 Then
                Z_SHIPX_FigureFedExExpressZone = 8
            ElseIf subVarZip <= 708 Then
                Z_SHIPX_FigureFedExExpressZone = 7
            ElseIf subVarZip = 709 Then
                Z_SHIPX_FigureFedExExpressZone = "NA"
            ElseIf subVarZip <= 714 Then
                Z_SHIPX_FigureFedExExpressZone = 7
            ElseIf subVarZip = 715 Then
                Z_SHIPX_FigureFedExExpressZone = "NA"
            ElseIf subVarZip <= 729 Then
                Z_SHIPX_FigureFedExExpressZone = 7
            ElseIf subVarZip <= 731 Then
                Z_SHIPX_FigureFedExExpressZone = 6
            ElseIf subVarZip = 732 Then
                Z_SHIPX_FigureFedExExpressZone = "NA"
            ElseIf subVarZip <= 733 Then
                Z_SHIPX_FigureFedExExpressZone = 7
            ElseIf subVarZip <= 741 Then
                Z_SHIPX_FigureFedExExpressZone = 6
            ElseIf subVarZip = 742 Then
                Z_SHIPX_FigureFedExExpressZone = "NA"
            ElseIf subVarZip <= 745 Then
                Z_SHIPX_FigureFedExExpressZone = 7
            ElseIf subVarZip <= 746 Then
                Z_SHIPX_FigureFedExExpressZone = 6
            ElseIf subVarZip <= 747 Then
                Z_SHIPX_FigureFedExExpressZone = 7
            ElseIf subVarZip <= 748 Then
                Z_SHIPX_FigureFedExExpressZone = 6
            ElseIf subVarZip <= 759 Then
                Z_SHIPX_FigureFedExExpressZone = 7
            ElseIf subVarZip <= 764 Then
                Z_SHIPX_FigureFedExExpressZone = 6
            ElseIf subVarZip <= 767 Then
                Z_SHIPX_FigureFedExExpressZone = 7
            ElseIf subVarZip <= 769 Then
                Z_SHIPX_FigureFedExExpressZone = 6
            ElseIf subVarZip <= 787 Then
                Z_SHIPX_FigureFedExExpressZone = 7
            ElseIf subVarZip <= 788 Then
                Z_SHIPX_FigureFedExExpressZone = 6
            ElseIf subVarZip <= 789 Then
                Z_SHIPX_FigureFedExExpressZone = 7
            ElseIf subVarZip <= 797 Then
                Z_SHIPX_FigureFedExExpressZone = 6
            ElseIf subVarZip <= 816 Then
                Z_SHIPX_FigureFedExExpressZone = 5
            ElseIf subVarZip <= 819 Then
                Z_SHIPX_FigureFedExExpressZone = "NA"
            ElseIf subVarZip <= 830 Then
                Z_SHIPX_FigureFedExExpressZone = 5
            ElseIf subVarZip <= 837 Then
                Z_SHIPX_FigureFedExExpressZone = 4
            ElseIf subVarZip <= 838 Then
                Z_SHIPX_FigureFedExExpressZone = 5
            ElseIf subVarZip <= 839 Then
                Z_SHIPX_FigureFedExExpressZone = "NA"
            ElseIf subVarZip <= 847 Then
                Z_SHIPX_FigureFedExExpressZone = 4
            ElseIf subVarZip <= 849 Then
                Z_SHIPX_FigureFedExExpressZone = "NA"
            ElseIf subVarZip <= 852 Then
                Z_SHIPX_FigureFedExExpressZone = 5
            ElseIf subVarZip <= 853 Then
                Z_SHIPX_FigureFedExExpressZone = 4
            ElseIf subVarZip = 854 Then
                Z_SHIPX_FigureFedExExpressZone = "NA"
            ElseIf subVarZip <= 857 Then
                Z_SHIPX_FigureFedExExpressZone = 5
            ElseIf subVarZip = 858 Then
                Z_SHIPX_FigureFedExExpressZone = "NA"
            ElseIf subVarZip <= 859 Then
                Z_SHIPX_FigureFedExExpressZone = 5
            ElseIf subVarZip <= 860 Then
                Z_SHIPX_FigureFedExExpressZone = 4
            ElseIf subVarZip <= 862 Then
                Z_SHIPX_FigureFedExExpressZone = "NA"
            ElseIf subVarZip <= 864 Then
                Z_SHIPX_FigureFedExExpressZone = 4
            ElseIf subVarZip <= 865 Then
                Z_SHIPX_FigureFedExExpressZone = 5
            ElseIf subVarZip <= 869 Then
                Z_SHIPX_FigureFedExExpressZone = "NA"
            ElseIf subVarZip <= 875 Then
                Z_SHIPX_FigureFedExExpressZone = 5
            ElseIf subVarZip = 876 Then
                Z_SHIPX_FigureFedExExpressZone = "NA"
            ElseIf subVarZip <= 880 Then
                Z_SHIPX_FigureFedExExpressZone = 5
            ElseIf subVarZip <= 881 Then
                Z_SHIPX_FigureFedExExpressZone = 6
            ElseIf subVarZip <= 885 Then
                Z_SHIPX_FigureFedExExpressZone = 5
            ElseIf subVarZip <= 888 Then
                Z_SHIPX_FigureFedExExpressZone = "NA"
            ElseIf subVarZip <= 891 Then
                Z_SHIPX_FigureFedExExpressZone = 4
            ElseIf subVarZip = 892 Then
                Z_SHIPX_FigureFedExExpressZone = "NA"
            ElseIf subVarZip = 893 Then
                Z_SHIPX_FigureFedExExpressZone = 4
            ElseIf subVarZip <= 895 Then
                Z_SHIPX_FigureFedExExpressZone = 2
            ElseIf subVarZip = 896 Then
                Z_SHIPX_FigureFedExExpressZone = "NA"
            ElseIf subVarZip <= 897 Then
                Z_SHIPX_FigureFedExExpressZone = 2
            ElseIf subVarZip <= 898 Then
                Z_SHIPX_FigureFedExExpressZone = 4
            ElseIf subVarZip = 899 Then
                Z_SHIPX_FigureFedExExpressZone = "NA"
            ElseIf subVarZip <= 908 Then
                Z_SHIPX_FigureFedExExpressZone = 4
            ElseIf subVarZip = 909 Then
                Z_SHIPX_FigureFedExExpressZone = "NA"
            ElseIf subVarZip <= 928 Then
                Z_SHIPX_FigureFedExExpressZone = 4
            ElseIf subVarZip = 929 Then
                Z_SHIPX_FigureFedExExpressZone = "NA"
            ElseIf subVarZip <= 931 Then
                Z_SHIPX_FigureFedExExpressZone = 4
            ElseIf subVarZip <= 935 Then
                Z_SHIPX_FigureFedExExpressZone = 3
            ElseIf subVarZip <= 954 Then
                Z_SHIPX_FigureFedExExpressZone = 2
            ElseIf subVarZip <= 955 Then
                Z_SHIPX_FigureFedExExpressZone = 3
            ElseIf subVarZip <= 966 Then
                Z_SHIPX_FigureFedExExpressZone = 2
            ElseIf subVarZip <= 968 Then
                Z_SHIPX_FigureFedExExpressZone = 8
            ElseIf subVarZip <= 974 Then
                Z_SHIPX_FigureFedExExpressZone = 4
            ElseIf subVarZip <= 976 Then
                Z_SHIPX_FigureFedExExpressZone = 3
            ElseIf subVarZip <= 979 Then
                Z_SHIPX_FigureFedExExpressZone = 4
            ElseIf subVarZip <= 982 Then
                Z_SHIPX_FigureFedExExpressZone = 5
            ElseIf subVarZip <= 986 Then
                Z_SHIPX_FigureFedExExpressZone = 4
            ElseIf subVarZip = 987 Then
                Z_SHIPX_FigureFedExExpressZone = "NA"
            ElseIf subVarZip <= 989 Then
                Z_SHIPX_FigureFedExExpressZone = 4
            ElseIf subVarZip <= 992 Then
                Z_SHIPX_FigureFedExExpressZone = 5
            ElseIf subVarZip <= 994 Then
                Z_SHIPX_FigureFedExExpressZone = 4
            ElseIf subVarZip <= 999 Then
                Z_SHIPX_FigureFedExExpressZone = 8
            End If
        Else
            Z_SHIPX_FigureFedExExpressZone = "NA"
        End If

    End Function
    Public Function Z_SHIPX_FigureMediaMailZone(subVarCountry As String, subVarState As String, subVarPriceGroup As String, subVarZip As String) As String
        Z_SHIPX_FigureMediaMailZone = "NA"
        If subVarCountry = "USA" Then
            If subVarPriceGroup = "RetailPrice" Then
                Z_SHIPX_FigureMediaMailZone = "8"
            Else
                Z_SHIPX_FigureMediaMailZone = "8"
            End If
        End If
    End Function

    Function Z_SHIPX_FigureAirMailLetterPostZone(subVarCountryALP As String, strConnectionStringName As String) As String
        If subVarCountryALP = "USA" Then
            Z_SHIPX_FigureAirMailLetterPostZone = "NA"
        Else
            Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
                SqlConnection.ClearPool(conn)
                conn.Open()
                Dim CMD_X As New SqlCommand("spUSPSNotShippingTo", conn)
                CMD_X.CommandType = Data.CommandType.StoredProcedure
                CMD_X.Parameters.AddWithValue("@Country", subVarCountryALP)
                Dim readerX As SqlDataReader
                readerX = CMD_X.ExecuteReader
                If readerX.HasRows Then
                    Return "NA"
                End If
            End Using

            Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
                SqlConnection.ClearPool(conn)
                conn.Open()
                Dim CMD_X As New SqlCommand("spGetAirMailLetterPostZone", conn)
                CMD_X.CommandType = Data.CommandType.StoredProcedure
                CMD_X.Parameters.AddWithValue("@Country", subVarCountryALP)
                Dim readerX As SqlDataReader
                readerX = CMD_X.ExecuteReader
                If readerX.HasRows Then
                    readerX.Read()
                    Z_SHIPX_FigureAirMailLetterPostZone = readerX("AirSmallPacketZone")
                End If
            End Using
        End If
    End Function
    Public Function CopyrightFooter()
        CopyrightFooter = "Copyright 2017-" & Date.Today.Year & " Millions Of Records. Trademarks, servicemarks, brands, musical works, audio visual works, recordings and artwork are the property of their respective owners."
    End Function

    Public Function CapFirstLetter(texttofix As String) As String
        CapFirstLetter = Trim(texttofix)
        If CapFirstLetter = "" Or Len(CapFirstLetter) = 0 Then Exit Function
        Dim ltxt As String = Len(CapFirstLetter)
        CapFirstLetter = UCase(Left(CapFirstLetter, 1)) & Right(CapFirstLetter, ltxt - 1)
        Dim x As Integer = 1
        Dim position As Integer = 0
        Do
            position = InStr(x, CapFirstLetter, " ")
            If position = 0 Then Exit Do
            CapFirstLetter = Left(CapFirstLetter, position) & UCase(Mid(CapFirstLetter, position + 1, 1)) & Right(CapFirstLetter, ltxt - position - 1)
            x = position + 1
        Loop

    End Function

    Public Function SanitizeNameAndAddress(texttofix As String) As String
        SanitizeNameAndAddress = texttofix
        If SanitizeNameAndAddress = "" Then Exit Function
        Dim position As Integer = 0
        position = InStr(1, SanitizeNameAndAddress, "'")
        If position > 0 Then
            Do
                SanitizeNameAndAddress = Left(SanitizeNameAndAddress, position - 1) & "`" & Right(SanitizeNameAndAddress, Len(SanitizeNameAndAddress) - position)
                position = InStr(position + 1, SanitizeNameAndAddress, "'")
                If position = 0 Then Exit Do
            Loop
        End If

        position = InStr(1, SanitizeNameAndAddress, ">")
        If position > 0 Then
            Do
                SanitizeNameAndAddress = Left(SanitizeNameAndAddress, position - 1) & Right(SanitizeNameAndAddress, Len(SanitizeNameAndAddress) - position)
                position = InStr(position + 1, SanitizeNameAndAddress, ">")
                If position = 0 Then Exit Do
            Loop
        End If

        position = InStr(1, SanitizeNameAndAddress, "<")
        If position > 0 Then
            Do
                SanitizeNameAndAddress = Left(SanitizeNameAndAddress, position - 1) & Right(SanitizeNameAndAddress, Len(SanitizeNameAndAddress) - position)
                position = InStr(position + 1, SanitizeNameAndAddress, "<")
                If position = 0 Then Exit Do
            Loop
        End If

        position = InStr(1, SanitizeNameAndAddress, """")
        If position > 0 Then
            Do
                SanitizeNameAndAddress = Left(SanitizeNameAndAddress, position - 1) & Right(SanitizeNameAndAddress, Len(SanitizeNameAndAddress) - position)
                position = InStr(position + 1, SanitizeNameAndAddress, """")
                If position = 0 Then Exit Do
            Loop
        End If

        position = InStr(1, SanitizeNameAndAddress, "%")
        If position > 0 Then
            Do
                SanitizeNameAndAddress = Left(SanitizeNameAndAddress, position - 1) & Right(SanitizeNameAndAddress, Len(SanitizeNameAndAddress) - position)
                position = InStr(position + 1, SanitizeNameAndAddress, "%")
                If position = 0 Then Exit Do
            Loop
        End If

        position = InStr(1, SanitizeNameAndAddress, ";")
        If position > 0 Then
            Do
                SanitizeNameAndAddress = Left(SanitizeNameAndAddress, position - 1) & Right(SanitizeNameAndAddress, Len(SanitizeNameAndAddress) - position)
                position = InStr(position + 1, SanitizeNameAndAddress, ";")
                If position = 0 Then Exit Do
            Loop
        End If

        position = InStr(1, SanitizeNameAndAddress, "!")
        If position > 0 Then
            Do
                SanitizeNameAndAddress = Left(SanitizeNameAndAddress, position - 1) & Right(SanitizeNameAndAddress, Len(SanitizeNameAndAddress) - position)
                position = InStr(position + 1, SanitizeNameAndAddress, "!")
                If position = 0 Then Exit Do
            Loop
        End If

        position = InStr(1, SanitizeNameAndAddress, "--")
        If position > 0 Then
            Do
                SanitizeNameAndAddress = Left(SanitizeNameAndAddress, position - 1) & Right(SanitizeNameAndAddress, Len(SanitizeNameAndAddress) - position - 1)
                position = InStr(position + 1, SanitizeNameAndAddress, "--")
                If position = 0 Then Exit Do
            Loop
        End If
    End Function

    Public Function FixEmail(texttofix As String) As String
        FixEmail = texttofix
        If FixEmail = "" Then Exit Function
        Dim position As Integer = 0
        position = InStr(1, FixEmail, ",")
        If position > 0 Then
            Do
                FixEmail = Left(FixEmail, position - 1) & "." & Right(FixEmail, Len(FixEmail) - position)
                position = InStr(position + 1, FixEmail, ",")
                If position = 0 Then Exit Do
            Loop
        End If

        position = InStr(1, UCase(FixEmail), "@YAHO.")
        If position > 0 Then
            Do
                FixEmail = Left(FixEmail, position - 1) & "@yahoo." & Right(FixEmail, Len(FixEmail) - position - 5)
                position = InStr(position + 1, UCase(FixEmail), "@YAHO.")
                If position = 0 Then Exit Do
            Loop
        End If

    End Function
    Public Function Z_SHIPX_FigureFedExGroundZone(subVarCountry As String, subVarZipCode As String, subVarState As String) As String
        Z_SHIPX_FigureFedExGroundZone = "NA"
        If Len(subVarZipCode) < 5 Then
            Z_SHIPX_FigureFedExGroundZone = "NA"
            Exit Function
        End If
        If Not IsNumeric(subVarZipCode) Then
            Z_SHIPX_FigureFedExGroundZone = "NA"
            Exit Function
        End If
        If subVarState = "AA (Military)" Or subVarState = "AE (Military)" Or subVarState = "AP (Military)" Or subVarState = "American Samoa" Or subVarState = "Guam" Or subVarState = "Marshall Islands" Or subVarState = "Micronesia" Or subVarState = "Northern Mariana Islands" Or subVarState = "Palau" Or subVarState = "Puerto Rico" Or subVarState = "Virgin Islands (U.S.)" Or subVarState = "Alaska" Or subVarState = "Hawaii" Then
            Z_SHIPX_FigureFedExGroundZone = "NA"
            Exit Function
        End If
        Dim subVarZip As String = ""
        If subVarCountry = "USA" Then
            subVarZip = Left(subVarZipCode, 3)
            subVarZipCode = Left(subVarZipCode, 5)
            If subVarZip <= 4 Then
                Z_SHIPX_FigureFedExGroundZone = "NA"
            ElseIf subVarZip <= 5 Then
                Z_SHIPX_FigureFedExGroundZone = 8
            ElseIf subVarZip <= 9 Then
                Z_SHIPX_FigureFedExGroundZone = "NA"
            ElseIf subVarZip <= 212 Then
                Z_SHIPX_FigureFedExGroundZone = 8
            ElseIf subVarZip = 213 Then
                Z_SHIPX_FigureFedExGroundZone = "NA"
            ElseIf subVarZip <= 268 Then
                Z_SHIPX_FigureFedExGroundZone = 8
            ElseIf subVarZip = 269 Then
                Z_SHIPX_FigureFedExGroundZone = "NA"
            ElseIf subVarZip <= 342 Then
                Z_SHIPX_FigureFedExGroundZone = 8
            ElseIf subVarZip = 343 Then
                Z_SHIPX_FigureFedExGroundZone = "NA"
            ElseIf subVarZip = 344 Then
                Z_SHIPX_FigureFedExGroundZone = 8
            ElseIf subVarZip = 345 Then
                Z_SHIPX_FigureFedExGroundZone = "NA"
            ElseIf subVarZip <= 347 Then
                Z_SHIPX_FigureFedExGroundZone = 8
            ElseIf subVarZip = 348 Then
                Z_SHIPX_FigureFedExGroundZone = "NA"
            ElseIf subVarZip <= 352 Then
                Z_SHIPX_FigureFedExGroundZone = 8
            ElseIf subVarZip = 353 Then
                Z_SHIPX_FigureFedExGroundZone = "NA"
            ElseIf subVarZip <= 374 Then
                Z_SHIPX_FigureFedExGroundZone = 8
            ElseIf subVarZip <= 375 Then
                Z_SHIPX_FigureFedExGroundZone = 7
            ElseIf subVarZip <= 379 Then
                Z_SHIPX_FigureFedExGroundZone = 8
            ElseIf subVarZip <= 383 Then
                Z_SHIPX_FigureFedExGroundZone = 7
            ElseIf subVarZip <= 385 Then
                Z_SHIPX_FigureFedExGroundZone = 8
            ElseIf subVarZip <= 387 Then
                Z_SHIPX_FigureFedExGroundZone = 7
            ElseIf subVarZip <= 388 Then
                Z_SHIPX_FigureFedExGroundZone = 8
            ElseIf subVarZip <= 392 Then
                Z_SHIPX_FigureFedExGroundZone = 7
            ElseIf subVarZip <= 395 Then
                Z_SHIPX_FigureFedExGroundZone = 8
            ElseIf subVarZip <= 396 Then
                Z_SHIPX_FigureFedExGroundZone = 7
            ElseIf subVarZip <= 418 Then
                Z_SHIPX_FigureFedExGroundZone = 8
            ElseIf subVarZip <= 419 Then
                Z_SHIPX_FigureFedExGroundZone = "NA"
            ElseIf subVarZip <= 420 Then
                Z_SHIPX_FigureFedExGroundZone = 7
            ElseIf subVarZip <= 423 Then
                Z_SHIPX_FigureFedExGroundZone = 8
            ElseIf subVarZip <= 424 Then
                Z_SHIPX_FigureFedExGroundZone = 7
            ElseIf subVarZip <= 427 Then
                Z_SHIPX_FigureFedExGroundZone = 8
            ElseIf subVarZip <= 429 Then
                Z_SHIPX_FigureFedExGroundZone = "NA"
            ElseIf subVarZip <= 462 Then
                Z_SHIPX_FigureFedExGroundZone = 8
            ElseIf subVarZip <= 464 Then
                Z_SHIPX_FigureFedExGroundZone = 7
            ElseIf subVarZip <= 475 Then
                Z_SHIPX_FigureFedExGroundZone = 8
            ElseIf subVarZip <= 477 Then
                Z_SHIPX_FigureFedExGroundZone = 7
            ElseIf subVarZip <= 497 Then
                Z_SHIPX_FigureFedExGroundZone = 8
            ElseIf subVarZip <= 509 Then
                Z_SHIPX_FigureFedExGroundZone = 7
            ElseIf subVarZip <= 516 Then
                Z_SHIPX_FigureFedExGroundZone = 6
            ElseIf subVarZip <= 519 Then
                Z_SHIPX_FigureFedExGroundZone = "NA"
            ElseIf subVarZip <= 528 Then
                Z_SHIPX_FigureFedExGroundZone = 7
            ElseIf subVarZip = 529 Then
                Z_SHIPX_FigureFedExGroundZone = "NA"
            ElseIf subVarZip <= 532 Then
                Z_SHIPX_FigureFedExGroundZone = 7
            ElseIf subVarZip = 533 Then
                Z_SHIPX_FigureFedExGroundZone = "NA"
            ElseIf subVarZip <= 535 Then
                Z_SHIPX_FigureFedExGroundZone = 7
            ElseIf subVarZip = 536 Then
                Z_SHIPX_FigureFedExGroundZone = "NA"
            ElseIf subVarZip <= 551 Then
                Z_SHIPX_FigureFedExGroundZone = 7
            ElseIf subVarZip = 552 Then
                Z_SHIPX_FigureFedExGroundZone = "NA"
            ElseIf subVarZip <= 560 Then
                Z_SHIPX_FigureFedExGroundZone = 7
            ElseIf subVarZip <= 562 Then
                Z_SHIPX_FigureFedExGroundZone = 6
            ElseIf subVarZip <= 564 Then
                Z_SHIPX_FigureFedExGroundZone = 7
            ElseIf subVarZip <= 565 Then
                Z_SHIPX_FigureFedExGroundZone = 6
            ElseIf subVarZip <= 566 Then
                Z_SHIPX_FigureFedExGroundZone = 7
            ElseIf subVarZip <= 576 Then
                Z_SHIPX_FigureFedExGroundZone = 6
            ElseIf subVarZip <= 577 Then
                Z_SHIPX_FigureFedExGroundZone = 5
            ElseIf subVarZip <= 579 Then
                Z_SHIPX_FigureFedExGroundZone = "NA"
            ElseIf subVarZip <= 588 Then
                Z_SHIPX_FigureFedExGroundZone = 6
            ElseIf subVarZip <= 589 Then
                Z_SHIPX_FigureFedExGroundZone = "NA"
            ElseIf subVarZip <= 599 Then
                Z_SHIPX_FigureFedExGroundZone = 5
            ElseIf subVarZip <= 620 Then
                Z_SHIPX_FigureFedExGroundZone = 7
            ElseIf subVarZip = 621 Then
                Z_SHIPX_FigureFedExGroundZone = "NA"
            ElseIf subVarZip <= 631 Then
                Z_SHIPX_FigureFedExGroundZone = 7
            ElseIf subVarZip = 632 Then
                Z_SHIPX_FigureFedExGroundZone = "NA"
            ElseIf subVarZip <= 641 Then
                Z_SHIPX_FigureFedExGroundZone = 7
            ElseIf subVarZip <= 643 Then
                Z_SHIPX_FigureFedExGroundZone = "NA"
            ElseIf subVarZip <= 658 Then
                Z_SHIPX_FigureFedExGroundZone = 7
            ElseIf subVarZip = 659 Then
                Z_SHIPX_FigureFedExGroundZone = "NA"
            ElseIf subVarZip <= 662 Then
                Z_SHIPX_FigureFedExGroundZone = 7
            ElseIf subVarZip = 663 Then
                Z_SHIPX_FigureFedExGroundZone = "NA"
            ElseIf subVarZip <= 666 Then
                Z_SHIPX_FigureFedExGroundZone = 6
            ElseIf subVarZip <= 667 Then
                Z_SHIPX_FigureFedExGroundZone = 7
            ElseIf subVarZip <= 681 Then
                Z_SHIPX_FigureFedExGroundZone = 6
            ElseIf subVarZip = 682 Then
                Z_SHIPX_FigureFedExGroundZone = "NA"
            ElseIf subVarZip <= 692 Then
                Z_SHIPX_FigureFedExGroundZone = 6
            ElseIf subVarZip <= 693 Then
                Z_SHIPX_FigureFedExGroundZone = 5
            ElseIf subVarZip <= 699 Then
                Z_SHIPX_FigureFedExGroundZone = "NA"
            ElseIf subVarZip <= 701 Then
                Z_SHIPX_FigureFedExGroundZone = 8
            ElseIf subVarZip = 702 Then
                Z_SHIPX_FigureFedExGroundZone = "NA"
            ElseIf subVarZip <= 704 Then
                Z_SHIPX_FigureFedExGroundZone = 8
            ElseIf subVarZip <= 708 Then
                Z_SHIPX_FigureFedExGroundZone = 7
            ElseIf subVarZip = 709 Then
                Z_SHIPX_FigureFedExGroundZone = "NA"
            ElseIf subVarZip <= 714 Then
                Z_SHIPX_FigureFedExGroundZone = 7
            ElseIf subVarZip = 715 Then
                Z_SHIPX_FigureFedExGroundZone = "NA"
            ElseIf subVarZip <= 729 Then
                Z_SHIPX_FigureFedExGroundZone = 7
            ElseIf subVarZip <= 731 Then
                Z_SHIPX_FigureFedExGroundZone = 6
            ElseIf subVarZip = 732 Then
                Z_SHIPX_FigureFedExGroundZone = "NA"
            ElseIf subVarZip <= 733 Then
                Z_SHIPX_FigureFedExGroundZone = 7
            ElseIf subVarZip <= 741 Then
                Z_SHIPX_FigureFedExGroundZone = 6
            ElseIf subVarZip = 742 Then
                Z_SHIPX_FigureFedExGroundZone = "NA"
            ElseIf subVarZip <= 745 Then
                Z_SHIPX_FigureFedExGroundZone = 7
            ElseIf subVarZip <= 746 Then
                Z_SHIPX_FigureFedExGroundZone = 6
            ElseIf subVarZip <= 747 Then
                Z_SHIPX_FigureFedExGroundZone = 7
            ElseIf subVarZip <= 748 Then
                Z_SHIPX_FigureFedExGroundZone = 6
            ElseIf subVarZip <= 759 Then
                Z_SHIPX_FigureFedExGroundZone = 7
            ElseIf subVarZip <= 764 Then
                Z_SHIPX_FigureFedExGroundZone = 6
            ElseIf subVarZip <= 767 Then
                Z_SHIPX_FigureFedExGroundZone = 7
            ElseIf subVarZip <= 769 Then
                Z_SHIPX_FigureFedExGroundZone = 6
            ElseIf subVarZip <= 787 Then
                Z_SHIPX_FigureFedExGroundZone = 7
            ElseIf subVarZip <= 788 Then
                Z_SHIPX_FigureFedExGroundZone = 6
            ElseIf subVarZip <= 789 Then
                Z_SHIPX_FigureFedExGroundZone = 7
            ElseIf subVarZip <= 797 Then
                Z_SHIPX_FigureFedExGroundZone = 6
            ElseIf subVarZip <= 816 Then
                Z_SHIPX_FigureFedExGroundZone = 5
            ElseIf subVarZip <= 819 Then
                Z_SHIPX_FigureFedExGroundZone = "NA"
            ElseIf subVarZip <= 830 Then
                Z_SHIPX_FigureFedExGroundZone = 5
            ElseIf subVarZip <= 837 Then
                Z_SHIPX_FigureFedExGroundZone = 4
            ElseIf subVarZip <= 838 Then
                Z_SHIPX_FigureFedExGroundZone = 5
            ElseIf subVarZip <= 839 Then
                Z_SHIPX_FigureFedExGroundZone = "NA"
            ElseIf subVarZip <= 847 Then
                Z_SHIPX_FigureFedExGroundZone = 4
            ElseIf subVarZip <= 849 Then
                Z_SHIPX_FigureFedExGroundZone = "NA"
            ElseIf subVarZip <= 852 Then
                Z_SHIPX_FigureFedExGroundZone = 5
            ElseIf subVarZip <= 853 Then
                Z_SHIPX_FigureFedExGroundZone = 4
            ElseIf subVarZip = 854 Then
                Z_SHIPX_FigureFedExGroundZone = "NA"
            ElseIf subVarZip <= 857 Then
                Z_SHIPX_FigureFedExGroundZone = 5
            ElseIf subVarZip = 858 Then
                Z_SHIPX_FigureFedExGroundZone = "NA"
            ElseIf subVarZip <= 859 Then
                Z_SHIPX_FigureFedExGroundZone = 5
            ElseIf subVarZip <= 860 Then
                Z_SHIPX_FigureFedExGroundZone = 4
            ElseIf subVarZip <= 862 Then
                Z_SHIPX_FigureFedExGroundZone = "NA"
            ElseIf subVarZip <= 864 Then
                Z_SHIPX_FigureFedExGroundZone = 4
            ElseIf subVarZip <= 865 Then
                Z_SHIPX_FigureFedExGroundZone = 5
            ElseIf subVarZip <= 869 Then
                Z_SHIPX_FigureFedExGroundZone = "NA"
            ElseIf subVarZip <= 875 Then
                Z_SHIPX_FigureFedExGroundZone = 5
            ElseIf subVarZip = 876 Then
                Z_SHIPX_FigureFedExGroundZone = "NA"
            ElseIf subVarZip <= 880 Then
                Z_SHIPX_FigureFedExGroundZone = 5
            ElseIf subVarZip <= 881 Then
                Z_SHIPX_FigureFedExGroundZone = 6
            ElseIf subVarZip <= 885 Then
                Z_SHIPX_FigureFedExGroundZone = 5
            ElseIf subVarZip <= 888 Then
                Z_SHIPX_FigureFedExGroundZone = "NA"
            ElseIf subVarZip <= 891 Then
                Z_SHIPX_FigureFedExGroundZone = 4
            ElseIf subVarZip = 892 Then
                Z_SHIPX_FigureFedExGroundZone = "NA"
            ElseIf subVarZip = 893 Then
                Z_SHIPX_FigureFedExGroundZone = 4
            ElseIf subVarZip <= 895 Then
                Z_SHIPX_FigureFedExGroundZone = 2
            ElseIf subVarZip = 896 Then
                Z_SHIPX_FigureFedExGroundZone = "NA"
            ElseIf subVarZip <= 897 Then
                Z_SHIPX_FigureFedExGroundZone = 2
            ElseIf subVarZip <= 898 Then
                Z_SHIPX_FigureFedExGroundZone = 4
            ElseIf subVarZip = 899 Then
                Z_SHIPX_FigureFedExGroundZone = "NA"
            ElseIf subVarZip <= 908 Then
                Z_SHIPX_FigureFedExGroundZone = 4
            ElseIf subVarZip = 909 Then
                Z_SHIPX_FigureFedExGroundZone = "NA"
            ElseIf subVarZip <= 928 Then
                Z_SHIPX_FigureFedExGroundZone = 4
            ElseIf subVarZip = 929 Then
                Z_SHIPX_FigureFedExGroundZone = "NA"
            ElseIf subVarZip <= 931 Then
                Z_SHIPX_FigureFedExGroundZone = 4
            ElseIf subVarZip <= 935 Then
                Z_SHIPX_FigureFedExGroundZone = 3
            ElseIf subVarZip <= 954 Then
                Z_SHIPX_FigureFedExGroundZone = 2
            ElseIf subVarZip <= 955 Then
                Z_SHIPX_FigureFedExGroundZone = 3
            ElseIf subVarZip <= 966 Then
                Z_SHIPX_FigureFedExGroundZone = 2
            ElseIf subVarZip <= 969 Then
                Z_SHIPX_FigureFedExGroundZone = "NA"
            ElseIf subVarZip <= 974 Then
                Z_SHIPX_FigureFedExGroundZone = 4
            ElseIf subVarZip <= 976 Then
                Z_SHIPX_FigureFedExGroundZone = 3
            ElseIf subVarZip <= 979 Then
                Z_SHIPX_FigureFedExGroundZone = 4
            ElseIf subVarZip <= 982 Then
                Z_SHIPX_FigureFedExGroundZone = 5
            ElseIf subVarZip <= 986 Then
                Z_SHIPX_FigureFedExGroundZone = 4
            ElseIf subVarZip = 987 Then
                Z_SHIPX_FigureFedExGroundZone = "NA"
            ElseIf subVarZip <= 989 Then
                Z_SHIPX_FigureFedExGroundZone = 4
            ElseIf subVarZip <= 992 Then
                Z_SHIPX_FigureFedExGroundZone = 5
            ElseIf subVarZip <= 994 Then
                Z_SHIPX_FigureFedExGroundZone = 4
            Else
                Z_SHIPX_FigureFedExGroundZone = "NA"
            End If
        End If
    End Function
    Public Function Z_SHIPX_FigureIfCODAllowed(ByVal subVarShippingMethod As String, ByVal strConnectionStringName As String) As String
        Z_SHIPX_FigureIfCODAllowed = "N"
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
            SqlConnection.ClearPool(conn)
            conn.Open()
            Dim CMD_X As New SqlCommand("spGetShippingMethodsRow", conn)
            CMD_X.CommandType = Data.CommandType.StoredProcedure
            CMD_X.Parameters.AddWithValue("@ShippingMethodCode", subVarShippingMethod)
            Dim readerX As SqlDataReader
            readerX = CMD_X.ExecuteReader
            If readerX.HasRows Then
                readerX.Read()
                Z_SHIPX_FigureIfCODAllowed = readerX("CODOK")
            End If
        End Using
    End Function
    Public Function Z_SHIPX_FigureShipDate(subVarShipmentDate As Date, subVarShippingMehod As String, ByVal strConnectionStringName As String) As Date
        If Len(subVarShipmentDate.ToString) = 0 Then
            Z_SHIPX_FigureShipDate = "NA"
            Exit Function
        End If
        Dim intShippingCutoffMinutes As Integer = 600
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
            SqlConnection.ClearPool(conn)
            conn.Open()
            Dim CMD_X As New SqlCommand("spGetShippingCutoffMinutes", conn)
            CMD_X.CommandType = Data.CommandType.StoredProcedure
            CMD_X.Parameters.AddWithValue("@ShippingMethodCode", subVarShippingMehod)
            Dim readerX As SqlDataReader
            readerX = CMD_X.ExecuteReader
            If readerX.HasRows Then
                readerX.Read()
                intShippingCutoffMinutes = readerX("WebShippingCutoffMinutes")
            End If
        End Using

        If DateTime.Now.Hour * 60 + DateTime.Now.Minute >= intShippingCutoffMinutes Then
            Z_SHIPX_FigureShipDate = subVarShipmentDate.AddDays(1)
        Else
            Z_SHIPX_FigureShipDate = subVarShipmentDate
        End If

        Z_SHIPX_FigureShipDate = Z_SHIPX_FigureShipDate.ToShortDateString

    End Function
    Public Function Z_SHIPX_FigureTransitDaysAirmailLetterPost() As String
        Z_SHIPX_FigureTransitDaysAirmailLetterPost = "4-10"
    End Function
    Public Function Z_SHIPX_FigureTransitDaysAirParcelPost() As String
        Z_SHIPX_FigureTransitDaysAirParcelPost = "4-10"
    End Function
    Public Function Z_SHIPX_FigureTransitDaysExpressMail() As String
        Z_SHIPX_FigureTransitDaysExpressMail = "1-2"
    End Function
    Public Function Z_SHIPX_FigureTransitDaysFedExExpressSaver(subVarCountry As String, subVarZipCode As String) As String
        Z_SHIPX_FigureTransitDaysFedExExpressSaver = "3"
    End Function
    Public Function Z_SHIPX_FigureTransitDaysFedExGround(subVarCountry As String, subVarZipCode As String, strConnectionStringName As String) As String
        If Len(subVarZipCode) < 5 Then
            Z_SHIPX_FigureTransitDaysFedExGround = "NA"
            Exit Function
        End If

        If subVarCountry <> "USA" Then
            Z_SHIPX_FigureTransitDaysFedExGround = "NA"
            Exit Function
        End If

        Dim subVarZip5 As String = Left(subVarZipCode, 5)

        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
            SqlConnection.ClearPool(conn)
            conn.Open()
            Dim CMD_X As New SqlCommand("[spGetWebSHIPX_FedExGroundTimeInTransitRow]", conn)
            CMD_X.CommandType = Data.CommandType.StoredProcedure
            CMD_X.Parameters.AddWithValue("@ZipCode", subVarZip5)
            Dim readerX As SqlDataReader
            readerX = CMD_X.ExecuteReader
            If readerX.HasRows Then
                readerX.Read()
                Z_SHIPX_FigureTransitDaysFedExGround = readerX("Days")
            Else
                Z_SHIPX_FigureTransitDaysFedExGround = "NA"
                Exit Function
            End If
        End Using

    End Function
    Public Function Z_SHIPX_FigureTransitDaysFedExInternationalEconomy() As String
        Z_SHIPX_FigureTransitDaysFedExInternationalEconomy = "5"
    End Function
    Public Function Z_SHIPX_FigureTransitDaysFedExInternationalPriority(subVarCountry As String) As String
        Z_SHIPX_FigureTransitDaysFedExInternationalPriority = "2"
        If subVarCountry = "Canada" Or subVarCountry = "Mexico" Then
            Z_SHIPX_FigureTransitDaysFedExInternationalPriority = "1-2"
        End If
    End Function
    Public Function Z_SHIPX_FigureTransitDaysFedexSaturday2ndDay(varCountry As String, varZipCode As String) As String
        If Len(varZipCode) < 5 Then
            Z_SHIPX_FigureTransitDaysFedexSaturday2ndDay = "NA"
            Exit Function
        End If
        Z_SHIPX_FigureTransitDaysFedexSaturday2ndDay = "2"
    End Function
    Public Function Z_SHIPX_FigureTransitDaysFedexSaturdayOvernight(varZipCode As String) As String
        If Len(varZipCode) < 5 Then
            Z_SHIPX_FigureTransitDaysFedexSaturdayOvernight = "NA"
            Exit Function
        End If
        Z_SHIPX_FigureTransitDaysFedexSaturdayOvernight = "1"
    End Function
    Public Function Z_SHIPX_FigureTransitDaysFedExStandardOvernight() As String
        Z_SHIPX_FigureTransitDaysFedExStandardOvernight = "1"
    End Function
    Public Function Z_SHIPX_FigureTransitDaysFirstClass(subVarFirstClassZone As String, subVarState As String, strConnectionStringName As String) As String
        If Len(subVarState) = 0 Then
            Z_SHIPX_FigureTransitDaysFirstClass = ""
            Exit Function
        End If
        If Len(subVarFirstClassZone) = 0 Then
            Z_SHIPX_FigureTransitDaysFirstClass = ""
            Exit Function
        End If

        Dim subVarStateAbbreviation As String = ""
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
            SqlConnection.ClearPool(conn)
            conn.Open()
            Dim CMD_Z As New SqlCommand("spGetWebCountryStateProvincesListRow", conn)
            CMD_Z.CommandType = Data.CommandType.StoredProcedure
            CMD_Z.Parameters.AddWithValue("@Country", "USA")
            CMD_Z.Parameters.AddWithValue("@StateProvince", subVarState)
            Dim readerZ As SqlDataReader
            readerZ = CMD_Z.ExecuteReader
            If readerZ.HasRows Then
                readerZ.Read()
                subVarStateAbbreviation = readerZ("StateProvinceAbbreviation")
            Else
                Z_SHIPX_FigureTransitDaysFirstClass = "2-3"
                Exit Function
            End If
        End Using

        If subVarStateAbbreviation = "HI" Or subVarStateAbbreviation = "AK" Then
            Z_SHIPX_FigureTransitDaysFirstClass = "2-3"
        ElseIf subVarStateAbbreviation = "AA" Or subVarStateAbbreviation = "AE" Or subVarStateAbbreviation = "AP" Then
            Z_SHIPX_FigureTransitDaysFirstClass = "2-3"
        ElseIf subVarFirstClassZone = 2 Then
            Z_SHIPX_FigureTransitDaysFirstClass = "1-3"
        ElseIf subVarFirstClassZone = 3 Then
            Z_SHIPX_FigureTransitDaysFirstClass = "1-2"
        ElseIf subVarFirstClassZone = 4 Then
            Z_SHIPX_FigureTransitDaysFirstClass = "2-3"
        ElseIf subVarFirstClassZone = 5 Then
            Z_SHIPX_FigureTransitDaysFirstClass = "2-3"
        ElseIf subVarFirstClassZone = 6 Then
            Z_SHIPX_FigureTransitDaysFirstClass = "2-3"
        ElseIf subVarFirstClassZone = 7 Then
            Z_SHIPX_FigureTransitDaysFirstClass = "2-3"
        ElseIf subVarFirstClassZone = 8 Then
            Z_SHIPX_FigureTransitDaysFirstClass = "2-3"
        Else
            Z_SHIPX_FigureTransitDaysFirstClass = "2-3"
        End If
    End Function
    Public Function Z_SHIPX_FigureTransitDaysGlobalExpress() As String
        Z_SHIPX_FigureTransitDaysGlobalExpress = "3-5"
    End Function
    Public Function Z_SHIPX_FigureTransitDaysMediaMail(subVarPriorityMailZone As String, subVarState As String) As String
        Z_SHIPX_FigureTransitDaysMediaMail = ""
        If Len(subVarState) = 0 Then
            Z_SHIPX_FigureTransitDaysMediaMail = ""
            Exit Function
        End If
        If Len(subVarPriorityMailZone) = 0 Then
            Z_SHIPX_FigureTransitDaysMediaMail = ""
            Exit Function
        End If
        If subVarPriorityMailZone = 1 Then
            Z_SHIPX_FigureTransitDaysMediaMail = "4-8"
        ElseIf subVarPriorityMailZone = 2 Then
            Z_SHIPX_FigureTransitDaysMediaMail = "4-8"
        ElseIf subVarPriorityMailZone = 3 Then
            Z_SHIPX_FigureTransitDaysMediaMail = "4-8"
        ElseIf subVarPriorityMailZone = 4 Then
            Z_SHIPX_FigureTransitDaysMediaMail = "4-8"
        ElseIf subVarPriorityMailZone = 5 Then
            Z_SHIPX_FigureTransitDaysMediaMail = "4-8"
        ElseIf subVarPriorityMailZone = 6 Then
            Z_SHIPX_FigureTransitDaysMediaMail = "4-8"
        ElseIf subVarPriorityMailZone = 7 Then
            Z_SHIPX_FigureTransitDaysMediaMail = "4-8"
        ElseIf subVarPriorityMailZone = 8 Then
            Z_SHIPX_FigureTransitDaysMediaMail = "4-8"
        End If
    End Function
    Public Function Z_SHIPX_FigureTransitDaysParcelPost(subVarPriorityMailZone As String, subVarState As String) As String
        Z_SHIPX_FigureTransitDaysParcelPost = ""
        If Len(subVarState) = 0 Then
            Z_SHIPX_FigureTransitDaysParcelPost = ""
            Exit Function
        End If
        If Len(subVarPriorityMailZone) = 0 Then
            Z_SHIPX_FigureTransitDaysParcelPost = ""
            Exit Function
        End If
        If subVarPriorityMailZone = 1 Then
            Z_SHIPX_FigureTransitDaysParcelPost = "2-3"
        ElseIf subVarPriorityMailZone = 2 Then
            Z_SHIPX_FigureTransitDaysParcelPost = "2-3"
        ElseIf subVarPriorityMailZone = 3 Then
            Z_SHIPX_FigureTransitDaysParcelPost = "3-4"
        ElseIf subVarPriorityMailZone = 4 Then
            Z_SHIPX_FigureTransitDaysParcelPost = "3-4"
        ElseIf subVarPriorityMailZone = 5 Then
            Z_SHIPX_FigureTransitDaysParcelPost = "4-7"
        ElseIf subVarPriorityMailZone = 6 Then
            Z_SHIPX_FigureTransitDaysParcelPost = "5-7"
        ElseIf subVarPriorityMailZone = 7 Then
            Z_SHIPX_FigureTransitDaysParcelPost = "6-7"
        ElseIf subVarPriorityMailZone = 8 Then
            Z_SHIPX_FigureTransitDaysParcelPost = "6-8"
        End If
    End Function
    Public Function Z_SHIPX_FigureTransitDaysPriorityMail(subVarPriorityMailZone As String, subVarState As String, strConnectionStringName As String) As String
        Z_SHIPX_FigureTransitDaysPriorityMail = ""
        If Len(subVarState) = 0 Then
            Z_SHIPX_FigureTransitDaysPriorityMail = ""
            Exit Function
        End If
        If Len(subVarPriorityMailZone) = 0 Then
            Z_SHIPX_FigureTransitDaysPriorityMail = ""
            Exit Function
        End If

        Dim subVarStateAbbreviation As String = ""
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
            SqlConnection.ClearPool(conn)
            conn.Open()
            Dim CMD_Z As New SqlCommand("spGetWebCountryStateProvincesListRow", conn)
            CMD_Z.CommandType = Data.CommandType.StoredProcedure
            CMD_Z.Parameters.AddWithValue("@Country", "USA")
            CMD_Z.Parameters.AddWithValue("@StateProvince", subVarState)
            Dim readerZ As SqlDataReader
            readerZ = CMD_Z.ExecuteReader
            If readerZ.HasRows Then
                readerZ.Read()
                subVarStateAbbreviation = readerZ("StateProvinceAbbreviation")
            Else
                Z_SHIPX_FigureTransitDaysPriorityMail = "2-3"
                Exit Function
            End If
        End Using

        If subVarStateAbbreviation = "HI" Or subVarStateAbbreviation = "AK" Then
            Z_SHIPX_FigureTransitDaysPriorityMail = "2-4"
        ElseIf subVarStateAbbreviation = "AA" Or subVarStateAbbreviation = "AE" Or subVarStateAbbreviation = "AP" Or subVarStateAbbreviation = "GU" Or subVarStateAbbreviation = "PR" Or subVarStateAbbreviation = "VI" Then
            Z_SHIPX_FigureTransitDaysPriorityMail = "3-6"
        ElseIf subVarPriorityMailZone <= 5 Then
            Z_SHIPX_FigureTransitDaysPriorityMail = "1-3"
        ElseIf subVarPriorityMailZone >= 6 Then
            Z_SHIPX_FigureTransitDaysPriorityMail = "2-3"
        Else
            Z_SHIPX_FigureTransitDaysPriorityMail = "2-3"
        End If
    End Function
    Public Function Z_SHIPX_FigureTransitDaysUPSGround(subVarCountry As String, subVarZipCode As String, strConnectionStringName As String) As String
        If Len(subVarZipCode) < 5 Then
            Z_SHIPX_FigureTransitDaysUPSGround = "NA"
            Exit Function
        End If

        If subVarCountry <> "USA" Then
            Z_SHIPX_FigureTransitDaysUPSGround = "NA"
            Exit Function
        End If
        Dim subVarZip5 As String = Left(subVarZipCode, 5)

        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
            SqlConnection.ClearPool(conn)
            conn.Open()
            Dim CMD_X As New SqlCommand("[spGetWebSHIPX_UPSTimeInTransitRow]", conn)
            CMD_X.CommandType = Data.CommandType.StoredProcedure
            CMD_X.Parameters.AddWithValue("@ZipCode", subVarZip5)
            Dim readerX As SqlDataReader
            readerX = CMD_X.ExecuteReader
            If readerX.HasRows Then
                readerX.Read()
                Z_SHIPX_FigureTransitDaysUPSGround = readerX("Days")
            Else
                Z_SHIPX_FigureTransitDaysUPSGround = "NA"
                Exit Function
            End If
        End Using

    End Function
    Public Function Z_SHIPX_FigureTransitDaysUPSGroundCanada(subVarCountry As String, subVarZipCode As String, strConnectionStringName As String) As String
        Z_SHIPX_FigureTransitDaysUPSGroundCanada = "NA"

        If Len(subVarZipCode) < 6 Then
            Exit Function
        End If

        If subVarCountry <> "Canada" Then
            Exit Function
        End If
        Dim subVarZip7 As String = Left(subVarZipCode, 3) & Right(subVarZipCode, 3)

        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
            SqlConnection.ClearPool(conn)
            conn.Open()
            Dim CMD_X As New SqlCommand("[spGetWebSHIPX_UPSGroundCanadaTimeInTransitRow]", conn)
            CMD_X.CommandType = Data.CommandType.StoredProcedure
            CMD_X.Parameters.AddWithValue("@PostalCode", subVarZip7)
            Dim readerX As SqlDataReader
            readerX = CMD_X.ExecuteReader
            If readerX.HasRows Then
                readerX.Read()
                Z_SHIPX_FigureTransitDaysUPSGroundCanada = readerX("Days")
                Exit Function
            End If
        End Using

        'Check left 3
        Dim strSQL As String = ""
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
            strSQL = "select * from WebSHIPX_UPSGroundCanadaTimeInTransit" _
             & " where left(PostalCode,3)='" & Left(subVarZip7, 3) & "'" _
             & " order by Days"
            SqlConnection.ClearPool(conn)
            conn.Open()
            Dim CMD_X3 As New SqlCommand(strSQL, conn)
            CMD_X3.CommandType = Data.CommandType.Text
            Dim readerX3 As SqlDataReader
            readerX3 = CMD_X3.ExecuteReader
            If readerX3.HasRows Then
                readerX3.Read()
                Z_SHIPX_FigureTransitDaysUPSGroundCanada = readerX3("Days")
                Exit Function
            End If
        End Using

        'Check left 1
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
            strSQL = "select * from WebSHIPX_UPSGroundCanadaTimeInTransit" _
             & " where left(PostalCode,1)='" & Left(subVarZip7, 1) & "'" _
             & " order by Days"
            SqlConnection.ClearPool(conn)
            conn.Open()
            Dim CMD_X1 As New SqlCommand(strSQL, conn)
            CMD_X1.CommandType = Data.CommandType.Text
            Dim readerX1 As SqlDataReader
            readerX1 = CMD_X1.ExecuteReader
            If readerX1.HasRows Then
                readerX1.Read()
                Z_SHIPX_FigureTransitDaysUPSGroundCanada = readerX1("Days")
                Exit Function
            End If
        End Using
    End Function
    Public Function Z_SHIPX_FigureUPSGroundCanadaZone(subVarCountry As String, subVarPostalCode As String, strConnectionStringName As String) As String
        Z_SHIPX_FigureUPSGroundCanadaZone = "NA"
        Exit Function
        If subVarCountry <> "Canada" Then
            Exit Function
        End If
        If Len(subVarPostalCode) < 6 Then
            Exit Function
        End If

        Dim subVarPostalCode3 As String = Left(subVarPostalCode, 3)

        Dim strSQL As String = ""
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
            strSQL = "select * from WebSHIPX_UPSGroundCanadaZones" _
             & " where PostalCodeFrom <='" & subVarPostalCode3 & "' and PostalCodeTo >='" & subVarPostalCode3 & "'"
            SqlConnection.ClearPool(conn)
            conn.Open()
            Dim CMD_X3 As New SqlCommand(strSQL, conn)
            CMD_X3.CommandType = Data.CommandType.Text
            Dim readerX3 As SqlDataReader
            readerX3 = CMD_X3.ExecuteReader
            If readerX3.HasRows Then
                readerX3.Read()
                Z_SHIPX_FigureUPSGroundCanadaZone = readerX3("zone")
            End If
        End Using

    End Function
    Public Function Z_SHIPX_FigureTransitDaysFedExPriorityOvernight(subVarCountry As String, subVarState As String, subVarPostalCode As String) As String
        If Len(subVarPostalCode) < 5 Then
            Z_SHIPX_FigureTransitDaysFedExPriorityOvernight = "NA"
            Exit Function
        End If
        If Len(subVarState) = 0 Then
            Z_SHIPX_FigureTransitDaysFedExPriorityOvernight = "NA"
            Exit Function
        End If

        Z_SHIPX_FigureTransitDaysFedExPriorityOvernight = "1"
        If subVarCountry = "USA" Then
            subVarPostalCode = Left(subVarPostalCode, 5)
        End If
        If subVarCountry <> "USA" Then Exit Function
        If subVarState = "Alaska" Then
            Z_SHIPX_FigureTransitDaysFedExPriorityOvernight = "2"
        End If
        If subVarState = "Hawaii" Then
            Z_SHIPX_FigureTransitDaysFedExPriorityOvernight = "1"
            If subVarPostalCode = 96713 Or subVarPostalCode = 96727 Or subVarPostalCode = 96747 Or subVarPostalCode = 96752 Or subVarPostalCode = 96769 Or subVarPostalCode = 96772 Then
                Z_SHIPX_FigureTransitDaysFedExPriorityOvernight = "2"
            End If
            If subVarPostalCode = 96774 Or subVarPostalCode = 96776 Or subVarPostalCode = 96777 Or subVarPostalCode = 96778 Or subVarPostalCode = 96780 Or subVarPostalCode = 96796 Then
                Z_SHIPX_FigureTransitDaysFedExPriorityOvernight = "2"
            End If
            If subVarPostalCode = 96742 Then
                Z_SHIPX_FigureTransitDaysFedExPriorityOvernight = "3"
            End If
        End If

    End Function

    Public Function Z_SHIPX_FigureTransitDaysFedEx2Day(subVarCountry As String, subVarZipCode As String) As String
        If Len(subVarZipCode) < 5 Then
            Z_SHIPX_FigureTransitDaysFedEx2Day = "NA"
            Exit Function
        End If
        Z_SHIPX_FigureTransitDaysFedEx2Day = "2"
        If subVarCountry <> "USA" Then
            Z_SHIPX_FigureTransitDaysFedEx2Day = "NA"
            Exit Function
        End If
        subVarZipCode = Left(subVarZipCode, 5)
        If Not IsNumeric(subVarZipCode) Then
            Z_SHIPX_FigureTransitDaysFedEx2Day = "NA"
            Exit Function
        End If
        'Hawaii other than Oahu
        If subVarZipCode >= 96701 And subVarZipCode <= 96705 Then
            Z_SHIPX_FigureTransitDaysFedEx2Day = "2"
        ElseIf subVarZipCode = 96708 Then
            Z_SHIPX_FigureTransitDaysFedEx2Day = "3"
        ElseIf subVarZipCode = 96710 Then
            Z_SHIPX_FigureTransitDaysFedEx2Day = "3"
        ElseIf subVarZipCode >= 96713 And subVarZipCode <= 96716 Then
            Z_SHIPX_FigureTransitDaysFedEx2Day = "3"
        ElseIf subVarZipCode >= 96718 And subVarZipCode <= 96729 Then
            Z_SHIPX_FigureTransitDaysFedEx2Day = "3"
        ElseIf subVarZipCode >= 96732 And subVarZipCode <= 96733 Then
            Z_SHIPX_FigureTransitDaysFedEx2Day = "3"
        ElseIf subVarZipCode = 96742 Then
            Z_SHIPX_FigureTransitDaysFedEx2Day = "4"
        ElseIf subVarZipCode >= 96737 And subVarZipCode <= 96743 Then
            Z_SHIPX_FigureTransitDaysFedEx2Day = "3"
        ElseIf subVarZipCode >= 96745 And subVarZipCode <= 96757 Then
            Z_SHIPX_FigureTransitDaysFedEx2Day = "3"
        ElseIf subVarZipCode >= 96760 And subVarZipCode <= 96761 Then
            Z_SHIPX_FigureTransitDaysFedEx2Day = "3"
        ElseIf subVarZipCode >= 96763 And subVarZipCode <= 96781 Then
            Z_SHIPX_FigureTransitDaysFedEx2Day = "3"
        ElseIf subVarZipCode >= 96783 And subVarZipCode <= 96785 Then
            Z_SHIPX_FigureTransitDaysFedEx2Day = "3"
        ElseIf subVarZipCode = 96788 Then
            Z_SHIPX_FigureTransitDaysFedEx2Day = "3"
        ElseIf subVarZipCode = 96790 Then
            Z_SHIPX_FigureTransitDaysFedEx2Day = "3"
        ElseIf subVarZipCode = 96793 Then
            Z_SHIPX_FigureTransitDaysFedEx2Day = "3"
        ElseIf subVarZipCode = 96796 Then
            Z_SHIPX_FigureTransitDaysFedEx2Day = "3"
        End If
        'Alaska
        If subVarZipCode >= 99500 And subVarZipCode <= 99999 Then
            Z_SHIPX_FigureTransitDaysFedEx2Day = "3"
        End If
    End Function
    Public Function GetCartDetails(ByVal intCustomerServerCounter As Integer, strConnectionStringName As String, NameOfCart As String)
        'Variables
        Dim xx As SqlDataReader
        Dim intCartQty As Integer = 0
        Dim dblCartTotal As Double = 0
        Dim varLowestShippingCost As Double = 0
        Dim dblWeightInGrams As Double = 0
        Dim dblWeightInPounds As Double = 0
        Dim intWeightOfEachBox As Integer = 0
        Dim defaultPostalCode As String = ""
        Dim defaultStateProvince As String = ""
        Dim varZip3 As String = ""
        Dim defaultCountry As String = ""
        Dim varShippingCharge As Decimal = 0
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
        Dim varLastRateChecked As Decimal = 0
        Dim varResidentialDelivery As String = "YES"
        Dim varNumberOfBoxes As Integer = 0
        Dim varWeightOfEachBox As Decimal = 0
        Dim varPriceGroup As String = "StorePrice"

        'Get Cart Totals
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
                If Not IsDBNull(readerY("sumquantity")) Then
                    intCartQty = readerY("sumquantity")
                End If
                If Not IsDBNull(readerY("sumprice")) Then
                    dblCartTotal = readerY("sumprice")
                End If
                If Not IsDBNull(readerY("sumweight")) Then
                    dblWeightInGrams = readerY("sumweight")
                    dblWeightInPounds = dblWeightInGrams / 454
                End If
            End If
        End Using
        If intCartQty > 0 Then
            'Packaging Weight
            Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
                SqlConnection.ClearPool(conn)
                conn.Open()
                Dim CMD_X As New SqlCommand("spGetWebSHIPX_PackagingWeight", conn)
                CMD_X.CommandType = Data.CommandType.StoredProcedure
                CMD_X.Parameters.AddWithValue("@WeightInGrams", dblWeightInGrams)
                CMD_X.Parameters.AddWithValue("@CartName", NameOfCart)
                xx = CMD_X.ExecuteReader
                xx.Read()
                dblWeightInGrams = dblWeightInGrams + xx("PackagingWeight")
                dblWeightInPounds = dblWeightInPounds + CDbl(xx("PackagingWeight")) / 454
            End Using
            'Zip3 and Country
            Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
                SqlConnection.ClearPool(conn)
                conn.Open()
                Dim CMD_X As New SqlCommand("spGetCustomerDetailsByServerCounter", conn)
                CMD_X.CommandType = Data.CommandType.StoredProcedure
                CMD_X.Parameters.AddWithValue("@counter", intCustomerServerCounter)
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
            Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
                SqlConnection.ClearPool(conn)
                conn.Open()
                Dim CMD_X As New SqlCommand("spResidentialDelivery", conn)
                CMD_X.CommandType = Data.CommandType.StoredProcedure
                CMD_X.Parameters.AddWithValue("@counter", intCustomerServerCounter)
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

            'Zones
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
                varLastRateChecked = Z_SHIPX_FigureShippingCost("FC", NameOfCart, defaultPostalCode, dblCartTotal, varPriorityMailZone, defaultStateProvince, defaultCountry, dblWeightInPounds, 1, dblWeightInPounds, "No", varResidentialDelivery, varPriceGroup, strConnectionStringName)
                If varLastRateChecked <> -1 Then
                    If varShippingCharge = 0 Or varLastRateChecked < varShippingCharge Then
                        varShippingCharge = varLastRateChecked
                    End If
                End If
            End If
            'Media Mail
            If Not varMediaMailZone = "NA" Then
                varNumberOfBoxes = Z_SHIPX_FigureNumberOfBoxes(defaultCountry, NameOfCart, "MM", dblWeightInPounds, strConnectionStringName)
                varWeightOfEachBox = Int((dblWeightInPounds / varNumberOfBoxes) + 0.9999)
                If varWeightOfEachBox < 1 Then varWeightOfEachBox = 1
                varLastRateChecked = Z_SHIPX_FigureShippingCost("MM", NameOfCart, defaultPostalCode, dblCartTotal, varMediaMailZone, defaultStateProvince, defaultCountry, varWeightOfEachBox, varNumberOfBoxes, dblWeightInPounds, "No", varResidentialDelivery, varPriceGroup, strConnectionStringName)
                If varLastRateChecked <> -1 Then
                    If varShippingCharge = 0 Or varLastRateChecked < varShippingCharge Then
                        varShippingCharge = varLastRateChecked
                    End If
                End If
            End If
            'Media Mail
            If Not varMediaMailZone = "NA" Then
                varNumberOfBoxes = Z_SHIPX_FigureNumberOfBoxes(defaultCountry, NameOfCart, "MM", dblWeightInPounds, strConnectionStringName)
                varWeightOfEachBox = Int((dblWeightInPounds / varNumberOfBoxes) + 0.9999)
                If varWeightOfEachBox < 1 Then varWeightOfEachBox = 1
                varLastRateChecked = Z_SHIPX_FigureShippingCost("MM", NameOfCart, defaultPostalCode, dblCartTotal, varMediaMailZone, defaultStateProvince, defaultCountry, varWeightOfEachBox, varNumberOfBoxes, dblWeightInPounds, "No", varResidentialDelivery, varPriceGroup, strConnectionStringName)
                If varLastRateChecked <> -1 Then
                    If varShippingCharge = 0 Or varLastRateChecked < varShippingCharge Then
                        varShippingCharge = varLastRateChecked
                    End If
                End If
            End If
            'priority Mail
            If Not varPriorityMailZone = "NA" Then
                varNumberOfBoxes = Z_SHIPX_FigureNumberOfBoxes(defaultCountry, NameOfCart, "PM", dblWeightInPounds, strConnectionStringName)
                varWeightOfEachBox = Int((dblWeightInPounds / varNumberOfBoxes) + 0.9999)
                If varWeightOfEachBox < 1 Then varWeightOfEachBox = 1
                varLastRateChecked = Z_SHIPX_FigureShippingCost("PM", NameOfCart, defaultPostalCode, dblCartTotal, varPriorityMailZone, defaultStateProvince, defaultCountry, varWeightOfEachBox, varNumberOfBoxes, dblWeightInPounds, "No", varResidentialDelivery, varPriceGroup, strConnectionStringName)
                If varLastRateChecked <> -1 Then
                    If varShippingCharge = 0 Or varLastRateChecked < varShippingCharge Then
                        varShippingCharge = varLastRateChecked
                    End If
                End If
            End If
            'Express Mail to Address
            If Not varExpressMailZone = "NA" Then
                varNumberOfBoxes = Z_SHIPX_FigureNumberOfBoxes(defaultCountry, NameOfCart, "EMA", dblWeightInPounds, strConnectionStringName)
                varWeightOfEachBox = Int((dblWeightInPounds / varNumberOfBoxes) + 0.9999)
                If varWeightOfEachBox < 1 Then varWeightOfEachBox = 1
                varLastRateChecked = Z_SHIPX_FigureShippingCost("EMA", NameOfCart, defaultPostalCode, dblCartTotal, varExpressMailZone, defaultStateProvince, defaultCountry, varWeightOfEachBox, varNumberOfBoxes, dblWeightInPounds, "No", varResidentialDelivery, varPriceGroup, strConnectionStringName)
                If varLastRateChecked <> -1 Then
                    If varShippingCharge = 0 Or varLastRateChecked < varShippingCharge Then
                        varShippingCharge = varLastRateChecked
                    End If
                End If
            End If
            'First Class Mail International
            If Not varAirMailLetterPostZone = "NA" And dblWeightInPounds <= 3 Then
                varNumberOfBoxes = Z_SHIPX_FigureNumberOfBoxes(defaultCountry, NameOfCart, "ALP", dblWeightInPounds, strConnectionStringName)
                varWeightOfEachBox = Int((dblWeightInPounds / varNumberOfBoxes) + 0.9999)
                varLastRateChecked = Z_SHIPX_FigureShippingCost("ALP", NameOfCart, defaultPostalCode, dblCartTotal, varAirMailLetterPostZone, defaultStateProvince, defaultCountry, dblWeightInPounds, varNumberOfBoxes, dblWeightInPounds, "No", varResidentialDelivery, varPriceGroup, strConnectionStringName)
                If varLastRateChecked <> -1 Then
                    If varShippingCharge = 0 Or varLastRateChecked < varShippingCharge Then
                        varShippingCharge = varLastRateChecked
                    End If
                End If
            End If
            'Priority Mail International
            If Not varAirParcelPostZone = "NA" And dblWeightInPounds > 3 Then
                varNumberOfBoxes = Z_SHIPX_FigureNumberOfBoxes(defaultCountry, NameOfCart, "APP", dblWeightInPounds, strConnectionStringName)
                varWeightOfEachBox = Int((dblWeightInPounds / varNumberOfBoxes) + 0.9999)
                If varWeightOfEachBox < 1 Then varWeightOfEachBox = 1
                varLastRateChecked = Z_SHIPX_FigureShippingCost("APP", NameOfCart, defaultPostalCode, dblCartTotal, varAirParcelPostZone, defaultStateProvince, defaultCountry, varWeightOfEachBox, varNumberOfBoxes, dblWeightInPounds, "No", varResidentialDelivery, varPriceGroup, strConnectionStringName)
                If varLastRateChecked <> -1 Then
                    If varShippingCharge = 0 Or varLastRateChecked < varShippingCharge Then
                        varShippingCharge = varLastRateChecked
                    End If
                End If
            End If
            'Express Mail International
            If Not varGlobalExpressZone = "NA" Then
                varNumberOfBoxes = Z_SHIPX_FigureNumberOfBoxes(defaultCountry, NameOfCart, "GE", dblWeightInPounds, strConnectionStringName)
                varWeightOfEachBox = Int((dblWeightInPounds / varNumberOfBoxes) + 0.9999)
                If varWeightOfEachBox < 1 Then varWeightOfEachBox = 1
                varLastRateChecked = Z_SHIPX_FigureShippingCost("GE", NameOfCart, defaultPostalCode, dblCartTotal, varGlobalExpressZone, defaultStateProvince, defaultCountry, varWeightOfEachBox, varNumberOfBoxes, dblWeightInPounds, "No", varResidentialDelivery, varPriceGroup, strConnectionStringName)
                If varLastRateChecked <> -1 Then
                    If varShippingCharge = 0 Or varLastRateChecked < varShippingCharge Then
                        varShippingCharge = varLastRateChecked
                    End If
                End If
            End If
            'UPS Ground
            If Not varUPSGroundZone = "NA" Then
                varNumberOfBoxes = Z_SHIPX_FigureNumberOfBoxes(defaultCountry, NameOfCart, "UPSGR", dblWeightInPounds, strConnectionStringName)
                varWeightOfEachBox = Int((dblWeightInPounds / varNumberOfBoxes) + 0.9999)
                If varWeightOfEachBox < 1 Then varWeightOfEachBox = 1
                varLastRateChecked = Z_SHIPX_FigureShippingCost("UPSGR", NameOfCart, defaultPostalCode, dblCartTotal, varUPSGroundZone, defaultStateProvince, defaultCountry, varWeightOfEachBox, varNumberOfBoxes, dblWeightInPounds, "No", varResidentialDelivery, varPriceGroup, strConnectionStringName)
                If varLastRateChecked <> -1 Then
                    If varShippingCharge = 0 Or varLastRateChecked < varShippingCharge Then
                        varShippingCharge = varLastRateChecked
                    End If
                End If
            End If
            'DHL International Economy
            If Not varDHLInternationalZone = "NA" Then
                varNumberOfBoxes = 1
                varWeightOfEachBox = Int((dblWeightInPounds / varNumberOfBoxes) + 0.9999)
                If varWeightOfEachBox < 1 Then varWeightOfEachBox = 1
                varLastRateChecked = Z_SHIPX_FigureShippingCost("DHLIE", NameOfCart, defaultPostalCode, dblCartTotal, varDHLInternationalZone, defaultStateProvince, defaultCountry, varWeightOfEachBox, varNumberOfBoxes, dblWeightInPounds, "No", varResidentialDelivery, varPriceGroup, strConnectionStringName)
                If varLastRateChecked <> -1 Then
                    If varShippingCharge = 0 Or varLastRateChecked < varShippingCharge Then
                        varShippingCharge = varLastRateChecked
                    End If
                End If
            End If
            'FedEx Ground
            If Not varFedExGroundZone = "NA" Then
                varNumberOfBoxes = Z_SHIPX_FigureNumberOfBoxes(defaultCountry, NameOfCart, "FEGR", dblWeightInPounds, strConnectionStringName)
                varWeightOfEachBox = Int((dblWeightInPounds / varNumberOfBoxes) + 0.9999)
                If varWeightOfEachBox < 1 Then varWeightOfEachBox = 1
                varLastRateChecked = Z_SHIPX_FigureShippingCost("FEGR", NameOfCart, defaultPostalCode, dblCartTotal, varFedExGroundZone, defaultStateProvince, defaultCountry, varWeightOfEachBox, varNumberOfBoxes, dblWeightInPounds, "No", varResidentialDelivery, varPriceGroup, strConnectionStringName)
                If varLastRateChecked <> -1 Then
                    If varShippingCharge = 0 Or varLastRateChecked < varShippingCharge Then
                        varShippingCharge = varLastRateChecked
                    End If
                End If
            End If
            'FedEx 2 Day
            If Not varFedExExpressZone = "NA" Then
                varNumberOfBoxes = Z_SHIPX_FigureNumberOfBoxes(defaultCountry, NameOfCart, "FE2D", dblWeightInPounds, strConnectionStringName)
                varWeightOfEachBox = Int((dblWeightInPounds / varNumberOfBoxes) + 0.9999)
                If varWeightOfEachBox < 1 Then varWeightOfEachBox = 1
                varLastRateChecked = Z_SHIPX_FigureShippingCost("FE2D", NameOfCart, defaultPostalCode, dblCartTotal, varFedExExpressZone, defaultStateProvince, defaultCountry, varWeightOfEachBox, varNumberOfBoxes, dblWeightInPounds, "No", varResidentialDelivery, varPriceGroup, strConnectionStringName)
                If varLastRateChecked <> -1 Then
                    If varShippingCharge = 0 Or varLastRateChecked < varShippingCharge Then
                        varShippingCharge = varLastRateChecked
                    End If
                End If
            End If
            'FedEx International Economy
            If Not varFedExInternationalEconomyZone = "NA" Then
                varNumberOfBoxes = Z_SHIPX_FigureNumberOfBoxes(defaultCountry, NameOfCart, "FEINTE", dblWeightInPounds, strConnectionStringName)
                varWeightOfEachBox = Int((dblWeightInPounds / varNumberOfBoxes) + 0.9999)
                If varWeightOfEachBox < 1 Then varWeightOfEachBox = 1
                varLastRateChecked = Z_SHIPX_FigureShippingCost("FEINTE", NameOfCart, defaultPostalCode, dblCartTotal, varFedExInternationalEconomyZone, defaultStateProvince, defaultCountry, varWeightOfEachBox, varNumberOfBoxes, dblWeightInPounds, "No", varResidentialDelivery, varPriceGroup, strConnectionStringName)
                If varLastRateChecked <> -1 Then
                    If varShippingCharge = 0 Or varLastRateChecked < varShippingCharge Then
                        varShippingCharge = varLastRateChecked
                    End If
                End If
            End If
            'FedEx International Priority
            If Not varFedExInternationalPriorityZone = "NA" Then
                varNumberOfBoxes = Z_SHIPX_FigureNumberOfBoxes(defaultCountry, NameOfCart, "FEINTP", dblWeightInPounds, strConnectionStringName)
                varWeightOfEachBox = Int((dblWeightInPounds / varNumberOfBoxes) + 0.9999)
                If varWeightOfEachBox < 1 Then varWeightOfEachBox = 1
                varLastRateChecked = Z_SHIPX_FigureShippingCost("FEINTP", NameOfCart, defaultPostalCode, dblCartTotal, varFedExInternationalPriorityZone, defaultStateProvince, defaultCountry, varWeightOfEachBox, varNumberOfBoxes, dblWeightInPounds, "No", varResidentialDelivery, varPriceGroup, strConnectionStringName)
                If varLastRateChecked <> -1 Then
                    If varShippingCharge = 0 Or varLastRateChecked < varShippingCharge Then
                        varShippingCharge = varLastRateChecked
                    End If
                End If
            End If
        Else
            varShippingCharge = 0
        End If
        GetCartDetails = "QU" & intCartQty & "PR" & formatnumber(dblCartTotal, 2) & "SH" & formatnumber(varShippingCharge, 2) & "TO" & formatnumber(dblCartTotal + varShippingCharge, 2) & "END"

    End Function



    Public Function Z_SHIPX_FigureShippingCost(subVarShippingMethod As String, subVarCartName As String, subVarPostalCode As String, subVarCostOfGoods As Double, subVarZone As String, subVarStateProvince As String, subVarCountry As String, subVarWeightOfEachBox As Double, subVarNumberOfBoxes As Integer, subVarWeightOfShipment As Double, subVarCOD As String, subVarResidentialDelivery As String, subVarPriceGroup As String, ByVal strConnectionStringName As String) As Decimal
        Z_SHIPX_FigureShippingCost = -1
        If Len(subVarZone) = 0 Then
            Exit Function
        End If
        If Len(subVarCountry) = 0 Then
            Exit Function
        End If
        If subVarPriceGroup = "" Then subVarPriceGroup = "RetailPrice"
        Dim subVarShippingViaCompany As String = ""
        Dim subVarShippingCostTableName As String = ""
        Dim subVarCODOK As String = ""
        Dim subVarDomestic As String = ""
        Dim subVarInternational As String = ""
        Dim subVarHawaii As String = ""
        Dim subVarAlaska As String = ""
        Dim subVarUSPossessions As String = ""
        Dim subVarMilitaryAddressOK As String = ""
        Dim subVarMinimumWeightOfShipment As String = ""
        Dim subVarShipmentFlatRateWeight As Double = 0
        Dim subVarFuelSurcharge As Double = 0
        Dim subVarResidentialDeliveryCharge As Double = 0
        Dim subVarOurDutyCostPercent As Double = 0
        Dim subVarSaturdayDeliveryCharge As Double = 0
        Dim subVarLPor12InchSurcharge As Double = 0
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
            SqlConnection.ClearPool(conn)
            conn.Open()
            Dim CMD_X As New SqlCommand("spGetShippingMethodsRow", conn)
            CMD_X.CommandType = Data.CommandType.StoredProcedure
            CMD_X.Parameters.AddWithValue("@ShippingMethodCode", subVarShippingMethod)
            Dim readerX As SqlDataReader
            readerX = CMD_X.ExecuteReader
            If readerX.HasRows Then
                readerX.Read()
                subVarShippingViaCompany = readerX("ShippingViaCompany")
                subVarShippingCostTableName = readerX("ShippingCostTableName")
                subVarCODOK = readerX("CODOK")
                subVarDomestic = readerX("Domestic")
                subVarInternational = readerX("International")
                subVarHawaii = readerX("Hawaii")
                subVarAlaska = readerX("Alaska")
                subVarUSPossessions = readerX("USPossessions")
                subVarMilitaryAddressOK = readerX("MilitaryAddressOK")
                subVarMinimumWeightOfShipment = readerX("MinimumWeightOfShipment")
                subVarShipmentFlatRateWeight = readerX("ShipmentFlatRateWeight")
                subVarFuelSurcharge = readerX("FuelSurcharge")
                subVarResidentialDeliveryCharge = readerX("ResidentialDeliveryCharge")
                subVarOurDutyCostPercent = readerX("OurDutyCostPercent")
                subVarSaturdayDeliveryCharge = readerX("SaturdayDeliveryCharge")
                subVarLPor12InchSurcharge = readerX("LPor12InchSurcharge")
            End If
        End Using
        Dim subVarWebUSMailWholesaleAllowed As String = ""
        Dim subVarAirSmallPacketWeightLimit As String = ""
        Dim subVarEuropeanUnionCountry As String = ""
        Dim subVarDutyShippingCostPercent As String = ""
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
            SqlConnection.ClearPool(conn)
            conn.Open()
            Dim CMD_Y As New SqlCommand("spGetWebCountryShippingZonesTRow", conn)
            CMD_Y.CommandType = Data.CommandType.StoredProcedure
            CMD_Y.Parameters.AddWithValue("@Country", subVarCountry)
            Dim readerY As SqlDataReader
            readerY = CMD_Y.ExecuteReader
            If readerY.HasRows Then
                readerY.Read()
                subVarWebUSMailWholesaleAllowed = readerY("WebUSMailWholesaleAllowed")
                subVarAirSmallPacketWeightLimit = readerY("AirSmallPacketWeightLimit")
                subVarEuropeanUnionCountry = IsDBSomething(readerY("EuropeanUnionCountry"), "")
                subVarDutyShippingCostPercent = readerY("DutyShippingCostPercent")
            Else
                Exit Function
            End If
        End Using

        Dim subVarStateProvinceAbbreviation As String = ""
        If subVarCountry = "USA" Then
            Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
                SqlConnection.ClearPool(conn)
                conn.Open()
                Dim CMD_Z As New SqlCommand("spGetWebCountryStateProvincesListRow", conn)
                CMD_Z.CommandType = Data.CommandType.StoredProcedure
                CMD_Z.Parameters.AddWithValue("@Country", subVarCountry)
                CMD_Z.Parameters.AddWithValue("@StateProvince", subVarStateProvince)
                Dim readerZ As SqlDataReader
                readerZ = CMD_Z.ExecuteReader
                If readerZ.HasRows Then
                    readerZ.Read()
                    subVarStateProvinceAbbreviation = readerZ("StateProvinceAbbreviation")
                Else
                    Z_SHIPX_FigureShippingCost = -1
                End If
            End Using
        End If

        'Check Web Wholesale US Mail Not Allowed Country
        If subVarShippingMethod <> "ALP" And subVarShippingViaCompany = "US Mail" And subVarPriceGroup <> "RetailPrice" And UCase(subVarWebUSMailWholesaleAllowed) = "N" Then
            Z_SHIPX_FigureShippingCost = -1
            Exit Function
        End If
        'Check subVarZone parameter
        If subVarZone = "NA" Or subVarZone = "" Then
            Z_SHIPX_FigureShippingCost = -1
            Exit Function
        End If

        'DHL International Express -------------------------------------------------------------------------------------------
        If subVarShippingMethod = "DHLIE" Then
            Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
                SqlConnection.ClearPool(conn)
                conn.Open()
                Dim CMD_Z As New SqlCommand("spGetWebCountryShippingZonesTRow", conn)
                CMD_Z.CommandType = Data.CommandType.StoredProcedure
                CMD_Z.Parameters.AddWithValue("@Country", subVarCountry)
                Dim readerZ As SqlDataReader
                readerZ = CMD_Z.ExecuteReader
                If Not readerZ.hasrows Then
                    Z_SHIPX_FigureShippingCost = -1
                    Exit Function
                Else
                    readerZ.read
                    Z_SHIPX_FigureShippingCost = formatnumber(readerZ("DHLFlatRate"), 2)
                    Exit Function
                End If
            End Using
        End If

        'ALL OTHER SHIPPING METHODS ------------------------------------------------------------------------------------------

        'Check for Zone in Shipping Table
        Dim subVarZoneOK As Integer = 0
        Dim subN As Integer = 0
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
            SqlConnection.ClearPool(conn)
            conn.Open()
            Dim CMD_Z As New SqlCommand("spCheckForZoneInShippingTable", conn)
            CMD_Z.CommandType = Data.CommandType.StoredProcedure
            CMD_Z.Parameters.AddWithValue("@TableName", subVarShippingCostTableName)
            Dim readerZ As SqlDataReader
            readerZ = CMD_Z.ExecuteReader
            For subN = 0 To readerZ.FieldCount - 1
                If readerZ.GetName(subN) = "Zone" & subVarZone Then
                    subVarZoneOK = 1
                End If
            Next
        End Using
        If subVarZoneOK = 0 Then
            Z_SHIPX_FigureShippingCost = -1
            Exit Function
        End If
        'Check COD parameter
        If UCase(subVarCOD) = "YES" Then
            If UCase(subVarCODOK) = "N" Then
                Z_SHIPX_FigureShippingCost = -1
                Exit Function
            End If
        End If

        'Check Domestic parameter
        If subVarCountry = "USA" Then
            If UCase(subVarDomestic) = "N" Then
                Z_SHIPX_FigureShippingCost = -1
                Exit Function
            End If
        End If
        'Check International parameter
        If subVarCountry <> "USA" Then
            If UCase(subVarInternational) = "N" Then
                Z_SHIPX_FigureShippingCost = -1
                Exit Function
            End If
        End If
        'Check US Possession parameter
        If subVarCountry = "USA" Then
            If subVarStateProvinceAbbreviation = "PR" Or subVarStateProvinceAbbreviation = "VI" Or subVarStateProvinceAbbreviation = "GU" Then
                If UCase(subVarUSPossessions) = "N" Then
                    Z_SHIPX_FigureShippingCost = -1
                    Exit Function
                End If
            End If
        End If
        'Check Hawaii parameter
        If subVarCountry = "USA" Then
            If subVarStateProvinceAbbreviation = "HI" Then
                If UCase(subVarHawaii) = "N" Then
                    Z_SHIPX_FigureShippingCost = -1
                    Exit Function
                End If
            End If
        End If
        'Check Alaska parameter
        If subVarCountry = "USA" Then
            If subVarStateProvinceAbbreviation = "AK" Then
                If UCase(subVarAlaska) = "N" Then
                    Z_SHIPX_FigureShippingCost = -1
                    Exit Function
                End If
            End If
        End If
        'Check Military Address parameter
        If subVarCountry = "USA" Then
            If subVarStateProvinceAbbreviation = "AA" Or subVarStateProvinceAbbreviation = "AE" Or subVarStateProvinceAbbreviation = "AP" Then
                If UCase(subVarMilitaryAddressOK) = "N" Then
                    Z_SHIPX_FigureShippingCost = -1
                    Exit Function
                End If
            End If
        End If
        'Check Minimum Shipment Weight parameter
        If subVarWeightOfShipment < subVarMinimumWeightOfShipment Then
            Z_SHIPX_FigureShippingCost = -1
            Exit Function
        End If

        'Shipping Rate from Table
        Dim strSQL As String = ""
        If subVarShippingMethod = "FC" Or subVarShippingMethod = "ALP" Then
            strSQL = "select * from Web" & subVarShippingCostTableName _
            & " where weightinpounds>=" & subVarWeightOfEachBox _
            & " order by weightinpounds"
            Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
                SqlConnection.ClearPool(conn)
                conn.Open()
                Dim CMD_S2 As New SqlCommand(strSQL, conn)
                CMD_S2.CommandType = Data.CommandType.Text
                Dim readerS2 As SqlDataReader
                readerS2 = CMD_S2.ExecuteReader
                If readerS2.HasRows Then
                    readerS2.Read()
                    Z_SHIPX_FigureShippingCost = readerS2("zone" & subVarZone) * subVarNumberOfBoxes
                End If
            End Using
        Else
            strSQL = "select * from Web" & subVarShippingCostTableName _
             & " where weightinpounds=" & subVarWeightOfEachBox
            Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
                SqlConnection.ClearPool(conn)
                conn.Open()
                Dim CMD_S3 As New SqlCommand(strSQL, conn)
                CMD_S3.CommandType = Data.CommandType.Text
                Dim readerS3 As SqlDataReader
                readerS3 = CMD_S3.ExecuteReader
                If readerS3.HasRows Then
                    readerS3.Read()
                    Z_SHIPX_FigureShippingCost = readerS3("zone" & subVarZone) * subVarNumberOfBoxes
                    If subVarShippingMethod = "FEGR" Then
                        Z_SHIPX_FigureShippingCost = FormatNumber(Z_SHIPX_FigureShippingCost, 2)
                    ElseIf subVarShippingMethod = "FE2D" Or subVarShippingMethod = "FE2DSAT" Or subVarShippingMethod = "FEES" Or subVarShippingMethod = "FEPO" Or subVarShippingMethod = "FEPOSAT" Or subVarShippingMethod = "FESO" Then
                        Z_SHIPX_FigureShippingCost = FormatNumber(Z_SHIPX_FigureShippingCost, 2)
                    End If
                    'Fedex International Minimum Charge
                    'If subVarShippingMethod = "FEINTP" Then
                    ' If subVarZone = "A" Then
                    '  If CDbl(Z_SHIPX_FigureShippingCost) < CDbl(31.79) Then Z_SHIPX_FigureShippingCost = 31.79
                    ' ElseIf subVarZone = "B" Then
                    '  If CDbl(Z_SHIPX_FigureShippingCost) < CDbl(31.36) Then Z_SHIPX_FigureShippingCost = 31.36
                    ' ElseIf subVarZone = "C" Then
                    '  If CDbl(Z_SHIPX_FigureShippingCost) < CDbl(32.76) Then Z_SHIPX_FigureShippingCost = 32.76
                    ' ElseIf subVarZone = "D" Then
                    ' If CDbl(Z_SHIPX_FigureShippingCost) < CDbl(40.88) Then Z_SHIPX_FigureShippingCost = 40.88
                    ' ElseIf subVarZone = "E" Then
                    '  If CDbl(Z_SHIPX_FigureShippingCost) < CDbl(88.12) Then Z_SHIPX_FigureShippingCost = 88.12
                    ' ElseIf subVarZone = "F" Then
                    '  If CDbl(Z_SHIPX_FigureShippingCost) < CDbl(42.57) Then Z_SHIPX_FigureShippingCost = 42.57
                    ' ElseIf subVarZone = "G" Then
                    '  If CDbl(Z_SHIPX_FigureShippingCost) < CDbl(42.16) Then Z_SHIPX_FigureShippingCost = 42.16
                    ' ElseIf subVarZone = "H" Then
                    '  If CDbl(Z_SHIPX_FigureShippingCost) < CDbl(52.12) Then Z_SHIPX_FigureShippingCost = 52.12
                    ' ElseIf subVarZone = "I" Then
                    ' If CDbl(Z_SHIPX_FigureShippingCost) < CDbl(46.26) Then Z_SHIPX_FigureShippingCost = 46.26
                    ' ElseIf subVarZone = "J" Then
                    ' If CDbl(Z_SHIPX_FigureShippingCost) < CDbl(52.16) Then Z_SHIPX_FigureShippingCost = 52.16
                    ' ElseIf subVarZone = "K" Then
                    '  If CDbl(Z_SHIPX_FigureShippingCost) < CDbl(52.97) Then Z_SHIPX_FigureShippingCost = 52.97
                    ' ElseIf subVarZone = "L" Then
                    '  If CDbl(Z_SHIPX_FigureShippingCost) < CDbl(57.27) Then Z_SHIPX_FigureShippingCost = 57.27
                    ' ElseIf subVarZone = "M" Then
                    '  If CDbl(Z_SHIPX_FigureShippingCost) < CDbl(86.61) Then Z_SHIPX_FigureShippingCost = 86.61
                    ' ElseIf subVarZone = "N" Then
                    '  If CDbl(Z_SHIPX_FigureShippingCost) < CDbl(52.36) Then Z_SHIPX_FigureShippingCost = 52.36
                    ' ElseIf subVarZone = "O" Then
                    '  If CDbl(Z_SHIPX_FigureShippingCost) < CDbl(60.69) Then Z_SHIPX_FigureShippingCost = 60.69
                    '  End If
                    ' ElseIf subVarShippingMethod = "FEINTE" Then
                    '  If subVarZone = "A" Then
                    '  If CDbl(Z_SHIPX_FigureShippingCost) < CDbl(26.31) Then Z_SHIPX_FigureShippingCost = 26.31
                    '  ElseIf subVarZone = "B" Then
                    '   If CDbl(Z_SHIPX_FigureShippingCost) < CDbl(29.15) Then Z_SHIPX_FigureShippingCost = 29.15
                    ' ElseIf subVarZone = "C" Then
                    '  If CDbl(Z_SHIPX_FigureShippingCost) < CDbl(27.83) Then Z_SHIPX_FigureShippingCost = 27.83
                    '  ElseIf subVarZone = "D" Then
                    '  If CDbl(Z_SHIPX_FigureShippingCost) < CDbl(31.14) Then Z_SHIPX_FigureShippingCost = 31.14
                    ' ElseIf subVarZone = "E" Then
                    '  If CDbl(Z_SHIPX_FigureShippingCost) < CDbl(69.27) Then Z_SHIPX_FigureShippingCost = 69.27
                    '  ElseIf subVarZone = "F" Then
                    '   If CDbl(Z_SHIPX_FigureShippingCost) < CDbl(29.9) Then Z_SHIPX_FigureShippingCost = 29.9
                    ' ElseIf subVarZone = "G" Then
                    '  If CDbl(Z_SHIPX_FigureShippingCost) < CDbl(29.96) Then Z_SHIPX_FigureShippingCost = 29.96
                    ' ElseIf subVarZone = "H" Then
                    '  If CDbl(Z_SHIPX_FigureShippingCost) < CDbl(41.99) Then Z_SHIPX_FigureShippingCost = 41.99
                    ' ElseIf subVarZone = "I" Then
                    '  If CDbl(Z_SHIPX_FigureShippingCost) < CDbl(32.43) Then Z_SHIPX_FigureShippingCost = 32.43
                    ' ElseIf subVarZone = "J" Then
                    '  If CDbl(Z_SHIPX_FigureShippingCost) < CDbl(34.82) Then Z_SHIPX_FigureShippingCost = 34.82
                    '  ElseIf subVarZone = "K" Then
                    '   If CDbl(Z_SHIPX_FigureShippingCost) < CDbl(35.85) Then Z_SHIPX_FigureShippingCost = 35.85
                    '   ElseIf subVarZone = "L" Then
                    '   If CDbl(Z_SHIPX_FigureShippingCost) < CDbl(38.08) Then Z_SHIPX_FigureShippingCost = 38.08
                    '     ElseIf subVarZone = "M" Then
                    'If CDbl(Z_SHIPX_FigureShippingCost) < CDbl(70.26) Then Z_SHIPX_FigureShippingCost = 70.26
                    'ElseIf subVarZone = "N" Then
                    '  If CDbl(Z_SHIPX_FigureShippingCost) < CDbl(34.99) Then Z_SHIPX_FigureShippingCost = 34.99
                    ' ElseIf subVarZone = "O" Then
                    '  If CDbl(Z_SHIPX_FigureShippingCost) < CDbl(41.0) Then Z_SHIPX_FigureShippingCost = 41.0
                    ' End If
                    'End If
                End If
            End Using
        End If

        'Check for Alternate Flat Rate
        Dim subVarFlatRatePerPound As Double
        If subVarShipmentFlatRateWeight <= subVarWeightOfShipment Then
            strSQL = "select * from Web" & subVarShippingCostTableName _
             & " where weightinpounds=" & subVarShipmentFlatRateWeight
            Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
                SqlConnection.ClearPool(conn)
                conn.Open()
                Dim CMD_S4 As New SqlCommand(strSQL, conn)
                CMD_S4.CommandType = Data.CommandType.Text
                Dim readerS4 As SqlDataReader
                readerS4 = CMD_S4.ExecuteReader
                If readerS4.HasRows Then
                    readerS4.Read()
                    subVarFlatRatePerPound = readerS4("zone" & subVarZone) / subVarShipmentFlatRateWeight
                    Z_SHIPX_FigureShippingCost = subVarFlatRatePerPound * subVarWeightOfShipment
                End If
            End Using
        End If

        If Z_SHIPX_FigureShippingCost = -1 Then
            Exit Function
        End If
        'Fuel Surcharge
        Z_SHIPX_FigureShippingCost = Z_SHIPX_FigureShippingCost * (1 + subVarFuelSurcharge)
        'Residential Delivery Charge
        If UCase(subVarResidentialDelivery) = "YES" Then
            Z_SHIPX_FigureShippingCost = Z_SHIPX_FigureShippingCost + subVarResidentialDeliveryCharge
        End If
        'DutyCost by ShippingMethod
        Z_SHIPX_FigureShippingCost = Z_SHIPX_FigureShippingCost + (subVarCostOfGoods * subVarOurDutyCostPercent)
        'Duty cost for Japan Retail Fedex
        If subVarCountry = "Japan" And Left(subVarShippingMethod, 2) = "FE" And subVarPriceGroup = "RetailPrice" Then
            Z_SHIPX_FigureShippingCost = Z_SHIPX_FigureShippingCost + (subVarCostOfGoods * subVarDutyShippingCostPercent)
        End If
        'Saturday Delivery
        Z_SHIPX_FigureShippingCost = Z_SHIPX_FigureShippingCost + subVarSaturdayDeliveryCharge
        'Okinawa Parameter
        If subVarStateProvince = "Okinawa" And (subVarShippingMethod = "FEINTP" Or subVarShippingMethod = "FEINTE") Then
            Z_SHIPX_FigureShippingCost = Z_SHIPX_FigureShippingCost + 28
        End If

        'Our Surcharges-------------------------------------------------------------------------------------------------------

        'WebSHIPX_DefaultShippingCharges Surcharge Table
        strSQL = "select * from WebSHIPX_DefaultShippingCharges" & subVarPriceGroup _
         & " where ShippingMethod ='" & subVarShippingMethod & "'"
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
            SqlConnection.ClearPool(conn)
            conn.Open()
            Dim CMD_S5 As New SqlCommand(strSQL, conn)
            CMD_S5.CommandType = Data.CommandType.Text
            Dim readerS5 As SqlDataReader
            readerS5 = CMD_S5.ExecuteReader
            If readerS5.HasRows Then
                readerS5.Read()
                Z_SHIPX_FigureShippingCost = Z_SHIPX_FigureShippingCost + (readerS5("ShippingCostSurcharge") * Z_SHIPX_FigureShippingCost) + (readerS5("AmountPerPoundSurcharge") * subVarWeightOfShipment) + (readerS5("PercentOfPurchaseValueSurcharge") * subVarCostOfGoods) + readerS5("FlatAmountSurcharge")
            End If
        End Using
        'LP or 12 Inch Surcharge
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
            SqlConnection.ClearPool(conn)
            conn.Open()
            Dim CMD_V As New SqlCommand("spCheckForLPor12InchInCart", conn)
            CMD_V.CommandType = Data.CommandType.StoredProcedure
            CMD_V.Parameters.AddWithValue("@CartName", subVarCartName)
            Dim readerV As SqlDataReader
            readerV = CMD_V.ExecuteReader
            If readerV.HasRows Then
                Z_SHIPX_FigureShippingCost = Z_SHIPX_FigureShippingCost + subVarLPor12InchSurcharge
            End If
        End Using
        'Australia Surcharge For Fedex
        If (subVarShippingMethod = "FEINTE" Or subVarShippingMethod = "FEINTP") And ucase(subVarCountry) = "AUSTRALIA" Then
            Z_SHIPX_FigureShippingCost = Z_SHIPX_FigureShippingCost + 25
        End If

        'New Zealand Surcharge For Fedex
        If (subVarShippingMethod = "FEINTE" Or subVarShippingMethod = "FEINTP") And ucase(subVarCountry) = "NEW ZEALAND" Then
            Z_SHIPX_FigureShippingCost = Z_SHIPX_FigureShippingCost + 59
        End If

        'Check for Minumum Order Amount For Flat Shipping Charge
        Dim dblMinimumOrderForFlatShippingCharge As Double = 200000
        Dim dblFlatShippingCharge As Double = 0
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
            SqlConnection.ClearPool(conn)
            conn.Open()
            Dim CMD_Flat As New SqlCommand("spGetMinimumFlatShippngCharge", conn)
            CMD_Flat.CommandType = Data.CommandType.StoredProcedure
            CMD_Flat.Parameters.AddWithValue("@ShippingMethodCode", subVarShippingMethod)
            Dim readerFlat As SqlDataReader
            readerFlat = CMD_Flat.ExecuteReader
            If readerFlat.HasRows Then
                readerFlat.read()
                dblMinimumOrderForFlatShippingCharge = IsDBSomething(readerFlat("CustomFlatShippingChargeSpendThreshold"), 200000)
                dblFlatShippingCharge = IsDBSomething(readerFlat("CustomFlatShippingCharge"), 0)
            End If
            If dblMinimumOrderForFlatShippingCharge = 0 Then dblMinimumOrderForFlatShippingCharge = 200000
        End Using
        If CDbl(subVarCostOfGoods) >= CDbl(dblMinimumOrderForFlatShippingCharge) And CDbl(dblFlatShippingCharge) < CDbl(Z_SHIPX_FigureShippingCost) Then
            Z_SHIPX_FigureShippingCost = dblFlatShippingCharge
        End If

        'Format to 2 decimals
        Z_SHIPX_FigureShippingCost = Math.Round(Z_SHIPX_FigureShippingCost, 2, MidpointRounding.AwayFromZero)
        Z_SHIPX_FigureShippingCost = formatnumber(Z_SHIPX_FigureShippingCost, 2)
    End Function
    Public Function Z_SHIPX_FigureStateProvinceFromZipCode(ByVal subVarZipCode As String) As String
        Z_SHIPX_FigureStateProvinceFromZipCode = ""
        If Len(subVarZipCode) > 8 Then
            Exit Function
        End If
        Dim subVarZip3 As String = ""
        If subVarZipCode = "" Then
            Z_SHIPX_FigureStateProvinceFromZipCode = "Nevada"
            Exit Function
        End If
        Z_SHIPX_FigureStateProvinceFromZipCode = "Nevada"
        If Len(subVarZipCode) <> 5 Then
            Z_SHIPX_FigureStateProvinceFromZipCode = "Nevada"
            Exit Function
        End If
        If Not IsNumeric(subVarZipCode) Then
            Z_SHIPX_FigureStateProvinceFromZipCode = "Nevada"
            Exit Function
        End If
        subVarZip3 = Left(subVarZipCode, 3)
        If subVarZip3 >= 962 And subVarZip3 <= 966 Then
            Z_SHIPX_FigureStateProvinceFromZipCode = "AP (Military)"
        ElseIf subVarZip3 >= 90 And subVarZip3 <= 99 Then
            Z_SHIPX_FigureStateProvinceFromZipCode = "AE (Military)"
        ElseIf subVarZip3 = 340 Then
            Z_SHIPX_FigureStateProvinceFromZipCode = "AA (Military)"
        ElseIf subVarZip3 = 967 Or subVarZip3 = 968 Then
            Z_SHIPX_FigureStateProvinceFromZipCode = "Hawaii"
        ElseIf subVarZip3 >= 995 And subVarZip3 <= 999 Then
            Z_SHIPX_FigureStateProvinceFromZipCode = "Alaska"
        ElseIf subVarZip3 = 6 Or subVarZip3 = 7 Or subVarZip3 = 9 Then
            Z_SHIPX_FigureStateProvinceFromZipCode = "Puerto Rico"
        ElseIf subVarZip3 = 969 Then
            Z_SHIPX_FigureStateProvinceFromZipCode = "Guam"
        ElseIf subVarZip3 = 8 Then
            Z_SHIPX_FigureStateProvinceFromZipCode = "Virgin Islands (U.S.)"
        End If
    End Function
    Public Function FigureTimeAgo(txt As String) As String
        FigureTimeAgo = ""
        If IsDate(txt) Then
            If DateDiff(DateInterval.Second, CDate(txt), Now) < 60 Then
                FigureTimeAgo = DateDiff(DateInterval.Second, CDate(txt), Now) & " Seconds"
                If DateDiff(DateInterval.Second, CDate(txt), Now) = 1 Then
                    FigureTimeAgo = DateDiff(DateInterval.Second, CDate(txt), Now) & " Second"
                End If
            ElseIf DateDiff(DateInterval.Minute, CDate(txt), Now) < 60 Then
                FigureTimeAgo = DateDiff(DateInterval.Minute, CDate(txt), Now) & " Minutes"
                If DateDiff(DateInterval.Minute, CDate(txt), Now) = 1 Then
                    FigureTimeAgo = DateDiff(DateInterval.Minute, CDate(txt), Now) & " Minute"
                End If
            ElseIf DateDiff(DateInterval.Hour, CDate(txt), Now) < 60 Then
                FigureTimeAgo = DateDiff(DateInterval.Hour, CDate(txt), Now) & " Hours"
                If DateDiff(DateInterval.Hour, CDate(txt), Now) = 1 Then
                    FigureTimeAgo = DateDiff(DateInterval.Hour, CDate(txt), Now) & " Hour"
                End If
            Else
                FigureTimeAgo = DateDiff(DateInterval.Day, CDate(txt), Now) & " Days"
                If DateDiff(DateInterval.Day, CDate(txt), Now) = 1 Then
                    FigureTimeAgo = DateDiff(DateInterval.Day, CDate(txt), Now) & " Day"
                End If
            End If
        End If
    End Function
    Public Function CleanText(txt As String) As String
        If Len(txt) = 0 Then
            CleanText = ""
            Exit Function
        End If
        Dim position As Integer = 0
        CleanText = txt
        CleanText = Replace(CleanText, ";", ":", 1, 100, vbTextCompare)
        position = InStr(1, CleanText, "*")
        If position > 0 Then
            Do
                CleanText = Left(CleanText, position - 1) & Right(CleanText, Len(CleanText) - position)
                position = InStr(1, CleanText, "*")
                If position = 0 Then Exit Do
            Loop
        End If
        position = InStr(1, CleanText, "<")
        If position > 0 Then
            Do
                CleanText = Left(CleanText, position - 1) & Right(CleanText, Len(CleanText) - position)
                position = InStr(1, CleanText, "<")
                If position = 0 Then Exit Do
            Loop
        End If
        position = InStr(1, CleanText, ">")
        If position > 0 Then
            Do
                CleanText = Left(CleanText, position - 1) & Right(CleanText, Len(CleanText) - position)
                position = InStr(1, CleanText, ">")
                If position = 0 Then Exit Do
            Loop
        End If
        position = InStr(1, CleanText, "--")
        If position > 0 Then
            Do
                CleanText = Left(CleanText, position - 1) & Right(CleanText, Len(CleanText) - position - 1)
                position = InStr(1, CleanText, "--")
                If position = 0 Then Exit Do
            Loop
        End If
        position = InStr(1, CleanText, "xp_")
        If position > 0 Then
            Do
                CleanText = Left(CleanText, position - 1) & Right(CleanText, Len(CleanText) - position - 2)
                position = InStr(1, CleanText, "xp_")
                If position = 0 Then Exit Do
            Loop
        End If
        position = InStr(1, CleanText, "sp_")
        If position > 0 Then
            Do
                CleanText = Left(CleanText, position - 1) & Right(CleanText, Len(CleanText) - position - 2)
                position = InStr(1, CleanText, "sp_")
                If position = 0 Then Exit Do
            Loop
        End If
    End Function
    Public Function Z_SHIPX_FigureTrackingURL(subVarTrackingNumber As String, subVarShippingCompany As String) As String
        Z_SHIPX_FigureTrackingURL = "NA"
        If subVarTrackingNumber = "" Then
            Exit Function
        End If
        If Len(subVarTrackingNumber) < 5 Then
            Exit Function
        End If
        'ShippingCompany
        If InStr(1, UCase(subVarShippingCompany), "FEDEX") > 0 Or InStr(1, UCase(subVarShippingCompany), "FEDERAL") > 0 Then
            subVarShippingCompany = "FEDEX"
        ElseIf InStr(1, UCase(subVarShippingCompany), "UPS") > 0 Then
            subVarShippingCompany = "UPS"
        ElseIf InStr(1, UCase(subVarShippingCompany), "USPS") > 0 Or InStr(1, UCase(subVarShippingCompany), "MAIL") > 0 Then
            subVarShippingCompany = "USPS"
        ElseIf InStr(1, UCase(subVarShippingCompany), "DHL") > 0 Then
            subVarShippingCompany = "DHL"
        Else
            Exit Function
        End If
        'Get rid of spaces
        Dim intSpace As Integer = 0
        Dim intCombined As Integer = 0
        Do
            intSpace = InStr(1, subVarTrackingNumber, " ")
            If intSpace > 0 Then
                subVarTrackingNumber = Left(subVarTrackingNumber, intSpace - 1) & Right(subVarTrackingNumber, Len(subVarTrackingNumber) - intSpace)
            Else
                Exit Do
            End If
        Loop
        'Get rid of "combined" text
        Do
            If Right(UCase(subVarTrackingNumber), 8) = "COMBINED" Then
                subVarTrackingNumber = Left(subVarTrackingNumber, Len(subVarTrackingNumber) - 8)
            End If
            intCombined = InStr(1, UCase(subVarTrackingNumber), "COMBINED")
            If intCombined > 0 Then
                subVarTrackingNumber = Left(subVarTrackingNumber, intCombined - 1) & Right(subVarTrackingNumber, Len(subVarTrackingNumber) - intCombined - 8)
            Else
                Exit Do
            End If
        Loop
        'Replace non-alphanumeric characters with ;
        Dim strOriginalTrackingNumber As String = ""
        Dim intASC As Integer = 0
        Z_SHIPX_FigureTrackingURL = ""
        strOriginalTrackingNumber = subVarTrackingNumber
        subVarTrackingNumber = ""
        For n = 1 To Len(strOriginalTrackingNumber)
            intASC = Asc(Mid(strOriginalTrackingNumber, n, 1))
            If (intASC >= 48 And intASC <= 57) Or (intASC >= 65 And intASC <= 90) Or (intASC >= 97 And intASC <= 122) Or intASC = 59 Then
                subVarTrackingNumber = subVarTrackingNumber & Chr(intASC)
            Else
                subVarTrackingNumber = subVarTrackingNumber & ";"
            End If
        Next
        'Check end for semi
        If Right(subVarTrackingNumber, 1) = ";" Then
            subVarTrackingNumber = Left(subVarTrackingNumber, Len(subVarTrackingNumber) - 1)
        End If
        Z_SHIPX_FigureTrackingURL = ""
        'Figure Tracking URL
        Dim intSemi As Integer = 0
        Dim intBox As Integer = 0
        If UCase(subVarShippingCompany) = "FEDEX" Then
            Z_SHIPX_FigureTrackingURL = "https://www.fedex.com/fedextrack/summary?trknbr="
            Do
                intSemi = InStr(1, subVarTrackingNumber, ";")
                If intSemi > 0 Then
                    Z_SHIPX_FigureTrackingURL = Z_SHIPX_FigureTrackingURL & Left(subVarTrackingNumber, intSemi - 1) & ","
                    subVarTrackingNumber = Right(subVarTrackingNumber, Len(subVarTrackingNumber) - intSemi)
                Else
                    Z_SHIPX_FigureTrackingURL = Z_SHIPX_FigureTrackingURL & subVarTrackingNumber
                    Exit Do
                End If
            Loop
        ElseIf UCase(subVarShippingCompany) = "DHL" Then
            Z_SHIPX_FigureTrackingURL = "https://www.dhl.com/us-en/home/tracking/tracking-express.html?submit=1&tracking-id="
            Do
                intSemi = InStr(1, subVarTrackingNumber, ";")
                If intSemi > 0 Then
                    Z_SHIPX_FigureTrackingURL = Z_SHIPX_FigureTrackingURL & Left(subVarTrackingNumber, intSemi - 1) & ","
                    subVarTrackingNumber = Right(subVarTrackingNumber, Len(subVarTrackingNumber) - intSemi)
                Else
                    Z_SHIPX_FigureTrackingURL = Z_SHIPX_FigureTrackingURL & subVarTrackingNumber
                    Exit Do
                End If
            Loop
        ElseIf UCase(subVarShippingCompany) = "UPS" Then
            Z_SHIPX_FigureTrackingURL = "https://wwwapps.ups.com/WebTracking/processInputRequest?sort_by=status&tracknums_displayed=1&TypeOfInquiryNumber=T&"
            intBox = 0
            Do
                intSemi = InStr(1, subVarTrackingNumber, ";")
                If intSemi > 0 Then
                    intBox = intBox + 1
                    Z_SHIPX_FigureTrackingURL = Z_SHIPX_FigureTrackingURL & "InquiryNumber" & intBox & "=" & Left(subVarTrackingNumber, intSemi - 1) & "&"
                    subVarTrackingNumber = Right(subVarTrackingNumber, Len(subVarTrackingNumber) - intSemi)
                Else
                    intBox = intBox + 1
                    Z_SHIPX_FigureTrackingURL = Z_SHIPX_FigureTrackingURL & "InquiryNumber" & intBox & "=" & subVarTrackingNumber
                    Exit Do
                End If
            Loop
        ElseIf UCase(subVarShippingCompany) = "USPS" Then
            intBox = 1
            Do
                intSemi = InStr(1, subVarTrackingNumber, ";")
                If intSemi = 0 Then Exit Do
                subVarTrackingNumber = Trim(Left(subVarTrackingNumber, intSemi - 1)) & "%2C" & Right(subVarTrackingNumber, Len(subVarTrackingNumber) - intSemi)
                intBox = intBox + 1
            Loop
            Z_SHIPX_FigureTrackingURL = "https://tools.usps.com/go/TrackConfirmAction.action?tRef=fullpage&tLc=" & intBox & "&text28777=&tLabels=" & subVarTrackingNumber
        End If

    End Function
    Public Function Z_SHIPX_FigureNumberOfBoxes(subVarCountry As String, subVarNameOfCart As String, subVarShippingMethod As String, subVarWeight As Integer, ByVal strConnectionStringName As String) As Integer

        If Len(subVarNameOfCart) = 0 Or Len(subVarShippingMethod) = 0 Or subVarWeight = 0 Then
            Z_SHIPX_FigureNumberOfBoxes = 1
            Exit Function
        End If

        Dim varWeightInGrams As Integer = subVarWeight * 454
        Dim varMaxBoxWeightInGrams As Integer = 0
        Dim subVarMaxWeightOfBoxInGramsForShippingMethod As Integer = 0
        Dim varMaxWeightOfBoxInGramsForPacking As Integer = 0
        Dim varWeightOfProductInGrams As Integer = 0

        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
            SqlConnection.ClearPool(conn)
            conn.Open()
            Dim CMD_Y As New SqlCommand("spGetWeightOfProduct", conn)
            CMD_Y.CommandType = Data.CommandType.StoredProcedure
            CMD_Y.Parameters.AddWithValue("@CartName", subVarNameOfCart)
            Dim readerY As SqlDataReader
            readerY = CMD_Y.ExecuteReader
            If readerY.HasRows Then
                readerY.Read()
                varWeightOfProductInGrams = readerY("sumweight")
            End If
        End Using

        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
            SqlConnection.ClearPool(conn)
            conn.Open()
            Dim CMD_X As New SqlCommand("spGetShippingMethodsRow", conn)
            CMD_X.CommandType = Data.CommandType.StoredProcedure
            CMD_X.Parameters.AddWithValue("@ShippingMethodCode", subVarShippingMethod)
            Dim readerX As SqlDataReader
            readerX = CMD_X.ExecuteReader
            If readerX.HasRows Then
                readerX.Read()
                subVarMaxWeightOfBoxInGramsForShippingMethod = readerX("MaxWeightOfBox") * 454
            End If
        End Using

        If subVarShippingMethod = "GE" Or subVarShippingMethod = "APP" Then
            Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
                SqlConnection.ClearPool(conn)
                conn.Open()
                Dim CMD_Y As New SqlCommand("spGetWebCountryShippingZonesTRow", conn)
                CMD_Y.CommandType = Data.CommandType.StoredProcedure
                CMD_Y.Parameters.AddWithValue("@Country", subVarCountry)
                Dim readerY As SqlDataReader
                readerY = CMD_Y.ExecuteReader
                If readerY.HasRows Then
                    readerY.Read()
                    If subVarShippingMethod = "APP" Then
                        subVarMaxWeightOfBoxInGramsForShippingMethod = IsDBSomething(readerY("AirParcelPostWeightLimit"), 44)
                    Else
                        subVarMaxWeightOfBoxInGramsForShippingMethod = IsDBSomething(readerY("GlobalExpressWeightLimit"), 44)
                    End If
                    subVarMaxWeightOfBoxInGramsForShippingMethod = subVarMaxWeightOfBoxInGramsForShippingMethod * 454
                Else
                    subVarMaxWeightOfBoxInGramsForShippingMethod = 19976
                    Exit Function
                End If
            End Using
        End If

        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
            SqlConnection.ClearPool(conn)
            conn.Open()
            Dim CMD_X As New SqlCommand("spGetWebSHIPX_MaxWeightOfBoxForPacking", conn)
            CMD_X.CommandType = Data.CommandType.StoredProcedure
            CMD_X.Parameters.AddWithValue("@CartName", subVarNameOfCart)
            Dim readerX As SqlDataReader
            readerX = CMD_X.ExecuteReader
            readerX.Read()
            varMaxWeightOfBoxInGramsForPacking = readerX("MaxWeightInGrams")
        End Using

        varMaxBoxWeightInGrams = subVarMaxWeightOfBoxInGramsForShippingMethod
        If varMaxBoxWeightInGrams > varMaxWeightOfBoxInGramsForPacking Then
            varMaxBoxWeightInGrams = varMaxWeightOfBoxInGramsForPacking
        End If

        If varWeightOfProductInGrams < varMaxBoxWeightInGrams Then
            Z_SHIPX_FigureNumberOfBoxes = 1
        Else
            Z_SHIPX_FigureNumberOfBoxes = Int((varWeightOfProductInGrams / varMaxBoxWeightInGrams)) + 1
        End If


    End Function
    Public Function fixtext(ByVal texttofix As String) As String
        fixtext = Trim(texttofix)
        Dim varPercentSignFound As Integer = 0
        Dim position As Integer = 0
        fixtext = Replace(fixtext, "'", "''")
        fixtext = Replace(fixtext, """", "")
        If Len(fixtext) > 0 Then
            position = InStr(1, fixtext, "%")
            If position > 0 Then
                varPercentSignFound = 1
                Do
                    fixtext = Left(fixtext, position - 1) & "[%]" & Right(fixtext, Len(fixtext) - position)
                    If position + 3 > Len(fixtext) Then Exit Do
                    position = InStr(position + 3, fixtext, "%")
                    If position = 0 Then Exit Do
                Loop
            End If
        End If
        If Len(fixtext) > 0 Then
            position = InStr(1, UCase(fixtext), "PERCENT")
            If position > 0 Then
                varPercentSignFound = 1
                Do
                    fixtext = Left(fixtext, position - 1) & "[%]" & Right(fixtext, Len(fixtext) - position - 6)
                    If position + 3 > Len(fixtext) Then Exit Do
                    position = InStr(position + 3, fixtext, "PERCENT")
                    If position = 0 Then Exit Do
                Loop
            End If
        End If
        position = InStr(1, fixtext, ">")
        If position > 0 Then
            Do
                fixtext = Left(fixtext, position - 1) & Right(fixtext, Len(fixtext) - position)
                position = InStr(1, fixtext, ">")
                If position = 0 Then Exit Do
            Loop
        End If
        position = InStr(1, fixtext, "<")
        If position > 0 Then
            Do
                fixtext = Left(fixtext, position - 1) & Right(fixtext, Len(fixtext) - position)
                position = InStr(1, fixtext, "<")
                If position = 0 Then Exit Do
            Loop
        End If
        position = InStr(1, fixtext, "--")
        If position > 0 Then
            Do
                fixtext = Left(fixtext, position - 1) & Right(fixtext, Len(fixtext) - position - 1)
                position = InStr(1, fixtext, "--")
                If position = 0 Then Exit Do
            Loop
        End If
        If varPercentSignFound = 0 Then
            position = InStr(1, fixtext, "[")
            If position > 0 Then
                Do
                    fixtext = Left(fixtext, position - 1) & "(" & Right(fixtext, Len(fixtext) - position)
                    position = InStr(1, fixtext, "[")
                    If position = 0 Then Exit Do
                Loop
            End If
            position = InStr(1, fixtext, "]")
            If position > 0 Then
                Do
                    fixtext = Left(fixtext, position - 1) & ")" & Right(fixtext, Len(fixtext) - position)
                    position = InStr(1, fixtext, "]")
                    If position = 0 Then Exit Do
                Loop
            End If
        End If
    End Function


    Public Sub subSendEmail_old(ByVal strFrom As String, ByVal strTo As String, ByVal strSubject As String, ByVal strBody As String, ByVal intLogEmailErrors As Integer, ByVal intHTML As Integer, ByVal strConnectionStringName As String)
        'Try
        Dim strToAddress = New MailAddress(strTo)
        Dim MailMsg As New MailMessage()
        If strTo = "kirby2001@gmail.com" Or strTo = "ernieb12345@gmail.com" Then
            MailMsg.From = New MailAddress("greatbiged@gmail.com", "Millions Of Records")
        Else
            MailMsg.From = New MailAddress("ernieb12345@gmail.com", "Millions Of Records")
        End If
        MailMsg.To.Add(strToAddress)
        MailMsg.BodyEncoding = Encoding.Default
        MailMsg.Subject = strSubject
        MailMsg.Body = strBody
        MailMsg.Priority = MailPriority.High
        If strConnectionStringName = "MillionsOfRecordsConnectionStringDevelopment" Then
            Exit Sub
        End If
        If intHTML = 1 Then
            MailMsg.IsBodyHtml = True
        End If
        Dim SmtpMail As New SmtpClient
        SmtpMail.Host = "smtp.gmail.com"
        SmtpMail.EnableSsl = True
        SmtpMail.Port = 587
        SmtpMail.DeliveryMethod = SmtpDeliveryMethod.Network
        SmtpMail.UseDefaultCredentials = False
        If strTo = "kirby2001@gmail.com" Or strTo = "ernieb12345@gmail.com" Then
            SmtpMail.Credentials = New System.Net.NetworkCredential("greatbiged@gmail.com", "wolcefmhkvxfngvs")
        Else
            SmtpMail.Credentials = New System.Net.NetworkCredential("ernieb12345@gmail.com", "dzuoobhxtpgftjko")
        End If
        SmtpMail.Send(MailMsg)
        'Catch ex As Exception
        'End Try
    End Sub


    Public Function CheckCCNumber(ByVal ccn As String) As Integer
        CheckCCNumber = 1
        Exit Function
        ccn = Trim(ccn)
        Dim zspace As String = ""
        Dim xreverse As String = ""
        Dim qqz As String = ""
        Dim tot As String = ""
        'get rid of spaces
        ccn = Replace(ccn, " ", "")
        'get rid of dashes
        ccn = Replace(ccn, "-", "")
        'get rid of slashes
        ccn = Replace(ccn, "/", "")
        'get rid of commas
        ccn = Replace(ccn, ",", "")
        'get rid of number sign
        ccn = Replace(ccn, "#", "")
        'reverse string
        xreverse = ""
        For n3 = Len(ccn) To 1 Step -1
            xreverse = xreverse & Mid(ccn, n3, 1)
        Next

        'double every other digit starting with second digit
        qqz = ""
        For n5 = 1 To Len(xreverse)
            If n5 / 2 = Int(n5 / 2) Then
                If IsNumeric(Mid(xreverse, n5, 1)) Then
                    qqz = qqz & (Mid(xreverse, n5, 1) * 2)
                Else
                    CheckCCNumber = 0
                    Exit Function
                End If
            Else
                qqz = qqz & Mid(xreverse, n5, 1)
            End If
        Next

        'add up total digits and divide by 10
        tot = 0
        For n7 = 1 To Len(qqz)
            If IsNumeric(Mid(qqz, n7, 1)) Then
                tot = tot + Mid(qqz, n7, 1)
            Else
                CheckCCNumber = 0
                Exit Function
            End If
        Next
        If tot / 10 <> Int(tot / 10) Then
            CheckCCNumber = 0
        End If
    End Function
End Module
