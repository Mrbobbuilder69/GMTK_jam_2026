extends Control

@onready var main_menu: Control = $"."
@onready var settings: Control = $"../Settings"
@onready var master: HSlider = $"../Settings/Panel/VBoxContainer/Master"
@onready var music: HSlider = $"../Settings/Panel/VBoxContainer/Music"
@onready var sound: HSlider = $"../Settings/Panel/VBoxContainer/Sound"

func _on_master_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))

func _on_music_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))

func _on_sound_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))


func _ready() -> void:
	main_menu.visible = true
	settings.visible = false
	master.value = 0.5
	music.value = 0.5
	sound.value = 0.5

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/test_scene_2.tscn")

func _on_settings_pressed() -> void:
	main_menu.visible = false
	settings.visible = true

func _on_quit_pressed() -> void:
	get_tree().quit()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("esc") and settings.visible == true:
		settings.visible = false
		main_menu.visible = true
	else:
		pass


func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
