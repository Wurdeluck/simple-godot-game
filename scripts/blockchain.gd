extends Area2D

@export var _kafka: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body is CharacterBody2D:
		print(body, " successfully entered blockchain, deleting")
		for ch_i in _kafka.get_children():
			if ch_i == body:
				ch_i.queue_free()
