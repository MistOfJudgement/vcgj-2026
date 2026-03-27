extends CharacterBody2D


@export var speed: float = 250
# I know godot has an input system let me code quick
# fix later do now

func _process(delta: float) -> void:
	var vel: Vector2 = Vector2.ZERO
	if Input.is_key_pressed(KEY_A):
		vel += Vector2.LEFT
	if Input.is_key_pressed(KEY_D):
		vel += Vector2.RIGHT
	if Input.is_key_pressed(KEY_W):
		vel += Vector2.UP
	if Input.is_key_pressed(KEY_S):
		vel += Vector2.DOWN
	
	velocity = vel.normalized() * speed
	move_and_slide()
	
		
