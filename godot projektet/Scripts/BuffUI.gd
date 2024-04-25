extends Control

@onready var textureRect = $TextureRect
@onready var buffCount = $Count
@onready var progressBar = $TextureProgressBar

var buffs: Array[Buff]
var time: float
var type: String

func addBuff(buff:Buff) -> void:
	type = buff.type
	buffs.append(buff)
	buff.UI = self
	time = buff.time
	textureRect.texture = buff.sprite
	progressBar.max_value = time
	progressBar.value = time
	updateCount()

func _process(delta):
	updateTexture(delta)

func endBuff(buff: Buff) -> void:
	buffs.erase(buff)
	updateCount()

func updateCount() -> void:
	if buffs.size() > 1:
		buffCount.text = str(buffs.size())
		return
	buffCount.text = ""
	if buffs.size() < 1:
		queue_free()

func updateTexture(delta) -> void:
	progressBar.value = buffs[0].timer.time_left
	#if progressBar.value <= 0:
		#queue_free()
