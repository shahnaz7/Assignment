extends Node

const SETTINGS_FILE := "user://ui_settings.cfg"
const SAVE_FILE := "user://ui_savegame.json"

var settings := {
	"audio": {
		"music": 1.0,
		"sfx": 1.0,
		"voice": 1.0
	},
	"graphics": {
		"fullscreen": false,
		"resolution": "1920x1080"
	},
	"controls": {
		"move_up": "w",
		"move_down": "s",
		"move_left": "a",
		"move_right": "d"
	},
	"gameplay": {
		"difficulty": 1,
		"show_tutorial": true
	}
}

enum DIFFICULTY {
	EASY,
	NORMAL,
	HARD
}
var current_game_difficulty: DIFFICULTY
var difficulty_label = ["EASY", "NORMAL", "HARD"]

var save_data := {}
var config = ConfigFile.new()


# Called when the autoload initializes
func _ready():
	load_settings()
	load_game()

# ========== SETTINGS MANAGEMENT ==========

# Get a setting value
func get_setting(category: String, key: String):
	return settings.get(category, {}).get(key, null)

# Set a setting value and save it
func set_setting(category: String, key: String, value):
	if settings.has(category):
		settings[category][key] = value
		save_settings()

# Save settings to a file
func save_settings():
	for category in settings.keys():
		for key in settings[category].keys():
			config.set_value(category, key, settings[category][key])
	config.save(SETTINGS_FILE)

# Load settings from file
func load_settings():
	if config.load(SETTINGS_FILE) == OK:
		for category in settings.keys():
			for key in settings[category].keys():
				settings[category][key] = config.get_value(category, key, settings[category][key])

# ========== SAVE / LOAD GAME DATA ==========

# Save game data to a JSON file
func save_game():
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data, "\t"))
		file.close()

# Load game data from a JSON file
func load_game():
	if FileAccess.file_exists(SAVE_FILE):
		var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
		if file:
			var content = file.get_as_text()
			var parsed = JSON.parse_string(content)
			print("parsed content found :", content)
			if parsed is Dictionary:
				save_data = parsed
			file.close()
			print("save data is -> ", JSON.stringify(save_data))

# Reset save data
func reset_game_data():
	save_data = {}
	save_game()
