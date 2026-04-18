extends Area3D

@export var dmgAmount : int = 0

func _ready() -> void:
	$Timer.start()


### FUCKING KILL THE BITCH ###
func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		_on_timer_timeout()


### DAMAGE PLAYER AFTER EACH SECOND ###
func _on_timer_timeout() -> void:
	for body in get_overlapping_bodies():
		if body is Player:
			body.damagePlayer(dmgAmount)
