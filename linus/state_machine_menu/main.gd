extends Node2D

@onready var die: AnimatedSprite2D = $Die

enum State { one, two, three }
var current_state: State = State.one

# Process, select and match State
func _process(delta):
	match current_state:
		State.one:
			state_to_frame(State.one)
		State.two:
			state_to_frame(State.two)
		State.three:
			state_to_frame(State.three)

	if Input.is_action_pressed("ui_left"):
		current_state = State.one
	elif Input.is_action_pressed("ui_up"):
		current_state = State.two
	elif Input.is_action_pressed("ui_right"):
		current_state = State.three

func state_to_frame(state: State):
	die.frame = state
