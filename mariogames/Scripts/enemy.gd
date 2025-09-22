extends Area2D

class_name Enemy

@export var horizontal_speed: int = 20
@export var vertical_speed:int = 100
@onready var ray_cast_2d: RayCast2D = $RayCast2D

func _process(delta: float) -> void:
	position.x -= horizontal_speed * delta
	
	if !ray_cast_2d.is_colliding():
		position.y += vertical_speed * delta
