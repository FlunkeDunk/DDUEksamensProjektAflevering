extends VBoxContainer
@onready var generatorMenu = $"../../../../../.."
@onready var progressBar = $ProgressBar
@onready var energyPerSecond = $InfoContainer/EnergyPerSecond
#@onready var batteryText = $InfoContainer/BatteryText
@onready var energyText = $ProgressBar/EnergyText

func _process(_delta) -> void:
	updateText()

func updateText() -> void:
	progressBar.value = generatorMenu.energy
	progressBar.max_value = generatorMenu.energyLimit
	energyText.text = "%s/%s" % [Globals.convertNum(round(generatorMenu.energy)), Globals.convertNum(round(generatorMenu.energyLimit))]
	energyPerSecond.text = "%s Power Per Day" % Globals.convertNum(round(generatorMenu.energyGain))
	#batteryText.text = str(round(generatorMenu.energyLimit)) + " Battery Capacity"
