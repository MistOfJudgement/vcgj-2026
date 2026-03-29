extends Control
signal safe_solved
@export var answer = "1234"

@onready var label = $Label
@onready var buttonContainer: Control = $GridContainer

func _ready() -> void:
	var buttons: Array[Button] = []
	for panel: Panel in buttonContainer.get_children():
		if panel.get_child(0) is Button:
			buttons.append(panel.get_child(0))
	for i in range(9):
		buttons[i].text = "%d" % (i+1)
		buttons[i].pressed.connect(func (): button_press(i+1))
	buttons[9].text = "Clear"
	buttons[9].pressed.connect(reset)
	buttons[10].text = "0"
	buttons[10].pressed.connect(func (): button_press(0))
	buttons[11].text = "Exit"
	buttons[11].pressed.connect(func (): visible = false)
	
	

func button_press(number):
	if len(label.text) == 4:
		return
	label.text = label.text+ ("%d" % (number))
	check_answer()

func reset():
	label.text = ""
func check_answer():
	if label.text == answer:
		InventoryManager.instance.collected_gun = true
		self.visible = false


func _on_safe_clicked() -> void:
	if InventoryManager.instance.collected_gun: return
	visible = true
