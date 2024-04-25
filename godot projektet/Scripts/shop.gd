extends Control
@onready var moneyLabel = %MoneyLabel
@onready var itemContainer = %ItemContainer
@onready var itemNameLabel = %ItemNameLabel
@onready var itemTypeLabel = %ItemTypeLabel
@onready var itemDescriptionLabel = %ItemDescriptionLabel
@onready var buyButton = %BuyButton
@onready var itemPriceLabel = %ItemPriceLabel
@onready var buyItemSound: AudioStream = load("res://Assets/AudioFiles/buy.wav")

var itemAmmount: int = 3
var selectedItem: Item
var selectedInstance: Control

# Called when the node enters the scene tree for the first time.
func _ready():
	rerollShop()
	buyButton.pressed.connect(buyItem)
	SfxManager.play_music(load("res://Assets/AudioFiles/shop_music.mp3"))

func rerollShop() -> void:
	updateMoney()
	generateItems()
	resetPanel()

func updateMoney() -> void:
	moneyLabel.text = str(Globals.stats.money)

func generateItems() -> void:
	for i in itemAmmount:
		var itemInstance = load("res://Scenes/shop_item.tscn").instantiate()
		itemInstance.item = Globals.stats.weightedRandomReward()
		itemInstance.selected.connect(itemSelected)
		itemContainer.add_child(itemInstance)

func itemSelected(item: Item, instance: Control) -> void:
	updatePanel(item)
	if is_instance_valid(selectedInstance):
		selectedInstance.outline.set_shader_parameter("enabled", false)
	selectedItem = item
	selectedInstance = instance
	selectedInstance.outline.set_shader_parameter("enabled", true)
	buyButton.disabled = Globals.stats.money < item.price

func updatePanel(item: Item) -> void:
	itemNameLabel.text = item.name
	itemTypeLabel.text = item.type
	itemPriceLabel.text = "Price: $ " + str(item.price)
	itemDescriptionLabel.text = item.getDescription()

func resetPanel() -> void:
	itemNameLabel.text = "No item selected"
	itemTypeLabel.text = ""
	itemPriceLabel.text = ""
	itemDescriptionLabel.text = ""
	buyButton.disabled = true

func buyItem() -> void:
	Globals.stats.money -= selectedItem.price
	selectedInstance.queue_free()
	selectedInstance = null
	updateMoney()
	resetPanel()
	if selectedItem.type == "Artifact":
		Globals.stats.artifactObtained(selectedItem)
		return
	if selectedItem is Gun:
		Globals.stats.gunObtained(selectedItem)
	Globals.inventory.addItem(selectedItem)
	SfxManager.play_sound(buyItemSound)

