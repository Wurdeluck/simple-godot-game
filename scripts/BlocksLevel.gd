extends Node

@onready var global_vars = get_node("/root/GlobalVariables")

@onready var cur_money_label: Label = $MachinesValues/Money
@onready var cur_money_speed_label: Label = $MachinesValues/MoneySpeed
@onready var cur_clients_label: Label = $MachinesValues/Clients
@onready var cur_client_price_label: Label = $ClientPrice
@onready var buy_client_button: Button = $BuyClient

@onready var test_var: int = global_vars.cur_clients

@export var _kafka: Node2D
@export var block_timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	print(test_var)
	test_var += 1
	print(global_vars.cur_clients)
	cur_money_label.show()
	cur_money_label.text = str("%10.2f" % global_vars.cur_money)
	cur_money_speed_label.show()
	cur_money_speed_label.text = str("%10.2f" % global_vars.cur_money_speed)
	buy_client_button.show()
	cur_clients_label.show()
	cur_clients_label.text = str("%10f" % global_vars.cur_clients)
	cur_client_price_label.text = str("CLIENT PRICE: %10.2f" % global_vars.cur_client_price)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cur_money_label.text = str("%10.2f" % global_vars.cur_money)
	cur_money_speed_label.text = str("%10.2f" % global_vars.cur_money_speed)
	cur_clients_label.text = str(global_vars.cur_clients)
	cur_client_price_label.text = str("CLIENT PRICE: %10.2f" % global_vars.cur_client_price)


func _on_add_money_pressed():
	global_vars.cur_money += global_vars.block_price


func _on_buy_client_pressed():
	if (global_vars.cur_money >= global_vars.cur_client_price):
		global_vars.cur_money -= global_vars.cur_client_price
		global_vars.cur_clients += 1
		global_vars.cur_money_speed = float(1.1 ** global_vars.cur_clients)/100
		global_vars.cur_client_price *= 2.5

func _on_counter_timeout():
	if (global_vars.cur_clients > 0):
		for i in range(global_vars.cur_clients):
			global_vars.cur_money += global_vars.cur_money_speed
			cur_money_label.text = str("%10.2f" % global_vars.cur_money)
	block_timer.wait_time = 1/(global_vars.cur_clients)


func _on_blockchain_body_entered(body):
	if body is CharacterBody2D:
		global_vars.cur_money += global_vars.block_price

