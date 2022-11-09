class Empleado{
	var cargoOcupado
	var antiguedad
	const property personalidad
	var cargoEjecutivo = false

	method hacerEjecutivo(){
		cargoEjecutivo = true
	}
	
	method sueldoMensual(horas) = cargoOcupado.sueldoPorMes(horas) + 100 * antiguedad
	
	method recategorizar(nuevaCat){cargoOcupado = nuevaCat}
	
	method motivacion(){
		if(cargoEjecutivo){ 
			return cargoOcupado.motivacion() * 1.1
		}else{
			return cargoOcupado.motivacion()
		}
	}
}

class Recepcionista{
	const sueldoPorHora = 15
	
	method sueldoPorHora() = sueldoPorHora
	
	method sueldoPorMes(horas){ return sueldoPorHora * horas * 22 }
}

class Pasante{
	const sueldoPorHora = 10
	var diasTomados

	method sueldoPorHora() = sueldoPorHora
	
	method diasTomados() = diasTomados
	
	method sueldoPorMes(horas){ return sueldoPorHora * horas * (22 - diasTomados) }
	
}

class Gerente{
	const sueldoPorHora = 8
	var cantidadColegas
	method sueldoPorHora() = sueldoPorHora
	
	method sueldoPorMes(horas){ return (sueldoPorHora * cantidadColegas) * horas * 22 }	
}

class Sucursal{
	var presupuestoMensual
	var empleados = []
	
	method agregarEmpleado(empleado) = empleados.add(empleado)

	method hacerEjecutivo(empleado) = empleado.hacerEjecutivo()

	method sacarEmpleado(empleado) = empleados.remove(empleado)
	
	method cantidadDeEmpleados() = empleados.size()
	
	method esViable(){
		if(self.sueldosTotalesPorMes() < presupuestoMensual){
			throw new Exception(message = "La sucursal no es viable!")
		}
	}
	
	method sueldosTotalesPorMes(){
		return empleados.map({empleado => empleado.sueldoPorMes()}).sum()
	}
		
	method recategorizarEmpleado(nuevaCat, empleado){
		self.esViable()
		empleados.find({emp => emp == empleado}).recategorizar(nuevaCat)
	}

	method moverAOtraSucursal(nuevaSucursal, empleado){
		nuevaSucursal.esViable()
		if(self.cantidadDeEmpleados() > 3){
			const emple = empleados.find({emp => emp == empleado})
			nuevaSucursal.agregarEmpleado(emple)
			self.sacarEmpleado(emple)
		}
		else{self.error("No es posible hacer el transpaso!")}
	}

	method promedioMotivacion(){
		return empleados.map({ empleado => empleado.motivacion() }).sum() / self.cantidadDeEmpleados()
	}

	method esMejorQue(otraSucursal){
		self.esViable() 
		otraSucursal.esViable()
		return self.promedioMotivacion() > otraSucursal.promedioMotivacion()
	}
}

/* PERSONALIDADES */

class Competitiva{
	method motivacion(sucursal, empleado){
		return 100 - 10*((sucursal.empleados().map({emp => emp.sueldoMensual() > empleado.sueldoMensual()})).size())
	} 
}

class Sociable{
	method motivacion(sucursal, empleado) = 15 * (sucursal.cantidadDeEmpleados() - 1)
}

class Indiferente{
	var motivacion

	method motivacion(sucursal, empleado) = motivacion
}

class Compleja{
	const personalidades = []

	method motivacion(sucursal, empleado) = personalidades.map({ personalidad => personalidad.motivacion(sucursal, empleado) }).sum() / personalidades.size()
}















