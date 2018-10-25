import rolando.*
import hechiceria.*


class Artefacto{
	
	const property fechaDeCompra = new Date()
	const property pesoInicial = 0
	
	method pesas() = self.pesoInicial() - self.factorDeCorrecion()
	
	method factorDeCorrecion() = (self.diasDesdeQueTeCompraron() / 1000).min(1)
	
	method diasDesdeQueTeCompraron() = new Date() - self.fechaDeCompra()
	
	method unidadesDeLucha(propietario)
	
}


class Arma inherits Artefacto {	

	override method unidadesDeLucha(propietario) = 3
	
	method precio() = 5 * self.unidadesDeLucha(0)
	
}

class Espada inherits Arma {}

class Hacha inherits Arma {}

class Lanza inherits Arma {}


class CollarDivino inherits Artefacto {

	var property perlas = 5

	override method unidadesDeLucha(propietario) = self.perlas()
	
	method precio() = 2 * self.perlas()
	
	override method pesas() = super() + 0.5 * self.perlas()

}


class MascaraOscura inherits Artefacto {

	var property indiceDeOscuridad = 1

	var property minimoDePoder = 4

	override method unidadesDeLucha(propietario) = self.minimoDePoder().max(self.indiceDeOscuridad() * (mundo.fuerzaOscura() / 2))
	
	override method pesas() = super() + (self.unidadesDeLucha(0) - 3).max(0)
	
}


class Armadura inherits Artefacto {

	var property valorBaseDeRefuerzo = 2

	var property refuerzo = nada

	override method unidadesDeLucha(propietario) = self.valorBaseDeRefuerzo() + self.refuerzo().unidadesDeLucha(propietario)

	method precio() = self.refuerzo().precio(self)
	
	override method pesas() = super() + refuerzo.pesas()

}

class CotaDeMalla {

	const property unidades = 1

	method unidadesDeLucha(propietario) = self.unidades()

	method precio(armadura) = self.unidadesDeLucha(0) / 2
	
	method pesas() = 1

}

object bendicion {

	method unidadesDeLucha(propietario) = propietario.nivelDeHechiceria()
	
	method precio(armadura) = armadura.valorBaseDeRefuerzo()
	
	method pesas() = 0
	
}

object nada {
		
	method unidadesDeLucha(propietario) = 0
	
	method precio(armadura) = 2
	
	method pesas() = 0

}

object espejo {

	method unidadesDeLucha(propietario) = if (propietario.artefactosSin(self).isEmpty()) {return 0} else {propietario.cualEsTuMejorArtefactoExceptuando(self).unidadesDeLucha(propietario)}
	
	method precio() = 90
	
}
