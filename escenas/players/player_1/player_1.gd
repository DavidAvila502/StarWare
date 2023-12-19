class_name player1
extends Node2D
signal update_p1_lives_counter
signal stop_timers
signal update_shots_bar_p1
signal stop_reload_shots_p1
signal p1_die

var selected_character  


func _ready():
	#instanciamos a nuestro personaje
	
	selected_character = load(Global.selected_character_p1)
	selected_character = selected_character.instantiate()
	selected_character.name = 'selected_character'
	add_child(selected_character)
	# Modificamos estadisticas de nuestro personaje
	#set_lives(3)
	#selected_character._GetShoot()
	
	
	#Conectamos nuestras señales a nuestro controlador de entrada
	
	#Señales de movimiento
	$entry_controller.connect('move_up',_on_move_up)
	$entry_controller.connect('move_down',_on_move_down)
	
	#Señales de carga y disparo
	$entry_controller.connect('start_charge',_on_start_charge)
	$entry_controller.connect('shoot',_on_shoot)
	
	#Señales para el world
	selected_character.connect('update_lives_counter',_on_update_lives_counter)
	selected_character.connect('update_shots_bar',_on_update_shots_bar)
	selected_character.connect('stop_reload_shots',_on_stop_reload_shots)
	selected_character.connect('stop_timers',_on_stop_timers)
	selected_character.connect('die',_on_die)
	
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
# Funciones de nuestras señales

##### Para mover y disparar 
func _on_move_up():
	selected_character.move(-1)

func _on_move_down():
	selected_character.move(1)

func _on_start_charge():
	selected_character.start_charge_shot()

func _on_shoot():
	selected_character.shoot()

###### Para gestionar los timers y comunicarse con el world
func _on_update_lives_counter():
	emit_signal('update_p1_lives_counter')

func _on_stop_timers():
	emit_signal('stop_timers',0)
	$entry_controller.queue_free()

func _on_update_shots_bar(reload_shot):
	emit_signal('update_shots_bar_p1',reload_shot)
	
func _on_stop_reload_shots():
	emit_signal('stop_reload_shots_p1')
	
func _on_die():
	emit_signal('p1_die')
	
######### Funciones para mutar las estadisticas del personaje
func get_lives():
	return selected_character.lives
	
func set_lives(lives):
	selected_character.lives = lives
	
func set_shots(shots):
	selected_character.shots = shots
	
func get_shots():
	return selected_character.shots
	
func add_shots(shots):
	selected_character.shots += shots
	
func add_item(item_name):
	if $".".has_node('selected_character') and not selected_character.items.has(item_name):
		selected_character.items.append(item_name)

func remove_item(item_name):
	if $".".has_node('selected_character') and selected_character.items.has(item_name):
		selected_character.items.erase(item_name)
