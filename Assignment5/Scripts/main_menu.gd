extends Node2D




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
