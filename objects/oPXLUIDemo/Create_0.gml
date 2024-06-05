pxlui = new pxlui_create();

var _group1 = pxlui.add_group("group1",[
	new pxlui_button("50","15",{
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
	new pxlui_button("50","20",{
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
	new pxlui_checkbox("50","25",{halign: fa_center}),
	new pxlui_slider("50","30",{halign: fa_center}),
]);

var _group2 = pxlui.add_group("group2",[
	new pxlui_sprite("5","5",{sprite_index: sCat}),
	new pxlui_text("50","40",{text: "Welcome to PXLUI 2.0.0 Alpha", halign: fa_center}),
	new pxlui_text("50","45",{
		text: "This is a work in progress ui system built for GML. It's intention is to create a more flexible UI system with powerful styling & animation configurations.", 
		halign: fa_center,
		width: 450,
		color: #606060,
	})
]);

pxlui.add_page("DemoPage",[
	pxlui_group(_group1,0,"50"),
	pxlui_group(_group2,0,0),
]);

alarm[0] = 1;
