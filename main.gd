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
{"spawn": [-516, -225]},
{"spawn": [-230, -268]},
{"spawn": [-270, -269]},
{"spawn": [-308, -268]},
{"spawn": [-341, -268]},
{"spawn": [-375, -269]},
{"spawn": [-415, -269]},
{"spawn": [-449, -270]},
{"spawn": [-482, -270]},
{"spawn": [-513, -269]},
{"spawn": [224, -263]},
{"spawn": [508, -184]},
{"spawn": [543, -74]},
{"spawn": [500, -26]},
{"spawn": [550, -23]},
{"spawn": [530, 272]},
{"spawn": [525, 247]},
{"spawn": [454, 291]},
{"spawn": [412, 152]},
{"spawn": [371, 194]},
{"spawn": [322, 193]},
{"spawn": [284, 193]},
{"spawn": [244, 194]},
{"spawn": [206, 197]},
{"spawn": [165, 154]},
{"spawn": [374, 107]},
{"spawn": [325, 108]},
{"spawn": [288, 108]},
{"spawn": [253, 108]},
{"spawn": [215, 105]},
{"spawn": [178, -46]},
{"spawn": [149, 4]},
{"spawn": [117, -53]},
{"spawn": [105, -18]},
{"spawn": [-229, -227]},
{"spawn": [-303, -224]},
{"spawn": [-367, -225]},
{"spawn": [-390, -224]},
{"spawn": [-445, -225]},
{"spawn": [-480, -226]},
{"spawn": [-320, 135]},
{"spawn": [-116, 205]},
{"spawn": [-374, -178]},
{"spawn": [-339, -178]},
{"spawn": [-301, -180]},
{"spawn": [-269, -180]},
{"spawn": [-229, -183]},
{"spawn": [-504, 278]},
{"spawn": [-529, 139]},
{"spawn": [-525, -16]},
{"spawn": [-364, 49]},
{"spawn": [-368, 220]},
{"spawn": [-325, 221]},
{"spawn": [-360, 133]},
{"spawn": [-318, 44]},
{"spawn": [-158, -88]},
{"spawn": [-165, 1]},
{"spawn": [-192, -46]},
{"spawn": [-108, -89]},
{"spawn": [-78, -43]},
{"spawn": [-114, 1]},
{"spawn": [-133, -37]},
{"spawn": [-231, -135]},
{"spawn": [-265, -139]},
{"spawn": [-300, -137]},
{"spawn": [-409, -138]},
{"spawn": [-445, -139]},
{"spawn": [-2, -272]},
{"spawn": [30, -302]},
{"spawn": [-517, -140]},
{"spawn": [-513, -183]},
{"spawn": [-476, -181]},
{"spawn": [-441, -181]},
{"spawn": [-408, -178]},
{"spawn": [440, -269]},
{"spawn": [438, -301]},
{"spawn": [476, -302]},
{"spawn": [477, -266]},
{"spawn": [512, -302]},
{"spawn": [508, -268]},
{"spawn": [508, -236]},
{"spawn": [476, -239]},
{"spawn": [440, -240]},
{"spawn": [407, -305]},
{"spawn": [406, -272]},
{"spawn": [406, -243]}
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
