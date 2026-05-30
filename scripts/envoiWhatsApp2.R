# =========================================================================
# SCRIPT AUTOMATIQUE WHATSAPP - SYNTAXE CHROMOTE CORRIGÉE
# =========================================================================

if (!requireNamespace("chromote", lazy = TRUE)) install.packages("chromote")
library(chromote)

# 1. Configuration des variables d'environnement de Chrome
# Force le mode VISIBLE (Headless = FALSE)
Sys.setenv(CHROMOTE_HEADLESS = "false")
options(chromote.headless = FALSE)

# Définition du chemin de l'exécutable Chrome
chrome_path <- "C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe"
Sys.setenv(CHROMOTE_CHROME = chrome_path)

# Pour éviter le bug de l'espace dans le chemin "HP 14", on force le profil dans un dossier temporaire Windows sans espace
dossier_profil <- "C:\\temp_chrome_profile_whatsapp"
if (!dir.exists(dossier_profil)) dir.create(dossier_profil, recursive = TRUE)

# Configuration des arguments de lancement via la variable globale du package
Sys.setenv(CHROMOTE_CHROME_ARGS = paste0(
  "--user-data-dir=", dossier_profil, " ",
  "--no-sandbox ",
  "--disable-gpu"
))

# 2. Lecture de la liste des contacts
if (!file.exists("destinataires.csv")) {
  stop("Le fichier 'destinataires.csv' est introuvable.")
}
contacts <- read.csv("destinataires.csv", stringsAsFactors = FALSE, encoding = "UTF-8")
contacts <- contacts[!is.na(contacts$Telephone) & contacts$Telephone != "", ]

# 3. DÉMARRAGE DE LA SESSION CORRIGÉE
# On appelle l'initialisation standard sans arguments interdits
b <- ChromoteSession$new()

# Masquer l'empreinte de robot pour éviter le blocage de WhatsApp
agent_humain <- "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
b$Network$setUserAgentOverride(userAgent = agent_humain)

# 4. Connexion initiale
message("Ouverture de Google Chrome et connexion à WhatsApp Web...")
b$Page$navigate("https://whatsapp.com")

# =========================================================================
# TÉLÉPHONE EN MAIN : SCANNEZ LE QR CODE MAINTENANT
# =========================================================================
message("⚠️ IMPORTANT : Une fenêtre de navigation Google Chrome vient de s'ouvrir.")
message("Scannez le QR Code de WhatsApp immédiatement.")
message("Le script patiente 35 secondes pour vous laisser le temps de vous connecter...")
Sys.sleep(35)

# 5. Boucle d'envoi automatique
for (i in 1:nrow(contacts)) {
  nom_personne <- contacts$Nom[i]
  numero_tel <- gsub("[[:space:]+---------]", "", as.character(contacts$Telephone[i]))
  
  nom_propre <- gsub("[^[:alnum:]]", "_", nom_personne)
  chemin_image <- normalizePath(file.path("./resultats", paste0("carte_", nom_propre, ".png")), mustWork = FALSE)
  
  if (!file.exists(chemin_image)) {
    message("❌ Image introuvable pour ", nom_personne, ", envoi ignoré.")
    next
  }
  
  message("-> Navigation vers la discussion de : ", nom_personne)
  url_contact <- paste0("https://whatsapp.com/send?phone=", numero_tel)
  b$Page$navigate(url_contact)
  
  # Attente indispensable pour laisser la discussion se synchroniser
  Sys.sleep(12)
  
  tryCatch({
    # A. Récupération du document DOM de la page
    document_interne <- b$DOM$getDocument()
    
    # B. Recherche de la zone d'injection de l'image
    champ_chargement <- b$DOM$querySelector(document_interne$root$nodeId, 'input[type="file"]')
    
    if (!is.null(champ_chargement)) {
      # Injection de la carte PNG personnalisée
      b$DOM$setFileInputFiles(files = list(chemin_image), nodeId = champ_chargement$nodeId)
      Sys.sleep(4) # Attente du chargement de la miniature
      
      # C. Simulation de la touche Entrée pour envoyer la photo
      b$Input$dispatchKeyEvent(type = "keyDown", key = "Enter")
      b$Input$dispatchKeyEvent(type = "keyUp", key = "Enter")
      
      message("✅ Carte transmise avec succès à : ", nom_personne)
    } else {
      message("❌ Impossible d'accéder au module d'envoi pour ", nom_personne)
    }
    
    # Pause anti-spam réglementaire
    Sys.sleep(5)
    
  }, error = function(e) {
    message("⚠️ Erreur lors de l'envoi pour ", nom_personne, " : ", e$message)
  })
}

# 6. Fermeture
b$parent$close()
message("Campagne de publipostage terminée avec succès !")






library(rvest)

url <- "wa.me/773380329"
url <- "www.google.com"
url <- "https://api.whatsapp.com/send/?phone=773380329"
url <- "https://wa.me/773380329"

page <- read_html_live(url)

# Ajoutez un délai et vérifiez la connexion
page <- read_html_live("https://www.google.com")
page <- read_html_live("https://api.whatsapp.com/send/?phone=773380329")
page$view()  # Pour voir ce que Chrome voit réellement
Sys.sleep(3) # Attendre le chargement

str(page)















