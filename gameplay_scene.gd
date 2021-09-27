extends Node

# 1 - basic ; 2 - jump ; 3 - boost
var preload_platforms = [preload("res://models/platform.tscn"), preload("res://models/jump_platform.tscn"), preload("res://models/boost_platform.tscn")]
var state = "game"

func _ready():
	global.score = 0
	global._game = true
	if global.control_mode == "keyboard":
		$Camera2D/UI/Buttons.visible = false

func create_platform():
	randomize()
	var platform = preload_platforms[rand_range(-2, 2)].instance()
	$Platforms.add_child(platform)
	platform.global_position.y = $Player.global_position.y + 1800 + rand_range(-100, 100)
	platform.global_position.x = rand_range(20, 580)

func update_score():
	if global.score < int($Player.global_position.y / 12):
		global.score = int($Player.global_position.y / 12)
	$Camera2D/UI/Score.text = str(global.score) 

func _physics_process(delta):
	if state == "dead":
		if $"Camera2D/UI/DeathScreen".rect_position.x < -300:
			$"Camera2D/UI/DeathScreen".rect_position.x += delta * 450
		if $"Camera2D/UI/PauseScreen".rect_position.x < 300:
			$"Camera2D/UI/PauseScreen".rect_position.x += delta * 450
	elif state == "pause":
		if $"Camera2D/UI/PauseScreen".rect_position.x > -300:
			$"Camera2D/UI/PauseScreen".rect_position.x -= delta * 450
		if $"Camera2D/UI/DeathScreen".rect_position.x > -900:
			$"Camera2D/UI/DeathScreen".rect_position.x -= delta * 450
	else:
		if $"Camera2D/UI/DeathScreen".rect_position.x > -900:
			$"Camera2D/UI/DeathScreen".rect_position.x -= delta * 450
		if $"Camera2D/UI/PauseScreen".rect_position.x < 300:
			$"Camera2D/UI/PauseScreen".rect_position.x += delta * 450
		update_score()

func replay():
	$Sounds/SelectSound.play()
	get_tree().reload_current_scene()

func home():
	$Sounds/SelectSound.play()
	global.save()
	get_tree().change_scene("res://scenes/main_menu.tscn")

func pause():
	$Sounds/SelectSound.play()
	if global.best_score < global.score:
		global.best_score = global.score
	global._game = false
	state = "pause"

func resume():
	$Sounds/SelectSound.play()
	global._game = true
	state = "game"

func left():
	$Player.direction = "left"

func right():
	$Player.direction = "right"

func arrow_up():
	$Player.direction = ""
