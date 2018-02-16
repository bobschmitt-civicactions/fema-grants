#!/bin/bash -e
set -e
DRUSH=/var/www/vendor/bin/drush

echo "Installing Drupal"
$DRUSH -y site:install minimal --account-pass=civicactions --sites-subdir=default --db-url=mysql://dbuser:dbpass@db:3306/drupal --config-dir=/var/www/config/sync

echo "Importing Configuration"
$DRUSH -y config-import

echo "Adding specialist roles"
$DRUSH user:role:add specialist Jackson.Specialist,Celeste.Aspecialist

echo "Adding grantee roles"
$DRUSH urol grantee Marcos.Fletcher,Shannon.Blair,Amy.Fleming,Rose.Mack,Colleen.Parsons,Andrea.Wells,Cynthia.Tran,Darnell.Wright,Pamela.Clarke,Cameron.Denton,Mei.Lee,Sage.Anthony,Jillian.Doll,Roxanna.Kozlowski,Providencia.Camp,Shan.Vanover,Tessie.Oswald,Michel.Villanueva,Annice.Shackelford

echo "Unblocking and setting e-mail addresses for demo users"
$DRUSH sqlq "UPDATE users_field_data SET mail=CONCAT(name, '@example.com'), status=1 WHERE uid > 0"

echo "Setting passwords"
for NAME in $($DRUSH sqlq "SELECT name FROM users_field_data WHERE uid > 0"); do
  $DRUSH user:password "${NAME}" "civicactions"
done
