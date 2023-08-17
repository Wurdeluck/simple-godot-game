extends Area2D

var _is_blocks_inside = false

@export var _block: PackedScene
@export var _kafka: Node2D
@onready var block_cooldown_timer: Timer = $BlockCoolDown
@onready var block_cooldown_timer_base_time = block_cooldown_timer.wait_time
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
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
		new_block.base_speed *= owner.cur_clients
		new_block.z_index = 2
		_kafka.add_child(new_block)
		print("New ", new_block ," spawned in ", rand_spawn_point.name)
		
		new_block.global_position = rand_spawn_point.global_position
		_is_blocks_inside = true
	else:
		print("No Block spawn!")


func _on_body_exited(body):
	var new_block := body as Block
	if not new_block:
		return
	print(body, " left from API")
	_is_blocks_inside = false
