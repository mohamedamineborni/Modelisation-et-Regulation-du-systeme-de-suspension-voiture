# Mod-lisation-et-R-gulation-du-syst-me-de-suspension-voiture
Dans un premier temps, nous allons modéliser le système à l'aide d'une représentation d'état adaptée aux spécifications de la commande. Ensuite, nous mettrons en œuvre la commande LQR et la comparerons à la commande de placement de pôles. Le principal outil que nous utiliserons pour atteindre ces objectifs sera Matlab.



La conception d'un système de suspension automobile est un problème de contrôle intéressant et stimulant. Pour simplifier le problème en un système à ressorts et amortisseurs multiples 1-D, on utilise un modèle 1/4 (l'une des quatre roues) lors de la conception du système de suspension.

![image](https://user-images.githubusercontent.com/74740705/230244810-cca0e201-6451-45f7-ab10-a84b919fed1c.png)

Le but de ce projet est d'implémenter et de comparer deux stratégies de contrôle différentes : la commande LQR et la commande de placement de pôles. Ces deux stratégies seront utilisées pour réguler le déplacement vertical du corps de la voiture lors de la conduite sur une route bosselée. Les performances des deux stratégies de contrôle seront comparées en termes de leur capacité à réduire le mouvement du corps et à améliorer le confort de conduite.

![image](https://user-images.githubusercontent.com/74740705/230244078-e357e77b-0f83-41c8-ac3b-96445b789093.png)

![image](https://user-images.githubusercontent.com/74740705/230244166-ffb99639-d5ea-46f9-bbff-c55ab93b6f09.png)

À partir de l'image ci-dessus et de la loi de Newton, nous pouvons obtenir les équations dynamiques suivantes : 

![image](https://user-images.githubusercontent.com/74740705/230244487-fe0b8aa7-5288-4d90-aad1-c8844fc97356.png)

Le modèle de simulation de suspension automobile est un outil essentiel pour la conception et l'évaluation des performances de la suspension. Le modèle Simulink de ce système utilise les lois de la dynamique Newtonienne pour simuler les réponses de la suspension à différents mouvements de la roue et du corps de la voiture. Le modèle est basé sur deux masses reliées par un ressort et un amortisseur, et les forces agissant sur chaque masse sont calculées en utilisant la deuxième loi de Newton. Les positions verticales des deux masses sont les sorties du modèle, permettant l'évaluation des performances de la suspension.

Le modèle Simulink peut être étendu pour inclure des contrôleurs, tels que la commande LQR et la commande de placement de pôles, pour améliorer la réponse de la suspension et réduire les vibrations du corps de la voiture. Les blocs Simulink dédiés peuvent être utilisés pour ajouter ces contrôleurs, permettant l'ajustement des paramètres et la visualisation de leurs effets sur la réponse de la suspension. En somme, ce modèle de simulation est un outil puissant pour la compréhension et l'optimisation des performances de la suspension automobile.

Simulation en boucle ouverte :

La modélisation de ce système en boucle ouverte nécessite de sommer les forces agissant sur les deux masses (corps et suspension) et d'intégrer deux fois les accélérations de chaque masse pour obtenir les vitesses et les positions. Pour cela, nous allons appliquer la loi de Newton à chaque masse.

Pour commencer la simulation, ouvrez Simulink et créez un nouveau modèle. Nous allons tout d'abord modéliser les intégrales des accélérations des masses, avant de passer à l'étape suivante qui consiste à sommer les forces.

![image](https://user-images.githubusercontent.com/74740705/230245155-f03061a6-d969-4465-b3b0-d60693eef5b9.png)

L'animation de la suspension automobile permet de visualiser le comportement de la suspension en réponse à des mouvements de la roue et du corps de la voiture. Elle montre comment les forces s'appliquent sur les masses et comment elles sont amorties par le ressort et l'amortisseur.

Dans l'animation, on peut voir les deux masses reliées par un ressort et un amortisseur, représentant la suspension d'une roue de la voiture. Lorsqu'une force est appliquée à la roue, la masse de la roue bouge vers le haut ou vers le bas, entraînant la masse de la carrosserie de la voiture. Les forces s'appliquant sur chaque masse sont calculées en utilisant la deuxième loi de Newton, et les positions verticales des deux masses sont les sorties du modèle.

![image](https://user-images.githubusercontent.com/74740705/230245214-f547aa99-e22e-465e-8043-d1367e92c401.png)



