//https://docs.google.com/document/d/e/2PACX-1vRFhr0lXZkZoovSdMhpqNr45HMn6NsuRTsQBJXVCDReAqqcvaOtskwIJCV9K7vIbWAXHlF2gFjaQwD9/pub

class Empleado{
    var salud
    var misionesCompletadas
	var oficio

	method oficio() = oficio
	method oficio(nuevoOficio){
		oficio = nuevoOficio
	}

	method habilidades() = oficio.habilidades()
	method agregarHabilidad(habilidad) = oficio.agregarHabilidad(habilidad)

	method saludCritica()

    method estaIncapacitado() = salud < self.saludCritica()

	method puedeUsar(habilidad) = (!self.estaIncapacitado() && tieneHabilidad(habilidad))

	method tieneHabilidad(habilidad) = self.habilidades().contains(habilidad)

	method puedeCumplirMision(mision) = mision.habilidades().all({habilidad => self.habilidades().contains(habilidad)})

	method cumplirMision(mision){
		self.disminuirSalud(mision.peligrosidad())
		if(salud > 0) self.registrarMision(mision)
	}

	method disminuirSalud(cantidad){
		salud = salud - cantidad
	}

	method registrarMision(mision){
        misionesCompletadas.add(mision)
		oficio.registrarMision(mision)
		oficio.postCondicion(self)
    }
}

class Oficio{
	var habilidades
	
	method habilidades() = habilidades
	method agregarHabilidad(habilidad){
		habilidades.add(habilidad)
	}
	method borrarDuplicados(){
		habilidades = habilidades.asSet()
	}

	method saludCritica()
	method registrarMision(mision)
	method postCondicion(empleado)
}

class Espia inherits Oficio{
	override method saludCritica() = 15

	override method registrarMision(mision){
		mision.habilidades().forEach({ habilidad => self.agregarHabilidad(habilidad) })
		self.borrarDuplicados()
	}

	override method postCondicion(empleado){}
}

class Oficinista inherits Oficio{
	var estrellas

	override method saludCritica() = 40 - 5 * estrellas

	override method registrarMision(mision){
		estrellas = estrellas + 1
    }
	
	override method postCondicion(empleado){
		if(estrellas >= 3){
			empleado.oficio(new Espia(habilidades = self.habilidades()))
		}
	}
}

class Jefe inherits Empleado{
    var subordinados
    var oficio

	method agregarSubordinado(subordinado) = subordinados.add(subordinado)
	method subordinados() = subordinados

    method puedeUsar(habilidad) = (!self.estaIncapacitado() && (self.tieneHabilidad(habilidad) || self.algunSubordinadoTieneHabilidad(habilidad)))

    method algunSubordinadoTieneHabilidad(habilidad) = subordinados.any {subordinado => subordinado.tieneHabilidad(habilidad)}
        
}

class Equipo{
	var grupo = new List()

    method puedeCumplirMision(mision) = grupo.any({empleado => empleado.puedeCumplirMision(mision)})

    method cumplirMision(mision){
        if(grupo.size() > 1){
            grupo.forEach({ empleado => empleado.disminuirSalud( mision.peligrosidad() / 3 ) })
        }else{
            grupo.forEach({ empleado => empleado.cumplirMision( mision )})
        } // caso para un equipo con un integrante
    }
}

class Mision{
    var habilidadesRequeridas
    var property peligrosidad

    method habilidades() = habilidadesRequeridas
}