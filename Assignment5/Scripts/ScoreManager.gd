extends Node

var current_score = 0
var high_score: int = 0

const SAVE_PATH := "user://score.save"

func _ready() -> void:
	load_high_score()

func save_high_score(new_score: int):
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_var(new_score)

func load_high_score():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			high_score = file.get_var()
