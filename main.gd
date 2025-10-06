extends Node

@export var mob_scene: PackedScene
var score

var mobs = [
	{"spawn": [100, 100], "personality": 1},
	{"spawn": [700, 500], "personality": 1},
	{"spawn": [800, 200], "personality": 1},
	{"spawn": [400, 100], "personality": 2},
	{"spawn": [1000, 500], "personality": 2},
	{"spawn": [300, 200], "personality": 2},
	{"spawn": [300, 500], "personality": 2},
	{"spawn": [100, 500], "personality": 2},
	{"spawn": [900, 200], "personality": 0},
	{"spawn": [100, 350], "personality": 0},
	{"spawn": [300, 350], "personality": 0},
	{"spawn": [200, 350], "personality": 0},
]

func _ready():
	new_game()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	var mob = mob_scene.instantiate();
	for mob_data in mobs:
		var unique_mob = mob.duplicate();
		
		unique_mob.position = Vector2(mob_data.spawn[0], mob_data.spawn[1]);
		unique_mob.personality = mob_data.personality;
		# Spawn the mob by adding it to the Main scene.
		add_child(unique_mob)
