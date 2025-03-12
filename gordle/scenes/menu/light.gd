extends PointLight2D

func _process(delta: float) -> void:
	self.energy = randf_range(0.6,0.8)
	self.color = Color(1.0, randf_range(0.43, 0.5), 0.0, 1.0)
