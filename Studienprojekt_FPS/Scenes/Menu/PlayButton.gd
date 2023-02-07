extends Button

# Start the game when the "Start Game" Button is pressed
func _on_pressed():
	get_tree().change_scene_to_file("res://Scenes/World/world.tscn")
