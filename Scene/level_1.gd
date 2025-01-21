extends Node2D


@onready var marker_l = %Marker_L
@onready var marker_t = %Marker_T
@onready var marker_r = %Marker_R
@onready var marker_b = %Marker_B
@onready var music_1 = %Music_1
@onready var music_2 = %Music_2
@onready var music_3 = %Music_3
@onready var music_4 = %Music_4
@onready var music_5 = %Music_5
@onready var audio_russia = %Audio_Russia

@onready var voice_durov = %Voice_Durov

@onready var mobile_ui = %MobileUi
@onready var move_setting = %Move_setting

var ui_mobile_ru = preload("res://Sprites/UI/mobile_ui_ru.png")
var ui_mobile_en = preload("res://Sprites/UI/mobile_ui_en.png")




var music_arr = ["music_1", "music_2", "music_3", "music_4", "music_5"]



# Called when the node enters the scene tree for the first time.
func _ready():
	if Globals.language == "ru":
		Language_RU()
	elif Globals.language == "en":
		Language_EN()
	
	if Globals.platform == "mobile":
		pc_move()
		get_tree().call_group("UI", "Control_mobile_visible_off")
	elif Globals.platform == "pc":
		mobile_move()
		get_tree().call_group("UI", "Control_mobile_visible_on")
	
	create_traps()
	music_1.volume_db = Globals.music
	music_2.volume_db = Globals.music
	music_3.volume_db = Globals.music
	music_4.volume_db = Globals.music
	music_5.volume_db = Globals.music
	var actual_track = music_arr.pick_random()
	if actual_track == music_arr[1] and Globals.last_music != 1:
		music_2.play()
		Globals.last_music = 1
	elif actual_track == music_arr[2] and Globals.last_music != 2:
		music_3.play()
		Globals.last_music = 2
	elif actual_track == music_arr[3] and Globals.last_music != 3:
		music_4.play()
		Globals.last_music = 3
	elif actual_track == music_arr[4] and Globals.last_music != 4:
		music_5.play()
		Globals.last_music = 4
	else:
		music_1.play()
		Globals.last_music = 0
	if Globals.language == "ru":
		get_tree().call_group("Language", "Language_RU")
	elif Globals.language == "en":
		get_tree().call_group("Language", "Language_EN")


func create_traps():
	var position_traps_x = [marker_l.position.x, marker_r.position.x]
	var position_traps_y = [marker_t.position.y, marker_b.position.y]
	var half_position_y = (marker_t.position.y + marker_b.position.y) / 2.0
	var actual_traps = ""
	for i in 100:
		if position_traps_x[0] <  position_traps_x[1]:
			var n = randi_range(0, 10)
			if n == 0 or n == 1 or n == 2:
				actual_traps = preload("res://Scene/Traps/trap_big.tscn")
			elif n == 3:
				actual_traps = preload("res://Scene/Traps/puddle.tscn")
			elif n == 4 or n == 5:
				actual_traps = preload("res://Scene/Traps/speed_bump.tscn")
			else:
				actual_traps = preload("res://Scene/Traps/trap_small.tscn")
			var trap_create = actual_traps.instantiate()
			position_traps_x[0] += randf_range(2000, 3000) #расстояние между каждой ловушкой от и до
			get_node("Traps").add_child(trap_create)
			if actual_traps == preload("res://Scene/Traps/puddle.tscn") or actual_traps == preload("res://Scene/Traps/speed_bump.tscn"):
				trap_create.position = Vector2(position_traps_x[0], half_position_y)
			else:
				trap_create.position = Vector2(position_traps_x[0], randf_range(position_traps_y[0], position_traps_y[1]))

func _on_area_start_body_entered(body): # СТАРТ
	get_tree().call_group("Player", "start")
	voice_durov.play()
	


func _on_area_finish_body_entered(body): # ФИНИШ
	get_tree().call_group("Player", "finish")
	audio_russia.play()
	music_1.volume_db = -80
	music_2.volume_db = -80
	music_3.volume_db = -80
	music_4.volume_db = -80
	music_5.volume_db = -80

func music_on_off():
	if Globals.music == -20:
		music_1.volume_db = -80
		music_2.volume_db = -80
		music_3.volume_db = -80
		music_4.volume_db = -80
		music_5.volume_db = -80
		Globals.music = -80
	else:
		music_1.volume_db = -20
		music_2.volume_db = -20
		music_3.volume_db = -20
		music_4.volume_db = -20
		music_5.volume_db = -20
		Globals.music = -20

func mobile_move():
	mobile_ui.visible = true
	move_setting.visible = false
func pc_move():
	mobile_ui.visible = false
	move_setting.visible = true

func Language_RU():
	%Sign_Label_Start.text = "СТАРТ"
	%Sign_Label_Finish.text = "ФИНИШ"
	%MobileUi.texture = ui_mobile_ru
func Language_EN():
	%Sign_Label_Start.text = "START"
	%Sign_Label_Finish.text = "FINISH"
	%MobileUi.texture = ui_mobile_en
