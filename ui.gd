class_name UI
extends Control

const final_rotation = 328.5

var medium_pulse_started = false
var quick_pulse_started = false

var current_tween: Tween

func _process(_delta: float) -> void:
	var main = get_tree().root.get_child(0)
	if main && main is Main && main.current_level:
		var time_out = main.current_level.level_time
		var time_elapsed = time_out - main.current_level.get_node("LevelTimer").time_left
		
		var percent_elapsed = time_elapsed / time_out
		
		if percent_elapsed >= 0.9 && !quick_pulse_started:
			start_quick_pulse()
		elif percent_elapsed >= 0.7 && !medium_pulse_started:
			start_medium_pulse()
		elif percent_elapsed < 0.7:
			be_normal()
		
		var new_rotation = percent_elapsed * final_rotation
		$Clock/ClockPivot.rotation_degrees = new_rotation

func start_quick_pulse():
	if current_tween:
		current_tween.kill()
	quick_pulse_started = true
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property($Clock, "scale", Vector2(1.25, 1.25), 0.25).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.parallel()
	tween.tween_property($Clock, "modulate", Color(255, 0, 0), 0.25).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property($Clock, "scale", Vector2(1, 1), 0.25).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)	
	tween.parallel()
	tween.tween_property($Clock, "modulate", Color.WHITE, 0.25).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	current_tween = tween

func start_medium_pulse():
	if current_tween:
		current_tween.kill()
	medium_pulse_started = true
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property($Clock, "scale", Vector2(1.15, 1.15), 1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property($Clock, "scale", Vector2(1, 1), 1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	current_tween = tween
	
func be_normal():
	if current_tween:
		current_tween.kill()
	var tween = create_tween()
	tween.tween_property($Clock, "scale", Vector2(1, 1), 0.2)
	tween.parallel()
	tween.tween_property($Clock, "modulate", Color.WHITE, 0.2)
	medium_pulse_started = false
	quick_pulse_started = false
