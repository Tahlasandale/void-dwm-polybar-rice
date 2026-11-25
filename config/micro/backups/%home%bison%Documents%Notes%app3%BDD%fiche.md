> Fiche bdd preparatiore qcm1

## MCD ( MERISE )
- entitee / attribut / association
- Cardinalités
	- 0,1
	- 1,1
	- 0,n
	- n,n

>Les concepts clés du MCD s'articulent autour de trois notions fondamentales :
>   L'Entité : C'est l'équivalent d'une table en PostgreSQL. Elle représente un objet du monde réel (par exemple : Client, Produit, Commande).
>   L'Attribut : C'est l'équivalent d'une colonne ou d'un champ (par exemple, pour l'entité Client, les attributs sont nom, prenom, email).
>   L'Association : C'est un lien logique entre deux ou plusieurs entités (par exemple, un client passe une commande).

## UML
- classe = entité, nom de la chose
- attributs
- association = trait qui relie les classes
- methodes ( actions que l'objet peut faire)
- multiplicité = cardinalité mais notation 0..1, 1..* * 1..1?
- pas sur que cxa se note dans le meme ordre

> En UML, pour modéliser des données, on utilise principalement le Diagramme de classes. C'est le cousin direct du MCD, mais avec une syntaxe légèrement différente.
>    La Classe : Elle remplace l'entité. Elle est représentée par un rectangle divisé en trois parties :
>        En haut : Le nom de la classe (ex: Client).
>        Au milieu : Les attributs (ex: - nom : String).
>        En bas : Les méthodes (les actions que l'objet peut faire, ex: + seConnecter()). En base de données, cette partie est souvent vide.
>    L'Association : C'est le trait qui relie deux classes.
>    La Multiplicité : C'est l'équivalent exact des cardinalités de Merise, mais notée différemment (ex: 0..1, 1..* ou * pour dire "plusieurs").


