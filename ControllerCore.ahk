/*
File: ControllerCore.ahk
Author: Austin "sind2934" Gray
Version 0.1.0
License: GPL-3.0
Repository: https://github.com/sid2934/AHK_Controller_Library.git
*/

/*
The in code comments should do a fairly decent job at explaining how everything
works. This code is FAR from optimal and is currently working as a proof of
concept and a basis for future optimization.

If you discover any instances of the code breaking please fill a issue report on
github this will allow me to get a wider testing range. If you would like to
suggest a feature please also fill out an isue report and start the title with
"Feature Suggestion:" this will help me see what should be implemented next.
*/

;Recommended for performance and compatibility with future AutoHotkey releases.
#NoEnv
;Enable warnings to assist with detecting common errors. Commment out unless there is issues
;#Warn
SendMode Input  ;Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ;Ensures a consistent starting directory.

;This Include is to include the On-Screen Keyboard Library in the code
#Include %A_ScriptDir%/Extended Library/KeyboardGUI.ahk

;Apperently this is needed for some vodoo blackmagic shit
null := 

;These globals are intended to be used for array access for the Controller state
global Buttons = 1
global Axes = 2
global Pov = 3
global Joysticks = 4

;<summary>
;This class is used to represent buttons on the controller
;</summary>
class CButton{

	;The literal id that AHK can use to access the button
	buttonId :=
	;NOT IMPLEMENTED - The common name of the button i.e. 'x', 'y', 'triangle',etc
	name :=
	;The controller number that AHK can use for access
	controllerNumber :=
	;The number that AHK uses for access
	buttonNumber :=

	;<summary
	;This is a constructor for the button class
	;The above parametes
	;</summary>
	;<param="cNumber">The controller number</param>
	;<param="bNumber">The button number</param>
	;<param="n">The common name of the button</param>
	__New(cNumber, bNumber, n){
		tempId = %cNumber%Joy%bNumber%
		this.buttonId := tempId
		this.name := n
		this.controllerNumber := cNumber
		this.buttonNumber := bNumber
	}

	;<summary
	;returns the key state of the button (0 if not pressed - 1 if pressed)
	;</summary>
	state {
		get{
			return GetKeyState(this.buttonId)
		}
	}
}

;<summary>
;This class is used to represent axes on the controller
;</summary>
class CAxes{

	;The literal id that AHK can use to access the axis
	axisId :=
	;The common name for the axis
	name :=
	;The controller number that AHK can use for access
	controllerNumber :=
	;The offset needed to make the axes default position equal to zero.
	offset :=

	;<summary
	;This is a constructor for the button class
	;</summary>
	;<param="cNumber">The controller number</param>
	;<param="aLetter">The axis letter</param>
	;<param="n">The common name of the axis</param>
	__New(cNumber, aLetter, o, n){
		tempId = %cNumber%Joy%aLetter%
		this.axisId := tempId
		this.name := n
		this.controllerNumber := cNumber
		this.offset := o
	}

	;<summary
	;returns the state of the axis (0-100)
	;</summary>
	state {
		get{
			return (GetKeyState(this.axisId) + this.offset)
		}
	}
}

;<summary>
;This class is used to bid two axis together and make a joystick
;</summary>
class CJoystick{

	;The axis object for the X axis of the joystick
	axisX :=
	;The axis id for the X axis of the joystick
	axisXId :=
	;The axis object for the Y axis of the joystick
	axisY :=
	;The axis id for the Y axis of the joystick
	axisYId :=
	;The common name of the joystick i.e. 'Right Stick'
	name :=
	;The controller number that AHK can use for access
	controllerNumber :=
	;This is used to invert the results of the X Axis
	;Explanation:
	;This has multiple uses, first it can be used to correct the readings of the 
	;joystick state. Second it can be used to implement a inverted axis in the 
	;end script. This was implemented here so that it could be used for the first
	;reason. The xbox needs to have the Y Axis inverted for proper reading of angles.
	invertX :=
	;This is used to invert the results of the Y Axis
	invertY :=

