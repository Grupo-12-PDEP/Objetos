object rolando {
	
	var hechizoPreferido = hechizoBasico
	var valorBaseDeLucha = 1
	var artefactos = []
	
	method hechizoPreferido() = hechizoPreferido
	method hechizoPreferido(nuevoHehizoPreferido) {
		hechizoPreferido = nuevoHehizoPreferido
	}
	
	method valorBaseDeLucha() = valorBaseDeLucha
	method valorBaseDeLucha(nuevoValor) {
		valorBaseDeLucha = nuevoValor
	}
	
	method artefactos() = artefactos
	method artefactos(nuevaLista) {
		artefactos = nuevaLista
	}
	
	method agregarArtefacto(nuevoArtefacto){
		self.artefactos(self.artefactos() + [nuevoArtefacto])
	}
	
	method removerArtefacto(viejoArtefacto){
		self.artefactos(self.artefactos() - [viejoArtefacto])
	}
	
	method nivelDeHechiceria() = (3 * self.hechizoPreferido().poder()) + fuerzaOscura.valor()
	
	method seCreePoderoso() = self.hechizoPreferido().sosPoderoso()
	
	method habilidadDeLucha() = self.valorBaseDeLucha() + self.artefactos().sum({artefacto => artefacto.unidadesDeLucha()})
	
	method esMejorLuchadorQueHechicero() = self.habilidadDeLucha() > self.nivelDeHechiceria()
	
}


object espectroMalefico{
	
	var nombre = "Espectro malefico"
	
	method nombre() = nombre
	method nombre(nuevoNombre) {
		nombre = nuevoNombre
	}

	method poder() = self.nombre().size()
	
	method sosPoderoso() = self.nombre().size() > 15

}


object hechizoBasico{
	
	var poder = 10
	
	method poder() = poder
	method poder(nuevoValor) {
		poder = nuevoValor
	} //capas no haga falta este method
	
	method sosPoderoso() = false
	
}


object fuerzaOscura {
	
	var valor = 5
	
	method valor() = valor
	method valor(nuevoValor) { valor = nuevoValor }
	
	method eclipse() {
		self.valor( self.valor() * 2 )
	}
	
}


object espadaDelDestino {
	
	method unidadesDeLucha() = 3
	
}

object collarDivino{
	var perlas = 0
	
	method perlas() = perlas
	method perlas(cantidadDePerlas){
		perlas = cantidadDePerlas
	}
	
	method unidadesDeLucha() = self.perlas()
}

object mascaraOscura{
	
	method unidadesDeLucha() = 4.max(fuerzaOscura.valor() / 2)
}






//fin
