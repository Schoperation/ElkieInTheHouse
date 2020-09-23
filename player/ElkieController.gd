extends Area2D

"""
Handles the controls for Elkie. 
"""

export var speed = 300

func _ready():
	pass # Replace with function body.


func _process(delta):
	var velocity = Vector2()
	
	# Detect keystrokes
	if Input.is_key_pressed(KEY_A):
		velocity.x -= 1
	if Input.is_key_pressed(KEY_D):
		velocity.x += 1
	if Input.is_key_pressed(KEY_W):
		velocity.y -= 1
	if Input.is_key_pressed(KEY_S):
		velocity.y += 1
		
	# Normalize and determine animation
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.animation = "walk"
	else:
		$AnimatedSprite.animation = "still"
		
	# Determine if flipping is necessary
	if velocity.x != 0:
		$AnimatedSprite.flip_h = velocity.x < 0
	
	# Set position of player
	position += velocity * delta
	position.x = clamp(position.x, 0, get_viewport_rect().size.x)
	position.y = clamp(position.y, 0, get_viewport_rect().size.y)
