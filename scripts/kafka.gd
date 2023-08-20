extends Node2D
class_name Kafka

@onready var blocks: Array[Block] = []

var from = Vector2(-800,0)
var to = Vector2(800, 0)

func _draw():
	draw_line(from, to , Color(0.3, 0, 0.7), 5)


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


func _on_block_stuck_timer_timeout():
	var block: Block = blocks.pick_random()
	if block:
		print("Try stuck from Kafka! ", block, block.position)
		block.try_stuck()
