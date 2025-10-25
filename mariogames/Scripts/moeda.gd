extends Area2D



func _on_body_entered(body: Node2D) -> void:
	$anim.play("RESET")


func _on_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "RESET":
		queue_free()
