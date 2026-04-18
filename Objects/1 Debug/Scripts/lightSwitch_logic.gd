extends StaticBody3D

@export var Enabled : bool = false
@export var base_energy : float = 10.0

func _ready() -> void:
	if Enabled == false:
		$Lights/Light1.light_energy = 0.0
	else:
		$Lights/Light1.light_energy = base_energy

func Interact():
	if Enabled == false:
		Enabled = true
		$Lights/Light1.light_energy = base_energy
		$AnimationPlayer.play("Switch")
	else:
		Enabled = false
		$Lights/Light1.light_energy = 0.0
		$AnimationPlayer.play_backwards("Switch")