	;<summary
	;This is a constructor for the joystick class
	;</summary>
	;<param="cNumber">The controller number</param>
	;<param="axX">The axis object of the joystick's X axis</param>
	;<param="axY">The axis object of the joystick's Y axis</param>
	;<param="n">The common name of the joystick</param>
	;<param="invX">Whether to invert the X axis or not</param>
	;<param="invY">Whether to invert the X axis or not</param>
	__New(cNumber, axX, axY, n, invX := false, invY := false){
		this.controllerNumber := cNumber
		this.axisX := axX
		this.axisY := axY
		this.axisXId := this.axisX.axisId
		this.axisYId := this.axisY.axisId
		this.name := n
		this.invertX := invX
		this.invertY := invY
	}

	;<summary
	;This function is used to retun the current angle the joystick is making
	;implement my not be the best its been a while since I used triganometry
	;</summary>
	angle(){
		;if the x axis needs to be inverted invX is set to -1 as a modifier
		if(this.invertX == true){
			invX := -1
		}
		else{
			invX := 1
		}
		;same as above statment for the y axis
		if(this.invertY == true){
			invY := -1
		}
		else{
			invY := 1
		}
		;This is where the inversion happens by multiplying the  m
		xCoord := this.axisX.state * invX
		yCoord := this.axisY.state * invY
		;This next if statment is used to determine what Cartesian Quadrants the
		;point created by the joystick state is in.
		;https://en.wikipedia.org/wiki/Quadrant_(plane_geometry)
		if(xCoord > 0){
			if(yCoord > 0){
				quadrant := "firstQuadrant"
				quadModifier := 0
			}
			else if(yCoord < 0){
				quadrant := "forthQuadrant"
				quadModifier := -360
			}
			else{
				return 0
			}
		}
		else if(xCoord < 0){
			if(yCoord > 0){
				quadrant := "secondQuadrant"
				quadModifier := (-180)
			}
			else if(yCoord < 0){
				quadrant := "thirdQuadrant"
				quadModifier := 180
			}
			else{
				return 180
			}
		}
		;This else handles the literal edge cases where xCoord == 0
		else{
			if(yCoord > 0){
				return 90
			}
			else if(yCoord < 0){
				return 270
			}
		}
		;This function generates a positive angle from 0 - 359 that is equal to
		;the angle of the joystick in relation to the origin of the controller
		;atan functions as tan^-1
		return Abs(Abs(Atan(yCoord/xCoord) * (180/3.1415)) + quadModifier)
	}

	;<summary
	;This function is used to retun the current magnitude the joystick is making
	;Thi simply returns the distance from the (0,0)
	;</summary>
	magnitude(){
		xCoord := this.axisX.state
		yCoord := this.axisY.state
		;This is simply the distance equation in 2D
		;http://www.purplemath.com/modules/distform.htm
		return sqrt((xCoord)**2 +  (yCoord)**2)
	}

	;<summary
	;returns a AHK associative array with "Angle" and "Magnitude" as keys
	;https://autohotkey.com/docs/Objects.htm#Usage_Associative_Arrays
	;</summary>
	state{
		get{
			return {"Angle": this.angle() , "Magnitude": this.magnitude()}
		}
	}

}

;<summary
;This class is used to make the controller POV(hat) controlles
;This is the D-Pad for xbox controllers
;</summary>
class CPov{

	;This literal ID that the script calls to access the control
	povID :=
	;The common name of the pov i.e. D-Pad
	name :=
	controllerNumber :=

	;<summary
	;This is the constructor for the POV  class
	;</summary>
	;<param="cNumber">The controller number</param>
	;<param="n">The common name for the POV control</param>
	__New(cNumber, n){
		tempId = %cNumber%JoyPOV
		this.povId := tempId
		this.name := n
		this.controllerNumber := cNumber
	}

	;<summary
	;Returns the state of the POV control
	;</summary>
	state{
		get{
			return GetKeyState(this.povId)
		}
	}
}

;<summary
;This is the larges class and implements the other classes automatically when called
;This is where most of the "magic" happens
;</summary>
class Controller{

