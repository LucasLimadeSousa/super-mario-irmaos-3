extends CharacterBody2D

class_name Player

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum PlayerMode{
	SMALL, 
	BIG, 
	SHOOTING
}

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var area_collision_shape_2d: CollisionShape2D = $Area2D/AreaCollisionShape2D
@onready var body_collision_shape_2d: CollisionShape2D = $BodyCollisionShape2D

@export_group("Locomotion")
@export var run_speed_danping:float = 0.5
@export var speed:float = 100.0
@export var jump_velocity:int = -350
@export_group("")

@export_group("Stomping Enemies")
@export var min_stomp_degree = 35
@export var max_stomp_degree = 145
@export var stomp_y_velocity = -150
@export_group("")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	if Input.is_action_just_pressed("jump") and velocity.y < 0: 
		velocity.y *= 0.5
	var diretion = Input.get_axis("left","right")
	
	if diretion:
		velocity.x = lerp(velocity.x, speed * diretion, run_speed_danping * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, speed * delta)
	
	#aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
	move_and_slide()
	
	
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Enemy:
		handle_enemy_collision(area)
func handle_enemy_collision(enemy : Enemy):
	if enemy == null:
		return
	if is_instance_of(enemy, Koopa) and (enemy as Koopa).in_a_shell:
		(enemy as Koopa).on_stomp(global_position)
	else:
		var angle_of_collision = rad_to_deg(position.angle_to_point(enemy.position))
		if angle_of_collision > min_stomp_degree && max_stomp_degree > angle_of_collision:
			enemy.die()
			on_enemy_stomped()
func on_enemy_stomped():
	velocity.y = stomp_y_velocity
