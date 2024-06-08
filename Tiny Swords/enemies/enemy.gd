class_name Enemy
extends Node2D

@export var health: int = 5
@export var death_prefab: PackedScene

func damage(amount: int) -> void:
	health -= amount
	print(health)
	
	modulate = Color(0.8,0,0.1)
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "modulate", Color.WHITE, 0.5)
	
	if health <= 0:
		die()

func die() -> void:
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = self.position
		get_parent().add_child(death_object)
	
	queue_free()
