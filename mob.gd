extends CharacterBody2D;

class_name Mob;

var player: Player;
var clump_offset: Array;
@export var clump_index: int;
@export var speed = 7_000;
var personality: int;
var rng = RandomNumberGenerator.new()

enum Personalities {
	Neutral,
	Positive,
	Negative
}

func join_clump(index):
	if !clump_index:
		player.clump.append(self);
		clump_index = index;
		clump_offset = _get_clump_offset();
		$CollisionShape2D.set_deferred('disabled', true);

func _ready():
	player = get_parent().get_node("Player");
	var personality_random = rng.randf_range(0.0, 1.0)
	if personality_random < 0.15:
		personality = Personalities.Negative;
	elif personality_random < 0.3:
		personality = Personalities.Positive;
	else:
		personality = Personalities.Neutral;
	$CollisionShape2D.disabled = false
	
func _physics_process(delta):
	if clump_index:			
		position = Vector2(player.position.x + clump_offset[0], player.position.y + clump_offset[1]);
	else:
		var dist = position.distance_to(player.position);
		if dist < 100 && personality != Personalities.Neutral:
			velocity = position.direction_to(player.position) * speed * delta;
			if personality == Personalities.Negative:
				velocity *= -1;
			move_and_slide();
		

func _get_clump_offset():
#	This will position mobs in 8 points around the player
	var ring = clump_index / 6 + 1;
	print_debug(ring);
	var members_in_ring = ring * 6;
	var position_in_ring = clump_index - members_in_ring;
	var degrees_offset = position_in_ring / float(members_in_ring) * 360;
	var offset = Vector2(0, -1).rotated(degrees_offset);
	clump_offset = [offset.x, offset.y]
	clump_offset = [clump_offset[0] * (ring + 30), clump_offset[1] * (ring + 30)];
	return clump_offset;
