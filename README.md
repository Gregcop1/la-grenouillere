# La grenouillère

## Requis
 - PHP
 - MYSQL
 - Composer
 - GIT
 
## Installation
Allez dans le terminal et suivez les étapes suivantes :
```
git clone git@github.com:Gregcop1/la-grenouillere.git
cd la-grenouillere
composer install
```

Répondez à toutes les questions concernant la base de données, etc.

Les prochaines commande utilisant `wp-cli` pourrait être simplifiée en installant wp-cli globalement (comme indiqué sur [leur site](http://wp-cli.org/))
Les commandes utiliseraient alors `wp` plutôt que `vendor/wp-cli/wp-cli/bin/wp`

Continuez dans le terminal : 
```
vendor/wp-cli/wp-cli/bin/wp db create --path=web/wp
vendor/wp-cli/wp-cli/bin/wp db import db/dump.sql --path=web/wp
vendor/wp-cli/wp-cli/bin/wp server --path=web/
```

Votre site est maintenant accessible via _[http://localhost:8080/](http://localhost:8080/)_

La partie administration, elle, est visible depuis _[http://localhost:8080/wp/wp-admin/](http://localhost:8080/wp/wp-admin/)_
