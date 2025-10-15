extends CharacterBody2D

class_name Player;

@export var speed = 400
@export var clump: Array;
var screen_size
var mob_sprite;

func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1

	if direction.x != 0:
		velocity.x = max(min(speed / 2.0, velocity.x + direction.normalized().x * speed * delta), -speed / 2.0)
	else:
		velocity.x = lerpf(velocity.x, 0, 0.05)
		
	if direction.y != 0:
		velocity.y = max(min(speed / 2.0, velocity.y + direction.normalized().y * speed * delta), -speed / 2.0)
	else:
		velocity.y = lerpf(velocity.y, 0, 0.05)
	
	if velocity.x < 2 && velocity.x > -2:
		pass
	elif velocity.x > 0:
		$Sprite2D.rotation_degrees += 4 * (velocity.x / (speed / 2.0))
	elif velocity.x < 0:
		$Sprite2D.rotation_degrees -= 4 * (-velocity.x / (speed / 2.0))
	
	move_and_slide()
	
	var last_collision = get_last_slide_collision()
	if last_collision:
		var body = last_collision.get_collider()
		if body is Mob:
			body.join_clump(clump.size())	
			var image = Image.load_from_file("res://256x256.png")
			var texture = ImageTexture.create_from_image(image)
			mob_sprite = Sprite2D.new()
			mob_sprite.z_index = 10;
			mob_sprite.scale = mob_sprite.scale * 2;
			mob_sprite.texture = texture
			mob_sprite.offset = body.clump_offset;
			mob_sprite.rotation = randf();
			$Sprite2D.add_child(mob_sprite);
	
	var new_rotation = global_position.angle_to_point(global_position + velocity)
	if new_rotation != $GuyAnchor.rotation:
		var tween = create_tween()
		tween.tween_property(
			$GuyAnchor, "rotation", new_rotation, 0.25
		).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.parallel()
		tween.tween_property(
			$GuyAnchor/AnimatedSprite2D, "rotation", -new_rotation, 0.25
		).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		
	if $GuyAnchor.rotation_degrees >= 0 && $GuyAnchor.rotation_degrees < 180:
		$GuyAnchor.z_index = 0
	else:
		$GuyAnchor.z_index = 1
		
	if velocity.length() < 2 && velocity.length() > -2:
		if $GuyAnchor.z_index == 0:
			$GuyAnchor/AnimatedSprite2D.play("stand")
		else:
			$GuyAnchor/AnimatedSprite2D.play("stand_back")
	else:
		if $GuyAnchor.z_index == 0:
			$GuyAnchor/AnimatedSprite2D.play("walk")
		else:
			$GuyAnchor/AnimatedSprite2D.play("walk_back")
	
func start(pos):
	position = pos
