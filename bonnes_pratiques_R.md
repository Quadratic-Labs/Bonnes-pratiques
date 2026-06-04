
# INTRODUCTION 

On appelle bonnes pratiques tout ce qui garantit que le produit final soit de bonne qualité. 
La qualité est tout ce qui entoure le produit final au-delà de son simple bon fonctionnement. 
En effet, en informatique, un code fonctionnel n’est pas nécessairement un code de qualité.
Dans le cadre de R, ces bonnes pratiques sont d’autant plus importantes qu'elles pourraient vous aider à publier des paquets sur le CRAN (dépôt officiel de R), et donc contribuer au modèle open-source de ce langage. 

Dans ce document, je me focalise sur les bonnes pratiques appliquées aux langages R. Je me concentrerai sur les axes suivants : 
* La production d'un code propre 
* L'optimisation de l’exécution d'un code 
* Le choix de la forme du livrable 

# PARTIE 1 : CODER PROPREMENT EN R 

La notion de propreté est commune à tous les langages de programmation, malgré leurs différences (orienté objet ou procédural, de haut ou bas niveau...).
Un code propre, quel que soit son langage, a les qualités subjectives suivantes :  
* Sa maintenabilité : Il peut être lu et amélioré par un développeur autre que le développeur d’origine 
* Son imperfectibilité : rien ne permet de l’améliorer de manière évidente 
* Sa clarté : il demande peu d’effort pour être lu et compris 
* Sa limpidité : il retranscrit parfaitement l’idée d’origine du développeur 

Dans cette partie, je vous présente des moyens pour produire un code ayant ces qualités. 

## 1. La propreté du code 

> "La logique doit être simple, pour que les bogues aient du mal à se cacher.  
Les dépendances doivent être minimes afin de faciliter la maintenance.  
La gestion des erreurs doit être totale [...].  
Les performances doivent être proches de l'idéal [...].  
Un code propre fait une chose et le fait bien"  
*B. STROUSTRUP* (humble inventeur du C++)

Avant d’aborder plus précisément les spécificités du langage R, je présente les principes généraux de propreté d'un code. 

Les indicateurs de propreté du code ont été discutés par des développeurs renommés. Dans les différents points de vue que l’on peut trouver, on retrouve certaines tendances. Ainsi, un code propre doit être :  
* Explicite : aucune règle n’est implicite. Le lecteur n’a rien à deviner 
* Lisible : les imbrications sont identifiées. Le code est aéré. Les noms des entités sont pertinents. 
* Simple : le code est logique et va à l’essentiel 
* Parcimonieux : aucune opération superflue est présente 
* Non redondant : il n’y a pas 2 blocs/fonctions qui réalisent un traitement identique 
* Harmonieux : le style (cf. annexe1 pour plus de détails sur cette notion) est cohérent tout au long du script

__Le mythe de la reprise à 0 :__  
Pour appliquer ces principes aux scripts existants, il peut être tentant d'entreprendre une réécriture complète. En effet, il est plus facile de créer son propre script que de modifier celui de quelqu’un d’autre. Néanmoins il est communément admis que cela n’est pas une bonne idée, y compris si vous êtes un développeur expérimenté. En effet, si le code n’est pas propre, alors les intentions du développeur d’origine ne sont pas claires. Par conséquent, il vous manquerait très probablement des informations pour produire un script au moins aussi pertinent que celui de votre prédécesseur.  

Ainsi, pour éviter de reprendre de zéro tous les scripts non propres, je vous propose les 2 règles suivantes : 
* Quand vous travaillez sur un code, laissez le toujours un peu plus propre qu’il ne l’était initialement 
* “Plus tard signifie jamais” : si vous voyez un moyen évident d’améliorer un code, alors prenez le temps de le faire.

De cette manière, le script gagnera en qualité à chaque passe.

## 2. Les règles de propreté en R  