	;The number of the controller (different for each instance)
	controllerNumber :=
	;The name of the controller is determined when the constructor is called
	;This is usually the name of the driver used by the controller
	controllerName :=
	;This is the number of buttons the controller has
	;i.e. The xbox 360 controller has 10
	numberOfButtons :=
	;This is the number of axis the controller has
	;i.e. The xbox 360 controller has 5 - 2 for each joystick and the triggers are seen as an axis
	numberOfAxes := 0
	;This is the number of joysticks the controller has
	;unlike the others this is NOT determined by default and just be done manually for now
	;I am looking into making a doc with common controllers and having the class look at the
	;doc for the controller and making the joysticks automatically
	;This number is increased each time the createJoystick function is called
	numberOfJoysticks := 0
	;This can be though of as an array of the buttons where contollerButtons[x] is the object of button x
	controllerButtons := Object()
	;This can be though of as an array of the axes where controllerAxes[x] is the object of an axis
	;The axes dont used letters so the for each axis the contorller has it follows that XYZRUV are the order they occur in
	;so if there is 4 axes the 1 - X, 2 - Y, 3 - Z, 4 - R.
	controllerAxes := Object()
	;This is the controller POV it is technically an array like the others but only one pov can be on a controller at a time
	controllerPov := Object()
	;This can be though of as an array of the joysticks where controllerJoysticks[x] is the first joystick created
	;NOT used by default must be manually used
	controllerJoysticks := Object()
	;This is the queue that will be used to trigger button events
	;This is created in the config.ini file under the "Button Config Section" using a standard csv format with the following format
	; Keys,Function To Call
	; The Keys are seperated with foward slashes and the function must be implemented before the script will launch.
	; Examples:
	; 2/3/4, 2_3_4_Event
	; 1, 1_Event
	; 3/5, 3_5_Event
	controllerButtonQueue := new ButtonQueue()
	;This is the previous State of the controller. This is used when handling double/long button presses
	previousControllerState :=
	;This is the current method for handling the joystick event calls
	joystickQueue := new Queue()
	;This queue is used to  store the pov action that are defined in the config.ini file under the "POV Config" Section
	povDict := new Dictionary()
	;This queue is used to  store the axes action that are defined in the config.ini file under the "Axes Config" Section
	;Any Axes that has been added to a joystick will be ignored in this section
	axesQueue := new Queue()

