extends Panel

#var database: DatabaseManager = DatabaseManager.new()
@onready var nameEdit = %NameEdit
@onready var submitButton = %SubmitButton
@onready var scoreLabel = $MarginContainer/VBoxContainer/ScoreLabel
@onready var levelManager: Control = get_tree().get_root().get_node("MainScene/LevelManager")
@onready var submitClick: AudioStream = load("res://Assets/AudioFiles/UIBeepLighter.mp3")
@export var mainMenu: String
var score: int
func _ready():
	await owner.ready
	#add_child(database)
	Globals.database.scoreSubmiited.connect(levelManager.loadLevel.bind(mainMenu, false))
	scoreLabel.text = "Score: " + str(score)
	submitButton.pressed.connect(submitScore)
	SfxManager.play_sound(submitClick)

func submitScore() -> void:
	
	Globals.database.submitScore(score, nameEdit.text)
