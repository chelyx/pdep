import wollok.game.*
import disfraces.*
import casa.*

class Chicos {
	var property disfraz = superheroe
	
	method cuantosCaramelosPuedeConseguir(unHabitante) {
		return unHabitante.darCaramelos(self.disfraz())
	}
	
	method aumentarCaos(unidad) {
		casa.caos(casa.caos() + unidad)
	}
	
	method pedirCaramelos() {
		var caramelos = [self.cuantosCaramelosPuedeConseguir(casa.quienAbreLaPuerta()), casa.caramelos()].min()
		casa.caramelos(casa.caramelos() - caramelos)
	}
}

object rolo inherits Chicos {
	var property position = game.origin()
	method image() = "rolo.png"
	
	override method cuantosCaramelosPuedeConseguir(unHabitante){
		return 1
	}
	
	method visitarCasa() {
		self.aumentarCaos(5)
	}
	
}

object juanita inherits Chicos {
	method position(){
		const titoPosition = tito.position()
		return titoPosition.left(1)
	}
	method image(){
		if(disfraz == superheroe)  {
			return "juanita-superheroe.png"
		} else {
			return "juanita-harleyquinn.png"
		}
	}
	override method cuantosCaramelosPuedeConseguir(unHabitante) {
		return super(unHabitante) + 2
	}
	method visitarCasa() {
		self.pedirCaramelos()
	}
}

object tito inherits Chicos {
	var property position = game.at(2, 0)
	
	method image(){
		if(disfraz == superheroe)  {
			return "tito-superheroe.png"
		} else if (disfraz == ironman){
			return "tito-ironman.png"
		} else {
			return "tito-venom.png"
		}
	}
	
	override method cuantosCaramelosPuedeConseguir(unHabitante) {
		if (self.disfraz() == juanita.disfraz()) {
			return juanita.cuantosCaramelosPuedeConseguir(unHabitante)
		} else {
			return super(unHabitante)
		}
	}
	
	method visitarCasa() {
		self.pedirCaramelos()
		self.aumentarCaos(1)
	}
}