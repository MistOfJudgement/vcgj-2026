extends Node2D
class_name InventoryManager

signal clue_collected

static var instance: InventoryManager
var collected_clue: Dictionary[String, String] = {}
var collected_gun: bool = false
func _ready() -> void:
	instance = self

func collect_clue(key: String, text: String):
	if key not in collected_clue:
		collected_clue[key] = text
		clue_collected.emit(text)
		print("collected clue", key)

func collect_gun():
	collected_gun = true
	
