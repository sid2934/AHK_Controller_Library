#SingleInstance
#Include ControllerCore.ahk

;Creates a controller from the first joystick detected
Controller := new Controller(,true,"D:/Users/austi/Desktop/AHK Git/AHK_Controller_Library/buttonConfig.csv")
;Binds two axes to a single "Joystick"
Controller.createJoystick(1, 2, "Left", 50, 50, false, true)
Controller.createJoystick(5, 4, "Right", 50, 50, false, true)

Loop{
	Controller.update
	;This is the main loop of the program
}

1_Event(){
	MouseMove, 0, 1,, R
}

2_Event(){
	MouseMove, 1, 0,, R
}

3_Event(){
	MouseMove, -1, 0,, R
}

4_Event(){
	MouseMove, 0, -1,, R
}

1_2_3_4_Event(){
	MsgBox, Damn Straight
}
