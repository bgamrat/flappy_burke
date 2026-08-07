extends CharacterBody2D

const GRAVITY : int = 1000
const MAX_VEL : int = 600
const FLAP_SPEED : int = -500
var flying : bool = false
var falling : bool = false
var crashed : bool = false
const START_POS = Vector2(100, 400)

# Called when the node enters the scene tree for the first time.
func _ready():
	reset()

func reset():
	crashed = false
	falling = false
	flying = false
	position = START_POS
	$AnimatedSprite2D.play("flying")
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
			$AnimatedSprite2D.play("flying")
		elif falling:
			$AnimatedSprite2D.stop()
		move_and_collide(velocity * delta)
	else:
		if crashed:
			set_rotation(0)
			$AnimatedSprite2D.play("crash")
		else:
			$AnimatedSprite2D.stop()
		
func flap():
	velocity.y = FLAP_SPEED
	
func crash():
	crashed = true
