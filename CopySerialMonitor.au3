#include <MsgBoxConstants.au3>
#include <WinAPI.au3>
#include <FileConstants.au3>

Local $aname = "Arduino IDE"

; Retrieve a list of window handles.
Local $aList = WinList()
Local $ahnd = 0

; Loop through the array searching for Arduino.
For $i = 1 To $aList[0][0]
  If $aList[$i][0] <> "" And BitAND(WinGetState($aList[$i][1]), 2) Then
		if StringInStr($aList[$i][0], $aname) then
			$text = _WinAPI_GetClassName($aList[$i][1])
			MsgBox($MB_SYSTEMMODAL, "", "Title: " & $aList[$i][0] & @CRLF & "Handle: " & $aList[$i][1] & " CLS: " & $text)
			$ahnd = $aList[$i][1]
			ExitLoop
		endif   
  EndIf
Next

if $ahnd = 0 then
exit
endif

; We wait for the user to activate the Arduino window
WinWait($ahnd)
if WinWaitActive($ahnd, "", 10) then
	MsgBox($MB_SYSTEMMODAL, "", $aname & " Active")
endif

Local $sfileName = "SerialMonitor.txt"

; Delete target file to start with a blank one
FileDelete($sfileName)

; A few seconds of waiting for the user to select the first character of the Serial Monitor 
Sleep(10000)
Send("+{DOWN}")
Send("+{LEFT}")

; 1000 times give you 33*1000+31 = 33031 lines of capture
For $j = 1 To 1000
	if $j == 1 then $n = 31 ; First selection
	if $j <> 1 then $n = 33 ; Subsequent selections
	For $i = 1 To $n
		Send("+{DOWN}")
	Next
	Send("^c") ; Copy selection
	$sData = ClipGet()
	
	; Update target file
	Local $hFileOpen = FileOpen($sfileName, BitOR($FO_APPEND, $FO_CREATEPATH))
	Local $iFileWrite = FileWrite($hFileOpen, $sData)
	FileClose($hFileOpen)
Next
