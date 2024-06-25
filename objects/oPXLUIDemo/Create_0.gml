pxlui = new pxlui_create();

var _group1 = new pxlui_group("50","50",[
	new pxlui_button("50","15","Button 1",,{
		width: 100,
		height: 26,
		animations:{
			from: {image_index: 0, yoffset: 0, text_color: c_white},
			to: {image_index: 1, yoffset: 3, text_color: c_black},
		},
		
		animation_duration: 5,
		animation_curve: PXLUI_CURVES.ease_in,
		halign: fa_center,
		valign: fa_center,
	}),
	new pxlui_button("50","35","Button 2",,{
		width: 100,
		height: 26,
		animations:{
			from: {image: 0, xoffset: 0, color: c_white},
			to: {image: 1, xoffset: 3, color: c_red},
		},
		
		animation_duration: 5,
		animation_curve: PXLUI_CURVES.ease_in,
		halign: fa_center,
		valign: fa_center,
	}),
	new pxlui_checkbox("50","55",,{halign: fa_center}),
	new pxlui_slider("50","80",0,10,1,,{halign: fa_center}),
],{width: 150, height: 160,halign: fa_center,valign: fa_middle,sprite_index: spr_pxlui_button,image_speed: 0});

var _group2 = new pxlui_group(0,0,[
	new pxlui_sprite(15,15,spr_pxlui_logo,0),
	new pxlui_text(15 + 120 + 15, 15,"Welcome to PXLUI 2.0.0 Alpha",{xscale: 2, yscale: 2}),
	new pxlui_text(15 + 120 + 15, 50,"This is a work in progress ui system built for GML. It's intention is to create a more flexible UI system with powerful styling & animation configurations.",{
		width: 450,
		color: #606060,
	})
]);

var _group3 = new pxlui_group("50","75",[
	new pxlui_button("50","50","Exit",,{
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
		callback: function(){
			game_end();	
		}
	}),
],{width: 150, height: 60, halign: fa_center, valign: fa_bottom, sprite_index: spr_pxlui_button,image_speed: 0});

pxlui.add_page("DemoPage",[
	new pxlui_sprite("50",15,spr_pxlui_logo,0),
	_group1,
	_group2,
	_group3
]);

pxlui.load_page("DemoPage");
