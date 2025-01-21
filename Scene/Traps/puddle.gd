extends Area2D

@onready var puddle_sprite = %Puddle_sprite


func _ready():
	puddle_sprite.flip_h = randi_range(0, 1)


func _on_body_entered(body):
	get_tree().call_group("UI", "visible_dirt")
