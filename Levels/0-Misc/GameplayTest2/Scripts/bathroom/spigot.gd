extends StaticBody3D

var Enabled : bool = false

func _ready() -> void:
	$spigotbase/water.hide()

func Interact():
	if Enabled == false:
		Enabled = true
		$spigotbase/water.show()
		$Watersound.play()
	else:
		Enabled = false
		$spigotbase/water.hide()
		$Watersound.stop()
