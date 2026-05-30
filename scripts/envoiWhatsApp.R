# =========================================================================
# SCRIPT DE PUBLIPOSTAGE WHATSAPP - PROTECTION ANTI-VALEURS "NA"
# =========================================================================

if (!file.exists("destinataires.csv")) {
  stop("Le fichier 'destinataires.csv' est introuvable. Placez-le dans le bon dossier.")
}
contacts <- read.csv("destinataires.csv", stringsAsFactors = FALSE, encoding = "UTF-8")

# Nettoyage de sécurité : Supprime les lignes où le numéro ou le nom est introuvable (NA)
contacts <- contacts[!is.na(contacts$Telephone) & contacts$Telephone != "", ]
contacts <- contacts[!is.na(contacts$Nom) & contacts$Nom != "", ]

html_content <- "
<!DOCTYPE html>
<html lang='fr'>
<head>
    <meta charset='UTF-8'>
    <title>Mon Publipostage Tabaski 2026</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f7f6; padding: 40px; }
        .container { max-width: 850px; background: white; margin: auto; padding: 30px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); border-radius: 12px; }
        h1 { color: #2c3e50; text-align: center; margin-bottom: 30px; font-weight: 600; }
        .instructions { background: #eef2f3; border-left: 5px solid #128C7E; padding: 15px; border-radius: 4px; margin-bottom: 25px; font-size: 14px; color: #555; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th { background-color: #128C7E; color: white; padding: 12px; text-align: left; }
        td { padding: 12px; border-bottom: 1px solid #e0e0e0; font-size: 14px; color: #333; }
        tr:hover { background-color: #f9f9f9; }
        .btn-send { background-color: #25D366; color: white; border: none; padding: 8px 16px; border-radius: 20px; cursor: pointer; text-decoration: none; font-weight: bold; display: inline-block; font-size: 13px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .btn-send:hover { background-color: #128C7E; }
        .badge-path { font-family: monospace; background: #f0f0f0; padding: 3px 6px; border-radius: 4px; color: #c0392b; font-size: 12px; }
    </style>
</head>
<body>

<div class='container'>
    <h1>Dépêches de Vœux Tabaski 2026 🌙</h1>
    
    <div class='instructions'>
        <strong>Procédure de distribution rapide :</strong><br>
        1. Cliquez sur le bouton vert <strong>Envoyer →</strong> : la messagerie de votre contact va s'ouvrir proprement.<br>
        2. Allez dans votre dossier informatique <span class='badge-path'>./resultats</span>, prenez l'image PNG correspondante.<br>
        3. Faites un **Glisser-Déposer** de l'image directement dans la discussion et appuyez sur **Entrée** !
    </div>

    <table>
        <thead>
            <tr>
                <th>Nom du Destinataire</th>
                <th>Numéro de Téléphone</th>
                <th>Fichier Carte (.png)</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
"

# Remplissage de la page
for (i in 1:nrow(contacts)) {
  nom_personne <- contacts$Nom[i]
  
  # Nettoyage strict des caractères du numéro de téléphone
  numero_tel <- gsub("[[:space:]+--------]", "", as.character(contacts$Telephone[i]))
  
  nom_propre <- gsub("[^[:alnum:]]", "_", nom_personne)
  nom_carte <- paste0("carte_", nom_propre, ".png")
  
  # Format de lien universel WhatsApp (wa.me) exempt de bugs de redirection locale
  url_whatsapp <- paste0("https://wa.me/", numero_tel)
  
  html_content <- paste0(html_content, "
            <tr>
                <td><strong>", nom_personne, "</strong></td>
                <td>+", numero_tel, "</td>
                <td><span class='badge-path'>", nom_carte, "</span></td>
                <td><a href='", url_whatsapp, "' target='_blank' class='btn-send'>Envoyer →</a></td>
            </tr>")
}

html_content <- paste0(html_content, "
        </tbody>
    </table>
</div>

</body>
</html>
")

# Sauvegarde finale
writeLines(html_content, "Lancer_Envoi_WhatsApp.html", useBytes = TRUE)
utils::browseURL("Lancer_Envoi_WhatsApp.html")

message("L'interface 'Lancer_Envoi_WhatsApp.html' a été nettoyée et regénérée avec succès !")
