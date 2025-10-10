---1. Lister tous les coureurs qui participent à une édition du Tour de France spécifique.
SELECT *
FROM coureur inner join participe on coureur.idcoureur = participe.idcoureur 
WHERE participe.annee = [Veuillez entrer une édition spécifique];



---2. Afficher toutes les étapes pour une édition spécifique du Tour de France, y compris le départ et l'arrivée.
SELECT IdEtape, TypeEtape, DistanceEtape, DateEtape, v1.NomVille AS [Ville de départ], v2.NomVille AS [Ville d'arrivée]
FROM (Etape INNER JOIN Ville AS v1 ON Etape.Ville_depart = v1.CodeVille) INNER JOIN Ville AS v2 ON Etape.Ville_arrive = v2.CodeVille
WHERE Year(Etape.DateEtape) = [Entrer l'année d'édition]
ORDER BY Etape.IdEtape;
---3. Lister les résultats d’un coureur pour une étape spécifique
Select Coureur.nom, competition.*
from coureur inner join competition on coureur.idcoureur=competition.idcoureur
Where Coureur.idcoureur=[Veuillez entrer un coureur spécifique] and competition.idetape = [Veuillez entrer une étape spécifique];

---4. Afficher les coureurs qui n'ont pas abandonné pendant une édition spécifique
SELECT coureur.idcoureur, Coureur.nom, coureur.prenom
FROM coureur INNER JOIN competition ON coureur.idcoureur=competition.idcoureur
WHERE competition.motif_exclusion is null;

---5. Afficher les résultats des coureurs pour une étape donnée, triés par temps de manièredécroissante (du plus long au plus court)
select Competition.*
From coureur inner join competition on coureur.idcoureur=competition.idcoureur
where competition.idetape = [Veuillez entrer une étape spécifique] and date_exclusion is  null
order by TempsRealise desc 


---6. Afficher les résultats d'une équipe dans un Tour spécifique (édition)
SELECT Coureur.IdCoureur, Coureur.Nom, Coureur.Prenom, Competition.TempsRealise
FROM (((Equipe 
INNER JOIN Participe ON Equipe.IdEquipe = participe.IdEquipe) 
INNER JOIN Edition ON participe.Annee = Edition.Annee) 
INNER JOIN Coureur ON participe.IdCoureur = Coureur.IdCoureur) 
INNER JOIN Competition ON Coureur.IdCoureur = Competition.IdCoureur
WHERE Equipe.IdEquipe=[Veuillez saisir un numéro d'équipe] AND Edition.Annee = [Veuillez saisir une année d'édition];


---7. Lister des coureurs exclus d’une étape donnée avec le motif de l'exclusion et la date.
SELECT Coureur.IdCoureur, Coureur.Nom, Coureur.Prenom, Competition.TempsRealise,competition.date_exclusion
FROM (((Equipe INNER JOIN participe ON Equipe.IdEquipe = participe.IdEquipe) 
INNER JOIN Edition ON participe.Annee = Edition.Annee) 
INNER JOIN Coureur ON participe.IdCoureur = Coureur.IdCoureur) 
INNER JOIN Competition ON Coureur.IdCoureur = Competition.IdCoureur
WHERE Equipe.IdEquipe=[Veuillez saisir un numéro d'équipe] AND Edition.Annee = [Veuillez saisir une année d'édition] and competition.date_exclusion is not null ;


---8. Afficher la liste des exclusions de tous les coureurs pour une édition donnée, en détaillant l'étape et le motif de l'exclusion.
SELECT coureur.IdCoureur, Nom, IdEtape, Date_Exclusion, Motif_Exclusion
FROM(( Competition 
INNER JOIN Coureur ON Competition.IdCoureur = Coureur.IdCoureur)
INNER JOIN  participe on  Coureur.IdCoureur = participe.IdCoureur)
INNER JOIN Edition on participe.Annee=Edition.Annee
WHERE Date_Exclusion IS NOT NULL AND Edition.Annee = [Veuillez saisir une année d'édition];



---9. Afficher les coureurs n'ayant pas terminé une étape donnée
SELECT Coureur.*
FROM Coureur
INNER JOIN Competition ON Coureur.IdCoureur = Competition.IdCoureur
WHERE Competition.IdEtape = [veuillez mettre le num d'Etape] and  Competition.TempsRealise IS NULL;


---10. Afficher les étapes où un coureur a terminé dans les 5 premiers
SELECT c.IdCoureur, Nom, IdEtape
FROM(( Competition 
INNER JOIN Coureur  as c ON Competition.IdCoureur = c.IdCoureur)
INNER JOIN  participe on  c.IdCoureur = participe.IdCoureur)
INNER JOIN Edition on participe.Annee=Edition.Annee
where c.IdCoureur = [veuillez mettre le nom du coureur] and c.IdCoureur in (SELECT TOP 5 
    p.IdCoureur
FROM 
    Competition
INNER JOIN 
    Participe AS p ON Competition.IdCoureur = p.IdCoureur
GROUP BY 
    p.IdCoureur
ORDER BY 
    SUM(Competition.TempsRealise) ASC;
 ) 




---11. Afficher le classement par équipe de l’édition du Tour de France
SELECT 
    p.IdEquipe
FROM 
    Competition
INNER JOIN 
    Participe AS p ON Competition.IdCoureur = p.IdCoureur
GROUP BY 
    p.IdCoureur
ORDER BY 
    SUM(Competition.TempsRealise) ASC



---12. Trouver les étapes où un coureur a gagné une étape spécifique (1ère place)
SELECT c.IdCoureur, Nom, IdEtape
FROM(( Competition 
INNER JOIN Coureur  as c ON Competition.IdCoureur = c.IdCoureur)
INNER JOIN  participe on  c.IdCoureur = participe.IdCoureur)
INNER JOIN Edition on participe.Annee=Edition.Annee
where c.IdCoureur = [veuillez mettre le numero du coureur] and c.IdCoureur in (SELECT TOP 1 p.IdCoureur
                                                                            FROM Competition
                                                                            INNER JOIN Participe AS p ON Competition.IdCoureur = p.IdCoureur
                                                                            GROUP BY p.IdCoureur
                                                                            ORDER BY SUM(Competition.TempsRealise) ASC;
                                                                            ) 



---13. Nombre de coureurs par équipe dans une édition spécifique
select IdEquipe ,count(idcoureur) as "Nombre de coureur "
from participe
where Annee=[inserez l'annee d'edition]
group by IdEquipe


---14. Afficher le temps moyen de chaque coureur sur l'ensemble des étapes où il a participé.
select idcoureur,Format(AVG(CDbl([TempsRealise])),"hh:nn:ss") AS TempsMoyen
from competition  
group BY idcoureur

---15. Lister les meilleures performances (meilleurs temps) pour chaque étape du Tour de France.
select idetape,min(TempsRealise) as [Meilleur temps]
from competition  
group by IdEtape

---16. Afficher les positions d'un coureur dans toutes les étapes d'une édition
SELECT C1.IDCoureur,C1.IDEtape,1 + (SELECT COUNT(*)FROM Competition AS C2 WHERE C2.IDEtape = C1.IDEtape AND C2.TempsRealise < C1.TempsRealise) AS Position
FROM Competition AS C1
WHERE C1.IDCoureur = [Veuillez entrer le numéro du coureur]
ORDER BY C1.IDEtape;


---17. Afficher tous les coureurs et leur équipe pour une étape donnée
select p.IdEquipe,p.idcoureur
from (participe as p
inner join coureur  as c on c.idcoureur=p.idcoureur)
inner join competition as com on c.idcoureur =com.idcoureur
where com.idetape = [Entrer une etape]
order by p.IdEquipe

---18. Lister les étapes où un coureur spécifique a été exclu (abandon) et les raisons de son exclusion
select idetape,motif_exclusion from competition where motif_exclusion is not null
---19. Afficher les coureurs ayant participé à toutes les étapes d'une édition
SELECT C.IDCoureur
FROM Competition AS C
GROUP BY C.IDCoureur
HAVING COUNT(*) = (SELECT COUNT(*) FROM (SELECT DISTINCT IdEtape FROM Competition))
---20. Afficher le classement général des coureurs pour une édition spécifique
SELECT p.IdCoureur
FROM Competition
INNER JOIN Participe AS p ON Competition.IdCoureur = p.IdCoureur
where Annee=[Entrez l'annee de l'edition]
GROUP BY p.IdCoureur
ORDER BY SUM(Competition.TempsRealise) ASC

---21. Trouver tous les coureurs qui ont abandonné trois de fois

SELECT C.IDCoureur
FROM Competition AS C
GROUP BY C.IDCoureur
HAVING COUNT(*) = (SELECT COUNT(*) FROM (SELECT DISTINCT IdEtape FROM Competition))-3
---22. Afficher les résultats des coureurs d’une équipe spécifique dans une édition donnée
select IdEquipe,p.idcoureur,Format(SUM(CDbl([TempsRealise])),"hh:nn:ss")  AS [temps total réalise]
from (participe as p
inner join coureur  as c on c.idcoureur=p.idcoureur)
inner join competition as com on c.idcoureur =com.idcoureur
where Annee=[entrez une edition] and IdEquipe=[entrez une equipe]
GROUP BY IdEquipe,p.idcoureur


---23. Vérifier si un coureur a déjà participé à une édition donnée
    SELECT nom, Prenom
FROM Coureur AS c INNER JOIN Participe AS p ON c.IdCoureur = p.IdCoureur
WHERE c.Nom like [Entrez le nom] and c.Prenom like [Entrez le prenom] AND Annee = [Entrez l'année];


---24. Lister les coureurs ayant terminé dans le top 10 d'une étape donnée

SELECT TOP 10
    p.IdCoureur
from (participe as p
inner join coureur  as c on c.idcoureur=p.idcoureur)
inner join competition as com on c.idcoureur =com.idcoureur
where idetape=[entrez le numéro d'etape]

ORDER BY 
TempsRealise ASC;


---25. Trouver les coureurs ayant participé à toutes les étapes d’une édition donnée
SELECT C.IDCoureur
FROM Competition AS C
GROUP BY C.IDCoureur
HAVING COUNT(*) = (SELECT COUNT(*) FROM (SELECT DISTINCT IdEtape FROM Competition))

---26. Lister les étapes où un coureur a eu la meilleure position (meilleur classement) parmi toutes ses participes
SELECT *
FROM [excercice 16]
WHERE Position = (
    SELECT MIN(Position)
    FROM [excercice 16])
---27. Liste des étapes avec leur distance et la moyenne des temps des coureurs sur chaque étape
select idetape,DistanceEtape,Format(AVG(CDbl([TempsRealise])),"hh:nn:ss")
from competition as c 
inner join etape as e on c.idetape = e.idetape
group by idetape,DistanceEtape

---28. Afficher les équipes avec leurs coureurs et leurs résultats cumulés dans une édition spécifique

SELECT p.IdEquipe, p.IdCoureur, Format(SUM(CDbl([TempsRealise])),"hh:nn:ss")
FROM Competition
INNER JOIN Participe AS p ON Competition.IdCoureur = p.IdCoureur
where Annee=[Entrez l'annee de l'edition]
GROUP BY  p.IdEquipe,p.IdCoureur
ORDER BY SUM(Competition.TempsRealise) ASC

---29. Trouver les étapes avec le plus grand nombre de participants (coureurs)
select top 3 idetape,count(idcoureur) as [Nombre de coureur]
from competition
group by idetape
order by count(idcoureur) desc

---30. Lister les coureurs avec le plus grand nombre d'étapes terminées dans le top 10
SELECT top 5 c.IdCoureur,count(idcoureur)
FROM(( Competition 
INNER JOIN Coureur  as c ON Competition.IdCoureur = c.IdCoureur)
INNER JOIN  participe on  c.IdCoureur = participe.IdCoureur)
INNER JOIN Edition on participe.Annee=Edition.Annee
where c.IdCoureur in (SELECT TOP 10 p.IdCoureur
                    FROM Competition
                    INNER JOIN Participe AS p ON Competition.IdCoureur = p.IdCoureur
                    GROUP BY p.IdCoureur
                    ORDER BY SUM(Competition.TempsRealise) ASC;
                    ) 
group by c.idcoureur
order by count(idcoureur) desc
---31. Trouver les étapes où un coureur a amélioré sa position par rapport à l'étape précédente 
