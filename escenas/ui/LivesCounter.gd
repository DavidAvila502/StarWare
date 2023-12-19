class_name Livescounter
extends MarginContainer
#var P1_lives = 0
#var P2_lives = 0
var box3_icon = preload("res://escenas/ui/Items_icons/box3/box3_icon.tscn")
var box_infinite_icon = preload("res://escenas/ui/Items_icons/box_infinite/box_infinite_icon.tscn")
var p1_array_icons = []
var p1_array_positions = [Vector2(-65,35),Vector2(-101,35),]
var p2_array_icons = []
var p2_array_positions = [Vector2(75,35),Vector2(111,35),]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func set_initial_lives_counter(p1_lives,p2_lives):
	$HBoxContainer/p1/Lives.text = str('x',p1_lives)
	$HBoxContainer/p2/Lives.text = str('x',p2_lives)

func update_lives_counter_p1(lives):
	$HBoxContainer/p1/Lives.text = str('x',lives)
	$HBoxContainer/p1/AnimatedSprite2D.play("hit")
	await  $HBoxContainer/p1/AnimatedSprite2D.animation_finished
	

func update_lives_counter_p2(lives):
	$HBoxContainer/p2/Lives.text = str('x',lives)
	$HBoxContainer/p2/AnimatedSprite2D.play("hit")
	await $HBoxContainer/p2/AnimatedSprite2D.animation_finished
	

func update_shots_bar_p1(shots):
	match shots:
		10:
			$HBoxContainer/p1/AnimatedSprite2D2.play('10')
		9:
			$HBoxContainer/p1/AnimatedSprite2D2.play('9')
		8:
			$HBoxContainer/p1/AnimatedSprite2D2.play('8')
		7:
			$HBoxContainer/p1/AnimatedSprite2D2.play('7')
		6:
			$HBoxContainer/p1/AnimatedSprite2D2.play('6')
		5:
			$HBoxContainer/p1/AnimatedSprite2D2.play('5')
		4:
			$HBoxContainer/p1/AnimatedSprite2D2.play('4')
		3:
			$HBoxContainer/p1/AnimatedSprite2D2.play('3')
		2:
			$HBoxContainer/p1/AnimatedSprite2D2.play('2')
		1:
			$HBoxContainer/p1/AnimatedSprite2D2.play('1')
		0:
			$HBoxContainer/p1/AnimatedSprite2D2.play('0')

func update_shots_bar_p2(shots):
	match shots:
		10:
			$HBoxContainer/p2/AnimatedSprite2D2.play('10')
		9:
			$HBoxContainer/p2/AnimatedSprite2D2.play('9')
		8:
			$HBoxContainer/p2/AnimatedSprite2D2.play('8')
		7:
			$HBoxContainer/p2/AnimatedSprite2D2.play('7')
		6:
			$HBoxContainer/p2/AnimatedSprite2D2.play('6')
		5:
			$HBoxContainer/p2/AnimatedSprite2D2.play('5')
		4:
			$HBoxContainer/p2/AnimatedSprite2D2.play('4')
		3:
			$HBoxContainer/p2/AnimatedSprite2D2.play('3')
		2:
			$HBoxContainer/p2/AnimatedSprite2D2.play('2')
		1:
			$HBoxContainer/p2/AnimatedSprite2D2.play('1')
		0:
			$HBoxContainer/p2/AnimatedSprite2D2.play('0')



func add_box3_icon_P1():
	#Comprobamos si existe el icono el la barra
	if  $HBoxContainer/p1.has_node('box_x3'):
		return
	#creamos una instancia del icono
	var box3Icon = box3_icon.instantiate()
	#Agregamos nombre al icono
	box3Icon.name = 'box_x3'
	#Agregamos el icono como hijo de p1
	$HBoxContainer/p1.add_child(box3Icon)
	#modificamos la escala
	box3Icon.scale = Vector2(0.6,0.6)
	#Agregamos el nombre del icono al array
	p1_array_icons.append('box_x3')
	#Actualizamos su posicion el la barra de items
	#box3Icon.position =  Vector2(-65,35)
	_update_items_bar_positions_p1()
	
	

func delete_box3_icon_P1():
	$HBoxContainer/p1/box_x3.queue_free()
	p1_array_icons.erase('box_x3')
	_update_items_bar_positions_p1()
	

func add_box3_icon_P2():
	#Comprobamos si existe el icono el la barra
	if  $HBoxContainer/p2.has_node('box_x3'):
		return
	#creamos una instancia del icono
	var box3Icon = box3_icon.instantiate()
	#Agregamos nombre al icono
	box3Icon.name = 'box_x3'
	#Agregamos el icono como hijo de p1
	$HBoxContainer/p2.add_child(box3Icon)
	#modificamos la escala
	box3Icon.scale = Vector2(0.6,0.6)
	#Agregamos el nombre del icono al array
	p2_array_icons.append('box_x3')
	#Actualizamos su posicion el la barra de items
	#box3Icon.position =  Vector2(-65,35)
	_update_items_bar_positions_p2()

func delete_box3_icon_P2():
	$HBoxContainer/p2/box_x3.queue_free()
	p2_array_icons.erase('box_x3')
	_update_items_bar_positions_p2()


func add_box_infinite_P1():
		#Comprobamos si existe el icono el la barra
	if  $HBoxContainer/p1.has_node('box_infinite'):
		return
	#creamos una instancia del icono
	var box_infinite_ = box_infinite_icon.instantiate()
	#Agregamos nombre al icono
	box_infinite_.name = 'box_infinite'
	#Agregamos el icono como hijo de p1
	$HBoxContainer/p1.add_child(box_infinite_)
	#modificamos la escala
	#box_infinite_.scale = Vector2(0.6,0.6)
	#Agregamos el nombre del icono al array
	p1_array_icons.append('box_infinite')
	#Actualizamos su posicion el la barra de items
	#box3Icon.position =  Vector2(-65,35)
	_update_items_bar_positions_p1()


func delete_box_infinite_icon_P1():
	$HBoxContainer/p1/box_infinite.queue_free()
	p1_array_icons.erase('box_infinite')
	_update_items_bar_positions_p1()


func add_box_infinite_P2():
		#Comprobamos si existe el icono el la barra
	if  $HBoxContainer/p2.has_node('box_infinite'):
		return
	#creamos una instancia del icono
	var box_infinite_ = box_infinite_icon.instantiate()
	#Agregamos nombre al icono
	box_infinite_.name = 'box_infinite'
	#Agregamos el icono como hijo de p2
	$HBoxContainer/p2.add_child(box_infinite_)
	#modificamos la escala
	#box_infinite_.scale = Vector2(0.6,0.6)
	#Agregamos el nombre del icono al array
	p2_array_icons.append('box_infinite')
	#Actualizamos su posicion el la barra de items
	#box3Icon.position =  Vector2(-65,35)
	_update_items_bar_positions_p2()

func delete_box_infinite_icon_P2():
	$HBoxContainer/p2/box_infinite.queue_free()
	p2_array_icons.erase('box_infinite')
	_update_items_bar_positions_p2()



func _update_items_bar_positions_p1():
	for i in range(len(p1_array_icons)):
		var current_icon = p1_array_icons[i]
		var current_icon_node = $HBoxContainer/p1.get_node(current_icon)
		current_icon_node.position = p1_array_positions[i]



func _update_items_bar_positions_p2():
	for i in range(len(p2_array_icons)):
		var current_icon = p2_array_icons[i]
		var current_icon_node = $HBoxContainer/p2.get_node(current_icon)
		current_icon_node.position = p2_array_positions[i]
	
