extends Node

@export var mob_scene: PackedScene
var score

var mobs = [
	{"spawn": [100, 100]},
	{"spawn": [300, 500]},
	{"spawn": [400, 200]},
	{"spawn": [400, 100]},
	{"spawn": [400, 500]},
	{"spawn": [300, 200]},
	{"spawn": [300, 100]},
	{"spawn": [100, 500]},
	{"spawn": [4500, 200]},
	{"spawn": [100, 350]},
	{"spawn": [300, 350]},
	{"spawn": [200, 350]},
]

func _ready():
	new_game()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	var mob = mob_scene.instantiate();
	var clump_index = 1;
	for mob_data in mobs:
		var unique_mob = mob.duplicate();
		
		unique_mob.position = Vector2(mob_data.spawn[0], mob_data.spawn[1]);
		unique_mob.clump_index = clump_index;
		clump_index += 1;
		# Spawn the mob by adding it to the Main scene.
		add_child(unique_mob)
