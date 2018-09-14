object rolando {

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

	method nivelDeHechiceria() = self.valorBaseDeHechiceria() * self.hechizoPreferido().poder() + fuerzaOscura.valor()

	method teCreesPoderoso() = self.hechizoPreferido().sosPoderoso()

	method habilidadDeLucha() = self.valorBaseDeLucha() + self.artefactos().sum({artefacto => artefacto.unidadesDeLucha(self)})

	method sosMejorLuchadorQueHechicero() = self.habilidadDeLucha() > self.nivelDeHechiceria()

	method estasCargado() = self.artefactos().size() >= 5
	
	method artefactosSin(artefactoExceptuado) = self.artefactos().filter({artefacto => artefacto != artefactoExceptuado})
	
	method cualEsTuMejorArtefactoExceptuando(artefactoExceptuado) = self.artefactosSin(artefactoExceptuado).find( { unArtefacto => self.artefactosSin(artefactoExceptuado).all({otroArtefacto => unArtefacto.unidadesDeLucha(self) >= otroArtefacto.unidadesDeLucha(self)}) } )
}


class EspectroMalefico {
	
	var property nombre = "Espectro malefico"

	method poder() = self.nombre().size()

	method sosPoderoso() = self.poder() > 15

	method unidadesDeLucha(propietario) = self.poder()

}


class HechizoBasico {

	var property poder = 10

	method sosPoderoso() = false

	method unidadesDeLucha(propietario) = self.poder()

}


object fuerzaOscura {

	var property valor = 5

	method eclipse() {
		self.valor(self.valor() * 2)
	}

}


class EspadaDelDestino {	

	method unidadesDeLucha(propietario) = 3

}

class CollarDivino {

	var property perlas = 0

	method unidadesDeLucha(propietario) = self.perlas()

}

class MascaraOscura {

	method unidadesDeLucha(propietario) = 4.max(fuerzaOscura.valor() / 2)

}

class Armadura {
	
	var property refuerzo = ninguno

	method unidadesDeLucha(propietario) = 2 + self.refuerzo().unidadesDeLucha(propietario)

}

class CotaDeMalla {

	method unidadesDeLucha(propietario) = 1

}

class Bendicion {

	method unidadesDeLucha(propietario) = propietario.nivelDeHechiceria()

}

object ninguno {
		
	method unidadesDeLucha(propietario) = 0

}

class Espejo {

	method unidadesDeLucha(propietario) = if (self.filtrateDeLosArtefactos(propietario.artefactos()).isEmpty()) {return 0} else { propietario.cualEsTuMejorArtefactoExceptuando(self).unidadesDeLucha(propietario)	 }

	method filtrateDeLosArtefactos(artefactos) = artefactos.filter({artefacto => artefacto != self})

}

class LibroDeHechizos {

	const property hechizos = []

	method agregaHechizo(hechizo) {
		if (hechizo != self){
			self.hechizos().add(hechizo)
		}
	}

	method poder() = self.hechizos().filter({hechizo => hechizo.sosPoderoso()}).sum({hechizo => hechizo.poder()})

	method sosPoderoso() = if (self.hechizos().isEmpty()) {return false} else {return self.hechizos().all({hechizo => hechizo.sosPoderoso()})}

}

//fin