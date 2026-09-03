extends RigidBody3D

var active : bool = false

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Left Click"):
		if freeze == true:
			$MeshInstance3D/ExtinguisherSmoke01.emitting = true
			$Timer.start()
			
			if $MeshInstance3D/RayCast3D.is_colliding():
				var collider = $MeshInstance3D/RayCast3D.get_collider()
				print(str(collider))
				if collider.is_in_group("Extinguishable"):
					collider.queue_free()


func _on_timer_timeout() -> void:
	$MeshInstance3D/ExtinguisherSmoke01.emitting = false
