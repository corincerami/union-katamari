extends CharacterBody2D;

class_name Mob;

var player: Player;
var clump_offset: Vector2;
@export var clump_index = -1;
@export var speed = 7_000;
var personality: int;
var rng = RandomNumberGenerator.new()
const rings = [6, 18, 36, 60, 90];

enum Personalities {
	Neutral,
	Positive,
	Negative
}

func join_clump(index):
	if clump_index < 0:
		player.clump.append(self);
		clump_index = index;
		clump_offset = _get_clump_offset();
		$CollisionShape2D.set_deferred('disabled', true);
		hide()
		
func leave_clump():
	player.clump.remove_at(clump_index);
	var angle = rng.randf_range(0.0, 6.2831853); # pick a rangle angle in radians
	var offset = Vector2(0, 100).rotated(angle);
	position = player.position + offset;
	clump_index = -1; # 'unset' the index;
	personality = Personalities.Neutral;
	$CollisionShape2D.disabled = false;
	show()

func _ready():
	player = get_parent().get_parent().get_node("Player");
	var personality_random = rng.randf_range(0.0, 1.0)
	if personality_random < 0.15:
		personality = Personalities.Negative;
	elif personality_random < 0.3:
		personality = Personalities.Positive;
	else:
		personality = Personalities.Neutral;
	$CollisionShape2D.disabled = false
	
func _physics_process(delta):
	var dist = position.distance_to(player.position);
	if dist < 100 && personality != Personalities.Neutral:
		velocity = position.direction_to(player.position) * speed * delta;
		if personality == Personalities.Negative:
			velocity *= -1;
		move_and_slide();

func _get_clump_offset():
	var ring = rings.find_custom(func(r): return clump_index < r)
	var ring_capacity = (ring + 1) * 6;
	var capacity_of_prev_rings = 0;
	if ring > 0:
		capacity_of_prev_rings = rings[ring - 1];
	var position_in_ring = clump_index - capacity_of_prev_rings;
	var radians_offset = (position_in_ring + 1) / float(ring_capacity) * 6.2831853; # multiplier for percentage around a circle to radians
	var offset = Vector2(0, -1).rotated(radians_offset);
	offset = Vector2(offset.x * (ring * 200 + 30), offset.y * (ring * 200 + 30));
	return offset;
