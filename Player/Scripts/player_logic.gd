class_name Player
extends CharacterBody3D

var SENSITIVITY = 0.005
var SPEED = 2.5
var JUMP_VELOCITY = 4.5

@export var Health : int = 100
var Crouched : bool = false


### SET WHEN PLAYER ENTERS SCENE ###
func _ready() -> void:
	jail_mouse()
	$Menus/PauseMenu.hide()


### CALL EVERY FRAME ###
func _process(_delta: float) -> void:
	
	### DECREASE STAMINA ###
	# I wonder if there is a better way to do this
	if Input.is_action_pressed("Sprint"):
		if Crouched == false:
			$Menus/Interface/VBoxContainer/StaminaBar.value -= 0.1
	else:
		$Menus/Interface/VBoxContainer/StaminaBar.value += 0.1


### PHYSICS STUFF ###
func _physics_process(delta: float) -> void:
	### ADD THE GRAVITTY ###
	if not is_on_floor():
		velocity += get_gravity() * delta

	### JUMPING ###
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	### MOVEMENT ###
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var vel2d := Vector2(velocity.x, velocity.z)
	var DEACC : float = SPEED * 0.1
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		if Crouched == false:
			$AnimationPlayer.play("CamBob")
	else:
		vel2d = vel2d.move_toward(Vector2.ZERO, DEACC)
		velocity.x = vel2d.x
		velocity.z = vel2d.y
		if Crouched == false:
			$AnimationPlayer.play("Idle")
	move_and_slide()
	
	
	### PUSHING PHYSICS OBJECTS ###
	var Push_Force = 0.30
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody3D:
			c.get_collider().apply_central_impulse(-c.get_normal() * Push_Force)


func jail_mouse():
	# Put that bitch in jail
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
func free_mouse():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


### KEY/MOUSE INPUT ###
func _input(event: InputEvent) -> void:
	### PLAYER'S CAMERA MOVEMENT WITH MOUSE MOTION ###
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			rotate_y(-event.relative.x * SENSITIVITY)
			$CamPoint.rotate_x(-event.relative.y * SENSITIVITY)
			$CamPoint.rotation.x = clamp($CamPoint.rotation.x, -PI/2, PI/2)
	
	### TEMPORARY PAUSING TO EXIT GAME ###
	if Input.is_action_just_pressed("Escape"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			free_mouse()
		elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			jail_mouse()
	
	### INTERACTING WITH OBJECTS ###
	if Input.is_action_just_pressed("Interact"):
		if %RayCastInteract.is_colliding():
			var collider = %RayCastInteract.get_collider()
			if collider.has_method("Interact"):
				collider.Interact()
				print("Interacted")
	
	### CROUCHING AND UNCROUCHING ###
	if Input.is_action_just_pressed("Crouch"):
		# Yeah thats right, on your knees like a good boy
		if Crouched == false:
			$AnimationPlayer.play("Crouching")
			Crouched = true
			$Collision.set_deferred("disabled", true)
			SPEED = 1.5
		elif Crouched == true:
			if not $CrouchCollision/CrouchRay.is_colliding():
				# Okay stand up now
				$AnimationPlayer.play("CamBob")
				Crouched = false
				$Collision.set_deferred("disabled", false)
				SPEED = 2.5
	
	### SPRINTING ###
	if Input.is_action_pressed("Sprint"):
		if Crouched == false:
			SPEED = 5.0
	elif Input.is_action_just_released("Sprint"):
		if Crouched == false:
			SPEED = 2.5


### PLAYER DAMAGE FUNC ###
func damagePlayer(dmgAmount : int):
	if Health < 0:
		Health = 0
	if Health > 100:
		Health = 100
	
	Health -= dmgAmount
	
	if Health <= 0:
		# Placeholder
		print("Died")


### PLAYER HEAL FUNC ###
func healPlayer(healAmount : int):
	if Health < 0:
		Health = 0
	if Health > 100:
		Health = 100
	
	Health += healAmount


### FOOTSTEPS BASED OFF GROUP ###
func play_step_sound():
	if $FloorMatCheck.is_colliding():
		var collider = $FloorMatCheck.get_collider()
		if collider.is_in_group("grass"):
			$Sound/footstep_Grass01.play()
			
		elif collider.is_in_group("gravel"):
			$Sound/footstep_Gravel01.play()
			
		elif collider.is_in_group("metal"):
			$Sound/footstep_Metal01.play()
			
		elif collider.is_in_group("stone"):
			$Sound/footstep_Stone01.play()
			
		elif collider.is_in_group("wood"):
			$Sound/footstep_Wood01.play()
