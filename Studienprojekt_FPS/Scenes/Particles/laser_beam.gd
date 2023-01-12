extends Node3D

@onready var scaler = $Scaler


func enhance(distance):	
	scaler.scale.z = distance

func dissolve():
	queue_free()
