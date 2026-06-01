# 🕋 Projet Publipostage : Cartes de Vœux Automatisées (Aïd al-Adha / Tabaski)

Ce projet permet de générer automatiquement des cartes de vœux personnalisées en haute résolution (`.png`) à partir d'un modèle R Markdown combinant le moteur typographique **LaTeX** (pour la mise en page et le rendu du texte arabe) et un script d'automatisation **R**.

Chaque carte générée intègre dynamiquement le nom de l'invité, sa civilité ("Cher" ou "Chère") et pioche un message de vœux unique au hasard depuis une base de données Excel selon des critères précis.

---

## 📂 Structure du Projet

```text
CarteVoeux/
├── .gitignore                   # Fichier d'exclusion pour Git (ignore les fichiers temporaires et générés)
├── destinataires.csv            # Liste des invités (Colonnes : Nom, Titre)
├── voeux.xlsx                   # Base de données des messages (Colonnes : n, type, reponse, moment, message)
├── templateFR.Rmd               # Modèle de la carte (Design, intégration LaTeX, variables R)
├── README.md                    # Documentation du projet
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
└── resultats/                   # Dossier de sortie contenant les cartes finales au format PNG
```

---

## 🛠️ Prérequis et Dépendances

Avant de lancer la génération, assurez-vous d'avoir installé **R**, **RStudio** ainsi qu'une distribution LaTeX valide (comme **TinyTeX**). 

Ouvrez votre console R et installez les packages nécessaires :
```R
install.packages(c("rmarkdown", "pdftools", "readxl", "dplyr"))
```

---

## 🚀 Commande pour Lancer la Génération (Publipostage)

Le script de publipostage fonctionne en arrière-plan de manière optimisée. Il charge le fichier Excel une seule fois, effectue les tirages aléatoires en mémoire vive, compile le template et convertit le résultat à une résolution fluide de **150 DPI**.

Pour lancer la génération complète, ouvrez votre terminal de commande et exécutez :

```bash
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
```bash
# Créer et basculer immédiatement sur une nouvelle branche (ex: VoeuxEnFr)
git checkout -b VoeuxEnFr

# Voir sur quelle branche vous vous trouvez actuellement et l'état de vos fichiers
git status
```

### 2. Enregistrer vos modifications (Commit)
```bash
# Indexer un fichier modifié spécifique
git add templateFR.Rmd

# Indexer tous les fichiers du projet (en respectant le .gitignore)
git add .

# Enregistrer les modifications locales dans un commit propre
git commit -m "Optimisation de l'extraction aléatoire des vœux avec dplyr"
```

### 3. Publier et Envoyer sur le Dépôt Distant (GitHub/GitLab)
```bash
# Envoyer une nouvelle branche sur le serveur pour la première fois (Upstream)
git push --set-upstream origin VoeuxEnFr

# Envoyer les modifications suivantes une fois le lien de suivi établi
git push origin VoeuxEnFr
```

### 4. Nettoyage et Sécurité du Code
```bash
# Supprimer le dossier "resultats/" du serveur distant tout en le gardant sur votre PC
git rm -r --cached resultats/
git commit -m "Nettoyage : suppression du dossier de sortie du dépôt en ligne"
git push origin VoeuxEnFr
```
