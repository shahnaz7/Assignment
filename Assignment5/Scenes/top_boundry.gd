extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.name == "MainCharacter":
		SceneManager.change_scene("res://Scenes/GameOver.tscn", {
		"speed": 5,
		"pattern": "scribbles",
	})
