extends Control

@onready var label_move = %Label_move
@onready var label_mobile = %Label_mobile
@onready var label_pc = %Label_pc


func _ready():
	if Globals.language == "ru":
		Language_RU()
	elif Globals.language == "en":
		Language_EN()


func _on_pc_pressed():
	Globals.platform = "pc"
	get_tree().call_group("Level_1", "pc_move")
	get_tree().call_group("UI", "Control_mobile_visible_off")
	get_tree().change_scene_to_packed(Globals.level_scene)

func _on_mobile_pressed():
	Globals.platform = "mobile"
	get_tree().call_group("Level_1", "mobile_move")
	get_tree().call_group("UI", "Control_mobile_visible_on")
	get_tree().change_scene_to_packed(Globals.level_scene)

func Language_RU():
	label_move.text = "Выберите способ управления"
	label_mobile.text = "Телефон"
	label_pc.text = "Компьютер"
func Language_EN():
	label_move.text = "Select a control method"
	label_mobile.text = "Mobile"
	label_pc.text = "Computer"
