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

