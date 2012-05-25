//
//  Sincronizacao.m
//  myWine
//
//  Created by Fernando Gracas on 5/11/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "Sincronizacao.h"

@implementation Sincronizacao


-(void)sync:(NSError **)error withPercentage:(int *)p {
    percentage = p;
    receivedData = [[NSMutableData data]init];
    
    NSString *jsonRequest = @"{\"accessKey\":\"mywine\",\"userid\":\"mywine@cpcis.pt\",\"MyWines\":null}";
    NSURL *url = [NSURL URLWithString:@"http://backofficegp.cpcis.pt/MyWineSincService/MyWineSincService.svc/MyWineSincronize"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    
    
    NSURLConnection * theConnection = [NSURLConnection connectionWithRequest:[request copy] delegate:self];
    
    
    if (!theConnection) {
        DebugLog(@"Connection Failed");
    }
    
    
    //*percentage = 1;

    
}


- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    if(data == nil){
        DebugLog(@"Didnt receive any data");
    }else{
        [receivedData appendData:data];
    }
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSError *jsonParsingError = nil;
    NSDictionary *ob = [NSJSONSerialization JSONObjectWithData:receivedData options:0 error:&jsonParsingError];
    
    NSString *output = [NSString stringWithFormat:@"%@",  ob];
    
    DebugLog(@"JSON: %@", output);

    
}



-(NSMutableDictionary *)buidRequestNewWines{
    return Nil;
    
}



-(NSMutableDictionary *)buildRequestNewTastings{
    return Nil;
}



-(NSMutableDictionary *)buildRequestDeleted{
    return Nil;
}



-(NSMutableDictionary *)buildRequestUpdatedWines{
    return Nil;
}



-(BOOL)processResponseDeleted:(NSDictionary *)deleted{
    //TODO: delete dos wine/tastings enviados mais os recebidos pelo server
    return TRUE;
}



-(BOOL)processResponseCountries:(NSArray *)countries{
    return TRUE;
}


@end