	;<summary
	;This is a constructor for the controller class
	;</summary>
	;<param="joystickNumber">The number of joystick for make a controller object for. Leave blank if not sure and will auto-detect the first controller</param>
	__New(configPath := "", joystickNumber := 0){
	
		;The IniRead(s) here are to determine if each set of the controller
		;Is enabled. If not enabled the sub config sections will not be read for 
		;that control.
		;https://autohotkey.com/docs/commands/IniRead.htm
		IniRead, buttonEnabled, %configPath%, General, Buttons_Enable
		IniRead, joystickEnabled, %configPath%, General, Joysticks_Enable
		IniRead, povEnabled, %configPath%, General, Pov_Enabled
		IniRead, axesEnable, %configPath%, General, Axes_Enabled

		;The section to read in the button sub config section if buttons are enabled
		if(buttonEnabled == true ){
			;ToDo - get rid of the redundant boolean and just use buttonEnabled, etc
			checkButtonsImplementation := true
			;Reads the "Button Config" sub config in the config.ini file
			IniRead, buttonConfigSection, %configPath%, Button Config
			;If the section is empty of not found then the IniRead will set
			;buttonConfigSection to ""
			if(buttonConfigSection == ""){
			MsgBox, BUTTONS DISABLED `nNo button config file was specified. Cannot use buttons without a Button Config Section
			checkButtonsImplementation := false
			}
			else{
				;Loops through one line of the section at a time
				Loop, Parse, buttonConfigSection, "`n"
				{
					;A_LoopField is a built in variable and is set each iteration
					;of the loop with the contents of the next line
					;controllerButtonQueue.AddCombo in the function itself
					this.controllerButtonQueue.AddCombo(A_LoopField)
				}
			}
		}
		else{
			checkButtonsImplementation := false
		}

		;The section to read in the joystick sub config section if joystick are enabled
		if(joystickEnabled == true ){
			;ToDo - get rid of the redundant boolean and just use joystickEnabled, etc
			checkJoystickImplementation := true
			;Reads the "Joystick Config" sub config in the config.ini file
			IniRead, joystickConfigSection, %configPath%, Joystick Config
			;If the section is empty of not found then the IniRead will set
			;joystickConfigSection to ""
			if(joystickConfigSection == ""){
			MsgBox, Joysticks DISABLED `nNo joystick config section was specified. Cannot use joysticks without a Joystick Config Section
			checkJoystickImplementation := false
			}
			else{
				;Loops through each line of the joystickConfigSection section
				Loop, Parse, joystickConfigSection, `n
				{
					;This adds a new joystick to the joystick queue
					;More documentation is in "class joystickConfigSection()"
					temp := new axes_joystickTrigger(A_LoopField)
					this.joystickQueue.Enqueue(temp)
				}
			}
		}
		else{
			checkJoystickImplementation := false
		}

		;The section to read in the pov sub config section if pov are enabled
		if(povEnabled == true){
			;ToDo - get rid of the redundant boolean and just use povEnabled, etc
			checkPovImplementation := true
			;Reads the "POV Config" sub config in the config.ini file
			IniRead, povConfigSection, %configPath%, POV Config
			;If the section is empty of not found then the IniRead will set
			;povConfigSection to ""
			if(povConfigSection == ""){
				MsgBox, POV DISABLED `nNo pov config section was specified. Cannot use joysticks without a POV Config Section
				checkPovImplementation := false
			}
			else{
				;This loops through each line of the povConfigSection
				Loop, Parse, povConfigSection, `n
				{
					;This allows the StringSplit Function to be 
					loopString = %A_LoopField%
					;This built in function splits the loopString string into
					;a sudo array called output using a comma as the delimeter
					;https://autohotkey.com/docs/commands/StringSplit.htm
					StringSplit, output, loopString, "`,"
					value := output1
					function := output2
					;This adds the value and function to the povDict.
					;povDict is an instance of the partial Dictionary class
					;that I created because the AHK associative arrays were not
					;working as I liked
					this.povDict.Add(value,function)
				}
			}
		}
		else{
			checkPovImplementation := false
		}

		;The section to read in the axes sub config section if axes are enabled
		if(axesEnable == true){
			;ToDo - get rid of the redundant boolean and just use axesEnable, etc
			checkAxesImplementation := true
			;Reads the "Axes Config" sub config in the config.ini file
			IniRead, axesConfigSection, %configPath%, Axes Config
			;If the section is empty of not found then the IniRead will set
			;axesConfigSection to ""
			if(axesConfigSection == ""){
				MsgBox, Axes DISABLED `nNo axes config section was specified. Cannot use joysticks without a Axes Config Section
				checkAxesImplementation := false
			}
			else{
				;Loops through each of the lines in the axesConfigSection section
				Loop, Parse, axesConfigSection, `n
				{
					;This Enqueues a new axes_joystickTrigger into axesQueue
					;More documentation for Enqueue is in the "class" Queue 
					;found below
					temp := new axes_joystickTrigger(A_LoopField)
					this.axesQueue.Enqueue(temp)
				}
			}
		}
		else{
			checkAxesImplementation := false
		}

		;This calls the implementationCheck function with the params to ensure
		;that all functions specified in the config.ini file are implemented in
		;the code.
		this.implementationCheck(checkButtonsImplementation, checkJoystickImplementation, checkPovImplementation, checkAxesImplementation)

		;Finds the joystick if not specified as a parameter
		;This code below is modified from the Joy Test.ahk file provided here
		;https://autohotkey.com/docs/scripts/JoystickTest.htm
		if(joystickNumber <= 0){
			Loop 16  ; Query each joystick number to find out which ones exist.
			{
				GetKeyState, JoyName, %A_Index%JoyName
				this.controllerName := JoyName
				if (JoyName <> null)
				{
					this.controllerNumber :=  A_Index
					break
				}
			}
			if (this.controllerNumber <= 0)
			{
				MsgBox, The system does not appear to have any joysticks.
				ExitApp
			}
			else{
				JoystickNumber := this.controllerNumber
				GetKeyState, outVar, %JoystickNumber%JoyButtons
				this.numberOfButtons := outVar
				GetKeyState, outVar, %JoystickNumber%JoyName
				this.controllerName := outVar
				GetKeyState, joy_info, %JoystickNumber%JoyInfo

				nButtons := this.numberOfButtons
				;Loop for each button to make a button object and add it to controllerButtons
				Loop %nButtons%
				{
					;This adds a new button object to the controllerButtons Array
					;for every button the controller has
					;ToDo - Implement the button name so that either the user or
					;a list of common controllers can populate that field
					newButton := new CButton(this.controllerNumber, A_Index, "NeedsAdded")
					this.controllerButtons.Push(newButton)
				}


				;Axes and POV's
				;This section simply adds the axes/pov control to its respective
				;field if it exists. For a more clear look at the method used
				;open the Joy Test.ahk file
				;https://autohotkey.com/docs/scripts/JoystickTest.htm
				GetKeyState, joy_info, %JoystickNumber%JoyInfo
				GetKeyState, joy_axes, %JoystickNumber%JoyAxes
				this.numberOfAxes := joy_axes
				cNumber := this.controllerNumber
				GetKeyState, tempOffset, %cNumber%JoyX
				newAxis := new CAxes(this.controllerNumber, "X", (0 - tempOffset), "X")
				this.controllerAxes.Push(newAxis)
				GetKeyState, tempOffset, %cNumber%JoyY
				newAxis := new CAxes(this.conxtrollerNumber, "Y", (0 - tempOffset), "Y")
				this.controllerAxes.Push(newAxis)

				IfInString, joy_info, Z
				{
					GetKeyState, tempOffset, %cNumber%JoyZ
					newAxis := new CAxes(this.controllerNumber, "Z",(0 - tempOffset), "Z")
					this.controllerAxes.Push(newAxis)
				}
				IfInString, joy_info, R
				{
					GetKeyState, tempOffset, %cNumber%JoyR
					newAxis := new CAxes(this.controllerNumber, "R", (0 - tempOffset), "R")
					this.controllerAxes.Push(newAxis)
				}
				IfInString, joy_info, U
				{
					GetKeyState, tempOffset, %cNumber%JoyU
					newAxis := new CAxes(this.controllerNumber, "U", (0 - tempOffset), "U")
					this.controllerAxes.Push(newAxis)
				}
				IfInString, joy_info, V
				{
					GetKeyState, tempOffset, %cNumber%JoyV
					newAxis := new CAxes(this.controllerNumber, "V", (0 - tempOffset), "V")
					this.controllerAxes.Push(newAxis)
				}
				IfInString, joy_info, P
				{
					newPov := new CPov(this.controllerNumber, "POV", "POV")
					this.controllerPov := newPov
				}
			}
		}
	}


