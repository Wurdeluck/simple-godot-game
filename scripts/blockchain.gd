extends Area2D

@export var _kafka: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	var new_block := body as Block
	if not new_block:
		return
	print(new_block, " successfully entered blockchain, deleting")
	for block in _kafka.blocks:
		if block == new_block:
			print("Removing", block, " because it equals to", new_block)
			block.queue_free()
