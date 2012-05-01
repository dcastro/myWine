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
/**
 *IMPORTANT: statement is a state machine with the possible numbers 0,1,2,3.
 * 0 - synced with server
 * 1 - new
 * 2 - edited
 * 3 - deleted
 */
const char  *databaseTables[] = {
    
    "CREATE TABLE User (\
    username TEXT PRIMARY KEY, \
    password TEXT, \
    synced_at INTEGER, \
    validated INTEGER \
    );",
    
    "CREATE TABLE Country (\
    country_id INTEGER PRIMARY KEY AUTOINCREMENT, \
    name_en TEXT, \
    name_fr TEXT, \
    name_pt TEXT \
    );",
    
    "CREATE TABLE Region (\
    region_id INTEGER PRIMARY KEY AUTOINCREMENT, \
    country_id INTEGER NOT NULL, \
    default_selection INTEGER, \
    name TEXT, \
    FOREIGN KEY (country_id) REFERENCES Country (country_id) ON UPDATE CASCADE ON DELETE CASCADE \
    );",
    
    "CREATE TABLE WineType (\
    winetype_id INTEGER PRIMARY KEY AUTOINCREMENT, \
    name_en TEXT, \
    name_fr TEXT, \
    name_pt TEXT \
    );",
    
    "CREATE TABLE Grape(\
    grape_id INTEGER PRIMARY KEY AUTOINCREMENT, \
    name_en TEXT, \
    name_fr TEXT, \
    name_pt TEXT \
    );",
    
    
    "CREATE TABLE Wine (\
    wine_id INTEGER PRIMARY KEY AUTOINCREMENT, \
    user TEXT NOT NULL, \
    region_id INTEGER NOT NULL, \
    winetype_id INTEGER NOT NULL, \
    wine_server_id INTEGER, \
    name TEXT NOT NULL, \
    year INTEGER NOT NULL, \
    photo_filename TEXT, \
    producer TEXT, \
    currency TEXT, \
    price REAL, \
    state INTEGER, \
    FOREIGN KEY (user) REFERENCES User (username) ON UPDATE CASCADE ON DELETE CASCADE, \
    FOREIGN KEY (region_id) REFERENCES Region (region_id) ON UPDATE CASCADE ON DELETE CASCADE, \
    FOREIGN KEY (winetype_id) REFERENCES WineType (winetype_id) ON UPDATE CASCADE ON DELETE CASCADE \
    );",
    
    "CREATE TABLE WineGrape (\
    grape_id INTEGER NOT NULL, \
    wine_id INTEGER NOT NULL, \
    PRIMARY KEY (grape_id, wine_id), \
    FOREIGN KEY (grape_id) REFERENCES Grape (grape_id) ON UPDATE CASCADE ON DELETE CASCADE, \
    FOREIGN KEY (wine_id) REFERENCES Wine (wine_id) ON UPDATE CASCADE ON DELETE CASCADE \
    )",
    
    "CREATE TABLE Tasting (\
    tasting_id INTEGER PRIMARY KEY AUTOINCREMENT, \
    wine_id INTEGER NOT NULL, \
    classification_id INTEGER NOT NULL, \
    tasting_date INTEGER NOT NULL, \
    comment TEXT, \
    latitude REAL, \
    longitude REAL, \
    state INTEGER, \
    FOREIGN KEY (classification_id) REFERENCES Classification (classification_id) ON UPDATE CASCADE ON DELETE CASCADE, \
    FOREIGN KEY (wine_id) REFERENCES Wine (wine_id) ON UPDATE CASCADE ON DELETE CASCADE \
    );",
    
    "CREATE TABLE Section (\
    section_id INTEGER PRIMARY KEY AUTOINCREMENT, \
    tasting_id INTEGER, \
    name_en TEXT, \
    name_fr TEXT, \
    name_pt TEXT, \
    FOREIGN KEY (tasting_id) REFERENCES Tasting (tasting_id) ON UPDATE CASCADE ON DELETE CASCADE \
    );",
    
    "CREATE TABLE Criterion (\
    criterion_id INTEGER PRIMARY KEY AUTOINCREMENT, \
    section_id INTEGER NOT NULL, \
    classification_id INTEGER NOT NULL, \
    name_en TEXT, \
    name_fr TEXT, \
    name_pt TEXT, \
    FOREIGN KEY (classification_id) REFERENCES Classification (classification_id) ON UPDATE CASCADE ON DELETE CASCADE, \
    FOREIGN KEY (section_id) REFERENCES Section (section_id) ON UPDATE CASCADE ON DELETE CASCADE \
    );",
    
    "CREATE TABLE Characteristic (\
    characteristics_id INTEGER PRIMARY KEY AUTOINCREMENT, \
    section_id INTEGER NOT NULL, \
    classification_id INTEGER, \
    name_en TEXT, \
    name_fr TEXT, \
    name_pt TEXT, \
    FOREIGN KEY (section_id) REFERENCES Section (section_id) ON UPDATE CASCADE ON DELETE CASCADE, \
    FOREIGN KEY (classification_id) REFERENCES Classification (classification_id) ON UPDATE CASCADE ON DELETE CASCADE \
    );",
    
    "CREATE TABLE Classification (\
    classification_id INTEGER PRIMARY KEY, \
    weight INTEGER, \
    name_en TEXT, \
    name_fr TEXT, \
    name_pt TEXT \
    );",
    
    "CREATE TABLE UserTypeForm (\
    user TEXT NOT NULL, \
    winetype_id INTEGER NOT NULL, \
    formtasting_id INTEGER NOT NULL, \
    PRIMARY KEY (user, winetype_id, formtasting_id), \
    FOREIGN KEY (user) REFERENCES User (username) ON UPDATE CASCADE ON DELETE CASCADE, \
    FOREIGN KEY (winetype_id) REFERENCES WineType (winetype_id) ON UPDATE CASCADE ON DELETE CASCADE, \
    FOREIGN KEY (formtasting_id) REFERENCES FormTasting (formtasting_id) ON UPDATE CASCADE ON DELETE CASCADE \
    );",
    
    "CREATE TABLE FormTasting (\
    formtasting_id INTEGER PRIMARY KEY AUTOINCREMENT \
    );",
    
    "CREATE TABLE FormSection (\
    formsection_id INTEGER PRIMARY KEY AUTOINCREMENT, \
    formtasting_id INTEGER NOT NULL, \
    name_en TEXT, \
    name_fr TEXT, \
    name_pt TEXT, \
    FOREIGN KEY (formtasting_id) REFERENCES FormTasting (formtasting_id) ON UPDATE CASCADE ON DELETE CASCADE \
    );",
    
    "CREATE TABLE FormCriterion (\
    formcriterion_id INTEGER PRIMARY KEY AUTOINCREMENT, \
    formsection_id INTEGER NOT NULL, \
    name_en TEXT, \
    name_fr TEXT, \
    name_pt TEXT, \
    FOREIGN KEY (formsection_id) REFERENCES FormSection (formsection_id) ON UPDATE CASCADE ON DELETE CASCADE \
    );",
    
    
    "CREATE TABLE FormCharacteristic (\
    formcharacteristics_id INTEGER PRIMARY KEY AUTOINCREMENT, \
    formsection_id INTEGER NOT NULL, \
    name_en TEXT, \
    name_fr TEXT, \
    name_pt TEXT, \
    FOREIGN KEY (formsection_id) REFERENCES FormSection (formsection_id) ON UPDATE CASCADE ON DELETE CASCADE \
    );",
    
    "CREATE TABLE PossibleClassification(\
    classifiable_id INTEGER, \
    classification_id INTEGER, \
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
    "CREATE INDEX IDX_WINE_NAME ON Wine (name);",
    
    "CREATE INDEX IDX_TASTING_WINE ON Tasting (wine_id);",
    "CREATE INDEX IDX_TASTING_DATE ON Tasting (tasting_date);",
    
    "CREATE INDEX IDX_SECTION_TASTING ON Section (tasting_id);",
    
    "CREATE INDEX IDX_CRITERION_SECTION ON Criterion (section_id);",
    
    "CREATE INDEX IDX_CHARACTERISTIC_SECTION ON Characteristic (section_id);",
    
    "CREATE INDEX IDX_POSSIBLECLASSIFICATION ON PossibleClassification(classifiable_id, classifiable_type);",
    
    
    
    
    //DADOS DE TESTE
    "INSERT INTO User VALUES ('admin', 'admin', '10000', 1)",
    
    
    "INSERT INTO Country VALUES (1,'Portugal', 'Portugal', 'Portugal');",
    
    
    "INSERT INTO Region VALUES (1, 1, 1, 'Vila Real');",
    "INSERT INTO Region VALUES (2, 1, 0, 'Porto');",
    "INSERT INTO Region VALUES (3, 1, 0, 'Alijo');",
    
    
    "INSERT INTO WineType VALUES (1, 'White Wine', 'Vin Blanc', 'Vinho Branco');",
    "INSERT INTO WineType VALUES (2, 'Sparlking Wine', 'Vin Mousseux', 'Vinho Espumante');",
    
    
    "INSERT INTO Grape VALUES (1,'ALVARINHO', 'ALVARINHO', 'ALVARINHO');",
    "INSERT INTO Grape VALUES (2,'ARINTO', 'ARINTO', 'ARINTO');", 
    "INSERT INTO Grape VALUES (3,'MARIA GOMES', 'MARIA GOMES', 'MARIA GOMES');", 
    "INSERT INTO Grape VALUES (4,'TINTA RORIZ', 'TINTA RORIZ', 'TINTA RORIZ');",
    "INSERT INTO Grape VALUES (5,'BAGA','BAGA','BAGA');", 
    
    
    "INSERT INTO Wine VALUES (1, 'admin', 1, 1,NULL, 'Terras do Aleu', 2012, NULL, 'Lavrador XPTO', 'EUR', 9.99, 0);",
    "INSERT INTO Wine VALUES (2, 'admin', 3, 1,NULL, 'Muralhas', 2012, NULL, 'Adega Qualquer', 'EUR', 4.00, 0);",
    
    
    "INSERT INTO WineGrape VALUES (4,1);",
    "INSERT INTO WineGrape VALUES (5,1);",
    "INSERT INTO WineGrape VALUES (1,2);",
    "INSERT INTO WineGrape VALUES (2,2);",
    "INSERT INTO WineGrape VALUES (3,2);",
    
    
    "INSERT INTO Classification VALUES (1,15,'Very bad', 'Tres mal', 'Muito mau');",
    "INSERT INTO Classification VALUES (2,30,'Bad', 'Mal', 'Mau');",
    "INSERT INTO Classification VALUES (3,45,'Reasonable', 'Raisonnable', 'Razoavel');",
    "INSERT INTO Classification VALUES (4,60,'Good', 'Bon', 'Bom');",
    "INSERT INTO Classification VALUES (5,75,'Very Good', 'Tres bon', 'Muito bom');",
    "INSERT INTO Classification VALUES (6,100,'Excellent', 'Excellent', 'Excelente');",
    "INSERT INTO Classification VALUES (7,0,'Very bad', 'Tres mal', 'Muito mau');",
    "INSERT INTO Classification VALUES (8,0,'Bad', 'Mal', 'Mau');",
    "INSERT INTO Classification VALUES (9,0,'Reasonable', 'Raisonnable', 'Razoavel');",
    "INSERT INTO Classification VALUES (10,0,'Good', 'Bon', 'Bom');",
    "INSERT INTO Classification VALUES (11,0,'Very Good', 'Tres bon', 'Muito bom');",
    "INSERT INTO Classification VALUES (12,0,'Excellent', 'Excellent', 'Excelente');",
    
    
    "INSERT INTO PossibleClassification VALUES (1,2,'Tasting');",
    "INSERT INTO PossibleClassification VALUES (1,3,'Tasting');",
    "INSERT INTO PossibleClassification VALUES (1,4,'Tasting');",
    "INSERT INTO PossibleClassification VALUES (1,5,'Tasting');",
    "INSERT INTO PossibleClassification VALUES (1,6,'Tasting');",
    "INSERT INTO PossibleClassification VALUES (1,2,'Criterion');",
    "INSERT INTO PossibleClassification VALUES (1,4,'Criterion');",
    "INSERT INTO PossibleClassification VALUES (2,3,'Criterion');",
    "INSERT INTO PossibleClassification VALUES (2,4,'Criterion');",
    "INSERT INTO PossibleClassification VALUES (2,5,'Criterion');",
    "INSERT INTO PossibleClassification VALUES (2,6,'Criterion');",
    "INSERT INTO PossibleClassification VALUES (3,6,'Criterion');",
    "INSERT INTO PossibleClassification VALUES (4,4,'Criterion');",
    "INSERT INTO PossibleClassification VALUES (5,4,'Criterion');",
    "INSERT INTO PossibleClassification VALUES (6,5,'Criterion');",
    "INSERT INTO PossibleClassification VALUES (1,10,'Characteristic');",
    "INSERT INTO PossibleClassification VALUES (2,10,'Characteristic');",
    "INSERT INTO PossibleClassification VALUES (3,11,'Characteristic');",
    
    
    "INSERT INTO Tasting VALUES (1, 1, 3, 1000000, 'muito bom este negocio....', 27.0, 27.0, 1);",
    
    
    "INSERT INTO Section VALUES (1,1,'View', 'Voir', 'Vista');",
    "INSERT INTO Section VALUES (2,1,'Aroma', 'Arome', 'Aroma');",
    "INSERT INTO Section VALUES (3,1,'Flavor', 'Saveur', 'Sabor');",

    
    "INSERT INTO Criterion VALUES (1, 1, 4, 'Clarity', 'Clarte', 'Limpidez');",
    "INSERT INTO Criterion VALUES (2, 1, 6, 'Color', 'Couleur', 'Cor');",
    "INSERT INTO Criterion VALUES (3, 3, 6, 'Genuineness', 'Authenticite', 'Genuinidade');",
    "INSERT INTO Criterion VALUES (4, 3, 4, 'Intensity', 'Intensite', 'Intensidade');",
    "INSERT INTO Criterion VALUES (5, 3, 4, 'Persistence', 'Persistance', 'Persistencia');",
    "INSERT INTO Criterion VALUES (6, 3, 5, 'Quality', 'Qualite', 'Qualidade');",

    
    "INSERT INTO Characteristic VALUES (1, 2, 10 , 'Genuineness', 'Authenticite', 'Genuinidade');",
    "INSERT INTO Characteristic VALUES (2, 2, 10 , 'Intensity', 'Intensite', 'Intensidade');",
    "INSERT INTO Characteristic VALUES (3, 2, 11, 'Quality', 'Qualite', 'Qualidade');",

    
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
const int region_column_count = 4;
const int region_column_id = 0;
const int region_column_country = 1;
const int region_column_default = 2;
const int region_column_name = 3;



//columns in table Wine
const int wine_column_count = 12;
const int wine_column_id = 0;
const int wine_column_user = 1;
const int wine_column_region = 2;
const int wine_column_winetype = 3;
const int wine_column_server_id = 4;
const int wine_column_name = 5;
const int wine_column_year = 6;
const int wine_column_photo = 7;
const int wine_column_producer = 8;
const int wine_column_currency = 9;
const int wine_column_price = 10;
const int wine_column_state = 11;



