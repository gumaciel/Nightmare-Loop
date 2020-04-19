extends Node2D


func _ready() -> void:
	return

func _input(event):
	if Input.is_key_pressed(KEY_P):
		get_tree().reload_current_scene()
