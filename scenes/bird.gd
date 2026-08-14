extends CharacterBody2D

const GRAVITY : int = 1000
const MAX_VEL : int = 600
const FLAP_SPEED : int = -500
var flying : bool = false
var falling : bool = false
var crashed : bool = false
const START_POS = Vector2(100, 400)
var CRASH_Y : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.animation_finished.connect(_on_animation_finished)
	reset()

#waits for flying animation to finish when flap is called, then back to gliding
func _on_animation_finished():
	if $AnimatedSprite2D.animation == "flying":
		$AnimatedSprite2D.play("gliding")

func set_floor(ground_floor):
	CRASH_Y = ground_floor

func reset():
	crashed = false
	falling = false
	flying = false
	position = START_POS
	$AnimatedSprite2D.play("gliding")
	$AnimatedSprite2D/CrashParticle/CPUParticles2D.emitting = false # turns off particle emmission on reset or start
	set_rotation(0)
	
	# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if flying or falling:
		velocity.y += GRAVITY * delta
		#terminal velocity
		if velocity.y > MAX_VEL:
			velocity.y = MAX_VEL
		if flying:
			set_rotation(deg_to_rad(velocity.y * 0.05))
			# turned off setting anim each frame $AnimatedSprite2D.play("gliding")
		elif falling:
			$AnimatedSprite2D.pause()
			if position.y >= CRASH_Y:
				falling = false
				crashed = true
		move_and_collide(velocity * delta)
	else:
		if crashed:
			position.y = CRASH_Y
			set_rotation(0)
			$AnimatedSprite2D.play("crash")
			$AnimatedSprite2D/CrashParticle/CPUParticles2D.emitting = true #turns on particle emission after hitting ground
			await get_tree().create_timer(3).timeout
		$AnimatedSprite2D.pause()
		
func flap():
	velocity.y = FLAP_SPEED
	$AnimatedSprite2D.play("flying")
	
func crash():
	crashed = true


func _on_animated_sprite_2d_animation_finished() -> void:
	pass # Replace with function body.
