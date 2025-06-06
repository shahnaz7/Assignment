extends RigidBody2D

@onready var sprite = $Sprite2D
var particle_scene = preload("res://Scenes/RockParticles.tscn")

func _ready():
	if randf() > 0.5:
		sprite.flip_h = true


		

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "MainCharacter":  # Check for player
		print("Rock hit the player!")
		body.take_damage()
	elif body.is_in_group("rock_tiles"):  # Check for HardTile (add group in HardTile)
		print("Rock hit a tile!") 
	create_particles()
	queue_free()

func create_particles():
	var particles = particle_scene.instantiate()
	particles.global_position = global_position
	get_tree().current_scene.add_child(particles)

	# Access CPUParticles2D inside the particles scene
	var effect = particles.get_node("CPUParticles2D")
	effect.emitting = true

	await get_tree().create_timer(0.5).timeout
	queue_free()
