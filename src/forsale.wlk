class Operacion{
	var empleadoQueLoRealizo /* Empleado */
    var concretada = false
    var empleadoReserva
	
	method empleadoQueLoRealizo() = empleadoQueLoRealizo
	
	method cobrarComision(empleado, inmueble)

    method realizarse(empleado, inmueble){
        concretada = true
        self.cobrarComision(empleado, inmueble)
        empleadoQueLoRealizo = empleado
    }

    method comision(inmueble){
        if(concretada){
            return self.valorComision(inmueble)
        } else {
            return 0
        }
    }

    method valorComision(inmueble) 
}

class Alquiler inherits Operacion{
	var meses

    method valorComision(inmueble){
        return (meses*inmueble.valorDeInmueble()) / 50000
    }
	
	method cobrarComision(empleado, inmueble){
		empleado.cobrarComision( self.valorComision(inmueble) )
	}
	
}

class Venta inherits Operacion{
	var porcentaje
	
    method valorComision(inmueble){
        return ( inmueble.valorDeInmueble()) * porcentaje
    }

	method cobrarComision(empleado,inmueble){
		empleado.cobrarComision( self.valorComision(inmueble) )
	}
}
		/*const aux = empleados.map({empleado => empleado.comisiones()}).max()
		return empleados.find({ empleado => empleado.comisiones() == aux })*/
		/*const aux = empleados.map({empleado => empleado.OpCerradas()}).max()
		return empleados.find({ empleado => empleado.OpCerradas() == aux })*/

class Inmobiliaria{
	var empleados
	var operaciones
	
    method mejorEmpleadoSegunCriterio(criterio){
        return empleados.max({ empleado => criterio.apply(empleado) })
    }

	method mejorEmpleadoSegunComisiones(){
        return self.mejorEmpleadoSegunCriterio({ empleado => empleado.comisiones() })
        /*return empleados.max({ empleado => empleado.comisiones() })*/
	}

	method mejorEmpleadoSegunOpCerradas(){
        return self.mejorEmpleadoSeguinCriterio({ empleado => empleado.OpCerradas().size() })
        /*return empleados.max({empleado => empleado.OpCerradas()})*/
	}

    method mejorEmpleadoSegunReservas(){
        return self.mejorEmpleadoSeguinCriterio({ empleado => empleado.reservas().size() })
    }
}

class Cliente{

    method solicitarReserva(empleado, inmueble){
        inmueble.reservar(empleado, self)
    }

}

class Empleado{
	var comisiones = 0
	var OpCerradas = []
    var reservas = []
	method comisiones() = comisiones
	method OpCerradas() = OpCerradas
	method reservas() = reservas
	
	method cobrarComision(cantidad){ comisiones += cantidad }

    method sumarReserva(nuevaReserva){ reservas.add(inmueble) }

    method sumarOpCerrada(nuevaOperacion){ OpCerradas.add(inmueble) }

    method vaATenerProblemas(otroEmpleado){
        var zonasOperaciones = OpCerradas.map({ inmueble => inmueble.zona() })
         
        if(otroEmpleado.OpCerradas().any({ operacion => zonasOperaciones.contains(operacion.zona()) })){

            if(otroEmpleado.OpCerradas().any({ inmueble => inmueble.operacion().empleadoReserva() == self })){
                return true
            } else if (OpCerradas().any({ inmueble => inmueble.operacion().empleadoReserva() == otroEmpleado })){
                return true
            }
            
        }
    }
}

object clienteNulo{}

class Inmueble{
    const tamanio
    const ambientes
    var property operacion
    var zona
    var reservada = clienteNulo

    method valorDeInmueble(inmueble) = zona.plus()

    method reservar(empleado, cliente){
        if(cliente == clienteNulo){
            reservada = cliente
            empleado.sumarReserva(self)
            operacion.empleadoReserva = empleado
        }
    }

    method concretarOperacion(empleado, cliente){
        if(cliente == reservada){
            operacion.realizarse(empleado, cliente)
            empleado.sumarOpCerrada(self)
        }
    }
}

class Casa inherits Inmueble{
    const valor

    override method valorDeInmueble(inmueble) = super(inmueble) + valor
}

class Local inherits Casa{
    var tipoDeLocal

    override method valorDeInmueble(inmueble) = tipoDeLocal.valorDeInmueble(inmueble)
}

object galpon{
    method valorDeInmueble(inmueble) = inmueble.valorDeInmueble() / 2
}

object aLaCalle{
    var montoFijo = 500

    method valorDeInmueble(inmueble) = inmueble.valorDeInmueble() + montoFijo
}

class PH inherits Inmueble{
	
	override method valorDeInmueble(inmueble) = super(inmueble) + 500000.max(tamanio * 14000)
}

class Departamento inherits Inmueble{
	
	override method valorDeInmueble(inmueble) = super(inmueble) + ambientes * 350000
}

class Zona{
    method plus() = 1
    
}