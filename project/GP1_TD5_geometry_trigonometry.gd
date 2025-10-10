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
	var dist : float = initial_position.distance_to(final_position)
	var total_time : float = dist / speed
	var progress : float = min(1.0, current_time / total_time)
	return initial_position * (1-progress) + final_position * (progress)
	# Votre code ici
	return Vector2.ZERO


# Interpoler la rotation de l'objet pour qu'il garde une orientation correcte
# selon sa cible.
# Bonus: Faire une interpolation fluide vers l'angle cible
func lerp_object_rotation(object_rotation : float, object_position : Vector2,
							target_position : Vector2) -> float:
	var dir := (target_position - object_position).normalized()
	if dir.length() == 0.0:
		return object_rotation
	var target_angle := atan2(dir.y, dir.x)
	# Bonus: Interpolation fluide vers l'angle cible (rotation progressive)
	var rotate_speed := 3.0  # facteur de lissage (plus grand = plus rapide)
	var new_rotation := lerp_angle(object_rotation, target_angle, get_process_delta_time() * rotate_speed)
	return new_rotation
	
	# Votre code ici
	return 0.0



####### EXERCICE 2 #############################################################
# Décrire l'orbite d'un stallite

# Calculer les paramètre de l'orbite d'un satellite (qu'=e l'on suppose être 
# toujours un cercle parfait).
func get_satellite_orbit_parameters(orbit_center : Vector2, orbit_duration : float,
									satellite_position : Vector2) -> Dictionary[String, float]:
	var radius_vec := satellite_position - orbit_center
	var radius := radius_vec.length()
	var starting_angle := radius_vec.angle()
	var speed := TAU / orbit_duration # TAU = 2 PI
	return {
		"radius": radius,
		"speed": speed,
		"starting_angle": starting_angle
	}
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
	var current_angle := starting_angle + (current_time / orbit_duration) * TAU
	var current_pos := orbit_center + Vector2(
		cos(current_angle) * orbit_radius.x,
		sin(current_angle) * orbit_radius.y
	)
	# Calcul du vecteur de vélocité à l'instant t (dérivée de la position)
	var vel := Vector2(
		-sin(current_angle) * orbit_radius.x,
		 cos(current_angle) * orbit_radius.y
	)
	# Calcul de l'orientation du satellite (tangente de la vitesse)
	var rotation := vel.angle()
	return Transform2D(rotation, current_pos)
	# Votre code ici
	return Transform2D(
		0.0,          # satellite rotation
		Vector2.ZERO  # stallite position
	)



####### EXERCICE 3 #############################################################
# Faire tourner le MotherShip vers l'asteroïde obstacle de l'ExplorerShip.

# Recréer la fonction angle_to()
func get_angle_to(object : Vector2, target : Vector2) -> float:
	# Vecteurs relatifs
	var diff := target - object
	
	# Retourner l’angle absolu entre (1,0) et diff
	return atan2(diff.y, diff.x)
	# Votre code ici
	return 0.0



####### EXERCICE 4 #############################################################
# Détruire l'astéroïde obstacle

# Recréer la fonction get_direction_to()
# Pensez à bien retourner un vecteur NORMALISÉ!
func get_direction_to(origin : Vector2, target : Vector2) -> Vector2:
	var dir := target - origin
	if dir.length() == 0.0:
		return Vector2.ZERO
	return dir.normalized()
	# Votre code ici
	return Vector2.ZERO


# Donner la velocity = (direction * speed) du missile
# Bonus: utiliser current_velocity pour donner une accélération à l'objet. 
#      Si vous faites le bonus, pensez à retirer "_" de l'argument "_current_velocity".
func get_velocity(position : Vector2, target_position : Vector2, speed : float, 
							delta : float, current_velocity : Vector2) -> Vector2:
	# Direction normalisée vers la cible
	var direction := get_direction_to(position, target_position)
	# Vitesse cible instantanée
	var desired_velocity := direction * speed * delta
	# BONUS : Interpolation lissée pour simuler l'accélération
	var acceleration := 0.45  # facteur d’accéleration
	var new_velocity := current_velocity.lerp(desired_velocity, acceleration * delta)
	return new_velocity
	# Votre code ici
	return Vector2.ZERO



####### EXERCICE 5 #############################################################
# Générer procéduralement les astéroïdes

