extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var hit_sound = $HitSound  # Ensure this is an AudioStreamPlayer node
@onready var hit_timer = $HitTimer  # Ensure this is a Timer node
@export var max_health: int = 4
var current_health: int = max_health
var is_invincible: bool = false
var invincibility_time: float = 3.0
var flash_toggle: bool = false

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_facing_right: bool = true

func _ready():
	add_to_group("player")
	current_health = max_health
	hit_sound.stream = preload("res://Assets/Audio/mixkit-negative-guitar-tone-2324.wav")  # Load the sound
	hit_timer.wait_time = 0.2  # Flash interval (adjust for desired speed)
	hit_timer.one_shot = false  # Allow repeated timeouts for flashing

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	# Jump
	if Input.is_action_just_pressed("JUMP") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		print("Jump triggered with velocity: ", velocity.y)

	var direction = Input.get_axis("LEFT", "RIGHT")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _process(delta):
	if is_invincible:
		invincibility_time -= delta
		if invincibility_time <= 0:
			end_invincibility()
	animate()
	flip()

func animate():
	if not is_on_floor():
		animated_sprite.play("jump")
	elif abs(velocity.x) > 0.05:
		animated_sprite.play("run")
	else:
		animated_sprite.play("idle")

func flip():
	if velocity.x < -0.5 and is_facing_right:
		scale.x *= -1
		is_facing_right = false
	elif velocity.x > 0.5 and not is_facing_right:
		scale.x *= -1
		is_facing_right = true

func take_damage():
	if is_invincible:
		return
	
	# Start invincibility
	is_invincible = true
	invincibility_time = 3.0  # Reset to 3 seconds
	current_health -= 1
	hit_sound.play()  # Play negative-guitar-tone
	hit_timer.start()  # Start flashing
	update_health_bar()

	if current_health <= 0:
		print("Player dead")
		SceneManager.change_scene("res://Scenes/GameOver.tscn", {
			"speed": 5,
			"pattern": "scribbles",
		})

func end_invincibility():
	is_invincible = false
	hit_timer.stop()
	animated_sprite.modulate = Color(1, 1, 1)  # Reset to normal color
	flash_toggle = false

func _on_hit_timer_timeout():
	flash_toggle = !flash_toggle
	animated_sprite.modulate = Color(1, 0.6, 0.6) if flash_toggle else Color(1, 1, 1)

func update_health_bar():
	var health_bar = get_node_or_null("../CanvasLayer/HealthBar")
	if health_bar:
		health_bar.value = current_health
		var health_text = health_bar.get_node_or_null("Health")
		if health_text:
			health_text.text = "Health: " + str(current_health)
	else:
		print("Health bar node not found!")
