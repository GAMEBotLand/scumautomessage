﻿/**
 * SCUM Server Script 
 * License: WTFPL [http://wtfpl.net/]
 * Requirements: AutoHotkey (v1.1+ or v2.0-a+)
 * 
 *     Uso
 *          Control+M activar / desactivar
 * by:
 *     La Patrulla Z: https://es-es.facebook.com/PatrullaZ/
 *     Escoria Humana SCUM Server 
 */

#NoEnv
#Singleinstance Force
SetTitleMatchMode, 2
CoordMode, mouse, screen

global comando1, tiempo1, m, msg, toggle1,clipboardold

tiempo1  := 1	;set minutes every message
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
	SetTimer, enviar_comandos, %tiempo1%
	Sleep, 1500
}
else
{
	toggle1:=false
	Traytip, scumautomessage,DEACTIVATED, 5, 1
	SetTimer, enviar_comandos, off
	Sleep, 1500
}

enviar_comandos:
	If (toggle1)
	{
		WinActivate, SCUM
		WinWaitActive, SCUM
		BlockInput MouseMove
		SetKeyDelay, 30, 30
		Sleep 100
		Send t
		Sleep 50
		Send ^a
		Sleep 50		
		clipboardold:=clipboard
		Sleep 50
		clipboard:=""
		clipboard:=comando1[m]
		Sleep 50
		Send ^v
		Sleep 50
		clipboard:=clipboardold
		Sleep 50
		Send {Enter}		
		Sleep 50
		Send {Enter}		
		BlockInput MouseMoveOff
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
	Sleep 5000
return
}
