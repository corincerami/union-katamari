extends Node

@export var mob_scene: PackedScene
var score

var mobs = [
	{"spawn": [100, 100]},
	{"spawn": [300, 500]}
]

func _ready():
	new_game()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	for mob_data in mobs:
		var mob = mob_scene.instantiate();

		mob.position = Vector2(mob_data.spawn[0], mob_data.spawn[1]);

		# Spawn the mob by adding it to the Main scene.
		add_child(mob)
