extends Button


func _ready() -> void:
	pressed.connect(goto_title)
	
func goto_title():
	get_tree().change_scene_to_file("res://Title.tscn")
