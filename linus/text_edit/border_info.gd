extends Label

@onready var delay_timer: Timer = $"../Timer"

const info_text = {
	"opened":"File opened...",
	"saved":"File saved as"
	}

func get_state_strings():
	pass

func _on_main__file_opened() -> void:
	self.text = info_text["opened"]
	delay_timer.wait_time = 3.0
	delay_timer.start()
	await delay_timer.timeout
	self.text = ""


func _on_main__file_saved() -> void:
	self.text = info_text["saved"]
	delay_timer.wait_time = 3.0
	delay_timer.start()
	await delay_timer.timeout
	self.text = ""
