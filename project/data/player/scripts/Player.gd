extends KinematicBody2D
class_name Player


export(int) var score := 0 setget set_score
var high_score : int = 0 setget set_high_score
export(int) var speed := 100

signal player_is_dead

var velocity := Vector2()

const CHARACTERS := [
	Rect2(Vector2(00, 85), Vector2(16, 16)),
	Rect2(Vector2(17, 85), Vector2(16, 16)),
	Rect2(Vector2(00, 102), Vector2(16, 16)),
	Rect2(Vector2(17, 102), Vector2(16, 16)),
	Rect2(Vector2(00, 119), Vector2(16, 16)),
	Rect2(Vector2(17, 119), Vector2(16, 16)),
	Rect2(Vector2(00, 136), Vector2(16, 16)),
	Rect2(Vector2(17, 136), Vector2(16, 16)),
	Rect2(Vector2(00, 170), Vector2(16, 16)),
	Rect2(Vector2(17, 170), Vector2(16, 16)),
	Rect2(Vector2(00, 187), Vector2(16, 16)),
	Rect2(Vector2(17, 187), Vector2(16, 16))
]

func _get_camera_position() -> Vector2:
	return $Camera2D.get_camera_position()

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$SpriteCharacter.region_rect = CHARACTERS[randi()%(CHARACTERS.size())]
	$CanvasLayer/UI/VBoxContainer/Score.text = "Score: " + str(score)
	$CanvasLayer/UI/VBoxContainer/HighScore.text = "HighScore: " + str(high_score)
	randomize()
	position = ($SpawnPositions.get_child(randi() % $SpawnPositions.get_child_count()) as Position2D).position

	var load_data = Game.load_game(name)
	if !load_data.empty():
		set_high_score(load_data.get("high_score"))
	
func get_input() -> void:
	look_at(get_global_mouse_position())
	velocity = Vector2()
	if Input.is_action_pressed("move_back"):
		velocity = Vector2(-speed, 0).rotated(rotation)
	if Input.is_action_pressed("move_front"):
		velocity = Vector2(speed, 0).rotated(rotation)
	if Input.is_action_just_pressed("attack"):
		var BulletNode = preload("res://data/bullet/scenes/Bullet.tscn").instance()
		BulletNode.position = position
		get_parent().add_child(BulletNode)

func limit_camera() -> void:
	position.x = clamp(position.x, $Camera2D.limit_left, $Camera2D.limit_right)
	position.y = clamp(position.y, $Camera2D.limit_top, $Camera2D.limit_bottom)


func _input(event):
	$Crosshair.position = get_local_mouse_position()

func _physics_process(delta) -> void:
	
	get_input()
	move_and_slide(velocity)
	rotation_degrees -= 90
	limit_camera()


func save() -> Dictionary:
	var save_dictionary = {
		"name" : name,
		"high_score": high_score
	}
	return save_dictionary

func set_score(value: int) -> void:
	score = value
	if score > high_score:
		set_high_score(score)
	$CanvasLayer/UI/VBoxContainer/Score.text = "Score: " + str(score)
	return
	
func set_high_score(value : int) -> void:
	high_score = value
	$CanvasLayer/UI/VBoxContainer/HighScore.text = "HighScore: " + str(high_score)
	Game.save_game()
	return
	
func die():
	emit_signal("player_is_dead")
	queue_free()
