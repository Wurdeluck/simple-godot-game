extends Node

const FLOAT_EPSILON = 0.009

@onready var cur_money_label: Label = $MachinesValues/Money
@onready var cur_money_speed_label: Label = $MachinesValues/MoneySpeed
@onready var cur_clients_label: Label = $MachinesValues/Clients
@onready var cur_blocks_label: Label = $MachinesKeys/BlocksKey
@onready var blocks_in_kafka_label: Label = $BlocksInKafka
@onready var game_time_label: Label = $GameTime
@onready var rich_money_label: RichTextLabel = $RichMoneyLabel
var rich_money: float = 0.0
var cur_money: float = 0.0
var cur_money_speed: float = 0.0
var cur_clients: int = 1
var block_price: float = 0.1
var cur_client_price: float = 1.0
var in_game_time: int = 0
@onready var cur_client_price_label: Label = $ClientPrice
@onready var buy_client_button: Button = $BuyClient

@export var _kafka: Kafka
@export var _api: API
@export var _blockchain: Blockchain
@onready var block_timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	game_time_label.text = str("GAME TIME: ", in_game_time, " s.")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	cur_blocks_label.text = str("BLOCKS: %15d" % _blockchain.blocks_in_blockchain)
	cur_money_label.text = str("%10.2f" % cur_money)
	cur_money_speed_label.text = str("%10.2f" % cur_money_speed)
	cur_clients_label.text = str(cur_clients)
	cur_client_price_label.text = str("CLIENT PRICE: %10.2f" % cur_client_price)
	blocks_in_kafka_label.text = str("BLOCKS IN KAFKA: %10.2f" % _kafka.blocks.size())


func _physics_process(delta):
	rich_money += 1.001 * delta
	rich_money_label.text = str(rich_money)

func _on_add_money_pressed():
	cur_money += block_price


func _on_buy_client_pressed():
	if (cur_money >= cur_client_price or self.compare_floats(cur_money, cur_client_price)):
		cur_money -= cur_client_price
		cur_clients += 1
		cur_money_speed = float(1.1 ** cur_clients)*cur_clients/80
		cur_client_price *= 2.5
		var wait_time: float = _api.block_cooldown_timer_base_time/float(cur_clients)
		print("Expected wait time ", wait_time)
		_api.block_cooldown_timer.wait_time = wait_time
		print("Actual wait time: ", _api.block_cooldown_timer.wait_time)

func _on_counter_timeout():
	if (cur_clients > 0):
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


static func compare_floats(a, b, epsilon = FLOAT_EPSILON):
	return abs(a - b) <= epsilon
