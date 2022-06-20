extends CanvasLayer

signal iniciar_juego
var defaultColor
const redColor = Color(250, 10, 10, 255)

func _ready():
	defaultColor = $Mensaje.get_color("font_color")
	$ScoreLabel.visible = false
	toggle_buttons(true)
	toggle_images("inicio")

func mostrar_mensaje(texto, timed = true):
	$Titulo.hide()
	$Mensaje.text = texto
	$Mensaje.show()
	if timed:
		$MensajeTimer.start()
	
func game_over(var win):
	$Mensaje.add_color_override("font_color", redColor)
	var mensaje = "GAME OVER"
	if win:
		mensaje = "GANASTE!"
	mostrar_mensaje(mensaje)
	yield($MensajeTimer, "timeout")
	$Mensaje.add_color_override("font_color", defaultColor)
	toggle_buttons(true)
	$Titulo.show()
	
func update_score(puntos):
	$ScoreLabel.text = str(puntos)
	
func toggle_buttons(var show, var untoggle_volver = false):
	if show:
		$BotonJugar.show()
		$BotonAyuda.show()
		$BotonCreditos.show()
		$BotonVolver.hide()
	else:
		$BotonJugar.hide()
		$BotonAyuda.hide()
		$BotonCreditos.hide()
		if untoggle_volver:
			$BotonVolver.show()

func toggle_images(var image):
	if image == "ayuda":
		$Ayuda.show()
		$Creditos.hide()
	elif image == "creditos":
		$Creditos.show()
		$Ayuda.hide()
	else:
		$Creditos.hide()
		$Ayuda.hide()

func _on_MensajeTimer_timeout():
	$Mensaje.hide()

func _on_BotonJugar_pressed():
	toggle_buttons(false)
	emit_signal("iniciar_juego")
	$ScoreLabel.visible = true

func _on_BotonCreditos_pressed():
	toggle_buttons(false, true)
	toggle_images("creditos")

func _on_BotonAyuda_pressed():
	toggle_buttons(false, true)
	toggle_images("ayuda")

func _on_BotonVolver_pressed():
	toggle_buttons(true)
	toggle_images("inicio")
