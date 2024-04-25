extends Control

@onready var playButton = %PlayButton
@onready var playButtonClick: AudioStream = load("res://Assets/AudioFiles/UIBeepLighter.mp3")

# Called when the node enters the scene tree for the first time.
func _ready():
	SfxManager.play_music(load("res://Assets/AudioFiles/menu_music.mp3"))
	checkForSave()
	Engine.set_time_scale(1)
	
func checkForSave() -> void:
	var newConfig = ConfigFile.new()
	newConfig.load("user://saves.cfg")
	if !newConfig.has_section("SAVES"):
		playButton.disabled = true

func _on_play_button_pressed():
	get_parent().loadSave()
	SfxManager.play_sound(playButtonClick)
	
