#extends Node
extends CharacterBody2D

@export var speed: float = 1
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var player_position = GameManager.player_position
	var difference = player_position - position
	var input_vector = difference.normalized()
	
	velocity = input_vector * speed * 100
	move_and_slide()
	
	if input_vector.x > 0 :
		sprite.flip_h = false
	elif input_vector.x < 0:
		sprite.flip_h = true
