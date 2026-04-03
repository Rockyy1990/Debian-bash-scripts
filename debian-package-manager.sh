#!/bin/bash

# Farben definieren
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Funktionen für Ausgabe
print_header() {
    clear
    echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${WHITE}     Debian/Ubuntu Package Manager${CYAN}      ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
    echo ""
}

print_error() {
    echo -e "${RED}✗ Fehler: $1${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# APT Menü
apt_menu() {
    while true; do
        print_header
        echo -e "${YELLOW}=== APT PAKETMANAGER MENÜ ===${NC}"
        echo ""
        echo -e "${GREEN}1)${NC} Paketlisten aktualisieren (apt update)"
        echo -e "${GREEN}2)${NC} Pakete installieren"
        echo -e "${GREEN}3)${NC} Pakete entfernen (mit Abhängigkeiten)"
        echo -e "${GREEN}4)${NC} Einzelnes Paket entfernen (ohne Abhängigkeiten)"
        echo -e "${GREEN}5)${NC} Nach Paketen suchen"
        echo -e "${GREEN}6)${NC} Paketinformationen anzeigen"
        echo -e "${GREEN}7)${NC} Systemupgrade (apt upgrade)"
        echo -e "${GREEN}8)${NC} Vollständiges Upgrade (apt full-upgrade)"
        echo -e "${GREEN}9)${NC} Cache leeren (apt clean)"
        echo -e "${GREEN}10)${NC} APT Reparatur & Wartung"
        echo -e "${GREEN}11)${NC} Zurück zum Hauptmenü"
        echo ""
        read -p "Wähle eine Option [1-11]: " choice

        case $choice in
            1)
                print_header
                print_info "Aktualisiere Paketlisten..."
                sudo apt update
                if [ $? -eq 0 ]; then
                    print_success "Paketlisten erfolgreich aktualisiert"
                else
                    print_error "Fehler beim Aktualisieren der Paketlisten"
                fi
                read -p "Drücke Enter um fortzufahren..."
                ;;
            2)
                print_header
                read -p "Paketname eingeben (durch Leerzeichen trennen): " packages
                if [ -z "$packages" ]; then
                    print_error "Keine Pakete eingegeben"
                else
                    print_info "Installiere Pakete: $packages"
                    sudo apt install $packages
                    if [ $? -eq 0 ]; then
                        print_success "Pakete erfolgreich installiert"
                    else
                        print_error "Fehler beim Installieren"
                    fi
                fi
                read -p "Drücke Enter um fortzufahren..."
                ;;
            3)
                print_header
                read -p "Paketname eingeben (durch Leerzeichen trennen): " packages
                if [ -z "$packages" ]; then
                    print_error "Keine Pakete eingegeben"
                else
                    print_warning "Entferne Pakete mit Abhängigkeiten: $packages"
                    sudo apt remove $packages
                    if [ $? -eq 0 ]; then
                        print_success "Pakete erfolgreich entfernt"
                    else
                        print_error "Fehler beim Entfernen"
                    fi
                fi
                read -p "Drücke Enter um fortzufahren..."
                ;;
            4)
                print_header
                read -p "Paketname eingeben: " package
                if [ -z "$package" ]; then
                    print_error "Keine Paket eingegeben"
                else
                    print_warning "Entferne Paket ohne Abhängigkeiten: $package"
                    sudo apt remove --no-install-recommends $package
                    if [ $? -eq 0 ]; then
                        print_success "Paket erfolgreich entfernt"
                    else
                        print_error "Fehler beim Entfernen"
                    fi
                fi
                read -p "Drücke Enter um fortzufahren..."
                ;;
            5)
                print_header
                read -p "Suchbegriff eingeben: " search_term
                if [ -z "$search_term" ]; then
                    print_error "Kein Suchbegriff eingegeben"
                else
                    print_info "Suche nach: $search_term"
                    apt search $search_term
                fi
                read -p "Drücke Enter um fortzufahren..."
                ;;
            6)
                print_header
                read -p "Paketname eingeben: " package
                if [ -z "$package" ]; then
                    print_error "Kein Paket eingegeben"
                else
                    print_info "Zeige Informationen für: $package"
                    apt show $package
                fi
                read -p "Drücke Enter um fortzufahren..."
                ;;
            7)
                print_header
                print_info "Führe Systemupgrade durch (apt upgrade)..."
                sudo apt upgrade
                if [ $? -eq 0 ]; then
                    print_success "Systemupgrade erfolgreich abgeschlossen"
                else
                    print_error "Fehler beim Systemupgrade"
                fi
                read -p "Drücke Enter um fortzufahren..."
                ;;
            8)
                print_header
                print_warning "Führe vollständiges Upgrade durch (apt full-upgrade)..."
                print_warning "Dies kann auch Pakete entfernen oder aktualisieren"
                sudo apt full-upgrade
                if [ $? -eq 0 ]; then
                    print_success "Vollständiges Upgrade erfolgreich abgeschlossen"
                else
                    print_error "Fehler beim Upgrade"
                fi
                read -p "Drücke Enter um fortzufahren..."
                ;;
            9)
                print_header
                print_info "Leere APT-Cache..."
                sudo apt clean
                if [ $? -eq 0 ]; then
                    print_success "APT-Cache erfolgreich geleert"
                else
                    print_error "Fehler beim Leeren des Cache"
                fi
                read -p "Drücke Enter um fortzufahren..."
                ;;
            10)
                apt_repair_menu
                ;;
            11)
                return
                ;;
            *)
                print_error "Ungültige Option"
                sleep 1
                ;;
        esac
    done
}

