# 🕋 Projet Publipostage : Cartes de Vœux Automatisées (Aïd al-Adha / Tabaski)

Ce projet permet de générer automatiquement des cartes de vœux personnalisées en haute résolution (.png) à partir d’un modèle R Markdown combinant le moteur typographique LaTeX et un script d’automatisation R.
Chaque carte générée intègre dynamiquement le nom de l’invité, sa civilité ("Cher" ou "Chère") et pioche un message de vœux unique au hasard depuis une base de données Excel selon des critères précis.
Le modèle repose sur plusieurs techniques avancées de publication assistée par ordinateur (PAO) avec R et LaTeX :

# Techniques Utilisées

## 1. Gestion dynamique des variables (params)
Le document R Markdown utilise des paramètres (params) déclarés dans son en-tête YAML. Ces variables agissent comme des points d'ancrage que le script R de publipostage va écraser à chaque itération avec les données de l'invité en cours.

```text
params:
  nom: "Destinataire" 
  titre: "Cher"
  voeu: "Texte du vœu par défaut si vide"
```

## 2. Injection et mise en forme des paramètres dans le texte
Les paramètres R sont injectés directement au milieu du code LaTeX à l'aide de la syntaxe d'évaluation en ligne de R Markdown (`r params$...`). Ils sont stylisés à la volée (mise en gras, passage en petites capitales, modification d'échelle).

```text
\scalebox{1.5}{% Multiplie la taille sur la même ligne
  {\policenom \textbf{\textsc{`r params$titre` `r params$nom`}}}
}
```

## 3. Intégration d'un arrière-plan personnalisé complet
Grâce aux packages LaTeX graphicx et eso-pic, le script applique une image de fond (templateTabaski.png) qui s'ajuste parfaitement aux dimensions réelles de la page (papier) sans marge blanche, servant de canevas graphique pour la carte.

```text
\AddToShipoutPictureBG*{
  \includegraphics[width=\paperwidth,height=\paperheight]{images/templateTabaski.png}
}
```

## 4. Déclaration et utilisation de polices typographiques externes
Pour assurer une esthétique unique (style manuscrit/cursif), le moteur de rendu xelatex charge directement un fichier de police TrueType (.ttf) stocké localement dans le projet sans nécessiter son installation sur le système d'exploitation.

```text
header-includes:
  - \newfontfamily\policenom{Mynerve-Regular}[Path = fonts/Mynerve/, Extension = .ttf]
```


```text
{\policenom \fontsize{14}{8}\selectfont } # Applique la police Mynerve avec une taille de 14pt
```

## 5. Typographie Arabe Sacrée (ArabTeX)
Le projet intègre le package arabtex couplé à utf8 pour restituer les douas traditionnels avec un rendu calligraphique arabe irréprochable (gestion automatique des ligatures et de la vocalisation complète via \fullvocalize), indispensable pour les vœux de l'Aïd.


---

## 📂 Structure du Projet

```text
CarteVoeux/
├── .gitignore                   # Fichier d'exclusion pour Git
├── templateFR.Rmd               # Modèle de la carte (Design, intégration LaTeX, variables R)
├── README.md                    # Documentation du projet
│
├── data/
│   └── destinataires.csv            # Liste des invités (Colonnes : Nom, Titre)
│   └── voeux.xlsx                   # Base de données des messages 
│
├── scripts/
│   └── generer_cartes.R         # Script principal d'automatisation et de publipostage
│
├── images/
│   ├── templateTabaski.png      # Image de fond de la carte (arrière-plan)
│   ├── tabaski2026.png          # Titre principal ou logo graphique
│   └── sallahouAleyhiWaSallam.png # Calligraphie de bénédiction pour les douas
│
├── fonts/
│   └── Mynerve/
│       └── Mynerve-Regular.ttf  # Police cursive personnalisée pour le nom de l'invité
│
└── resultats/                   # Dossier de sortie contenant les cartes au format PNG

```

---

## 🛠️ Prérequis et Dépendances

Avant de lancer la génération, assurez-vous d'avoir installé **R**, **RStudio** ainsi qu'une distribution LaTeX valide (comme **TinyTeX**). 

Ouvrez votre console R et installez les packages nécessaires :

```text
install.packages(c("rmarkdown", "pdftools", "readxl", "dplyr"))

```

---

## 🚀 Commande pour Lancer la Génération (Publipostage)

Le script de publipostage fonctionne en arrière-plan de manière optimisée. Il charge le fichier Excel une seule fois, effectue les tirages aléatoires en mémoire vive, compile le template et convertit le résultat à une résolution fluide de **150 DPI**.

Pour lancer la génération complète, ouvrez votre terminal de commande et exécutez :

```text
# 1. Placez-vous à la racine de votre projet
cd "D:/Users/HP 14/Desktop/R RSTUDIO/CarteVoeux"

# 2. Exécutez le script avec Rscript
Rscript scripts/generer_cartes.R

```

*Les logs de traitement s'afficheront en temps réel dans votre console avec une mesure précise du temps mis pour chaque carte (ex: `✅ Image PNG créée avec succès [1.8s] : carte_Salimata_Gassama.png`). Le bilan temporel complet s'affichera à la fin.*

---

## 🛠️ Commandes Git Utiles pour le Projet

Voici les commandes essentielles utilisées au quotidien pour gérer les versions et l'historique de ce projet :

### 1. Gérer les Branches (Développement sécurisé)

```text
# Créer et basculer immédiatement sur une nouvelle branche (ex: VoeuxEnFr)
git checkout -b VoeuxEnFr

# Voir sur quelle branche vous vous trouvez actuellement et l'état de vos fichiers
git status
```

### 2. Enregistrer vos modifications (Commit)

```text
# Indexer un fichier modifié spécifique
git add templateFR.Rmd

# Indexer tous les fichiers du projet (en respectant le .gitignore)
git add .

# Enregistrer les modifications locales dans un commit propre
git commit -m "Optimisation de l'extraction aléatoire des vœux avec dplyr"
```

### 3. Publier et Envoyer sur le Dépôt Distant (GitHub/GitLab)

````text
# Envoyer une nouvelle branche sur le serveur pour la première fois (Upstream)
git push --set-upstream origin VoeuxEnFr

# Envoyer les modifications suivantes une fois le lien de suivi établi
git push origin VoeuxEnFr

```


## 4. Gérer les Branches et mettre son travail en attente (git stash)
Si vous devez changer de branche alors que vos modifications actuelles ne sont pas encore prêtes à être commitées, vous devez utiliser le système de mise en attente (le "remisage") pour ne pas perdre votre travail.

### 4.1 Mettre son travail actuel en attente (à l'abri) :

```text
# Sauvegarde vos fichiers modifiés et non suivis (-u) sans faire de commit
git stash -u

```

### 4.2 Changer de branche :

```text
# Revenir sur la branche principale
git checkout main

```


```text
# Ou aller sur une autre branche existante
git checkout VoeuxEnFr

```

### 4.3 Récupérer son travail mis en attente :


```text
# Une fois revenu sur votre branche de travail, restaure vos fichiers mis de côté
git stash pop

```

---
## 5. Fusionner une branche dans la branche principale (git merge)
Une fois que vos tests sur la version française (templateFR.Rmd et son script) sont totalement validés et que vous souhaitez intégrer ce travail dans votre branche principale main, suivez cette procédure stricte :


```text
# 1. Basculez sur la branche principale
git checkout main

# 2. (Recommandé) Récupérez la dernière version du serveur pour être à jour
git pull origin main

# 3. Fusionnez la branche de travail (ex: VoeuxEnFr) dans main
git merge VoeuxEnFr

# 4. Enregistrez un message de validation pour la fusion (généré automatiquement par Git)

# 5. Poussez le résultat final fusionné sur le serveur distant
git push origin main

```

Une fois la fusion terminée et publiée, vous pouvez supprimer votre branche de travail locale devenue inutile avec la commande git branch -d VoeuxEnFr.



### 6. Nettoyage et Sécurité du Code

```text
# Supprimer le dossier "resultats/" du serveur distant tout en le gardant sur votre PC
git rm -r --cached resultats/
git commit -m "Nettoyage : suppression du dossier de sortie du dépôt en ligne"
git push origin VoeuxEnFr

```
