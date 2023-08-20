extends CharacterBody2D
class_name Block

signal clicked_and_hold
signal clicked_and_released
signal collided(speed: float)
signal stuck
signal unstuck

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var progress_bar: TextureProgressBar = $CollisionPolygon2D/TextureProgressBar
@onready var stuck_timer: Timer = $StuckTimer
@onready var stuck_label: Label = $StuckLabel
@onready var stuck_tween: Tween

##Block speed
@export var speed: float = 30.0
@export var base_speed: float = 10.0
@export var acceleration: int = 50
@export var friction: float = 0.3
@export var probability_stuck: float = 0.8
@export var stuck_timer_cooldown: float = 3.0
var was_stuck: bool = false
var is_stuck: bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var mouse_inside = false


func _ready():
	progress_bar.value = 0
	stuck_label.hide()


func _physics_process(delta):
	if not is_stuck:
		if Input.is_action_just_pressed("left_click") and mouse_inside:
			animation_player.play("squeeze")
			velocity.x = move_toward(velocity.x, 1 * speed + base_speed, acceleration)
		else:
			velocity.x = move_toward(velocity.x, base_speed, friction)
		
	
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		if collision_info.get_collider() is Block:
			print(collision_info.get_collider().velocity)
			collision_info.get_collider().emit_signal("collided", speed)
		velocity = velocity.bounce(collision_info.get_normal())


func try_stuck():
	print("Trying to get stuck!")
	if not is_stuck and not was_stuck:
		var probability = randf()
		print("Probability: ", probability, " > ", probability_stuck)
		if probability > probability_stuck:
			is_stuck = true
			stuck.emit()
			was_stuck = true
			velocity.x = 0


func test(delta: float):
	print(delta)

func _on_mouse_entered():
	print("Inside")
	mouse_inside = true


func _on_mouse_exited():
	print("Outside")
	mouse_inside = false
	clicked_and_released.emit()


func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and mouse_inside and event.is_pressed():
		clicked_and_hold.emit()
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and mouse_inside and event.is_released():
		clicked_and_released.emit()	


func _on_clicked_and_hold():
	if is_stuck:
		animation_player.play("sway")
		stuck_timer.start(stuck_timer_cooldown)
		await stuck_timer.timeout
		is_stuck = false
		unstuck.emit()


func _on_clicked_and_released():
	animation_player.stop()
	stuck_timer.stop()


func _on_collided(_speed):
	if not is_stuck:
		velocity.x = move_toward(velocity.x, 1 * _speed + base_speed, acceleration)


func _on_stuck():
	stuck_label.show()
	stuck_tween = get_tree().create_tween()
	stuck_tween.set_loops()
	stuck_tween.tween_property(stuck_label, "scale", Vector2(1.1, 1.1), 1)
	stuck_tween.tween_property(stuck_label, "scale", Vector2(1, 1), 1)


func _on_unstuck():
	stuck_label.hide()
	animation_player.stop()
	stuck_tween.stop()
