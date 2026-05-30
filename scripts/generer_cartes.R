# =========================================================================
# SCRIPT DE PUBLIPOSTAGE : COMPILATION PDF ET CONVERSION AUTOMATIQUE EN PNG
# =========================================================================

# 1. Chargement des bibliothèques nécessaires
library(rmarkdown)
library(pdftools)

# 2. Lecture de la liste des invités (doit contenir une colonne "Nom")
if (!file.exists("destinataires.csv")) {
  stop("Le fichier 'invites.csv' est introuvable dans le répertoire de travail.")
}
liste_invites <- read.csv("destinataires.csv", stringsAsFactors = FALSE, encoding = "UTF-8")

# 3. Création du dossier final s'il n'existe pas
dossier_sortie <- "./resultats"
if (!dir.exists(dossier_sortie)) {
  dir.create(dossier_sortie)
}

# 4. Boucle de génération personnalisée
for (i in 1:nrow(liste_invites)) {
  
  nom_personne <- liste_invites$Nom[i]
  
  # Nettoyage du nom pour créer un nom de fichier propre sans espaces
  nom_propre <- gsub("[^[:alnum:]]", "_", nom_personne)
  chemin_pdf_temporaire <- file.path(dossier_sortie, paste0("temp_", nom_propre, ".pdf"))
  chemin_png_final <- file.path(dossier_sortie, paste0("carte_", nom_propre, ".png"))
  
  message("--- Génération pour : ", nom_personne, " ---")
  
  # A. Compilation du fichier Rmd en PDF temporaire
  tryCatch({
    render(
      input = "template.Rmd",
      output_file = chemin_pdf_temporaire,
      params = list(nom = nom_personne),
      quiet = TRUE
    )
    
    # B. Conversion instantanée du PDF en image PNG (Haute Résolution 300 DPI)
    pdf_convert(
      pdf = chemin_pdf_temporaire,
      format = "png",
      pages = 1,
      dpi = 300,
      filenames = chemin_png_final
    )
    
    # C. Nettoyage : Suppression du fichier PDF temporaire
    file.remove(chemin_pdf_temporaire)
    
    message("✅ Image PNG créée avec succès : ", basename(chemin_png_final))
    
  }, error = function(e) {
    message("❌ Erreur lors de la génération pour ", nom_personne, " : ", e$message)
  })
}

message("=========================================================")
message("Opération terminée ! Vos cartes PNG sont dans le dossier : ", dossier_sortie)
message("=========================================================")
