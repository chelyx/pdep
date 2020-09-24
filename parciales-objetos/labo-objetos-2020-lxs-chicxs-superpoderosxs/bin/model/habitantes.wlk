import casa.*

object azucena {
	var property id = 1	
	var property saludar = "¡Ay, qué miedo! Jaja"
	method leGusta(disfraz) {
		return disfraz.ternura() > 6 && disfraz.terror() < 4 
	}
	
	method darCaramelos(disfraz) {
		if (self.leGusta(disfraz)) {
			return disfraz.ternura()
		} else {
			return 5
		}
	}
}

object sandra {
	var property id = 3
	method saludar() {
		if (casa.estaEnOrden() ){
			return "¡Pasalo lindo y no hagas lío!"	
		} else {
			return "¬¬"
		}
	}
	
	method leGusta(disfraz) {
		return disfraz.ternura() > disfraz.terror()		
	}

	method darCaramelos(disfraz) {
		if (casa.estaEnOrden()) {
			return 8
		} else {
			return 2
		}
	}
}

object jorge {
	var property id = 2
	var property saludar = "¡Feliz Navidad!"

	method leGusta(disfraz) {
		return disfraz.terror()	>= 8
	}

	method darCaramelos(disfraz) {
		if (casa.caramelos() >= 50) {
			return 10
		} else {
			return 4
		}
	}
}