extends Node2D
class_name ArtifactManager

var artifacts: Array[Artifact]
@export var startArtifact: Artifact
@export var levelManager: Control

func _ready():
	Globals.newStatsCreated.connect(connectAddArtifact)
	#levelManager.saveLoaded.connect(call_deferred.bind("onLoad"))
	#addArtifact()
	#for i in Globals.stats.availableArtifacts.size():
		#var artifact = Globals.stats.getNewArtifact()
		#Globals.stats.artifactObtained(artifact)

func addArtifact(artifact: Artifact) -> void:
	Globals.inventory.addItem(artifact)
	artifacts.append(artifact)
	#artifact.applyEffect()
	var artifactNode: Node = Node.new()
	artifactNode.set_script(artifact.nodeScript)
	add_child(artifactNode)

func connectAddArtifact() -> void:
	if !Globals.stats.gotArtifact.is_connected(addArtifact):
		Globals.stats.gotArtifact.connect(addArtifact)
