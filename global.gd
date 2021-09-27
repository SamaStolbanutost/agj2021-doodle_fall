extends Node

var _game = false
var score = 0
var best_score = 0
var sensivity = 500
var volume = 0
var control_mode = "keyboard"
var save_file = "user://whole_data.save"

func save():
	var save = {"best": best_score, "sensivity": sensivity, "volume": volume, "control": control_mode}
	var file = File.new()
	file.open(save_file, File.WRITE)
	file.store_var(save)
	file.close()

func load_save():
	var save = File.new()
	if save.file_exists(save_file):
		save.open(save_file, File.READ)
		var save_var = save.get_var()
		best_score = save_var["best"]
		sensivity = save_var["sensivity"]
		volume = save_var["volume"]
		control_mode = save_var["control"]
		save.close()
