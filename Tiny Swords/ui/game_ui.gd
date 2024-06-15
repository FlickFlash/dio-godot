extends CanvasLayer

@onready var timer_label = %TimerLabel
@onready var gold_label = %GoldLabel
@onready var meat_label = %MeatLabel

var time_process: float = 0.0
#var count_process: int = 0
var time_physics_process: float = 0.0
#var count_physics_process: int = 0
var meat_counter: int = 0

func _ready() -> void:
	GameManager.player.meat_collected.connect(on_meat_collected)

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
	timer_label.text = "%02d:%02d" % [minutes, seconds]
	

func _physics_process(_delta:float) -> void:
	#count_physics_process += 1
	#time_physics_process += _delta
	#print("Time_physics_process: ", time_physics_process)
	#print("Count_physics_process: ", count_process)
	pass

func on_meat_collected(_regeneration_value:int) -> void:
	meat_counter += 1
	meat_label.text = str(meat_counter)
	
