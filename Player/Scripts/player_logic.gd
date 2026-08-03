class_name Player
extends CharacterBody3D

var SENSITIVITY = 0.005
var DEFAULT_SPEED = 2.5
var SPEED = 2.5
var SPRINT_SPEED = 5.0
var CROUCH_SPEED = 1.5
var JUMP_VELOCITY = 4.5

@export var Health : int = 100
var Dead : bool = false
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
		if Input.is_action_pressed("Forward") or Input.is_action_pressed("Backward") or Input.is_action_pressed("Left") or Input.is_action_pressed("Right"):
			if Crouched == false and Dead == false:
				$Menus/Interface/VBoxContainer/StaminaBar.value -= 0.05
	else:
		if Crouched == true:
			$Menus/Interface/VBoxContainer/StaminaBar.value += 0.2
		$Menus/Interface/VBoxContainer/StaminaBar.value += 0.1


### PHYSICS STUFF ###
func _physics_process(delta: float) -> void:
	### ADD THE GRAVITTY ###
	if not is_on_floor():
		velocity += get_gravity() * delta

	### JUMPING ###
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		if Dead == false:
			velocity.y = JUMP_VELOCITY
	
	### MOVEMENT ###
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var vel2d := Vector2(velocity.x, velocity.z)
	var DEACC : float = SPEED * 0.1
	if direction and Dead == false:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		if Crouched == false and Dead == false:
			$AnimationPlayer.play("CamBob")
	else:
		vel2d = vel2d.move_toward(Vector2.ZERO, DEACC)
		velocity.x = vel2d.x
		velocity.z = vel2d.y
		if Crouched == false and Dead == false:
			$AnimationPlayer.play("Idle")
	move_and_slide()
	
	
	### PUSHING PHYSICS OBJECTS ###
	var Push_Force = 0.30
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody3D:
			c.get_collider().apply_central_impulse(-c.get_normal() * Push_Force)


### MOUSE FREEDOM ###
func jail_mouse():
	# Put that bitch in jail
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
func free_mouse():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


### KEY/MOUSE INPUT ###
var Held_Object = null
var HoldingSmth : bool = false
func _input(event: InputEvent) -> void:
	### PLAYER'S CAMERA MOVEMENT WITH MOUSE MOTION ###
	if event is InputEventMouseMotion and Dead == false:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			rotate_y(-event.relative.x * SENSITIVITY)
			$CamPoint.rotate_x(-event.relative.y * SENSITIVITY)
			$CamPoint.rotation.x = clamp($CamPoint.rotation.x, -PI/2, PI/2)
	
	
	### INTERACTING WITH OBJECTS ###
	if Input.is_action_just_pressed("Interact") and Dead == false:
		if %RayCastInteract.is_colliding():
			var collider = %RayCastInteract.get_collider()
			if collider.has_method("Interact"):
				collider.Interact()


	### PICKING UP AND DROPPING THINGS ###
	if Input.is_action_just_pressed("Grab") and Dead == false:
		if %RayCastInteract.is_colliding():
			var collider = %RayCastInteract.get_collider()
			if collider.is_in_group("Grabable"):
				if HoldingSmth == false:
					collider.reparent($CamPoint/Hand)
					collider.freeze = true
					collider.global_position = $CamPoint/Hand.global_position
					collider.rotation = Vector3(0,0,0)
					collider.collision_layer = 0
					collider.collision_mask = 0
					Held_Object = collider
					HoldingSmth = true
	if Input.is_action_just_pressed("Drop") and Dead == false:
		if HoldingSmth == true:
			DropObj()


	### CROUCHING AND UNCROUCHING ###
	if Input.is_action_just_pressed("Crouch") and Dead == false:
		# Yeah thats right, on your knees like a good boy
		if Crouched == false:
			$AnimationPlayer.play("Crouching")
			Crouched = true
			$Collision.set_deferred("disabled", true)
			SPEED = CROUCH_SPEED
		elif Crouched == true:
			if not $CrouchCollision/CrouchRay.is_colliding():
				# Okay stand up now
				$AnimationPlayer.play("CamBob")
				Crouched = false
				$Collision.set_deferred("disabled", false)
				SPEED = DEFAULT_SPEED


	### SPRINTING ###
	if Input.is_action_pressed("Sprint") and Dead == false:
		if Crouched == false:
			if Input.is_action_pressed("Forward") or Input.is_action_pressed("Backward") or Input.is_action_pressed("Left") or Input.is_action_pressed("Right"):
				if $Menus/Interface/VBoxContainer/StaminaBar.value <= 1.0:
					SPEED = CROUCH_SPEED
				elif $Menus/Interface/VBoxContainer/StaminaBar.value > 1.0:
					SPEED = SPRINT_SPEED
				$AnimationPlayer.speed_scale = 2.0
	elif Input.is_action_just_released("Sprint") and Dead == false:
		if Crouched == false:
			SPEED = DEFAULT_SPEED
			$AnimationPlayer.speed_scale = 1.0


func DropObj():
	Held_Object.reparent(get_tree().current_scene)
	Held_Object.freeze = false
	Held_Object.collision_layer = 1
	Held_Object.collision_mask = 1
	Held_Object = null
	HoldingSmth = false


### PLAYER DAMAGE FUNC ###
func damagePlayer(dmgAmount : int):
	if Health < 0:
		Health = 0
	if Health > 100:
		Health = 100
	
	Health -= dmgAmount
	
	if Health <= 0:
		Die()
		print("Died")


### PLAYER HEAL FUNC ###
func healPlayer(healAmount : int):
	if Health < 0:
		Health = 0
	if Health > 100:
		Health = 100
	
	Health += healAmount


### PLAYER DEATH FUNC ###
func Die():
	$AnimationPlayer.play("Die")
	free_mouse()
	Dead = true


### FOOTSTEPS BASED OFF GROUP ###
func play_step_sound():
	if $FloorMatCheck.is_colliding() and Dead == false:
		var collider = $FloorMatCheck.get_collider()
		if collider.is_in_group("grass"):
			var randint = randi_range(1,2)
			if randint == 1:
				$Sound/footstep_Grass01.play()
			else:
				$Sound/footstep_Grass02.play()
			
		elif collider.is_in_group("gravel"):
			$Sound/footstep_Gravel01.play()
			
		elif collider.is_in_group("metal"):
			$Sound/footstep_Metal01.play()
			
		elif collider.is_in_group("stone"):
			var randint = randi_range(1,2)
			if randint == 1:
				$Sound/footstep_Stone01.play()
			else:
				$Sound/footstep_Stone02.play()
			
		elif collider.is_in_group("wood"):
			var randint = randi_range(1,2)
			if randint == 1:
				$Sound/footstep_Wood01.play()
			else:
				$Sound/footstep_Wood02.play()
