extends KinematicBody2D

enum STATE {
	STANDING = 0,
	WALKING = 1,
	RUNNING = 2,
	SWIMMING = 3,
	ATTACKING = 4
}
enum DIRECTION {
	DOWN = 0,
	UP = 1,
	LEFT = 2,
	RIGHT = 3
}
enum ITEM {
	NOTHING = -1,
	KNIFE = 0
}

const states = ["stand", "walking", "running", "swimming", "attacking"]
const directions = ["down", "up", "left", "right"]
const items = ["knife"]
const damages = {
	ITEM.NOTHING: 0,
	ITEM.KNIFE: 5
}

export var speed = 50.0

var state
var direction
var item_in_hand

var raycast_to = Vector2()
var velocity = Vector2()

var hp
var dmg
var swimming: bool

var flashlight = false

var map: TileMap

signal hp_signal
signal move_rock
signal destroy_web
signal position_signal
signal set_item_in_hotbar

func _ready():
	state = STATE.STANDING
	direction = DIRECTION.DOWN
	item_in_hand = ITEM.NOTHING
	hp = 100
	dmg = 0

func _physics_process(delta):
	velocity = Vector2()
	if Input.is_action_just_pressed("attack") and item_in_hand == ITEM.KNIFE:
		state = STATE.ATTACKING
	if "attacking" in $AnimatedSprite.animation:
		if not $AnimatedSprite.frame == 1:
			$Timer.start(.5)
	if state != STATE.ATTACKING:
		velocity = movement()
		var _collision = move_and_collide(velocity.normalized()*speed*delta)
	emit_signal("position_signal", self.position)

func _process(_delta):
	var object: Node
	
	check_swim()
	$RayCast2D.cast_to = raycast_to
	control_animation()
	
	if $RayCast2D.is_colliding():
		object = $RayCast2D.get_collider()
	if object and "Rock" in object.name and Input.is_action_pressed("rock_moving"):
		emit_signal("move_rock", velocity, object.get_name())
	if object and "Web" in object.name and Input.is_action_pressed("web_destroyer"):
		emit_signal("destroy_web", object.name)
	
	if Input.is_action_just_pressed("flashlight"):
		flashlight = !flashlight
	
	$Flashlight.enabled = flashlight
	
	hp = min(100, hp)
	hp = max(0, hp)
	dmg = damages[item_in_hand]
	
	emit_signal("hp_signal", hp)
	
	if hp == 0:
		var _unused = get_tree().change_scene("res://scenes/GameOver.tscn")

func movement():
	velocity = Vector2()
	var moving = false
	raycast_to = Vector2()
	
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		state = STATE.WALKING if state == STATE.STANDING else state
		direction = DIRECTION.UP
		moving = true
		raycast_to.y -= 50
	
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
		state = STATE.WALKING if state == STATE.STANDING else state
		direction = DIRECTION.DOWN
		moving = true
		raycast_to.y += 50
	
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		state = STATE.WALKING if state == STATE.STANDING else state
		direction = DIRECTION.LEFT
		moving = true
		raycast_to.x -= 50
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		state = STATE.WALKING if state == STATE.STANDING else state
		direction = DIRECTION.RIGHT
		moving = true
		raycast_to.x += 50
	
	if not moving:
		state = STATE.STANDING
	
	if Input.is_action_just_pressed("sprint"):
		speed *= 1.5
	if Input.is_action_just_released("sprint"):
		speed /= 1.5
	if Input.is_action_pressed("sprint"):
		state = STATE.RUNNING if state == STATE.WALKING else state
	
	return velocity

func control_animation():
	if state == STATE.SWIMMING:
		$AnimatedSprite.play("%s_%s" % [states[state], directions[direction]])
	elif state == STATE.ATTACKING:
		$AnimatedSprite.play("%s_%s" % [states[state], directions[direction]])
	elif item_in_hand == ITEM.NOTHING:
		$AnimatedSprite.play("%s_%s" % [states[state], directions[direction]])
	elif item_in_hand != ITEM.NOTHING:
		$AnimatedSprite.play("%s_%s_%s" % [states[state], directions[direction], items[item_in_hand]])

func check_swim():
	if swimming:
		state = STATE.SWIMMING

func _on_Area2D2_body_entered(body):
	if body == self:
		swimming = true
		state = STATE.SWIMMING


func _on_Area2D2_body_exited(body):
	if body == self:
		swimming = false
		state = STATE.WALKING


func _on_Timer_timeout() -> void:
	state = STATE.STANDING
