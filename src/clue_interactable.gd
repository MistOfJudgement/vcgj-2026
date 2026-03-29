extends Node2D

@onready var sprite := $Sprite2D
var in_range: bool = false

func _process(_delta: float) -> void:
	if in_range:
		flash()
	else:
		sprite.modulate = Color.WHITE

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
			print("clicked")
