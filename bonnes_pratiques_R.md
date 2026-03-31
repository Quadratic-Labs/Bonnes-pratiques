
# INTRODUCTION 

On appelle bonnes pratiques tout ce qui garantit que le produit final soit de bonne qualité. 
La qualité est tout ce qui entoure le produit final au-delà de son simple bon fonctionnement. 
En effet, en informatique, un code fonctionnel n’est pas nécessairement un code de qualité.
Dans le cadre de R, ces bonnes pratiques sont d’autant plus importantes qu'elles pourraient vous aider à publier des paquets sur le CRAN (dépôt officiel de R), et donc contribuer au modèle open-source de ce langage. 

Dans ce document, je me focalise sur les bonnes pratiques appliquées aux langages R. Kee me concentrerai sur les axes suivants : 
* La production d'un code propre 
* L'optimisation de l’exécution d'un code 
* Le choix de la forme du livrable 

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
  
  Les pipes (ou ‘conduits’ en français) est un type d’opérateur qui permet de construire un 'pipeline', pour appliquer une suite de transformation à un input. Il évite la création de variables purement intermédiaires, tout en rendant le code moins redondant. L'opérateur de type pipe le plus connu est `%>%` du package magrittr. Mais je conseillerais plutôt l’utilisation du pipe natif `|>`. Bien qu'il soit moins courant, il a l’avantage d'être légèrement plus rapide que celui de magrittr, tout en évitant une dépendance supplémentaire. 

* Identifier, minimiser, et mettre à jour les paquets importés
  
  Les importations ont tendance à complexifier la maintenance et le déploiement de code. C’est le cas par exemple si une montée de version d’un paquet utilisé engendre des nouveaux comportements non gérés par le code. De plus, le risque de conflits entre paquets augmente logiquement avec le nombre de dépendances. C'est pourquoi je déconseille d’avoir un recours systématique au paquet dplyr. Bien que pratique et couramment utilisé, il ne reste pas moins une dépendance supplémentaire à gérer.
  
  Pour minimiser le nombre de dépendances, je conseille d’abord de les identifier en signalant les fonctions importées de cette façon : `[paquet]::[methode]`. De cette manière, vous pouvez vérifier si certains paquets importés ne sont plus nécessaires. Ensuite, pour des paquets où seul une ou deux fonctions sont importés, recherchez si des fonctions de R Base pourraient les remplacer. De cette manière, vous pourrez supprimer certaines dépendances. Enfin, pour les dépendances restantes, vérifier que votre code est fonctionnel avec leurs dernières versions. 

* Gérer explicitement les erreurs de lecture/écriture
  
  La lecture et écriture de fichiers utilise des chemins physiques pour localiser des données sur le disque. Ces chemins sont souvent gérés par des chaînes de caractères en un unique bloc. Pour repérer plus facilement les problèmes de fichier non trouvé, je recommande d’utiliser en amont de la lecture les fonctions dir.exits ou file.exist. De plus, pour gagner en lisibilité, je recommande d’utiliser la fonction file.path de R Base, où chaque répertoire du chemin correspond à un argument. Elle est d’autant plus pratique qu’elle fonctionne de manière récursive. 

* Pas de codage dynamique
  
  Le codage dynamique fait référence à l’utilisation de chaînes de caractères consistant en des instructions ou des noms de variables. En R, il se manifeste notamment par la présence des fonctions suivantes :
  * `base::eval()` et `base::parse()` pour gérer les chaînes de caractère comme des instructions 
  * `base::get()` et `base::assign()` pour gérer les chaînes de caractère comme des noms de variable

  N’utilisez jamais ces méthodes. En effet, elles rendent particulièrement laborieuses le débogage des scripts. C'est pourquoi si vous les trouvez dans un script existant, je vous déconseille fortement de le modifier. Il peut exister des cas rares où cela est pertinent. Mais dans 99% des cas, elles sont substituables.  

