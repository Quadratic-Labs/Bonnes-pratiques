
# INTRODUCTION 

On appelle bonnes pratiques tout ce qui garantit que le produit final soit de bonne qualité. 
La qualité est tout ce qui entoure le produit final au-delà de son simple bon fonctionnement. 
En effet, en informatique, un code fonctionnel n’est pas nécessairement un code de qualité.  
Dans le cadre de R, ces bonnes pratiques sont d’autant plus importantes qu'elles pourraient vous aider à publier des paquets sur le CRAN (dépôt officiel de R), et donc contribuer au modèle open-source de ce langage. 

Dans ce document, je me focalise donc sur les bonnes pratiques appliquées aux langages R. C'est assez sujet large, c’est pourquoi je me concentre sur les axes suivants : 
* Comment produire un code propre 
* Comment optimiser l’exécution de son code 
* Comment choisir la forme du livrable 

# PARTIE 1 : CODER PROPREMENT EN R 

La notion de propreté est commune à tous les langages de programmation, malgré leurs différences (orienté objet ou procédural, de haut ou bas niveau...).  
Un code propre, quel que soit son langage, a les qualités subjectives suivantes :  
* Sa maintenabilité : Il peut être lu et amélioré par un développeur autre que le développeur d’origine 
* Son imperfectibilité : rien de permet de l’améliorer de manière évidente 
* Sa clarté : il demande peu d’effort pour être lu et compris 
* Sa limpidité : il retranscrit parfaitement l’idée d’origine du développeur 

Dans cette partie, je vous présente des moyens pour produire un code qui auraient ces qualités. 

## 1. La propreté du code 

> "La logique doit être simple, pour que les bogues aient du mal à se cacher.  
Les dépendances doivent être minimes afin de faciliter la maintenance. 
La gestion des erreurs doit être totale [...]. 
Les performances doivent être proches de l'idéal [...]. 
Un code propre fait une chose et le fait bien"  
B. STROUSTRUP (humble inventeur du C++)

Avant d’aborder plus précisément les spécificités du langage R, j’aborde d’abord ces principes généraux. 

Les indicateurs de propreté du code ont été discutés par des développeurs renommés. Dans les différents points de vue que l’on peut trouver, on retrouve certaines tendances. Ainsi, un code propre doit être :  
* Explicite : aucune règle n’est implicite. Le lecteur n’a rien à deviner 
* Lisible : les imbrications sont identifiées. Le code est aéré. Les noms des entités sont pertinents. 
* Simple : le code est logique et va à l’essentiel 
* Parcimonieux : aucune opération superflue est présente 
* Non redondant : il n’y a pas 2 parties/fonctions qui réalisent un traitement identique 
* Harmonieux : le style est cohérent tout au long du script (cf. Annexe 1 pour + de détails sur la notion de style, en opposition à la propreté) 

__Le mythe de la reprise à 0 :__  
Pour appliquer ces principes aux scripts existants, il peut être tentant de tenter de le réécrire en partant de 0. En effet, il est plus facile de créer son propre script, que de bien modifier celui de quelqu’un d’autre. Néanmoins il est communément admis que cela n’est pas une bonne idée, y compris si vous êtes un développeur expérimenté. En effet, si le code n’est pas propre, alors les intentions du développeur d’origine ne sont pas claires. Par conséquent, il vous manquerait très probablement des informations pour produire un script au moins aussi fonctionnel que celui de votre prédécesseur.  

Ainsi, pour éviter de reprendre de zéro tous les scripts non propres, je vous propose les 2 règles suivantes : 
* Quand vous travaillez sur un code, quitter le toujours un peu plus propre qu’il ne l’était initialement 
* “Plus tard signifie jamais” : si vous voyez un moyen évident d’améliorer un code, alors prenez le temps de le faire 
De cette manière, le script gagnera progressivement en propreté. 

## 2. Les règles de propreté en R  

A partir des indicateurs précédents, on déduit des règles concrètes appliqués au langage R. A noter que certaines de ces critères sont transposables à d'autres langages, selon qu’il soit proche ou non de R. 

