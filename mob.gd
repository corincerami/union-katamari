extends CharacterBody2D;

var player;
var clump_offset = [0, 0];
@export var clumped = false;
@export var clump_index = 0;
@export var speed = 6000;
@export var personality: int;

func _ready():
	player = get_parent().get_node("Player");
	clump_offset = _get_clump_offset()
	$CollisionShape2D.disabled = false
	
func _physics_process(delta):
	if clumped:
		position = Vector2(player.position.x + clump_offset[0], player.position.y + clump_offset[1]);
	else:
		var dist = position.distance_to(player.position);
		if dist < 100 && personality != 0:
			velocity = position.direction_to(player.position) * speed * delta;
			if personality == 2:
				velocity *= -1;
			move_and_slide();
		

func _get_clump_offset():
	var mod = clump_index % 8;
	if mod == 0:
		clump_offset = [20, 0];
	if mod == 1:
		clump_offset = [13, 13];
	if mod == 2:
		clump_offset = [0, 20];
	if mod == 3:
		clump_offset = [-13, 13];
	if mod == 4:
		clump_offset = [-20, 0];
	if mod == 5:
		clump_offset = [-13, -13];
	if mod == 6:
		clump_offset = [0, -20];
	if mod == 7:
		clump_offset = [13, -13];
	
	var ring = round(clump_index / 8.0) + 1;
	print_debug(ring);
	if ring > 1:
		clump_offset = [clump_offset[0] * ring, clump_offset[1] * ring];
	return clump_offset;
