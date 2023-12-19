extends Node2D
@onready var selector1 = $green_selector_p1
@onready var selector2 = $green_selector_p2
@onready var ready_timer = $Timer
var array_ships = ['yellow_beetle','bumblebee','green_shadow']

#Player 1
var tween_p1
var selected_character_p1
var counter_p1 = 0
var min_height_p1 = 168
var max_height_p1 = 160
var is_ready_p1 = false

#Player 2
var tween_p2
var selected_character_p2
var counter_p2 = 0
var min_height_p2 = 168
var max_height_p2 = 160
var is_ready_p2 = false

# Called when the node enters the scene tree for the first time.

func _ready():
	$"3-2-1".visible = false
	#Conectar señales para los controles
	$entry_controller_p1.connect('change_right',on_change_ship_p1_right)
	$entry_controller_p1.connect('change_left',on_change_ship_p1_left)
	$entry_controller_p1.connect('get_ready',on_get_ready_p1)
	$entry_controller_p2.connect('change_right',on_change_ship_p2_right)
	$entry_controller_p2.connect('change_left',on_change_ship_p2_left)
	$entry_controller_p2.connect('get_ready',on_get_ready_p2)
	# Instanciamos las naves y configuramos selectores
	instantiate_ship_p1()
	instantiate_ship_p2()
	selector2.set_player(1)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$ParallaxBackground/far_mountains.motion_offset -= (Vector2(50,0)) * delta
	$ParallaxBackground/near_mountains.motion_offset -= (Vector2(100,0)) * delta
	
func _on_timer_timeout():
	get_tree().change_scene_to_file('res://escenas/world_selector/world_selector.tscn')

func start_counter_animation():
	$"3-2-1".visible = true
	$"3-2-1".play('default')
	await $"3-2-1".animation_finished
	$"3-2-1".visible = false

func cancel_counter_animation():
	$"3-2-1".stop()
	$"3-2-1".visible = false
	

############### Logica del player 1 #######################
#Connectar animacion de levitacion (comenzará al conectar)
func connect_levitate_animation_p1():
	tween_p1 = create_tween().set_loops()
	tween_p1.tween_property($".".get_node('selected_character_p1'),'position:y',max_height_p1,0.4)
	tween_p1.tween_property($".".get_node('selected_character_p1'),'position:y',min_height_p1,0.4)
	

func on_change_ship_p1_left():
	cancel_ready_p1()
	
	if counter_p1 == 0:
		counter_p1 = len(array_ships) -1
	else:
		counter_p1 -= 1
	
	$green_selector_p1.play_transition()
	instantiate_ship_p1()


func on_change_ship_p1_right():
	cancel_ready_p1()

	if counter_p1 == len(array_ships) -1:
		counter_p1 = 0
	else:
		counter_p1 += 1
		
	$green_selector_p1.play_transition()
	instantiate_ship_p1()

func on_get_ready_p1():
	if is_ready_p1 == true:
		cancel_ready_p1()
	else:
		is_ready_p1 = true
		$green_selector_p1.get_ready()
		$green_selector_p1.play_infinite_transition()
		tween_p1.pause()
		
	if is_ready_p1 == true and is_ready_p2 ==  true:
		ready_timer.start()
		start_counter_animation()

# Destruye y agrega una nueva nave en el selecor del player 1
func instantiate_ship_p1():
	if $".".has_node('selected_character_p1'):
		tween_p1.pause()
		$".".remove_child($".".get_node('selected_character_p1'))
	var ship_directory = "res://escenas/ships/" + array_ships[counter_p1] + '/' + array_ships[counter_p1]+'.tscn' 
	var loaded_ship = load(ship_directory)
	var new_ship =  loaded_ship.instantiate()
	Global.selected_character_p1 = ship_directory
	new_ship.name = 'selected_character_p1'
	new_ship.scale = Vector2(1.4,1.4) 
	new_ship.position = Vector2(160,168)
	new_ship.rotation = -95.81
	$".".add_child(new_ship)
	connect_levitate_animation_p1()
	
	
# continua el efecto de levitacion
func resume_levitate_animation_p1():
	tween_p1.play()

func cancel_ready_p1():
	is_ready_p1 = false
	$Timer.stop()
	$green_selector_p1.play_default()
	$green_selector_p1.cancel_ready()
	resume_levitate_animation_p1()
	cancel_counter_animation()
	
############### Logica del player 2 #######################
#Connectar animacion de levitacion (comenzará al conectar)
func connect_levitate_animation_p2():
	tween_p2 = create_tween().set_loops()
	tween_p2.tween_property($".".get_node('selected_character_p2'),'position:y',max_height_p2,0.4)
	tween_p2.tween_property($".".get_node('selected_character_p2'),'position:y',min_height_p2,0.4)

func on_change_ship_p2_left():
	cancel_ready_p2()
	
	if counter_p2 == 0:
		counter_p2 = len(array_ships) -1
	else:
		counter_p2 -= 1
	
	$green_selector_p2.play_transition()
	instantiate_ship_p2()


func on_change_ship_p2_right():
	cancel_ready_p2()
	
	if counter_p2 == len(array_ships) -1:
		counter_p2 = 0
	else:
		counter_p2 += 1
		
	$green_selector_p2.play_transition()
	instantiate_ship_p2()

func on_get_ready_p2():
	if is_ready_p2 == true:
		cancel_ready_p2()
		
	else:
		is_ready_p2 = true
		$green_selector_p2.play_infinite_transition()
		tween_p2.pause()
		$green_selector_p2.get_ready()
		
		
	if is_ready_p2 == true and is_ready_p1 ==  true:
		ready_timer.start()
		start_counter_animation()

# Destruye y agrega una nueva nave en el selecor del player 1
func instantiate_ship_p2():
	if $".".has_node('selected_character_p2'):
		tween_p2.pause()
		$".".remove_child($".".get_node('selected_character_p2'))
	
	var ship_directory ="res://escenas/ships/" + array_ships[counter_p2] + '/' + array_ships[counter_p2]+'.tscn' 
	var loaded_ship = load(ship_directory)
	var new_ship =  loaded_ship.instantiate()
	Global.selected_character_p2 = ship_directory
	new_ship.name = 'selected_character_p2'
	new_ship.scale = Vector2(1.4,1.4) 
	new_ship.position = Vector2(416,168)
	new_ship.rotation = -95.81
	$".".add_child(new_ship)
	connect_levitate_animation_p2()


func resume_levitate_animation_p2():
	tween_p2.play()

func cancel_ready_p2():
	is_ready_p2 = false
	$Timer.stop()
	$green_selector_p2.play_default()
	$green_selector_p2.cancel_ready()
	resume_levitate_animation_p2()
	cancel_counter_animation()
