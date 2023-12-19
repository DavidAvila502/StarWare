class_name box_x3
extends Area2D
var speed = 200.0
var velocity = Vector2()
var isApears = false
var isUp = false
signal destroy_item

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if isApears == false:
		appears()
		return
	
	velocity.y = speed * delta
	translate(velocity)

# Destruir item al salir de la ventana
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func appears():
	$AnimatedSprite2D.play("portal")
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("default")
	isApears = true
	

func _up():
	Global.sound_item()
	speed = -200.0
	isUp = true
	$AnimatedSprite2D.play("destroy")
	await $AnimatedSprite2D.animation_finished
	queue_free()
	
func _on_area_entered(area):
	if area.has_method('get_area_type') and (area.get_area_type() == 'shot' or area.get_area_type() == 'power_shot') and isApears and isUp == false:
		area.queue_free()
		emit_signal("destroy_item",'box_x3',area.direction)
		_up()
	
