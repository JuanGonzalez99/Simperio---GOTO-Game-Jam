extends Area2D

export (int) var velocidad
signal golpe
signal get_estrella
signal dar_estrella
var Movimiento = Vector2()
var paso = 1
var limite
var hasStar

# Called when the node enters the scene tree for the first time.
func _ready():
	hide() # Ocultar el Player
	$Estrella.visible = false
	limite = get_viewport_rect().size
	hasStar = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Movimiento = Vector2()
	
	if Input.is_action_pressed("ui_right"):
		Movimiento.x += paso
	if Input.is_action_pressed("ui_left"):
		Movimiento.x -= paso
	if Input.is_action_pressed("ui_up"):
		Movimiento.y -= paso
	if Input.is_action_pressed("ui_down"):
		Movimiento.y += paso
	
	if Movimiento.length() > 0: # Verificar si se está moviendo
		Movimiento = Movimiento.normalized() * velocidad # Normalizar la velocidad
		$Sparkle.emitting = true
	else:
		$Sparkle.emitting = false
	
	position += Movimiento * delta
	position.x = clamp(position.x, 0, limite.x)
	position.y = clamp(position.y, 0, limite.y)
	
	if Movimiento.x > 0:
		$AnimatedSprite.animation = "derecha"
	elif Movimiento.x < 0:
		$AnimatedSprite.animation = "izquierda"
	elif Movimiento.y < 0:
		$AnimatedSprite.animation = "espalda"
	elif Movimiento.y > 0:
		$AnimatedSprite.animation = "frente"
	else:
		$AnimatedSprite.animation = "parado"
	
	$Estrella.visible = hasStar
		

func inicio(pos):
	position = pos
	show() # Mostrar el Player
	$CollisionShape2D.disabled = false
	rescale(1)
	hasStar = false
	
func fin():
	hide()
	$CollisionShape2D.disabled = true
	
func rescale(resize):
	self.scale.x = resize
	self.scale.y = resize
	$CollisionShape2D.scale.x = resize
	$CollisionShape2D.scale.y = resize

# Cuando el Player tenga una colision con un cuerpo
func _on_Player_body_entered(body):
	if body.tipo == "bueno":
		if !hasStar:
			emit_signal("get_estrella")
			self.hasStar = true
	else:
		fin()
		emit_signal("golpe")

func _on_Player_area_entered(area):
	if "Ally" in area.name && !area.move:
		if self.hasStar:
			emit_signal("dar_estrella")
			area.move = true
			self.hasStar = false
			rescale(self.scale.x + 0.2)
