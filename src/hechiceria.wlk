import Rolando.*
import Artefactos.*


class Hechizo {
	
	method poder() = 10
	
	method sosPoderoso() = self.poder() > 15
	
	method unidadesDeLucha(propietario) = self.poder()
	
	method precio() = self.poder()
	
	method precio(armadura) = armadura.valorBaseDeRefuerzo() + self.precio()
	
	method pesas() = if (self.poder().even()) {2} else {1}
	
}

class Logos inherits Hechizo {

	var property constanteProporcionalDeHechizo = 1

	var property nombre = ""

	override method poder() = self.constanteProporcionalDeHechizo() * self.nombre().size()

}

class HechizoComercial inherits Logos {
	
	var property porcentaje = 20
	
	override method poder() =  (self.porcentaje() / 100) * super()
}

object hechizoBasico inherits Hechizo {}

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
	
	override method pesas() = 0

}
