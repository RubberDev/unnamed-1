extends StaticBody3D


@export var locked : bool = false
var Open : bool = false

### OPEN AND CLOSE DOOR ###
# Hey look at that, the door in this version is slightly less fucked
func Interact():
	if locked == false:
		if Open == false:
			$AnimationPlayer.play("Open")
			$Col1.set_deferred("disabled", true)
			$Col2.set_deferred("disabled", false)
			Open = true
			$Sounds/OpenDoor.play()
		else:
			$AnimationPlayer.play_backwards("Open")
			$Col1.set_deferred("disabled", false)
			$Col2.set_deferred("disabled", true)
			Open = false
			$Sounds/CloseDoor.play()
	else:
		$AnimationPlayer.play("Locked")
		$Sounds/LockedDoor.play()
