extends Control

@onready var animator = $AnimationPlayer
@onready var resume_button = $ColorRect/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/ResumeButton
@onready var quit_button = $ColorRect/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/QuitButton

# Unpause the tree and continue the game
func unpause():
	animator.play("Unpause")
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# Pause the tree and show the pause screen
func pause():
	animator.play("Pause")
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


# Continue the game when the resume button is presses
func _on_resume_button_pressed():
	unpause()


# Quit the game when the quit button is pressed
func _on_quit_button_pressed():
	get_tree().quit()
