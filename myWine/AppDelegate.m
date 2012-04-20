//
//  AppDelegate.m
//  myWine
//
//  Created by Antonio Velasquez on 3/19/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ListaVinhosViewController.h"
#import "User.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    Database * db = [Database instance];
    
    NSError * error = nil;
    //[db deleteDatabase:&error];
    if(![db isDatabaseCreated]){
        if(![db createDatabase:&error]){
            #warning TODO: o error tem a mensagem de erro a ser mostrada ao utilizador, convem mostrar
            DebugLog(@"%@", [error localizedDescription]);
        }
    }
    
    //Add login
    //Remove login
    //Add splitview
    
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
    splitViewController.delegate = (id)navigationController.topViewController;
    
    //check if there's a default user
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* username;
    
    ListaVinhosViewController *lvvc = [[[[splitViewController viewControllers] objectAtIndex:0] viewControllers ] objectAtIndex:0 ];
    
    //if there isn't a default user, show login
    if (!(username = [defaults stringForKey:@"username"])) {
    
        //show login controller at startup
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        LoginViewController *lvc = (LoginViewController *) [storyboard instantiateViewControllerWithIdentifier:@"firstLogin"];
        lvc.modalPresentationStyle = UIModalPresentationFullScreen;
        [_window makeKeyAndVisible];
        [splitViewController presentModalViewController:lvc animated:YES];
    
        //set ListaVinhos as Login's delegate
        lvc.delegate = lvvc;
    }
    
    //if there is a default user
    else {
        [User createWithUsername:username];
        User* user = [User instance];
        [lvvc setVinhos:user.vinhos];
    }
    
    return YES;
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
