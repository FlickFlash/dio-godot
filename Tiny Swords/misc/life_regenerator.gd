extends Node2D

@export var regeneration_amount: int = 10

@onready var area2d: Area2D


func _ready():
	area2d = $Area2D
	area2d.body_entered.connect(on_body_entered)

func on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var player: Player = body
		
		if player.health < player.max_health:
			player.heal(regeneration_amount)
			player.meat_collected.emit(regeneration_amount)
			queue_free()
