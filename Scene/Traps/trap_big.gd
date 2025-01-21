extends Area2D



func _on_body_entered(body):
	get_tree().call_group("Player", "Game_over")

func _on_area_sign_body_entered(body):
	$AnimationPlayer.play("Sign")

func _on_area_light_body_entered(body):
	$EmergencySign.modulate = "d5d5d5"
func _on_area_light_body_exited(body):
	$EmergencySign.modulate = "616161"