# Tracer un polygone régulier selon un rayon et un nombre de côtés
func generate_regular_polygon(radius : float, number_of_sides : int) -> PackedVector2Array:
	if number_of_sides < 3:
		push_error("number_of_sides must be at least 3")
		return []
	if radius <= 0.0:
		push_error("radius must be > 0")
		return []
	
	var points: PackedVector2Array = PackedVector2Array()
	var angle_step := (TAU) / float(number_of_sides) # TAU = PI * 2
	# Optionnel : démarrer en haut (−PI/2) pour que le premier sommet soit vers le haut
	var start_angle := -PI * 0.5
	for i in range(number_of_sides):
		var a := start_angle + angle_step * i
		var p := Vector2(cos(a), sin(a)) * radius
		points.append(p)
	return points

	# Votre code ici
	return []


# Tracer un polygone quelconque selon un nombre de côtés, un rayon exterieur et un
# rayon intérieur. Tous les points du polygons doivent être entre les deux rayons.
func generate_random_polygon(external_radius : float, internal_radius : float,
							number_of_sides : int) -> PackedVector2Array:
	if number_of_sides < 3:
		push_error("number_of_sides must be at least 3")
		return []
	if internal_radius <= 0.0 or external_radius <= internal_radius:
		push_error("Invalid radius values: external must be > internal > 0")
		return []
	
	var points: PackedVector2Array = PackedVector2Array()
	var angle_step := (TAU) / float(number_of_sides) # TAU = PI * 2
	var start_angle := -PI * 0.5  # pour commencer vers le haut
	for i in range(number_of_sides):
		var a := start_angle + angle_step * i
		a += randf_range(-angle_step * 0.1, angle_step * 0.1) # irrégularité sur l'angle
		# Rayon aléatoire entre les deux bornes
		var r := randf_range(internal_radius, external_radius)
		var p := Vector2(cos(a), sin(a)) * r
		points.append(p)
	return points
	# Votre code ici
	return []



####### EXERCICE 6 #############################################################
# Détruire un astéroïde

# Fracturer un polygone en un nombre de fragments donnés ;
# Par simplicité, on peut donner qu'un fragment est un triangle, composé d'un point
# dans le polygone commun à tous les fragments, et de deux points sur la bordure du
# polygone.
# BONUS : Utiliser un diagramme de Voronoi (plutôt complexe, déconseillé pour l'instant)
func shatter_polygon(polygon: PackedVector2Array, nb_fragments : int) -> Array:
	if polygon.size() < 3 or nb_fragments <= 0:
		return []
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	
	# Les seeds sont les points utilisés ensuite pour la découpe du polygone
	var seeds: Array[Vector2] = _sample_points_in_polygon(polygon, nb_fragments, rng)
	var poly_arr: Array[Vector2] = []
	for v in polygon:
		poly_arr.append(v)
	
	var fragments: Array = []
	for i in range(seeds.size()):
		var cell : Array[Vector2] = poly_arr.duplicate()
		var si: Vector2 = seeds[i]
		for j in range(seeds.size()):
			if i == j:
				continue
			var sj: Vector2 = seeds[j]
			var normal := sj - si
			var C := (sj.dot(sj) - si.dot(si)) * 0.5
			cell = _clip_by_halfplane(cell, normal, C)
			if cell.size() < 3:
				break
		if cell.size() >= 3:
			var packed := PackedVector2Array()
			for v in cell:
				packed.append(v)
			fragments.append(packed)
	
	return fragments


# Helper: obtient un échantillon de points "aléatoires" dans le polygone
# nom de l'algo -> rejection sampling
func _sample_points_in_polygon(polygon: PackedVector2Array, n: int, 
								rng: RandomNumberGenerator) -> Array[Vector2]:
	var pts: Array[Vector2] = []
	
	var xmin := INF
	var xmax := -INF
	var ymin := INF
	var ymax := -INF
	
	for v in polygon:
		xmin = min(xmin, v.x)
		xmax = max(xmax, v.x)
		ymin = min(ymin, v.y)
		ymax = max(ymax, v.y)
	
	var attempts := 0
	while (pts.size() < n) and (attempts < n * 5000):
		attempts += 1
		var p := Vector2(rng.randf_range(xmin, xmax), rng.randf_range(ymin, ymax))
		if _point_in_polygon(p, polygon):
			pts.append(p)
	
	return pts


