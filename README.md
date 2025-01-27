# SKRYPTY
Opis skryptów:
1. wordpress_manager.sh
   Automatyzuje tworzenie nowych środowisk do pracy z wordpressem.
   Automatycznie tworzy w katalogu /var/www/html nowy katalog projektu.
   Tworzy nową bazę danych nazwa-projektu_db i przydziela wcześniej utworzonemu użytkownikowi uprawnienia do tej konkretnej bazy.
   Tworzy plik wp_config.php oraz wstępnie konfiguruje wordpressa nam pozostawiając tak naprawdę ustalenie danych logowania do panelu oraz nazwy projektu.

   Automatyzuje usuwanie niepotrzebnych środowisk pracy, usuwa wybrany katalog projektu oraz niepotrzebną bazę danych.

   Dzięki skryptowi instalacja nowego środowiska bądź usunięcie starego trwa zaledwie kilka sekund.
