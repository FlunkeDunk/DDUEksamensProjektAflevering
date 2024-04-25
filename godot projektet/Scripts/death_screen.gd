extends MarginContainer

@onready var scoreLabel = %ScoreLabel
@onready var leaderboard = %Leaderboard
@onready var mainScreen = %MainScreen
@onready var submitscoreScreen = %SubmitscoreScreen
@onready var deathMenuClick: AudioStream = load("res://Assets/AudioFiles/buy.wav")
var score

func _ready():
	score = Globals.stats.score
	submitscoreScreen.score = score
	Globals.resetStats()
	Globals.stats.setAvailableItems()
	scoreLabel.text = "Score: " + str(score)

func hideLeaderboard() -> void:
	leaderboard.hide()
	mainScreen.show()
	SfxManager.play_sound(deathMenuClick)

func _on_leaderboard_button_pressed():
	leaderboard.show()
	mainScreen.hide()
	SfxManager.play_sound(deathMenuClick)


func _on_submit_score_button_pressed():
	submitscoreScreen.show()
	mainScreen.hide()
	SfxManager.play_sound(deathMenuClick)


func _on_return_button_pressed():
	submitscoreScreen.hide()
	mainScreen.show()
	SfxManager.play_sound(deathMenuClick)


