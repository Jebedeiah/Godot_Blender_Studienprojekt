extends Node3D

@onready var Enemy = preload("res://Scenes/Enemies/flying_guard.tscn")

@onready var timer = $Timer

@export var num_enemies = 4
@export var seconds_between_spawns = 2

var enemies_remaining_to_spawn
var enemies_killed_this_wave

var waves # list of all Wave nodes
var current_wave: Wave #Wave node
var current_wave_number = -1

func _ready():
	waves = $Waves.get_children()
	start_next_wave()


# Start the next wave when all enemies are killed
func start_next_wave():
	enemies_killed_this_wave = 0
	current_wave_number += 1
	if current_wave_number < waves.size():
		current_wave = waves[current_wave_number]
		enemies_remaining_to_spawn = current_wave.num_enemies
		timer.wait_time = current_wave.seconds_between_spawns
		timer.start()
	else:
		get_tree().change_scene_to_file("res://Scenes/Menu/victory.tscn")


# Connect to the custom signal "enemy_killed" in the "flying_guard" scene
func connect_to_enemy_signals(enemy: Enemy):
	enemy.enemy_killed.connect(_on_enemy_killed_signal)


# If an enemy gets killed, increment the kill counter of this wave
func _on_enemy_killed_signal():
	enemies_killed_this_wave += 1


# If there are enemies left to spawn this wave then spawn the next enemy
func _on_timer_timeout():
	if enemies_remaining_to_spawn:
		var spawns = get_tree().get_nodes_in_group("spawn") # Get all spawns as a list
		var spawn = spawns[randi() % spawns.size()] # Select a random spawn from the list
		var root = get_parent()
		var enemy = Enemy.instantiate()
		connect_to_enemy_signals(enemy)
		root.add_child(enemy)
		enemy.position = spawn.position
		enemies_remaining_to_spawn -= 1
		
	# If all enemies are killed, start the next wave
	elif enemies_killed_this_wave == current_wave.num_enemies:
		start_next_wave()
