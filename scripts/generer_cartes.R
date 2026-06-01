library(rmarkdown)
library(pdftools)
library(readxl)
library(dplyr)

# Lancement du chronomètre global
temps_debut_global <- Sys.time()

# 1. Chargement et vérification des fichiers sources
if (!file.exists("data/destinataires.csv")) {
  stop("Le fichier 'destinataires.csv' est introuvable.")
}
if (!file.exists("data/voeux.xlsx")) {
  stop("Le fichier 'voeux.xlsx' est introuvable.")
}

liste_invites <- read.csv("data/destinataires.csv", stringsAsFactors = FALSE, encoding = "UTF-8")
liste_voeux <- read_excel("data/voeux.xlsx")
# liste_voeux <- liste_voeux[5:15,]
liste_voeux <- liste_voeux %>% dplyr::filter(reponse == "oui")

# 2. Création du dossier final s'il n'existe pas
dossier_sortie <- "./resultats"
if (!dir.exists(dossier_sortie)) {
  dir.create(dossier_sortie)
}

# Fixer le hasard pour obtenir le même tirage de vœux à chaque exécution (Optionnel)
set.seed(42)

# 3. Boucle de génération personnalisée
for (i in 1:nrow(liste_invites)) {
  
  temps_debut_carte <- Sys.time()
  
  nom_personne <- liste_invites$Nom[i]
  valeur_cher <- liste_invites$Titre[i]
  
  # Sélection d'un vœu au hasard dans le fichier Excel
  index_aleatoire <- liste_voeux %>% 
    slice_sample(n = 1) %>% 
    pull(message) 
  # valeur_voeu <- liste_voeux$message[index_aleatoire]
  valeur_voeu <- liste_voeux %>% 
    slice_sample(n = 1) %>% 
    pull(message) 
  
  # Nettoyage du nom pour le fichier final
  nom_propre <- gsub("[^[:alnum:]]", "_", nom_personne)
  chemin_pdf_temporaire <- file.path(dossier_sortie, paste0("temp_", nom_propre, ".pdf"))
  chemin_png_final <- file.path(dossier_sortie, paste0("carte_", nom_propre, ".png"))
  
  message("--- Génération pour : ", nom_personne, " ---")
  
  tryCatch({
    # A. Compilation du fichier Rmd en PDF temporaire
    render(
      input = "templateFR.Rmd",
      output_file = chemin_pdf_temporaire,
      params = list(
        nom = nom_personne, 
        titre = valeur_cher,
        voeu = valeur_voeu
      ),
      quiet = TRUE
    )
    
    # B. Conversion du PDF en image PNG (Format de nom dynamique pour éviter l'avertissement)
    chemin_png_format <- file.path(dossier_sortie, paste0("carte_", nom_propre, "_%d.%s"))
    
    pdf_convert(
      pdf = chemin_pdf_temporaire,
      format = "png",
      pages = 1,
      dpi = 150,
      filenames = chemin_png_format
    )
    
    # Ajustement cosmétique du nom pour enlever le "_1" ajouté automatiquement par pdftools
    file.rename(
      from = file.path(dossier_sortie, paste0("carte_", nom_propre, "_1.png")),
      to = chemin_png_final
    )
    
    # C. Nettoyage
    file.remove(chemin_pdf_temporaire)
    
    temps_fin_carte <- Sys.time()
    duree_carte <- round(as.numeric(difftime(temps_fin_carte, temps_debut_carte, units = "secs")), 1)
    
    message("✅ Image PNG créée avec succès [", duree_carte, "s] : ", basename(chemin_png_final))
    
  }, error = function(e) {
    message("❌ Erreur lors de la génération pour ", nom_personne, " : ", e$message)
  })
}

# 4. Bilan global du temps d'exécution
temps_fin_global <- Sys.time()
duree_totale <- round(as.numeric(difftime(temps_fin_global, temps_debut_global, units = "secs")), 1)

if (duree_totale > 60) {
  temps_affichage <- paste0(round(duree_totale / 60, 1), " minute(s)")
} else {
  temps_affichage <- paste0(duree_totale, " seconde(s)")
}

message("=========================================================")
message("Opération terminée ! Vos cartes PNG sont dans le dossier : ", dossier_sortie)
message("⏱️ Temps total d'exécution : ", temps_affichage)
message("=========================================================")
