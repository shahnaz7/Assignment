extends Node2D

@onready var left_limit = $FloorLimitLeft
@onready var right_limit = $FloorLimitRight
@onready var hard_tiles_node = $"../../HardTiles"
@onready var floor_spawner_location = $"../FloorSpawnerYPosition"
@onready var depth_label = $"../../CanvasLayer/DepthLabel"

var player: Node = null
var floor_tile_scene: PackedScene = preload("res://Scenes/hard_tile.tscn")
var health_potion_scene: PackedScene = preload("res://Scenes/potion.tscn")
var max_tile_quantity = 300
const tile_size = 32
const METERS_PER_LAYER = 3.0

var spawn_next_location: float
var initial_y_position: float
var deepest_depth: float = 0.0
var is_initial_position_set: bool = false

func _ready():
	# Spawn initial rows and set initial_y_position based on the first row
	spawn_row()
	initial_y_position = spawn_next_location - tile_size  # First row's y position
	is_initial_position_set = true
	update_depth_label()
	print("Initial y position set to first row: ", initial_y_position)
	
	spawn_row()
	spawn_row()

func _process(delta):
	# Find the player if not already found (for depth tracking)
	if not player:
		player = get_tree().get_first_node_in_group("player")
		if not player:
			print("Player not found yet...")
			return
		else:
			print("Player found at y: ", player.global_position.y)
	
	# Calculate depth and update label
	if is_initial_position_set:
		var current_depth = calculate_depth()
		if current_depth > deepest_depth:
			deepest_depth = current_depth
			update_depth_label()
	
	# Spawn new row based on this node's global_position.y (as in the provided script)
	if global_position.y > spawn_next_location:
		spawn_row()

func calculate_depth() -> float:
	var y_distance = player.global_position.y - initial_y_position
	var depth_in_meters = (y_distance / tile_size) * METERS_PER_LAYER
	return max(0.0, depth_in_meters)

func update_depth_label():
	if depth_label:
		depth_label.text = "Current depth: %.1f m" % deepest_depth
	else:
		print("Error: DepthLabel node not found!")

func spawn_row():
	var left_limit_position = left_limit.global_position
	var right_limit_position = right_limit.global_position
	var new_tiles = []
	var new_tile_position = left_limit_position
	
	while new_tile_position.x < right_limit_position.x:
		var new_tile = floor_tile_scene.instantiate()
		new_tile.global_position = new_tile_position
		new_tile_position.x += tile_size  # Adjust new tile position
		new_tiles.append(new_tile)
	
	for i in range(len(new_tiles)):
		# Check for skipping a tile (20% chance to create a gap)
		if randf() > 0.80:
			# In the empty gap, spawn a potion with a 10% chance
			if randf() > 0.90:  # 10% chance to spawn a potion in the empty space
				var potion = health_potion_scene.instantiate()
				potion.global_position = new_tiles[i].global_position
				# Optional: Adjust potion position slightly above the tile level
				potion.global_position.y -= 10  # Move potion 10 pixels above
				# Optional: Ensure potion renders above other elements
				potion.z_index = 1  # Ensure potion is above tiles (which are likely at z_index 0)
				hard_tiles_node.add_child(potion)
				print("Potion spawned at: ", potion.global_position)
			continue  # Skip adding the tile to create the gap
		
		# Add the tile if not skipped
		hard_tiles_node.add_child(new_tiles[i])
	
	# Set the next spawn location based on this node's global_position.y (as in the provided script)
	spawn_next_location = global_position.y + tile_size
