//https://docs.google.com/document/d/1zcKxokC0BUi7o47XXDqt4oM4xQE3LvU8528PrWfPY70/edit
class Empleado{
	var estamina
	var rol
	
	//Rol
	method cambiarRol(nuevoRol){
		rol = nuevoRol
	}
	
	//Tarea
	method realizarTarea(tarea){
		tarea.comprobarSiPuedeSerRealizadaPor(self)
		tarea.serRealizadaPor(self)
	}
	
	//Estamina
	method estamina() = estamina
	method aumentarEstamina(nuevaEstamina)
	method reducirEstamina(reduccion){
		estamina = (estamina - reduccion).min(0)
	}
	
	//Fuerza
	method fuerza() = (estamina / 2) + 2
	
	method comerFruta(fruta){
		fruta.serComida(self)
	}
}

class Fruta{
	const cantidad
	
	method serComida(empleado){
		empleado.aumentarEstamina(cantidad)
	}
}

const banana = new Fruta(cantidad = 10)
const manzana = new Fruta(cantidad = 5)
const uva = new Fruta(cantidad = 1)

class Maquina{
	const property complejidad
	const property herramientas
	
	method herramientasEsVacia() = herramientas.isEmpty()
	
	method puedeSerArreglada(listaHerramientas) = herramientas.all({ herramienta => listaHerramientas.contains(herramienta) })
}

class ArreglarUnaMaquina{
	var maquina
	
	method comprobarSiPuedeSerRealizadaPor(empleado){
		if(empleado.estamina() < maquina.complejidad()){
			self.error("Este empleado no tiene la estamina para arreglar esta maquina.")
		} else {
			if(!maquina.herramientasEsVacia() && maquina.puedeSerArreglada(empleado.herramientas())){
				self.error("Este empleado no tiene las herramientas para arreglar esta maquina.")
			}
		}
	}
	
	method serRealizadaPor(empleado){
		empleado.reducirEstamina(maquina.complejidad())
	}
	
	method dificultad() = 2 * maquina.complejidad()
}

object defenderSector{	
	method comprobarSiPuedeSerRealizadaPor(empleado){
		if(empleado.fuerza() < amenaza){
			self.error("El empleado no tiene la fuerza para defender el sector!")
		}
	}
	
	method serRealizadaPor(empleado){
		empleado.rol().defenderSector(empleado)
	}
}

object grande{}

class LimpiarSector{
	var property dificultad	= 10
	const tamanio
	
	method esGrande() = tamanio == grande
	
	method comprobarSiPuedeSerRealizadaPor(empleado){
		if((self.esGrande() && empleado.estamina() < 4) || (!self.esGrande() && empleado.estamina() < 1)){
			self.error("El empleado no tiene la estamina para limpiar el sector!")
		}
	}
	
	method serRealizadaPor(empleado){
		if(self.esGrande()){
			empleado.rol().limpiarSector(4, empleado)
		} else {
			empleado.rol().limpiarSector(1, empleado)
		}
	}
}

class Biclopes inherits Empleado{
	override method aumentarEstamina(nuevaEstamina){
		estamina = nuevaEstamina.max(10)
	}
}

class Ciclopes inherits Empleado{
	override method aumentarEstamina(nuevaEstamina){
		estamina = nuevaEstamina
	}
}

class Soldado{
	var practica
	
	method defenderSector(empleado){
		practica = practica + 2
	}
	
	method limpiarSector(n, empleado){
		empleado.reducirEstamina(n)
	}
}

object obrero{
	var cinturonHerramientas = []
	
	method defenderSector(empleado){
		empleado.reducirEstamina(empleado.estamina() / 2)
	}
	
	method limpiarSector(n, empleado){
		empleado.reducirEstamina(n)
	}
}

object mucama{
	method defenderSector(empleado){
		self.error("Las mucamas no defienden los sectores!")
	}
	method limpiarSector(n, empleado){}
}