/**
 * Copyright 2016 Marcel Piestansky (http://marpies.com)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "FirebaseAuth.h"
#import "Functions/InitFunction.h"

static BOOL FirebaseAuthLogEnabled = NO;
FREContext FirebaseAuthExtContext = nil;
static FirebaseAuth* FirebaseAuthSharedInstance = nil;

@implementation FirebaseAuth

@synthesize helper;

+ (id) sharedInstance {
    if( FirebaseAuthSharedInstance == nil ) {
        FirebaseAuthSharedInstance = [[FirebaseAuth alloc] init];
    }
    return FirebaseAuthSharedInstance;
}

+ (void) dispatchEvent:(const NSString*) eventName {
    [self dispatchEvent:eventName withMessage:@""];
}

+ (void) dispatchEvent:(const NSString*) eventName withMessage:(NSString*) message {
    NSString* messageText = message ? message : @"";
    FREDispatchStatusEventAsync( FirebaseAuthExtContext, (const uint8_t*) [eventName UTF8String], (const uint8_t*) [messageText UTF8String] );
}

+ (void) log:(const NSString*) message {
    if( FirebaseAuthLogEnabled ) {
        NSLog( @"[iOS-FirebaseAuth] %@", message );
    }
}

+ (void) showLogs:(BOOL) showLogs {
    FirebaseAuthLogEnabled = showLogs;
}

@end

/**
 *
 *
 * Context initialization
 *
 *
 **/

FRENamedFunction airFirebaseAuthExtFunctions[] = {
    { (const uint8_t*) "init",               0, fba_init }
};

void FirebaseAuthContextInitializer( void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet ) {
    *numFunctionsToSet = sizeof( airFirebaseAuthExtFunctions ) / sizeof( FRENamedFunction );
    
    *functionsToSet = airFirebaseAuthExtFunctions;
    
    FirebaseAuthExtContext = ctx;
}

void FirebaseAuthContextFinalizer( FREContext ctx ) { }

void FirebaseAuthInitializer( void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet ) {
    *extDataToSet = NULL;
    *ctxInitializerToSet = &FirebaseAuthContextInitializer;
    *ctxFinalizerToSet = &FirebaseAuthContextFinalizer;
}

void FirebaseAuthFinalizer( void* extData ) { }







