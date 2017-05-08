
#AHK_Controller_Library
A Simple and Easy to Use AHK Controller Library

This repository's goal is to develop an easy to implement AHK library to manipulate input from controllers / joystick / gamepads. AHK's current implementations is very simplistic and does not offer an easy way to access much of the useful. Current Release is Beta 0.1.0 updates should come out periodically.

----------

[TOC]

----------


#Getting Started

1) Download this repository (simple way press "clone or download" -> "download ZIP")
2) Open the config.ini file and modify it to your needs
3) Create a new AHK script and add #Include %A_ScriptDir%/ControllerCore.ahk and an update loop
4) Implement the functions that you outlined in the config.ini
5) Enjoy


----------


#A Deeper Look
##ControllerCore.ahk
The functionality for this library can be found in this file. The code is very well documented and moderately difficult to understand if no previous knowledge of AHK, but with basic knowledge it shouldn't take long to be able to modify it if needed.

If you come across and bugs, issues, missing functionality, or huge performance issues please create an issues report on the repository to help the progress of the library.
##Config.ini
The config.ini file is where all user configuration happens. The ini file itself contains a bit of cvs as well in order to reduce the number of files needed for proper functionality.  Below is a sample ini file that would work with an Xbox 360 Wired Controller (Wireless and Xbox One should also work) and works with the given TestScript.ahk file

    [General]
	Buttons_Enable = 1
	Joysticks_Enable = 1
	Pov_Enabled = 1
	Axes_Enabled = 1
	
	
	[Joysticks]
	Number_Of_Joysticks = 2
	Joystick_1_Name = Left_Stick
	Joystick_2_Name = Right_Stick
	
	
	[Left_Stick]
	Name = Left_Stick
	X_Axis = 1
	Y_Axis = 2
	Invert_X = 0
	Invert_Y = 1
	
	
	[Right_Stick]
	Name = Right_Stick
	X_Axis = 5
	Y_Axis = 4
	Invert_X = 0
	Invert_Y = 1
	
	
	[Button Config]
	1,1_Event
	2,2_Event
	3,3_Event
	4,4_Event
	1/2/3/4,1_2_3_4_Event
	9,9_Event
	
	
	[Joystick Config]
	1,20,Left_Stick_Event
	2,10,Right_Stick_Event
	
	
	[POV Config]
	0,povUp_Event
	9000,povRight_Event
	18000,povDown_Event
	27000,povLeft_Event
	
	
	[Axes Config]
	3,5,Trigger_Event

Things to note are that the ini files should use "0" for false and "1" for true. All of the numbers associated with the buttons, axes, and joysticks are the numebers that AHK identifies them by and can be tested for with the "Joy Test.ahk" script. The [Joysticks] section defines the number of joysticks and the name of the section of that define them. Each joystick needs the following values in its section.


	[Joysticks]
	Number_Of_Joysticks = 2
	Joystick_1_Name = Left_Stick
	Joystick_2_Name = Right_Stick

**The "Number_Of_Joysticks" is set to the number of joysticks you wish to have and the entries below that MUST BE NAMED "Joystick_n_Name" where n is the next number of stick starting at 1. THIS IS A MUST DO. The value of the "Joystick_n_Name" entry is the name of the section to look at for the configuration information for that joystick** 

----------

	[Generic_Joystick_Name]
	Name = Left_Stick
	X_Axis = 1
	Y_Axis = 2
	Invert_X = 0
	Invert_Y = 1

Where the "Name" is the common for the joystick (doesn't have to be the same as the section but can be), the "X_Axis" is the ID number of the desired axis for the X component of the joystick (again the "Joy Test.ahk" script will make finding that easy), the "Y_Axis" is the ID number of the desired axis for Y component of the joystick, the Invert_X and Invert_Y are Boolean values ( "0" or "1") whether that axis should be inverted when calculation the angle it is generating.

Next the the [Button Config] section is where all of the button combinations are defined. A sample section may look like

	[Button Config]
	1,1_Event
	2,2_Event
	3,3_Event
	4,4_Event
	1/2/3/4,1_2_3_4_Event
	9,9_Event
These entries are NOT in typical ini format and instead use [csv format](https://msdn.microsoft.com/en-us/library/mt260840.aspx). There is two parts to each line in this section the left-hand side of the comma is where the keys are defined. Each keys ID number is listed separated by a "/" character. **DO NOT PUT ON AT THE BEGINNING OR END** that will break the implementation. Order of the numbers does not matter. The right-hand side of the comma is the name of the function to call when that button combination is pressed. **Ensure that it is NOT encased in quotation marks**. Take the lines:

	2,2_Event
	1/2/3/4,1_2_3_4_Event
The first will trigger the "2_Event" function when the 2 button is pressed, and the second will trigger the "1_2_3_4_Event" function when the four buttons (1, 2, 3, and 4) are pressed.

##Making Your Custom Function Set

##Extended Library

