#SingleInstance
#Include ControllerCore.ahk

;Creates a controller from the first joystick detected
Controller := new Controller(,true,"D:/Users/austi/Desktop/AHK Git/AHK_Controller_Library/buttonConfig.csv", true, "D:/Users/austi/Desktop/AHK Git/AHK_Controller_Library/joystickConfig.csv")
;Binds two axes to a single "Joystick"
;MsgBox % Controller.numberOfAxes
Controller.createJoystick(1, 2, "Left", false, true)
Controller.createJoystick(5, 4, "Right", false, true)
;MsgBox % Controller.numberOfAxes

FileDelete, log.csv

Loop{
	Controller.update
	;array2 := (Controller.state)[4]
	;ajoy1 := array2[1]
	;MsgBox % ajoy1.Angle ", " ajoy1.Magnitude
	;This is the main loop of the program
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
	Send {RButton}
}

3_Event(){
}

4_Event(){
	MouseMove, 0, -1,, R
}

1_2_3_4_Event(){
	MsgBox, Damn Straight
}

9_Event(param){
	if(param == "double" || param == "long"){
		OpenKeyboard()
	}
}

Left_Stick_Event(state){
	deg := state.Angle
	lenght := state.Magnitude
	radian  :=  deg*0.0174532925
	MouseGetPos, mx, my
	my2:= -(sin(radian)*lenght)/2
	mx2:= (cos(radian)*lenght)/2
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

log(msg){
	FileAppend, %A_TickCount%`,%msg%`n, log.csv
}