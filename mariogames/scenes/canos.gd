extends Area2D

@onready var cano_b: Area2D = $"../canoB"


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		await get_tree().create_timer(3.0).timeout
		body.can_teleport = false
		body.can_teleport
		body.global_position = cano_b.global_position
		body.can_teleport = true
