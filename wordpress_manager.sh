#!/bin/bash
# Aby skrypt zadziałał w pierwszej kolejności utwórz w bazie nowego użytkownika dla baz danych WP poleceniem CREATE USER 'nazwa_użytkownika_bazy_wordpressa'@'localhost' IDENTIFIED BY 'hasło_do_bazy_wordpressa';

# Funkcja tworzenia nowego projektu WordPress
create_project() {
    echo "Podaj nazwę projektu:"
    read PROJECT_NAME

    # Ścieżki i ustawienia
    PROJECT_DIR="/var/www/html/$PROJECT_NAME"
    DB_NAME="${PROJECT_NAME}_db"
    DB_USER="nazwa_użytkownika_bazy_wordpressa"
    DB_PASSWORD="hasło_do_bazy_wordpressa"
    WP_URL="https://pl.wordpress.org/latest-pl_PL.zip"
    TMP_FILE="/tmp/latest-pl_PL.zip"

    # Tworzenie katalogu projektu
    if [ -d "$PROJECT_DIR" ]; then
        echo "Projekt o nazwie $PROJECT_NAME już istnieje."
        return
    fi

    mkdir -p "$PROJECT_DIR"
    echo "Katalog projektu $PROJECT_NAME został utworzony."

    # Tworzenie bazy danych
    mysql -u root -p"hasło_roota_do_bazy" -e "CREATE DATABASE $DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    mysql -u root -p"hasło_roota_do_bazy" -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD'; FLUSH PRIVILEGES;"
    echo "Baza danych $DB_NAME została utworzona i użytkownik $DB_USER otrzymał pełne uprawnienia."

    # Pobieranie i rozpakowanie WordPressa
    wget -q -O "$TMP_FILE" "$WP_URL"
    unzip -q "$TMP_FILE" -d "$PROJECT_DIR"
    mv "$PROJECT_DIR/wordpress"/* "$PROJECT_DIR/"
    rm -rf "$PROJECT_DIR/wordpress" "$TMP_FILE"
    echo "WordPress został pobrany i rozpakowany w katalogu $PROJECT_DIR."

    # Tworzenie pliku wp-config.php
    cp "$PROJECT_DIR/wp-config-sample.php" "$PROJECT_DIR/wp-config.php"
    sed -i "s/database_name_here/$DB_NAME/" "$PROJECT_DIR/wp-config.php"
    sed -i "s/username_here/$DB_USER/" "$PROJECT_DIR/wp-config.php"
    sed -i "s/password_here/$DB_PASSWORD/" "$PROJECT_DIR/wp-config.php"

    # Ustawienia właściciela plików i uprawnień
    chown -R www-data:www-data "$PROJECT_DIR"
    chmod -R 755 "$PROJECT_DIR"

    echo "Projekt $PROJECT_NAME został skonfigurowany."
}

# Funkcja usuwania istniejącego projektu
delete_project() {
    echo "Podaj nazwę projektu do usunięcia:"
    read PROJECT_NAME

    # Ścieżki i ustawienia
    PROJECT_DIR="/var/www/html/$PROJECT_NAME"
    DB_NAME="${PROJECT_NAME}_db"

    # Usuwanie katalogu projektu
    if [ ! -d "$PROJECT_DIR" ]; then
        echo "Projekt o nazwie $PROJECT_NAME nie istnieje."
        return
    fi

    rm -rf "$PROJECT_DIR"
    echo "Katalog projektu $PROJECT_NAME został usunięty."

    # Usuwanie bazy danych
    mysql -u root -p"Himalaje24," -e "DROP DATABASE $DB_NAME;"
    echo "Baza danych $DB_NAME została usunięta."
}

# Menu główne
while true; do
    echo "Wybierz opcję:"
    echo "1) Stwórz nowy projekt WordPress"
    echo "2) Usuń istniejący projekt WordPress"
    echo "3) Wyjdź"
    read -p "Twój wybór: " CHOICE

    case $CHOICE in
        1)
            create_project
            ;;
        2)
            delete_project
            ;;
        3)
            echo "Do widzenia!"
            exit 0
            ;;
        *)
            echo "Nieprawidłowy wybór, spróbuj ponownie."
            ;;
    esac
    echo ""
done
