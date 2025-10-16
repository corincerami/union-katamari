extends CharacterBody2D

class_name UnionBuster

var player: Player;
var origin: Vector2;
var speed = 7000;
var resetting = false;

func _ready():
	player = get_parent().get_parent().get_node("Player");
	position = origin;

func _physics_process(delta):
	var dist_from_player = position.distance_to(player.position);
	var dist_from_origin = position.distance_to(origin);
	if dist_from_origin < 1 && resetting:
		resetting = false;
		$CollisionShape2D.set_deferred('disabled', false);
	if dist_from_player < 100 && dist_from_origin < 100 && !resetting:
		velocity = position.direction_to(player.position) * speed * delta;
		move_and_slide();
	else:
		velocity = position.direction_to(origin) * speed * delta / 3;
		move_and_slide();

func collide_with_player():
	$CollisionShape2D.set_deferred('disabled', true);
	resetting = true;
