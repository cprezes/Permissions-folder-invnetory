#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=Indekser uprawnien folderow.exe
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_UPX_Parameters=--ultra-brute
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_Comment=Cezar z IT
#AutoIt3Wrapper_Res_Description=Cezar z IT
#AutoIt3Wrapper_Res_Fileversion=1.2.1.54
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_LegalCopyright=Cezar z IT
#AutoIt3Wrapper_Res_Language=1045
#AutoIt3Wrapper_Res_Field=Cezar z IT|Cezar z IT
#AutoIt3Wrapper_AU3Check_Parameters=-w 1 -w 2 -w 3 -w 4 -w 6 -d
#AutoIt3Wrapper_Run_Tidy=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <MsgBoxConstants.au3>
#include <SQLite.au3>
#include <SQLite.dll.au3>
#include <Array.au3>


Global $workFolder = "a:" ;Ram Disk

Global $sDefaultPath = prepareWorkDir("acl")

Global $WydobywaczUprawnien = @ScriptDir & "\sprawdz_acl.exe"
;~ Global $ZapisywaczDoBazy = @ScriptDir & "\zapis_do_db.exe"

If Not FileExists($WydobywaczUprawnien) Then Exit MsgBox(0, "Koniec programu", "Brak Pliku " & $WydobywaczUprawnien)
;~ If Not FileExists($ZapisywaczDoBazy) Then Exit MsgBox(0, "Koniec programu", "Brak Pliku " & $ZapisywaczDoBazy)


Global $startNumProcess = UBound(ProcessList(), 1)


Global $sFileSelectFolder = FileSelectFolder("Select a start index folder", "")
If @error Then Exit
Global $sSqlLitePatch = @ScriptDir & "\"
Global $listRout = $sFileSelectFolder
Global $listRoutZamienNa = $sFileSelectFolder

;~ Run($ZapisywaczDoBazy, @ScriptDir, @SW_HIDE) ;-------------------------------->

_filelist($listRout)

MsgBox(0, "", "Skonczono indeksowanie dysku " & $listRout & "Wyniki Zapisano", 20)

Func _filelist($searchdir)
	Local $file = ""
	Local $search = FileFindFirstFile($searchdir & "\*.*")
	If $search = -1 Then Return -1
	While 1
		$file = FileFindNextFile($search)
		If @error Then

			FileClose($search)
			Return
		ElseIf $file = "." Or $file = ".." Then
			ContinueLoop
		ElseIf StringInStr(FileGetAttrib($searchdir & "\" & $file), "D") Then
			_filelist($searchdir & "\" & $file)

		EndIf
		If StringInStr(FileGetAttrib($searchdir & "\" & $file), "D") Then PreperePreveleges($searchdir & "\" & $file)

	WEnd
EndFunc   ;==>_filelist

Func PreperePreveleges($sPath)


	While UBound(ProcessList(), 1) - $startNumProcess > 200 Or DirGetSize($sDefaultPath, 1)[1] > 1000
		Sleep(10)
	WEnd
	$sPath = StringReplace($sPath, ":\\", ":\")


	Run(@ComSpec & " /c " & $WydobywaczUprawnien & " " & StringToBinary($sPath), "c:\", @SW_HIDE)
;~ 	ConsoleWrite("num files  => " & DirGetSize($sDefaultPath, 1)[1] & " Num process => " & UBound(ProcessList(), 1) - $startNumProcess & " run => " & $WydobywaczUprawnien & " " & StringToBinary($sPath) & " path --> " & $sPath & @LF)
EndFunc   ;==>PreperePreveleges



Func prepareWorkDir($sFold)
	$sFold = $workFolder & "\" & $sFold
	If FileExists($sFold) And StringInStr(FileGetAttrib($sFold), "D") Then
	Else
		DirCreate($sFold)
	EndIf
	Return $sFold & "\"
EndFunc   ;==>prepareWorkDir
