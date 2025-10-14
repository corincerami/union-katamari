extends Node2D

@export var mob_scene: PackedScene

var start_position = Vector2(0, 300);
var level_index = 2;

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
	{"spawn": [0, 0]}
]

var level_timer;
var level_time = 5;
var player;

func _ready():
	player = get_parent().get_node('Player');
	$LevelTimer.timeout.connect(_on_level_timer_timeout)
	$LevelTimer.wait_time = level_time;

func start_level():
	player.start(start_position);
	player.clump = []
	var mob = mob_scene.instantiate();
	for mob_data in mobs:
		var unique_mob = mob.duplicate();
		
		unique_mob.position = Vector2(mob_data.spawn[0], mob_data.spawn[1]);
		# Spawn the mob by adding it to the Main scene.
		add_child(unique_mob)
	$LevelTimer.start();

func game_over():
	for child in get_children():
		if child is Mob:
			child.queue_free();
	start_level();

func _on_level_timer_timeout():
	$LevelTimer.stop()
	var rating = _get_rating();
	if rating == Ratings.F:
		game_over();
	else:
		get_parent().change_level(level_index + 1);

func _get_rating():
	var total = mobs.size()
	var score = player.clump.size();
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
