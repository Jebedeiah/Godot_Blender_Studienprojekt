extends Control

var victory_music = load("res://Audio/victory.mp3")

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$AnimationPlayer.play("FadeIn")
	MusicController.play_music(victory_music)
