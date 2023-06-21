
This is PXLUI, it's a UI system I've been working on for the past few months.

### Once you've installed the packages, There are a couple things you need to do.
1. Install Input & Scribble from Juju.
2. After you've installed those packages, in the `__input_config_verbs` of Input add these 3 verbs ```
```javascript
alt_shoot: input_binding_mouse_button(mb_right),
scroll_up: input_binding_mouse_wheel_up(),
scroll_down: input_binding_mouse_wheel_down(),
```
This is needed for certain elements.
3. `pxlui_config` is where you can configure some settings and themes for the UI system.
4. Ready to go!


```javascript
pxlui = new pxlui_create();
```
Start by creating the system with pxlui_create in the `create event`, This uses constructors, so each UI made can be controlled via this new struct. You can have as many system as you like.

In the `step event` of the object you created your ui system in, add this function.
```javascript
pxlui.step();
```
This allows for keyboard/gamepad navigation to be enabled and also enables a staggered page loading effect that you may have noticed above. Now you're ready to create your UI.

```javascript
pxlui.add_page("Main",[
	pxlui_button("35","90",lexicon_text("ui.newgame"),80,20,,,function(){
		instance_destroy();
		room_goto_next(); 
		
		audio_stop_sound(snd_mainmenu);
		audio_stop_sound(snd_rain);
	}),
	load_game,
	pxlui_button("65","90",lexicon_text("ui.options"),80,20,,,function(){
		pxlui.unload_page("Main");
		pxlui.load_page("Options");
	}),
	pxlui_button("80","90",lexicon_text("ui.exit"),80,20,,,function(){
		game_end();
	})
]);
```
To create a UI, Each UI screen you make is called a page. Each page is created by supplying a key identifier, an array of it's elements and optionally a `layer` and `depth` property. The `layer` property will be explained later on.

```javascript
pxlui_button("65","90","Options",80,20,fa_middle,fa_middle,function(){
	pxlui.unload_page("Main");
	pxlui.load_page("Options");
}),
```
Each elements are prefixed with `pxlui_` For consistency, The element here is to create a button.

```javascript
///@Description PXLUI Button. Text will automatically adjust the width and height of the button.
///@param x x position on the GUI layer, can be percentage if in string
///@param y x position on the GUI layer, can be percentage if in string
///@param text String to apply on button
///@param [width] Width of the button
///@param [height] Height of the button
///@param [halign] Horizontal alignment of the button
///@param [valign] Vertical alignment of the button
///@param [callback] Function to execute on button activation
///@param [elementid] Identifier for use in element referencing
function pxlui_button(x, y, text, width = -1, height = -1, halign = fa_middle, valign = fa_middle, callback = function(){}, elementid = 0){
	return {
		object: oPXLUIButton,
		xx : x,
		yy : y,
		
		text: text,
		
		width: width,
		height: height,
		
		halign: halign,
		valign: valign,
		
		callback: callback,
		elementid: elementid
	};
}
```
As you can see the function return a struct, This allows for fine control of how each element works. You can add run code in them, store data in, change the way it draws, etc. 

You can store UI elements in variables to add extra functionality.
Here's how I edited a text UI element to change pages when a input is detected from the player.
```javascript
var anykey = pxlui_text("50","90",lexicon_text("ui.pressanykey"));
anykey.step = function(id){
	if (input_source_using(INPUT_KEYBOARD) || input_source_using(INPUT_MOUSE) || input_source_using(INPUT_GAMEPAD)){
		pxlui.unload_page("Start");
		pxlui.load_page_delay("Main",10);	
	}
}
```

Now once you've added a page to the system you will want to load it.
You simply call load_page(`pageName`) anywhere you need and it will create the system for you.
```javascript
pxlui.load_page("Start");
```
Voilà, as simple as that! Behind the scenes, this assigns all the UI elements to instances wit their draw GUI disabled. 

This is because PXLUI creates a renderer object for each layer specified and renders the UI elements on it's own surface.
```javascript
if (!graceful_destroy){
	if (!surface_exists(render_surf)){
		render_surf = surface_create(global.uiW,global.uiH);
	} else{
		surface_set_target(render_surf);
		
		draw_clear_alpha(c_black,0);
	
		var _elements = layer_get_all_elements(layerId);
		for(var i = 0; i < array_length(_elements); i++;){
			var _element = _elements[i];
			var _id = layer_instance_get_instance(_element);
			with(_id){
				if (visible){
					drawGUI(id);
				}
			}
		}

		surface_reset_target();
	}
}

pxlui_render_GUI(id);
```
If no layer was supplied, it will use the default layer `"PXLUI_Layer"` 

```javascript
pxlui_draw_elements = function(id){
	draw_surface_ext(id.render_surf,0,0,1,1,0,c_white,1);
}

pxlui_render_GUI = function(id){
	id.pxlui_draw_elements(id);
}
```

This setup allows you to control how each layer renders. Adding backgrounds, applying shaders, you name it!
```javascript 
pxlui.custom_render("Options",function(id){
	draw_rectangle(0,0,global.uiW,global.uiH,false);
	id.pxlui_draw_elements();
})
```


Lastly, PXLUI comes with themes!
```javascript
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
			text1: global.sfont,	
			text2: global.bfont
		}
	},
}
```
You can create as many themes as you want and switch them at runtime! These themes effect what sprites certain UI element uses and some of the default colors, as well as fonts!

#### Dependencies
Credit to [@jujuadams](https://github.com/JujuAdams)
[Scribble](https://github.com/JujuAdams/scribble) - Text Renderer
[Input](https://github.com/JujuAdams/input) - Input system

##### This UI system is still a work in progress and optimization is required.
