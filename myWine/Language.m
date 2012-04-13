//
//  Language.m
//  myWine
//
//  Created by Diogo Castro on 4/5/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "Language.h"

static Language *sharedMyLanguage = nil;

@implementation Language

@synthesize selectedLanguage;


#pragma mark Singleton Methods
+ (id)sharedLanguage {
    @synchronized(self) {
        if (sharedMyLanguage == nil)
            sharedMyLanguage = [[self alloc] init];
    }
    return sharedMyLanguage;
}
- (id)init {
    if (self = [super init]) {
        
        #warning TODO: load default language from saved preferences
        selectedLanguage = PT;
    }
    return self;
}
- (void)dealloc {
    // Should never be called, but just here for clarity really.
}


-(NSString*) languageSelectedStringForKey:(NSString*) key
{
    
	NSString *path;
	if(selectedLanguage==EN)
		path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
	else if(selectedLanguage== PT)
		path = [[NSBundle mainBundle] pathForResource:@"pt" ofType:@"lproj"];
	else if(selectedLanguage==FR)
		path = [[NSBundle mainBundle] pathForResource:@"fr" ofType:@"lproj"];
	
	NSBundle* languageBundle = [NSBundle bundleWithPath:path];
	NSString* str=[languageBundle localizedStringForKey:key value:@"" table:nil];
	return str;
}



@end
