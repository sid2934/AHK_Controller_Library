#SingleInstance

#Include %A_ScriptDir%/ControllerCore.ahk

;Creates a controller from the first joystick detected
Controller := new Controller("C:\Users\austi\Documents\GitHub\AHK_Controller_Library\config.ini")
;Binds two axes to a single "Joystick"
;MsgBox % Controller.numberOfAxesoo
Controller.createJoystick(1, 2, "Left", false, true)
Controller.createJoystick(5, 4, "Right", false, true)
;MsgBox % Controller.numberOfAxes

FileDelete, log.csv

Loop{
	Controller.update
}

1_Event(param){
	if(param == "long"){
		Send {LButton Down}
	}
	else{
		Send {LButton}
	}
}

2_Event(){
	if(keyboardIsOpen==true){
		keyboardEnter("Backspace", "Bk")
	}
	else{
		Send {RButton}
	}
}

3_Event(){
	MsgBox, Hello Tarra
}

4_Event(){
	MouseMove, 0, -1,, R
}

1_2_3_4_Event(){
	MsgBox, Damn Straight
}

9_Event(param){
	if(param == "double" || param == "long"){
		toggleKeyboard()
	}
	else{
		if(keyboardIsOpen == true){
			keyboardEnter()
		}
	}
}

Left_Stick_Event(state){
	deg := state.Angle
	lenght := state.Magnitude
	radian  :=  deg*0.0174532925
	MouseGetPos, mx, my
	my2:= -(sin(radian)*lenght)/10
	mx2:= (cos(radian)*lenght)/10
	MouseMove, %mx2%, %my2%, 10, R
}

Right_Stick_Event(state){
	deg := state.Angle
	mag := state.Magnitude
	Send {Up up}{Down up}{Left up}{Right Up}
	if(mag >= 10){
		if(deg >= 45 && deg <= 135){
			Send {Up down}
		}
		else if(deg > 135 && deg < 225){
			Send {Left down}
		}
		else if(deg >= 225 && deg <= 315){
			Send {Down down}
		}
		else{
			Send {Right down}
		}
	}
}


povLeft_Event(){
	if(keyboardIsOpen == true){
		keyboardMoveLeft()
	}
	else{
		Send {f1}
	}
}

povRight_Event(){
	if(keyboardIsOpen == true){
		keyboardMoveRight()
	}
	else{
		Send {f2}
	}
}

povUp_Event(){
	if(keyboardIsOpen == true){
		keyboardMoveUp()
	}
	else{
		Send {esc}
	}
}

povDown_Event(){
	if(keyboardIsOpen == true){
		keyboardMoveDown()
	}
	else{
		Send {f3}
	}
}

Trigger_Event(){
}

log(msg){
	FileAppend, %A_TickCount%`,%msg%`n, log.csv
}