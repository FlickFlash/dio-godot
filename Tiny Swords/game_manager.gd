extends Node

signal game_over

var player: Player
var player_position: Vector2
var is_game_over: bool = false

var time_process: float = 0.0
var time_process_string: String
var meat_counter: int = 0
var gold_counter: int = 0
var monsters_defeated_counter: int = 0


func _process(delta:float) -> void:
	#count_process += 1
	time_process += delta
	#print("Time_process: ", time_process)
	#print("Count_process: ", count_process)
	var time_elapsed_in_seconds: int = floori(time_process)
	#if time_elapsed_in_seconds % 60 < 10:
		#timer_label.text = str(floori(time_elapsed_in_seconds/60), ":0", time_elapsed_in_seconds % 60)
	#else:
		#timer_label.text = str(floori(time_elapsed_in_seconds/60), ":", time_elapsed_in_seconds % 60)
	var seconds: int = time_elapsed_in_seconds % 60
	@warning_ignore("integer_division")
	var minutes: int = time_elapsed_in_seconds / 60
	time_process_string = "%02d:%02d" % [minutes, seconds]

func end_game():
	if is_game_over:
		return
	
	is_game_over = true
	game_over.emit()

func reset():
	player = null
	player_position = Vector2.ZERO
	is_game_over = false
	time_process = 0
	time_process_string = "00:00"
	meat_counter = 0
	gold_counter = 0
	monsters_defeated_counter = 0
	
	for connection in game_over.get_connections():
		game_over.disconnect(connection.callable)
