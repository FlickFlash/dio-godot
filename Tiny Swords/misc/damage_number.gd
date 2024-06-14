extends Node2D

var value: float = 0

func _ready() -> void:
	%Label.text = str(value)
