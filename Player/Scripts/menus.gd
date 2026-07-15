extends Node


func _ready() -> void:
	$PauseMenu/Settings/Panel/VBoxContainer/VolLabel.text = str(AudioServer.get_bus_name(0)) + " - " + str($PauseMenu/Settings/Panel/VBoxContainer/VolumeSlide.value * 10)
	$PauseMenu/Settings/Panel/VBoxContainer/VolumeSlide.value = db_to_linear(AudioServer.get_bus_index("Master"))
	
	$PauseMenu/Settings/Panel/VBoxContainer/VoiLabel.text = str(AudioServer.get_bus_name(1)) + " - " + str($PauseMenu/Settings/Panel/VBoxContainer/VoiSlider.value * 10)
	$PauseMenu/Settings/Panel/VBoxContainer/VoiSlider.value = db_to_linear(AudioServer.get_bus_index("Voices"))
	
	$PauseMenu/Settings/Panel/VBoxContainer/FootLabel.text = str(AudioServer.get_bus_name(2)) + " - " + str($PauseMenu/Settings/Panel/VBoxContainer/FootSlider.value * 10)
	$PauseMenu/Settings/Panel/VBoxContainer/FootSlider.value = db_to_linear(AudioServer.get_bus_index("Footsteps"))


func _process(_delta: float) -> void:
	$Interface/VBoxContainer/HealthBar.value = $"..".Health


### MOUSE FREEDOM ###
func jail_mouse():
	# Put that bitch in jail
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
func free_mouse():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _input(_event: InputEvent) -> void:
	### SHOW PAUSE MENU ###
	if Input.is_action_just_pressed("Escape"):
		if get_tree().paused == false:
			get_tree().paused = true
			$PauseMenu.show()
			free_mouse()
		elif get_tree().paused == true:
			get_tree().paused = false
			$PauseMenu.hide()
			jail_mouse()


### PAUSE MENU ###
func _on_resume_pressed() -> void:
	get_tree().paused = false
	$PauseMenu.hide()
	jail_mouse()

func _on_settings_pressed() -> void:
	$PauseMenu/Settings.show()

func _on_quit_2_desktop_pressed() -> void:
	get_tree().quit()

func _on_close_settings_pressed() -> void:
	$PauseMenu/Settings.hide()


### SETTINGS MENU ###

### MASTER VOLUME SLIDER ###
func _on_volume_slide_value_changed(value: float) -> void:
	var bus = AudioServer.get_bus_index("Master")
	$PauseMenu/Settings/Panel/VBoxContainer/VolLabel.text = str(AudioServer.get_bus_name(0)) + " - " + str(value * 10)
	
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))


### VOICE VOLUME SLIDER ###
func _on_voi_slider_value_changed(value: float) -> void:
	var bus = AudioServer.get_bus_index("Voices")
	$PauseMenu/Settings/Panel/VBoxContainer/VoiLabel.text = str(AudioServer.get_bus_name(1)) + " - " + str(value * 10)
	
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))


### FOOTSTEP VOLUME SLIDER ###
func _on_foot_slider_value_changed(value: float) -> void:
	var bus = AudioServer.get_bus_index("Footsteps")
	$PauseMenu/Settings/Panel/VBoxContainer/FootLabel.text = str(AudioServer.get_bus_name(2)) + " - " + str(value * 10)
	
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))


### FIELD OF VIEW SLIDER ###
func _on_fo_vslide_value_changed(value: float) -> void:
	var Camera = $"../CamPoint/PlayerCam"
	$PauseMenu/Settings/Panel/VBoxContainer/FOVLabel.text = "FOV: " + str(value)
	
	Camera.fov = value


### SENSITIVITY ###
func _on_sens_slide_value_changed(value: float) -> void:
	$PauseMenu/Settings/Panel/VBoxContainer/SensLabel.text = "Sensitivity: " + str(value * 1000)
	
	$"..".SENSITIVITY = value


### WINDOW MODES ###
func _on_window_mode_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)


### ANTI-ALIASING ###
func _on_anti_aliasing_item_selected(index: int) -> void:
	match index:
		0:
			get_viewport().msaa_3d = Viewport.MSAA_8X
			get_viewport().use_taa = false
		1:
			get_viewport().msaa_3d = Viewport.MSAA_4X
			get_viewport().use_taa = false
		2:
			get_viewport().msaa_3d = Viewport.MSAA_2X
			get_viewport().use_taa = false
		3:
			get_viewport().use_taa = true
		4:
			get_viewport().msaa_3d = Viewport.MSAA_DISABLED
			get_viewport().use_taa = false


### SHADOW QUALITY ###
func _on_shadows_item_selected(index: int) -> void:
	match index:
		pass


### VIEWPORT SCALING ###
func _on_scale_button_item_selected(index: int) -> void:
	match index:
		0:
			RenderingServer.viewport_set_scaling_3d_mode(get_viewport().get_viewport_rid(), RenderingServer.VIEWPORT_SCALING_3D_MODE_FSR2)
		1:
			RenderingServer.viewport_set_scaling_3d_mode(get_viewport().get_viewport_rid(), RenderingServer.VIEWPORT_SCALING_3D_MODE_FSR)
		2:
			RenderingServer.viewport_set_scaling_3d_mode(get_viewport().get_viewport_rid(), RenderingServer.VIEWPORT_SCALING_3D_MODE_BILINEAR)
