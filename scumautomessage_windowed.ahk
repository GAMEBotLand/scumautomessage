/**
 * scum auto messages AHK script WINDOWED MODE VERSION
 * 
 * Requirements: AutoHotkey (v1.1+)
 * SCUM IN WINDOEWS MODE
 * 
 *     Use:
 *          Control+M   activate / deactivate
 *
 * by GAMNEBotLand.com
 */
 
#NoEnv
#Singleinstance Force
SetTitleMatchMode, 2
SetControlDelay -1

global comando1, tiempo1, m, msg, toggle1,clipboardold

tiempo1  := 5	;await minutes every message
pastebin := "https://pastebin.com/raw/QxgHJ1BN"

toggle1 := false
tiempo1 := tiempo1 * 60000
m       :=1
comando1:=[]

leermensajes()
m:=1

				
^M::
toggle1:=!toggle1
If (toggle1)
{
	toggle1:=true
	Traytip, scumautomessage,ACTIVATED, 5, 1
	Sleep, 3000
	SetTimer, enviar_comandos, %tiempo1%

}
else
{
	toggle1:=false
	Traytip, scumautomessage,DEACTIVATED, 5, 1
	Sleep, 3000
	SetTimer, enviar_comandos, off
}

enviar_comandos:
	If (toggle1)
	{
		Sleep 100
		clipboardold:=clipboard
		Sleep 100
		clipboard:=""
		Sleep 100
		clipboard:=comando1[m]
		Sleep 100
		ControlSend, , t{Ctrl down}a{Ctrl up}{Ctrl down}v{Ctrl up}, SCUM
		clipboard:=clipboardold
		Sleep 100
		ControlSend, ,{Enter}, SCUM
		Sleep 100
		ControlSend, ,{Enter}, SCUM
		Sleep 100
		m++
		if (m>comando1.MaxIndex())
		{
		  m:=1
		  leermensajes()
		}
	}
	Sleep 100
return

leermensajes() {

	local strmensajes,whr
	
	try {
		whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
		ComObjError(0)
		whr.Open("GET", pastebin, true)
		whr.Send()
		whr.WaitForResponse(2)
		strmensajes := whr.ResponseText
		ObjRelease(whr)
	} catch e {
		return
	}
	
	n:=1
	Loop, parse, strmensajes, `n, `r
	{
		comando1[n]:=A_LoopField
		n++
	}
return
}

