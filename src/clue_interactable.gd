extends Node2D
signal clicked
@export_multiline() var text: String
@onready var sprite := $Sprite2D
@export var destinationArea: Control

var in_range: bool = false
var tween: Tween
func _process(_delta: float) -> void:
	if in_range:
		flash()
	else:
		sprite.modulate = Color.WHITE
	if tween:
		global_position = global_position.lerp(world_pos_center(destinationArea), 0.1)

func flash():
	sprite.modulate = Color.BLUE
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("inrange")
		in_range = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		in_range = false



func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and in_range:
			if text != "": # random hardcode for safe stuff
				InventoryManager.instance.collect_clue(self.name, text)
				animate_out()
			else:
				clicked.emit()

func animate_out():
	if destinationArea == null:
		queue_free()
		return
	if tween != null:
		return
	tween = create_tween()
	# tween.tween_property(self, "global_position", world_pos_center(destinationArea), 1)
	tween.tween_property(sprite, "scale", Vector2.ZERO, 1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_callback(queue_free)

static func world_rect(control: Control) -> Rect2:
	var screen_coords = control.get_viewport_transform() * control.get_global_rect()
	var scene_root = control.get_tree().current_scene
	assert(
		scene_root as Node2D,
		"Cannot call from within a CanvasLayer scene. You must have a Node2D root."
	)
	var rect = scene_root.get_viewport_transform().affine_inverse() * screen_coords
	return rect


# Get world position of the centre of a control in a CanvasLayer.
static func world_pos_center(control: Control):
	return world_rect(control).get_center()
