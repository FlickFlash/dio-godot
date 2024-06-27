extends Node2D

@export var game_ui: CanvasLayer
@export var game_over_ui_template: PackedScene

@onready var player: Player = $Player

func _ready() -> void:
	GameManager.game_over.connect(trigger_game_over)
	# position == global_position porque o node Main é o "global"
	#player.global_position = Vector2(576, 324)
	player.position = Vector2(-17000, -11000)
	

func trigger_game_over():
	if game_ui:
		game_ui.queue_free()
		game_ui = null # "Zerar" variável
	
	#preload("res://ui/game_over_ui.tscn") 
	
	var game_over_ui: GameOverUI = game_over_ui_template.instantiate()
	#game_over_ui.monsters_defeated = 0
	#game_over_ui.time_survived = "00:00"
	add_child(game_over_ui)
