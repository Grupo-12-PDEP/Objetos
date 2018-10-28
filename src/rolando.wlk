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
		if (hechizo.precio() - self.hechizoPreferido().precio() / 2 > self.oro()){
			throw new ExcepcionPorDineroInsuficiente("no tenes fondos suficiente para realizar el canje")
		}
		
		self.restateOro( 0.max(hechizo.precio() - self.hechizoPreferido().precio() / 2) )
		self.hechizoPreferido(hechizo)
		
	}
	
	method compra(artefacto, comerciante) {
		if (artefacto.precio() > self.oro()){
			throw new ExcepcionPorDineroInsuficiente("no tenes fondos suficiente para realizar la compra")
		} 
		
		if (self.cargas() + artefacto.pesas() > self.pesoMaximo()){
			throw new ExcepcionPorPesoMaximoAlcanzado("no se puede realizar la compra porque se excederia el peso maximo permitido para el personaje")
		}
		
		if (self.puedeCanjear(hechizo).negate()) {
			throw new ExcepcionPorPocoOro("No te alcanza el oro para comprar este hechizo")
		}
		self.restateOro( 0.max(hechizo.precio() - self.hechizoPreferido().precio() / 2) )
		self.hechizoPreferido(hechizo)
	}
	
	method puedeCanjear(hechizo) = hechizo.precio() - self.hechizoPreferido().precio() / 2 <= self.oro()
	
	method compra(artefacto) {
		if (self.puedeComprar(artefacto).negate()) {
			throw new ExcepcionPorPocoOro("No te alcanza el oro para comprar este artefacto")
		}
		self.restateOro(artefacto.precio())
		self.agregaArtefacto(artefacto)
	}
	
	method puedeComprar(artefacto) = artefacto.precio() <= self.oro()
	
}

class Hechizo inherits Refuerzo {
	
	method poder()
	
	method sosPoderoso()
	
	method precio()
	
	method cargas() = self.artefactos().sum({artefacto => artefacto.pesas()})
	
	method desprendete(unArtefacto){
		self.artefactos().remove(unArtefacto)
	}
	
	
}

class ExcepcionPorDineroInsuficiente inherits Exception{}

class ExcepcionPorPesoMaximoAlcanzado inherits Exception{}

}

class Logos inherits Hechizo {

	var property constanteProporcionalDeHechizo = 0

	var property nombre = ""

	override method poder() = self.constanteProporcionalDeHechizo() * self.nombre().size()

	override method sosPoderoso() = self.poder() > 15

	override method unidadesDeLucha(propietario) = self.poder()
	
	override method precio() = self.poder()
	
	override method precio(armadura) = armadura.valorBaseDeRefuerzo() + self.precio()

}

object hechizoBasico inherits Hechizo {

	override method poder() = 10

	override method sosPoderoso() = false

	override method unidadesDeLucha(propietario) = self.poder()
	
	override method precio() = 10
	
	override method precio(armadura) = armadura.valorBaseDeRefuerzo() + self.precio()

}

object mundo {

	var property fuerzaOscura = 5

	method eclipse() {
		self.fuerzaOscura(self.fuerzaOscura() * 2)
	}

}

class ArtefactoDeLucha {
	
	method unidadesDeLucha(propietario)
	
	method precio()
	
}

class Arma inherits ArtefactoDeLucha {	

	override method unidadesDeLucha(propietario) = 3
	
	override method precio() = 5 * self.unidadesDeLucha(nada)

}

class Espada inherits Arma {}

class Hacha inherits Arma {}

class Lanza inherits Arma {}

class CollarDivino inherits ArtefactoDeLucha {

	var property perlas = 0

	override method unidadesDeLucha(propietario) = self.perlas()
	
	override method precio() = 2 * self.perlas()

}

class MascaraOscura inherits ArtefactoDeLucha {

	var property indiceDeOscuridad = 0

	var property minimoDePoder = 4

	override method unidadesDeLucha(propietario) = self.minimoDePoder().max(self.indiceDeOscuridad() * (mundo.fuerzaOscura() / 2))

}

class Armadura inherits ArtefactoDeLucha {

	var property valorBaseDeRefuerzo = 2

	var property refuerzo = nada

	override method unidadesDeLucha(propietario) = self.valorBaseDeRefuerzo() + self.refuerzo().unidadesDeLucha(propietario)

	override method precio() = self.refuerzo().precio(self)

}

class Refuerzo {
	
	method unidadesDeLucha(propietario)
	
	method precio(armadura)
	
}

class CotaDeMalla inherits Refuerzo {

	const property unidades = 1

	override method unidadesDeLucha(propietario) = self.unidades()

	override method precio(armadura) = self.unidades() / 2

}

object bendicion inherits Refuerzo {

	override method unidadesDeLucha(propietario) = propietario.nivelDeHechiceria()
	
	override method precio(armadura) = armadura.valorBaseDeRefuerzo()
	
}

object nada inherits Refuerzo {
		
	override method unidadesDeLucha(propietario) = 0
	
	override method precio(armadura) = 2

}

object espejo inherits ArtefactoDeLucha {

	override method unidadesDeLucha(propietario) = 
	if (propietario.artefactosSin(self).isEmpty()) {
		return 0
	} 
	else {
		propietario.cualEsTuMejorArtefactoExceptuando(self).unidadesDeLucha(propietario)
	}
	
	override method precio() = 90
	
}

class LibroDeHechizos inherits Hechizo {

	const property hechizos = []

	method agregaHechizo(hechizo) {
		self.hechizos().add(hechizo)
	}

	override method poder() = self.hechizosSin(self).filter({hechizo => hechizo.sosPoderoso()}).sum({hechizo => hechizo.poder()})

	override method sosPoderoso() = if (self.hechizos().isEmpty()) {return false} else {return self.hechizosSin(self).all({hechizo => hechizo.sosPoderoso()})}

	method hechizosSin(hechizo) = self.hechizos().filter({unHechizo => unHechizo != hechizo})

	override method precio() = self.hechizos().size() * 10 + self.hechizos().filter({unHechizo => unHechizo.sosPoderoso()}).sum({unHechizo => unHechizo.poder()})

	override method precio(armadura) = armadura.valorBaseDeRefuerzo() + self.precio()

}

class ExcepcionPorPocoOro inherits Exception {}

//fin