extends Node2D

@export var game_ui: CanvasLayer
@export var game_over_ui_template: PackedScene
@export var boss_list: PackedScene


@onready var player: Player = $Player

func _ready() -> void:
	GameManager.game_over.connect(trigger_game_over)
	# position == global_position porque o node Main é o "global"
	#player.global_position = Vector2(576, 324)
	player.global_position = Vector2(1700, 1250)
	#player.position = Vector2(-17000, -11000)
	var boss_enemy = boss_list.instantiate()
	print($Boss1Area/Marker2D.global_position)
	boss_enemy.set_scale(Vector2(2,2)) ## Necessário reduzir scale do damage_number pela metade
	boss_enemy.position = $Boss1Area/Marker2D.global_position
	add_child(boss_enemy)

func trigger_game_over():
	if game_ui:
		game_ui.queue_free()
		game_ui = null # "Zerar" variável
	
	#preload("res://ui/game_over_ui.tscn") 
	
	var game_over_ui: GameOverUI = game_over_ui_template.instantiate()
	#game_over_ui.monsters_defeated = 0
	#game_over_ui.time_survived = "00:00"
	add_child(game_over_ui)
