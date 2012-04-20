//
//  DatatabaseDefinitions.h
//  myWine
//
//  Created by Fernando Gracas on 4/18/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#ifndef myWine_DatatabaseDefinitions_h
#define myWine_DatatabaseDefinitions_h



/**
 Database name
 */
extern const char * databaseFilename;


//database table creation
extern const char  *databaseTables[];


//columns in table User
extern const int user_column_count;
extern const int user_column_username;
extern const int user_column_password;
extern const int user_column_synced;
extern const int user_column_validated;


//columns in table Country
extern const int country_column_count;
extern const int country_column_id;
extern const int country_column_name_fr;
extern const int country_column_name_en;
extern const int country_column_name_pt;


//columns in table Region
extern const int region_column_count;
extern const int region_column_id;
extern const int region_column_country;
extern const int region_column_default;
extern const int region_column_name_fr;
extern const int region_column_name_en;
extern const int region_column_name_pt;


//columns in table Wine
extern const int wine_column_count;
extern const int wine_column_id;
extern const int wine_column_user;
extern const int wine_column_region;
extern const int wine_column_winetype;
extern const int wine_column_name;
extern const int wine_column_year;
extern const int wine_column_photo;
extern const int wine_column_producer;
extern const int wine_column_currency;
extern const int wine_column_price;



#endif
