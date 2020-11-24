// pelotas
class Quaffle {
	method laUsan() = 'cazadores'
	method cantidad() = 1
	// suma 10 meterla en el aro
	//El guardián debe proteger los aros y evitar que le metan un gol.
}

class Bludger {
	method cantidad() = 2
	//batear apuntando hacia un jugador del otro equipo y los más grosos hasta pueden evitar goles desviando la quaffle
}

class Snitch {
	// buscador es el encargado de buscar la snitch y atraparla
}

// escobas
class Nimbus {
	const anioFabricacion
	var porcentajeSalud
	
	method velocidad() {
		return (80-anioFabricacion)*porcentajeSalud
	}
}

class SaetaFuego {
	method velocidad() = 100
}

// posiciones
class Cazador {
	var property tieneQuaffle = false

	method habilidad(jugador) {
		return jugador.velocidad() + jugador.skills() + jugador.punteria() * jugador.fuerza()
	}
	
	method jugarTurno(jugador, equipoContrario) {
		if(tieneQuaffle) {
			if (equipoContrario.puedeBloquearTiro()) {
				jugador.perderSkills(2)
				const jugadorBloqueo = equipoContrario.quienPuedeBloquear()
				jugadorBloqueo.mejorarSkills(10)
			}else {
				jugador.ganarPuntos(10)
				jugador.mejorarSkills(5)
			}
			self.perderQuaffle(equipoContrario)
		}
	}
	
	method perderQuaffle(equipoContrario){
		tieneQuaffle = false
		equipoContrario.cazadorMasRapido().posicion(new Cazador(tieneQuaffle = true))
	}
}

class Guardian {
	method habilidad(jugador) {
		return jugador.velocidad() + jugador.skills() + jugador.reflejos() + jugador.fuerza()
	}
}

class Golpeador {
	method habilidad(jugador) {
		return jugador.velocidad() + jugador.skills() + jugador.punteria() + jugador.fuerza()
	}
}

class Buscador {
	method habilidad(jugador) {
		return jugador.velocidad() + jugador.skills() + jugador.reflejos() * jugador.vision()
	}
}

class Jugador {
	var property skills
	var peso
	var escoba
	var property punteria
	var property fuerza
	var property reflejos
	var property vision
	var property posicion
	var equipo
	var valorMercadoEscoba

	method manejoEscoba() {
		return skills / peso
	}
	
	method velocidad() {
		return escoba.velocidad() * self.manejoEscoba()
	}
	
	method habilidad() {
		return posicion.habilidad()
	}
	
	method lePasaElTrapoA(otroJugador) {
		return self.habilidad() > 2 * otroJugador.habilidad()
	}
	
	method esGroso() {
		return self.habilidad() > equipo.promedioHabilidad() && self.velocidad() > valorMercadoEscoba
	}
	
	method ganarPuntos(p) {
		equipo.ganarPuntos(p)
	}
	
	method mejorarSkills(mejora) {
		skills += mejora
	}
	
	method perderSkills(perdida) {
		skills -= perdida
	}
}

class Equipo {
	var property jugadores = []
	var puntos
	
	method promedioHabilidad() {
		return jugadores.sum({j => j.habilidad()}) / jugadores.size()
	}
	
	method jugadorEstrellaContra(otroEquipo) {
		return jugadores.any({jNuestro => otroEquipo.jugadores().all({jOtro => jNuestro.lePasaElTrapoA(jOtro)})})
	}
	
	method ganarPuntos(cuantos) {
		puntos += cuantos
	}
	
	method cazadorMasRapido() {
		
	}
	
	method bloquearTiro() {
		
	}
	
}





