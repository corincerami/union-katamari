extends Node

@export var mob_scene: PackedScene
@onready var level_timer = $Timer

enum Ratings {
	S,
	A,
	B,
	C,
	D,
	E,
	F
}

var mobs = [
{"spawn": [335, 93]},
{"spawn": [335, 31]},
{"spawn": [315, 31]},
{"spawn": [295, 29]},
{"spawn": [277, 29]},
{"spawn": [260, 30]},
{"spawn": [569, 294]},
{"spawn": [606, 256]},
{"spawn": [551, 236]},
{"spawn": [587, 206]},
{"spawn": [209, 456]},
{"spawn": [262, 452]},
{"spawn": [239, 428]},
{"spawn": [200, 414]},
{"spawn": [245, 388]},
{"spawn": [285, 411]},
{"spawn": [261, 93]},
{"spawn": [280, 93]},
{"spawn": [300, 93]},
{"spawn": [317, 94]}
]

var level_time = 60;

func _ready():
	level_timer.timeout.connect(_on_level_timer_timeout)
	level_timer.wait_time = level_time;
	new_game()

func new_game():
	$Player.start($StartPosition.position)
	$Player.clump = []
	var mob = mob_scene.instantiate();
	for mob_data in mobs:
		var unique_mob = mob.duplicate();
		
		unique_mob.position = Vector2(mob_data.spawn[0], mob_data.spawn[1]);
		# Spawn the mob by adding it to the Main scene.
		add_child(unique_mob)
	level_timer.start();
	
func game_over():
	for child in get_children():
		if child is Mob:
			child.queue_free();
	new_game();

func _get_rating():
	var total = mobs.size()
	var score = $Player.clump.size();
	var percent = float(score) / total
	if percent < 0.6:
		return Ratings.F
	elif percent < 0.7:
		return Ratings.D
	elif percent < 0.8:
		return Ratings.C
	elif percent < 0.9:
		return Ratings.B
	elif percent < 1:
		return Ratings.A
	elif percent == 1:
		return Ratings.S

func _on_level_timer_timeout():
	level_timer.stop()
	var rating = _get_rating();
	if rating == Ratings.F:
		game_over();
