extends KinematicBody2D

export (int) var speed = 100

var velocity = Vector2()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func get_input():
	look_at(get_global_mouse_position())
	velocity = Vector2()
	if Input.is_action_pressed("move_back"):
		velocity = Vector2(-speed, 0).rotated(rotation)
	if Input.is_action_pressed("move_front"):
		velocity = Vector2(speed, 0).rotated(rotation)

func limit_camera():
	position.x = clamp(position.x, $Camera2D.limit_left, $Camera2D.limit_right)
	position.y = clamp(position.y, $Camera2D.limit_top, $Camera2D.limit_bottom)


func _physics_process(delta):
	get_input()
	move_and_slide(velocity)
	rotation_degrees -= 90
	$Crosshair.position = get_local_mouse_position()
	limit_camera()
