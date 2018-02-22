#NoTrayIcon
#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=sprawdz_acl.exe
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_UPX_Parameters=--ultra-brute
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Res_Comment=Cezar z IT
#AutoIt3Wrapper_Res_Description=Cezar z IT
#AutoIt3Wrapper_Res_Fileversion=1.2.1.56
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_LegalCopyright=Cezar z IT
#AutoIt3Wrapper_Res_Language=1045
#AutoIt3Wrapper_Res_Field=Cezar z IT|Cezar z IT
#AutoIt3Wrapper_Run_Tidy=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <Array.au3>
#include <WinAPI.au3>

Global $workFolder = "a:"
Global $sDefaultPath = prepareWorkDir("acl")

If $CmdLine[0] = 0 Then Exit
Global $param = $CmdLine[1]


$param = BinaryToString($param)

PreperePreveleges($param)


Func PreperePreveleges($sPath)
	Local $toWrite = $sPath
	Local $bFlaga = False

	Local $aACL = GetACLs($sPath)
	For $i = 1 To UBound($aACL) - 1
		If StringInStr($aACL[$i], ":(") Then
			If $bFlaga Then $toWrite = $toWrite & @CRLF & $aACL[$i]
			$bFlaga = True

		EndIf
	Next
;~ 	ConsoleWrite("output file : ->>>" & @LF & $toWrite)
	FileWrite(randFileName(), $toWrite)
	Return $sPath
EndFunc   ;==>PreperePreveleges


Func randFileName()
	Local $sFilePath = ""
	Local $sFileName = ""
	Local $randOfset = Asc(StringRight($param, 1))
	Local $mod = Mod((Random($randOfset, $randOfset + $randOfset) + @AutoItPID), 24)
	Do
		$sFileName = @HOUR & @MIN & @MSEC & Random_Password(5 + $mod) & @AutoItPID & ".txt"
		$sFilePath = $sDefaultPath & $sFileName
	Until Not FileExists($sFilePath)
	Return $sFilePath
EndFunc   ;==>randFileName



Func _GetDOSOutput($sCommand)
	Local $iPID, $sOutput = ""

	$iPID = Run(@ComSpec, "C:\", @SW_DISABLE, $STDIN_CHILD + $STDOUT_CHILD)
	StdinWrite($iPID, "chcp 1250 " & @CRLF) ; change codepage for cmd.exe instance to 1250 (West European Latin)
	StdinWrite($iPID, $sCommand)
	StdinWrite($iPID, "exit" & @CRLF) ; send exit command to trigger stdout
	While 1
		$sOutput &= StdoutRead($iPID)
		If @error Then
			ExitLoop
		EndIf
		Sleep(10)
	WEnd

	Return $sOutput
EndFunc   ;==>_GetDOSOutput



Func RemouveDoubleSpace($string)

	Do
		$string = StringReplace($string, "  ", " ")
	Until (StringInStr($string, "  ") < 1)

	Return $string
EndFunc   ;==>RemouveDoubleSpace

Func ClearArrayEmptyLine($array)
	Local $sOut = ""
	Local $sTmp

	For $i = 1 To UBound($array) - 1
		If (StringLen($array[$i]) > 0) Then
			$sTmp = StringStripWS($array[$i], 3)
			$sOut = $sOut & $sTmp & "|"
		EndIf
	Next

	Return StringSplit($sOut, "|")
EndFunc   ;==>ClearArrayEmptyLine

Func GetACLs($sPath)
	Local $getFromOutput = _GetDOSOutput('CACLS  "' & $sPath & '"' & @LF)

	$getFromOutput = _WinAPI_WideCharToMultiByte($getFromOutput, 1250, 1)
	$getFromOutput = BinaryToString($getFromOutput)
	ConsoleWrite($sPath & @LF & $getFromOutput)
	$getFromOutput = RemouveDoubleSpace($getFromOutput)

	Local $iCountToTrim = StringInStr($getFromOutput, $sPath, 0, 2) + StringLen($sPath)
	Local $sPrewiliges = StringStripWS(StringTrimLeft($getFromOutput, $iCountToTrim), 3)
	Local $iCountToTrim = StringInStr($sPrewiliges, "C:\>exit") - 1
	$sPrewiliges = StringLeft($sPrewiliges, $iCountToTrim)
	$sPrewiliges = RemouveDoubleSpace($sPrewiliges)

	Local $array = StringSplit($sPrewiliges, @CRLF)

	$array = ClearArrayEmptyLine($array)

	Return $array

EndFunc   ;==>GetACLs



Func CzyscBiale($string)
	For $x = 0 To 255
		If $x > 47 And $x < 58 Then ContinueLoop
		If $x > 64 And $x < 91 Then ContinueLoop
		If $x > 96 And $x < 123 Then ContinueLoop
;~ ConsoleWrite( $x & " =>  "& chr($x) & @crlf)
		$string = StringReplace($string, Chr($x), "_")
	Next
	Return $string
EndFunc   ;==>CzyscBiale

Func prepareWorkDir($sFold)

	$sFold = $workFolder & "\" & $sFold
	If FileExists($sFold) And StringInStr(FileGetAttrib($sFold), "D") Then
	Else
		DirCreate($sFold)
	EndIf

	Return $sFold & "\"

EndFunc   ;==>prepareWorkDir

Func Random_Password($MAXLENGTH)
	Local $PASSWORD = ""
	Local $iRand
	While StringLen($PASSWORD) <= $MAXLENGTH
		$iRand = Random(1, 3, 1)
		If $iRand = 1 Then
			$LETTER = Random(48, 57)
		ElseIf $iRand = 2 Then
			$LETTER = Random(65, 90)
		ElseIf $iRand = 3 Then
			$LETTER = Random(97, 122)
		Else
			$LETTER = ""
		EndIf
		If StringLen($LETTER) <> "" Then $PASSWORD = $PASSWORD & Chr($LETTER)

	WEnd
	Return $PASSWORD
EndFunc   ;==>Random_Password

