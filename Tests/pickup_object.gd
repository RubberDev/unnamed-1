extends RigidBody3D

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Left Click"):
		if freeze == true:
			rotation.x += 10
		else:
			pass
