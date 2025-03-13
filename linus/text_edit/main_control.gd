extends Control

@onready var open_file: FileDialog = $OpenFileDialog
@onready var save_file: FileDialog = $SaveFileDialog
@onready var text_edit: TextEdit = $TextEdit

# OptionsRow signal for actions after clicking menu option


#func _on_open_file_pressed() -> void:
	#open_file.popup()
	#print_debug("Open pressed")
#
#func _on_save_file_pressed() -> void:
	#save_file.popup()
	#print_debug("Save pressed")

# Load file
signal _file_opened(path_to_file: String)
func _on_open_file_dialog_file_selected(path: String) -> void:
	var file: FileAccess = FileAccess.open(path,FileAccess.READ) # Set 'file' to selected file
	text_edit.text = file.get_as_text() # Store text in TextEdit.text (text_edit.text)
	emit_signal("_file_opened",path)
	file.close() # Unload file from memory
	
	print_debug("Opened: " + path)


signal _file_saved(path_to_file: String)
func _on_save_file_dialog_file_selected(path: String) -> void: # Save file as
	var file: FileAccess = FileAccess.open(path, FileAccess.WRITE) # Set 'file' to selected file
	file.store_string(text_edit.text) # Write text to file from TextEdit.text (text_edit.text)
	emit_signal("_file_saved",path)
	file.close() # Unload file from memory
	
	print("Saved to: " + path)
