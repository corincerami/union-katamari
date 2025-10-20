extends CharacterBody2D

class_name FriendlyPowerup

var player: Player;

func _ready():
	player = get_parent().get_parent().get_node("Player");
	$CollisionShape2D.disabled = false

func picked_up():
	player.all_friendly = true;
	$CollisionShape2D.set_deferred('disabled', true);
	hide();
	$Timer.timeout.connect(_on_timer_timeout)
	$Timer.wait_time = 5;
	$Timer.start()

func _on_timer_timeout():
	player.all_friendly = false;
