extends HBoxContainer
class_name Ranking

@onready var nameLabel = %NameLabel
@onready var scoreLabel = %ScoreLabel
@onready var placementLabel = %PlacementLabel

var placement: String
var username: String
var score: String





func _ready() -> void:
	placementLabel.text = placement
	if username == "":
		username = "none"
	nameLabel.text = username
	scoreLabel.text = score
