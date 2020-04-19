extends KinematicBody2D
class_name Player

export (int) var speed := 100

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

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$SpriteCharacter.region_rect = CHARACTERS[randi()%(CHARACTERS.size())]

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
