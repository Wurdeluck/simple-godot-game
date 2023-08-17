extends Node2D

@onready var blocks: Array[Block] = []

var from = Vector2(-537,220)
var to = Vector2(549,220)

func _draw():
	draw_line(from, to , Color(0.3, 0, 0.7), 5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_api_body_exited(body):
	var new_block := body as Block
	if not new_block:
		return
	if new_block not in blocks:
		blocks.append(new_block)
		print(new_block, " added to messageBus")
		print(blocks)


func _on_blockchain_body_entered(body):
	var new_block := body as Block
	if not new_block:
		return
	blocks.erase(new_block)
	print(new_block, " removed from messageBus")
	print("Removed ", new_block," now it's ", blocks)
