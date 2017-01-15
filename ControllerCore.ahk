#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Enable warnings to assist with detecting common errors. Commment out unless there is issues
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
CoordMode, Mouse, Screen ;Sets the Coordinate Mode for all "Mouse" methods

;This simply adds some readibility for my sake
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
	
	;<summary
	;This is a constructor for the button class
	;</summary>
	;<param="cNumber">The controller number</param>
	;<param="aLetter">The axis letter</param>
	;<param="n">The common name of the axis</param>
	__New(cNumber, aLetter, n){
		tempId = %cNumber%Joy%aLetter%
		this.axisId := tempId
		this.name := n
		this.controllerNumber := cNumber
	}
	
	;<summary
	;returns the state of the axis (0-100)
	;</summary>
	state {
		get{
			return GetKeyState(this.axisId)
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
	;The needed offset to make the default location appear as 0 for the X axis
	;Explanation:
	;This and yOffset are used to make the resting location of the joystick appeat as (0,0)
	;For example the Xbox controller rests at the middle of its range so the offset is 50
	;for both x and y. This must be correct in order for the state, angle, magnitude functions
	;to work properly.
	xOffset :=
	;The needed offset to make the default location appear as 0 for the Y axis
	yOffset :=
	;This is used to invert the results of the X Axis
	;Explanation:
	;This has multiple uses, first it can be used to correct the readings of the joystick state.
	;Second it can be used to implement a inverted axis in the end script. This was implemented
	;here so that it could be used for the first reason. The xbox needs to have the Y Axis inverted
	;for proper reading of angles.
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
	;<param="xO">The X offset</param>
	;<param="yO">The Y offset</param>
	;<param="invX">Whether to invert the X axis or not</param>
	;<param="invY">Whether to invert the X axis or not</param>
	__New(cNumber, axX, axY, n, xO := 0, yO := 0, invX := false, invY := false){
		this.controllerNumber := cNumber
		this.axisX := axX
		this.axisY := axY
		this.axisXId := this.axisX.axisId
		this.axisYId := this.axisY.axisId
		this.name := n
		this.xOffset := xO
		this.yOffset := yO
		this.invertX := invX
		this.invertY := invY
	}
	
	;<summary
	;This function is used to retun the current angle the joystick is making
	;implement my not be the best its been a while since I used triganometry
	;</summary>
	angle(){
		if(this.invertX == true){
			invX := -1
		}
		else{
			invX := 1
		}
		if(this.invertY == true){
			invY := -1
		}
		else{
			invY := 1
		}		
		xCoord := (this.axisX.state - this.xOffset) * invX 
		yCoord := (this.axisY.state - this.yOffset) * invY
		
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
		else{
			if(yCoord > 0){
				return 90
			}
			else if(yCoord < 0){
				return 270
			}
			else{
				return 0
			}
		}
		return Abs(Abs(Atan(yCoord/xCoord) * (180/3.1415)) + quadModifier)
	}
	
	;<summary
	;This function is used to retun the current magnitude the joystick is making
	;Thi simply returns the distance from the (0,0) 
	;</summary>
	magnitude(){
		xCoord := this.axisX.state - this.xOffset 
		yCoord := this.axisY.state - this.yOffset
		
		return sqrt((xCoord)**2 +  (yCoord)**2)
	}
	
	;<summary
	;returns a string with angle and magnitude. i.e. "[91.25,42.26]"
	;</summary>
	state{
		get{
			return "["this.angle()","this.magnitude()"]"
		}
	}
	
}

;<summary
;This class is used to make the controller POV(hat) controlles
;This is the D-Pad for xbox controllers
;</summary>
class CPov{

	povID :=
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
	;This is the number of joysricks the controller has
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
	
	;<summary
	;This is a constructor for the controller class
	;</summary>
	;<param="joystickNumber">The number of joystick for make a controller object for. Leave blank if not sure and will auto-detect the first controller</param>
	__New(joystickNumber := 0){
		
		this.implementationCheck()
		
		;find the joystick if not set
		if(joystickNumber <= 0)
		{
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
					newButton := new CButton(this.controllerNumber, A_Index, "NeedsAdded")
					this.controllerButtons.Push(newButton)
				}
				
				
				;Axes and POV's
				GetKeyState, joy_info, %JoystickNumber%JoyInfo
				GetKeyState, joy_axes, %JoystickNumber%JoyAxes
				this.numberOfAxes := joy_axes
				newAxis := new CAxes(this.controllerNumber, "X", "X")
				this.controllerAxes.Push(newAxis)
				newAxis := new CAxes(this.conxtrollerNumber, "Y", "Y")
				this.controllerAxes.Push(newAxis)
				
				IfInString, joy_info, Z
				{
					newAxis := new CAxes(this.controllerNumber, "Z", "Z")
					this.controllerAxes.Push(newAxis)
				}
				IfInString, joy_info, R
				{
					newAxis := new CAxes(this.controllerNumber, "R", "R")
					this.controllerAxes.Push(newAxis)
				}
				IfInString, joy_info, U
				{
					newAxis := new CAxes(this.controllerNumber, "U", "U")
					this.controllerAxes.Push(newAxis)
				}
				IfInString, joy_info, V
				{
					newAxis := new CAxes(this.controllerNumber, "V", "V")
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
	
	implementationCheck(){
		if(IsFunc("ButtonHandler") == false){
			MsgBox, SCRIPT HAS STOPPED`nA "ButtonHandler()" function must exist`nThis functions job is to direct the controllers button state to the needed functions`n`nTo override this pass the "override" as the first parameter to the constructor
			Exit, -1
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
		returnString := 
		loop %dif%
		{
			if(this.controllerButtons[counter].state == True){
				if(returnString != null){
					returnString = %returnString%,%counter%
				}
				else{
					returnString = %counter%
				}
			}
			counter++
		}
		return returnString
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
		returnString := 
		loop %dif%
		{
			currentValue := this.controllerAxes[counter].state
			if(returnString != null){
				returnString = %returnString%,%currentValue%
			}
			else{
				returnString = %currentValue%
			}
			counter++
		}
		return returnString
		
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
		returnString := 
		
		Loop %dif%{
			currentValue := this.controllerJoysticks[counter].state
			if(returnString != null){
				returnString = %returnString%,%currentValue%
			}
			else{
				returnString = %currentValue%
			}
			counter++
		}
		return returnString
	}
	
	;<summary
	;This function is called to create a joystick given a list of params
	;</summary>
	;<param="axX">The array index for the joystick's X axis</param>
	;<param="axY">The array index for the joystick's Y axis/param>
	;<param="n">The common name of the joystick</param>
	;<param="xO">The X offset</param>
	;<param="yO">The Y offset</param>
	;<param="invX">Whether to invert the X axis or not</param>
	;<param="invY">Whether to invert the X axis or not</param>
	createJoystick(axX, axY, n, xO := 0, yO := 0, invX := false, invY:= false){
		this.numberOfJoysticks++
		newJoy := new CJoystick(this.controllerNumber, this.controllerAxes[axX], this.controllerAxes[ax], n, xO, yO, invX, invY)
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
}