A partir des indicateurs précédents, on déduit des règles concrètes appliquées au langage R. A noter que certains de ces critères sont transposables à d'autres langages, selon qu’ils soient proches ou non de R. 

* Respecter les conventions d’indentation
  
  En R, l’indentation du code n'a pas de conséquences sur son exécution. Néanmoins, un script mal indenté perd significativement en lisibilité. De plus, une bonne indentation indique quelles parties du code sont particulièrement imbriquées, et donc lesquelles pourraient bénéficier d’une réécriture. En effet, un code imbriqué est généralement moins lisible qu'un code plat. Pour reprendre le *zen de Python* (cf. Annexe 2) « Nested is better than flat”. 

* Ecrire des commentaires uniquement s’ils sont irremplaçables
  
  S’ils peuvent être pertinents, les commentaires sont souvent utilisés pour compenser des défauts réels du code. Si le code est propre, alors un développeur n’a pas besoin de commentaires pour le comprendre. Par opposition, le bon commentaire est celui qui ne peut pas être remplacé par du code (cf. Annexe 3 pour des exemples précis de mauvais commentaires). Aussi, les développeurs, intervenant sur un code tierce, sont plus réticents à supprimer un commentaire qu’à modifier du code, même si le commentaire en question est énigmatique. 

* Utiliser les pipes
  
  Le pipe (ou ‘conduit’ en français) est un type d’opérateur qui permet de construire un 'pipeline', pour appliquer une suite de transformations à un input. Il évite la création de variables purement intermédiaires, tout en rendant le code moins redondant. L'opérateur de type pipe le plus connu est `%>%` du package 'magrittr'. Mais je conseillerais plutôt l’utilisation du pipe natif `|>`. Bien qu'il soit moins courant, il a l’avantage d'être légèrement plus rapide que celui de 'magrittr', tout en évitant une dépendance supplémentaire. 

* Identifier, minimiser, et mettre à jour les paquets importés
  
  Les importations ont tendance à complexifier la maintenance et le déploiement de code. C’est le cas par exemple si une montée de version d’un paquet utilisé engendre des nouveaux comportements non gérés par le code. De plus, le risque de conflit entre paquets augmente logiquement avec le nombre de dépendances. C'est pourquoi je déconseille notamment d’avoir un recours systématique au paquet 'dplyr'. Bien que pratique et couramment utilisé, il ne reste pas moins une dépendance supplémentaire à gérer.
  
  Pour minimiser le nombre de dépendances, je conseille d’abord de les identifier en signalant les fonctions importées de cette façon : `[paquet]::[methode]`. De cette manière, vous pouvez vérifier si certains paquets importés ne sont plus nécessaires. Ensuite, pour des paquets où seul une ou deux fonctions sont importées, recherchez si des fonctions natives pourraient les remplacer. De cette manière, vous pourrez les supprimer. Enfin, pour les dépendances restantes, vérifiez que votre code est fonctionnel avec la version la plus récente du CRAN.

* Gérer explicitement les erreurs de lecture/écriture
  
  La lecture et l'écriture de fichiers utilisent des chemins physiques pour localiser des données sur le disque. Ces chemins sont souvent gérés par des chaînes de caractères en un unique bloc. Pour repérer plus facilement les problèmes de fichier non trouvé, je recommande d’utiliser en amont de la lecture les fonctions `dir.exits` ou `file.exists`. De plus, pour gagner en lisibilité, je recommande d’utiliser la fonction `file.path`, où chaque répertoire du chemin correspond à un argument. Elle est d’autant plus pratique qu’elle fonctionne de manière récursive. 

* Pas de codage dynamique
  
  Le codage dynamique fait référence à l’utilisation de chaînes de caractères dont la valeur est une instruction ou un nom de variables. En R, il se manifeste notamment par la présence des fonctions suivantes :
  * `eval()` et `parse()` pour gérer les chaînes de caractère comme des instructions 
  * `get()` et `assign()` pour gérer les chaînes de caractère comme des noms de variable

  N’utilisez jamais ces méthodes. En effet, elles rendent particulièrement laborieux le débogage des scripts. C'est pourquoi si vous les trouvez dans un script existant, je vous déconseille fortement de le modifier.  
