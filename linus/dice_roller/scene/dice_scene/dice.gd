extends Control

@onready var sprite: AnimatedSprite2D = $"HBox/Dice (Control)/AnimSprite2D"
var rolling: bool = false

func _ready() -> void:
	sprite.frame = randi() % sprite.sprite_frames.get_frame_count("roll")

func _process(delta: float) -> void:
	if rolling:
		sprite.play("roll")
	if !rolling:
		sprite.stop()

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and Input.is_action_pressed("left_click"):
		rolling = true
		print("rolling clicked")
