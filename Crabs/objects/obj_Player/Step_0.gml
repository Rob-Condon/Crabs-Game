/// @description Insert description here
// You can write your code in this editor
/// Movement
// You can write your code in this editor

// Starting veriables

if global.stop == false and StopMovement = false{
	Selfx = x;
	Selfy = y
	//Setting up colision boxes and lines
	collisionJump = collision_rectangle(x-23, y+33, x+23, y+3, o_Wall, false, false)
	collisionSquare = collision_rectangle(x-SquareX, y-20, x+SquareX+1, y+32, o_Wall, true, false)
	collisionSquarePearl = collision_rectangle(x-(SquareX-15), y+2, x+(SquareX-15), y+20, obj_WhiteCoin, false, false)
	collisionLine = collision_line(x, y+26, x+Xline, y+26, o_Wall, false, false)
	collisionEllipse_MovingPlatforms = collision_ellipse(x-22, y+31, x+23, y+13, obj_MovingObject, false, false)
	collisionLine_MovingPlatforms = collision_line(x-20, y+33, x+21, y+33, obj_MovingObject, false, false)
	collisionEllipse_JellyFish = collision_ellipse(x-22, y+31, x+23, y+13, obj_JellyFish_BlueGreen64, false, false)
	collisionLine_JellyFish = collision_line(x-20, y+33, x+21, y+33, obj_JellyFish_BlueGreen64, false, false)
	
	if global.Invert = false{
		key_right = keyboard_check(ord("D"));
		key_left = keyboard_check(ord("A"));
		key_up = keyboard_check(ord("W"));
		key_down = keyboard_check_pressed(ord("S"));
	}else{
		key_left = keyboard_check(vk_left);
		key_right = keyboard_check(vk_right);
		key_up = keyboard_check(vk_up);
		key_down = keyboard_check_pressed(vk_down);
	
	}
	//wall bullshit
	//No wall bullshit during squish
	SquareX = 26
	if(keyboard_check_released(vk_space)) {
		AmFlat = !AmFlat;	
	}
	
	if(SpuishedOffOn == false){
		
		Yline = 32
		if(key_right)Xline = 27;
		if(key_left)Xline = -26;
		if((!key_right) and (!key_left))Xline = 0;
		//Restart
		if keyboard_check(ord("R")){
			game_restart()
		}
	}

	
	//ShockWave form Barrel
	stop -= 1
	//acceleration and deceleration
	
	//Slows the movement down
	script_execute(scr_Bang)
	//It's times so it can also work with a negtive
	hsp_move = Approach(hsp_move, (key_right - key_left)*walksp, 0.5);
	hsp = hsp_move + bang;
	
	//JellyFish stuff
	
	//Jump
	
	if((collisionJump and key_up) or Jumping = true)
	{
		
		Jumping = true
		if(JumpWindUp >= 5) {
			audio_play_sound(snd_Effect_Jump, 2, false);
			if(obj_BelowPlayerLeft.StepColour != noone){
				part_type_color1(PartStep, obj_BelowPlayerLeft.StepColour)
				part_emitter_region(partStep_sys, PartStep_emit, Selfx-24, Selfx-20, Selfy+32, Selfy+31, ps_shape_rectangle, ps_distr_gaussian)
				part_emitter_burst(partStep_sys, PartStep_emit, PartStep, 4);
			}
			if(obj_BelowPlayerRight.StepColour != noone){
				part_type_color1(PartStep, obj_BelowPlayerRight.StepColour)
				part_emitter_region(partStep_sys, PartStep_emit, Selfx+24, Selfx+20, Selfy+32, Selfy+31, ps_shape_rectangle, ps_distr_gaussian)
				part_emitter_burst(partStep_sys, PartStep_emit, PartStep, 4);
			}
		
			vsp = JumpHight
			Jumping = false;
			JumpWindUp = 0;
		} else {
			JumpWindUp += 1;
		}
	}
	//Moving objects movement
	if(collisionEllipse_MovingPlatforms or collisionLine_MovingPlatforms){
		x += MoveBy 
	}
	
	if(collisionLine_JellyFish or collisionEllipse_JellyFish) {
		y += MoveByY;	
	}
	
	script_execute(scr_SquishCrab)
	
	if((sprite_index == spr_NewPlayer_squishTunnel) and (path_index == -1)){
		sprite_index = spr_NewPlayer_squish
	}
	
	//Wall bullshit, slowdown
	if (stamina_current <= stamina_max){	
		if((!place_meeting(x, y+1, o_Wall)) and (collisionSquare)){
			if(collisionLine){
				if(SpuishedOffOn == false){
					if vsp > 0{
						stamina_current += 1
						vsp = vsp*0.05
						if(SlidingRight == true){
							part_type_color1(PartStep, obj_SidePlayerRight.StepColour)
							part_emitter_region(partStep_sys, PartStep_emit, Selfx+24, Selfx+20, Selfy+32, Selfy+31, ps_shape_rectangle, ps_distr_gaussian)
							part_emitter_burst(partStep_sys, PartStep_emit, PartStep, 1);
						}else if (SlidingLeft == true){
							part_type_color1(PartStep, obj_SidePlayerLeft.StepColour)
							part_emitter_region(partStep_sys, PartStep_emit, Selfx-24, Selfx-20, Selfy+32, Selfy+31, ps_shape_rectangle, ps_distr_gaussian)
							part_emitter_burst(partStep_sys, PartStep_emit, PartStep, 1);
						}
					}
				}
			}
		}
	}
	
	//Cool bubble base thing 
	/*if(vsp < -0.3) {
		grv = -1*((vsp/20)+0.1);	
	} else if(vsp < 0.5){
		grv = 0.1
	} else {
		grv = 0.2;	
	}*/
	if(WandShake > 0) {
		WandShake -= 0.01;
		part_type_speed(WandShotPartical, 1, 1.5, 0, WandShake);
	}
	if(WandGravity < 0.05) {
		WandGravity += 0.001;
		part_type_gravity(WandShotPartical, WandGravity, 90);
	}
	//Grav Based things
	PerfectPoint = false;
	if(vsp < -2) {
		grv = -1*((vsp/20)-0.1);	
	} else if(vsp < 3){
		grv = 0.1
		PerfectPoint = true;
	} else {
		grv = 0.2;	
	}
	//grv = -1*(vsp/10);	
	if(vsp + grv + Vbang < 8) {
		vsp += grv + Vbang;
	}
	
	//show_debug_message("VSP: " + string(vsp));
	//show_debug_message("grv: " + string(grv));
	//X axies Collision
	//Meaning if it meets o_Wall on hte x axies it will stop the movement
	
	if (place_meeting(x+hsp, y, o_Wall))
	{
		//This is always checking if you havn't hit the wall yet
		Yplus = 0;
		
		while(place_meeting(x+hsp, y-Yplus, o_Wall) && Yplus <= abs(1*hsp)) Yplus += 1;
		if(place_meeting(x+hsp, y-Yplus, o_Wall)) {
			while (!place_meeting(x + sign(hsp), y, o_Wall))
			{
				x = x + sign(hsp);	
			}
			hsp = 0;
		} else {
			y -= Yplus;	
		}
		
	} 
	
	if(place_meeting(x+1, y, o_Sand) or place_meeting(x-1, y, o_Sand)){
		HittingWall = true
	}else{
		HittingWall = false
	}
	
	if(place_meeting(x,y+1, o_Wall)) {
		OnFloor = true;	
		
	} else {
		OnFloor = false;	
		
	}
	//show_debug_message(point_direction(obj_Player.x, obj_Player.y, o_Turret.x, o_Turret.y))	

	x = x + hsp

	//Y axies Collison 
	//Meaning if it meets o_Wall on the y axies it will stop the movement
	collisionLine_EntireBottom = collision_rectangle(x-23, y+32+vsp, x+23, y-8+vsp, o_Wall, true, false)
	if(collisionLine_EntireBottom){
		vsp = 0;
		//show_debug_message("Touching leaf!");
		stamina_current = 0
		while (!collisionLine_EntireBottom)
		{
			y = y + sign(vsp);
		}
		
	} else {
		//show_debug_message("nah");	
	}
	y = y + vsp;
	
	//Animation
	if(SpuishedOffOn == false){
		script_execute(scr_AnimationCrab)
	}

	//Win
	if (place_meeting(x, y+1, o_Win))
	{ 
		room_goto(RoomGo);
	}

 

	//Damdge management
	script_execute(scr_DamdgeControl)
	//Damdge from fire
	script_execute(scr_HitBounce, obj_fire, -6, false)
	if(Eel_electric == true) {
		script_execute(scr_HitBounce, obj_ElectricEel, -6, false)
	}
	
	//hat follow you
	if(sprite_index != spr_NewPlayer_Jump){
		obj_Hat.x = x
		obj_Hat.y = y-12
	}else{
		obj_Hat.x = x
		obj_Hat.y = y-10
	}
	
	
}else{
	sprite_index = spr_NewPlayer_idel
}


//Claw stuff
//Claw attack with E animations


with(Claw) {
	y = other.y + other.Claw_Y;
	x = other.x + other.Claw_X;
}

/*if(keyboard_check_pressed(ord("E"))) {
	if(Claw_State != spr_Claw_BasicAttack) {
		Claw_State = spr_Claw_BasicAttack;
	} else {
		if(Claw.image_index	>= 7) {
			Claw_State = spr_Claw_BasicComboAttack;
		}
	}
}

if(Claw_State = spr_Claw_BasicAttack) {
	if(Claw.image_index	>= 10) {
		Claw_State = spr_Claw_Idel;	
	}
} else if(Claw_State = spr_Claw_BasicComboAttack) {
	if(Claw.image_index	>= 5) {
		Claw_State = spr_Claw_Idel;	
	}
} */
