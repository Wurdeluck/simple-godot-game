extends Area2D
class_name API

var _is_blocks_inside = false

@export var _block: PackedScene
@export var _kafka: Kafka
@onready var block_cooldown_timer: Timer = $BlockCoolDown
@onready var block_cooldown_timer_base_time = block_cooldown_timer.wait_time


func _physics_process(_delta):
	if self.get_overlapping_bodies():
		_is_blocks_inside = true
	else:
		_is_blocks_inside = false

func _on_block_cool_down_timeout():
	var spawns = []
	if not _is_blocks_inside:
		print("Block can spawn!")
		for ch_i in self.get_children():
			if ch_i.name == "SpawnPoints":
				for ch_ch_i in ch_i.get_children():
					if ch_ch_i is Node2D:
						spawns.append(ch_ch_i)
					else:
						print("Block spawn is not Node2D!")
		var rand_spawn_point: Node2D = spawns[randi() % spawns.size()]
		var new_block := _block.instantiate() as Block
		_kafka.add_child(new_block)
		new_block.owner = _kafka
		new_block.base_speed *= owner.cur_clients
		new_block.z_index = 2
		new_block.global_position = rand_spawn_point.global_position
		print("New ", new_block ," with pos:", new_block.global_position," spawned in ", rand_spawn_point.name, " with pos:", new_block.global_position)
		_is_blocks_inside = true
	else:
		print("No Block spawn!")


func _on_body_exited(body):
	var new_block := body as Block
	if not new_block:
		return
	print(body, " left from API")
	_is_blocks_inside = false
