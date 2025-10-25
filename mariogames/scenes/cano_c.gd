extends Area2D

@onready var cano_d: Area2D = $"../canoD"


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		await get_tree().create_timer(1.0).timeout
		body.can_teleport = false
		body.can_teleport
		body.global_position = cano_d.global_position
		body.can_teleport = true
