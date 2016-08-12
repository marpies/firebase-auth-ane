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

#import "FirebaseAuthHelper.h"
#import "FirebaseAuth.h"
#import "FirebaseAuthEvent.h"
#import <AIRExtHelpers/MPStringUtils.h>
#import <FirebaseAuth/FIRUserInfo.h>

@implementation FirebaseAuthHelper

# pragma mark - Public API

- (instancetype) init {
    self = [super init];
    
    [FirebaseAuth log:@"FirebaseAuthHelper::init"];
    
    if( self != nil ) {
        [self addAuthListener];
    }
    
    return self;
}

- (FIRUser*) getUser {
    return [FIRAuth auth].currentUser;
}

- (void) createUserWithEmail:(NSString*) email password:(NSString *)password completion:(FIRAuthResultCallback) completion {
    [FirebaseAuth log:@"Creating new user with email and password"];
    [[FIRAuth auth] createUserWithEmail:email password:password completion:completion];
}

- (void) signInAnonymouslyWithCompletion:(FIRAuthResultCallback) completion {
    [FirebaseAuth log:@"Signing in anonymously"];
    [[FIRAuth auth] signInAnonymouslyWithCompletion:completion];
}

- (void) signInWithEmail:(NSString*) email password:(NSString *)password completion:(FIRAuthResultCallback) completion {
    [FirebaseAuth log:@"Signing in with email and password"];
    [[FIRAuth auth] signInWithEmail:email password:password completion:completion];
}

- (void) signInWithGoogleAccount:(NSString*) idToken accessToken:(NSString*) accessToken completion:(FIRAuthResultCallback) completion {
    [FirebaseAuth log:@"Signing in with Google account"];
    FIRAuthCredential* credential = [FIRGoogleAuthProvider credentialWithIDToken:idToken accessToken:accessToken];
    [[FIRAuth auth] signInWithCredential:credential completion:completion];
}

- (void) signInWithFacebookAccount:(NSString*) accessToken completion:(FIRAuthResultCallback) completion {
    [FirebaseAuth log:@"Signing in with Facebook account"];
    FIRAuthCredential* credential = [FIRFacebookAuthProvider credentialWithAccessToken:accessToken];
    [[FIRAuth auth] signInWithCredential:credential completion:completion];
}

- (NSString*) getJSONFromUser:(FIRUser*) newUser {
    FIRUser* user = (newUser == nil) ? [self getUser] : newUser;
    if( user != nil ) {
        NSMutableDictionary* json = [NSMutableDictionary dictionary];
        json[@"uid"] = user.uid;
        json[@"isAnonymous"] = @(user.isAnonymous);
        if( user.displayName != nil ) {
            json[@"displayName"] = user.displayName;
        }
        NSMutableArray* providerData = [NSMutableArray array];
        for( id<FIRUserInfo> userInfo in user.providerData ) {
            NSString* userInfoJSON = [self getJSONFromUserInfo:userInfo];
            if( userInfoJSON != nil ) {
                [providerData addObject:userInfoJSON];
            }
        }
        if( providerData.count > 0 ) {
            json[@"providerData"] = providerData;
        }
        return [MPStringUtils getJSONString:json];
    }
    return nil;
}

# pragma mark - Private API

- (void) addAuthListener {
    [[FIRAuth auth] addAuthStateDidChangeListener:^(FIRAuth * _Nonnull auth, FIRUser * _Nullable user) {
        if (user != nil) {
            [FirebaseAuth log:@"User has signed in"];
            NSString* userJSON = [self getJSONFromUser:user];
            if( userJSON == nil ) {
                userJSON = @"";
            }
            [FirebaseAuth dispatchEvent:FBA_AUTH_STATE_SIGN_IN withMessage:userJSON];
        } else {
            [FirebaseAuth log:@"No user is currently signed in"];
            /* Dispatch internal event to remove cached FIRUser in AS3 lib */
            [FirebaseAuth dispatchEvent:FBA_AUTH_STATE_SIGN_OFF];
        }
    }];
}

- (NSString*) getJSONFromUserInfo:(id<FIRUserInfo>) userInfo {
    NSMutableDictionary* json = [NSMutableDictionary dictionary];
    NSString* providerID = userInfo.providerID;
    if( providerID != nil ) {
        json[@"providerId"] = providerID;
    }
    NSString* uid = userInfo.uid;
    if( uid != nil ) {
        json[@"uid"] = uid;
    }
    NSString* name = userInfo.displayName;
    if( name != nil ) {
        json[@"displayName"] = name;
    }
    NSString* email = userInfo.email;
    if( email != nil ) {
        json[@"email"] = email;
    }
    NSURL* photoURL = userInfo.photoURL;
    if( photoURL != nil ) {
        json[@"photoURL"] = photoURL.absoluteString;
    }
    return [MPStringUtils getJSONString:json];
}
@end
