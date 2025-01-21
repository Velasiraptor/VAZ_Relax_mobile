extends CharacterBody2D


@export var max_speed_x := 2400.0
@export var max_speed_y := 800.0
@export var acceleration := 5.0
@export var friction := 5.0

@onready var engine_loop_sound = %Engine_loop_sound
@onready var fire_sound = %Fire_sound
@onready var stalled_sound = %Stalled_sound
@onready var start_engine_sound = %Start_engine_sound
@onready var stop = %stop
@onready var car_in_trap = %car_in_trap



var game_over_ind := false
var stalled_ind := false
var start_ind := false
var finish_ind := false
var score_ind := false
var stop_ind := false
var arrow_count := 1
var arrow_rotation = [0, 90, 180, -90]

@onready var wheel_l = %Wheel_L
@onready var wheel_r = %Wheel_R
@onready var arrow_1 = %Arrow_1
@onready var arrow_2 = %Arrow_2
@onready var arrow_3 = %Arrow_3
@onready var stall_text = %Stall_text
@onready var fire_1 = %Fire_1
@onready var fire_2 = %Fire_2
@onready var smoke_death = %Smoke_death
@onready var smoke = %Smoke
@onready var camera_2d = %Camera2D
@onready var stopper = %stopper
@onready var animation_player_death = %AnimationPlayer_death
@onready var animation_wheels_on_speed_bumb = %Animation_wheels_on_speed_bumb


@onready var animation_start_or_stop_move = %Animation_start_or_stop_move


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	fire_1.visible = false
	fire_2.visible = false
	smoke_death.visible = false
	smoke.emitting = true
	await get_tree().create_timer(0.5).timeout
	camera_2d.position_smoothing_enabled = true
	camera_2d.position_smoothing_speed = 4
	engine_loop_sound.play()
	if Globals.language == "ru":
		get_tree().call_group("Language", "Language_RU")
	elif Globals.language == "en":
		get_tree().call_group("Language", "Language_EN")


func _process(delta):
	move()
	animation(delta)
	animation_rotation_move()
	pressed_when_stalled()
	stop_sound()

func move():
	if game_over_ind == false and finish_ind == false:
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction_x = Input.get_axis("ui_left", "ui_right")
		if Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_left") and stalled_ind == false:
			stopper.visible = false
			velocity.x = move_toward(velocity.x, direction_x * max_speed_x, acceleration)
		elif Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right") and stalled_ind == false:
			stopper.visible = false
			velocity.x = move_toward(velocity.x, direction_x * max_speed_x, acceleration)
		else:
			friction = 5.0
			stopper.visible = false
			velocity.x = move_toward(velocity.x, 0, friction)
		
		var direction_y = Input.get_axis("ui_up", "ui_down")
		if direction_y and velocity.x > 100 or direction_y and velocity.x < -100:
			if velocity.x <= max_speed_x * 0.25:
				velocity.y = direction_y * max_speed_y * 0.25
			elif velocity.x <= max_speed_x * 0.5:
				velocity.y = direction_y * max_speed_y * 0.5
			elif velocity.x <= max_speed_x * 0.75:
				velocity.y = direction_y * max_speed_y * 0.75
			elif velocity.x <= max_speed_x:
				velocity.y = direction_y * max_speed_y
		else:
			velocity.y = move_toward(velocity.y, 0, max_speed_y)
		
		if Input.is_action_pressed("ui_accept") and (game_over_ind == false or finish_ind == false):
			stop_ind = false
			friction = 30.0
			stopper.visible = true
			velocity.x = move_toward(velocity.x, 0, friction)

	else: # При попадании в ловушку
		if game_over_ind == true: 
			friction = 30.0
			stopper.visible = false
			velocity.x = move_toward(velocity.x, 0, friction)
			velocity.y = move_toward(velocity.y, 0, max_speed_y)
			engine_loop_sound.stop()
		else:
			friction = 5.0
			stopper.visible = false
			velocity.x = move_toward(velocity.x, 0, friction)
			velocity.y = move_toward(velocity.y, 0, max_speed_y)
	move_and_slide()

func stop_sound():
	if Input.is_action_just_pressed("ui_accept") and velocity.x != 0:
		stop.play()


func animation(delta):
	if velocity.x > 0:
		var n = velocity.x / 100
		if velocity.x <= 100 * n:
			wheel_l.rotation += delta * n
			wheel_r.rotation += delta * n
	elif velocity.x < 0:
		var n = velocity.x / -100
		if velocity.x <= 100 * n:
			wheel_l.rotation += delta * -n
			wheel_r.rotation += delta * -n
	else:
		wheel_l.rotation += delta * 0
		wheel_r.rotation += delta * 0
#	if velocity.y > 0:
#		wheel_r.skew = 0.2 # заменить на спрайт поворота
#	elif velocity.y < 0:
#		wheel_r.skew = -0.2
#	else:
#		wheel_r.skew = 0

