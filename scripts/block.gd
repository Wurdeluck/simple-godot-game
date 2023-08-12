extends CharacterBody2D

@export var speed = 30.0
@export var base_speed = 10.0
@export var acceleration = 50
@export var friction = 0.3

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var mouse_inside = false


func _physics_process(delta):
	if Input.is_action_just_pressed("left_click") and mouse_inside:
		velocity.x = move_toward(velocity.x, 1 * speed + base_speed, acceleration)
		print(self, velocity.x)
	else:
		velocity.x = move_toward(velocity.x, base_speed, friction)
#		print(velocity.x)
	move_and_slide()

func _on_mouse_entered():
	print("Inside")
	mouse_inside = true


func _on_mouse_exited():
	print("Outside")
	mouse_inside = false