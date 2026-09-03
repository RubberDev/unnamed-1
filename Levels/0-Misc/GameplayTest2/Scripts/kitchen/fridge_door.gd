extends StaticBody3D

var open : bool = false

func Interact():
	if open == false:
		open = true
		$AnimationPlayer.play("door")
	else:
		open = false
		$AnimationPlayer.play_backwards("door")
