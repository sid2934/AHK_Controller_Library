SetTitleMatchMode, 3
SetTitleMatchMode, Slow

global keyboardIsOpen := false
capsLockOn := false
controlPressed := false
shiftPressed := false
altPressed := false

global k_map := Object()
class KeyMap{

	__New(u, d, l , r){
		this.uKey := u
		this.dKey := d
		this.lKey := l
		this.rKey := r
	}
	
	upKey{
		get{
			value := this.uKey
			value = %value%
			return value
		}
	}
	
	downKey{
		get{
			value := this.dKey
			value = %value%
			return value
		}
	}
	
	leftKey{
		get{
			value := this.lKey
			value = %value%
			return value
		}
	}
	
	rightKey{
		get{
			value := this.rKey
			value = %value%
			return value
		}
	}
}

k_map["Fn"] := new KeyMap("Ctrl", "Tab", "Bk", "``")
k_map["``"]  := new KeyMap("Win", "Tab", "Fn", "1")
k_map[1] := new KeyMap("Win", "Q", "``", "2")
k_map[2] := new KeyMap("Alt", "W", "1", "3")
k_map[3] := new KeyMap("Space", "E", "2", "4")
k_map[4] := new KeyMap("Space", "R", "3", "5")
k_map[5] := new KeyMap("Space", "T", "4", "6")
k_map[6] := new KeyMap("Space", "Y", "5", "7")
k_map[7] := new KeyMap("Space", "U", "6", "8")
k_map[8] := new KeyMap("Space", "I", "7", "9")
k_map[9] := new KeyMap("Space", "O", "8", "0")
k_map[0] := new KeyMap("Space", "P", "9" ,"-")
k_map["-"] := new KeyMap("'", "[", "0", "=")
k_map["="] := new KeyMap("Enter", "]", "-", "Bk")
k_map["Bk"] := new KeyMap("Enter", "\", "=", "Fn")

k_map["Tab"] := new KeyMap("Fn", "Caps Lock", "\", "Q")
k_map["Q"]  := new KeyMap("1", "A", "Tab", "W")
k_map["W"] := new KeyMap("2", "S", "Q", "E")
k_map["E"] := new KeyMap("3", "D", "W", "R")
k_map["R"] := new KeyMap("4", "F", "E", "T")
k_map["T"] := new KeyMap("5", "G", "R", "Y")
k_map["Y"] := new KeyMap("6", "H", "T", "U")
k_map["U"] := new KeyMap("7", "J", "Y", "I")
k_map["I"] := new KeyMap("8", "K", "U", "O")
k_map["O"] := new KeyMap("9", "L", "I", "P")
k_map["P"] := new KeyMap("0", ";", "O", "[")
k_map["["] := new KeyMap("-", "'", "P" ,"]")
k_map["]"] := new KeyMap("=", "Enter", "[", "\")
k_map["\"] := new KeyMap("Bk", "Enter", "]", "Tab")

k_map["Caps Lock"] := new KeyMap("Tab","Shift","Enter","A")
k_map["A"] := new KeyMap("Q", "Z", "Caps Lock", "S")
k_map["S"] := new KeyMap("W", "X", "A","D")
k_map["D"] := new KeyMap("E", "C", "S","F")
k_map["F"] := new KeyMap("R", "V", "D","G")
k_map["G"] := new KeyMap("T", "B", "F","H")
k_map["H"] := new KeyMap("Y", "N", "G","J")
k_map["J"] := new KeyMap("U", "M", "H","K")
k_map["K"] := new KeyMap("I", "`,", "J","L")
k_map["L"] := new KeyMap("O", ".", "K",";")
k_map[";"] := new KeyMap("P", "/", "L","'")
k_map["'"] := new KeyMap("[", "-", ";","Enter")
k_map["Enter"] := new KeyMap("]", "=", "'", "Caps Lock")

k_map["Shift"] := new KeyMap("Caps Lock","Ctrl","/","Z")
k_map["Z"] := new KeyMap("A", "Win", "Shift", "X")
k_map["X"] := new KeyMap("S", "Alt", "Z","C")
k_map["C"] := new KeyMap("D", "Space", "X","V")
k_map["V"] := new KeyMap("F", "Space", "C","B")
k_map["B"] := new KeyMap("G", "Space", "V","N")
k_map["N"] := new KeyMap("H", "Space", "B","M")
k_map["M"] := new KeyMap("J", "Space", "N",",")
k_map[","] := new KeyMap("K", "Space", "M",".")
k_map["."] := new KeyMap("L", "Space", ",","/")
k_map["/"] := new KeyMap(";", "Space", ".", "Shift")

k_map["Ctrl"] := new KeyMap("Shift", "Fn", "Space", "Win")
k_map["Win"] := new KeyMap("Z", "1", "Ctrl", "Alt")
k_map["Alt"] := new KeyMap("X", "2", "Win","Space")
k_map["Space"] := new KeyMap("C", "3", "Alt", "Ctrl")

global k_currentKey := "Enter"
global k_ID  :=


k_FontSize = 10
k_FontName = Verdana  ; This can be blank to use the system's default font.
k_FontStyle = Bold    ; Example of an alternative: Italic Underline

k_Monitor = 

k_KeyWidth = %k_FontSize%
k_KeyWidth *= 3
k_KeyHeight = %k_FontSize%
k_KeyHeight *= 3.5
k_KeyMargin = %k_FontSize%
k_KeyMargin /= 6
k_SpacebarWidth = %k_FontSize%
k_SpacebarWidth *= 25
k_KeyWidthHalf = %k_KeyWidth%
k_KeyWidthHalf /= 2


tempValue = %k_KeyWidth%
tempValue *= 2
tempValue++
k_KeyWidthDouble = %tempValue%

tempValue = %k_KeyWidth%
tempValue *= 1.5
tempValue += .8
k_KeyWidthPlusHalf = %tempValue%

tempValue = %k_KeyWidth%
tempValue *= 8
tempValue += 8
k_SpaceKeyWidth = %tempValue%

k_KeySize = w%k_KeyWidth% h%k_KeyHeight%
k_SpaceKeySize = w%k_SpaceKeyWidth% h%k_KeyHeight%
k_PlusHalfKeySize = w%k_KeyWidthPlusHalf% h%k_KeyHeight%
k_DoubleKeySize = w%k_KeyWidthDouble% h%k_KeyHeight%


k_Position = x+%k_KeyMargin% %k_KeySize%


Gui, Keyboard: Font, s%k_FontSize% %k_FontStyle%, %k_FontName%
Gui, Keyboard: -Caption +E0x200 +ToolWindow
TransColor = F1ECED
Gui, Keyboard: Color, %TransColor%  ; This color will be made transparent later below.

Gui, Keyboard: Add, Button, section %k_KeySize% xm+%k_KeyWidth%, Fn
Gui, Keyboard: Add, Button, %k_Position%, ``
Gui, Keyboard: Add, Button, %k_Position%, 1
Gui, Keyboard: Add, Button, %k_Position%, 2
Gui, Keyboard: Add, Button, %k_Position%, 3
Gui, Keyboard: Add, Button, %k_Position%, 4
Gui, Keyboard: Add, Button, %k_Position%, 5
Gui, Keyboard: Add, Button, %k_Position%, 6
Gui, Keyboard: Add, Button, %k_Position%, 7
Gui, Keyboard: Add, Button, %k_Position%, 8
Gui, Keyboard: Add, Button, %k_Position%, 9
Gui, Keyboard: Add, Button, %k_Position%, 0
Gui, Keyboard: Add, Button, %k_Position%, -
Gui, Keyboard: Add, Button, %k_Position%, =
Gui, Keyboard: Add, Button, %k_Position%, Bk

Gui, Keyboard: Add, Button, xs y+%k_KeyMargin% %k_DoubleKeySize%, Tab  ; Auto-width.
Gui, Keyboard: Add, Button, %k_Position%, Q
Gui, Keyboard: Add, Button, %k_Position%, W
Gui, Keyboard: Add, Button, %k_Position%, E
Gui, Keyboard: Add, Button, %k_Position%, R
Gui, Keyboard: Add, Button, %k_Position%, T
Gui, Keyboard: Add, Button, %k_Position%, Y
Gui, Keyboard: Add, Button, %k_Position%, U
Gui, Keyboard: Add, Button, %k_Position%, I
Gui, Keyboard: Add, Button, %k_Position%, O
Gui, Keyboard: Add, Button, %k_Position%, P
Gui, Keyboard: Add, Button, %k_Position%, [
Gui, Keyboard: Add, Button, %k_Position%, ]
Gui, Keyboard: Add, Button, %k_Position%, \


Gui, Keyboard: Add, Button, xs y+%k_KeyMargin% %k_DoubleKeySize%, Caps Lock
Gui, Keyboard: Add, Button, %k_Position%, A
Gui, Keyboard: Add, Button, %k_Position%, S
Gui, Keyboard: Add, Button, %k_Position%, D
Gui, Keyboard: Add, Button, %k_Position%, F
Gui, Keyboard: Add, Button, %k_Position%, G
Gui, Keyboard: Add, Button, %k_Position%, H
Gui, Keyboard: Add, Button, %k_Position%, J
Gui, Keyboard: Add, Button, %k_Position%, K
Gui, Keyboard: Add, Button, %k_Position%, L
Gui, Keyboard: Add, Button, %k_Position%, `;
Gui, Keyboard: Add, Button, %k_Position%, '
Gui, Keyboard: Add, Button, x+%k_KeyMargin% %k_DoubleKeySize%, Enter  ; Auto-width.

Gui, Keyboard: Add, Button, xs y+%k_KeyMargin% %k_DoubleKeySize%, Shift
Gui, Keyboard: Add, Button, %k_Position%, Z
Gui, Keyboard: Add, Button, %k_Position%, X
Gui, Keyboard: Add, Button, %k_Position%, C
Gui, Keyboard: Add, Button, %k_Position%, V
Gui, Keyboard: Add, Button, %k_Position%, B
Gui, Keyboard: Add, Button, %k_Position%, N
Gui, Keyboard: Add, Button, %k_Position%, M
Gui, Keyboard: Add, Button, %k_Position%, `,
Gui, Keyboard: Add, Button, %k_Position%, .
Gui, Keyboard: Add, Button, %k_Position%, /

Gui, Keyboard: Add, Button, xs y+%k_KeyMargin% %k_PlusHalfKeySize%, Ctrl  ; Auto-width.
Gui, Keyboard: Add, Button,x+%k_KeyMargin% %k_PlusHalfKeySize%, Win      ; Auto-width.
Gui, Keyboard: Add, Button, %k_Position%, Alt      ; Auto-width.
Gui, Keyboard: Add, Button, h%k_KeyHeight% x+%k_KeyMargin% %k_SpaceKeySize%, Space
;Gui, Keyboard: Add, Text, vCurrentPosition,  Here it is
;Gui, Keyboard: Add, Text, vThisString,  Here it is 2

openKeyboard(){
Gui, Keyboard: Show, 
keyboardIsOpen := true
k_IsVisible = y

WinGet, temp_k_ID, ID, A   ; Get its window ID.
k_ID := temp_k_ID
WinGetPos,,, k_WindowWidth, k_WindowHeight, A

;---- Position the keyboard at the bottom of the screen (taking into account
; the position of the taskbar):
SysGet, k_WorkArea, MonitorWorkArea, %k_Monitor%

; Calculate window's X-position:
k_WindowX = %k_WorkAreaRight%
k_WindowX -= %k_WorkAreaLeft%  ; Now k_WindowX contains the width of this monitor.
k_WindowX -= %k_WindowWidth%
k_WindowX /= 2  ; Calculate position to center it horizontally.
; The following is done in case the window will be on a non-primary monitor
; or if the taskbar is anchored on the left side of the screen:
k_WindowX += %k_WorkAreaLeft%

; Calculate window's Y-position:
k_WindowY = %k_WorkAreaBottom%
k_WindowY -= %k_WindowHeight%

WinMove, A,, %k_WindowX%, %k_WindowY%
WinSet, AlwaysOnTop, On, ahk_id %k_ID%
WinSet, Disable,, ahk_id %k_ID%
;WinSet, TransColor, %TransColor% 220, ahk_id %k_ID%

;GuiControl, Keyboard:, ThisString, %k_ID%
ControlClick, %k_currentKey%, ahk_id %k_ID%, , LEFT, 1
;GuiControl, Keyboard: ,CurrentPosition, %k_currentKey%
Gui, Keyboard: +E0x08000000
}

closeKeyboard(){
	keyboardIsOpen := false
	Gui, Keyboard: Hide	
	Sleep 500
}

toggleKeyboard(){
	if(keyboardIsOpen == false){
		openKeyboard()
	}else{
		closeKeyboard()
	}
}

keyboardMoveLeft(){
	k_currentKey := k_map[ k_currentKey].leftKey
	;GuiControl, Keyboard:, ThisString, %k_ID%
	;GuiControl, Keyboard: ,CurrentPosition, %k_currentKey%
	ControlClick, %k_currentKey%, ahk_id %k_ID%, , LEFT, 1
	Sleep, 60
}

keyboardMoveRight(){
	k_currentKey := k_map[k_currentKey].rightKey
	;GuiControl, Keyboard:, ThisString, %k_ID%
	;GuiControl, Keyboard: ,CurrentPosition, %k_currentKey%
	ControlClick, %k_currentKey%, ahk_id %k_ID%, , LEFT, 1
	Sleep, 60
}

keyboardMoveUp(){
	k_currentKey := k_map[k_currentKey].upKey
	;GuiControl, Keyboard:, ThisString, %k_ID%
	;GuiControl, Keyboard: ,CurrentPosition, %k_currentKey%
	ControlClick, %k_currentKey%, ahk_id %k_ID%, , LEFT, 1
	Sleep, 60
}

keyboardMoveDown(){
	k_currentKey := k_map[k_currentKey].downKey
	;GuiControl, Keyboard:, ThisString, %k_ID%
	;GuiControl, Keyboard: ,CurrentPosition, %k_currentKey%
	ControlClick, %k_currentKey%, ahk_id %k_ID%, , LEFT, 1
	Sleep, 60
}

keyboardEnter(override := ""){

	if(k_currentKey == "Caps Lock"){
		capsLockOn := !capsLockOn
	}
	else if(k_currentKey == "Shift"){
		shiftPressed := !shiftPressed
	}
	else if(k_currentKey == "Ctrl"){
		controlPressed := !controlPressed
	}
	else if(k_currentKey == "Tab"){
		Send {Tab}
	}
	else if(k_currentKey == "Fn"){
		
	}
	else if(k_currentKey == "Bk"){
		Send {Backspace}
	}
	else if(k_currentKey == "Win"){
		Send {LWin}
	}
	else if(k_currentKey == "Alt"){
		altPressed := !altPressed
	}
	else if(k_currentKey == "Enter"){
		Send {Enter}
	}
	else if(k_currentKey == "Space"){
		Send {Space}
	}
	else{
		;MsgBox % controlPressed
		if(capsLockOn == true){
			keyToSend := k_currentKey
		}
		else{
			StringLower, keyToSend, k_currentKey
		}
		keyMod =
		if(shiftPressed == true){
			keyMod = %keyMod%+
		}
		if(controlPressed == true){
			keyMod = %keyMod%^
		}
		if(altPressed == true){
			keyMod = %keyMod%!
		}
		
		Send %keyMod%%keyToSend%
		controlPressed := false
		shiftPressed := false
		altPressed := false
		/*
		if(shiftPressed == true){
			MsgBox, Should not be here
			if(controlPressed == true){
				if(altPressed == true){
					Send ^!+{%keyToSend%}
				}
				else{
					Send ^+{%keyToSend%}
				}
			}
			else{
				Send +{%keyToSend%}
			}
		}
		else{
			if(controlPressed == true){
				if(altPressed == true){
					Send ^!{%keyToSend%}
				}
				else{
					;MsgBox, It gets here
					Send ^{%keyToSend%}
				}
			}
			else{
				Send %keyModifier%{%keyToSend%}
			}
		}
		*/
		
	}
}