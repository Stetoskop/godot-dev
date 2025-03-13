extends RigidBody2D

# Parent scaler exported
@export var ball_scale_mult := 1.0  # Default scale

# Load nodes for scaling
@onready var col_shape := $CollisionShape2D
@onready var light_occ := $LightOccluder2D
@onready var sprite := $BasketBallImage
@onready var sound_col := $"Sound Collision/CollisionShape2D"

# Load sound players
@onready var area_hit := $"Sound Collision/AreaHit"
@onready var mouse_hit := $"Sound Collision/MouseHit"

# Export min and max pitch values to inspector
# Define pitch variable
@export var pitch_min: float
@export var pitch_max: float
var pitch := 2

func _ready() -> void:
	# Apply the scale to all children nodes
	col_shape.scale *= Vector2(ball_scale_mult, ball_scale_mult)
	light_occ.scale *= Vector2(ball_scale_mult, ball_scale_mult)
	sprite.scale *= Vector2(ball_scale_mult, ball_scale_mult)
	sound_col.scale *= Vector2(ball_scale_mult, ball_scale_mult)

func play_hit(body_entered):
	# Sets random pitch
	# If body entered has group mouse, play mouse_hit
	# In all other cases (areas) play area_hit
	#pitch = randf_range(pitch_min,pitch_max)
	if body_entered.is_in_group("mouse"):
		#mouse_hit.pitch_scale = pitch
		mouse_hit.play()
	else: 
		#area_hit.pitch_scale = pitch
		area_hit.play()

func _on_sound_collision_body_entered(body: Node2D) -> void:
	# On collision, run play_hit() with the collided-with body as parameter
	# Print console message with collided-with's body type
	play_hit(body)
	print("Collided with:  " + str(body.get_groups()))
