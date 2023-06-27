// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
#macro PXLUI_CLICK_CHECK_PRESSED input_check_pressed("shoot")
#macro PXLUI_CLICK_CHECK input_check("shoot")
#macro PXLUI_CLICK_CHECK_RELEASED input_check_released("shoot")

#macro PXLUI_ALTCLICK_CHECK_PRESSED input_check_pressed("alt_shoot")
#macro PXLUI_ALTCLICK_CHECK input_check("alt_shoot")
#macro PXLUI_ALTCLICK_CHECK_RELEASED input_check_released("alt_shoot")

#macro PXLUI_UP input_check_repeat("up",,,1)
#macro PXLUI_DOWN input_check_repeat("down",,,1)
#macro PXLUI_LEFT input_check_repeat("left",,,1)
#macro PXLUI_RIGHT input_check_repeat("right",,,1)

#macro PXLUI_BACKSPACE input_check_repeat("cancel",,4,3)

#macro PXLUI_SCROLL_UP input_check("held_previous")
#macro PXLUI_SCROLL_DOWN input_check("held_next")

#macro PXLUI_EASE_SPEED 0.2

#macro PXLUI_NAV_PADDING 16

#macro PXLUI_DEPTH_BOTTOM -9000
#macro PXLUI_DEPTH_MIDDLE -9100
#macro PXLUI_DEPTH_TOP -9200

#macro PXLUI_DEBUG 1

enum PXLUI_ORIENTATION{
	VERTICAL,
	HORIZONTAL
}

global.pxlui_theme = {
	minimal:{
		container: spr_pxlui_container,
		card: spr_pxlui_container,
		scrollview: spr_pxlui_container,
		slider: spr_pxlui_container,
		button: spr_pxlui_button,
		checkbox: spr_pxlui_checkbox,
		
		color:{
			base: #55f0ff,
			secondary: c_dkgray,
			rectangle: c_black,
			selection: #f566c4,
			
			text:{
				primary: c_white,
				secondary: c_ltgray
			}	
		},
		fonts:{
			text1: "fntMonogram_12",	
			text2: "fntMonogram_24",
		},
	},
}

global.pxlui_settings = {
	theme: "minimal",

	ResW : 1280,
	ResH : 720,
	
	UIResW : 640,
	UIResH : 360,
}