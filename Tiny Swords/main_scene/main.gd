extends Node2D

@onready var player: Player = $Player

func _ready() -> void:
	# position == global_position porque o node Main é o "global"
	#player.global_position = Vector2(576, 324)
	player.position = Vector2(-17000, -11000)
