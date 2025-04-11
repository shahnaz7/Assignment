extends Node2D

@onready var high_score_label = %ScoreLabel

func _ready() -> void:
	high_score_label.text = "%d" % ScoreManager.high_score + "m"


func _on_start_game_button_pressed():
	SceneManager.change_scene("res://Scenes/boulder_dash.tscn", {
		"speed": 5,
		"pattern": "scribbles",
	})


func _on_exit_game_button_pressed():
	get_tree().quit()


func _on_english_pressed() -> void:
	TranslationServer.set_locale("en")


func _on_french_pressed() -> void:
	TranslationServer.set_locale("fr")
