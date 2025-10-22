extends CharacterBody2D

class_name Player

enum PlayerMode{
	SMALL, 
	BIG, 
	SHOOTING
}

signal  points_scored(points: int)

const POINTS_LABEL_SCENE = preload("res://scenes/points_label.tscn")

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var area_collision_shape_2d: CollisionShape2D = $Area2D/AreaCollisionShape2D
@onready var body_collision_shape_2d: CollisionShape2D = $BodyCollisionShape2D
@onready var area_2d = $Area2D

@export_group("Locomotion")
@export var run_speed_danping:float = 0.5
@export var run_atrition:float = 1.5
@export var speed:float = 100.0
@export var jump_velocity:int = -350
@export_group("")

@export_group("Stomping Enemies")
@export var min_stomp_degree : int = 35
@export var max_stomp_degree : int = 145
@export var stomp_y_velocity : int = -150
@export_group("")

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player_mode = PlayerMode.SMALL
var is_dead = false
var is_floor = true


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		is_floor = false
		animated_sprite_2d.play("pulo_Direita_Pequeno")
		velocity.y += gravity * delta
	else:
		is_floor = true
	if Input.is_action_pressed("jump") and is_floor:
		velocity.y = jump_velocity
		animated_sprite_2d.play("pulo_Direita_Pequeno")
	if Input.is_action_just_pressed("jump") and velocity.y < 0: 
		velocity.y *= 0.5
	var diretion = Input.get_axis("left","right")
	if diretion:
		animated_sprite_2d.flip_h = velocity.x < 0
		if is_floor && not animated_sprite_2d.animation == "direita_Pequeno":
			animated_sprite_2d.play("direita_Pequeno")
		velocity.x = lerp(velocity.x, speed * diretion, run_speed_danping * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, pow(speed,run_atrition) *delta)
		if is_floor:
			animated_sprite_2d.play("parado")
	move_and_slide()
	
	
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Enemy:
		handle_enemy_collision(area)
func handle_enemy_collision(enemy : Enemy):
	if enemy == null || is_dead:
		return
	if is_instance_of(enemy, Koopa) and (enemy as Koopa).in_a_shell:
		(enemy as Koopa).on_stomp(global_position)
	else:
		var angle_of_collision = rad_to_deg(position.angle_to_point(enemy.position))
		
		if angle_of_collision > min_stomp_degree && max_stomp_degree > angle_of_collision:
			enemy.die()
			on_enemy_stomped()
			spawn_points_label(enemy)
		else:
			die()

func on_enemy_stomped():
	velocity.y = stomp_y_velocity

func spawn_points_label(enemy):
	var points_label = POINTS_LABEL_SCENE.instantiate()
	points_label.position = enemy.position + Vector2(-20, -20)
	get_tree().root.add_child(points_label)
	points_scored.emit(100)
	
func die():
	if player_mode == PlayerMode.SMALL:
		is_dead = true
		animated_sprite_2d.play("small_death")
		set_physics_process(false)

	var death_tween = get_tree().create_tween()
	death_tween.tween_property(self, "position", position + Vector2(0, -48), .5)
	death_tween.chain().tween_property(self, "position", position + Vector2(0, 256), 1)
	death_tween.tween_callback(func(): get_tree().reload_current_scene())
