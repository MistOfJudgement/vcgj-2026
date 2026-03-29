extends Control

@onready var clue_holder = $Panel/VBoxContainer/ScrollContainer/ClueHolder
@onready var template = $Panel/VBoxContainer/ScrollContainer/ClueHolder/TemplatePanel
func _ready() -> void:
	visibility_changed.connect(on_visible_changed)
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_pressed() and event.keycode == KEY_ESCAPE:
			visible = !visible

func on_visible_changed():
	pass

func build_clue(str: String):
	template.visible = false
	var clue = template.duplicate()
	var clueLabel = clue.get_child(0)
	clueLabel.text = str
	clue.visible = true
	clue_holder.add_child(clue)
	print("build")


func _on_inventory_manager_clue_collected(str: String) -> void:
	build_clue(str)


func _on_title_pressed() -> void:
	pass # Replace with function body.


func _on_resume_pressed() -> void:
	visible = false
