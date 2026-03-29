extends Node2D
class_name InventoryManager

signal clue_collected
signal game_over
signal gun_get
static var instance: InventoryManager
var collected_clue: Dictionary[String, String] = {}
var collected_gun: bool = false
var game_over_cause: String = ""
var paused: bool = false

func _ready() -> void:
	instance = self

func collect_clue(key: String, text: String):
	if key not in collected_clue:
		collected_clue[key] = text
		clue_collected.emit(text)
		print("collected clue", key)
func set_game_over(cause: String):
	game_over_cause = cause
	paused = true
	game_over.emit(game_over_cause)
	
func collect_gun():
	collected_gun = true
	gun_get.emit()
	
func is_game_over(): return not game_over_cause.is_empty()