	implementationCheck(b, j, p, a){
		if(b == true){
				buttonEvents := this.controllerButtonQueue.queue.Size
				loop %buttonEvents%{
					currentQueue := this.controllerButtonQueue.queue.queue[A_Index]
					currentFunction := currentQueue.eventHandler
					if(IsFunc(currentFunction) == false){
						MsgBox % currentFunction "() Does not exist"
					}
				}
		}
		if(j == true){
			joystickEvents := this.joystickQueue.Size
			loop %joystickEvents%{
				currentQueue := this.joystickQueue.queue[A_Index]
				currentFunction := currentQueue.eventHandler
				if(IsFunc(currentFunction) == false){
					MsgBox % currentFunction "() Does not exist"
				}
			}
		}

		if(p == true){
			numberOfPovEvents := this.povDict.Size
			Loop %numberOfPovEvents%{
				currentFunction := this.povDict.valueOf(this.povDict.getKeyFromInt(A_Index))
				if(IsFunc(currentFunction) == false){
					MsgBox % currentFunction "() Does not exist"
				}
			}
		}

		if(a == true){
			axesEvents := this.axesQueue.Size
			loop %axesEvents%{
				currentQueue := this.axesQueue.queue[A_Index]
				currentFunction := currentQueue.eventHandler
				if(IsFunc(currentFunction) == false){
					MsgBox % currentFunction "() Does not exist"
				}
			}
		}
	}


