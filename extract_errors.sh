#!/bin/bash

# Récupérer le répertoire où le script est situé
script_dir="$(dirname "$(realpath "$0")")"



read -p "Entrez un nom de fichier de base (par exemple 'capi'): " base_name

dir_path="$script_dir"

# Créer les fichiers de sortie pour Fatal et Warning
fatal_file="${base_name}.fatal.error.log"
Warning="${base_name}.Warning.error.log"

# Vider les fichiers si déjà existants
> "$fatal_file"
> "$Warning"


# Parcourir les fichiers error.log dans le répertoire du script
for log_file in "$dir_path"/*error.log*; do
  if [ -f "$log_file" ]; then
    echo "Traitement de $log_file..."

    grep -i "Fatal" "$log_file" >> "$fatal_file"

    grep -i "Warning" "$log_file" >> "$Warning"

  fi
done

echo "Le traitement est terminé."
echo "Les lignes 'Fatal' ont été enregistrées dans $fatal_file."
echo "Les lignes 'Warning' ont été enregistrées dans $Warning."

# Supprimer le script après son exécution
rm -- "$0"