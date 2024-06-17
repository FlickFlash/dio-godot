extends Node2D

@onready var player: Player = $Player

func _ready() -> void:
	player.global_position = Vector2(576, 324)
