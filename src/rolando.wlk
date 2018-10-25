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
		if (hechizo.precio() - self.hechizoPreferido().precio() / 2 > self.oro()){
			throw new ExcepcionPorDineroInsuficiente("no tenes fondos suficiente para realizar el canje")
		}
		
		self.restateOro( 0.max(hechizo.precio() - self.hechizoPreferido().precio() / 2) )
		self.hechizoPreferido(hechizo)
		
	}
	
	method compra(artefacto) {
		if (artefacto.precio() > self.oro()){
			throw new ExcepcionPorDineroInsuficiente("no tenes fondos suficiente para realizar la compra")
		} 
		
		self.restateOro(artefacto.precio())
		self.agregaArtefacto(artefacto)
	}
	
	
}

class ExcepcionPorDineroInsuficiente inherits Exception{}


object mundo {

	var property fuerzaOscura = 5

	method eclipse() {
		self.fuerzaOscura(self.fuerzaOscura() * 2)
	}

}


		

//fin