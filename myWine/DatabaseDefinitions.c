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
    synced_at REAL, \
    validated INTEGER \
    );",
    
    "CREATE TABLE Country (\
    country_id TEXT PRIMARY KEY, \
    name_en TEXT, \
    name_fr TEXT, \
    name_pt TEXT \
    );",
    
    "CREATE TABLE Region (\
    region_id INTEGER PRIMARY KEY, \
    country_id TEXT NOT NULL, \
    name TEXT, \
    FOREIGN KEY (country_id) REFERENCES Country (country_id) ON UPDATE CASCADE ON DELETE CASCADE \
    );",
    
    "CREATE TABLE WineType (\
    winetype_id INTEGER PRIMARY KEY, \
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
    grapes TEXT, \
    photo_filename TEXT, \
    producer TEXT, \
    currency TEXT, \
    price REAL, \
    state INTEGER, \
    FOREIGN KEY (user) REFERENCES User (username) ON UPDATE CASCADE ON DELETE CASCADE, \
    FOREIGN KEY (region_id) REFERENCES Region (region_id) ON UPDATE CASCADE ON DELETE CASCADE, \
    FOREIGN KEY (winetype_id) REFERENCES WineType (winetype_id) ON UPDATE CASCADE ON DELETE CASCADE \
    );",
    
    "CREATE TABLE Tasting (\
    tasting_id INTEGER PRIMARY KEY AUTOINCREMENT, \
    wine_id INTEGER NOT NULL, \
    tasting_date REAL NOT NULL, \
    comment TEXT, \
    latitude REAL, \
    longitude REAL, \
    state INTEGER, \
    FOREIGN KEY (wine_id) REFERENCES Wine (wine_id) ON UPDATE CASCADE ON DELETE CASCADE \
    );",
    
    "CREATE TABLE Section (\
    section_id INTEGER PRIMARY KEY AUTOINCREMENT, \
    tasting_id INTEGER, \
    order_priority INTEGER NOT NULL, \
    name_en TEXT, \
    name_fr TEXT, \
    name_pt TEXT, \
    FOREIGN KEY (tasting_id) REFERENCES Tasting (tasting_id) ON UPDATE CASCADE ON DELETE CASCADE \
    );",
    
    "CREATE TABLE SectionCharacteristic (\
    sectioncharacteristic_id INTEGER PRIMARY KEY AUTOINCREMENT, \
    tasting_id INTEGER, \
    order_priority INTEGER NOT NULL, \
    name_en TEXT, \
    name_fr TEXT, \
    name_pt TEXT, \
    FOREIGN KEY (tasting_id) REFERENCES Tasting (tasting_id) ON UPDATE CASCADE ON DELETE CASCADE \
    );",
    
    "CREATE TABLE Criterion (\
    criterion_id INTEGER PRIMARY KEY AUTOINCREMENT, \
    section_id INTEGER NOT NULL, \
    order_priority INTEGER NOT NULL, \
    classification_id INTEGER NOT NULL, \
    name_en TEXT, \
    name_fr TEXT, \
    name_pt TEXT, \
    FOREIGN KEY (classification_id) REFERENCES Classification (classification_id) ON UPDATE CASCADE ON DELETE CASCADE, \
    FOREIGN KEY (section_id) REFERENCES Section (section_id) ON UPDATE CASCADE ON DELETE CASCADE \
    );",
    
    "CREATE TABLE Characteristic (\
    characteristic_id INTEGER PRIMARY KEY AUTOINCREMENT, \
    sectioncharacteristic_id INTEGER NOT NULL, \
    order_priority INTEGER NOT NULL, \
    classification_id INTEGER, \
    name_en TEXT, \
    name_fr TEXT, \
    name_pt TEXT, \
    FOREIGN KEY (sectioncharacteristic_id) REFERENCES SectionCharacteristic (sectioncharacteristic_id) ON UPDATE CASCADE ON DELETE CASCADE, \
    FOREIGN KEY (classification_id) REFERENCES Classification (classification_id) ON UPDATE CASCADE ON DELETE CASCADE \
    );",
    
    "CREATE TABLE Classification (\
    classification_id INTEGER PRIMARY KEY AUTOINCREMENT, \
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
    order_priority INTEGER NOT NULL, \
    name_en TEXT, \
    name_fr TEXT, \
    name_pt TEXT, \
    FOREIGN KEY (formtasting_id) REFERENCES FormTasting (formtasting_id) ON UPDATE CASCADE ON DELETE CASCADE \
    );",
    
    "CREATE TABLE FormSectionCharacteristic (\
    formsectioncharacteristic_id INTEGER PRIMARY KEY AUTOINCREMENT, \
    formtasting_id INTEGER NOT NULL, \
    order_priority INTEGER NOT NULL, \
    name_en TEXT, \
    name_fr TEXT, \
    name_pt TEXT, \
    FOREIGN KEY (formtasting_id) REFERENCES FormTasting (formtasting_id) ON UPDATE CASCADE ON DELETE CASCADE \
    );",
    
    "CREATE TABLE FormCriterion (\
    formcriterion_id INTEGER PRIMARY KEY AUTOINCREMENT, \
    formsection_id INTEGER NOT NULL, \
    order_priority INTEGER NOT NULL, \
    name_en TEXT, \
    name_fr TEXT, \
    name_pt TEXT, \
    FOREIGN KEY (formsection_id) REFERENCES FormSection (formsection_id) ON UPDATE CASCADE ON DELETE CASCADE \
    );",
    
    
    "CREATE TABLE FormCharacteristic (\
    formcharacteristic_id INTEGER PRIMARY KEY AUTOINCREMENT, \
    formsectioncharacteristic_id INTEGER NOT NULL, \
    order_priority INTEGER NOT NULL, \
    name_en TEXT, \
    name_fr TEXT, \
    name_pt TEXT, \
    FOREIGN KEY (formsectioncharacteristic_id) REFERENCES FormSectionCharacteristic (formsectioncharacteristic_id) ON UPDATE CASCADE ON DELETE CASCADE \
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
    "CREATE INDEX IDX_SECTION_TOUPLE ON Section (order_priority,  name_en, name_fr, name_pt);",
    
    
    "CREATE INDEX IDX_SECTIONCHARACTERISTIC_TASTING ON SectionCharacteristic (tasting_id);",
    "CREATE INDEX IDX_SECTIONCHARACTERISTIC_TOUPLE ON SectionCharacteristic (order_priority,  name_en, name_fr, name_pt);",

    
    "CREATE INDEX IDX_CRITERION_SECTION ON Criterion (section_id);",
    "CREATE INDEX IDX_CRITERION_TOUPLE ON Criterion (order_priority,  name_en, name_fr, name_pt);",

    
    "CREATE INDEX IDX_CHARACTERISTIC_SECTIONCHARACTERISTIC ON Characteristic (sectioncharacteristic_id);",
    "CREATE INDEX IDX_CHARACTERISTIC_TOUPLE ON Characteristic (order_priority,  name_en, name_fr, name_pt);",

    
    "CREATE INDEX IDX_POSSIBLECLASSIFICATION ON PossibleClassification(classifiable_id, classifiable_type);",
    
    
    "CREATE INDEX IDX_CLASSIFICATION_TOUPLE ON Classification(weight, name_en, name_fr, name_pt);",
    
    
    
    
    //DADOS DE TESTE
    //VINHOS
    "INSERT INTO User VALUES ('mywine@cpcis.pt', 'mywine', 0.0, 1)",
    
    
    "\n"
};


