//
//  AppDelegate.m
//  myWine
//
//  Created by Antonio Velasquez on 3/19/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "AppDelegate.h"
#import "ListaVinhosViewController.h"
#import "User.h"
#import "FilterManager.h"
#import "Filter.h"
#import "Comparator.h"
#import "UIColor+myWineColor.h"
#import "MySplitViewViewController.h"
#import "NSMutableArray+VinhosMutableArray.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize splitView = _splitView;
@synthesize overlayWindow;
@synthesize comparatorNavController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //inicializa comparator
    [Comparator instance];
    
    //inicializa filter manager
    [FilterManager instance];
    
    //Customize TabBar's appearance
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor myWineColor]];
    
    // Override point for customization after application launch.
    
    Database * db = [Database instance];
    
    NSError * error = nil;
    //[db deleteDatabase:&error];
    if(![db isDatabaseCreated]){
        if(![db createDatabase:&error]){
            DebugLog(@"%@", [error localizedDescription]);
        }
    }
    
    //Add login
    //Remove login
    //Add splitview
    
    MySplitViewViewController *splitViewController = (MySplitViewViewController *)self.window.rootViewController;
    
    self.splitView = splitViewController;
    
    UINavigationController *masterNavigationController = [splitViewController.viewControllers objectAtIndex:0];
    ListaVinhosViewController *lvvc = (ListaVinhosViewController *)masterNavigationController.topViewController;
    lvvc.splitViewController = splitViewController;
    
    splitViewController.delegate = (id)lvvc;
    
    //check if there's a default user
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    NSString* username;
    
    BOOL logout = [defaults boolForKey:@"logout"];
    
    
    //if there isn't a default user, show login
    if (!(username = [defaults stringForKey:@"username"]) || logout) {
    
        //show login controller at startup
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        LoginViewController *lvc = (LoginViewController *) [storyboard instantiateViewControllerWithIdentifier:@"firstLogin"];
        lvc.modalPresentationStyle = UIModalPresentationFullScreen;
        [_window makeKeyAndVisible];
        [splitViewController presentModalViewController:lvc animated:NO];
    
        //set ListaVinhos as Login's delegate
        lvc.delegate = lvvc;
        lvc.splitViewController = self.splitView;
        
        if(logout){
            [defaults setBool:NO forKey:@"logout"];
            [defaults synchronize];
        }
        
    }
    
    //if there is a default user
    else {
        [User createWithUsername:username];
        User* user = [User instance];
        [lvvc setVinhos:user.vinhos];
        lvvc.selectedOrder = ORDER_BY_NAME;
        [lvvc.vinhos orderVinhosBy:lvvc.selectedOrder];
        [lvvc.vinhos sectionizeOrderedBy:lvvc.selectedOrder];
        [lvvc reloadData];

        
        //alerta de sync
        int alert_option = [defaults integerForKey:@"sync_reminder"];
        NSLog(@"alert option %i", alert_option);
        // se o alerta estiver ligado
        if (alert_option != 1) {
            if (alert_option == 0)
                alert_option = 7; //valor por defeito
            
            NSDate* last_sync = [NSDate dateWithTimeIntervalSince1970:user.synced_at];
            NSDate* today = [NSDate date];
       
            NSDateComponents* components;
            int days_since_last_sync;
            
            components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:last_sync toDate:today options:0];
            days_since_last_sync = [components day];
            NSLog(@"days elapsed since last sync %i", days_since_last_sync);
            
            
            if (days_since_last_sync > alert_option) {
                Language* lan = [Language instance];
                NSString* alert_message = [NSString stringWithFormat:@"%@ %i %@", [lan translate:@"Alert1"], days_since_last_sync, [lan translate:@"Alert2"]];
                
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[lan translate:@"Alert Title"] message:alert_message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert performSelector:@selector(show) withObject:nil afterDelay:0.0];
            }
            
            
        }
        

    }
    
    return YES;
    
}

-(void) showComparator {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    self.comparatorNavController = [storyboard instantiateViewControllerWithIdentifier:@"comparatorNVC"];
    
    self.overlayWindow = [[UIWindow alloc] initWithFrame: self.window.frame];
    
    self.overlayWindow.clipsToBounds = YES;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.8;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    transition.delegate = self;        
    
    [[self.comparatorNavController.view layer] addAnimation:transition forKey:nil];    
    
    [self.overlayWindow addSubview:self.comparatorNavController.view];
    [self.overlayWindow setWindowLevel:1];
    [self.overlayWindow makeKeyAndVisible];
    
    [self.splitView setShouldRotate:NO];
    
}

