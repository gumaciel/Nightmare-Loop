extends Area2D

class_name Enemy

signal life_changed

export(int) var life := 5 setget set_life
export(int) var damage_taken := 1
export(int) var speed := 50
onready var LifeProgressBar := $UI/LifeProgressBar

var path := PoolVector2Array() 


const CHARACTERS := [
	Rect2(Vector2(00, 00), Vector2(16, 16)),
	Rect2(Vector2(17, 00), Vector2(16, 16)),
	Rect2(Vector2(00, 17), Vector2(16, 16)),
	Rect2(Vector2(00, 34), Vector2(16, 16)),
	Rect2(Vector2(17, 34), Vector2(16, 16)),
	Rect2(Vector2(00, 51), Vector2(16, 16)),
	Rect2(Vector2(17, 51), Vector2(16, 16))
]

func _ready() -> void:
	$SpriteCharacter.region_rect = CHARACTERS[randi()%(CHARACTERS.size())]

	LifeProgressBar.max_value = life
	LifeProgressBar.value = life
	randomize()
	position = ($SpawnPositions.get_child(randi() % $SpawnPositions.get_child_count()) as Position2D).position

	return

func _process(delta : float) -> void:
	if get_parent().has_node("Navigation2D") and get_parent().has_node("Player"):
		path = get_parent().get_node("Navigation2D").get_simple_path(global_position, get_parent().get_node("Player").global_position)
		var move_distance := speed * delta
		move_along_path(move_distance)
	return

func move_along_path(distance : float) -> void:
	var start_point := position
	if path.size() > 1:
		for i in range(path.size()):
			var distance_to_next := start_point.distance_to(path[0])
			if distance <= distance_to_next and distance > 0.0 and distance_to_next > 0.0:
				position = start_point.linear_interpolate(path[0], distance / distance_to_next)
				break
			distance -= distance_to_next
			start_point = path[0]
			path.remove(0)
	return

func _on_Enemy_body_entered(body : Node):
	if body.is_in_group("player"):
		body.die()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	pass # Replace with function body.


func set_life(value : int) -> void:
	life = value
	emit_signal("life_changed", value)

func _on_Enemy_life_changed(value : int):
	if life > 0:
		LifeProgressBar.value -= damage_taken
		(LifeProgressBar.get("custom_styles/fg") as StyleBoxTexture).modulate_color -= Color(0, 1.0/life, 1.0/life, 0)
	else:
		if get_parent().has_node("Player"):
			var PlayerNode = get_parent().get_node("Player")
			PlayerNode.score += 1
		queue_free()
	pass # Replace with function body.

