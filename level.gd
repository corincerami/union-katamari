extends Node2D

class_name Level

var player: Player

enum Ratings {
	S,
	A,
	B,
	C,
	D,
	E,
	F
}

var mobs: Array
var union_busters: Array
var powerups: Array

var level_time: int
var start_position: Vector2

@export var mob_scene: PackedScene
@export var union_buster_scene: PackedScene
@export var friendly_powerup_scene: PackedScene
@export var level_index: int

func _ready():
	var file = FileAccess.get_file_as_string("res://level_%s.json" % level_index)
	var content = JSON.parse_string(file)
	level_time = content.level_time
	start_position = Vector2(content.start_position[0], content.start_position[1])
	mobs = content.mobs
	union_busters = content.union_busters
	powerups = content.powerups
	player = get_parent().get_node('Player')
	$LevelTimer.timeout.connect(_on_level_timer_timeout)
	$LevelTimer.wait_time = level_time;

func start_level():
	player.reset_clump()
	player.start(start_position);
	var mob = mob_scene.instantiate();
	for mob_data in mobs:
		var unique_mob = mob.duplicate();
		
		unique_mob.position = Vector2(mob_data.spawn[0], mob_data.spawn[1]);
		# Spawn the mob by adding it to the Main scene.
		add_child(unique_mob)
	var union_buster = union_buster_scene.instantiate();
	for ub_data in union_busters:
		var unique_ub = union_buster.duplicate();
		unique_ub.origin = Vector2(ub_data.spawn[0], ub_data.spawn[1]);
		add_child(unique_ub);
	
	var friendly_powerup = friendly_powerup_scene.instantiate();
	for powerup_data in powerups:
		var unique_powerup = friendly_powerup.duplicate();
		unique_powerup.position = Vector2(powerup_data.spawn[0], powerup_data.spawn[1])
		add_child(unique_powerup)
	$LevelTimer.start();

func game_over():
	for child in get_children():
		if child is Mob || child is UnionBuster:
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
