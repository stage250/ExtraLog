#!/bin/bash
read -p "Entrez un nom de fichier de base (par exemple 'capi'): " base_name

dir_path=$(pwd)

# Créer les fichiers de sortie pour Fatal et Warning
fatal_file="${base_name}.fatal.error.log"
Warning="${base_name}.warning.error.log"

# Vider les fichiers si déjà existants
> "$fatal_file"
> "$Warning"


# Parcourir les fichiers error.log dans le répertoire du script
for log_file in "$dir_path"/*error.log*; do
  # -f : fichier régulier || existence du fichier
  if [ -f "$log_file" ]; then
    echo "Traitement de $log_file..."

    # -i : insensible à la casse
    grep -i "Fatal" "$log_file" >> "$fatal_file"

    # -E : expression régulière étendue
    # -u : ignorer les doublons
    grep -i "Warning" "$log_file" | \
      sed -E 's/\[[^]]*\] \[proxy_fcgi:error\] \[pid [0-9]*:tid [0-9]*\] \[(client|remote) [^]]*\] AH01071: Got error //' | \
      sort -u >> "$Warning"

  fi
done

echo "Le traitement est terminé."
echo "Les lignes 'Fatal' ont été enregistrées dans $fatal_file."
echo "Les lignes 'Warning' ont été enregistrées dans $Warning."

# Supprimer le script après son exécution
rm -- "$dir_path/extract_errors.sh"
