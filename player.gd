extends KinematicBody2D

var _dead = false
var velocity = Vector2.ZERO
var h_speed = global.sensivity
var timer = 0.0
var is_jumping = false
var v_speed = -600
var jump_time = 1.0
var last_pos_y
var direction

func _ready():
	last_pos_y = $".".global_position.y

func get_input():
	velocity = Vector2.ZERO
	
	if not is_jumping:
		velocity.y -= v_speed
		velocity.y *= timer
	else:
		velocity.y += v_speed
		velocity.y *= timer
	
	if Input.is_action_pressed("ui_left") or direction == "left":
		velocity.x -= h_speed
		$"Sprite".flip_h = true
	elif Input.is_action_pressed("ui_right") or direction == "right":
		velocity.x += h_speed
		$"Sprite".flip_h = false

func check_collision():
	for object in get_slide_count():
		var collider = get_slide_collision(object).collider
		if collider.is_in_group("right_portal"):
			global_position.x = 50
		if collider.is_in_group("left_portal"):
			global_position.x = 550
		if collider.is_in_group("platform"):
			$"../Sounds/JumpSound".play()
			is_jumping = true
			timer = jump_time
			collider.call_deferred("free")
		if collider.is_in_group("jump_platform"):
			$"../Sounds/HighJump".play()
			is_jumping = true
			timer = jump_time * 20
			collider.call_deferred("free")
		if collider.is_in_group("boost_platform"):
			$"../Sounds/LowJump".play()
			is_jumping = true
			timer = jump_time * 0.1
			collider.call_deferred("free")
		if collider.is_in_group("death"):
			if global.best_score < global.score:
				global.best_score = global.score
			$"../Camera2D/UI/Buttons".visible = false
			global._game = false
			_dead = true
			$"..".state = "dead"
			collider.call_deferred("free")

func sync_camera():
	if $"../Camera2D".global_position.y < $".".global_position.y:
		$"../Camera2D".global_position.y = $".".global_position.y
	$"../Background".global_position = $"../Camera2D".global_position

func generate_map():
	if $".".global_position.y >= last_pos_y + 200:
		$"..".create_platform()
		last_pos_y = $".".global_position.y

func _physics_process(delta):
	if global._game:
		get_input()
		
		if is_jumping:
			timer -= delta
			if timer <= 0.0:
				is_jumping = false
		else:
			timer += delta
		
		velocity = move_and_slide(velocity)
		check_collision()
		sync_camera()
		generate_map()
		
	elif _dead:
		velocity = Vector2.ZERO
		velocity.y -= -(v_speed * 5)
		velocity = move_and_slide(velocity)
