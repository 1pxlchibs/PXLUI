pxlui = new pxlui_create();

var _group1 = new pxlui_group("50","50",[
	new pxlui_button("50","5",{
		text: "Button 1",
		width: 100,
		height: 25,
		animations:{
			from: {image: 0, yoffset: 0},
			to: {image: 1, yoffset: 3},
		},
		
		animation_duration: 5,
		animation_curve: PXLUI_CURVES.ease_in,
		halign: fa_center,
	}),
	new pxlui_button("50","30",{
		text: "Button 2",
		width: 100,
		height: 25,
		animations:{
			from: {image: 0, xoffset: 0, color: c_white},
			to: {image: 1, xoffset: 3, color: c_red},
		},
		
		animation_duration: 5,
		animation_curve: PXLUI_CURVES.ease_in,
		halign: fa_center,
	}),
	new pxlui_checkbox("50","55",{halign: fa_center}),
	new pxlui_slider("50","80",{halign: fa_center}),
],{width: 150, height: 160,halign: fa_center,valign: fa_center,sprite_index: spr_pxlui_button,image_speed: 0,});

var _group2 = new pxlui_group(0,0,[
	new pxlui_sprite(15,15,{sprite_index: sCat}),
	new pxlui_text(15 + 302 + 15,"5",{text: "Welcome to PXLUI 2.0.0 Alpha", xscale: 2, yscale: 2}),
	new pxlui_text(15 + 302 + 15,"10",{
		text: "This is a work in progress ui system built for GML. It's intention is to create a more flexible UI system with powerful styling & animation configurations.", 
		width: 450,
		color: #606060,
	})
]);

var _group3 = new pxlui_group(0,0,[
	new pxlui_sprite("95","95",{sprite_index: spr_pxlui_button, image_speed: 0, image_xscale: 200/16, image_yscale: 200/16, halign: fa_right, valign: fa_bottom}),
]);

pxlui.add_page("DemoPage",[
	_group1,
	_group2,
	_group3
]);

alarm[0] = 1;
