extends Control

var score_ind := false
var game_over_ind := false
var second := 0.0


@onready var result = %Result
@onready var record_number = %Record_number
@onready var result_number = %Result_number
@onready var animation_dirt = %Animation_dirt
@onready var music_button = %MusicButton

@onready var record_str = %Record_str
@onready var result_str = %Result_str
@onready var reset = %Reset
@onready var exit = %Exit
@onready var text_result = %Text_result

@onready var control_move_mobile = %Control_move_mobile

var second_label = "сек"

var ind_sound = 1
var sprite_sound_on = preload("res://Sprites/UI/sound_icon_on.png")
var sprite_sound_off = preload("res://Sprites/UI/sound_icon_off.png")

func _ready():
	animation_dirt.play("dirt_false")
	if Globals.music == -20:
		music_button.texture_normal = sprite_sound_on
	elif Globals.music == -80:
		music_button.texture_normal = sprite_sound_off

	if Globals.language == "ru":
		get_tree().call_group("Language", "Language_RU")
		second_label = "сек"
	elif Globals.language == "en":
		get_tree().call_group("Language", "Language_EN")
		second_label = "sec"
	

func _process(delta):
	score(delta)
	record_number.text = str(Globals.record)

func visible_UI():
	$Control.visible = true
	if game_over_ind == true:
		result_number.text = " - " + second_label
	else:
		result_number.text = str(float(round(second) / 100)) + " " + second_label
		if Globals.record > float(round(second) / 100) or Globals.record == 0.0:
			Globals.record = float(round(second) / 100)
			Globals.save_game()
		$igbgui.yandex_result = int(Globals.record * 100)
		$igbgui.on_yandex_leaderboard()
		$igbgui.on_read_yandex_leaderboard()


func start():
	score_ind = true
func finish():
	score_ind = false

func score(delta):
	if score_ind == true:
		second += 1.0 * delta * 100
		result.text = str(float(round(second) / 100)) + " " + second_label

func Game_over():
	game_over_ind = true
	result.text = " - " + second_label


func visible_dirt():
	animation_dirt.stop()
	animation_dirt.play("dirt_true")


func _on_reset_pressed():
	get_tree().change_scene_to_file("res://Scene/level_1.tscn")


func _on_exit_pressed():
	$igbgui.on_show_interstitial()
	get_tree().change_scene_to_file("res://Scene/Main_menu/main_menu.tscn")


func _on_music_button_pressed():
	get_tree().call_group("Level_1", "music_on_off")
	if Globals.music == -20:
		music_button.texture_normal = sprite_sound_on
	elif Globals.music == -80:
		music_button.texture_normal = sprite_sound_off


func _on_texture_button_pressed():
	get_tree().change_scene_to_file("res://Scene/Main_menu/main_menu.tscn")

func Control_mobile_visible_on():
	control_move_mobile.visible = true
func Control_mobile_visible_off():
	control_move_mobile.visible = false

func Language_RU():
	record_str.text = "Рекорд: "
	result_str.text = "Результат: "
	reset.text = "ПЕРЕЗАПУСТИТЬ"
	exit.text = "МЕНЮ"
	text_result.text = "Результат:"
func Language_EN():
	record_str.text = "Record: "
	result_str.text = "Score: "
	reset.text = "RESET"
	exit.text = "MENU"
	text_result.text = "Score:"
