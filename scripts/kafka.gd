extends Node2D

@onready var _blocks: Array = []

var from = Vector2(-537,220)
var to = Vector2(549,220)

func _draw():
	draw_line(from, to , Color(0.3, 0, 0.7), 5)


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
		_blocks.pop_front()
