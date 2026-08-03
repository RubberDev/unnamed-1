extends StaticBody3D


func Interact():
	$"../Begin/Door_01".locked = false
	queue_free()
