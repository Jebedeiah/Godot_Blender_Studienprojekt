extends Button

# Restart the game when the "Play Again" button is pressed
func _on_pressed():
	get_tree().change_scene_to_file("res://Scenes/World/world.tscn")
