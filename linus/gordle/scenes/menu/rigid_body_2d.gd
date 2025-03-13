extends CharacterBody2D

# Speed of the character
var speed: float = 2.0

func _physics_process(delta: float) -> void:
	# Calculate the direction based on rotation
	var direction: Vector2 = Vector2.RIGHT.rotated(rotation)
	rotation += speed * delta	
	velocity = direction * speed
	

	
	# Move the character
	move_and_slide()
