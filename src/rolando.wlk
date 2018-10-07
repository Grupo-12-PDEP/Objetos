class Personaje {

	const property artefactos = []
	var property hechizoPreferido = new HechizoBasico()
	var property valorBaseDeLucha = 1
	
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

	method nivelDeHechiceria() = self.valorBaseDeHechiceria() * self.hechizoPreferido().poder() + mundo.fuerzaOscura()

	method teCreesPoderoso() = self.hechizoPreferido().sosPoderoso()

	method habilidadDeLucha() = self.valorBaseDeLucha() + self.artefactos().sum({artefacto => artefacto.unidadesDeLucha(self)})

	method sosMejorLuchadorQueHechicero() = self.habilidadDeLucha() > self.nivelDeHechiceria()

	method estasCargado() = self.artefactos().size() >= 5
	
	method artefactosSin(artefactoExceptuado) = self.artefactos().filter({artefacto => artefacto != artefactoExceptuado})
	
	method cualEsTuMejorArtefactoExceptuando(artefactoExceptuado) = self.artefactosSin(artefactoExceptuado).find( { unArtefacto => self.artefactosSin(artefactoExceptuado).all({otroArtefacto => unArtefacto.unidadesDeLucha(self) >= otroArtefacto.unidadesDeLucha(self)}) } )

}

class Logos {

	var property constanteProporcionalDeHechizo = 0

	var property nombre = ""

	method poder() = self.constanteProporcionalDeHechizo() * self.nombre().size()

	method sosPoderoso() = self.poder() > 15

	method unidadesDeLucha(propietario) = self.poder()

}

class HechizoBasico {

	var property poder = 10

	method sosPoderoso() = false

	method unidadesDeLucha(propietario) = self.poder()

}

object mundo {

	var property fuerzaOscura = 5

	method eclipse() {
		self.fuerzaOscura(self.fuerzaOscura() * 2)
	}

}

class Arma {	

	method unidadesDeLucha(propietario) = 3

}

class Espada inherits Arma {}

class Hacha inherits Arma {}

class Lanza inherits Arma {}

class CollarDivino {

	var property perlas = 0

	method unidadesDeLucha(propietario) = self.perlas()

}

class MascaraOscura {

	var property indiceDeOscuridad = 0

	var property minimoDePoder = 4

	method unidadesDeLucha(propietario) = self.minimoDePoder().max(self.indiceDeOscuridad() * (mundo.fuerzaOscura() / 2))

}

class Armadura {
	
	var property refuerzo = nada

	method valorBaseDeRefuerzo() = 2

	method unidadesDeLucha(propietario) = self.valorBaseDeRefuerzo() + self.refuerzo().unidadesDeLucha(propietario)

}

class CotaDeMalla {

	method unidadesDeLucha(propietario) = 1

}

class Bendicion {

	method unidadesDeLucha(propietario) = propietario.nivelDeHechiceria()

}

object nada {
		
	method unidadesDeLucha(propietario) = 0

}

class Espejo {

	method unidadesDeLucha(propietario) = if (propietario.artefactosSin(self).isEmpty()) {return 0} else {propietario.cualEsTuMejorArtefactoExceptuando(self).unidadesDeLucha(propietario)}

}

class LibroDeHechizos {

	const property hechizos = []

	method agregaHechizo(hechizo) {
		self.hechizos().add(hechizo)
	}

	method poder() = self.hechizosSin(self).filter({hechizo => hechizo.sosPoderoso()}).sum({hechizo => hechizo.poder()})

	method sosPoderoso() = if (self.hechizos().isEmpty()) {return false} else {return self.hechizosSin(self).all({hechizo => hechizo.sosPoderoso()})}

	method hechizosSin(hechizo) = self.hechizos().filter({unHechizo => unHechizo != hechizo})

}

//fin