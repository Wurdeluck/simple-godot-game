extends Node

@onready var cur_money_label: Label = $MachinesValues/Money
@onready var cur_money_speed_label: Label = $MachinesValues/MoneySpeed
@onready var cur_clients_label: Label = $MachinesValues/Clients
@onready var blocks_in_kafka_label: Label = $BlocksInKafka
@onready var game_time_label: Label = $GameTime
var cur_money: float = 0.0
var cur_money_speed: float = 0.0
var cur_clients: int = 1
var block_price: float = 0.1
var cur_client_price: float = 1.0
var in_game_time: int = 0
@onready var cur_client_price_label: Label = $ClientPrice
@onready var buy_client_button: Button = $BuyClient

@onready var _kafka: Node2D = $Kafka
@onready var _api: Area2D = $API
@onready var block_timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	game_time_label.text = str("GAME TIME: ", in_game_time, " s.")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cur_money_label.text = str("%10.2f" % cur_money)
	cur_money_speed_label.text = str("%10.2f" % cur_money_speed)
	cur_clients_label.text = str(cur_clients)
	cur_client_price_label.text = str("CLIENT PRICE: %10.2f" % cur_client_price)
	blocks_in_kafka_label.text = str("BLOCKS IN KAFKA: %10.2f" % _kafka.blocks.size())


func _on_add_money_pressed():
	cur_money += block_price


func _on_buy_client_pressed():
	print(cur_money, " >= ", cur_client_price)
	if (cur_money >= cur_client_price):
		cur_money -= cur_client_price
		cur_clients += 1
		cur_money_speed = float(1.1 ** cur_clients)/100
		cur_client_price *= 2.5
		var wait_time: float = _api.block_cooldown_timer_base_time/float(cur_clients)
		print("Expected wait time ", wait_time)
		_api.block_cooldown_timer.wait_time = wait_time
		print("Actual wait time: ", _api.block_cooldown_timer.wait_time)

func _on_counter_timeout():
	if (cur_clients > 0):
		for i in range(cur_clients):
			cur_money += cur_money_speed
			cur_money_label.text = str("%10.2f" % cur_money)
	in_game_time += 1
	if (in_game_time < 60):
		game_time_label.text = str("GAME TIME: ", in_game_time, " s.")
	elif (in_game_time < 60 * 60):
		game_time_label.text = str("GAME TIME: ", in_game_time/60, " m. ", in_game_time % 60," s.")
		


func _on_blockchain_body_entered(body):
	var block := body as Block
	if not block:
		return
	cur_money += block_price

