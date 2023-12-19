class_name space_ship
extends CharacterBody2D
#Recursos cargados
#var normal_shot = preload("res://escenas/shoot/shoot.tscn")
#var poower_shot = preload("res://escenas/poower_shot/poower_shot.tscn")
var normal_shot
var poower_shot
#Variables
var SPEED = 300.0
var bodyType = 'ship'
var lives = 4
var shots = 10
var charge_level = 0
var charge = 0
var power =0
var items = []
var global_delta
#Señales
signal update_lives_counter
signal update_shots_bar
signal stop_reload_shots
signal stop_timers
signal die
#Banderas
var vulnerable = true
var isDiying = false
var right_direction = false



func _physics_process(delta):
	global_delta = delta
	
	#Anulamos toda accion si es que esta muriendo
	if isDiying:
		return 
	
	#Cambiams la animacion del personaje segun la carga
	if power == 2:
		$AnimatedSprite2D.play("charge_1")
	elif power ==3:
		$AnimatedSprite2D.play("charge_2")
	elif power == 4:
		$AnimatedSprite2D.play("charge_3")
	
	# Si sus vidas son inferiores a 1 entonces destruimos el personaje
	if lives < 1:
		_DestroyShip()


func _DestroyShip():
	isDiying = true
	Global.sound_destroy()
	emit_signal('die')
	emit_signal("stop_timers")
	$AnimatedSprite2D.play("destroy")
	await $AnimatedSprite2D.animation_finished
	queue_free()

# Esta funcion le da un golpe a nuestro personaje
func _GetShoot():
	if lives >= 1 and vulnerable:
		Global.sound_hit()
		lives -= 1
		emit_signal("update_lives_counter")
		vulnerable = false
		$AnimatedSprite2D.play("hit")
		await $AnimatedSprite2D.animation_finished
		$AnimatedSprite2D.play("idle")
		vulnerable = true
		$AnimatedSprite2D.play("idle")
		

func _oneShot():
	var centershot
	
	#Si hay poder acomulado entonces la bala será cargada
	if power >= 2:
		centershot = poower_shot.instantiate()
#		Agregamos el power al tiro cargado
		centershot.power = power
		
	#De cualquier otra forma sera una bala normal
	else:
		centershot = normal_shot.instantiate()
		reduce_shots(1,true)
	
	#invertimos la direccion del tiro si es que esta del lado derecho
	if right_direction:
		centershot.direction =-1
	
	get_parent().get_parent().add_child(centershot)
	centershot.position =$CentralMarker.global_position

	
	$AnimatedSprite2D.play("shot")
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("idle")
	

func _threeShot():
	var centershot
	var leftShot
	var rightShot
	
	#Si hay poder acomulado entonces las balas seran cargadas
	if power >= 2:
		centershot = poower_shot.instantiate()
		leftShot = poower_shot.instantiate()
		rightShot = poower_shot.instantiate()
		#	Agregamos el power al tiro cargado
		centershot.power = power
		leftShot .power = power
		rightShot.power = power
		
	#De cualquier otra forma seran  balas normales
	else:
		centershot = normal_shot.instantiate()
		leftShot = normal_shot.instantiate()
		rightShot = normal_shot.instantiate()
		reduce_shots(1,true)
	
	#invertimos la direccion del tiro si es que esta del lado derecho
	if right_direction:
		centershot.direction =-1
		leftShot.direction =-1
		rightShot.direction =-1

	
	get_parent().get_parent().add_child(centershot)
	centershot.position =$CentralMarker.global_position
	
	
	get_parent().get_parent().add_child(leftShot)
	leftShot.position =$LeftMarker.global_position
	
	
	get_parent().get_parent().add_child(rightShot)
	rightShot.position =$RightMarker.global_position

	
	$AnimatedSprite2D.play("shot")
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("idle")


func reduce_shots(shots_num,reload_shot):
	if not items.has('box_infinite'):
		shots -= shots_num
		emit_signal('update_shots_bar',reload_shot)


func get_body_type():
	return bodyType


func move(direction):
	if direction:
		velocity.y = direction * SPEED
	else:
		velocity.y = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()


func start_charge_shot():
	if shots > 0:
		emit_signal('stop_reload_shots') #Detenemos timers de recarga de balas
		charge += global_delta # acomulamos carga
		#Acomula 1 nivel de carga cada segundo y actualiza la barra de balas
		if charge >= 1:
			charge_level +=1 #Acomulamos nivel de carga 
			if charge_level >= 1 and charge_level < 2 and shots >= 2:
				power +=2
				reduce_shots(2,false)#Reducimos las balas en 2 sin activar la recarga de esa bala
				
			if charge_level >= 2 and charge_level < 3 and power ==2 and shots >=1:
				power +=1
				reduce_shots(1,false)
			
			if charge_level >= 3 and charge_level < 4 and power ==3 and shots >=1:
				power +=1
				reduce_shots(1,false)
				
			
			charge = 0 # La carga se reduce a 0 al acomular +1 de charge_level


func shoot():
		#Emitir sonido global de disparo
		if shots >0 or power >=2:
			Global.sound_shoot()
			pass
		#Disparar 3 tiros si es posible
		if items.has('box_x3') and shots > 0 or items.has('box_3') and power >=2:
			_threeShot()
		#Disparar 1 tiro si es posible
		elif shots > 0 or power >=2:
			_oneShot()
			
		#Reestablecer los niveles de poder y carga
		charge_level = 0
		power = 0
		charge = 0
		#Activamos la recarga de las balas
		emit_signal('update_shots_bar',true)


func flip_character():
	right_direction = true
	$CentralMarker.position = Vector2(-40,0)
	$LeftMarker.position = Vector2(-30,-16)
	$RightMarker.position = Vector2(-30,16)
	$AnimatedSprite2D.flip_v = true
		
		
