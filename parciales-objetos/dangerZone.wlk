class Espia {
	method saludCritica() = 15
	method registrarMision(mision, empleado) {
		const nuevasHabilidades = mision.habilidadesRequeridas().filter({h => !empleado.habilidades().contains(h)})
		empleado.agregarHabilidades(nuevasHabilidades)
	}
}

class Oficinista {
	var property estrellas = 0
	method saludCritica() = 40 - 5*estrellas
	method registrarMision(mision, empleado) {
		estrellas += 1
		if(estrellas == 3) {
			empleado.tipo(new Espia())
		}
	}
}

class Jefe inherits Empleado {
	var property subordinados = []
	
	override method puedeUsar(habilidad) {
		return super(habilidad) || subordinados.any({s=> s.puedeUsar(habilidad)})
	}
}

class Empleado {
	var property habilidades
	var property salud
	var property tipo 

	method estaIncapacitado() {
		return salud < tipo.saludCritica()
	}
	
	method puedeUsar(habilidad) {
		return !self.estaIncapacitado() && habilidades.contains(habilidad)
	}
	
	method recibirDanio(cantidad) {
		salud -= cantidad
	}
	
	method agregarHabilidades(hab) {
		habilidades.add(hab)
	}
	
	method finalizarMision(mision) {
		if (salud > 0) {
			tipo.registrarMision(mision, self)
		} else {
			throw new NoSobrevivioLaMision()
		}
	}
	
	method validarHabilidades(habilidadesRequeridas) {
		return habilidadesRequeridas.all({h => self.puedeUsar(h)})
	}
	
}

class Equipo {
	var property empleados
	
	method validarHabilidades(habilidadesRequeridas) {
		return habilidadesRequeridas.all({h => empleados.any({a => a.puedeUsar(h)})})
	}
	
	method recibirDanio(cantidad) {
		empleados.forEach({e=> e.recibirDanio(cantidad/3)})
	}
	
	method finalizarMision(mision) {
		empleados.forEach({e=> e.finalizarMision(mision)})
	}
}

class Mision {
	var property habilidadesRequeridas
	var property peligrosidad
	
	method cumplirMision(asignado){ 
		if(asignado.validarHabilidades(habilidadesRequeridas)){
			asignado.recibirDanio(peligrosidad)
			asignado.finalizarMision(self)
		} else {
			throw new NoTieneHabilidadesRequeridas()
		}
	}
	
}

class NoTieneHabilidadesRequeridas inherits DomainException {}
class NoSobrevivioLaMision inherits DomainException {}



