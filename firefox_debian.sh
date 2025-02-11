#!/usr/bin/env bash

# Last Edit: 11.02.2025

echo ""
read -p "Einrichtung der Mozilla APT-Repository und Installation von Firefox
                      Beliebige Taste drücken um fortzufahren.
"
clear

# Verzeichnis für APT-Repository-Schlüssel erstellen, falls nicht vorhanden
sudo install -d -m 0755 /etc/apt/keyrings

# Importieren des signierten Schlüssels des Mozilla-APT-Repositories
wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null

# Überprüfen des Fingerabdrucks
FINGERPRINT=$(gpg -n -q --import --import-options import-show /etc/apt/keyrings/packages.mozilla.org.asc | awk '/pub/{getline; gsub(/^ +| +$/,""); print $0}')
EXPECTED_FINGERPRINT="35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3"

if [ "$FINGERPRINT" == "$EXPECTED_FINGERPRINT" ]; then
    echo "Der Schlüssel-Fingerabdruck stimmt überein ($FINGERPRINT)."
else
    echo "Überprüfung fehlgeschlagen: Der Fingerabdruck ($FINGERPRINT) stimmt nicht mit dem erwarteten überein."
    exit 1
fi

# Hinzufügen des Mozilla-APT-Repositories zu den Quellen
echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | sudo tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null

# Konfigurieren von APT, um Pakete aus dem Mozilla Repository zu priorisieren
echo '
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
' | sudo tee /etc/apt/preferences.d/mozilla

# Aktualisieren der Paketliste und Installation von Firefox
sudo apt update 
sudo apt install -y firefox

echo ""
echo "Firefox wurde erfolgreich installiert."