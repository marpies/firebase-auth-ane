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

#import "CreateUserFunction.h"
#import "FirebaseAuth.h"
#import "FirebaseAuthEvent.h"
#import <AIRExtHelpers/MPFREObjectUtils.h>
#import <AIRExtHelpers/MPStringUtils.h>

FREObject fba_createUser( FREContext context, void* functionData, uint32_t argc, FREObject argv[] ) {
    [FirebaseAuth log:@"FirebaseAuth::fba_createUser"];
    NSString* email = [MPFREObjectUtils getNSString:argv[0]];
    NSString* password = [MPFREObjectUtils getNSString:argv[1]];
    int callbackId = [MPFREObjectUtils getInt:argv[2]];
    
    FirebaseAuthHelper* authHelper = [[FirebaseAuth sharedInstance] helper];
    [authHelper createUserWithEmail:email password:password completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        /* Success */
        if( error == nil ) {
            NSString* userJSON = [authHelper getJSONFromUser:user];
            NSMutableDictionary* response = [NSMutableDictionary dictionary];
            response[@"user"] = userJSON;
            response[@"callbackId"] = @(callbackId);
            NSString* responseJSON = [MPStringUtils getJSONString:response];
            if( responseJSON != nil ) {
                [FirebaseAuth log:@"User creation/sign in success"];
                [FirebaseAuth dispatchEvent:FBA_SIGN_IN_SUCCESS withMessage:responseJSON];
            } else {
                [FirebaseAuth log:@"User creation/sign in success, but failed to create response"];
                [FirebaseAuth dispatchEvent:FBA_SIGN_IN_ERROR withMessage:[MPStringUtils getEventErrorJSONString:callbackId errorMessage:@"Failed to create response."]];
            }
        }
        /* Error */
        else {
            [FirebaseAuth log:[NSString stringWithFormat:@"Error creating user: %@", error.localizedDescription]];
            [FirebaseAuth dispatchEvent:FBA_SIGN_IN_ERROR withMessage:[MPStringUtils getEventErrorJSONString:callbackId errorMessage:error.localizedDescription]];
        }
    }];
    
    return nil;
}