func animation_rotation_move(): #анимация в зависимости от угла
	if Input.is_action_just_pressed("ui_right") and stalled_ind == false:
		animation_start_or_stop_move.play("start_move")
	elif Input.is_action_just_released("ui_right") and stalled_ind == false:
		if animation_start_or_stop_move.is_playing():
			animation_start_or_stop_move.play("start_move", 0, -1.0)
		else:
			animation_start_or_stop_move.play_backwards("start_move")
	


func stalled():
	if stalled_ind == true:
		if animation_start_or_stop_move.is_playing():
			animation_start_or_stop_move.play("start_move", 0, -1.0)
		else:
			animation_start_or_stop_move.play_backwards("start_move")
		stalled_sound.play()
		engine_loop_sound.stop()
		arrow_count = 1
		smoke.emitting = false
		arrow_1.rotation_degrees = arrow_rotation.pick_random()
		arrow_1.visible = true
		arrow_2.rotation_degrees = arrow_rotation.pick_random()
		arrow_2.visible = true
		arrow_3.rotation_degrees = arrow_rotation.pick_random()
		arrow_3.visible = true
		stall_text.visible = true
	elif stalled_ind == false:
		start_engine_sound.play()
		engine_loop_sound.play()
		smoke.emitting = true
		stall_text.visible = false

func pressed_when_stalled():
	if stalled_ind == true:
		if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down"):
			arrow_pressed()

func arrow_pressed():
	if game_over_ind == false:
		if arrow_1.visible == true and arrow_count == 1: # первая иконка стрелки
			if arrow_1.rotation_degrees == -90 and Input.is_action_just_pressed("ui_left"):
				arrow_1.visible = false
				arrow_count = 2
			elif  arrow_1.rotation_degrees == 0 and Input.is_action_just_pressed("ui_up"):
				arrow_1.visible = false
				arrow_count = 2
			elif  arrow_1.rotation_degrees == 90 and Input.is_action_just_pressed("ui_right"):
				arrow_1.visible = false
				arrow_count = 2
			elif  arrow_1.rotation_degrees == 180 and Input.is_action_just_pressed("ui_down"):
				arrow_1.visible = false
				arrow_count = 2
			else:
				stalled()
		elif arrow_2.visible == true and arrow_count == 2: # вторая иконка стрелки
			if arrow_2.rotation_degrees == -90 and Input.is_action_just_pressed("ui_left"):
					arrow_2.visible = false
					arrow_count = 3
			elif  arrow_2.rotation_degrees == 0 and Input.is_action_just_pressed("ui_up"):
					arrow_2.visible = false
					arrow_count = 3
			elif  arrow_2.rotation_degrees == 90 and Input.is_action_just_pressed("ui_right"):
					arrow_2.visible = false
					arrow_count = 3
			elif  arrow_2.rotation_degrees == 180 and Input.is_action_just_pressed("ui_down"):
					arrow_2.visible = false
					arrow_count = 3
			else:
				stalled()
		elif arrow_3.visible == true and arrow_count == 3: # третья иконка стрелки
			if arrow_3.rotation_degrees == -90 and Input.is_action_just_pressed("ui_left"):
					stalled_ind = false
					arrow_3.visible = false
					arrow_count = 1
					stalled()
			elif  arrow_3.rotation_degrees == 0 and Input.is_action_just_pressed("ui_up"):
					stalled_ind = false
					arrow_3.visible = false
					arrow_count = 1
					stalled()
			elif  arrow_3.rotation_degrees == 90 and Input.is_action_just_pressed("ui_right"):
					stalled_ind = false
					arrow_3.visible = false
					arrow_count = 1
					stalled()
			elif  arrow_3.rotation_degrees == 180 and Input.is_action_just_pressed("ui_down"):
					stalled_ind = false
					arrow_3.visible = false
					arrow_count = 1
					stalled()
			else:
				stalled()



#анимация наезда на лежачего полицейского
func _on_area_wheel_l_area_entered(area): #левое колесо
	animation_wheels_on_speed_bumb.play("wheel_L")
func _on_area_wheel_r_area_entered(area): #правое колесо
	animation_wheels_on_speed_bumb.play("wheel_r")

func stalled_true():
	if velocity.x >= 1600:
		stalled_ind = true
		stalled()


func start():
	start_ind = true
	get_tree().call_group("UI", "start")

func score():
	if score_ind == true:
		get_tree().call_group("UI", "score")

func finish():
	finish_ind = true
	get_tree().call_group("UI", "finish")
	get_tree().call_group("UI", "visible_UI")

func Game_over():
	game_over_ind = true
	engine_loop_sound.stop()
	car_in_trap.play()
	fire_sound.play()
	get_tree().call_group("UI", "Game_over")
	get_tree().call_group("UI", "finish")
	animation_player_death.play("death")
	$Animation_Fire.play("fire_start")
	await get_tree().create_timer(2.0).timeout
	get_tree().call_group("UI", "visible_UI")


func Language_RU():
	stall_text.text = "ЁЛКИ-ПАЛКИ, ЗАГЛОХЛА!"
func Language_EN():
	stall_text.text = "DAMN, IT'S STALLED!"
