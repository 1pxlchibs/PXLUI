function healthHud(x,y){
	var _sprite = pxlui_sprite(spr_health_hud,0,x,y,,,"origin","origin",,global.pxlui_theme[$ global.pxlui_settings.theme].color.selection);
	_sprite.drawGUI = function(id){
		for(var _mhp = 0; _mhp < obj_controller.playerStats.max_hp/2; _mhp++) {
			var _flip = 1;
			if (_mhp % 2 == 1){
				_flip = -1;
			}
			gpu_set_fog(true,c_black,0,0);
			draw_sprite_ext(id.sprite,0,id.x+id.xalign+(20*_mhp),id.y+id.yalign,id.xscale,id.yscale*_flip,id.angle,id.color1,0.5);
			gpu_set_fog(false,c_white,0,0);
		}

		for(var _hp = 0; _hp < obj_controller.playerStats.hp/2; _hp++) {
			var _flip = 1;
			if (_hp % 2 == 1){
				_flip = -1;
			}
			if (obj_controller.playerStats.hp = _hp*2+1) {
			draw_sprite_ext(id.sprite,1,id.x+id.xalign+(20*_hp),id.y+id.yalign,id.xscale,id.yscale*_flip,id.angle,id.color1,1);
			} else {
				_image = 0;
				draw_sprite_ext(id.sprite,0,id.x+id.xalign+(20*_hp),id.y+id.yalign,id.xscale,id.yscale*_flip,id.angle,id.color1,1);
			}
		}
	}
	
	return _sprite;
}

function pxlui_money(x,y, halign = fa_left, valign = fa_middle, effect = ""){
	var _money = pxlui_text(x,y,effect+string(obj_controller.playerStats.money),,,halign,valign);
	_money.drawGUI = function(id){
		id.text = id.effect+string(obj_controller.playerStats.money);
	
		id.scribbleText.align(id.halign,id.valign).blend(id.color, id.alpha).transform(id.xscale + id.xscaleMod, id.yscale + id.yscaleMod, 0);
	
		if (id.width != -1){
			id.scribbleText.wrap(id.width);
		}
		if (id.height != -1){
			id.scribbleText.scale_to_box(id.width,id.height);
			id.scribbleText.fit_to_box(id.width,id.height);
		}
	
		id.scribbleText.draw(id.x + id.xMod, id.y + id.yMod);
	}
	_money.effect = effect;
	
	return _money;
}

function pxlui_key(x,y,halign = fa_left, valign = fa_middle){
	var _keys = pxlui_text(x,y,"x"+string(obj_controller.playerStats.keys),,,halign,valign);
	_keys.drawGUI = function(id){
		id.text = "x"+string(obj_controller.playerStats.keys);
		id.scribbleText.align(id.halign,id.valign).blend(id.color, id.alpha).transform(id.xscale + id.xscaleMod, id.yscale + id.yscaleMod, 0);
	
		if (id.width != -1){
			id.scribbleText.wrap(id.width);
		}
		if (id.height != -1){
			id.scribbleText.scale_to_box(id.width,id.height);
			id.scribbleText.fit_to_box(id.width,id.height);
		}
	
		id.scribbleText.draw(id.x + id.xMod, id.y + id.yMod);
	}
	return _keys;
}

function active_tab(x,y,text,pageName){
	var _button = pxlui_button(x,y,text,76,,,,function(id){
		pxlui.reload_page(id.pageName);				
	});
	_button.pageName = pageName;
	_button.step = function(id){
		id.hover = true;
	}
	_button.onhover = function(id){
		if (id.hover){
			if (id.parent.object_index = oPXLUIScrollView){
				id.parent.currentElement = scrollview_number;
			}
			draw_sprite_ext(id.sprite, 1, id.x + id.xalign + id.xMod,  id.y + id.yalign + id.yMod, 
						id.width/sprite_get_width(id.sprite) + id.xscaleMod, id.height/sprite_get_height(id.sprite) + id.yscaleMod,
						0,id.color2,id.alpha);
		}
	}
	
	return _button;
}