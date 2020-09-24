import habitantes.*

object casa {
	var property caramelos = 100
	var property caos = 0
	var property quienAbreLaPuerta = azucena
	const habitantes = [azucena, jorge, sandra]
	
	method image() = "casa.png"
	
	method abrirleA(alguien) {
		alguien.visitarCasa()
	}
	
	method cerrarLaPuerta(){
		const idActual = quienAbreLaPuerta.id()
		if ( idActual == 1 && caramelos >= 5) { // id 1 azucena se come un caramelo
			caramelos -= 1
		} if (idActual == 2) { // id 2 jorge acomoda la casa
			caos -= 2
		} // sandra no hace nada
		var idNuevo = idActual + 1
		if(idNuevo > habitantes.size()){
			idNuevo = 1
		}
		quienAbreLaPuerta = habitantes.find({i => i.id() == idNuevo})
	}
	
	method saludo(){
		if (!self.seTerminoLaDiversion()) {
			return quienAbreLaPuerta.saludar()
		} else {
			return "¡Suficiente por hoy! Nos vamos a dormir."
		}
		
	}
	
	method recibirVisita(chico) {
		self.abrirleA(chico)
		self.saludo()
		self.cerrarLaPuerta()
	}
	
	method seTerminoLaDiversion() {
		return caramelos == 0 || caos > 20
	}
	
	method estaEnOrden() {
		return self.caos() < 3
	}
	
	// El saludador va a ser el juego cuando se corra el programa de esa forma.
	// Desde los tests puede ser lo que más nos sirva para validar el funcionamiento del programa :D
	method teVisita(alguien, saludador){
		self.abrirleA(alguien)
		saludador.say(self, self.saludo())
		self.cerrarLaPuerta()
	}
}