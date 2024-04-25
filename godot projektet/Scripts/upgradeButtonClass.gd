extends VBoxContainer
class_name UpgradeButton

@export var basePrice: float
@export var repeatable: bool = false
@export var scaling: float
@export var priceScaling: float
@export var startDescription: String
@export var additive: bool = false
@export var price: float
@export  var bought: int = 0
var hasReadied: bool = false

@onready var button: Button = %Button
@onready var buy10Button: Button = %Buy10Button
@onready var buyMaxButton: Button = %BuyMaxButton
@onready var buy10Price: Label = %Buy10Price
@onready var buyMaxPrice: Label = %BuyMaxPrice
@onready var buy1Price: Label = %Buy1Price
@onready var buy10Container: VBoxContainer  = %Buy10
@onready var buyMaxContainer: VBoxContainer = %BuyMax
@onready var generatorMenu: Control = owner

func _enter_tree():
	if !hasReadied:
		return
	call_deferred("updateVisibility")

func _ready():
	if price == 0:
		price = basePrice
	if !button.pressed.is_connected(onPress):
		button.pressed.connect(onPress)
		buyMaxButton.pressed.connect(buyMax)
		buy10Button.pressed.connect(buy10)
		generatorMenu.energyChanged.connect(updateVisibility)
	
	updateText()
	if !repeatable:
		buy10Container.queue_free()
		buyMaxContainer.queue_free()
	updateVisibility()
	hasReadied = true

func onPress() -> void:
	SfxManager.play_sound(load("res://Assets/AudioFiles/UIBeepLighter.mp3"))
	buy()

func whenBought() -> void:
	pass

func updateText() -> void:
	var data: Array = [str(scaling), str(Globals.convertNum(calculateEffect()))]
	var description = startDescription % data
	$Label.text = description
	buy1Price.text = Globals.convertNum(round(price)) + " Energy"
	if repeatable:
		buy10Price.text = Globals.convertNum(round(calculate10Price())) + " Energy"
		buyMaxPrice.text = Globals.convertNum(round(calculateBuyMaxPrice())) + " Energy"
	elif bought > Globals.stats.extraUpgrades:
		buy1Price.text = "Max bought"

func updateVisibility() -> void:
	if (bought < 1+Globals.stats.extraUpgrades or repeatable) and price <= generatorMenu.energy:
		button.disabled = false
		if repeatable:
			buyMaxButton.disabled = false
	else:
		button.disabled = true
		if repeatable:
			buyMaxButton.disabled = true
	if repeatable and calculate10Price() <= generatorMenu.energy:
		buy10Button.disabled = false
	elif repeatable:
		buy10Button.disabled = true
	if (visible or price/2 <= generatorMenu.energy):
		show()
	else: 
		hide()
	updateText()

func buy() -> void:
	generatorMenu.changeEnergy(-price)
	bought += 1
	price *= priceScaling
	whenBought()
	updateText()
	updateVisibility()

func buyMax() -> void:
	SfxManager.play_sound(load("res://Assets/AudioFiles/UIBeepLighter.mp3"))
	while price <= generatorMenu.energy:
		buy()

func buy10() -> void:
	SfxManager.play_sound(load("res://Assets/AudioFiles/UIBeepLighter.mp3"))
	for i in 10:
		buy()
	
func calculate10Price() -> float:
	var calculatedPrice: float = 0
	for i in 10:
		calculatedPrice += price*pow(priceScaling, i)
	return(calculatedPrice)

func calculateBuyMaxPrice() -> float:
	var calculatedPrice: float = price
	var priceOfNext: float = price*priceScaling
	var iteration: int = 0
	while calculatedPrice+priceOfNext < generatorMenu.energy:
		iteration += 1
		calculatedPrice += priceOfNext
		priceOfNext = price*pow(priceScaling, iteration)
		
	return(calculatedPrice)


func calculateEffect() -> float:
	var effect: float = 0
	if additive:
		effect = (scaling*bought)
	else:
		effect = pow(scaling, bought)
	return effect
