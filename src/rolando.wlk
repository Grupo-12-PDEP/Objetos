class Personaje {

	const property artefactos = []
	var property hechizoPreferido = hechizoBasico
	var property valorBaseDeLucha = 1
	var property oro = 100
	
	method valorBaseDeHechiceria() = 3

	method artefactos(nuevaLista) {
		self.artefactos().clear()
		self.artefactos().addAll(nuevaLista)
	}

	method agregaArtefacto(nuevoArtefacto){
		self.artefactos().add(nuevoArtefacto)
	}

	method removeArtefacto(viejoArtefacto){
		self.artefactos().remove(viejoArtefacto)
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
		if (hechizo.precio() - self.hechizoPreferido().precio() <= self.oro()){
			self.restateOro( 0.max(hechizo.precio() - self.hechizoPreferido().precio()) )
			self.hechizoPreferido(hechizo)
			return true
		} else {
			return false
		}
	}
	
	method compra(artefacto) {
		if (artefacto.precio() <= self.oro()){
			self.restateOro(artefacto.precio())
			self.agregaArtefacto(artefacto)
			return true
		} else {
			return false
		}
	}
	
	
}

class Logos {

	var property constanteProporcionalDeHechizo = 0

	var property nombre = ""

	method poder() = self.constanteProporcionalDeHechizo() * self.nombre().size()

	method sosPoderoso() = self.poder() > 15

	method unidadesDeLucha(propietario) = self.poder()
	
	method precio() = self.poder()
	
	method precio(armadura) = armadura.valorBaseDeRefuerzo() + self.precio()

}

object hechizoBasico {

	var property poder = 10

	method sosPoderoso() = false

	method unidadesDeLucha(propietario) = self.poder()
	
	method precio() = 10
	
	method precio(armadura) = armadura.valorBaseDeRefuerzo() + self.precio()

}

object mundo {

	var property fuerzaOscura = 5

	method eclipse() {
		self.fuerzaOscura(self.fuerzaOscura() * 2)
	}

}

class Arma {	

	method unidadesDeLucha(propietario) = 3
	
	method precio() = 5 * self.unidadesDeLucha(0)

}

class Espada inherits Arma {}

class Hacha inherits Arma {}

class Lanza inherits Arma {}

class CollarDivino {

	var property perlas = 0

	method unidadesDeLucha(propietario) = self.perlas()
	
	method precio() = 2 * self.perlas()

}

class MascaraOscura {

	var property indiceDeOscuridad = 0

	var property minimoDePoder = 4

	method unidadesDeLucha(propietario) = self.minimoDePoder().max(self.indiceDeOscuridad() * (mundo.fuerzaOscura() / 2))

}

class Armadura {

	var property valorBaseDeRefuerzo

	var property refuerzo = nada

	method unidadesDeLucha(propietario) = self.valorBaseDeRefuerzo() + self.refuerzo().unidadesDeLucha(propietario)

	method precio() = self.refuerzo().precio(self)

}

class CotaDeMalla {

	const property unidades = 1

	method unidadesDeLucha(propietario) = self.unidades()

	method precio(armadura) = self.unidadesDeLucha(0) / 2

}

object bendicion {

	method unidadesDeLucha(propietario) = propietario.nivelDeHechiceria()
	
	method precio(armadura) = armadura.valorBaseDeRefuerzo()
	
}

object nada {
		
	method unidadesDeLucha(propietario) = 0
	
	method precio(armadura) = 2

}

object espejo {

	method unidadesDeLucha(propietario) = if (propietario.artefactosSin(self).isEmpty()) {return 0} else {propietario.cualEsTuMejorArtefactoExceptuando(self).unidadesDeLucha(propietario)}
	
	method precio() = 90
	
}

class LibroDeHechizos {

	const property hechizos = []

	method agregaHechizo(hechizo) {
		self.hechizos().add(hechizo)
	}

	method poder() = self.hechizosSin(self).filter({hechizo => hechizo.sosPoderoso()}).sum({hechizo => hechizo.poder()})

	method sosPoderoso() = if (self.hechizos().isEmpty()) {return false} else {return self.hechizosSin(self).all({hechizo => hechizo.sosPoderoso()})}

	method hechizosSin(hechizo) = self.hechizos().filter({unHechizo => unHechizo != hechizo})

	method precio() = self.hechizos().size() * 10 + self.hechizos().filter({unHechizo => unHechizo.sosPoderoso()}).sum({unHechizo => unHechizo.poder()})

	method precio(armadura) = armadura.valorBaseDeRefuerzo() + self.precio()

}

// Fin