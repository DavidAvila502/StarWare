class_name power_shot
extends Area2D
var Speed = 700
var direction = 1
var velocity = Vector2()
var power = 2
var area_type = 'power_shot'

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if power == 3:
		Speed = 850
	if power == 4:
		Speed = 1000
		
	if direction == -1:
		$AnimatedSprite2D.flip_h = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	velocity.x = Speed * direction * delta
	translate(velocity)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body):
	if body.has_method('get_body_type') and body.get_body_type() == 'ship':
		body._GetShoot()
		queue_free()
	
func get_area_type():
	return area_type
