pxlui = new pxlui_create();

function sine_wave(time, period, amplitude, midpoint) {
    return sin(time * 2 * pi / period) * amplitude + midpoint;
}

function sine_between(time, period, minimum, maximum) {
    var midpoint = mean(minimum, maximum);
    var amplitude = maximum - midpoint;
    return sine_wave(time, period, amplitude, midpoint);
}

checkbox1 = false;
checkbox2 = false;

slider1 = 1;
slider2 = 10;

counter = 0;

pxlui.add_page("lines",[
	pxlui_divline("5", PXLUI_ORIENTATION.HORIZONTAL),
	pxlui_divline("50", PXLUI_ORIENTATION.VERTICAL),

	pxlui_divline("95", PXLUI_ORIENTATION.HORIZONTAL),
]);

pxlui.add_page("main",[

	
	pxlui_text("2","10","Welcome to [c_red]PXLUI!",2,2,fa_left),
	pxlui_text("2","25","A highly overengineered UI system for game maker.[nbsp]"+
	"This system was born out of pure hyperfocus, coffee and a couple years of UI experience. It utilises [rainbow]Scribble[/rainbow] and [c_blue]Input[/c] for that extra [slant]pizzazz.",,,fa_left,,300),
	
	
	pxlui_text("52", "10", "Uses:", 2, 2, fa_left),
	pxlui_button("52", "20", "Useless Button!",,,fa_left),
	pxlui_button("70", "20", "Counter Button!",,,fa_left,,function(){
		oPXLUIDemo.counter++;	
	}),
	
	pxlui_text("88","20",[id,"counter"],,,fa_left),
	
	pxlui_text("52","35","Checkbox 1",,,fa_left),
	pxlui_text("52","40","Checkbox 2",,,fa_left),
	pxlui_checkbox("62", "35",[id,"checkbox1"],,,fa_left),
	pxlui_checkbox("62", "40",[id,"checkbox2"],,,fa_left),
	pxlui_text("66","35",[id,"checkbox1"]),
	pxlui_text("66","40",[id,"checkbox2"]),
	
	pxlui_text("52","55","Slider 1",,,fa_left),
	pxlui_text("52","60","Slider 2",,,fa_left),
	pxlui_slider("62","55",[id,"slider1"],0,1,0.1,,,fa_left),
	pxlui_slider("62","60",[id,"slider2"],0,10,0.5,,,fa_left),
	pxlui_text("73","55",[id,"slider1"],,,fa_left),
	pxlui_text("73","60",[id,"slider2"],,,fa_left),
]);

pxlui.load_page("main");
pxlui.load_page("lines");