# APT Reparatur Menü
apt_repair_menu() {
    while true; do
        print_header
        echo -e "${RED}=== APT REPARATUR & WARTUNG ===${NC}"
        echo ""
        echo -e "${GREEN}1)${NC} Abhängigkeiten reparieren (apt --fix-broken install)"
        echo -e "${GREEN}2)${NC} Verwaiste Pakete entfernen (apt autoremove)"
        echo -e "${GREEN}3)${NC} Verwaiste Abhängigkeiten entfernen (apt autoclean)"
        echo -e "${GREEN}4)${NC} Paketdatenbank überprüfen und reparieren"
        echo -e "${GREEN}5)${NC} Doppelte Paketquellen entfernen"
        echo -e "${GREEN}6)${NC} Beschädigte Pakete reparieren"
        echo -e "${GREEN}7)${NC} Vollständige Systemreparatur"
        echo -e "${GREEN}8)${NC} APT-Quellen überprüfen"
        echo -e "${GREEN}9)${NC} Paketlisten neu aufbauen"
        echo -e "${GREEN}10)${NC} Zurück zum APT-Menü"
        echo ""
        read -p "Wähle eine Option [1-10]: " choice

        case $choice in
            1)
                print_header
                print_warning "Repariere fehlerhafte Abhängigkeiten..."
                sudo apt --fix-broken install
                if [ $? -eq 0 ]; then
                    print_success "Abhängigkeiten erfolgreich repariert"
                else
                    print_error "Fehler bei der Reparatur"
                fi
                read -p "Drücke Enter um fortzufahren..."
                ;;
            2)
                print_header
                print_info "Suche verwaiste Pakete..."
                orphaned=$(apt autoremove --dry-run | grep "^Removing")

                if [ -z "$orphaned" ]; then
                    print_success "Keine verwaisten Pakete gefunden"
                else
                    echo -e "${YELLOW}Verwaiste Pakete gefunden:${NC}"
                    apt autoremove --dry-run
                    echo ""
                    read -p "Entfernen? (j/N): " confirm

                    if [[ $confirm == "j" || $confirm == "J" ]]; then
                        sudo apt autoremove
                        if [ $? -eq 0 ]; then
                            print_success "Verwaiste Pakete entfernt"
                        else
                            print_error "Fehler beim Entfernen"
                        fi
                    fi
                fi
                read -p "Drücke Enter um fortzufahren..."
                ;;
            3)
                print_header
                print_info "Leere verwaiste Abhängigkeiten..."
                sudo apt autoclean
                if [ $? -eq 0 ]; then
                    print_success "Verwaiste Abhängigkeiten entfernt"
                else
                    print_error "Fehler beim Entfernen"
                fi
                read -p "Drücke Enter um fortzufahren..."
                ;;
            4)
                print_header
                print_info "Überprüfe Paketdatenbank..."
                sudo apt check
                if [ $? -eq 0 ]; then
                    print_success "Paketdatenbank ist OK"
                else
                    print_warning "Probleme gefunden - versuche zu reparieren..."
                    sudo dpkg --configure -a
                    sudo apt --fix-broken install
                fi
                read -p "Drücke Enter um fortzufahren..."
                ;;
            5)
                print_header
                print_info "Überprüfe auf doppelte Paketquellen..."

                if command -v apt-listchanges &> /dev/null; then
                    print_info "Zeige Paketquellen..."
                    cat /etc/apt/sources.list
                    echo ""
                    print_info "Zusätzliche Quellen in /etc/apt/sources.list.d/:"
                    ls -la /etc/apt/sources.list.d/ 2>/dev/null || print_info "Keine zusätzlichen Quellen gefunden"
                else
                    print_info "Zeige Paketquellen..."
                    cat /etc/apt/sources.list
                fi
                read -p "Drücke Enter um fortzufahren..."
                ;;
            6)
                print_header
                print_warning "Repariere beschädigte Pakete..."
                sudo dpkg --configure -a
                if [ $? -eq 0 ]; then
                    print_success "Beschädigte Pakete repariert"
                    print_info "Führe apt fix-broken durch..."
                    sudo apt --fix-broken install
                else
                    print_error "Fehler bei der Reparatur"
                fi
                read -p "Drücke Enter um fortzufahren..."
                ;;
            7)
                print_header
                print_warning "WARNUNG: Vollständige Systemreparatur wird durchgeführt!"
                print_warning "Dies führt mehrere Reparaturschritte nacheinander aus."
                read -p "Fortfahren? (j/N): " confirm

                if [[ $confirm == "j" || $confirm == "J" ]]; then
                    print_info "Schritt 1: Konfiguriere Pakete..."
                    sudo dpkg --configure -a

                    print_info "Schritt 2: Repariere fehlerhafte Abhängigkeiten..."
                    sudo apt --fix-broken install

                    print_info "Schritt 3: Aktualisiere Paketlisten..."
                    sudo apt update

                    print_info "Schritt 4: Überprüfe Paketdatenbank..."
                    sudo apt check

                    print_info "Schritt 5: Entferne verwaiste Pakete..."
                    sudo apt autoremove

                    print_info "Schritt 6: Leere verwaiste Abhängigkeiten..."
                    sudo apt autoclean

                    print_success "Vollständige Systemreparatur abgeschlossen"
                else
                    print_info "Abgebrochen"
                fi
                read -p "Drücke Enter um fortzufahren..."
                ;;
            8)
                print_header
                print_info "Zeige APT-Quellen..."
                echo ""
                echo -e "${CYAN}=== /etc/apt/sources.list ===${NC}"
                cat /etc/apt/sources.list | grep -v "^#" | grep -v "^$"
                echo ""

                if [ -d "/etc/apt/sources.list.d" ]; then
                    echo -e "${CYAN}=== /etc/apt/sources.list.d/ ===${NC}"
                    ls /etc/apt/sources.list.d/ 2>/dev/null || print_info "Keine zusätzlichen Quellen"
                fi
                read -p "Drücke Enter um fortzufahren..."
                ;;
            9)
                print_header
                print_warning "Baue Paketlisten neu auf..."
                print_info "Dies kann einige Zeit dauern"

                sudo rm -rf /var/lib/apt/lists/*
                sudo mkdir -p /var/lib/apt/lists/partial
                sudo apt update

                if [ $? -eq 0 ]; then
                    print_success "Paketlisten erfolgreich neu aufgebaut"
                else
                    print_error "Fehler beim Neuaufbau"
                fi
                read -p "Drücke Enter um fortzufahren..."
                ;;
            10)
                return
                ;;
            *)
                print_error "Ungültige Option"
                sleep 1
                ;;
        esac
    done
}

# Snap Menü (optional für Ubuntu)
snap_menu() {
    # Prüfe ob snap installiert ist
    if ! command -v snap &> /dev/null; then
        print_header
        print_error "snap ist nicht installiert"
        print_info "Installiere snap mit: sudo apt install snapd"
        read -p "Drücke Enter um fortzufahren..."
        return
    fi

    while true; do
        print_header
        echo -e "${MAGENTA}=== SNAP PAKETMANAGER MENÜ ===${NC}"
        echo ""
        echo -e "${GREEN}1)${NC} Snap-Pakete installieren"
        echo -e "${GREEN}2)${NC} Snap-Pakete entfernen"
        echo -e "${GREEN}3)${NC} Nach Snap-Paketen suchen"
        echo -e "${GREEN}4)${NC} Snap-Pakete aktualisieren (snap refresh)"
        echo -e "${GREEN}5)${NC} Installierte Snap-Pakete anzeigen"
        echo -e "${GREEN}6)${NC} Snap-Cache leeren"
        echo -e "${GREEN}7)${NC} Zurück zum Hauptmenü"
        echo ""
        read -p "Wähle eine Option [1-7]: " choice

        case $choice in
                        1)
                print_header
                read -p "Paketname eingeben (durch Leerzeichen trennen): " packages
                if [ -z "$packages" ]; then
                    print_error "Keine Pakete eingegeben"
                else
                    print_info "Installiere Snap-Pakete: $packages"
                    sudo snap install $packages
                    if [ $? -eq 0 ]; then
                        print_success "Snap-Pakete erfolgreich installiert"
                    else
                        print_error "Fehler beim Installieren"
                    fi
                fi
                read -p "Drücke Enter um fortzufahren..."
                ;;
            2)
                print_header
                read -p "Paketname eingeben (durch Leerzeichen trennen): " packages
                if [ -z "$packages" ]; then
                    print_error "Keine Pakete eingegeben"
                else
                    print_warning "Entferne Snap-Pakete: $packages"
                    sudo snap remove $packages
                    if [ $? -eq 0 ]; then
                        print_success "Snap-Pakete erfolgreich entfernt"
                    else
                        print_error "Fehler beim Entfernen"
                    fi
                fi
                read -p "Drücke Enter um fortzufahren..."
                ;;
            3)
                print_header
                read -p "Suchbegriff eingeben: " search_term
                if [ -z "$search_term" ]; then
                    print_error "Kein Suchbegriff eingegeben"
                else
                    print_info "Suche nach: $search_term"
                    snap search $search_term
                fi
                read -p "Drücke Enter um fortzufahren..."
                ;;
            4)
                print_header
                print_info "Aktualisiere Snap-Pakete..."
                sudo snap refresh
                if [ $? -eq 0 ]; then
                    print_success "Snap-Pakete erfolgreich aktualisiert"
                else
                    print_error "Fehler beim Aktualisieren"
                fi
                read -p "Drücke Enter um fortzufahren..."
                ;;
            5)
                print_header
                print_info "Zeige installierte Snap-Pakete..."
                snap list
                read -p "Drücke Enter um fortzufahren..."
                ;;
            6)
                print_header
                print_info "Leere Snap-Cache..."
                sudo snap set system refresh.retain=2
                print_success "Snap-Cache-Aufbewahrung auf 2 Versionen gesetzt"
                read -p "Drücke Enter um fortzufahren..."
                ;;
            7)
                return
                ;;
            *)
                print_error "Ungültige Option"
                sleep 1
                ;;
        esac
    done
}

# Flatpak Menü (optional)
flatpak_menu() {
    # Prüfe ob flatpak installiert ist
    if ! command -v flatpak &> /dev/null; then
        print_header
        print_error "flatpak ist nicht installiert"
        print_info "Installiere flatpak mit: sudo apt install flatpak"
        read -p "Drücke Enter um fortzufahren..."
        return
    fi

    while true; do
        print_header
        echo -e "${MAGENTA}=== FLATPAK PAKETMANAGER MENÜ ===${NC}"
        echo ""
        echo -e "${GREEN}1)${NC} Flatpak-Pakete installieren"
        echo -e "${GREEN}2)${NC} Flatpak-Pakete entfernen"
        echo -e "${GREEN}3)${NC} Nach Flatpak-Paketen suchen"
        echo -e "${GREEN}4)${NC} Flatpak-Pakete aktualisieren"
        echo -e "${GREEN}5)${NC} Installierte Flatpak-Pakete anzeigen"
        echo -e "${GREEN}6)${NC} Flatpak-Verzeichnisse bereinigen"
        echo -e "${GREEN}7)${NC} Zurück zum Hauptmenü"
        echo ""
        read -p "Wähle eine Option [1-7]: " choice

        case $choice in
            1)
                print_header
                read -p "Paketname eingeben (z.B. org.gnome.Gedit): " package
                if [ -z "$package" ]; then
                    print_error "Keine Paket eingegeben"
                else
                    print_info "Installiere Flatpak-Paket: $package"
                    flatpak install flathub $package
                    if [ $? -eq 0 ]; then
                        print_success "Flatpak-Paket erfolgreich installiert"
                    else
                        print_error "Fehler beim Installieren"
                    fi
                fi
                read -p "Drücke Enter um fortzufahren..."
                ;;
            2)
                print_header
                read -p "Paketname eingeben: " package
                if [ -z "$package" ]; then
                    print_error "Keine Paket eingegeben"
                else
                    print_warning "Entferne Flatpak-Paket: $package"
                    flatpak uninstall $package
                    if [ $? -eq 0 ]; then
                        print_success "Flatpak-Paket erfolgreich entfernt"
                    else
                        print_error "Fehler beim Entfernen"
                    fi
                fi
                read -p "Drücke Enter um fortzufahren..."
                ;;
            3)
                print_header
                read -p "Suchbegriff eingeben: " search_term
                if [ -z "$search_term" ]; then
                    print_error "Kein Suchbegriff eingegeben"
                else
                    print_info "Suche nach: $search_term"
                    flatpak search $search_term
                fi
                read -p "Drücke Enter um fortzufahren..."
                ;;
            4)
                print_header
                print_info "Aktualisiere Flatpak-Pakete..."
                flatpak update
                if [ $? -eq 0 ]; then
                    print_success "Flatpak-Pakete erfolgreich aktualisiert"
                else
                    print_error "Fehler beim Aktualisieren"
                fi
                read -p "Drücke Enter um fortzufahren..."
                ;;
            5)
                print_header
                print_info "Zeige installierte Flatpak-Pakete..."
                flatpak list --app
                read -p "Drücke Enter um fortzufahren..."
                ;;
            6)
                print_header
                print_info "Bereinige Flatpak-Verzeichnisse..."
                flatpak uninstall --unused
                if [ $? -eq 0 ]; then
                    print_success "Flatpak-Verzeichnisse bereinigt"
                else
                    print_error "Fehler beim Bereinigen"
                fi
                read -p "Drücke Enter um fortzufahren..."
                ;;
            7)
                return
                ;;
            *)
                print_error "Ungültige Option"
                sleep 1
                ;;
        esac
    done
}

# Hauptmenü
main_menu() {
    while true; do
        print_header
        echo -e "${WHITE}=== HAUPTMENÜ ===${NC}"
        echo ""
        echo -e "${GREEN}1)${NC} APT Paketmanager"
        echo -e "${GREEN}2)${NC} SNAP Paketmanager"
        echo -e "${GREEN}3)${NC} FLATPAK Paketmanager"
        echo -e "${GREEN}4)${NC} Beenden"
        echo ""
        read -p "Wähle eine Option [1-4]: " choice

        case $choice in
            1)
                apt_menu
                ;;
            2)
                snap_menu
                ;;
            3)
                flatpak_menu
                ;;
            4)
                clear
                echo -e "${GREEN}Auf Wiedersehen!${NC}"
                exit 0
                ;;
            *)
                print_error "Ungültige Option"
                sleep 1
                ;;
        esac
    done
}

# Script starten
main_menu

