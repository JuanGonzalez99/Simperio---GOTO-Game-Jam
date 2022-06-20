extends Node

export (PackedScene) var Enemigo
export (PackedScene) var Ally
var Score
const alliesLimit = 4
var allies = []
var won = false

func _ready():
	randomize()

func nuevo_juego():
	if allies.size() > 0:		
		for ally in allies:
			ally.queue_free()
		allies.clear()
		
	won = false
	Score = 0
	$Player.inicio($PosicionInicial.position)
	$InicioTimer.start()
	$Interfaz.mostrar_mensaje("Listo!")
	$Interfaz.update_score(Score)
	$Musica.play()

func _process(_delta):
	if !won and allies.size() > 0:
		var last_ally = allies.back()
		if last_ally != null and last_ally.llego:
			if allies.size() == alliesLimit:
				game_over(true)
			elif $AllyTimer.is_stopped():
				$AllyTimer.start()

func game_over(var win = false):
	$Player/CollisionShape2D.disabled = true
	$ScoreTimer.stop()
	$EnemyTimer.stop()
	$Musica.stop()
	$Interfaz.game_over(win)
	if win:
		$AudioCompletado.play()
		$Player.fin()
	else:
		$AudioGameOver.play()
		for ally in allies:
			ally.queue_free()
		allies.clear()
	won = win

func _on_InicioTimer_timeout():
	$EnemyTimer.start()
	$ScoreTimer.start()
	$AllyTimer.start()

func _on_ScoreTimer_timeout():
	Score += 1
	$Interfaz.update_score(Score)

func _on_EnemyTimer_timeout():
	# Seleccionar un punto aleatorio en el camino
	$Camino/EnemyPosition.set_offset(randi())
	
	var enemy = Enemigo.instance()
	add_child(enemy)
	
	var direccion = $Camino/EnemyPosition.rotation + PI / 2
	
	enemy.position = $Camino/EnemyPosition.position
	
	direccion += rand_range(-PI/4, PI/4)
	enemy.rotation = direccion
	
	var vec = Vector2(rand_range(enemy.velocidad_min, enemy.velocidad_max), 0)
	enemy.set_linear_velocity(vec.rotated(direccion))

func _on_AllyTimer_timeout():
	var ally = Ally.instance()
	ally.inicio($PositionAlly.position)
	add_child(ally)
	allies.append(ally)

func _on_HSlider_value_changed(value):
	var volume = log(value) * 20
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume)
	
func _on_Player_get_estrella():
	$AudioGetEstrella.play()

func _on_Player_dar_estrella():
	$AudioDarEstrella.play()
