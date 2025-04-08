extends Control

var current_score = 0
var high_score = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%CurrentScoreLabel.text = "Depth: " + str(current_score) + "m"
	%HighScoreLabel.text = "High Score: " + str(high_score) + "m"

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
