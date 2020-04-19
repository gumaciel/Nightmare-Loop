extends Area2D

onready var TweenNode : Node = $Tween

func _ready() -> void:
	look_at(get_global_mouse_position())
	TweenNode.interpolate_property(self, NodePath("position"), position, get_global_mouse_position(), 0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	TweenNode.start()

	return

func _process(delta) -> void:
	pass


func _on_Tween_tween_completed(object, key):
	queue_free()
	pass # Replace with function body.



func _on_Bullet_area_entered(area):
	if area.is_in_group("enemies"):
		var enemy = (area as Enemy)
		enemy.life -= enemy.damage_taken
		self.queue_free()

	pass # Replace with function body.
