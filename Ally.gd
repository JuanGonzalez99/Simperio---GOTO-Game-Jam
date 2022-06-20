extends Area2D

export (int) var velocidad
var Movimiento = Vector2()
var move = false
var llego = false

func inicio(pos):
	$Sprite.animation = "default"
	position = pos
	show()
	
func _process(delta):
	if llego:
		pass
		
	Movimiento = Vector2()
	if move:
		Movimiento.x -= 1
		$Sprite.animation = "lado"
	else:
		Movimiento.x = 0
		$Sprite.animation = "default"
	
	if Movimiento.length() > 0: # Verificar si se está moviendo
		Movimiento = Movimiento.normalized() * velocidad
		self.position += Movimiento * delta

func _on_Visibility_screen_exited():
	queue_free()

func _on_Ally_area_entered(area):
	if area.name != "Player":
		move = false
		llego = true