* Respecter les conventions d’indentation
  
  En R, l’indentation du code n'a pas de conséquences sur son exécution. Néanmoins, un script mal indenté perd significativement en lisibilité. De plus, une bonne indentation indique quelles parties du code sont particulièrement imbriqués, et donc qui pourraient bénéficier d’une réécriture. En effet, un code imbriqué est généralement moins lisible qu'un code plat. Pour reprendre le zen de Python (cf. Annexe 2) « Nested is better than flat”. 

* Ecrire des commentaires uniquement s’ils sont irremplaçables
  
  S’ils peuvent être perinentes, les commentaires sont souvent utilisés pour compenser les défauts réels du code. Si le code est propre, alors un développeur n’a pas besoin de commentaires pour le comprendre. Par opposition, le bon commentaire est celui qui ne peut pas remplacé par du code.
  De plus, de nombreux commentaires nuisent à la maintenabilité du code. En effet, les développeurs sont en effet plus réticents à supprimer un commentaire qu’à modifier du code, même si le commentaire en question est énigmatique. (cf. Annexe 3 pour des exemples précis de mauvais commentaires) 

* Utiliser les pipes
  
  Les pipes (ou ‘conduits’ en français) est un type d’opérateur qui permet de construire un 'pipeline', pour appliquer une suite de transformation à un input. Il évite la création de variables purement intermédiaires, tout en rendant le code moins redondant. L'opérateur de type pipe le plus connu est ‘%>%’ du package magrittr. Mais je conseillerais plutôt l’utilisation du pipe natif ‘|>’. Bien qu'il soit moins courant, il a l’avantage d'être légèrement plus rapide que celui de magrittr, tout en évitant une dépendance supplémentaire. 

* Identifier, minimiser, et mettre à jour les paquets importés
  
  Les importations ont tendance à complexifier la maintenance et le déploiement de code. C’est le cas par exemple si une montée de version d’un paquet utilisé engendre des nouveaux comportements non gérés par le code. De plus, le risque de conflits entre paquets augmente logiquement avec le nombre de dépendances. C'est pourquoi je déconseille d’avoir un recours systématique au paquet  dplyr. Bien que pratique et couramment utilisé, il ne reste pas moins une dépendance supplémentaire à gérer.
  Pour minimiser le nombre de dépendances, je conseille d’abord de les identifier en signalant les fonctions importées de cette façon : ‘[paquet]::[methode]’. De cette manière, vous pouvez vérifier si certains paquets importés ne sont plus nécessaires. Ensuite, pour des paquets où seul une ou deux fonctions sont importés, recherchez si des fonctions de R Base pourraient les remplacer. De cette manière, vous pourrez supprimer certaines dépendances. Enfin, pour les dépendances restantes, vérifier que votre code est fonctionnel avec leurs dernières versions. 

* Gérer explicitement les erreurs de lecture/écriture
  
  La lecture et écriture de fichiers utilise des chemins physiques pour localiser des données sur le disque. Ces chemins sont souvent gérés par des chaînes de caractères en un unique bloc. Pour repérer plus facilement les problèmes de fichier non trouvé, je recommande d’utiliser en amont de la lecture les fonctions dir.exits ou file.exist. De plus, pour gagner en lisibilité, je recommande d’utiliser la fonction file.path de R Base, où chaque répertoire du chemin correspond à un argument. Elle est d’autant plus pratique qu’elle fonctionne de manière récursive. 

* Pas de codage dynamique
  
  Le codage dynamique fait référence à l’utilisation de chaînes de caractères consistant en des instructions ou des noms de variables. En R, il se manifeste notamment par la présence des fonctions suivantes :
  * eval et parse pour gérer les chaînes de caractère comme des instructions 
  * get et assign pour gérer les chaînes de caractère comme des noms de variable

  N’utilisez jamais ces méthodes. En effet, elles rendent particulièrement laborieuses le débogage des scripts. C'est pourquoi si vous les trouvez dans un script existant, je vous déconseille fortement de le modifier. Il peut exister des cas rares où cela est pertinent. Mais dans 99% des cas, elles sont substituables.  

