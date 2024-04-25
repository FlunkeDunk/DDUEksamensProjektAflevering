extends Control

@onready var masterVolume = %MasterVolume
@onready var masterVolumeText = %MasterVolumeText
@onready var sfxVolume = %SFXVolume
@onready var sfxVolumeText = %SFXVolumeText
@onready var musicVolume = %MusicVolume
@onready var musicVolumeText = %MusicVolumeText

@onready var volumeChange: AudioStream = load("res://Assets/AudioFiles/volumeChangeQuieter.mp3")
@onready var arrow = %Arrow
@onready var lowGraphics = %Graphics

func _ready():
	if get_tree().paused:
		owner.stopPause.connect(_on_scene_change_button_pressed)
	masterVolume.value = db_to_linear(Globals.settings.master)
	sfxVolume.value = db_to_linear(Globals.settings.SFX)
	musicVolume.value = db_to_linear(Globals.settings.music)
	arrow.button_pressed = Globals.settings.showArrow
	lowGraphics.button_pressed = Globals.settings.lowGraphics


func _on_master_volume_value_changed(value):
	var newValue = linear_to_db(value)
	AudioServer.set_bus_volume_db(0, newValue)
	Globals.settings.master = newValue
	masterVolumeText.text = str(round(value*100)) + "%"
	SfxManager.play_sound(volumeChange)


func _on_sfx_volume_value_changed(value):
	var newValue = linear_to_db(value)
	AudioServer.set_bus_volume_db(1, newValue)
	Globals.settings.SFX = newValue
	sfxVolumeText.text = str(round(value*100)) + "%"
	SfxManager.play_sound(volumeChange)


func _on_music_volume_value_changed(value):
	var newValue = linear_to_db(value)
	AudioServer.set_bus_volume_db(2, newValue)
	Globals.settings.music = newValue
	musicVolumeText.text = str(round(value*100)) + "%"
	SfxManager.play_sound(volumeChange)


func _on_arrow_toggled(toggled_on):
	Globals.settings.showArrow = toggled_on

func _on_graphics_toggled(toggled_on):
	Globals.settings.lowGraphics = toggled_on


func _on_scene_change_button_pressed():
	ResourceSaver.save(Globals.settings, "user://Settings.tres", 1)


