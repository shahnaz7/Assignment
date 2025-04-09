extends CharacterBody2D

@onready var animatedSprite = $AnimatedSprite2D
@export var max_health: int = 4
var current_health: int = max_health
var is_invincible = false

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_facing_right = true

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0  # Reset vertical velocity when on floor

	# Jump
	if Input.is_action_just_pressed("JUMP"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			print("Jump triggered with velocity: ", velocity.y)
		else:
			print("Can't jump - not on floor")

	var direction = Input.get_axis("LEFT", "RIGHT")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _process(delta):
	animate()
	flip()
	
func animate():
	if not is_on_floor():
		animatedSprite.play("jump")	
	elif abs(velocity.x) > 0.05:
		animatedSprite.play("run")
	else:
		animatedSprite.play("idle")
	
func flip():
	if velocity.x < -0.5 and is_facing_right:
		scale.x *= -1
		is_facing_right = false
	if velocity.x > 0.5 and not is_facing_right:
		scale.x *= -1
		is_facing_right = true	

func take_damage():
	if is_invincible:
		return 
	
	current_health -= 1
	is_invincible = true
	$HitSound.play()
	$HitTimer.start()  # Start 3s cooldown
	update_health_bar()
	
	if current_health <= 0:
		print("Player dead")
		SceneManager.change_scene("res://Scenes/GameOver.tscn", {
		"speed": 5,
		"pattern": "scribbles",
	})

func _on_hit_timer_timeout() -> void:
	is_invincible = false
	
func update_health_bar():
	var health_bar = get_node("../CanvasLayer/HealthBar")
	var health_text = health_bar.get_node("Health")

	health_bar.value = current_health
	health_text.text = "Health: " + str(current_health)
