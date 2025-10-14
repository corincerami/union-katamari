extends Node

func _ready():
	change_level(1);

func change_level(level_num: int):
	# Remove the current level
	if level_num > 1:
		var level = get_node("Level%s" % str(level_num - 1));
		remove_child(level)
		level.call_deferred("free")

	# Add the next level
	var next_level = get_node('Level%s' % str(level_num));
	add_child(next_level)
	next_level.start_level();
