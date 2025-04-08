extends RigidBody2D

@onready var sprite = $Sprite2D

func _ready():
	if randf() > 0.5:
		sprite.flip_h = true


		

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "MainCharacter":  # Or check for class
		print("Rock hit the player!")
		body.take_damage()
		queue_free()  # Remove the rock after hit
