extends RigidBody2D

export (int) var velocidad_min
export (int) var velocidad_max
var tipo_enemigo = ["frente", "lado"]
var tipo_bueno = ["frenteB", "ladoB"]
var tipo

func _ready():
	tipo = "malo"
	if randi() % 6 >= 4:
		tipo = "bueno"
		
	if tipo == "malo":
		$AnimatedSprite.animation = tipo_enemigo[randi() % tipo_enemigo.size()]
	else:
		$AnimatedSprite.animation = tipo_bueno[randi() % tipo_bueno.size()]
	
	if $AnimatedSprite.animation == "lado":
		$CollisionShape2D.scale.y = 1
		$CollisionShape2D.position.x -= 25
	if $AnimatedSprite.animation == "ladoB":
		$CollisionShape2D.scale.y = 1
		$CollisionShape2D.position.x += 25

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
