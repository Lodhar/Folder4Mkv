#pragma compile(Out, Folder4Mkv.exe)
; Uncomment to use the following icon. Make sure the file path is correct and matches the installation of your AutoIt install path.
#pragma compile(Icon,"E:\_workspace\Ico\developpement-des-logiciels-icone-4322.ico")
;~ #pragma compile(ExecLevel, highestavailable)
#pragma compile(Compatibility, win7)
;~ #pragma compile(UPX, False)
;~ #pragma compile(FileDescription, myProg - a description of the application)
#pragma compile(ProductName, Create a folder for each MKV files)
#pragma compile(ProductVersion, 1.0)
#pragma compile(FileVersion, 0.9) ; The last parameter is optional.
#pragma compile(LegalCopyright, © Lodhar)
#pragma compile(LegalTrademarks, 'GPL License')
#pragma compile(CompanyName, 'Bad Company')


#include <Array.au3> ; Only required to display the arrays
#include <File.au3>
#include <MsgBoxConstants.au3>
#include <String.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

#include <TreeViewConstants.au3>
#include <GuiListView.au3>
#include <ListViewConstants.au3>
#include <Debug.au3>

_DebugSetup("Create folder for MKV files", True,4,'log.txt',True)

Global $folder
$folder = SelectFolder()

GetFilesAndFolders($folder)

Func GetFilesAndFolders($filePath)

   $include = "*.part1.rar;*.part01.rar"
   $exclude = ""
;~    $Exclude_Folders = "_Séries;_VU;_*"
   $Exclude_Folders = "_*;Sample"

;~    Local $aArray = _FileListToArrayRec($filePath, $include & "|" & $exclude & "|" & $Exclude_Folders, $FLTAR_FOLDERS , $FLTAR_RECUR, $FLTAR_SORT, $FLTAR_RELPATH )
;~    Local $aArray = _FileListToArrayRec($filePath, "*", $FLTAR_FOLDERS , $FLTAR_RECUR, $FLTAR_SORT, $FLTAR_RELPATH )
;~    $filePath = "f:\_mkv"
;~    ConsoleWrite($filePath & @CRLF)
   Local $aArray = _FileListToArrayRec($filePath, "*.mkv;*.mp4|" & $exclude & "|" & $Exclude_Folders, $FLTAR_FILES , $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_FULLPATH  ) ; Get MKV files
;~    _ArrayDisplay($aArray,"Result")

   Local $sDrive = "", $sDir = "", $sFilename = "", $sExtension = ""
   Local $arrayResult[0]
   _ArrayDelete($aArray, 0) ; enlève le count
   For $i = 0 To UBound ($aArray) - 1 ; Get the filename and prepare the directory
	  Local $aPathSplit = _PathSplit($aArray[$i], $sDrive, $sDir, $sFilename, $sExtension)
	  ConsoleWrite($sFilename & @CRLF)
	  $result = StringRegExpReplace($sFilename,'(\.)',' ') ; Replace punt by space
	  $result = StringRegExpReplace($result,'(19\d{2}|20\d{2})','($1)') ; Put the date in ()
	  $result = StringRegExpReplace($result,'(\(\()','(') ; kill the double (
	  $result = StringRegExpReplace($result,'(\)\))',')') ; kill the double )
	  $result = StringRegExpReplace($result,'((\(19\d{2}\)|\(20\d{2}\)))((.*){1,})','$1') ; take everything after the date and erase it
	  $result = StringRegExpReplace($result,'(\A(The ))((.*){1,})((\(19\d{2}\)|\(20\d{2}\)))','$3, $2$5') ; Take care of the 'The'
	  $result = StringRegExpReplace($result,'( ,)',',') ; Kill the space before the ,
	  $result = StringRegExpReplace($result,'  ',' ') ; Replace double space by one space

	  ConsoleWrite("DirCreate:" & $sDrive & $sDir & $result & @CRLF)
	  DirCreate($sDrive & $sDir & $result)
	  ConsoleWrite("FileMove:" &$sDrive & $sDir & $sFilename & $sExtension & " TO " & $sDrive & $sDir & $result & "\" & $sFilename & $sExtension & @CRLF)
	  FileMove($sDrive & $sDir & $sFilename & $sExtension, $sDrive & $sDir & $result & "\" & $sFilename & $sExtension, $FC_CREATEPATH )

   Next

EndFunc




Func SelectFolder()
    ; Create a constant variable in Local scope of the message to display in FileSelectFolder.
    Local Const $sMessage = "Select a folder"


   Local $sFileSelectFolder = FileSelectFolder($sMessage, @WorkingDir, Default, @WorkingDir)
;~  Local $sFileSelectFolder = FileSelectFolder($sMessage, "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", Default, @WorkingDir)


    If @error Then
        ; Display the error message.
;~         MsgBox($MB_SYSTEMMODAL, "", )
		ConsoleWrite("ERROR: " & @error & " - " & "No folder was selected." & @CRLF)
		Exit
    Else
        ; Display the selected folder.
;~         MsgBox($MB_SYSTEMMODAL, "", "You chose the following folder:" & @CRLF & $sFileSelectFolder)
		ConsoleWrite("SUCCES: " & "You chose the following folder:" & $sFileSelectFolder & @CRLF)
	 EndIf
	 Return $sFileSelectFolder
  EndFunc   ;==>Example

Func errorDisplay()
;~    (@error) ?  ConsoleWrite("Error:" & @error & @CRLF) : ConsoleWrite("Ok:" & @error & @CRLF)
   If @error Then
	  ConsoleWrite("Error:" & @error & @CRLF)
   Else
	  ConsoleWrite("Ok:" & @error & @CRLF)
   EndIf
EndFunc
