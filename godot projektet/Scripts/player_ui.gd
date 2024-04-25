extends Control

@export var inventory: Control

@onready var healthBar = %HealthBar
@onready var ammoLabel = %AmmoLabel
@onready var moneyLabel = %MoneyLabel
@onready var effectContainer = %EffectContainer
@onready var buffContainer = %BuffContainer
@onready var leaveButton = %LeaveButton


func _ready() -> void:
	updateEffect()
	inventory.combinationsChanged.connect(updateEffect)

# Called when the node enters the scene tree for the first time.
func updateHealth(newValue, maxValue) -> void:
	healthBar.max_value = maxValue
	var tween: Tween
	if tween:
		tween.kill() # Abort the previous animation.
	tween = create_tween()
	tween.tween_property(healthBar, "value", newValue, 0.1)

func updateAmmo(currentAmmo, maxAmmo) -> void:
	ammoLabel.text = str(currentAmmo) + "/" + str(maxAmmo)

func updateMoney(newValue) -> void:
	moneyLabel.text = str(newValue)

func updateEffectProgression(progresisons: Array[int]) -> void:
	if progresisons.size() != get_child_count():
		updateEffect()
	effectContainer.updateEffectProgression(progresisons)

func updateEffect() -> void:
	effectContainer.updateChildren()

func showLeaveButton() -> void:
	leaveButton.show()
