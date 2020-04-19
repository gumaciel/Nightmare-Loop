extends Node2D


func _ready() -> void:
	return

func _input(event):
	if Input.is_key_pressed(KEY_P) and (event.is_pressed() and not event.is_echo()):
		get_tree().reload_current_scene()


func _on_SpawnTimer_timeout():
	var new_enemy = preload("res://data/enemy/scenes/Enemy.tscn").instance()
	add_child(new_enemy)
	pass # Replace with function body.


func _on_Button_pressed():
	get_tree().reload_current_scene()


func _on_Player_player_is_dead():
	$SpawnTimer.paused = true
	$CanvasLayer/UI/AnimationPlayer.play("game_over")
	pass # Replace with function body.
