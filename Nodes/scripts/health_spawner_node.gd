extends Node3D

var bandage = preload("res://Objects/Medical/bandages.tscn")
var morphine = preload("res://Objects/Medical/morphine.tscn")
var pills = preload("res://Objects/Medical/painkillers.tscn")


func _ready() -> void:
	$Sprite3D.hide()
	spawnObj()

# It turns out that arrays are a thing
var choose = randi_range(0, 2)
func spawnObj():
	var prefabs = [bandage, morphine, pills]
	add_child(prefabs[choose].instantiate())
