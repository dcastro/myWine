//
//  DatabaseDefinitions.c
//  myWine
//
//  Created by Fernando Gracas on 4/18/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#include "DatatabaseDefinitions.h"

/**
 Database name
 */
const char * databaseFilename = "wineDB.db";



//database table creation
const char  *databaseTables[] = {
    
    "CREATE TABLE User (\
    username TEXT PRIMARY KEY, \
    password TEXT, \
    synced_at INTEGER, \
    validated INTEGER \
    );",
    
    "CREATE TABLE Country (\
    country_id INTEGER PRIMARY KEY, \
    name_en TEXT, \
    name_fr TEXT, \
    name_pt TEXT \
    );",
    
    "CREATE TABLE Region (\
    region_id INTEGER PRIMARY KEY, \
    country_id INTEGER NOT NULL, \
    default_selection INTEGER, \
    name_fr TEXT, \
    name_en TEXT, \
    name_pt TEXT, \
    FOREIGN KEY (country_id) REFERENCES Country (country_id) ON UPDATE CASCADE ON DELETE CASCADE \
    );",
    
    "CREATE TABLE WineType (\
    winetype_id INTEGER PRIMARY KEY, \
    name_en TEXT, \
    name_fr TEXT, \
    name_pt TEXT \
    );",
    
    
    "CREATE TABLE Wine (\
    wine_id INTEGER PRIMARY KEY, \
    user TEXT NOT NULL, \
    region_id INTEGER NOT NULL, \
    winetype_id INTEGER NOT NULL, \
    name TEXT NOT NULL, \
    year INTEGER, \
    photo_filename TEXT, \
    producer TEXT, \
    currency TEXT, \
    price REAL, \
    update_at INTEGER, \
    FOREIGN KEY (user) REFERENCES User (username) ON UPDATE CASCADE ON DELETE CASCADE, \
    FOREIGN KEY (region_id) REFERENCES Region (region_id) ON UPDATE CASCADE ON DELETE CASCADE, \
    FOREIGN KEY (winetype_id) REFERENCES WineType (winetype_id) ON UPDATE CASCADE ON DELETE CASCADE \
    );",
    
    "CREATE TABLE Tasting (\
    tasting_id INTEGER PRIMARY KEY, \
    wine_id INTEGER NOT NULL, \
    classification_id INTEGER, \
    tasting_date INTEGER NOT NULL, \
    comment TEXT, \
    latitude REAL, \
    longitude REAL, \
    updated_at INTEGER, \
    FOREIGN KEY (classification_id) REFERENCES Classification (classification_id) ON UPDATE CASCADE ON DELETE CASCADE, \
    FOREIGN KEY (wine_id) REFERENCES Wine (wine_id) ON UPDATE CASCADE ON DELETE CASCADE \
    );",
    
    "CREATE TABLE Section (\
    section_id INTEGER PRIMARY KEY, \
    tasting_id INTEGER, \
    name_en TEXT, \
    name_fr TEXT, \
    name_pt TEXT, \
    FOREIGN KEY (tasting_id) REFERENCES Tasting (tasting_id) ON UPDATE CASCADE ON DELETE CASCADE \
    );",
    
    "CREATE TABLE Criterion (\
    criterion_id INTEGER PRIMARY KEY, \
    section_id INTEGER NOT NULL, \
    classification_id INTEGER, \
    name_en TEXT, \
    name_fr TEXT, \
    name_pt TEXT, \
    FOREIGN KEY (classification_id) REFERENCES Classification (classification_id) ON UPDATE CASCADE ON DELETE CASCADE, \
    FOREIGN KEY (section_id) REFERENCES Section (section_id) ON UPDATE CASCADE ON DELETE CASCADE \
    );",
    
    "CREATE TABLE Classification (\
    classification_id INTEGER PRIMARY KEY, \
    weight INTEGER, \
    name_en TEXT, \
    name_fr TEXT, \
    name_pt TEXT \
    );",
    
    "CREATE TABLE UserTypeForm (\
    user TEXT, \
    winetype_id INTEGER, \
    formtasting_id INTEGER, \
    PRIMARY KEY (user, winetype_id, formtasting_id), \
    FOREIGN KEY (user) REFERENCES User (username) ON UPDATE CASCADE ON DELETE CASCADE, \
    FOREIGN KEY (winetype_id) REFERENCES WineType (winetype_id) ON UPDATE CASCADE ON DELETE CASCADE, \
    FOREIGN KEY (formtasting_id) REFERENCES FormTasting (formtasting_id) ON UPDATE CASCADE ON DELETE CASCADE \
    );",
    
    "CREATE TABLE FormTasting (\
    formtasting_id INTEGER PRIMARY KEY, \
    updated_at INTEGER \
    );",
    
    "CREATE TABLE FormSection (\
    formsection_id INTEGER PRIMARY KEY, \
    formtasting_id INTEGER NOT NULL, \
    name_en TEXT, \
    name_fr TEXT, \
    name_pt TEXT, \
    FOREIGN KEY (formtasting_id) REFERENCES FormTasting (formtasting_id) ON UPDATE CASCADE ON DELETE CASCADE \
    );",
    
    "CREATE TABLE FormCriterion (\
    formcriterion_id INTEGER PRIMARY KEY, \
    formsection_id INTEGER NOT NULL, \
    name_en TEXT, \
    name_fr TEXT, \
    name_pt TEXT, \
    FOREIGN KEY (formsection_id) REFERENCES FormSection (formsection_id) ON UPDATE CASCADE ON DELETE CASCADE \
    );",
    
    "CREATE TABLE PossibleClassification(\
    classification_id INTEGER, \
    classifiable_id INTEGER, \
    classifiable_type TEXT, \
    PRIMARY KEY (classification_id, classifiable_id, classifiable_type), \
    FOREIGN KEY (classification_id) REFERENCES Classification (classification_id) ON UPDATE CASCADE ON DELETE CASCADE \
    );",
    
    
    "CREATE INDEX IDX_REGION_COUNTRY ON Region (country_id);",
    
    "CREATE INDEX IDX_WINE_USER ON Wine (user);",
    "CREATE INDEX IDX_WINE_REGION ON Wine (region_id);",
    "CREATE INDEX IDX_WINE_WINETYPE ON Wine (winetype_id);",
    "CREATE INDEX IDX_WINE_YEAR ON Wine (year);",
    "CREATE INDEX IDX_WINE_PRODUCER ON Wine (producer);",
    
    "CREATE INDEX IDX_TASTING_WINE ON Tasting (wine_id);",
    "CREATE INDEX IDX_TASTING_DATE ON Tasting (tasting_date);",
    
    "CREATE INDEX IDX_SECTION_TASTING ON Section (tasting_id);",
    
    "CREATE INDEX IDX_CRITERION_SECTION ON Criterion (section_id);",
    
    
    
    //DADOS DE TESTE
    "INSERT INTO User VALUES ('admin', 'admin', '10000', 1)",
    
    "INSERT INTO Country VALUES (1,'Portugal', 'Portugal', 'Portugal');",
    
    "INSERT INTO Region VALUES (1, 1, 1, 'Vila Real', 'Vila Real', 'Vila Real');",
    "INSERT INTO Region VALUES (2, 1, 0, 'Porto', 'Porto', 'Porto');",
    "INSERT INTO Region VALUES (3, 1, 0, 'Alijo', 'Alijo', 'Alijo');",
    
    "INSERT INTO WineType VALUES (1, 'White Wine', 'Vin Blanc', 'Vinho Branco');",
    "INSERT INTO WineType VALUES (2, 'Sparlking Wine', 'Vin Mousseux', 'Vinho Espumante');",
    
    "INSERT INTO Wine VALUES (1, 'admin', 1, 1, 'Terras do Aleu', 2012, NULL, 'Lavrador XPTO', 'EUR', 9.99, 15000);",
    "INSERT INTO Wine VALUES (2, 'admin', 3, 1, 'Muralhas', 2012, NULL, 'Adega Qualquer', 'EUR', 4.00, 15000);",

    
    "\n"
};


//columns in table User
const int user_column_count = 4;
const int user_column_username = 0;
const int user_column_password = 1;
const int user_column_synced = 2;
const int user_column_validated = 3;



//columns in table Country
const int country_column_count = 4;
const int country_column_id = 0;
const int country_column_name_fr = 1;
const int country_column_name_en = 2;
const int country_column_name_pt = 3;



//columns in table Region
const int region_column_count = 6;
const int region_column_id = 0;
const int region_column_country = 1;
const int region_column_default = 2;
const int region_column_name_fr = 3;
const int region_column_name_en = 4;
const int region_column_name_pt = 5;



//columns in table Wine
const int wine_column_count = 10;
const int wine_column_id = 0;
const int wine_column_user = 1;
const int wine_column_region = 2;
const int wine_column_winetype = 3;
const int wine_column_name = 4;
const int wine_column_year = 5;
const int wine_column_photo = 6;
const int wine_column_producer = 7;
const int wine_column_currency = 8;
const int wine_column_price = 9;


