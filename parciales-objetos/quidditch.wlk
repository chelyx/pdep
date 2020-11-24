class Pokemon {
	var salud
	var property saludMaxima
	var property condicion
	var property movimientos
	
	method grositud() {
		return self.saludMaxima() * self.movimientos().map({m => m.poder()}).sum()
	}
	
	method recibirDanio(danio) {
		salud -= danio
		salud = [salud, 0].max()
	}
	
	method recibirCuracion(cant) {
		salud += cant
		salud = [salud, saludMaxima].min()
	}
	
	method puedeMoverse(){
		return salud > 0 && condicion.permiteMoverse(self)
	}
	
	method lucharContra(oponente, mov) {
		mov.usar(self, oponente)
	}
}

//movimientos
class Movimiento {
	var property cantUsos
	method poder()
	method usar(realizador, oponente) {
		const movDisponible = realizador.movimientos().filter({m => m.cantUsos() > 0}).contains(self)
		if(!realizador.puedeMoverse()) {
			throw new NoPuedeMoverseError()
		} 
		if(!movDisponible) {
			throw new MovimientoNoDisponibleError()
		}
		cantUsos -= 1
	}
}

class MovimientosCurativos inherits Movimiento {
	var property salud
	override method poder() = salud
	override method usar(r, o) {
		super(r, o)
		r.recibirCuracion(salud)
	}
}

class MovimientosDaninos inherits Movimiento {
	var property danio
	override method poder() = danio * 2
	override method usar(r, o) {
		super(r, o)
		o.recibirDanio(danio)
	}
}

class MovimientosEspeciales inherits Movimiento {
	var tipo
	override method poder() = tipo.poder()
	override method usar(r, o) {
		super(r, o)
		o.condicion(tipo)
	}
}
// condiciones
class Normal{
	method permiteMoverse(pokemon) = true
}

class Suenio {
	method poder() = 50
	method permiteMoverse(pokemon) {
		if(0.randomUpTo(2).roundUp().even()) {
			pokemon.condicion(new Normal())
			return true
		}
		return false
	}
}

class Paralisis {
	method poder() = 30
	method permiteMoverse(pokemon) {
		return 0.randomUpTo(2).roundUp().even()
	}
}

class Confusion {
	var cantTurnos
	method poder() = 40 * cantTurnos
	method permiteMoverse(pokemon) {
		if (cantTurnos > 0) {
			pokemon.recibirDanio(20)
			cantTurnos--
			return false
		}
		return true
	}
}

// errores
class NoPuedeMoverseError inherits DomainException {}
class MovimientoNoDisponibleError inherits DomainException {}