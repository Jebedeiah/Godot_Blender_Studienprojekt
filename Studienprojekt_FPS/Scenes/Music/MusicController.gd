extends Node

var menu_music = preload("res://Audio/menu.mp3")




# Called when the node enters the scene tree for the first time.
func _ready():
	play_music(menu_music)


func play_music(music):
	$Music.stream = music
	$Music.play()
