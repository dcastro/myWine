//
//  Sincronizacao.h
//  myWine
//
//  Created by Fernando Gracas on 5/11/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sincronizacao : NSObject{
     NSMutableData *receivedData;
    int * percentage;
}

/**
 *Syncronization function. Establishes the connection to the webservice and processes the data.
 *@param error - Pointer to an NSError, with initial value nil.
 *@return boolean - true if the syncronization occoured without errors. If false, the parameter error cointains the error message.
 */
-(void)sync:(NSError **)error withPercentage:(int *)p;


@end
