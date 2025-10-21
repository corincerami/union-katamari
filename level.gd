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
var walls: Array

var level_time: int
var start_position: Vector2

@export var mob_scene: PackedScene
@export var union_buster_scene: PackedScene
@export var friendly_powerup_scene: PackedScene
@export var wall_scene: PackedScene
@export var level_index: int

func _ready():
	var file = FileAccess.get_file_as_string("res://level_%s.json" % level_index)
	var content = JSON.parse_string(file)
	level_time = content.level_time
	start_position = Vector2(content.start_position[0], content.start_position[1])
	mobs = content.mobs
	union_busters = content.union_busters
	powerups = content.powerups
	walls = content.walls
	player = get_parent().get_node('Player')
	$LevelTimer.timeout.connect(_on_level_timer_timeout)
	$LevelTimer.wait_time = level_time;

func start_level():
	player.reset_clump()
	player.start(start_position);
	create_workers()
	create_union_busters()	
	create_powerups()
	create_walls()
	$LevelTimer.start()

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

func create_workers():
	var mob = mob_scene.instantiate();
	for data in mobs:
		var unique_mob = mob.duplicate();
		
		unique_mob.position = Vector2(data.spawn[0], data.spawn[1]);
		# Spawn the mob by adding it to the Main scene.
		add_child(unique_mob)

func create_union_busters():
	var union_buster = union_buster_scene.instantiate();
	for data in union_busters:
		var unique_ub = union_buster.duplicate();
		unique_ub.origin = Vector2(data.spawn[0], data.spawn[1]);
		add_child(unique_ub);

func create_powerups():
	var friendly_powerup = friendly_powerup_scene.instantiate();
	for data in powerups:
		var unique_powerup = friendly_powerup.duplicate();
		unique_powerup.position = Vector2(data.spawn[0], data.spawn[1])
		add_child(unique_powerup)

func create_walls():
	var wall = wall_scene.instantiate()
	for data in walls:
		var unique_wall = wall.duplicate()
		unique_wall.position = Vector2(data.spawn[0], data.spawn[1])
		var size = Vector2(data.size.width, data.size.height)
		var shape = RectangleShape2D.new()
		shape.size = size
		unique_wall.get_node('CollisionShape2D').shape = shape
		var image = Image.load_from_file(data.sprite)
		var texture = ImageTexture.create_from_image(image)
		texture.set_size_override(size)
		var wall_sprite = Sprite2D.new()
		wall_sprite.z_index = 10;
		wall_sprite.texture = texture
		unique_wall.get_node("Sprite2D").add_child(wall_sprite);
		add_child(unique_wall)
