class PocionMagica {
	var property ingredientes = []
	
	method ingerir(persona) {
		ingredientes.forEach({i => i.efecto(persona, self)})
	}
}

// Ingredientes
class DDL {
	method efecto(persona, posion){
 		persona.aumentarFuerza(10)
 		if(persona.fueraDeCombate()) {
 			persona.aumentarResistencia(2)
 		}
 	}
 }
 
class HongosSilvestres {
 	var cantidad
 	method efecto(persona, posion) {
 		persona.aumentarFuerza(cantidad)
 		if(cantidad > 5) {
 			persona.recibirDanio(persona.resistencia()/2)
 		}
	}
}
 
class Grog {
 	method efecto(persona, posion) {
 		persona.aumentarFuerza(posion.ingredientes().size())
	}
}

class GrogXD inherits Grog {
	override method efecto(persona, posion) {
		super(persona, posion)
 		persona.aumentarResistencia(persona.resistencia()*2)
	}
}

class Persona {
	var property fuerza
	var property resistencia
	
	method recibirDanio(danio) {
		resistencia = 0.max(resistencia - danio)
	}
	
	method aumentarResistencia(aumento) {
		resistencia += aumento
	}
	
	method aumentarFuerza(aumento) {
		fuerza += aumento
	}
	
	method poder() {
		return fuerza * resistencia
	}
	
	method tomarPosion(posion) {
		posion.ingerir(self)
	}
	
	method fueraDeCombate() {
		return resistencia == 0 
	}
}


class Ejercito {
	var integrantes
	
	method poder() {
		return integrantes.sum({i => i.poder()})
	}
	
	method recibirDanio(danio){
		const masPoderosos = integrantes.sortedBy({p1,p2 => p1.poder() > p2.poder()})
		// masPoderosos trim primeros 10
		masPoderosos.forEach({p => p.recibirDanio(danio/10)})
	}
	
	method fueraDeCombate() {
		return integrantes.all({i => i.fueraDeCombate()})
	}
	
	method pelearContra(enemigo){
		if(!self.fueraDeCombate()) {
			const diferenciaPoder = self.poder() - enemigo.poder()
			const menosPoderoso = [self, enemigo].sortedBy({p1, p2 => p1.poder() > p2.poder()})
			menosPoderoso.last().recibirDanio(diferenciaPoder)		
		}
	}
}

 // Formaciones
 class Tortuga {
 	method poder() = 0
	method danio() = 0
 }

class EnCuadro {
	var property cantidadDelanteros
	method poder() = 1
	method danio() = 1
}

class FrontemAllargate {
	method poder() = 1.10
	method danio() = 2
}


class Legion inherits Ejercito {
	var formacion
	var minimoPoder
	
	override method poder() {
		return super() * formacion.poder()
	}
	
	override method recibirDanio(danio){
		const cantDanio = danio * formacion.danio()
		super(cantDanio)
		if(self.poder() < minimoPoder) {
			formacion = new Tortuga()
		}
	}
}

// 6. creación de una legión con formación en cuadro que manda 20 guerreros adelante.
// var legionEjemplo = new Legion(formacion = new EnCuadro(cantidadDelanteros=20), minimoPoder = 100, integrantes = [])









