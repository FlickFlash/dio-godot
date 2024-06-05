extends Node
#extends CharacterBody2D

@export var speed: float = 1
#@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var sprite: AnimatedSprite2D

var enemy: Enemy

func _ready() -> void:
	enemy = get_parent()
	sprite = enemy.get_node("AnimatedSprite2D")
	enemy.health = 11
	

func _physics_process(_delta: float) -> void:
	var player_position = GameManager.player_position
	var difference = player_position - enemy.position
	var input_vector = difference.normalized()
	
	enemy.velocity = input_vector * speed * 100
	enemy.move_and_slide()
	
	if input_vector.x > 0 :
		sprite.flip_h = false
	elif input_vector.x < 0:
		sprite.flip_h = true
