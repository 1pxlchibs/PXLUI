created = false;

create = function(pageName, id){
	id.depth_original = depth;
	id.page = pageName;
	
	id.hover = false;
	id.interactable = false;
	
	id.grandparent = -1;
	id.parent = -1;
	
	id.color = global.pxlui_theme[$ global.pxlui_settings.theme].color.base;
	id.alpha = 1;
	
	//Values for position and scale animating
	id.xMod = 0;
	id.yMod = 0;
	id.xscaleMod = 0;
	id.yscaleMod = 0;
	
	//resolve any alignment according to set halign and valign
	switch(id.halign){
		case fa_left:
			id.xalign = id.width/2;
			
			id.x1collision = 0;
			id.x2collision = id.width;
			
			id.htextAlign = id.width/2;
		break;
		case fa_middle:
			id.xalign = 0;
			
			id.x1collision = -id.width/2;
			id.x2collision = id.width/2;
			
			id.htextAlign = 0;
		break;
		case fa_right:
			id.xalign = -id.width/2;
			
			id.x1collision = -id.width;
			id.x2collision = 0;
			
			id.htextAlign = -id.width/2;
		break;
	}
	switch(id.valign){
		case fa_top:
			id.yalign = id.height/2;
			
			id.y1collision = 0;
			id.y2collision = id.height;
			
			id.vtextAlign = id.height/2;
		break;
		case fa_middle:
			id.yalign = 0;
			
			id.y1collision = -id.height/2;
			id.y2collision = id.height/2;
			
			id.vtextAlign = 0;
		break;
		case fa_bottom:
			id.yalign = -id.height/2;
			
			id.y1collision = -id.height;
			id.y2collision = 0;

			id.vtextAlign = -id.height/2;
		break;
	}
	
	created = true;
}

beginStep = function(id){
	//empty begin step event, fill out with behaviour!
}
	
step = function(id){
	//empty step event, fill out with behaviour!
}

drawGUI = function(id){
	//empty drawGUI event, fill out with behaviour!
}