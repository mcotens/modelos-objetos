const museo = new Lugar(senderos = [
	new Rural(destino = casaJim, kilometros = 40)
])
const casaJim = new Lugar(senderos =[
	new Urbano(destino = casaClara, kilometros = 5),
	new Rural(destino = mercadoTroll, kilometros = 35)
])
const casaClara = new Lugar(senderos = [
	new Urbano(destino = mercadoTroll, trafico = 4, kilometros = 15),
	new Urbano(destino = casaJim, kilometros = 5)
])
const mercadoTroll = new Lugar(senderos = [
	new Rural(destino = casaClara, kilometros = 15),
	new Urbano(destino = museo, kilometros = 15, trafico = 2)
])

const aja = new Persona(origen = museo, velocidad = 12, tiempoTotal = 7)
const clara = new Persona(origen = casaClara, velocidad = 10, tiempoTotal = 5)
const jim = new Persona(origen = casaJim, velocidad = 90, velocidadCampo = 9, tiempoTotal = 7)

class Lugar{
	var senderos
	
	method senderos() = senderos
	
	method seConecta(destino) = senderos.any({ sendero => sendero.destino() == destino })
	
	method senderoQueConecta(destino){
		self.comprobarSendero(destino)
		return senderos.find({ sendero => sendero.destino() == destino })	
	}
	
	method comprobarSendero(destino){
		if(!self.seConecta(destino)){
			throw new Exception(message = "El lugar no se conecta con ese destino.")
		}
	}
}

class Sendero{
	const property destino
	const property kilometros
	
	method tiempoEnRecorrer(persona)
}

class Urbano inherits Sendero{
	var trafico = 1
	
	override method tiempoEnRecorrer(persona){
		return (kilometros * trafico / persona.velocidad()).roundUp(0)
	}
}

class Rural inherits Sendero{
	override method tiempoEnRecorrer(persona){
		return (kilometros / persona.velocidadCampo()).roundUp(0)
	}
}

class Persona{
	const property velocidad
	var tiempoTotal
	var velocidadCampo = velocidad
	var property origen
	
	method tiempoTotal() = tiempoTotal
	
	method velocidadCampo() = velocidadCampo
	
	method tiempoEnRecorrer(destino) = origen.senderoQueConecta(destino).tiempoEnRecorrer(self)
	
	method destinoMasCercano() = origen.senderos().min({ sendero => sendero.tiempoEnRecorrer(self) }).destino()
	
	method seConectaCon(destino) = origen.seConecta(destino)
	
	method realizarTarea(tarea){
		tarea.serRealizada(self)
	}
	
	method pasarTiempo(horas){
		tiempoTotal -= horas
	}
	
	method sumarHoras(horas){
		tiempoTotal += horas
	}
	
	method mitadDeSusHoras() = tiempoTotal / 2
	
	method realizarTareas(tareas, itinerario){
		tareas.forEach({
			tarea =>
				try{
					self.realizarTarea(tarea)
					itinerario.agregarTareaRealizada(self)
				}catch e : Exception{
					console.println(e.message())
				}
		})
	}
}

class Tarea{
	method horasNecesarias(persona)
	
	method cumpleRequisitos(persona){
		if(persona.tiempoTotal() < self.horasNecesarias(persona)){
			throw new Exception(message = "La persona no tiene las horas necesarias.")
		}	
	}
	
	method serRealizada(persona){
		self.cumpleRequisitos(persona)
		self.realizarse(persona)
	}
	
	method realizarse(persona)
}

const moverseAMuseo = new MoverseAlDestino(destino = museo)
const moverseAMercadoTroll = new MoverseAlDestino(destino = mercadoTroll)
const moverseACasaClara = new MoverseAlDestino(destino = casaClara)
object destinoNulo{}

class MoverseAlDestino inherits Tarea{
	const destino = destinoNulo
	
	method destino() = destino
	
	override method cumpleRequisitos(persona){
		super(persona)
		if(!persona.seConectaCon(self.destino())){
			throw new Exception(message = "La persona no cumple los requisitos de la tarea.")
		}	
	}
	
	override method realizarse(persona){
		persona.pasarTiempo(self.horasNecesarias(persona))
		persona.origen(self.destino())
	}
	
	override method horasNecesarias(persona) = persona.tiempoEnRecorrer(self.destino())
}

class MoverseAlDestinoMasCercano inherits MoverseAlDestino{
	const persona
	
	override method destino() = persona.destinoMasCercano()
}

class UsarInstrumento inherits Tarea{
	const objetivo
	const instrumento
	
	override method cumpleRequisitos(persona){
		super(persona)
		if(persona.origen() != objetivo.origen()){
			throw new Exception(message = "La persona no cumple los requisitos de la tarea.")			
		}
	}
	
	override method realizarse(persona){
		persona.pasarTiempo(self.horasNecesarias(persona))
		instrumento.usarse(persona, objetivo)
	}
	
	override method horasNecesarias(persona) = instrumento.duracion(persona)
}

class Instrumento{
	method duracion(persona)
	method usarse(persona, objetivo)
}

class Kairosecto inherits Instrumento{
	override method duracion(persona) = 1
	
	override method usarse(persona, objetivo){
		objetivo.sumarHoras(3)
	}
}

class Baculo inherits Instrumento{
	const destino
	
	override method duracion(persona) = persona.mitadDeSusHoras()
	
	override method usarse(persona, objetivo){
		objetivo.origen(destino)
	}
}

const kairosecto = new Kairosecto()
const baculoAlMercadoTroll = new Baculo(destino = mercadoTroll)

class Itinerario{
	const tareas
	const tareasRealizadas = new Dictionary()
	
	method aplicarse(personas){
		personas.forEach({ persona => persona.realizarTareas(tareas, self) })
	}
	
	method agregarTareaRealizada(persona){
		var valorPrevio = 0
		
		if(tareasRealizadas.containsKey(persona)){
			valorPrevio = tareasRealizadas.get(persona)
		}			
			
		tareasRealizadas.put(persona, valorPrevio + 1)
	}
}