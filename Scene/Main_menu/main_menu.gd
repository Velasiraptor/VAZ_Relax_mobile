extends Control

@onready var label_play = %Label_play

@onready var label_auth = %Label_auth
@onready var label_auth_bottom = %Label_auth_bottom
@onready var label_language = %Label_Language
@onready var language_icon = %Language_icon
@onready var main_menu = %MainMenu

var icon_ru = preload("res://Sprites/UI/Main_menu/RU.png")
var icon_en = preload("res://Sprites/UI/Main_menu/EN.png")

var main_menu_RU = preload("res://Sprites/UI/Main_menu/Main_menu_RU.png")
var main_menu_EN = preload("res://Sprites/UI/Main_menu/Main_menu_EN.png")

func _ready():
	$igbgui.set_game_ready()
	if Globals.language == "ru":
		get_tree().call_group("Language", "Language_RU")
		language_icon.texture_normal = icon_ru
		main_menu.texture = main_menu_RU
	elif Globals.language == "en":
		get_tree().call_group("Language", "Language_EN")
		language_icon.texture_normal = icon_en
		main_menu.texture = main_menu_EN

func _on_button_auth_pressed():
	$igbgui.on_player_authorize()

func _on_button_exit_pressed():
	get_tree().quit()


func _on_button_play_pressed():
	$igbgui.on_show_interstitial()
	get_tree().change_scene_to_packed(Globals.menu_pc_or_mobile)

func Language_RU():
	label_play.text = "Играть"
	label_language.text = "Язык"
	label_auth.text = "Авторизируйся,"
	label_auth_bottom.text = "чтобы записывать 
рекорд в лидерборд!"
	main_menu.texture = main_menu_RU
func Language_EN():
	label_play.text = "Play"
	label_language.text = "Language"
	label_auth.text = "Log in"
	label_auth_bottom.text = "to save record
in the leaderboard!"
	main_menu.texture = main_menu_EN


func _on_language_icon_pressed():
	if language_icon.texture_normal == icon_ru:
		language_icon.texture_normal = icon_en
		Globals.language = "en"
		get_tree().call_group("Language", "Language_EN")
	elif language_icon.texture_normal == icon_en:
		language_icon.texture_normal = icon_ru
		Globals.language = "ru"
		get_tree().call_group("Language", "Language_RU")
