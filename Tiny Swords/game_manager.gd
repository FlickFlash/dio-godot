extends Node

signal game_over

var player: Player
var player_position: Vector2
var is_game_over: bool = false

func end_game():
	if is_game_over:
		return
	
	is_game_over = true
	game_over.emit()

func reset():
	player = null
	player_position = Vector2.ZERO
	is_game_over = false
	for connection in game_over.get_connections():
		game_over.disconnect(connection.callable)
