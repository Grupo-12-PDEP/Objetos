object rolando {

	const property artefactos = []
	var property hechizoPreferido = new HechizoBasico()
	var property valorBaseDeHechiceria = 3
	var property valorBaseDeLucha = 1

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

	method habilidadDeLucha() = self.valorBaseDeLucha() + self.artefactos().sum({artefacto => artefacto.unidadesDeLucha(self.nivelDeHechiceria(), self.artefactos())})

	method sosMejorLuchadorQueHechicero() = self.habilidadDeLucha() > self.nivelDeHechiceria()

	method estasCargado() = self.artefactos().size() >= 5

}


class EspectroMalefico {
	
	var property nombre = "Espectro malefico"

	method poder() = self.nombre().size()

	method sosPoderoso() = self.poder() > 15

	method unidadesDeLucha(nivelDeHechiceria, artefactos) = self.poder()

}


class HechizoBasico {

	var property poder = 10

	method sosPoderoso() = false

	method unidadesDeLucha(nivelDeHechiceria, artefactos) = self.poder()

}


object fuerzaOscura {

	var property valor = 5

	method eclipse() {
		self.valor(self.valor() * 2)
	}

}


class EspadaDelDestino {

	var property valorDeLuchaDeEspadaDelDestino = 3

	method unidadesDeLucha(nivelDeHechiceria, artefactos) = self.valorDeLuchaDeEspadaDelDestino()

}

class CollarDivino {

	var property perlas = 0

	method unidadesDeLucha(nivelDeHechiceria, artefactos) = self.perlas()

}

class MascaraOscura {

	method unidadesDeLucha(nivelDeHechiceria, artefactos) = 4.max(fuerzaOscura.valor() / 2)

}

class Armadura {
	
	var property refuerzo = null

	var property valorBaseDeRefuerzo = 2

	method unidadesDeLucha(nivelDeHechiceria, artefactos) = self.valorBaseDeRefuerzo() + if (refuerzo != null) {self.refuerzo().unidadesDeLucha(nivelDeHechiceria, artefactos)} else {0}

}

class CotaDeMalla {

	var property refuerzoDeCotaDeMalla = 1

	method unidadesDeLucha(nivelDeHechiceria, artefactos) = self.refuerzoDeCotaDeMalla()

}

class Bendicion {

	method unidadesDeLucha(nivelDeHechiceria, artefactos) = nivelDeHechiceria

}

class Espejo {

	method unidadesDeLucha(nivelDeHechiceria, artefactos) = if (self.filtrateDeLosArtefactos(artefactos).isEmpty()) {return 0} else {return self.filtrateDeLosArtefactos(artefactos).map({artefacto => artefacto.unidadesDeLucha(nivelDeHechiceria, artefactos)}).max()}

	method filtrateDeLosArtefactos(artefactos) = artefactos.filter({artefacto => artefacto != self})

}

class LibroDeHechizos {

	const property hechizos = []

	method agregaHechizo(hechizo) {
		self.hechizos().add(hechizo)
	}

	method poder() = self.hechizos().filter({hechizo => hechizo.sosPoderoso()}).sum({hechizo => hechizo.poder()})

	method sosPoderoso() = if (self.hechizos().isEmpty()) {return false} else {return self.hechizos().all({hechizo => hechizo.sosPoderoso()})}

}

//fin