* Ne pas utiliser ‘$’ pour référencer les colonnes d’un tableau
  
  Avec les data.frames (la structure de table de base), il existe 2 moyens de manipuler une colonne comme un vecteur : soit avec des crochets (Table1[[« nom_colonne1 »]]), soit un symbole dollar (Table1$nom_colonne1). Parmi ces 2 possibilités, je conseille d’utiliser plutôt les crochets. En effet, l’opérateur ‘$’ fait implicitement de l’auto-complétion. Par conséquent, si le nom de la colonne après le symbole ‘$’n’existe pas, alors il peut malgré tout retourner les valeurs d’une autre colonne. 

 

## 3. Gestion des fonctions  

J’aimerais aborder certains critères spécifiques aux fonctions. L’écriture des fonctions est un processus itératif. Quand vous écrivez une nouvelle fonction, il est normal que celle-ci ne soit pas propre dans sa première version. L’objectif du développeur consistera à faire plusieurs passes sur cette fonction pour qu’elle adhère progressivement à certains critères. C’est pourquoi il existe trois règles essentielles les concernant : 

1ère règle : **"Une fonction ne fait qu’une seule chose, et le fait bien"**

Cette phrase implique que : 
* Le nom de la fonction énonce clairement ce qu’elle est sensée faire 
* Chaque fonction est associée à un niveau d’abstraction. Le vocabulaire employé pour nommer la fonction et ses variables locales doit être cohérent avec le lexique de ce niveau. Par exemple, une fonction de haut niveau utilisera un vocabulaire en lien avec métier, tandis qu’une fonction de bas niveau utilisera un vocabulaire en lien avec le hardware 
* Une fonction ne doit pas produire d’effet de bords, c’est-à-dire d’autres effets que ce que celui qu’il est sensé produire 
* Ne pas avoir d’arguments indicateurs, c’est-à-dire d’arguments booléens qui changeraient le rôle de la fonction. Ce type d’argument indique qu’il vous faut probablement non pas une, mais deux fonctions. 
* Des tests unitaires doivent vérifier si la fonction remplie bien son unique objectif, y compris dans les cas particuliers 
* Le nombre de fonction dans un script est souvent important, et cela n’est pas un problème 

2ème règle : **"Ecrire des fonctions courtes"**

A cette règle, on peut se demander quelle est la longueur maximale (en nombre de lignes) que peut atteindre une fonction. Dans la littérature, ce seuil maximum varie généralement de 30 à 50 lignes, mais peut descendre jusqu’à 10. Plutôt que de se baser un seul arbitraire dans cet intervalle, je vous propose une méthode suivante. A chaque passe d’écriture de votre fonction, considérer qu’elle est trop longue et essayer de la rendre plus courte.  

3ème règle : **"Pour chaque fonction, limiter drastiquement le nombre d’arguments"** 

L’ajout d’arguments dans une fonction n’est pas sans conséquences : elle complexifie son l’utilisation. De plus, chaque argument nécessite la création de tests unitaires adéquats pour tester son bon fonctionnement.
Dans les faits, une fonction a rarement besoin de plus de 3 arguments. Ce nombre peut sembler irréalisable. Néanmoins certaines astuces permettent de s’en rapprocher : 
Pour les paramètres techniques : les développeurs ont tendance à mettre l’ensemble des paramètres techniques en argument, en leur attribuant une valeur par défaut. Or, si la valeur d’un paramètre ne varie dans votre fonction, alors celui-ci n’a pas besoin d’être un argument, mais seulement d’être une variable locale 
Utiliser des listes : les listes tendent à remplacer la programmation orientée objet (POO) en R (qui existent bien, mais sont rarement utilisés). Il n’y a donc pas de soucis à mettre une liste en argument, à condition que “l’objet” qu’elle représente ait une structure clairement définie 
Pour les paramètres utilisateurs : à l’inverse des paramètres techniques, les paramètres peuvent varier selon le souhait de l’utilisateur. Mon conseille est de créer une fonction spécifique pour récupérer les valeurs des paramètres utilisateurs. Pour cela, les valeurs de ces paramètres doivent être stockés dans un fichier isolé (dans le cas d’un projet R) ou comme un objet global (dans le cas d’un paquet) 