	;<summary
	;Returns a comma seperated string of the buttons that are pressed in the given range
	;Leave params blank to get all buttons
	;</summary>
	;<param="start">The first button to look at</param>
	;<param="last">The last button to look at</param>
	buttonState(start := 1, last := -1){
		if(last == -1){
			last := this.numberOfButtons
		}
		counter := start
		dif := (last + 1) - start
		returnObject := Object()
		loop %dif%
		{
			returnObject[counter] := this.controllerButtons[counter].state
			counter++
		}
		return returnObject
	}

	;<summary
	;Returns a comma seperated string of the state of the axis in the given range
	;Leave params blank to get all buttons
	;</summary>
	;<param="start">The first axis to look at</param>
	;<param="last">The last axis to look at</param>
	axesState(start := 1,  last := -1){
		if(last == -1){
			last := this.numberOfAxes
		}
		counter := start
		dif := (last + 1) - start

		returnArray := Object()

		Loop %dif%{
			currentValue := this.controllerAxes[counter].state
			returnArray.Push(currentValue)
			counter++
		}
		return returnArray

	}

	;<summary
	;Returns the state of the controller POV
	;</summary>
	povState(){
		return this.controllerPov.state
	}

	;<summary
	;Returns a comma seperated string of the state of the sticks in the given range
	;Leave params blank to get all buttons
	;</summary>
	;<param="start">The first joystick to look at</param>
	;<param="last">The last joystick to look at</param>
	joystickState(start := 1,  last := -1){
		if(last == -1){
			last := this.numberOfJoysticks
		}
		counter := start
		dif := (last + 1) - start

		returnArray := Object()

		Loop %dif%{
			currentValue := this.controllerJoysticks[counter].state
			returnArray.Push(currentValue)
			counter++
		}
		return returnArray
	}

	;<summary
	;This function is called to create a joystick given a list of params
	;This is currently in testing and should remove the axes from the axes array that are added into the joystick array
	;</summary>
	;<param="axX">The array index for the joystick's X axis</param>
	;<param="axY">The array index for the joystick's Y axis/param>
	;<param="n">The common name of the joystick</param>
	;<param="invX">Whether to invert the X axis or not</param>
	;<param="invY">Whether to invert the X axis or not</param>
	createJoystick(axX, axY, n, invX := false, invY := false){
		this.numberOfJoysticks++
		newJoy := new CJoystick(this.controllerNumber, this.controllerAxes[axX], this.controllerAxes[axY], n, invX, invY)
		this.controllerAxes[axX] := "ignore"
		this.controllerAxes[axY] := "ignore"
		this.controllerJoysticks.Push(newJoy)
	}

	;<summary
	;Returns a csv styke result of the state of all the control types. Buttons, Axes, POV, Joystick
	;</summary>
	state{
		get{
			returnArray := Object()
			returnArray.Push(this.buttonState())
			returnArray.Push(this.axesState())
			returnArray.Push(this.povState())
			returnArray.Push(this.joystickState())
			return returnArray
		}
	}

	update{
		get{
			currentState := this.state
			this.buttonHandler(currentState[Buttons])
			this.axesHandler(currentState[Axes])
			this.povHandler(currentState[POV])
			this.joystickHandler(currentState[Joysticks])
			this.previousState := currentState

		}
	}

