extends Node3D

@onready var player = $Player
@onready var spawner = $Spawner


# Give the enemies the current position of the player to calculate a path
func _physics_process(_delta):
	get_tree().call_group("Enemies", "update_target_location", player.global_transform.origin)


func _process(_delta):
	$HUD/Health.text = str(player.health)
	$HUD/EnemyAmount.text = str(spawner.current_wave.num_enemies - spawner.enemies_killed_this_wave)
