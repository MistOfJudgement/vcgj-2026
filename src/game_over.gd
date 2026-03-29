extends Control
@export var rich_text_label: RichTextLabel

@onready var textLabel = $GameOver/Panel/RichTextLabel
@onready var win_panel = $Win
@onready var lose_panel = $Lose
var already_done: bool = false
func _on_inventory_manager_game_over(cause: String) -> void:
	visible=true
	if cause.begins_with("You WIN. You brought your father back to life"):
		win_panel.visible=true
		lose_panel.visible = false
	elif not win_panel.visible:
		lose_panel.visible=true
	if not already_done:
		rich_text_label.text = cause
	already_done = true
		
