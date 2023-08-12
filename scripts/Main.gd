extends Node2D

@onready var cur_money_label: Label = $MachinesValues/Money
@onready var cur_money_speed_label: Label = $MachinesValues/MoneySpeed
var cur_money: float = 0.0
var cur_money_speed: float = 0.0
@onready var buy_clicker_button: Button = $BuyClicker
@onready var cur_clickers_label: Label = $MachinesValues/Clickers
var cur_clickers: int = 0
@onready var robot = $Robot
@onready var counter = $Counter

# Called when the node enters the scene tree for the first time.
func _ready():
	cur_money_label.show()
	cur_money_speed_label.show()
	buy_clicker_button.hide()
	cur_clickers_label.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cur_money_label.text = str("%10.2f" % cur_money)
	cur_money_speed_label.text = str("%10.2f" % cur_money_speed)
	if (buy_clicker_button.visible):
		cur_clickers_label.show()
		cur_clickers_label.text = str("%10.0f" % cur_clickers)
	if (cur_money >= 100):
		buy_clicker_button.show()


func _on_add_money_pressed():
	cur_money += 1


func _on_robot_mouse_entered():
	cur_money += 10


func _on_buy_clicker_pressed():
	if (cur_money >= 100):
		cur_money -= 100
		cur_clickers += 1
		cur_money_speed = float(1.1 ** cur_clickers)


func _on_counter_timeout():
	if (cur_clickers > 0):
		for i in range(cur_clickers):
			cur_money += cur_money_speed
