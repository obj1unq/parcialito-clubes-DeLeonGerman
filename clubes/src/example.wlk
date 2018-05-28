
object sistemaClubes{
	var valorSistemaEstrella
	method sancionarClub(club)
	{
		club.recibirSancionIntegral()
	}
	method sancionarActividad(club,unaActividad)
	{
		club.recibirSancion(unaActividad)
	}
	method reanudarActividad(club,unaActividad)
	{
		club.reanudarActividad(unaActividad)
	}
	method cantidadDeSancionesEquipo(equipo)
	{
		return equipo.cantidadDeVecesSancionado()
	}
	method actividadSancionada(actividad)
	{
		return actividad.sancionada()
	}
	method evaluarActividad(actividad)
	{
		actividad.evaluacionActividad()
		return actividad.unidadesEvaluacion()
	}
	method evaluarClub(club)
	{
		club.serEvaluado()
	}
	method valorSistemaEstrella()
	{
		return valorSistemaEstrella
	}
	method valorSistemaEstrella(unValor)
	{
	 valorSistemaEstrella = unValor
	}
	method sociosDestacados(club)
	{
		return club.capitanUOrganizador()
	}
	method sociosDestacadosYEstrellas(club)
	{
		return self.sociosDestacados(club).filter({unSocio => unSocio.soyEstrella(unSocio)})	
	}
	method equipoExperimentado(equipo)
	{
		equipo.plantel().all({unJugador => unJugador.cantidadPartidos()>=10})
	}
}
class Club{
	var perfil
	var actividades
	var socios
	var gastoMensual
	var sistema
	method esEstrella(socio)
	{
		return perfil.esEstrella()
	}
	method evaluacionActividad(){

	}
	method perfil()
	{
		return perfil
	}
	method recibirSancion()
	
	method recibirSancionIntegral()
	{
		if(socios < 500)
		{
			actividades.forEach
			({unaActividad => unaActividad.recibirSancion()
			})
		}
	}
	method reanudarActividad(unaActividad)
	method serEvaluado()
	{
		return self.evaluacionBruta()/socios
	}
	method evaluacionBruta()
	{
		return perfil.evaluacionBruta()
	}
	method gastoMensual(unGasto)
	{
		gastoMensual = unGasto
	}
	method integrantesActividades()
	{
		return  actividades.map
		({unaActividad => unaActividad.integrantesActividades()}).flatten()
	}
	method capitanUOrganizador()
	{
		return actividades.
		map({unaActividad => unaActividad.capitanUOrganizador()})
	}
}
class ClubProfesional inherits Club
//COMENTARIO
//Creo que el metodo esEstrella de esta clase , rompe el polimorfismo
//en alguna parte del codigo	

   {override method esEstrella(socio)
	{
		return socio.valorPase() > sistema.valorSistemaEstrella()
	}
	override method evaluacionBruta()
	{
		return actividades.forEach
		({unaActividad => unaActividad.evaluacionActividad()})
		.map({unaActividad =>unaActividad.unidadesEvaluacion()})
		.sum() *2 - gastoMensual * 	5
	}
}
class ClubTradicional inherits Club
{	
	override method esEstrella(socio)
	{
		return socio.valorPase() >sistema.valorSistemaEstrella()
		       || self.integrantesActividades().ocurrenceOf(socio) >= 3
	}
	override method evaluacionBruta()
	{
		return actividades.forEach
		({unaActividad => unaActividad.evaluacionActividad()})
		.map({unaActividad =>unaActividad.unidadesEvaluacion()})
		.sum() - gastoMensual 
	}
}
class ClubComunitario inherits Club
{
	override method esEstrella(socio)
	{
		return self.integrantesActividades().ocurrenceOf(socio) >= 3
	}
	override method evaluacionBruta()
	{
		return actividades.forEach
		({unaActividad => unaActividad.evaluacionActividad()})
		.map({unaActividad =>unaActividad.unidadesEvaluacion()})
		.sum()
	}
}
class Socio{
	
	var club
	var aniosDeSocio
	
	method esEstrella(socio)
	{
		return aniosDeSocio > 20
	}
	method aniosDeSocio(anios)
	{
		aniosDeSocio= anios
	}
}

class Jugador inherits Socio{
	var valorPase
	var cantidadPartidos
	
	override method esEstrella(socio)
	{
		return cantidadPartidos >= 50 ||self.menosDe50Partidos(club)
	}
	method menosDe50Partidos(club)
	{
		return club.perfil().esEstrella(self)
	}
}

class Equipo inherits Club	 {
	var plantel
	var capitan
	var cantidadDeVecesSancionado
	var campeonatos
	var unidadesEvaluacion
	
	override method recibirSancion()
	{
		cantidadDeVecesSancionado +=1
	}
	method cantidadDeVecesSancionado()
	{
		return cantidadDeVecesSancionado
	}
	method unidadesPorCampeonato()
	{
		return campeonatos * 5
	}
	method unidadesPorMiembro()
	{
		return 	plantel.size() * 2  
	}
	method capitanEstrella()
	{
		return capitan.esEstrella(capitan)
	}
	method unidadesPorSancion()
	{
		return cantidadDeVecesSancionado * 20
	}
	override method evaluacionActividad()
	{
		if(self.capitanEstrella())
		{
			unidadesEvaluacion += 5
		}
		unidadesEvaluacion += self.unidadesPorMiembro()
		unidadesEvaluacion += self.unidadesPorCampeonato()
		unidadesEvaluacion -= self.unidadesPorSancion()
	}
	method unidadesEvaluacion()
	{
		return unidadesEvaluacion
	}
	override method integrantesActividades()
	{
		return plantel
	}
	override method capitanUOrganizador()
	{
		return capitan
	}
}
class EquipoFutbol inherits Equipo
{
	override method unidadesPorMiembro()
	{
	  return plantel.filter({unJugador=>unJugador.esEstrella(unJugador)})
	  .size() * 5 + plantel.filter({unJugador=>not unJugador.esEstrella(unJugador)})
	  .size() * 2
	}
	override method unidadesPorSancion()
	{
		return cantidadDeVecesSancionado *30
	}
}
class ActividadSocial inherits Club{
	var participantes
	var organizador
	var sancionado
	var unidadesEvaluacion
	override method recibirSancion()
	{
		sancionado = true
	}
	override method reanudarActividad(unaActividad)
	{
		sancionado = false
	}
	method sancionado()
	{
		return sancionado	
	}
	override method evaluacionActividad()
	{
		if(self.sancionado())
		{
			unidadesEvaluacion = 0
		}
	}
	method unidadesEvaluacion()
	{
		return unidadesEvaluacion
	}
	method unidadesPorActividadSocial(unValor)
	{
		unidadesEvaluacion = unValor
	}
	override method integrantesActividades()
		{
			return participantes
		}
	override method capitanUOrganizador()
	{
		return organizador
	}
}


