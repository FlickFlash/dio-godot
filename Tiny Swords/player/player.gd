class_name Player
extends CharacterBody2D

@export_category("Speed")
@export var speed: float = 4
@export_category("Damage")
@export var damage_type: String = "physical_type"
@export_category("Sword")
@export var sword_damage: int = 2
@export_category("Ritual")
@export var ritual_damage: int = 1
@export var ritual_interval: float = 15.0
@export var ritual_scene: PackedScene

@export_category("Life")
@export var health: float = 100
@export var max_health: float = 100
@export var death_prefab: PackedScene

@export_category("Exp")
@export var player_exp: int = 0

@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var sprite:Sprite2D = $Sprite2D
@onready var sword_area: Area2D = $SwordArea
@onready var hitbox_area: Area2D= $HitboxArea
@onready var health_progress_bar: ProgressBar = %HealthProgressBar
@onready var exp_progress_bar: ProgressBar = %ExpProgressBar

var input_vector: Vector2 = Vector2(0,0)
var is_running: bool = false
var was_running: bool = false
var is_attacking: bool = false
var attack_cooldown: float = 0.0
var hitbox_cooldown: float = 0.0
var ritual_cooldown: float = 15.0

var player_levels: Dictionary = {0: 0, 1: 10, 2: 20, 3: 30}
var player_level: int = 1

signal meat_collected(value: int)

func _ready() -> void:
	GameManager.player = self
	meat_collected.connect(func(_value: int): GameManager.meat_counter += 1)



func _process(delta: float) -> void:
	GameManager.player_position = position
	
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		if not enemy.is_connected("earn_exp", on_enemy_earn_exp):
			enemy.connect("earn_exp", on_enemy_earn_exp)
		#print("Player connected to enemy signal")
		
	read_input()
	
	update_attack_cooldown(delta)
	if Input.is_action_just_pressed("attack"):
		attack()
		
	play_run_idle_animation()
	
	if not is_attacking:
		rotate_sprite()
	
	update_hitbox_detection(delta)
	
	update_ritual(delta)
	
	update_health_progress_bar()
	
	update_exp_progress_bar()

func _physics_process(_delta: float) -> void:
	var target_velocity = input_vector * speed * 100
	if is_attacking:
		target_velocity *= 0.5
	velocity = lerp(velocity, target_velocity, 0.5)
	move_and_slide()

func update_attack_cooldown(delta: float) -> void:
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0.0:
			is_attacking = false
			is_running = false
			animation_player.play("idle")

func update_ritual(delta: float) -> void:
	ritual_cooldown -= delta
	if ritual_cooldown > 0:
		return
	ritual_cooldown = ritual_interval
	
	var ritual = ritual_scene.instantiate()
	ritual.damage_amount = ritual_damage
	# Posição do ritual é sempre 0,0 para seguir o jogador
	add_child(ritual)

func update_health_progress_bar() -> void:
	health_progress_bar.max_value = max_health
	health_progress_bar.value = health
	var health_proportion: float = (health / max_health)
	
	if health_proportion >= 0.8:
		health_progress_bar.get_theme_stylebox('fill', 'ProgressBar').bg_color = Color.GREEN
	elif health_proportion >= 0.3:
		health_progress_bar.get_theme_stylebox('fill', 'ProgressBar').bg_color = Color.YELLOW
	else:
		health_progress_bar.get_theme_stylebox('fill', 'ProgressBar').bg_color = Color.RED

func on_enemy_earn_exp(enemy_exp):
	player_exp += enemy_exp
	#print("Enemy defeated! Earned EXP: ", enemy_exp)
	
func update_exp_progress_bar() -> void:
	if player_level <= player_levels.keys()[-1]: # Nível máximo atual
		exp_progress_bar.max_value = player_levels[player_level]
		exp_progress_bar.min_value = player_levels[player_level - 1]
		#print("Exp max: ", player_levels[player_level])
		exp_progress_bar.value = player_exp
		#print("Player current exp: ", player_exp)
		if exp_progress_bar.value == exp_progress_bar.max_value:
			player_level += 1
			## TODO Criar alguma animação de level up

func read_input() -> void:
	input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	#var deadzone = 0.15
	if abs(input_vector.x) < 0.15:
		input_vector.x = 0
	if abs(input_vector.y) < 0.15:
		input_vector.y = 0
	
	was_running = is_running
	is_running = not input_vector.is_zero_approx()

func play_run_idle_animation() -> void:
	if not is_attacking:
		if was_running != is_running:
			if is_running:
				animation_player.play("run")
			else:
				animation_player.play("idle")

func rotate_sprite() -> void:
	if input_vector.x > 0 :
		sprite.flip_h = false
	elif input_vector.x < 0:
		sprite.flip_h = true

func attack() -> void:
	if is_attacking:
		return
	animation_player.play("attack_side_1")
	attack_cooldown = 0.6
	is_attacking = true
	#deal_damage_to_enemies() # A função é chamada a partir da animação de ataque

func deal_damage_to_enemies() -> void:
	var bodies = sword_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			
			var direction_to_enemy = (enemy.position - position).normalized()
			var attack_direction: Vector2
			if sprite.flip_h:
				attack_direction = Vector2.LEFT
			else:
				attack_direction = Vector2.RIGHT
			var dot_product = direction_to_enemy.dot(attack_direction)
			if dot_product >= -0.1:
				#print("Dot: ", dot_product)
				enemy.damage(sword_damage, damage_type)

func update_hitbox_detection(delta: float) -> void:
	hitbox_cooldown -= delta
	if hitbox_cooldown > 0:
		return
	
	hitbox_cooldown = 0.5
	
	var bodies = hitbox_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			#var enemy: Enemy = body
			var damage_amount = 1
			damage(damage_amount)
			#print(self.health)

func damage(amount: int) -> void:
	if health <= 0:
		return
	
	health -= amount
	
	modulate = Color(1, 0.45, 0.36)
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	
	if health <= 0:
		die()

func die() -> void:
	#GameManager.is_game_over = true
	GameManager.end_game()
	
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = self.position
		get_parent().add_child(death_object)
	
	queue_free()

func heal(amount: float) -> float:
	health += amount
	if health > max_health:
		health = max_health
	return health