	;<summary
	;This method is called when the controller is updated. It handles the button states
	;This method calls the user defined functions that are given and stored in the controllerButtonQueue object.
	;</summary>
	;<param="pressedButtons">The state of all buttons at the time of the current cycle</param>
	buttonHandler(pressedButtons){
		numberOfCombos :=  this.controllerButtonQueue.queue.Size
		loop %numberOfCombos%{
			buttonsMatch := true
			currentQueue := this.controllerButtonQueue.queue.queue[A_Index]
			currentCheckKeys := currentQueue.trigger
			StringSplit, currentCheckKeys, currentCheckKeys, /
			currentNumberOfKeys := currentQueue.numberOfKeys

			loop %currentNumberOfKeys%{
				if(pressedButtons[currentCheckKeys%A_Index%] == false){
					buttonsMatch := false
					break
				}
			}
			if(buttonsMatch == true){
				loop %currentNumberOfKeys%{
					pressedButtons[currentCheckKeys%A_Index%] := false
					functionToCall := currentQueue.eventHandler
				}
				if(currentQueue.lastCycleState == true){
					if(currentQueue.timerStatus == false){
						currentQueue.KillTimer()
						%functionToCall%("long")
					}
				}
				else if(currentQueue.lastCycleState == false){
					if(currentQueue.timerStatus == true){
						currentQueue.KillTimer()
						%functionToCall%("double")
					}
					else{
						currentQueue.StartTimer()
					}
				}
				currentQueue.lastCycleState := true
			}
			else{
				if(currentQueue.lastCycleState == true){
					currentQueue.released := true
				}
				currentQueue.lastCycleState := false
			}
		}

	}

	axesHandler(axesState){
		nOfAxes := this.numberOfAxes
		Loop %nOfAxes%
		{
			currentQueue :=this.axesQueue.queue[A_Index]
			currentAxis :=  axesState[currentQueue.trigger]
			currentDeadzone := currentQueue.deadzone
			if(currentDeadzone <= currentAxis){
				functionToCall := currentQueue.eventHandler
				mag := currentAxis.state  - currentDeadzone
				%functionToCall%(mag)
			}
		}
	}


	povHandler(povState){
		if(povState != -1){

			functionToCall := this.povDict.valueOf(povState)
			if(functionToCall != ""){
				%functionToCall%()
			}
		}
	}

	;In development
	joystickHandler(joystickState){
		numberOfJoy := this.numberOfJoysticks
		Loop %numberOfJoy%
		{
			currentQueue :=this.joystickQueue.queue[A_Index]
			currentButton :=  joystickState[currentQueue.trigger]
			currentDeadzone := currentQueue.deadzone
			if(currentDeadzone <= currentButton.Magnitude){
				functionToCall := this.joystickQueue.queue[A_Index].eventHandler
				angle := currentButton.Angle
				mag := currentButton.Magnitude  - currentDeadzone
				%functionToCall%({"Angle": angle, "Magnitude": mag})
			}
		}
	}
}


/*
all of the classes below this are used in aiding or implementing the controller
class. Some are ahk implementations of common data structures, others are partial
implementations of custom structures ot make code (arguably) easier to read/write
*/

;<summary>
;This class is used to generate event triggers for the axes and joystick controls
;</summary>
class axes_joystickTrigger{
	joystickNumber :=
	deadzoneRadius :=
	function :=
	
	;<summary>
	;
	;</summary>
	;<param=""></param>
	__New(csvLine){
		StringSplit, output, csvLine, "`,"
		this.joystickNumber := output1
		this.deadzoneRadius := output2
		this.function := output3
	}

	trigger{
		get{
			return this.joystickNumber
		}
	}

	deadzone{
		get{
			return this.deadzoneRadius
		}
	}

	eventHandler{
		get{
			return this.function
		}
	}
}

class buttonTrigger{
	keys :=
	numberKeys :=
	function :=
	pressedLastCycle :=
	timerRunning :=
	clickModifyTimer :=
	releasedOnTimer :=

	__New(k, f){
		this.keys := k
		;gets the number of times a char occurs in a string
		StringReplace, k, k, /,, UseErrorLevel
		this.numberKeys := ErrorLevel + 1
		this.function := f
		this.pressedLastCycle := false
		this.timerRunning :=false
		this.clickModifyTimer := ObjBindMethod(this, "StopTimer")
		this.releasedOnTimer := false
	}

