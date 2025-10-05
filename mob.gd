extends RigidBody2D

var clumped;

func _ready():
	clumped = false;

func start(pos):
	position = pos
	$CollisionShape2D.disabled = false
	
func _process(delta):
	if clumped:
		position = get_parent().get_node("Player").position;
	

func _on_player_hit() -> void:
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
	clumped = true;
