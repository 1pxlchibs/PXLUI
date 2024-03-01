pxlui = new pxlui_create();

pxlui.add_group("demo",0,0,[
	new pxlui_button("50","50",{text: "A Button",
		animations:{
			from: {yoffset: 0}, 
			to: {yoffset: 4}
		},
		animation_duration: 10,
		animation_curve: PXLUI_CURVES.ease_in
	}),
	new pxlui_checkbox("50","60"),
	new pxlui_slider("50","70")
])

pxlui.add_page("DemoPage",[
	"demo"
]);

alarm[0] = 1;
