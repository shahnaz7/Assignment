extends Area2D




func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):  # Add "player" group to your character
		body.current_health = body.max_health  # Restore full health
		body.update_health_bar()  # Update the health bar
		queue_free()  # Remove the potion after pickup
