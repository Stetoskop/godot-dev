extends Node2D

@export var main_menu_scene: PackedScene
@export var main_game_scene: PackedScene


func _ready() -> void:
	change_state(Global.State.MAIN_MENU)

func _process(delta: float) -> void:
	pass

func change_state(new_state: Global.State):
	match new_state:
		Global.State.MAIN_MENU:
			pass
		Global.State.GAME:
			pass
	Global.current_state = new_state

func instantiate_scene():
	pass
