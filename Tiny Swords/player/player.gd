extends CharacterBody2D

@export var speed:float = 3

@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var sprite_player:Sprite2D = $Sprite2D

var input_vector: Vector2 = Vector2(0,0)
var is_running: bool = false
var was_running: bool = false
var is_attacking: bool = false
var attack_cooldown: float = 0.0

func _process(delta: float) -> void:
	GameManager.player_position = position
	
	read_input()
	
	update_attack_cooldown(delta)
	if Input.is_action_just_pressed("attack"):
		attack()
		
	play_run_idle_animation()
	rotate_sprite()
	

func _physics_process(_delta: float) -> void:
	var target_velocity = input_vector * speed * 100
	if is_attacking:
		target_velocity *= 0.25
	velocity = lerp(velocity, target_velocity, 0.5)
	move_and_slide()

func update_attack_cooldown(delta: float) -> void:
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0.0:
			is_attacking = false
			is_running = false
			animation_player.play("idle")

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
		sprite_player.flip_h = false
	elif input_vector.x < 0:
		sprite_player.flip_h = true

func attack() -> void:
	if is_attacking:
		return
	animation_player.play("attack_side_1")
	attack_cooldown = 0.6
	is_attacking = true
