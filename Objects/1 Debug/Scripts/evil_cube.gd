extends StaticBody3D

@export var dmgAmount : int = 0

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		body.damagePlayer(dmgAmount)
