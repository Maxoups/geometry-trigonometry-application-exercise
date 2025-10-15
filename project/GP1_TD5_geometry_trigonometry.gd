extends Node



"""
Appuyer sur F5 pour lancer un test.
Dans le test, appuyer sur Tab pour afficher/enlever les données de la grille.
Les exercices se joueront automatiquement.

FONCTIONS POUR VOUS AIDER:
	
	sin(r) 
		Donne le sinus de l'angle r en radians
	
	cos(r)
		Donne le cosinus de l'angle r en radians
	
	acos(c)
		Donne l'angle r dont cos(r) = c
	
	asin(s)
		Donne l'angle r dont sin(r) = s
	
	tan(r)
		Donne la tangente de l'angle r en radians
	
	atan2(y, x)
		Donne l'angle de tangente x, y
	
	lerp_angle(a, b, weight)
		Interpolation entre l'angle a et l'angle b de poids weight. On a:
		lerp_angle(a, b, 0.0) = a, lerp_angle(a, b, 1.0) = b,
		lerp_angle(a, b, 0.4) = (a*0.6 + b*0.4)/2.0
	
	sqrt(x) 
		Donne la racine carrée de x >= 0.0
	
	pow(x, i)
		Élève x à la puissance i
	
	Vector2(a, b).normalized() 
		Donne un vecteur de norme 1 colinéaire au vecteur Vector2(a, b)
	
	Vector2(a, b).angle_to(Vector2(c, d))
		Retourne l'angle entre le Vecteur(A, B) et le Vecteur(C, D)
	
	Vector2(a, b).distance_to(Vector2(c, d))
		Retourne la distance entre les deux points (a, b) et (c, d).
	
	Vector2(a, b).direction_to(Vector2(c, b))
		Retourne la direction (vecteur normalisé) du point (a, b) vers le point (c, d)

"""



####### EXERCICE 1 #############################################################
# Faire naviguer l'ExplorerShip jusqu'à son objectif

# Interpoler la position de l'objet
func lerp_object_position(initial_position : Vector2, final_position : Vector2, 
						speed : float, current_time : float) -> Vector2:
	# Votre code ici
	return Vector2.ZERO


# Interpoler la rotation de l'objet pour qu'il garde une orientation correcte
# selon sa cible.
# Bonus: Faire une interpolation fluide vers l'angle cible
func lerp_object_rotation(object_rotation : float, object_position : Vector2,
							target_position : Vector2) -> float:
	# Votre code ici
	return 0.0



####### EXERCICE 2 #############################################################
# Décrire l'orbite d'un stallite

# Calculer les paramètre de l'orbite d'un satellite (qu'=e l'on suppose être 
# toujours un cercle parfait).
func get_satellite_orbit_parameters(orbit_center : Vector2, orbit_duration : float,
									satellite_position : Vector2) -> Dictionary[String, float]:
	# Votre code ici
	return  {
		"radius"        : 0.0,
		"speed"         : 0.0,
		"starting_angle" : 0.0
		}


# Calculer la position et la rotation d'un satellite sur son orbite selon un 
# angle donné.
# Attention au rayon de l'orbite : c'est un vecteur (x, y). La trajectoire
# décrite peut donc être une ellipse si x != y !
func get_satellite_orbit_transform(orbit_center : Vector2, starting_angle : float,
		orbit_radius : Vector2, orbit_duration : float, current_time : float) -> Transform2D:
	# Votre code ici
	return Transform2D(
		0.0,          # satellite rotation
		Vector2.ZERO  # stallite position
	)



####### EXERCICE 3 #############################################################
# Faire tourner le MotherShip vers l'asteroïde obstacle de l'ExplorerShip.

# Recréer la fonction angle_to()
func get_angle_to(object : Vector2, target : Vector2) -> float:
	# Votre code ici
	return 0.0



####### EXERCICE 4 #############################################################
# Détruire l'astéroïde obstacle

# Recréer la fonction get_direction_to()
# Pensez à bien retourner un vecteur NORMALISÉ!
func get_direction_to(origin : Vector2, target : Vector2) -> Vector2:
	# Votre code ici
	return Vector2.ZERO


# Donner la velocity = (direction * speed) du missile
# Bonus: utiliser current_velocity pour donner une accélération à l'objet. 
#      Si vous faites le bonus, pensez à retirer "_" de l'argument "_current_velocity".
func get_velocity(position : Vector2, target_position : Vector2, speed : float, 
							delta : float, current_velocity : Vector2) -> Vector2:
	# Votre code ici
	return Vector2.ZERO



####### EXERCICE 5 #############################################################
# Générer procéduralement les astéroïdes

# Tracer un polygone régulier selon un rayon et un nombre de côtés
func generate_regular_polygon(radius : float, number_of_sides : int) -> PackedVector2Array:
	if number_of_sides < 3:
		print_debug("number_of_sides must be at least 3")
		return []
	if radius <= 0.0:
		print_debug("radius must be > 0")
		return []
	# Votre code ici
	return []


# Tracer un polygone quelconque selon un nombre de côtés, un rayon exterieur et un
# rayon intérieur. Tous les points du polygons doivent être entre les deux rayons.
func generate_random_polygon(external_radius : float, internal_radius : float,
							number_of_sides : int) -> PackedVector2Array:
	if number_of_sides < 3:
		print_debug("number_of_sides must be at least 3")
		return []
	if internal_radius <= 0.0 or external_radius <= internal_radius:
		print_debug("Invalid radius values: external must be > internal > 0")
		return []
	# Votre code ici
	return []



####### EXERCICE 6 #############################################################
# Détruire un astéroïde

# Fracturer un polygone en un nombre de fragments donnés ;
# Par simplicité, on peut donner qu'un fragment est un triangle, composé d'un point
# dans le polygone commun à tous les fragments, et de deux points sur la bordure du
# polygone.
# BONUS : Utiliser un diagramme de Voronoi (plutôt complexe, déconseillé pour l'instant)
func shatter_polygon(polygon: PackedVector2Array, nb_fragments : int) -> Array[Vector2]:
	if polygon.size() < 3 or nb_fragments <= 0:
		return []
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	# Votre code ici
	return []


# Calcul du centre et de l'aire d'un polygone
func centroid_and_area(polygon: PackedVector2Array) -> Dictionary:
	# Votre code ici
	return {
		"centroid" : Vector2.ZERO,
		"area" : 0.0
	}


# Calcul de la vélocité d'un fragment explosé (utiliser centroid_and_area)
func explode_fragment(asteroid_polygon : PackedVector2Array, asteroid_position : Vector2,
				fragment_polygon : PackedVector2Array, impact_point : Vector2, 
				force : float) -> Vector2:
	# Votre code ici
	return Vector2.ZERO
