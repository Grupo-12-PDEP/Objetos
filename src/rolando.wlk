object rolando {
	
	var armadura
	var hechizoPreferido = hechizoBasico
	var valorBaseDeLucha = 1
	var valorBaseDeRefuerzo = 2
	const artefactos = []
	
	method armadura() = armadura
	method armadura(nuevaArmadura) {
		self.artefactos().remove(armadura)
		armadura = nuevaArmadura
		self.artefactos().add(nuevaArmadura)
	}
	
	method hechizoPreferido() = hechizoPreferido
	method hechizoPreferido(nuevoHehizoPreferido) {
		hechizoPreferido = nuevoHehizoPreferido
	}
	
	method valorBaseDeLucha() = valorBaseDeLucha
	method valorBaseDeLucha(nuevoValor) {
		valorBaseDeLucha = nuevoValor
	}
	
	method valorBaseDeRefuerzo() = valorBaseDeRefuerzo
	method valorBaseDeRefuerzo(nuevoValor) {
		valorBaseDeRefuerzo = nuevoValor
	}
	
	method artefactos() = artefactos
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
	
	method nivelDeHechiceria() = (3 * self.hechizoPreferido().poder()) + fuerzaOscura.valor()
	
	method teCreesPoderoso() = self.hechizoPreferido().sosPoderoso()
	
	method habilidadDeLucha() = self.valorBaseDeLucha() + self.artefactos().sum({artefacto => artefacto.unidadesDeLucha(self.nivelDeHechiceria(), self.artefactos())})
	
	method sosMejorLuchadorQueHechicero() = self.habilidadDeLucha() > self.nivelDeHechiceria()
	
	method refuerzo() = self.valorBaseDeRefuerzo() + self.armadura().unidadesDeLucha(self.nivelDeHechiceria(), self.artefactos())
	
	method estasCargado() = self.artefactos().size() >= 5

}


object espectroMalefico{
	
	const nombre = "Espectro malefico"
	
	method nombre() = nombre
	method nombre(nuevoNombre) {
		self.nombre().clear()
		self.nombre().addAll(nuevoNombre)
	}

	method poder() = self.nombre().size()
	
	method sosPoderoso() = self.poder() > 15
	
	method unidadesDeLucha(nivelDeHechiceria, artefactos) = nivelDeHechiceria

}


object hechizoBasico{
	
	var poder = 10
	
	method poder() = poder
	method poder(nuevoValor) {
		poder = nuevoValor
	} //capas no haga falta este method
	
	method sosPoderoso() = false
	
	method unidadesDeLucha(nivelDeHechiceria, artefactos) = nivelDeHechiceria
	
}


object fuerzaOscura {
	
	var valor = 5
	
	method valor() = valor
	method valor(nuevoValor) { 
		valor = nuevoValor
	}
	
	method eclipse() {
		self.valor( self.valor() * 2 )
	}
	
}


object espadaDelDestino {
	
	method unidadesDeLucha(nivelDeHechiceria, artefactos) = 3
	
}

object collarDivino{
	var perlas = 0
	
	method perlas() = perlas
	method perlas(cantidadDePerlas){
		perlas = cantidadDePerlas
	}
	
	method unidadesDeLucha(nivelDeHechiceria, artefactos) = self.perlas()
	
}

object mascaraOscura{
	
	method unidadesDeLucha(nivelDeHechiceria, artefactos) = 4.max(fuerzaOscura.valor() / 2)
	
}

object cotaDeMalla {
	
	method unidadesDeLucha(nivelDeHechiceria, artefactos) = 1
	
}

object bendicion {
	
	method unidadesDeLucha(nivelDeHechiceria, artefactos) = nivelDeHechiceria
	
}

object espejo {
	
	method unidadesDeLucha(nivelDeHechiceria, artefactos) {
		artefactos.remove(self)
		return artefactos.max({artefacto => artefacto.unidadesDeLucha(nivelDeHechiceria, artefactos)}).unidadesDeLucha(nivelDeHechiceria, artefactos)
		artefactos.add(self)
	}

}

object libroDeHechizos {
	
	const hechizos = []
	
	method hechizos() = hechizos
	method agregaHechizo(hechizo) {
		self.hechizos().add(hechizo)
	}
	
	method poder() = self.hechizos().sum({hechizo => hechizo.poder()})

}

//fin