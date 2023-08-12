extends Node2D

@onready var _blocks: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var from = Vector2(0,0)
	var to = Vector2(100,100)
	draw_line(from, to , Color(0, 0, 1), 5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_api_body_exited(body):
	_blocks.append(body as CharacterBody2D)
	print(body, " added to messageBus")
	print(_blocks)


func _on_blockchain_body_entered(body):
		print(body, " removed from messageBus")
		_blocks.erase(body)
