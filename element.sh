#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

# Query the database
QUERY_RESULT=$($PSQL "
  SELECT elements.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius
  FROM elements
  INNER JOIN properties ON elements.atomic_number = properties.atomic_number
  INNER JOIN types ON properties.type_id = types.type_id
  WHERE elements.atomic_number::TEXT = '$1' OR symbol = '$1' OR name = '$1';")

if [[ -z $QUERY_RESULT ]]
then
  echo "I could not find that element in the database."
else
  echo "$QUERY_RESULT" | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING_POINT BOILING_POINT
  do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  done
fi



