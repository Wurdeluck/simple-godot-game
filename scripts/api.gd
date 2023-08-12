extends Area2D

var _is_blocks_inside = false

@export var _block: PackedScene
@export var _kafka: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_block_cool_down_timeout():
	var spawns = []
	if not _is_blocks_inside:
		for ch_i in self.get_children():
			if ch_i.name == "SpawnPoints":
				for ch_ch_i in ch_i.get_children():
					if ch_ch_i is Node2D:
						spawns.append(ch_ch_i)
					else:
						print("Block spawn is not Node2D!")
		var rand_spawn_point: Node2D = spawns[randi() % spawns.size()]
		var new_block = _block.instantiate() as CharacterBody2D
		_kafka.add_child(new_block)
		print("New ", new_block ," spawned in ", rand_spawn_point.name)
		
		new_block.global_position = rand_spawn_point.global_position
		_is_blocks_inside = true


func _on_body_exited(body):
	if body is CharacterBody2D:
		print(body, " left from API")
		_is_blocks_inside = false
