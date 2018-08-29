object rolando {
	
	var hechizoPreferido = hechizoBasico
	
	
	method hechizoPreferido() = hechizoPreferido
	method hechizoPreferido(nuevoHehizoPreferido) {
		hechizoPreferido = nuevoHehizoPreferido
	}
	
	method nivelDeHechiceria() = (3 * hechizoPreferido.poder()) + fuerzaOscura.valor()
	
	method seCreePoderoso() = hechizoPreferido.sosPoderoso()
	
	
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













//fin