Il peut exister des cas rares où cela est pertinent. Mais dans 99% des cas, vous n'en avez pas besoin.  

* Ne pas utiliser dans les scripts la correspondance partielle

  Dans certaines situations, R peut "deviner" le nom d'un élément en ne donnant que le début de celui-ci.
  Pour faire référence à une colonne nommée "price_wh" dans un data frame, `df$price` serait suffisant (à condition qu'il n'existe pas d'autres colonnes débutant par "price").
  A noter que la correspondance partielle ne s'applique pas uniquement aux data frames : lorsqu'on fait appel à une fonction, elle peut être utilisée pour définir la valeur des paramètres.  

  Je déconseille d'y avoir recours.
  En effet, cette pratique génère de la confusion. Dans un script, il est difficile de déterminer si la correspondance partielle a été utilisée sciemment par le développeur, ou s'il s'agit d'une erreur de nommage.
  De plus, si on reste sur le cas des data frames, la correspondance partielle est très sensible au renommage et ajout de colonnes. Avec ces modifications, ils risquent de vous retourner une valeur NULL, ou pire une autre colonne.
  Ainsi, pour ne pas utiliser ce mécanisme involontairement et détecter les erreurs de nommage, je vous conseille d'utiliser les crochets (`Table1[[« nom_colonne1 »]]`) plutôt que le dollar (`Table1$nom_colonne1`). En effet, la référence par crochet n'est pas soumise à la correspondance partielle.

* Contrôler les comparaisons

  Il existe plusieurs subtilités sur les comparaisons en R, qu'il est nécessaire de connaître pour réaliser une comparaison pertiente :
  * R peut comparer tout avec n'importe quoi. En effet, les 2 expressions suivantes ne retournent pas d'erreur dans la console : `356 > TRUE` et `1 < 'a'`. En effet, R effectue une "conversion automatique vers le type le plus générale". Concrètement, R convertit les éléments jusqu'à ce qu'ils soient tous au même type. En reprenant les exemples suivants :
    * `356 > TRUE` devient `356 > 1` donc `TRUE`  
    * `1 < 'a'` devient `'1' < 'a'`, donc `TRUE` (ordre ASCII)
      
    Il est donc important de contrôler les types des variables en amont pour vérifier que la comparaison n'est pas absurde.

  * test
    

## 3. Gestion des fonctions  

J’aimerais aborder certains critères spécifiques aux fonctions. Les concernant, 3 règles essentielles reviennent : 

1. **"Une fonction ne fait qu’une seule chose, et le fait bien"**  

   Cette phrase implique que :  
    * Le nom de la fonction énonce clairement ce qu’elle est sensée faire.
    * Chaque fonction est associée à un niveau d’abstraction. Le vocabulaire employé pour nommer la fonction et ses variables locales doit être cohérent avec le lexique de ce niveau. Par exemple, une fonction de haut niveau utilisera plutôt un vocabulaire métier, tandis qu’une fonction de bas niveau utilisera plutôt un vocabulaire technique/informatique.
    * Une fonction ne doit pas produire d’effet de bords, c’est-à-dire d’autres effets que celui qu’elle est sensée produire.
    * Ne pas avoir d’arguments indicateurs, c’est-à-dire d’arguments booléens qui changeraient le rôle de la fonction. Ce type d’argument indique qu’il vous faut non pas une, mais deux fonctions. 
    * Des tests unitaires doivent vérifier si la fonction remplie bien son unique objectif, y compris dans les cas particuliers.
    * Le nombre de fonctions dans un script est souvent important, et cela n’est pas un problème.

2. : **"Ecrire des fonctions courtes"**  

    A cette règle, on peut se demander quelle est la longueur maximale (en nombre de lignes) que doit atteindre une fonction. Dans la littérature, ce seuil maximum varie généralement de 30 à 50 lignes, mais peut descendre jusqu’à 10. Plutôt que de se baser sur un seuil arbitraire dans cet intervalle, je vous propose une méthode simple : à chaque passe d’écriture de votre fonction, considérer qu’elle est trop longue et essayer de la rendre plus courte.  

3. : **"Pour chaque fonction, limiter drastiquement le nombre d’arguments"**  

    L’ajout d’arguments dans une fonction n’est pas sans conséquences : elle complexifie son utilisation. De plus, chaque argument nécessite la création de tests unitaires adéquats pour tester son bon fonctionnement.
Dans les faits, une fonction a rarement besoin de plus de 3 arguments. Ce nombre peut sembler irréalisable. Néanmoins certaines astuces permettent de s’en rapprocher :
    * Pour les paramètres techniques : les développeurs ont tendance à mettre l’ensemble des paramètres techniques en argument, en leur attribuant une valeur par défaut. Or, si la valeur d’un paramètre ne varie pas dans votre fonction, alors celui-ci n’a pas besoin d’être un argument, mais seulement une variable locale
    * Utiliser des listes : les listes tendent à remplacer la programmation orientée objet (POO) en R (qui existe bien, mais est rarement utilisée). Il n’y a donc pas de soucis à mettre une liste en argument, à condition que l’objet qu’elle représente a une structure clairement définie et a du sens.
    * Pour les paramètres utilisateurs : à l’inverse des paramètres techniques, certains paramètres peuvent varier selon le souhait de l’utilisateur. Mon conseil est de créer une fonction spécifique pour récupérer les valeurs des paramètres utilisateurs depuis un fichier isolé (dans le cas d’un projet R) ou comme un objet global (dans le cas d’un paquet)
  
Pour rappel : l’écriture des fonctions est un processus itératif. Quand vous écrivez une nouvelle fonction, il est normal que celle-ci ne soit pas propre dans sa première version. L’objectif du développeur consistera à faire plusieurs passes d'écriture sur cette fonction pour qu’elle adhère progressivement aux critères de qualité.


# PARTIE 2 : OPTIMISATION DU CODE 

L’optimisation est l’étape logique qui suit la réécriture d’un code.  Elle a 2 objectifs : 
* Mobiliser de manière efficiente les ressources, à la fois en termes de mémoire (RAM) et de calcul (processeur) 
* Diminuer le temps d'exécution du code 

En pratique, l’optimisation consiste donc à : 
* Utiliser les méthodes les plus adaptées à la volumétrie de la donnée 
* Minimiser le volume des tables 
* Arbitrer entre les performances de 2 processus similaires 
* Minimiser l'usage des processus itératifs

Dans cette section, nous verrons d’abord comment analyser les performances d’un code, et ensuite comment les améliorer. 

Remarque importante : l’optimisation ne doit pas se faire au détriment de sa propreté. Le temps gagné côté utilisateur ne doit pas se transformer en du temps perdu côté développeur. 

## 1. Analyse des performances

L'outil de base de l'optimisation est le benchmark : l’évaluation des performances d’un code, ou seulement d’une partie. Deux fonctions complémentaires sont couramment utilisées pour cela : `profvis::profvis()` et `microbenmark::microbenmark()`. Ils sont chacun associés à un paquet éponyme. 

La fonction `profvis::profvis()` s'exécute sur un code entier.  La fonction analyse les performances de chaque étape. On peut donc identifier quelles sont celles qui nécessitent une optimisation. A noter qu'on retrouve généralement une répartition de Pareto. En effet, dans un code non optimisé, une faible partie du code (<20%) est responsable d'une grande partie du temps d'exécution (>80%). 

C’est à l’issue de l’identification qu’on utilise `microbenmark::microbenchmark()`. Contrairement à `profvis::profvis()`, celle-ci est conçue pour analyser des blocs courts. Elle analyse les performances de ce bloc sur plusieurs itérations. Cela permet de disposer d’indicateurs de performance fiables. A l'aide de ces indicateurs, on cherchera à refactoriser le bloc de manière à l’optimiser, notamment en termes de temps d’exécution. Il faut bien vérifier que ces gains sont significatifs, mais aussi analyser comment ils évoluent avec l’augmentation du volume de la donnée. 

## 2. Optimisation du temps d'exécution de son code

Dans cette sous-section, je vous présente 3 méthodes couramment utilisées pour optimiser le temps d’exécution de votre code. 

1. Affiner la lecture des inputs

   La fonction `read.table` (et ses dérivés comme `read.csv`) disposent de nombreux arguments pour réaliser des traitements dès de la phase de lecture.
   Or, cela permet généralement de gagner en temps d'exécution, emais aussi de ne pas stocker la totalité de la table en RAM.
   On y retrouve par exemple des arguments pour filtrer les lignes (`skip`,`n_max`) et sélectionner les colonnes souhaitées (`colClasses`).
   Dans le cas d’une connexion à une base de données SQL, cela revient à enrichir la requête SQL avec un maximum de traitements.

3. Gérer les données volumineuses avec data.table

   Comparable au paquet 'dplyr', le paquet 'data.table' propose une syntaxe pour manipuler la donnée. Elle est adaptée aux volumes importants de données. En effet, dans ce contexte, l’utilisation de 'data.table' peut faire gagner un temps significatif sur l’exécution du code.

4. Vectoriser les processus itératifs

   La vectorisation est une caractéristique que présente la majorité des fonctions natives de R.
   Une fonction est vectorisée au sens strict si, en prenant en input un vecteur, elle applique sa transformation ‘simultanément’ à ses éléments de manière indépendante, tout en retournant un vecteur de même dimension.
   Elle est néanmoins possible uniquement dans le cas où, dans une boucle, une itération ne dépend pas du résultat de l'itération précédente.
   Quand la vectorisation est possible, elle devient une alternatives aux boucles FOR.
   En règle générale, réaliser une opération par vectorisation est plus rapide que de la réaliser par boucle. De plus, elle a l'avantage d’éviter un niveau d’indentation supplémentaire.

   Du point de vue de la lisibité, je conseille la fonction `Vectorize()` (ne pas oublier la majuscule). Elle simule une vectorisation sur des fonctions non vectorisables. Attention, cette fonction ne diminue pas le temps d’exécution : elle n’est qu’un "wrapper" pour les boucles. Néanmoins, il existe d'autres fonctions qui appliquent une "vraie" vectorisation. C'est le cas de par exemple `bind_rows()` pour les concaténations, `plyr::join()` pour les jointures, ou les fonctions de la famille `apply` pour différentes applications de la vectorisation.

## 3. Optimisation de l'utilisation de son environnement

Nous avons vu comment optimiser le temps d'exécution d'un code indépendamment de son environnement.
Or, les ressources de calcul à disposition forment un autre levier d'action possible.
C'est une étape qui arrive après, et seulement après, avoir optimisé son code.

2 questions doivent se poser : 
* Comment maximiser son utilisation des ressources à disposition ? (efficacité)
* La quantité de ressources mobilisées est-elle cohérente avec votre besoin ? (efficience)

En termes d'efficacité, la parallélisation est une technique qui vous permet d'exploiter toute la puissance de calcul de vos ressources.
En effet, elle consiste à répartir l'exécution du code simultanément sur plusieurs unités de calcul (coeurs ou processeurs). 
Dans les paquets R, la parallélisation se manifeste sous la forme d'un ou plusieurs paramètres utilisateur : activer ou non la paraléllisation, combien d'unités doivent être mobilisées... 
Il sera particulièrement apprécié dans les paquets réalisant des traitements de donnée volumineuse.
L'objectif ici sera de paralléliser le maximum de traitements. En effet, plus les traitements seront parallélisés, et plus le gain de vitesse par unité de calcul sera important. 
Plusieurs paquets R permettent de paralléliser son code, comme par exemple 'parallel' ou le duo de 'doParallel' et 'foreach'.
Attention : en plus d'avoir tendance à complexifier le code, la mise en place de la parallélisation nécessite une certaine expérience pour être bien exploitée.

Une fois la parallélisation implémentée, il faut identifier le nombre d'unités de traitement suffisant pour votre code. 
En effet, mobiliser des ressources a un coût (monétaire ou d'opportunité), qu'il convient de minimiser.
Or, le gain de vitesse obtenu par chaque unité de calcul (coeurs ou processeurs) est décroissant, et tend vers 0 (cf. Loi d'Amdahl).
Ainsi, avec les outils présentés dans la sous-section 1, vous identifierez le nombre optimal de ressources pour votre besoin.

# PARTIE 3 : FORME DU LIVRABLE

Au-delà de la propreté du code, la forme finale du livrable jouera un rôle déterminant dans l’appréciation du client. 

## Un rmarkdown pour l’analyse

Le format de fichier rmarkdown (ou 'qwarto' dans sa forme plus moderne) est un type de fichier fusionnant la syntaxe markdown avec du code R.

C'est un type de fichier adapté pour la présentation de résultats ou la réalisation d'une analyse. Dans ces cas précis, le fichier rmarkdown et une version compilée (HTML,PDF,...) doivent être tous deux fournis au client. En effet, le rmarkdown est une 'preuve' de la reproductibilité des résultats. N'importe qui doit pouvoir re-compiler le fichier sous un autre format, tout en conservant les mêmes résultats. C'est pour cela qu'il est important de vérifier la consistance des résultats entre plusieurs exécutions complètes : tous les aléas potentiels doivent être maîtrisés.

Concernant la forme du markdown : 
* Un minimun de code R doit être intégré dans les chunks. En particulier, les fonctions ne doivent pas être déclarées dans le fichier. Pour cela, on pourra les intégrer à ses propres paquets (voir sous-section suivante)
* Toujours nommer les chunks pour mieux se repérer dans le document
* Le paquet 'knitr' ne sert pas uniquement à compiler le document. En effet, certaines de ses autres fonctions méritent d'être connues. Je pense par exemple à `knitr::ktable()` pour afficher des tables ou `knitr::opts_chunk()` pour définir globalement les paramètres des chunks.
* Dans le cadre de la production de rapports de présentation, vous pouvez omettre le code avec le paramètre `echo=FALSE` pour le rendre plus lisible. Les profils techniques pourront directement consulter le fichier rmarkdown pour consulter le code.

## Un paquet R pour le code 

Je déconseille fortement de définir ses fonctions dans des scripts R isolés. En effet, cela présente plusieurs inconvénients :
* On ne sait pas avec quelles versions des paquets importés votre code fonctionne, car les dépendances ne sont pas clairement citées.
* Aucun test ne vérifie le bon fonctionnement de chaque fonction, ce qui les rend plus risquées à modifier
* La documentation est indépendante du code, et donc n'est pas nécessairement à jour

Pour résoudre ces problèmes, la meilleure solution consiste à rassembler toutes ses fonctions dans un paquet. Ce terme peut faire peur mais je vous rassure : la création de paquets sur R est relativement simple, et de mon avis plus simple que sur Python. Je vous renvoie en particulier vers la bible de la création de paquet (gratuit !) : R Packages (2e) de Hadley Wickham and Jennifer Bryan.

Ainsi, un paquet R vous permettra de :
* Gérer vos dépendances, avec la possibilité de les classer selon leur importance (Depends/Imports/Suggest). L'ensemble des paquets utilisés doivent être explicitement cités dans la documentation 'roxygen2' avec les tags `@importFrom` (ou `@import` dans le cas des paquets "framework" comme 'dplyr' ou 'data.table'). 
* Ajouter des tests unitaires pour garantir la robustesse du code et la gestion des cas particuliers. Pour rappel : les tests unitaires doivent être réalisés en parallèle du développement de la fonction, et non après. Aussi, le paquet 'codecov' permet d'évaluer la couverture du code, c'est-à-dire la proportion du code "protégée" par les tests unitaires (attention : le taux de couverture est un indicateur, non un objectif !). 
* Intégrer directement la documentation à chaque fonction. Lors de la phase de `Check` du paquet, l’adéquation entre la fonction et sa documentation sera vérifiée. 
* Lier de la documentation annexe à votre code avec les vignettes. Elles sont particulièrement utiles pour illustrer à l'utilisateur le fonctionnement de vos fonctions.
* Intégrer des méta-données, telles que le nom de l’auteur, la licence, ... 
* Instaurer une notion de versionnage, avec donc un suivi des corrections des bogues ou d'ajouts de fonctionnalités

## Un shiny pour les outils interactifs


# PARTIE 4 : SELECTION DE PAQUETS PAR CAS D'USAGE

La force de R réside dans son immense bibliothèque de packages (plus de 20 000 sur le CRAN). Pour garantir la pérennité et l'efficacité de vos développements, il est crucial de s'appuyer sur des outils standards et éprouvés. Voici une sélection des packages incontournables classés par domaine d'application. 

## 1. Gestion de la data 

Avant toute analyse, la manipulation et le nettoyage des données constituent souvent 80 % du travail. Le "Tidyverse" a révolutionné cette étape en proposant une syntaxe lisible et performante. 

* **dplyr** : C'est la grammaire de la manipulation de données. Il permet d'effectuer les opérations les plus courantes (filtrer, sélectionner, réorganiser, créer des variables ou agréger) via des verbes simples et intuitifs. Son utilisation avec l'opérateur "pipe" (%>% ou |>) rend le code extrêmement lisible, proche du langage naturel, ce qui facilite grandement la revue de code et la maintenance. 

* **tidyr** : Ce package est dédié au "nettoyage" de la structure des données. Il permet de passer d'un format "large" à un format "long" (et vice-versa) pour que chaque variable soit une colonne et chaque observation une ligne. C’est un outil indispensable pour préparer vos jeux de données avant de les injecter dans des modèles statistiques ou des outils de visualisation. 

## 2. Statistique et Machine Learning (ML) 

R est avant tout un langage statistique. Pour le Machine Learning, l'enjeu est d'unifier les méthodes d'appels des différents algorithmes (souvent disparates) au sein d'un workflow cohérent. 

* **caret** : Historiquement le package de référence pour le ML en R. Il fournit une interface unique pour entraîner des centaines d'algorithmes différents. Caret gère tout le cycle de vie d'un modèle : du prétraitement des données (normalisation, gestion des valeurs manquantes) à la sélection des variables, en passant par l'optimisation des hyperparamètres et l'évaluation des performances. 

* **tidymodels** : C'est la version moderne et "Tidyverse-compatible" du Machine Learning. Ce n'est pas un seul package mais une collection d'outils (parsnip, recipes, rsample, etc.) qui favorisent de bonnes pratiques de modélisation. Plus modulaire que caret, il permet de construire des "pipelines" de modélisation robustes, reproductibles et très structurés, idéaux pour des projets complexes à grande échelle. 

## 3. Graphique et Visualisation 

La visualisation est l'un des plus grands atouts de R. Elle permet d'explorer les données et de communiquer des résultats complexes de manière percutante. 

* **ggplot2** : Basé sur la "Grammaire des Graphiques", ce package permet de construire des visualisations couche par couche (données, esthétiques, géométries). Sa flexibilité est quasi infinie et la qualité esthétique des graphiques produits est de standard professionnel (publication scientifique, presse). 

* **plotly** : Ce package permet de transformer vos graphiques statiques ggplot2 en versions interactives (zoom, survol à la souris, filtres) avec une seule fonction : `plotly::ggplotly()`. C'est l'outil parfait pour l'exploration de données ou pour enrichir des rapports HTML. 

* **highcharter** : Une interface R pour la célèbre bibliothèque JavaScript Highcharts. Il est particulièrement apprécié pour créer des graphiques dynamiques et élégants, très utilisés dans les tableaux de bord professionnels, offrant une grande fluidité et de nombreuses options de personnalisation. 

## 4. Shiny : Applications Web Interactives 

Shiny permet de transformer vos analyses R en applications web interactives sans avoir besoin de connaissances approfondies en HTML/CSS ou JavaScript. 

* **shiny** : C'est le framework de base. Il repose sur un modèle de programmation réactive : dès qu'un utilisateur modifie un paramètre (curseur, menu déroulant), les calculs et les graphiques se mettent à jour instantanément. C’est l’outil idéal pour l'aide à la décision. 

* **golem** : Pour passer d'un simple script Shiny à une application robuste prête pour la production, golem est indispensable. Il impose une structure de "package" à votre application Shiny, facilitant ainsi les tests unitaires, le contrôle de version et le déploiement sécurisé. C’est le garant du respect des bonnes pratiques de développement logiciel. 

## 5. Déboggage 

Le débogage est une étape inévitable pour garantir la fiabilité de vos scripts, surtout lorsque la logique métier devient complexe. 

* `browser()` : Plus qu'un package, c'est une fonction native essentielle. Insérée dans votre code, elle interrompt l'exécution et vous permet d'inspecter l'environnement à cet instant précis. Vous pouvez alors tester vos variables, exécuter le code ligne par ligne et comprendre exactement où et pourquoi une erreur se produit. C'est l'outil de diagnostic primaire de tout développeur R. Par ailleurs, il en existe des dérivés comme `recover()` et `debug()`.
 
* `codetools::findGlobals()` : Une erreur courante consiste à utiliser des objets globaux dans une fonction, c'est-à-dire définis hors de celle-ci. Avec `findGlobals()`, vous pouvez les détecter facilement et ajuster votre fonction.

* `conflicts()` :  Le fait d'avoir 2 objets portant un même nom peut génèrer des erreurs assez incompréhensible. C'est le cas quand une variable porte le même nom qu'une fonction d'un paquet chargé. Ainsi, `conflicts()` vérifie si deux objets portent le nom dans l'environnement.  

# SOURCES ET RESSOURCES

* "R for Data Science" de H. WICKAM et G. GROLEMUND  
  LA bible de R. Indispensable à tout data scientist.  
  Je conseille la première édition plutôt que la deuxième : elle se réfère d'avantage à des méthodes des paquets `base` et `utile`

* "Advanced R" de H. WICKAM  
  Suite canonique du livre précédent

* "R Packages" de H. WICKAM et J.  BRYAN  
  Essentiel pour monter en compétence sur la création des paquets R

* "Coder proprement" de R. C. MARTIN  
  Référence dans le monde de la programmation. Même si il est orienté JAVA, la plupart de ses principes et règles sont transposables à R et Python.  
  Source principale de la section 1.

* "R FAQ"  
  Document officiel du CRAN. Il dispose d'éléments de réponses sur certaines questions techniques récurrentes du langage.

* "The R Inferno" de P. BURNS  
  Etrange document, mais très riche. Il aborde certaines idées fausses sur R, et liste un nombre important de particularités/bizzareries du langage.  
  Attention : le document date de 2011. Certaines observations peuvent être caduques sur les versions récentes de R.
