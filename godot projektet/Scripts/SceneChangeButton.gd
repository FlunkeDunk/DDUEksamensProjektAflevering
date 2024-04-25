extends Button
class_name ChangeSceneButton

@export var scene: String
@onready var levelManager: Control = get_tree().get_root().get_node("MainScene/LevelManager")
@onready var mainMenuClick: AudioStream = load("res://Assets/AudioFiles/buy.wav")
@export var playFade: bool = false
@export var sound: AudioStream
@export var departure: AudioStream

func _pressed() -> void:
	get_tree().paused = false
	if playFade:
		await levelManager.playFade()
	levelManager.loadLevel(scene, playFade)
	SfxManager.play_sound(mainMenuClick)
	SfxManager.play_sound(departure)