	trigger{
		get{
			return this.keys
		}
	}

	released{
		set{
			return this.releasedOnTimer := value
		}
	}

	numberOfKeys{
		get{
			return this.numberKeys
		}
	}

	eventHandler{
		get{
			return this.function
		}
	}

	lastCycleState{
		get{
			return this.pressedLastCycle
		}
		set{
			return this.pressedLastCycle := value
		}
	}

	timerStatus{
		get{
			return this.timerRunning
		}
	}


	StartTimer(){
		;MsgBox, Timer Start
		this.timerRunning := true
		this.releasedOnTimer := false
		temp := this.clickModifyTimer
		SetTimer, %temp% , -300
	}

	StopTimer(){
		functionToCall := this.eventHandler
		if(this.releasedOnTimer == false){
			%functionToCall%("long")
		}
		else{
			%functionToCall%("single")
		}
		this.releasedOnTimer := false
		this.timerRunning := false
		temp := this.clickModifyTimer
		SetTimer, % temp, Off
	}

	;This is used to kill the timer if another event i.e. double or long press triggers it
	KillTimer(){
		this.releasedOnTimer := false
		this.timerRunning := false
		temp := this.clickModifyTimer
		SetTimer, % temp, Off
	}

}

class ButtonQueue{

	__New(){
		this.queue := new Queue()
	}

	AddCombo(csvLine){
		StringSplit, output, csvLine, "`,"
		newTrigger := new buttonTrigger(output1, output2)
		queueLength := this.queue.Size
		if(queueLength == 0){
			this.queue.Enqueue(newTrigger)
		}
		else{
			loop %queueLength%{
				tempQueueLocation := this.queue.queue[A_Index]
				x := tempQueueLocation.numberOfKeys
				y := newTrigger.numberOfKeys
				if(x <y){
					this.queue.Insert(newTrigger, A_Index)
				}
				else if(A_Index == queueLength){
					this.queue.Enqueue(newTrigger)
				}
			}
		}
	}

}

class Queue{

	queue := Object()
	count := 0

	__New{

	}

	Enqueue(data){
		this.count++
		this.queue.InsertAt(this.count, data)
	}

	Insert(data, location){
		this.count++
		this.queue.InsertAt(location, data)
	}

	Swap(locationA, locationB){
		dataOfA := this.queue(locationA)
		dataOfB := this.queue(locationB)
		this.queue[locationA] := dataOfB
		this.queue[locationB] := dataOfA
	}

	Dequeue(){
		if(this.count > 0){
			this.count--
			returnValue := this.queue[1]
			this.queue.RemoveAt(1)
			return returnValue
		}
		else{
			return null
		}
	}

	IsEmpty{
		get{
			return (0 == this.count)
		}
	}

	Size{
		get{
			return this.count
		}
	}

}

class Dictionary{

	__New(){
		if(startingContents == ""){
			this.contents := startingContents
			this.size := 0
			this.keys := Object()
		}
		else{
			;All of this needs to be added
			;ToDo: This entire struct pretty much lol
			startingContents := startingContents "|"
			MsgBox % startingContents
			this.contents :=startingContents
			StringReplace, startingContents, startingContents, |,, UseErrorLevel
			this.size := ErrorLevel
		}
	}

	Add(key, value){
		oldContents := this.contents
		newContent =  %oldContents%%key%:%value%|
		this.contents := newContent
		x := this.contents
		this.size++
		this.keys.Push(key)
	}

	Remove(){
		MsgBox, Needs to be added
	}

	Size{
		get{
			return this.size
		}
	}

	getKeyFromInt(int){
		return this.keys[int]
	}


	valueOf(key) {
		dictName := this.contents
		keyPos := InStr(dictName,key)
		dictStr2 := SubStr(dictName,keyPos)
		IfInString , dictStr2 , |
		{
			endPos := InStr(dictStr2, "|")
		}else{
			endPos := StrLen(dictStr2)+1
		}
		startPos := StrLen(key)+2
		returnValue := SubStr(dictStr2,startPos,(endPos-startPos))
		return returnValue
	}

}
