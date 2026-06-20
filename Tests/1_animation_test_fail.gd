extends Node3D

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Left Click"):
		$PlayerArms/AnimationPlayer.play("arms|Pistol Fire")
		$TestPistol/AnimationPlayer.play("root|metarigAction fire")
