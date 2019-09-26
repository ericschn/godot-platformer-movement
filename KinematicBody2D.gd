extends KinematicBody2D

const UP = Vector2(0, -1);
const GRAVITY = 20;
const ACCELERATION = 50;
const MAX_SPEED = 250;
const JUMP_HEIGHT = -550;

var motion = Vector2()
var grounded = false;
var friction = false;
var jump_frame = 0;

var jumped = false;

func _physics_process(delta):
	# Main gravity
	motion.y += GRAVITY;
	friction = false;
	
	# Set grounded state, not really necessary but eh I like it
	grounded = true if is_on_floor() else false;
	
	# Left and right movement
	if Input.is_action_pressed("move_left"):
		motion.x = max(motion.x - ACCELERATION, -MAX_SPEED);
		$Sprite.flip_h = true;
		$Sprite.play("run");
	elif Input.is_action_pressed("move_right"):
		motion.x = min(motion.x + ACCELERATION, MAX_SPEED);
		$Sprite.flip_h = false;
		$Sprite.play("run");
	else:
		$Sprite.play("idle");
		friction = true;
		
	# Jumping
	if grounded:
		jumped = false;
		jump_frame = 0;
		if Input.is_action_just_pressed("move_jump"):
			jumped = true;
			motion.y = JUMP_HEIGHT;
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.2);
	else:
		jump_frame += 1;
		# Variable jump height
#		if Input.is_action_pressed("move_jump"):
#			if jump_frame == 2:
#				motion.y += -200;
#			if jump_frame == 3:
#				motion.y += -100;
#		jump_frame += 1;
		# Rising
		if motion.y < 0:
			$Sprite.play("jump");
			if Input.is_action_just_released("move_jump"):
				if jump_frame > 2:
					motion.y = motion.y / 10;
				else:
					motion.y = -90;
					
		# Falling
		else:
			$Sprite.play("fall");
			if !jumped && Input.is_action_just_pressed("move_jump") && jump_frame < 8:
				jumped = true;
				motion.y = JUMP_HEIGHT;
				
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.05);
		
	# Move the player
	motion = move_and_slide(motion, UP);
	