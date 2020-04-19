extends Area2D

class_name Enemy

signal life_changed

export(int) var life := 5 setget set_life
export(int) var damage_taken := 1
export(int) var speed := 50
onready var LifeProgressBar := $UI/LifeProgressBar

var path := PoolVector2Array() 

func _ready() -> void:
	LifeProgressBar.max_value = life
	LifeProgressBar.value = life
	return

func _process(delta : float) -> void:
	if get_parent().has_node("Navigation2D") and get_parent().has_node("Player"):
		path = get_parent().get_node("Navigation2D").get_simple_path(global_position, get_parent().get_node("Player").global_position)

	var move_distance := speed * delta
	move_along_path(move_distance)
	return

func move_along_path(distance : float) -> void:
	var start_point := position
	for i in range(path.size()):
		var distance_to_next := start_point.distance_to(path[0])
		if distance <= distance_to_next and distance > 0.0 and distance_to_next > 0.0:
			position = start_point.linear_interpolate(path[0], distance / distance_to_next)
			break
		elif distance < 0.0:
			position  = path[0]
			set_process(false)
			break
		distance -= distance_to_next
		start_point = path[0]
		path.remove(0)
	return

func _on_Enemy_body_entered(body : Node):
	if body.is_in_group("player"):
		body.queue_free()

	pass # Replace with function body.


func set_life(value : int) -> void:
	life = value
	emit_signal("life_changed", value)

func _on_Enemy_life_changed(value : int):
	if life > 0:
		LifeProgressBar.value -= damage_taken
		(LifeProgressBar.get("custom_styles/fg") as StyleBoxTexture).modulate_color -= Color(0, 1.0/life, 1.0/life, 0)
	else:
		queue_free()
	pass # Replace with function body.

