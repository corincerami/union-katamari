class_name Main
extends Node

var current_level: Level

func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)
	change_level(1);

func change_level(level_num: int):
	# Remove the current level
	if level_num > 1:
		remove_child(current_level)
		current_level.call_deferred("free")

	# Start the level
	current_level = get_node('Level%s' % str(level_num));
	current_level.start_level();
