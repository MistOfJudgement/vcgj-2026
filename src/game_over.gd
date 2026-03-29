extends Control
@export var rich_text_label: RichTextLabel

@onready var textLabel = $GameOver/RichTextLabel
func _on_inventory_manager_game_over(cause: String) -> void:
	visible=true
	rich_text_label.text = cause
