#Include ControllerCore.ahk

;Creates a controller from the first joystick detected
Controller := new Controller()
;Binds two axes to a single "Joystick"
Controller.createJoystick(1, 2, "Left", 50, 50, false, true)
Controller.createJoystick(5, 4, "Right", 50, 50, false, true)
Loop{
	t := Controller.state
	MsgBox % t[Buttons]
	;This is the main loop of the program
}

ButtonHandler(buttonState){
	if(){
		
	}
	
}

