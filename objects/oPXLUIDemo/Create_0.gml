pxlui = new pxlui_create();

pxlui.add_group("demo",0,0,[
	new pxlui_button("10","50",{
		text: "A Button",

		animations:{
			from: {image: 0, yoffset: 0},
			to: {image: 1, yoffset: 5}
		},
		
		animation_duration: 1,
		animation_curve: PXLUI_CURVES.ease_in
	}),
	new pxlui_checkbox("50","60"),
	new pxlui_slider("50","70"),
	
	new pxlui_sprite("50","50",{
		sprite_index: spr_pxlui_arrows,
		image_xscale: 4,
		image_yscale: 4,
		halign: fa_center,
		valign: fa_middle
	})
])

pxlui.add_page("DemoPage",[
	"demo"
]);

alarm[0] = 1;
