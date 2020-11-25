class Vikingo {
	var property peso
	var inteligencia
	var property hambre
	var property velocidad
	var property barbarosidad
	var item
	var danio
	
	method danioItem() = item.danio()
	
	method danio() {
		return self.danioItem() + danio
	}
	
	method aumentarHambre(incremento) {
		return hambre + incremento
	}
	
	// 1. astrid.esMejorPara(pesca, hipo)
	method esMejorPara(posta, otroVikingo){
		const ganador = posta.conocerGanador([self, otroVikingo])
		return ganador == self
	}
}

// Dragones

class Dragon {
	var velocidadBase = 60
	var peso
	var property inteligencia
	var requisitos = [peso]
	
	method agregarRequisito(r) {
		requisitos.add(r)
	}
}

class FuriaNocturna inherits Dragon{
	var property danio
	method velocidad() = velocidadBase * 3
}

class NaderMortifero inherits Dragon{
	method danio() = 150
}

class Gronckle inherits Dragon{
	method velocidad() = velocidadBase / 2
	method danio() = peso * 5
}

// requisitos
class Peso {
	var peso
	method cumple(vikingo){
		return vikingo.peso() < peso * 0.2
	}
}
class Barbarosidad {
	var minimo
	method cumple(vikingo) {
		return vikingo.barbarosidad() > minimo
	}
}

class Item {
	var item
	method cumple(vikingo) {
		return vikingo.item() == item	
	}
}

class Inteligencia {
	var inteligencia
	method cumple(vikingo){
		return vikingo.inteligencia() < inteligencia
	}
}

//Jinetes

class Jinete {
	
}




// competencias
class Competencia {
	var participantes = []
	var resultado = []

	method aumentarHambre(cant) {
		participantes.forEach({v => v.aumentarHambre(cant)})
	}
	
	method puedeParticipar(vikingo, hambreExtra) {
		return (vikingo.hambre() + hambreExtra) < 100
	}
	
	method agregarParticipante(vikingo) {
		participantes.add(vikingo)
	}
}


class Pesca inherits Competencia{
	method maximoKgPescado(vikingo) {
		return vikingo.peso() * 0.5 + vikingo.barbarosidad() * 2
	}
	
	method terminarComp() {
		self.aumentarHambre(5)
	}
	
	method deMejorAPeor() {
		return participantes.sortedBy({v1, v2 => self.maximoKgPescado(v1) > self.maximoKgPescado(v2)})
	}
	
	method conocerGanador() {
		return self.deMejorAPeor().first()
	}
	
	method inscribirVikingo(vikingo) {
		if(self.puedeParticipar(vikingo, 5)) {
			self.agregarParticipante(vikingo)
		}
	}
	method jugarPosta(vikingos) {
		vikingos.forEach({v => v.inscribirVikingo(v)})
		resultado = self.deMejorAPeor()
		self.terminarComp()
	}
}

class Combate inherits Competencia{
	method cuantoDanioCausa(vikingo) {
		return vikingo.barbarosidad() + vikingo.danioItem()
	}
	
	method terminarComp(){
		self.aumentarHambre(10)
	}

	method deMejorAPeor() {
		return participantes.sortedBy({v1, v2 =>  self.cuantoDanioCausa(v1) > self.cuantoDanioCausa(v2)})
	}
	
	method conocerGanador() {
		return self.deMejorAPeor().first()
	}
	
	method inscribirVikingo(vikingo) {
		if(self.puedeParticipar(vikingo, 10)) {
			self.agregarParticipante(vikingo)
		}
	}
	method jugarPosta(vikingos) {
		vikingos.forEach({v => v.inscribirVikingo(v)})
		resultado = self.deMejorAPeor()
		self.terminarComp()
	}
}


class Carrera inherits Competencia{
	method terminarComp(){
		self.aumentarHambre(1)
	}

	method deMejorAPeor() {
		return participantes.sortedBy({v1, v2 =>  v1.velocidad() > v2.velocidad()})
	}
	
	method conocerGanador() {
		return self.deMejorAPeor().first()
	}
	
	method inscribirVikingo(vikingo) {
		if(self.puedeParticipar(vikingo, 1)) {
			self.agregarParticipante(vikingo)
		}
	}
	
	method jugarPosta(vikingos) {
		vikingos.forEach({v => v.inscribirVikingo(v)})
		resultado = self.deMejorAPeor()
		self.terminarComp()
	}
}

// Torneo
class Torneo {
	method jugarTorneo(vikingos, postas) {
		postas.forEach({p => p.jugarPosta(vikingos)})
	}
}

//items
class SistemaDeVuelo {
	method danio() = 0
}

class Masa {
	method danio() = 100
}

class Hacha {
	method danio() = 30
}

class Comestible {
	var property disminuyeHambre
	method danio() = 0
}


