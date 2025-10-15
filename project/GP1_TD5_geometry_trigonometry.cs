using Godot;
using Microsoft.VisualBasic;
using System;
using System.Collections.Generic;
using System.Security.Cryptography.X509Certificates;


public partial class GP1_TD5_geometry_trigonometry : Node
{
    //####### EXERCICE 1 #############################################################

    // Faire naviguer l'ExplorerShip jusqu'à son objectif
    // Interpoler la position de l'objet
    public Vector2 LerpObjectPosition(Vector2 initialPosition, Vector2 finalPosition, float speed, float currentTime)
    {
        return new Vector2();
    }

    // Interpoler la rotation de l'objet pour qu'il garde une orientation correcte selon sa cible.
    // Bonus: interpolation fluide vers l'angle cible
    public float LerpObjectRotation(float objectRotation, Vector2 objectPosition, Vector2 targetPosition)
    {
        return 0.0f;
    }

    //####### EXERCICE 2 #############################################################
    // Décrire l'orbite d'un satellite (on suppose cercle parfait)

    // Calculer les paramètres de l'orbite
    public Godot.Collections.Dictionary<String, float> GetSatelliteOrbitParameters(Vector2 orbitCenter, float orbitDuration, Vector2 satellitePosition)
    {
        var dict = new Godot.Collections.Dictionary<String, float>
        {
            ["radius"] = 0.0f,
            ["speed"] = 0.0f,
            ["starting_angle"] = 0.0f
        };
        return dict;
    }

    // Calculer la position et la rotation d'un satellite sur son orbite selon un angle donné.
    public Transform2D GetSatelliteOrbitTransform(Vector2 orbitCenter, float startingAngle, Vector2 orbitRadius, float orbitDuration, float currentTime)
    {
        return new Transform2D(0.0f, new Vector2());
    }

    //####### EXERCICE 3 #############################################################
    // Faire tourner le MotherShip vers l'asteroïde obstacle de l'ExplorerShip.
    // Recréer la fonction angle_to()
    public float GetAngleTo(Vector2 obj, Vector2 target)
    {
        return 0.0f;
    }

    //####### EXERCICE 4 #############################################################
    // Détruire l'astéroïde obstacle
    // Recréer la fonction get_direction_to() (retourner vecteur normalisé)
    public Vector2 GetDirectionTo(Vector2 origin, Vector2 target)
    {
        return new Vector2();
    }

    // Donner la velocity = (direction * speed) du missile
    // Bonus: utiliser current_velocity pour donner une accélération à l'objet.
    public Vector2 GetVelocity(Vector2 position, Vector2 targetPosition, float speed, float delta, Vector2 currentVelocity)
    {
        return new Vector2();
    }

    //####### EXERCICE 5 #############################################################
    // Générer procéduralement les astéroïdes

    // Tracer un polygone régulier selon un rayon et un nombre de côtés
    public Vector2[] GenerateRegularPolygon(float radius, int numberOfSides)
    {
        if (numberOfSides < 3)
        {
            GD.Print("number_of_sides must be at least 3");
            return new Vector2[0];
        }
        if (radius <= 0.0f)
        {
            GD.Print("Invalid radius values: external must be > internal > 0");
            return new Vector2[0];
        }

        List<Vector2> points = new List<Vector2>();
        return points.ToArray();
    }

    // Tracer un polygone quelconque selon un nombre de côtés, rayon extérieur et intérieur
    public Vector2[] GenerateRandomPolygon(float externalRadius, float internalRadius, int numberOfSides)
    {
        if (numberOfSides < 3)
        {
            GD.Print("number_of_sides must be at least 3");
            return new Vector2[0];
        }
        if (internalRadius <= 0.0f || externalRadius <= internalRadius)
        {
            GD.Print("Invalid radius values: external must be > internal > 0");
            return new Vector2[0];
        }

        List<Vector2> points = new List<Vector2>();
        return points.ToArray();
    }

    //####### EXERCICE 6 #############################################################
    // Détruire un astéroïde - fracturation en nb_fragments

    public float[,] ShatterPolygon(Vector2[] polygon, int nbFragments)
    {
        if (polygon.Length < 3 || nbFragments <= 0)
            return new float[0,0];
        var fragments = new float[0,0];
        return fragments;
    }

    // Calcul de la vélocité d'un fragment explosé (utiliser centroid_and_area)
    public Vector2 ExplodeFragment(Vector2[] asteroidPolygon, Vector2 asteroidPosition, Vector2[] fragmentPolygon, Vector2 impactPoint, float force)
    {
        return new Vector2();
    }
}
