extends Control

@onready var current_score_label = %DepthLabel
@onready var high_score_label = %ScoreLabel

func _ready() -> void:
	print("Loaded current_score:", ScoreManager.current_score)
	print("Loaded high_score:", ScoreManager.high_score)
	current_score_label.text = ": %d" %ScoreManager.current_score + "m"
	high_score_label.text = ": %d" % ScoreManager.high_score + "m"



func _on_restart_button_pressed() -> void:
	SceneManager.change_scene("res://Scenes/boulder_dash.tscn", {
		"speed": 5,
		"pattern": "scribbles",
	})

func _on_main_menu_button_pressed() -> void:
	SceneManager.change_scene("res://Scenes/main_menu.tscn", {
		"speed": 5,
		"pattern": "scribbles",
	})
