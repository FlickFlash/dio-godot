class_name Enemy
extends Node2D

signal earn_exp

@export_category("Life")
@export var health: int = 5
@export var death_prefab: PackedScene
var damage_digit_prefab: PackedScene

@onready var damage_number_marker = $DamageMarker

@export_category("Drops")
@export var drop_chance: float = 0.1
@export var drop_items: Array[PackedScene]
@export var drop_chances: Array[float]

var enemy_exp: int = 3
var group_exp = {
	"sheep": 1,
	"pawns": 2,
	"goblins": 5
}

func _ready() -> void:
	damage_digit_prefab = preload("res://misc/damage_number.tscn")
	for group in group_exp:
		if self.is_in_group(group):
			enemy_exp = group_exp[group]

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
	damage_number.z_index += 2
	if health > 0:
		if damage_number_marker:
			damage_number.global_position = damage_number_marker.position
			damage_number_marker.get_parent().add_child(damage_number)
		else:
			damage_number.global_position = global_position - Vector2(0, 40)
			get_parent().get_parent().add_child(damage_number)
	if health <= 0:
		if damage_number_marker:
			damage_number.global_position = damage_number_marker.global_position
		else:
			damage_number.global_position = global_position - Vector2(0, 40)
		get_parent().get_parent().add_child(damage_number)
		die()

func die() -> void:
	#print("Exp: ", enemy_exp)
	emit_signal("earn_exp", enemy_exp)
	#earn_exp.emit(enemy_exp)
	#print("Enemy died and signal emitted!")
	
	var random_number = randf()
	if random_number <= drop_chance:
		#if self.is_in_group("sheep"):
			#print("Matou ovelha! Drop chance: ", drop_chance, " Random Number: ", random_number)
		drop_item()
	
	GameManager.monsters_defeated_counter += 1
		
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = self.position
		get_parent().add_child(death_object)
	
	
	queue_free()

func drop_item() -> void:
	var drop = get_random_drop_item().instantiate()
	drop.position = self.position
	get_parent().add_child(drop)

func get_random_drop_item() -> PackedScene:
	if drop_items.size() == 1:
		return drop_items[0]
	var max_chance: float = 0.0
	for dc in drop_chances:
		max_chance += dc
		
	var random_value = randf() * max_chance
	
	var needle: float = 0.0
	for i in drop_items.size():
		var di = drop_items[i]
		var dc = drop_chances[i] if i < drop_chances.size() else drop_chances[0]
		if random_value <= dc + needle:
			return di
		needle += dc
	return drop_items[0]
