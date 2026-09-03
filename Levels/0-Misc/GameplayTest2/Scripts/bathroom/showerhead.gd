extends StaticBody3D

var enabled : bool = true

func Interact():
	if enabled == false:
		enabled = true
		$Water.show()
	else:
		enabled = false
		$Water.hide()
