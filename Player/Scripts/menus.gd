extends Node

func _process(_delta: float) -> void:
	$Interface/VBoxContainer/HealthBar.value = $"..".Health
