extends StaticBody3D

@export var dmgAmount : int = 0
@export var Debugging : bool = false

func _ready() -> void:
	if Debugging == true:
		$Area3D/CollisionShape3D/MeshInstance3D.show()
	else:
		$Area3D/CollisionShape3D/MeshInstance3D.hide()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		body.damagePlayer(dmgAmount)
