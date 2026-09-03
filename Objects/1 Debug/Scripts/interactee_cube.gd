extends StaticBody3D

@export var IntText : String = "This cube looks like it unlocks doors."

func Interact():
	print("Interacted with")
	rotate_z(25.0)
	$"../Door_02".locked = false
	IntText = "HIDEME!"
