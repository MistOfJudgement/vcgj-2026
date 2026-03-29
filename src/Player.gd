extends CharacterBody2D
class_name Player

@export var speed: float = 250
@onready var sprite: Sprite2D = $Sprite2D
# I know godot has an input system let me code quick
# fix later do now


func _process(delta: float) -> void:
	if InventoryManager.instance.is_game_over() or InventoryManager.instance.paused:
		return
	var vel: Vector2 = Vector2.ZERO
	if Input.is_key_pressed(KEY_A):
		vel += Vector2.LEFT
		sprite.flip_h = true
	if Input.is_key_pressed(KEY_D):
		vel += Vector2.RIGHT
		sprite.flip_h = false
	if Input.is_key_pressed(KEY_W):
		vel += Vector2.UP
	if Input.is_key_pressed(KEY_S):
		vel += Vector2.DOWN

	velocity = vel.normalized() * speed
	if (sprite.flip_h and velocity.x > 0) or (not sprite.flip_h and velocity.x < 0):
		sprite.flip_h = not sprite.flip_h

	move_and_slide()
