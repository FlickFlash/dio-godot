extends Node2D

@export var creatures: Array[PackedScene]
@export var mobs_per_minute: float = 60.0

@onready var path_follow_2d = %PathFollow2D

var cooldown: float = 0.0

func _process(delta: float):
	cooldown -= delta
	if cooldown > 0:
		return
	
	var interval = 60.0/mobs_per_minute
	cooldown = interval
	
	var point = get_point()
	var world_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = point
	parameters.collision_mask = 0b1000
	var result: Array = world_state.intersect_point(parameters, 1)
	if not result.is_empty():
		if  mobs_per_minute < 240:
			mobs_per_minute += 60
			print("Mobs per minute: ", mobs_per_minute)
		return
	
	var index = randi_range(0, creatures.size() - 1)
	var creature_scene = creatures[index]
	var creature = creature_scene.instantiate()
	creature.global_position = point
	get_parent().add_child(creature)
	if mobs_per_minute >= 240:
		mobs_per_minute -= 60
	print("Mobs per minute: ", mobs_per_minute)

func get_point() -> Vector2:
	randomize()
	path_follow_2d.progress_ratio = randf()
	return(path_follow_2d.global_position)
