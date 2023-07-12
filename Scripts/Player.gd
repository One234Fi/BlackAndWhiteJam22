extends KinematicBody2D

#signal sent to the level map script when a collision happens
signal collided
signal spawn_block

#modifiable variables that effect movement
export var moveSpeed = 400
export var jumpStrength = 300
export var airModifier = 0.75
export var fallSpeed = 10
export var SPAWNPOINT = Vector2(0,0)

#some vectors for movement
var up = Vector2(0, -1)
var jumpVect = Vector2(0, -jumpStrength)
var velocity = Vector2.ZERO

#behaviour booleans
var isGrounded = false
var isJumping = false
var jumpSquat = false
var idle = false
var takeDamage = false
var toggleHide = false
var canTakeDamage = true

func _ready():
	SPAWNPOINT = position
	
	#connect signals to level (player will always be a child of level to make this easier)
# warning-ignore:return_value_discarded
	self.connect("collided", get_parent(), "_on_Player_collided")
# warning-ignore:return_value_discarded
	self.connect("spawn_block", get_parent(), "_on_Player_spawn_block")
# warning-ignore:return_value_discarded
	get_parent().connect("damage", self, "_on_Level_damage")
	
	$HUD/TimerDisplay.hide()

func get_input():
	#multiply moveAxis by movespeed and store in the velocity vector
	var moveAxis = Input.get_axis("move_left", "move_right")
	velocity.x = moveAxis * moveSpeed
	
	#determine if it is possible to jump and begin jumping if so
	if Input.is_action_just_pressed("jump") && is_on_floor():
		jumpSquat = true
		get_node("SquatTimer").start()
	
	if (Input.is_action_pressed("restart")):
		respawn()

##TODO
func determine_animation():
	pass

#most of this method is a mess and can probably be done better but it works for now
func _physics_process(delta):
	# a damaged state conditional
	if takeDamage:
		velocity.y = -30
		toggleHide = !toggleHide
		if toggleHide:
			show()
		else:
			hide()
	else:
		velocity.y += fallSpeed * delta
		get_input()
	
	#if airborne modify the x velocity and play the right animation
	if !is_on_floor():
		velocity.x *= airModifier
		if velocity.y < -10 && !is_on_wall():
			$AnimatedSprite.play("jump")
		elif velocity.y > 10 && !is_on_wall():
			$AnimatedSprite.play("fall")
		elif !is_on_wall():
			$AnimatedSprite.play("squish")
	
	#determine grounded animations and stuff
	if isJumping:
		isJumping = false
		velocity.y = -jumpStrength
	elif jumpSquat:
		$AnimatedSprite.play("squish")
	elif velocity.x > 0 && is_on_floor():
		$AnimatedSprite.play("move")
		$AnimatedSprite.flip_h = false
	elif velocity.x < 0 && is_on_floor():
		$AnimatedSprite.play("move")
		$AnimatedSprite.flip_h = true
	elif is_on_floor():
		if idle:
			$AnimatedSprite.play("idle")
		else:
			$IdleTimer.start()
			$AnimatedSprite.play("stand")
	
	#"borrowed" from KidsCanCode because I was stuck on tile collisions
	#source: https://www.youtube.com/watch?v=OzgK__VowVs
	velocity = move_and_slide(velocity, up, true, 2)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision:
			emit_signal('collided', collision)
	
	update_hud()

#if both death and damage timer are stopped, start them
func start_death():
	if get_node("DeathTimer").is_stopped():
		if get_node("DamageTimer").is_stopped():
			get_node("DamageTimer").start()
			get_node("DeathTimer").start()
			$HUD/TimerDisplay.show()

# I think this works, call spawn_block
func respawn():
	position = SPAWNPOINT
	show()
	#print(SPAWNPOINT)

#TODO: Find location of player and spawn a filled_block on the nearest tile
func spawn_block():
	var block_pos = position
	emit_signal("spawn_block", block_pos)

#jumpSquat ends, start jump
func _on_SquatTimer_timeout():
	$Jump.play()
	jumpSquat = false
	isJumping = true

#player is idle, start animation
func _on_IdleTimer_timeout():
	idle = true

#player has died, spawn a block at death location and respawn
func _on_DeathTimer_timeout():
	##hide()
	takeDamage = false
	canTakeDamage = true
	$Death.play()
	spawn_block()
	respawn()
	$HUD/TimerDisplay.hide()

#has taken damage from a stage hazard
func _on_Level_damage():
	if takeDamage == false && canTakeDamage == true:
		takeDamage = true
		canTakeDamage = false
		$Damaged.play()
		start_death()

#end of damage state, make sure player is visible
func _on_DamageTimer_timeout():
	takeDamage = false
	show()

func update_hud():
	$HUD/TimerDisplay.text =  "Death In: %1.2f" % $DeathTimer.time_left
