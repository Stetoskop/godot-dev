extends Control

@onready var open_file: FileDialog = $"../OpenFileDialog"
@onready var save_file: FileDialog = $"../SaveFileDialog"
@onready var file_menu: MenuButton = $Panel/FileMenu
@onready var file_menu_popup: PopupMenu = file_menu.get_popup()

func _ready() -> void:
	file_menu_popup.connect("id_pressed", Callable(self, "_on_menu_item_pressed"))

func _on_menu_item_pressed(id: int) -> void:
	match id:
		0:
			open_file.popup()
			print_debug("File -> Open clicked")
		1:
			save_file.popup()
			print_debug("File -> Save as clicked")
		2:
			get_tree().quit()
			print_debug("File -> Quit clicked")
