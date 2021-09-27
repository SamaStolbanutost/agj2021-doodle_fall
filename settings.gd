extends Node

func _ready():
	$Control/Sensivity/HSlider.value = global.sensivity
	$Control/Volume/HSlider.value = global.volume
	if global.control_mode == "arrows":
		$Control/ControlMode/TextureButton.pressed = true

func change_volume(value):
	$SelectSound.play()
	global.volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), global.volume)

func change_sensivity(value):
	$SelectSound.play()
	global.sensivity = value

func back():
	$SelectSound.play()
	global.save()
	get_tree().change_scene("res://scenes/main_menu.tscn")

func change_control_mode():
	$SelectSound.play()
	if $Control/ControlMode/TextureButton.pressed:
		global.control_mode = "arrows"
	else:
		global.control_mode = "keyboard"
