extends Panel

#var database: DatabaseManager = DatabaseManager.new()
@onready var placementContainer = %PlacementContainer
@onready var returnButton = %ReturnButton
@export var ownScene: bool = true

func _ready():
	#add_child(database)
	Globals.database.leaderboardRecieved.connect(updateLeaderboard)
	Globals.database.getLeaderboard()
	if !ownScene:
		returnButton.hide()

func updateLeaderboard(leaderboard: Dictionary) -> void:
	var top20: Array = []
	for i in min(20, leaderboard.size()-1):
		top20.append(leaderboard[str(i)])
	for index in top20.size():
		var ranking: Ranking = load("res://Scenes/Ranking.tscn").instantiate()
		ranking.placement = str(index+1)
		ranking.username = top20[index]['username']
		ranking.score = top20[index]['score']
		placementContainer.add_child(ranking)


