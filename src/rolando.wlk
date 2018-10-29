import hechiceria.*
import artefactos.*

class Personaje {

	const property artefactos = []
	var property hechizoPreferido = hechizoBasico
	var property valorBaseDeLucha = 1
	var property oro = 100
	const property pesoMaximo = 10
	
	method valorBaseDeHechiceria() = 3

	method artefactos(nuevaLista) {
		self.abandonaTodosTusArtefactos()
		self.artefactos().addAll(nuevaLista)
	}

	method agregaArtefacto(nuevoArtefacto) {
		self.artefactos().add(nuevoArtefacto)
	}

	method removeArtefacto(viejoArtefacto) {
		self.artefactos().remove(viejoArtefacto)
	}
	
	method abandonaTodosTusArtefactos() {
		self.artefactos().clear()
	}
	
	method sumateOro(cantidad) { self.oro( self.oro() + cantidad ) }
	
	method restateOro(cantidad) { self.oro( 0.max(self.oro() - cantidad) ) }

	method nivelDeHechiceria() = self.valorBaseDeHechiceria() * self.hechizoPreferido().poder() + mundo.fuerzaOscura()

	method teCreesPoderoso() = self.hechizoPreferido().sosPoderoso()

	method habilidadDeLucha() = self.valorBaseDeLucha() + self.artefactos().sum({artefacto => artefacto.unidadesDeLucha(self)})

	method sosMejorLuchadorQueHechicero() = self.habilidadDeLucha() > self.nivelDeHechiceria()

	method estasCargado() = self.artefactos().size() >= 5
	
	method artefactosSin(artefactoExceptuado) = self.artefactos().filter({artefacto => artefacto != artefactoExceptuado})
	
	method cualEsTuMejorArtefactoExceptuando(artefactoExceptuado) = self.artefactosSin(artefactoExceptuado).find( { unArtefacto => self.artefactosSin(artefactoExceptuado).all({otroArtefacto => unArtefacto.unidadesDeLucha(self) >= otroArtefacto.unidadesDeLucha(self)}) } )
	
	method cumpliUnObjetivo() { self.sumateOro(10) }
	
	method canjea(hechizo) {
		if (self.puedeCanjear(hechizo).negate()) {
			throw new ExcepcionPorPocoOro("No te alcanza el oro para comprar este hechizo")
		}
		self.restateOro( 0.max(hechizo.precio() - self.hechizoPreferido().precio() / 2) )
		self.hechizoPreferido(hechizo)
	}
	
	method puedeCanjear(hechizo) = hechizo.precio() - self.hechizoPreferido().precio() / 2 <= self.oro()
	
	method compra(artefacto, comerciante) {
		if (self.puedeComprar(artefacto, comerciante).negate()) {
			throw new ExcepcionPorPocoOro("No te alcanza el oro para comprar este artefacto")
		}
		if (self.cargas() + artefacto.pesas() > self.pesoMaximo()) {
			throw new ExcepcionPorPesoMaximoAlcanzado("No se puede realizar la compra porque se excederia el peso maximo permitido para el personaje")
		}
		self.restateOro(artefacto.precio() + comerciante.impuesto(artefacto))
		self.agregaArtefacto(artefacto)
	}
	
	method puedeComprar(artefacto, comerciante) = artefacto.precio() + comerciante.impuesto(artefacto) <= self.oro()

	method cargas() = self.artefactos().sum({artefacto => artefacto.pesas()})
	
	method desprendete(unArtefacto){
		self.artefactos().remove(unArtefacto)
	}
	
}

class Comerciante {
	
	var property tipoDeComercio
	
	method impuesto(artefacto) = tipoDeComercio.criterioDeComercio(artefacto)
	
	method recategorizate() {
		self.tipoDeComercio(self.tipoDeComercio().recategorizate())
	}
	
}

class Independiente {
	
	var property impuesto
	
	method criterioDeComercio(artefacto) = impuesto * artefacto.precio()
	
	method recategorizate() {
		if (self.impuesto() * 2 < 0.21) {
			self.impuesto(self.impuesto() * 2)
			return self
		}
		else {
			return new Registrado()
		}
	}
	
}

class Registrado {
	
	method criterioDeComercio(artefacto) = 0.21 * artefacto.precio()
	
	method recategorizate() = new ConImpuestoALasGanancias()
	
}

class ConImpuestoALasGanancias {
	
	method criterioDeComercio(artefacto) = 0.35 * (artefacto.precio() - mundo.minimoNoImponible())
	
	method recategorizate() = self
	
}

class ExcepcionPorPocoOro inherits Exception {}

class ExcepcionPorPesoMaximoAlcanzado inherits Exception {}

object mundo {

	var property minimoNoImponible

	var property fuerzaOscura = 5

	method eclipse() {
		self.fuerzaOscura(self.fuerzaOscura() * 2)
	}

}

class NPC inherits Personaje {
	
	var property nivelDeDificultad
	
	override method habilidadDeLucha() = self.nivelDeDificultad().multiplicador() * super()
	
}

object facil {
	
	method multiplicador() = 1
	
}

object moderado {
	
	method multiplicador() = 2 
	
}

object dificil {
	
	method multiplicador() = 4
	
}

//fin