* Ne pas utiliser `$` pour référencer les colonnes d’un tableau
  
  Avec les data.frames (la structure de table de base), il existe 2 moyens de manipuler une colonne comme un vecteur : soit avec des crochets (`Table1[[« nom_colonne1 »]]`), soit un symbole dollar (`Table1$nom_colonne1)`. Parmi ces 2 possibilités, je conseille d’utiliser plutôt les crochets. En effet, l’opérateur `$` fait implicitement de l’auto-complétion. Par conséquent, si le nom de la colonne après le symbole `$` n’existe pas, alors il peut malgré tout retourner les valeurs d’une autre colonne. 

 

## 3. Gestion des fonctions  

J’aimerais aborder certains critères spécifiques aux fonctions. L’écriture des fonctions est un processus itératif. Quand vous écrivez une nouvelle fonction, il est normal que celle-ci ne soit pas propre dans sa première version. L’objectif du développeur consistera à faire plusieurs passes sur cette fonction pour qu’elle adhère progressivement à certains critères. C’est pourquoi il existe trois règles essentielles les concernant : 

1. **"Une fonction ne fait qu’une seule chose, et le fait bien"**  

   Cette phrase implique que :  
    * Le nom de la fonction énonce clairement ce qu’elle est sensée faire 
    * Chaque fonction est associée à un niveau d’abstraction. Le vocabulaire employé pour nommer la fonction et ses variables locales doit être cohérent avec le lexique de ce niveau. Par exemple, une fonction de haut niveau utilisera un vocabulaire en lien avec métier, tandis qu’une fonction de bas niveau utilisera un vocabulaire en lien avec le hardware 
    * Une fonction ne doit pas produire d’effet de bords, c’est-à-dire d’autres effets que ce que celui qu’il est sensé produire 
    * Ne pas avoir d’arguments indicateurs, c’est-à-dire d’arguments booléens qui changeraient le rôle de la fonction. Ce type d’argument indique qu’il vous faut probablement non pas une, mais deux fonctions. 
    * Des tests unitaires doivent vérifier si la fonction remplie bien son unique objectif, y compris dans les cas particuliers 
    * Le nombre de fonction dans un script est souvent important, et cela n’est pas un problème 

2. : **"Ecrire des fonctions courtes"**  

    A cette règle, on peut se demander quelle est la longueur maximale (en nombre de lignes) que peut atteindre une fonction. Dans la littérature, ce seuil maximum varie généralement de 30 à 50 lignes, mais peut descendre jusqu’à 10. Plutôt que de se baser un seul arbitraire dans cet intervalle, je vous propose une méthode suivante. A chaque passe d’écriture de votre fonction, considérer qu’elle est trop longue et essayer de la rendre plus courte.  

3. : **"Pour chaque fonction, limiter drastiquement le nombre d’arguments"**  

    L’ajout d’arguments dans une fonction n’est pas sans conséquences : elle complexifie son l’utilisation. De plus, chaque argument nécessite la création de tests unitaires adéquats pour tester son bon fonctionnement.
Dans les faits, une fonction a rarement besoin de plus de 3 arguments. Ce nombre peut sembler irréalisable. Néanmoins certaines astuces permettent de s’en rapprocher :
    * Pour les paramètres techniques : les développeurs ont tendance à mettre l’ensemble des paramètres techniques en argument, en leur attribuant une valeur par défaut. Or, si la valeur d’un paramètre ne varie dans votre fonction, alors celui-ci n’a pas besoin d’être un argument, mais seulement d’être une variable locale
    * Utiliser des listes : les listes tendent à remplacer la programmation orientée objet (POO) en R (qui existent bien, mais sont rarement utilisés). Il n’y a donc pas de soucis à mettre une liste en argument, à condition que “l’objet” qu’elle représente ait une structure clairement définie.
    * Pour les paramètres utilisateurs : à l’inverse des paramètres techniques, les paramètres peuvent varier selon le souhait de l’utilisateur. Mon conseille est de créer une fonction spécifique pour récupérer les valeurs des paramètres utilisateurs. Pour cela, les valeurs de ces paramètres doivent être stockés dans un fichier isolé (dans le cas d’un projet R) ou comme un objet global (dans le cas d’un paquet) 


# PARTIE 2 : OPTIMISATION DU CODE 

L’optimisation est l’étape logique qui suit la réécriture d’un code.  Elle a 2 objectifs : 
* Mobiliser de manière efficiente les ressources, à la fois en termes de mémoire (RAM) et de calcul (processeur) 
* Diminuer le temps d'exécution du code 

En pratique, l’optimisation consiste donc à : 
* Utiliser les méthodes les plus adaptées à la volumétrie de la donnée 
* Minimiser le volume des tables 
* Arbitrer entre les performances de 2 processus similaires 
* Minimiser l'usage des processus itératif 

Dans cette section, nous verrons d’abord comment analyser les performances d’un code, et ensuite comment les améliorer. 

Remarque importante : l’optimisation ne doit pas se faire au détriment de sa propreté. Le temps gagné côté utilisateur ne doit pas se transformer en du temps perdu côté développeur. 

## 1. Analyse des performances

L'outil de base de l'optimisation est le benchmark : l’évaluation des performances d’un code, ou seulement d’une partie. Deux fonctions complémentaires sont couramment utilisées pour cela : `profvis::profvis()` et `microbenmark::microbenmark()`. Ils sont chacun associés à un paquet éponyme. 

La fonction `profvis::profvis()` s'exécute sur un code entier.  La fonction analyse les performances de chaque étape. On peut donc identifier quelles sont celles qui nécessitent une optimisation. A noter qu'on retrouve généralement une répartition de Pareto. En effet, dans un code non optimisé, une faible partie du code (<20%) est responsable d'une grande partie du temps d'exécution (>80%). 

C’est à l’issue de l’identification qu’on utilise `microbenmark::microbenchmark()`. Contrairement à `profvis::profvis()`, celle-ci est conçue pour analyser des blocs courts. Elle analyse les performances de ce bloc sur plusieurs itérations. Cela permet de disposer d’indicateurs de performance fiables. A l'aide de ces indicateurs, on cherchera à refactoriser le bloc de manière à l’optimiser (par exemple le temps d’exécution). Il faut bien vérifier que ces gains sont significatifs, et vérifier comment ils évoluent avec l’augmentation du volume de données. 

## 2. Optimisation du temps d'exécution de son code

Dans cette sous-section, je vous présente 3 méthodes couramment utilisées pour optimiser le temps d’exécution de votre code. 

1. Affiner la lecture des inputs

   Il faut éviter de stocker la totalité de la table en mémoire. Il faut donc essayer d’importer de filtrer les données et/ou sélectionner les colonnes dès la lecture de l’input sur le disque dure.
   Dans le cas de de fichier Excel, cela consiste utilise les argument `col_names`, `skip`, et `n_max` (présent dans toutes les fonctions d’import). Dans le cas d’une table située sur une base de données SQL, cela revient à restreindre la quantité dans la requête SQL.  

2. Gérer les données volumineuses avec data.table

   Comparable au paquet 'dplyr', le paquet data.table propose une syntaxe pour manipulation de la donnée. Elle est adapté au traitement de volume de données important. En effet, dans ce cas précis, l’utilisation de data.table peut faire gagner un temps significatif sur les temps d’exécution. 

3. Vectoriser les processus itératifs

   La vectorisation est une caractéristique que présente la majorité des fonctions natives de R. Une fonction est vectorisée au sens strict si, en prenant en input un vecteur, elle applique sa transformation ‘simultanément’ à ses éléments de manière indépendante. C’est une caractéristique permet de ne pas avoir systématiquement recours à des boucles WHILE ou FOR.
   En effet, en règle générale, réaliser une opération par vectorisation est plus rapide que la réaliser par boucle. De plus, il permet d’éviter un niveau d’indentation supplémentaire. 

D’un point de vue de lisibité, je conseille la fonction `base::vectorize()`. Elle simule une vectorisation sur des fonctions non vectorisable. Néanmoins cette fonction ne diminue le temps d’exécution : elle n’est qu’un wrapper pour les boucles. 

## 3. Optimisation de l'utilisation de son environnement

Nous avons vu comment optimiser le temps d'exécution d'un code indépendamment de son environnement.
Or, les ressources de calcul à disposition forment un autre levier d'action possible.

C'est une étape qui arrive après, et seulement après, avoir optimisé son code. 
En effet, l'environnement d'un code peut être amené à changer. 
Or, votre code doit pouvoir s'éxécuter au mieux quelles que soit les ressources de son utilisateur.

2 questions doivent se poser : 
* Comment maximiser son utilisation des ressources à disposition ? (efficacité)
* La quantité de ressources mobilisées est-elle cohérente avec votre besoin ? (efficience)

En terme d'efficacité, la parallélisation est une technique qui vous permet d'exploiter toute la puissance de calcul de vos ressources.
En effet, elle consiste à répartir l'exécution du code simultanément sur plusieurs unités de calcul (coeurs ou processeurs). 
Dans les paquets R, la parallélisation se manifeste sous la forme d'un ou plusieurs paramètres utilisateur : activer ou non la paraléllisation, combien d'unités doivent être utilisées ... 
Il sera particulièrement apprécié dans les paquets réalisant des traitements de donnée volumineuse.
L'objectif ici sera de paralléliser le maximum de traitement. En effet, plus de traitements seront parallélisés, et plus le gain de vitesse par unité de calcul sera important. 
Plusieurs paquets R permettent de paralléliser son code, comme par exemple 'parallel' ou le duo 'doParallel' et 'foreach'.
Attention : en plus d'avoir tendance à complexifier le code, la mise en place de la parallélisation nécessite une certaine expérience pour être bien exploitée. 

Une fois la parallélisation implémentée, il faut identifier le nombre d'unités de traitement suffisant pour votre code. 
En effet, mobiliser des ressources a un coût (monétaire ou d'opportunité), qu'il convient de minimiser.
Or, le gain de vitesse obtenu par chaque unité de calcul (coeurs ou processeurs) est décroissant, et tend 0 (cf. Loi d'Amdahl).
Ainsi, avec les outils présentés dans la sous-section 1, on identifera le nombre optimal de ressources pour votre besoin.

# PARTIE 3 : FORME DU LIVRABLE

Au-delà de la propreté du code, la forme finale du livrable jouera un rôle déterminant dans l’appréciation du client. 

## Un rmarkdown pour l’analyse

Le format de fichier rmarkdown (ou 'qwarto' dans sa forme plus moderne) est un type de fichier fusionnant la syntaxe markdown et du code R.

C'est un type de fichier adapté pour la présentation de résultats ou la réalisation d'une analyse. Dans ces cas précis, le fichier rmarkdown et une version compilée (HTML,PDF,...) doivent être tous deux fournis au client. En effet, le rmarkdown est une 'preuve' de la reproductibilité des résultats. N'importe qui doit pouvoir re-compiler le fichier sous un autre format, tout en conservant les mêmes résultats. C'est pour cela qu'il est important de vérifier la consistance des résultats entre plusieurs exécutions complètes : tous les aléas potentiels doivent être maîtrisés.

Concernant la forme du markdown : 
* Un minimun de code R doit être intégré dans les chunks. En particulier, les fonctions ne doivent pas être déclarées dans le fichier. Pour cela, on pourra les intégrer à ses proches paquets (voir sous-section suivante)
* Toujours nommer les chunks pour mieux se repérer dans le document
* Le paquet 'knitr' ne sert pas uniquement à compiler le document. En effet, certaines de ses autres fonctions méritent d'être connues. Je pense par exemple à `knitr::ktable()` pour afficher des tables ou `knitr::opts_chunk()` pour définir globalement les paramètres des chunks.
* Dans le cadre de la production de rapport de présentation, vous pouvez omettre le code avec le paramètre `echo=FALSE` pour le rendre plus lisible. Les profils techniques pourront directement consulter le fichier rmarkdown pour conslter le code.

## Un paquet R pour le code 

Je déconseille fortement de définir ses fonctions dans des scripts R isolés. En effet, cela présente plusieurs inconvénients :
* On ne sait pas avec quelle version des paquets importés votre code fonctionne, car les dépendances ne sont pas clairement citées.
* Aucun test ne vérifie le bon fonctionnement de chaque fonction, ce qui le rend plus risqué à modifier
* La documentation est indépendante du code, et donc n'est pas nécessairement à jour

Pour résoudre ces problèmes, la meilleure solution consiste à rassembler toutes ses fonctions dans un paquet. Ce terme peut faire peur mais je vous rassure : la création de paquets sur R est relativement simple, et de mon avis plus simple que sur Python. Je vous renvoie en particulier vers la bible de la création de paquet (gratuit !) : R Packages (2e) de Hadley Wickham and Jennifer Bryan.

Ainsi, un paquet R vous permettra de :
* Gérer vos dépendances, avec la possibilité de les classer selon leur importance (Depends/Imports/Suggest). L'ensemble des paquets utilisés doivent être explicitement cité dans la documentation 'roxygen2' avec les tags `@importFrom` (ou `@import` dans le cas des paquets "framework" comme 'dplyr' ou 'data.table'). 
* Ajouter des tests unitaires pour garantir la robustesse du code et la gestion des cas particuliers. Pour rappel : les tests unitaires doivent être réalisés en parallèle du développement de la fonction, et non après. Aussi, le paquet 'codecov' permet d'évaluer la couverture du code, c'est-à-dire la proportion du code "protégée" par les tests unitaires (attention : le taux de couverture est un indicateur, non un objectif !) 
* Intégrer directement la documentation à chaque fonction. Lors de la phase de `Check` du paquet, l’adéquation entre la fonction et sa documentation sera vérifiées 
* Lier de la documentation annexe à votre code avec les vignettes. Elles sont particulièrement utiles pour illustrer le fonctionnement de vos fonctions.
* Intégrer des méta-données, telles que le nom de l’auteur, la licence, ... 
* Instaurer une notion de versionnage, avec donc un suivi des corrections de bugs ou d'ajouts de fonctionnalités

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

* `base::browser()` : Plus qu'un package, c'est une fonction native essentielle. Insérée dans votre code, elle interrompt l'exécution et vous permet d'inspecter l'environnement à cet instant précis. Vous pouvez alors tester vos variables, exécuter le code ligne par ligne et comprendre exactement où et pourquoi une erreur se produit. C'est l'outil de diagnostic primaire de tout développeur R. 
