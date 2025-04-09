extends Node2D

@onready var left_limit = $FloorLimitLeft
@onready var right_limit = $FloorLimitRight
@onready var hard_tiles_node = $"../../HardTiles"
@onready var floor_spawner_location = $"../FloorSpawnerYPosition"

var floor_tile_scene: PackedScene = preload("res://Scenes/hard_tile.tscn")
var health_potion_scene: PackedScene = preload("res://Scenes/potion.tscn")
var max_tile_quantity = 300
const tile_size = 32

var spawn_next_location: float

func _ready():
	spawn_row()
	spawn_row()
	spawn_row()

func _process(delta):
	if global_position.y > spawn_next_location:
		spawn_row()

func spawn_row():
	var left_limit_position = left_limit.global_position
	var right_limit_position = right_limit.global_position
	var new_tiles = []
	var new_tile_position = left_limit_position
	
	while(new_tile_position.x < right_limit_position.x):
		var new_tile = floor_tile_scene.instantiate()
		new_tile.global_position = new_tile_position
		new_tile_position.x += tile_size
		new_tiles.append(new_tile)
	
	for i in range(len(new_tiles)):
		var random_chance = randf()
		if random_chance > 0.80:  # 20% chance of a gap
			if random_chance > 0.95:  # 10% of gaps get a potion
				var potion = health_potion_scene.instantiate()
				potion.global_position = new_tiles[i].global_position
				hard_tiles_node.add_child(potion)
				print("Potion spawned at: ", potion.global_position)
			continue
		hard_tiles_node.add_child(new_tiles[i])
	
	spawn_next_location = global_position.y + tile_size
