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
NSString *appurl=NULL;

NSMutableDictionary *urlSchemesDict;


CDVPluginResult* apppluginResult = nil;


- (BOOL)startApp:(CDVInvokedUrlCommand*)command
{
    
    NSLog(@"method= %@", command.methodName);
    NSLog(@"SART_ACTION_MESSAGE= %@", SART_ACTION_MESSAGE);
    urlSchemesDict=[NSMutableDictionary dictionaryWithDictionary:@{@"twitter":@"twitter",@"facebook":@"fb",@"youtube":@"http",@"instagram":@"instagram" }];

    
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
                appurl=[strDict valueForKey:@"appurl"];
                
                NSLog(@"resultType value json= %@", resultType);
                NSLog(@"appid value json= %@", appid);
                NSLog(@"apptype value json= %@", apptype);
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
                if([appurl rangeOfString:@"https"].length!=0)
                {
                    typeurl=[appurl stringByReplacingOccurrencesOfString:@"https" withString:urlSchemesDict[apptype]];
                }
                else{
                    typeurl=[appurl stringByReplacingOccurrencesOfString:@"http" withString:urlSchemesDict[apptype]];
                    
                }
                
                NSLog(@"typeurl %@", typeurl);
                
                //Try to load url scheme

                getAppResult=[[UIApplication sharedApplication] openURL:[NSURL URLWithString:typeurl]];
                
                NSLog(@"StartApp after call");
                
                if(getAppResult){
                    
                    apppluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:resultType];
                }
                else{
                    apppluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
                    
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
