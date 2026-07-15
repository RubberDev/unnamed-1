extends RigidBody3D

var enabled : bool = true

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		if enabled == true:
			if body.Health < 100:
				body.healPlayer(10)
				enabled = false
				queue_free()
