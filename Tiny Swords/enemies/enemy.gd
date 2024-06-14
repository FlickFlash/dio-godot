class_name Enemy
extends Node2D

@export var health: int = 5
@export var death_prefab: PackedScene

@onready var damage_number_marker = $DamageMarker

var damage_digit_prefab: PackedScene

func _ready() -> void:
	damage_digit_prefab = preload("res://misc/damage_number.tscn")

func damage(amount: int) -> void:
	health -= amount
	print(health)
	
	modulate = Color(0.8,0,0.1)
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "modulate", Color.WHITE, 0.5)
	
	var damage_number = damage_digit_prefab.instantiate()
	damage_number.value = amount
	if health > 0:
		if damage_number_marker:
			damage_number.global_position = damage_number_marker.position
			damage_number_marker.get_parent().add_child(damage_number)
		else:
			damage_number.global_position = global_position - Vector2(0, 40)
			get_parent().get_parent().add_child(damage_number)
		damage_number.z_index += 2
	if health <= 0:
		if damage_number_marker:
			damage_number.global_position = damage_number_marker.global_position
		else:
			damage_number.global_position = global_position - Vector2(0, 40)
		damage_number.z_index += 2
		get_parent().get_parent().add_child(damage_number)
		die()

func die() -> void:
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = self.position
		get_parent().add_child(death_object)
	
	queue_free()
