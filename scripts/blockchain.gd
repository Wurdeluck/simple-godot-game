extends Area2D
class_name Blockchain

@export var _kafka: Node2D
@onready var blocks_in_blockchain: int = 0


func _on_body_entered(body):
	var new_block := body as Block
	if not new_block:
		return
	print(new_block, " successfully entered blockchain, deleting")
	for block in _kafka.blocks:
		if block == new_block:
			print("Removing", block, " because it equals to", new_block)
			blocks_in_blockchain += 1
			block.queue_free()