-(void) hideComparator {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.8;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;     
    [CATransaction setCompletionBlock:^ {
        self.comparatorNavController = nil;
        
        self.overlayWindow.hidden = YES;
        self.overlayWindow = nil;
        
        [self.splitView setShouldRotate:YES];
    }];
    
    [[[self.comparatorNavController.view superview] layer] addAnimation:transition forKey:nil]; 
    
    [self.comparatorNavController.view removeFromSuperview];
    
    [CATransaction commit];
    
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    BOOL logout = [defaults boolForKey:@"logout"];
    
    int selectedLanguage = [defaults integerForKey:@"lang"];
    Language* lan = [Language instance];
    
    //se o idioma tiver sido alterado
    if (selectedLanguage != 0 && selectedLanguage != lan.selectedLanguage) {
        NSLog(@"selected lang %i", selectedLanguage);
        [lan setLang:selectedLanguage];
        
        LoginViewController* loginVC = (LoginViewController*) [self.splitView modalViewController];
        if ([loginVC isKindOfClass:[LoginViewController class]] && loginVC != nil) {
            //traduzir login
            NSLog(@"Translating login and app");
            [loginVC translate];
        }
        else { 
            NSLog(@"dismissing modal views");
            [self.splitView dismiss ];
            
            NSLog(@"Translating app");
            [self.splitView translate];
        }
        
    }
    
    if(logout){

        [self doLogout];
        /*
        //NSLog(@"Entrou em foreground e flag logout e true");

        [defaults setObject:nil forKey:@"username"];
        [defaults setBool:NO forKey:@"logout"];
        [defaults synchronize];
        
        //se o login view estiver activo, return
        if ([self.splitView modalViewController] != nil)
            return;
        
        //dismiss das model views
        NSLog(@"dismissing modal views");
        [self.splitView dismiss ];
        
        //show login controller at startup
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        LoginViewController *lvc = (LoginViewController *) [storyboard instantiateViewControllerWithIdentifier:@"firstLogin"];
        lvc.modalPresentationStyle = UIModalPresentationFullScreen;
        [_window makeKeyAndVisible];
        [self.splitView presentModalViewController:lvc animated:NO];
        
        
        //set delegate
        UINavigationController *masterNavigationController = [self.splitView.viewControllers objectAtIndex:0];
        ListaVinhosViewController *lvvc = (ListaVinhosViewController *)[[masterNavigationController viewControllers] objectAtIndex:0] ;
        
        
        lvc.delegate = lvvc;
        lvc.splitViewController = self.splitView;
        */
        
    }
    

}

- (void) doLogout {
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"username"];
    [defaults setBool:NO forKey:@"logout"];
    [defaults synchronize];
    
    //se o login view estiver activo, return
    if ([self.splitView modalViewController] != nil)
        return;
    
    //dismiss das model views
    NSLog(@"dismissing modal views");
    [self.splitView dismiss ];
    
    //show login controller at startup
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    LoginViewController *lvc = (LoginViewController *) [storyboard instantiateViewControllerWithIdentifier:@"firstLogin"];
    lvc.modalPresentationStyle = UIModalPresentationFullScreen;
    [_window makeKeyAndVisible];
    [self.splitView presentModalViewController:lvc animated:NO];
    
    
    //set delegate
    UINavigationController *masterNavigationController = [self.splitView.viewControllers objectAtIndex:0];
    ListaVinhosViewController *lvvc = (ListaVinhosViewController *)[[masterNavigationController viewControllers] objectAtIndex:0] ;
    
    /*
     for(UINavigationController* c in self.splitView.viewControllers) {
     NSLog(@"class: %s", class_getName([c class]));
     for (UIViewController* v in c.viewControllers) {
     NSLog(@"-class: %s", class_getName([v class]));
     }
     }
     NSLog(@"--class: %s", class_getName([lvvc class]));
     */
    
    lvc.delegate = lvvc;
    lvc.splitViewController = self.splitView;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
