class_name MobSpawner
extends Node2D

@export var creatures: Array[PackedScene]
var mobs_per_minute: float = 60.0 # Não mais exportada, agora é feito no DifficultySystem
var spawn_correction_level: int = 1
var mobs_pm_corrected: float

@onready var path_follow_2d = %PathFollow2D

var cooldown: float = 0.0

func _process(delta: float):
	if GameManager.is_game_over:
		return
	
	cooldown -= delta
	#print("Spawn_cooldown: ", cooldown)
	#print("spawn_correction_level: ", spawn_correction_level, " mobs_per_minute_corrected: ", mobs_pm_corrected)
	if cooldown > 0:
		return
	
	mobs_pm_corrected = mobs_per_minute + 60 * spawn_correction_level
	var interval = 60.0/mobs_pm_corrected
	cooldown = interval
	
	var point = get_point()
	var world_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = point
	parameters.collision_mask = 0b1001 # Collision Mask nos layers 4 e 1 (->)
	var result: Array = world_state.intersect_point(parameters, 1)
	if not result.is_empty():
		if spawn_correction_level < 5:
			spawn_correction_level += 1
		return
	
	var index = randi_range(0, creatures.size() - 1)
	var creature_scene = creatures[index]
	var creature = creature_scene.instantiate()
	creature.global_position = point
	get_parent().add_child(creature)
	if spawn_correction_level > 1:
		spawn_correction_level -= 1
	#print("spawn_correction_level: ", spawn_correction_level)

func get_point() -> Vector2:
	randomize()
	path_follow_2d.progress_ratio = randf()
	return(path_follow_2d.global_position)
