extends Node2D

var value: float = 0

func _ready() -> void:
	%Label.text = str(value)
	#%Label.label_settings.font_color = Color(0.306, 0.353, 0.773)
	#%Label.set('label_settings', %Label.get('label_settings').duplicate(true))

func _process(_delta: float) -> void:
	
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		if not enemy.is_connected("attack_popup", on_popup):
			enemy.connect("attack_popup", on_popup)

func on_popup(damage_type):
	match damage_type:
		"physical_type":
			#damage_number.get_child(0).get_child(0).label_settings.font_color = Color(1, 0.353, 0.361)
			%Label.label_settings.font_color = Color(1, 0.353, 0.361)
			print(damage_type)
		"ritual_type":
			#damage_number.get_child(0).get_child(0).label_settings.font_color = Color(0.306, 0.353, 0.773)
			%Label.label_settings.font_color = Color(0.306, 0.353, 0.773)
			print(damage_type)
