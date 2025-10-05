extends Node

@export var mob_scene: PackedScene
var score

func _ready():
	new_game()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$Mob.start($Mob/SpawnPosition.position)
	$Mob2.start($Mob2/SpawnPosition.position)
	$Mob3.start($Mob3/SpawnPosition.position)
