// https://docs.google.com/document/d/1WOK0p1qH-5LQxDQ1Jx3b39gSXpyqy4GuLIax11yjnoc/edit

class Comida{
    var calorias
    const esCarne

    method esCarne() = esCarne
    method calorias() = calorias
    method esPesada() = calorias > 500
}

class Persona{
    var condicion
    var criterio
    var posicion
    var criterioComida
    var caloriasIngeridas = 0
    var queComi = []
    
    method posicion() = posicion

    method posicion(nuevaPosicion){
        posicion = nuevaPosicion
    }

    method tengoCercaEl(cosa){
        posicion.tengoCercaEl(cosa)
    }

    method pasameLa(persona,cosa){
        persona.tengoCercaEl(cosa)
        criterio.pasameLa(self, persona, cosa)
    }

    method comer(bandeja){
        criterioComida.comer(self, bandeja)
    }
    
    method comerComida(comida){
        queComi.add(comida)
        caloriasIngeridas += comida.calorias()
    }

    method estoyPipon() = queComi.any({ comida => comida.esPesada() })

    method laEstoyPasandoBien(){
        return ((queComi.size() >= 1) && condicion.apply(self))
    }

    method comiCarne() = queComi.any({comida => comida.esCarne()})

}

const osky = new Persona(criterio = sordo, posicion = new Posicion(nDeSilla = 1, elementosCerca = []), criterioComida = new Combinacion(condiciones = [vegetariano, new Alternado()]), condicion = {true})
/*const moni = new Persona(posicion = new Posicion(nDeSilla = 1), condicion = {(persona => persona.posicion().nDeSilla) == 1})
const facu = new Persona(........, condicion = {(persona => persona.comiCarne())})
const vero = new Persona(........, condicion = {(persona => persona.posicion().elementosCerca().size() <= 3)})*/

object vegetariano{
    method condicion(comida){
        return comida.esCarne() == false
    }

    method comer(persona, bandeja){
        bandeja.filter({comida => self.condicion(comida) }).forEach({ comida => persona.comerComida(comida) })
    }
}
    
object dietetico{
    method condicion(comida) = comida.esPesada()
    method comer(persona, bandeja){
        bandeja.filter({comida => self.condicion(comida) }).forEach({ comida => persona.comerComida(comida) })
    }
}

class Alternado{
    var vaAComer = true

    method condicion(comida){
        if(vaAComer){
            vaAComer = false
            return true
        } else{
            vaAComer = true
            return false
        }
    }

    method comer(persona, bandeja){
        bandeja.filter({ comida => self.condicion(comida) }).forEach({ comida => persona.comerComida(comida)} )    
    }
}

class Combinacion{
    const condiciones

    method cumpleCondiciones(comida){
        return condiciones.forAll({ condicion => condicion.condicion(comida) })
    }

    method comer(persona, bandeja){
        const listaAComer = bandeja.filter({ comida => self.cumpleCondiciones(comida) })
        listaAComer.forEach({ comida => persona.comerComida(comida) })
    }
}

class Posicion{
    var elementosCerca
    var nDeSilla

    method nDeSilla() = nDeSilla
    method elementosCerca() = elementosCerca

    method tengoCercaEl(cosa){
        if(!elementosCerca.contains(cosa)){
            throw new Exception(message = "No tengo el condimento cerca!")
        }
    }

    method sacarElemento(cosa){
        elementosCerca.remove(cosa)
    }

    method agregarElemento(cosa){
        elementosCerca.add(cosa)
    }
    
    method primerElemento() = elementosCerca.first()

    method agregarElementos(lista){
        lista.forEach{ elemento => self.agregarElemento(elemento) }
    }
    
    method sacarElementos(lista){
        lista.forEach{ elemento => self.sacarElemento(elemento) }
    }
    
    method elementosCerca(lista){
        elementosCerca = lista
    }    
}

object sordo{    
    method pasameLa(persona, otraPersona, cosa){
        persona.posicion().agregarElemento(otraPersona.posicion().primerElemento())
        otraPersona.posicion().sacarElemento(otraPersona.posicion().primerElemento())
    }
}

object dejameComerTranquilo{
    method pasameLa(persona, otraPersona, cosa){
        persona.posicion().agregarElemento(otraPersona.posicion().elementosCerca())
        otraPersona.posicion().sacarElementos(otraPersona.posicion().elementosCerca())
    }
}

object cambiamePosicion{
    method pasameLa(persona, otraPersona, cosa){
        var posicionAux = persona.posicion()

        persona.posicion(otraPersona.posicion())
        otraPersona.posicion(posicionAux)        
    }
}

object lePasanElemento{
    method pasameLa(persona, otraPersona, cosa){
        persona.posicion().agregarElemento(cosa)
        otraPersona.posicion().sacarElemento(cosa)
    }
}

object sal{}

object aceite{}