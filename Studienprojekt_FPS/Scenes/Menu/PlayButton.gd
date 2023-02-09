extends Button

var aniPlayer
var fade_out_timer

func _ready():
	aniPlayer = get_parent().get_node("AnimationPlayer")
	fade_out_timer = get_parent().get_node("FadeOutTimer")

# Start the game when the "Start Game" Button is pressed
func _on_pressed():
	aniPlayer.play("FadeOut")
	fade_out_timer.start()


func _on_fade_out_timer_timeout():
	get_tree().change_scene_to_file("res://Scenes/World/world.tscn")
