//
//  StartApp.m
//
//
//  Created by ShahidJ on 25/02/2015.
//
//

#import "StartApp.h"
#import <Cordova/CDV.h>
@implementation StartApp

NSString  *SART_ACTION_MESSAGE=@"startApp";
NSString  *SART_SUCCESS_PARAMETER=@"success";
NSString *appresult=NULL;
NSString *appid=NULL;
NSString *apptype=NULL;
NSString *urlscheme=NULL;
NSString *appurl=NULL;


CDVPluginResult* apppluginResult = nil;


- (BOOL)startApp:(CDVInvokedUrlCommand*)command
{
    
    NSLog(@"method= %@", command.methodName);
    NSLog(@"SART_ACTION_MESSAGE= %@", SART_ACTION_MESSAGE);
    
    
    if([[SART_ACTION_MESSAGE uppercaseString] isEqualToString:[command.methodName uppercaseString]])
    {
        
        // Check command.arguments here.
        [self.commandDelegate runInBackground:^{
            
            
            NSString *resultType=NULL;
            BOOL getAppResult=NO;
            
            @try{
                NSDictionary* strDict = [command.arguments objectAtIndex:0];
                
                NSLog(@"FilePlugin strDict= %@", strDict);
                NSLog(@"method= %@", command.methodName);
                
                resultType=[strDict valueForKey:@"result"];
                appid=[strDict valueForKey:@"appid"];
                apptype=[strDict valueForKey:@"apptype"];
                urlscheme=[strDict valueForKey:@"urlscheme"];
                appurl=[strDict valueForKey:@"appurl"];
                
                NSLog(@"resultType value json= %@", resultType);
                NSLog(@"appid value json= %@", appid);
                NSLog(@"apptype value json= %@", apptype);
                NSLog(@"urlscheme value json= %@", urlscheme);
                NSLog(@"appurl value json= %@", appurl);
                
            }
            @catch(NSException *e)
            {
                NSLog(@"StartApp %@", e.description);
                apppluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
            }
            
            if([[resultType uppercaseString] isEqualToString:[SART_SUCCESS_PARAMETER uppercaseString]])
            {
                NSLog(@"StartApp before call");
                NSString *typeurl;
                //Replace http or https with url scheme
                
                
                /*********** start facebook ************/
                if([[apptype lowercaseString] isEqualToString:[@"facebook" lowercaseString]])
                {
                    
                    
                            NSString *url_ = @"http://jsocialfeed.gardainformatica.it/facebook-page-id.php?url=";
                            url_=[url_ stringByAppendingString:appurl];
                            NSError *error;
                            
                            NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:url_]];
                            if(data!=nil)
                            {
                                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                    if(error)
                                    {
                                        typeurl=@"";
                                    }
                                    else{
                                        NSLog(@"json: %@", json);
                                        NSLog(@"id: %@", json[@"res"]);
                                        typeurl=@"fb://profile/";
                                        typeurl=[typeurl stringByAppendingString:json[@"res"]];
                                    }
                            }
                            else{
                                typeurl=@"";
                            }
                    
                }
                
                /*********** start twitter ************/
                if([[apptype lowercaseString] isEqualToString:[@"twitter" lowercaseString]])
                {
                    
                    NSArray *urlComponents = [appurl  componentsSeparatedByString:@"twitter.com/"];
                    NSString *twuser=[urlComponents[1] stringByReplacingOccurrencesOfString:@"/" withString:@""];
                    
                    NSLog(@"user %@",twuser);
                    typeurl=@"twitter://user?screen_name=";
                    typeurl=[typeurl stringByAppendingString:twuser];
                }
                
                /*********** start instagram ************/
                if([[apptype lowercaseString] isEqualToString:[@"instagram" lowercaseString]])
                {
                    
                    NSArray *urlComponents = [appurl  componentsSeparatedByString:@"instagram.com/"];
                    NSString *instauser=[urlComponents[1] stringByReplacingOccurrencesOfString:@"/" withString:@""];
                    NSLog(@"user %@",instauser);
                    typeurl=@"instagram://user?username=";
                    typeurl=[typeurl stringByAppendingString:instauser];
                }
                NSLog(@"typeurl %@", typeurl);
                
                /******* no social network found ******/
                if([[typeurl lowercaseString] isEqualToString:[@"" lowercaseString]])
                {
                         if([appurl rangeOfString:@"https"].length!=0)
                         {
                         typeurl=[appurl stringByReplacingOccurrencesOfString:@"https" withString:urlscheme];
                         
                         }
                         else{
                         
                         typeurl=[appurl stringByReplacingOccurrencesOfString:@"http" withString:urlscheme];
                         
                         }
                }
                
                //Try to load url scheme
                @try {
                    
                        getAppResult=[[UIApplication sharedApplication] openURL:[NSURL URLWithString:typeurl]];
                        
                        NSLog(@"StartApp url scheme found");
                                     }
                @catch (NSException *e) {
                    NSLog(@"StartApp app error %@", e.description);
                    getAppResult=NO;
                    
                }
                
                
                NSLog(@"StartApp after call");
                
                if(getAppResult){
                    
                    apppluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:resultType];
                }
                else{
                                            //NSLog(@"StartApp app error");
                    NSLog(@"StartApp url scheme not found load in browser");
                    
                    @try {
                        getAppResult=[[UIApplication sharedApplication] openURL:[NSURL URLWithString:appurl]];
                    }
                    @catch (NSException *e) {
                        NSLog(@"StartApp app error %@", e.description);
                        getAppResult=NO;
                        
                        apppluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Error: App not found"];
                        
                    }
                    
                    
                }
                
                NSLog(getAppResult?@"Yes":@"No");

            }
            else{
                
                apppluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
                NSLog(@"StartApp error ");
                
            }
            
            [self.commandDelegate sendPluginResult:apppluginResult callbackId:command.callbackId];
            
        }];
        
        return true;
    }
    else{
        return false;
    }
}

@end