# Helper: retourne si un point est dans le polygon donné
func _point_in_polygon(pt: Vector2, polygon: PackedVector2Array) -> bool:
	var inside := false
	var m := polygon.size()
	for i in range(m):
		var a := polygon[i]
		var b := polygon[(i + 1) % m]
		if (a.y > pt.y) != (b.y > pt.y):
			var t := (pt.y - a.y) / (b.y - a.y)
			var x := a.x + t * (b.x - a.x)
			if x > pt.x:
				inside = not inside
	return inside

# Helper: découpe le polygone avec un demi-plan
# algo -> Sutherland–Hodgman
func _clip_by_halfplane(poly_in: Array[Vector2], normal: Vector2, C: float) -> Array[Vector2]:
	var out: Array = []
	var m := poly_in.size()
	if m == 0:
		return out
	
	for i in range(m):
		var A := poly_in[i]
		var B := poly_in[(i + 1) % m]
		var va := A.dot(normal) - C
		var vb := B.dot(normal) - C
		var ina := va <= 0.0
		var inb := vb <= 0.0
		
		if ina and inb:
			out.append(B)
		elif ina and not inb:
			var d := vb - va
			if abs(d) > 1e-12:
				var t : float = clamp(-va / d, 0.0, 1.0)
				out.append(A + (B - A) * t)
		elif (not ina) and inb:
			var d2 := vb - va
			if abs(d2) > 1e-12:
				var t2 : float = clamp(-va / d2, 0.0, 1.0)
				out.append(A + (B - A) * t2)
			out.append(B)
	
	# remove duplicates
	var cleaned: Array[Vector2] = []
	for q in out:
		if cleaned.size() == 0 or (cleaned[-1].distance_to(q) > 1e-7):
			cleaned.append(q)
	if cleaned.size() > 1 and cleaned[0].distance_to(cleaned[-1]) < 1e-7:
		cleaned.pop_back()
	
	return cleaned


# Calcul du centre et de l'aire d'un polygone
func centroid_and_area(polygon: PackedVector2Array) -> Dictionary:
	var n := polygon.size()
	var cx := 0.0
	var cy := 0.0
	var a := 0.0
	
	for i in range(n):
		var p0 := polygon[i]
		var p1 := polygon[(i + 1) % n]
		var cross := p0.x * p1.y - p1.x * p0.y
		a += cross
		cx += (p0.x + p1.x) * cross
		cy += (p0.y + p1.y) * cross
	a *= 0.5
	
	var factor := 1.0 / (6.0 * a)
	var centroid := Vector2(cx * factor, cy * factor)
	return {
		"centroid": centroid, 
		"area": abs(a)
	}
	
	# Votre code ici
	return {
		"centroid" : Vector2.ZERO,
		"area" : 0.0
	}


# Calcul de la vélocité d'un fragment explosé (utiliser centroid_and_area)
func explode_fragment(asteroid_polygon : PackedVector2Array, asteroid_position : Vector2,
				fragment_polygon : PackedVector2Array, impact_point : Vector2, 
				force : float) -> Vector2:
	
	var fragment_info := centroid_and_area(fragment_polygon)
	var fragment_centroid : Vector2 = fragment_info["centroid"]
	var fragment_area : float = fragment_info["area"]
	
	# Direction depuis le point d’impact vers le centroïde du fragment
	var dir := asteroid_position + fragment_centroid - impact_point
	var dist := dir.length()
	
	if dist < 0.0001:
		dir = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
		dist = dir.length()
		if dist < 0.0001:
			dir = Vector2(0, -1)
			dist = 1.0
	dir = dir.normalized()
	
	# Atténuation selon la distance
	var distance_scale := 0.02
	var attenuation := 1.0 / (1.0 + dist * distance_scale)
	attenuation = clamp(attenuation, 0.05, 1.0)
	
	# Taille du fragment : plus petit => plus rapide
	var size_factor := sqrt(fragment_area / 8000.0)
	size_factor = clamp(size_factor, 0.6, 4.0)
	
	# Calcul final de la vélocité
	var velocity := dir * force * attenuation * size_factor
	velocity += Vector2(randf_range(-1,1), randf_range(-1,1)) * (force * 0.02)
	return velocity
	
	# Votre code ici
	return Vector2.ZERO
