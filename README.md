# PXLUI 2.0.0 Alpha
*A simple ui library built for ease of use and flexibility*

## Installation
1. Install [INPUT 6.2.5](https://github.com/offalynne/Input/releases/tag/6.2.5), as it has dependencies for menu navigation.
2. Import the package in `Tools` -> `Import Local Package`. 
3. `pxlui_config` is where you can configure some settings and themes for the UI system.
4. Ready to go!

## Quick Guide

### Create Event
```javascript
pxlui = new pxlui_create();
```
This system uses constructors, so each UI made can be controlled via this new struct. You can have as many system as you like.
```javascript
var _group1 = new pxlui_group("50","50",[
	new pxlui_button("50","15","Button 1",,{
		width: 100,
		height: 26,
		animations:{
			from: {image: 0, yoffset: 0},
			to: {image: 1, yoffset: 3},
		},
		
		animation_duration: 5,
		animation_curve: PXLUI_CURVES.ease_in,
		halign: fa_center,
		valign: fa_center,
	}),
],{width: 150, height: 160,halign: fa_center,valign: fa_center, sprite_index: spr_pxlui_button,image_speed: 0,});

pxlui.add_page("DemoPage",[
	_group1,
]);

pxlui.load_page("DemoPage");
```
PXLUI's this is a basic setup for adding a button. You first start by creating a group, these group are containers that restrain the elements inside it's bounding box, like a mini canvas. This allows the creation and reuse of UI element compositions.
### Step Event
```javascript
pxlui.step();
```
You must put this for UI interactions to work properly.

That's the basic guide! You now have a button!

## CONFIG
Each element has a config parameter, this is an optional struct that you can supply to edit various things about the element.
### List of Default configs
```
xscale
yscale

xoffset
yoffset

halign
valign

width
height

angle
color
alpha
text

padding
padding_top
padding_bottom
padding_left
padding_right

animation_xscale
animation_yscale

animation_duration
animation_curve_in
animation_curve_out
animations
```
All config options are displayed at the top of each element functions.
##### This UI system is still a work in progress and optimization is required.
##### This version of PXLUI has only been tested on v2024.4.1.152, it may or may not work on previous versions.
