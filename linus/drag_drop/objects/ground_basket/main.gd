extends Node2D

# Variables for intitial score, amount to add to score and the labels node
@export var score := 0
@export var score_per_shot := 1
@onready var score_label := $Control/ScoreLable

func _on_area_2d_body_entered(body: Node2D) -> void:
	# If body in parameter is "ball", run update_score()
	if body.is_in_group("ball"):
		update_score()
		
func update_score():
	score += score_per_shot
	score_label.text = "Dude Perfects:  " + str(score)
