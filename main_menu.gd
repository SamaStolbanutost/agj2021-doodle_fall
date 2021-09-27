extends Node

func _ready():
	global.load_save()
	if global.best_score != 0:
		$UI/BestScore.text = "Best: " + str(global.best_score)
		$UI/BestScore.visible = true

func play_pressed():
	$SelectSound.play()
	yield($SelectSound, "finished")
	get_tree().change_scene("res://scenes/gameplay.tscn")

func settings_pressed():
	$SelectSound.play()
	yield($SelectSound, "finished")
	get_tree().change_scene("res://scenes/settings.tscn")
