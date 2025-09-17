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
		
	move_and_slide()
	
	
	
		
		
