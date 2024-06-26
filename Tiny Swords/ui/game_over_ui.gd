class_name GameOverUI
extends CanvasLayer

@onready var time_label: Label = %TimeLabelValue
@onready var monsters_label: Label = %MonsterLabelValue

@export var restart_delay: float = 5.0

var restart_cooldown:float
var time_survived: String
var monsters_defeated: int

func _ready() -> void:
	time_label.text = time_survived
	monsters_label.text = str(monsters_defeated)
	restart_cooldown = restart_delay

func _process(delta) -> void:
	restart_cooldown -= delta
	
	if restart_cooldown <= 0:
		restart_game()

func restart_game() -> void:
	GameManager.reset()
	get_tree().reload_current_scene()
