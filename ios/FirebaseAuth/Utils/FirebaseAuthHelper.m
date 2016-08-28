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

# pragma mark - Create user / Sign in

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

- (void) signInWithGithubAccount:(NSString*) accessToken completion:(FIRAuthResultCallback) completion {
    [FirebaseAuth log:@"Signing in with Github account"];
    FIRAuthCredential* credential = [FIRGitHubAuthProvider credentialWithToken:accessToken];
    [[FIRAuth auth] signInWithCredential:credential completion:completion];
}

- (void) signInWithTwitterAccount:(NSString*) accessToken secret:(NSString*) secret completion:(FIRAuthResultCallback) completion {
    [FirebaseAuth log:@"Signing in with Twitter account"];
    FIRAuthCredential* credential = [FIRTwitterAuthProvider credentialWithToken:accessToken secret:secret];
    [[FIRAuth auth] signInWithCredential:credential completion:completion];
}

# pragma mark - Link / Unlink

- (void) linkWithEmail:(nonnull NSString*) email password:(nonnull NSString *)password completion:(nullable FIRAuthResultCallback)completion {
    [FirebaseAuth log:@"Linking with email and password"];
    FIRAuthCredential* credential = [FIREmailPasswordAuthProvider credentialWithEmail:email password:password];
    [self linkWithCredential:credential completion:completion];
}

- (void) linkWithGoogleAccount:(NSString*) idToken accessToken:(NSString*) accessToken completion:(FIRAuthResultCallback) completion {
    [FirebaseAuth log:@"Linking with Google account"];
    FIRAuthCredential* credential = [FIRGoogleAuthProvider credentialWithIDToken:idToken accessToken:accessToken];
    [self linkWithCredential:credential completion:completion];
}

- (void) linkWithFacebookAccount:(NSString*) accessToken completion:(FIRAuthResultCallback) completion {
    [FirebaseAuth log:@"Linking with Facebook account"];
    FIRAuthCredential* credential = [FIRFacebookAuthProvider credentialWithAccessToken:accessToken];
    [self linkWithCredential:credential completion:completion];
}

- (void) linkWithGithubAccount:(nonnull NSString*) accessToken completion:(nullable FIRAuthResultCallback)completion {
    [FirebaseAuth log:@"Linking with Github account"];
    FIRAuthCredential* credential = [FIRGitHubAuthProvider credentialWithToken:accessToken];
    [self linkWithCredential:credential completion:completion];
}

- (void) linkWithTwitterAccount:(nonnull NSString*) accessToken secret:(nonnull NSString*) secret completion:(nullable FIRAuthResultCallback) completion {
    [FirebaseAuth log:@"Linking with Twitter account"];
    FIRAuthCredential* credential = [FIRTwitterAuthProvider credentialWithToken:accessToken secret:secret];
    [self linkWithCredential:credential completion:completion];
}

- (void) unlinkFromProvider:(NSString*) providerId completion:(FIRAuthResultCallback) completion {
    FIRUser* user = [self getUser];
    if( user != nil ) {
        [FirebaseAuth log:[NSString stringWithFormat:@"Unlinking from provider: %@", providerId]];
        [user unlinkFromProvider:providerId completion:completion];
    } else {
        completion( nil, [NSError errorWithDomain:@"com.marpies.ane.firebase.auth.error"
                                             code:1338
                                         userInfo:@{ NSLocalizedDescriptionKey: @"Unable to unlink from provider, user is not signed in." }] );
    }
}

# pragma mark - User updates

- (void) updateEmail:(NSString*) email completion:(FIRUserProfileChangeCallback) completion {
    FIRUser* user = [self getUser];
    if( user != nil ) {
        [user updateEmail:email completion:completion];
    } else {
        completion( [NSError errorWithDomain:@"com.marpies.ane.firebase.auth.error"
                                        code:1339
                                    userInfo:@{ NSLocalizedDescriptionKey: @"Unable to update email, user is not signed in." }] );
    }
}

# pragma mark - Misc

- (BOOL) signOut {
    NSError *error;
    [[FIRAuth auth] signOut:&error];
    if( error == nil ) {
        return YES;
    }
    return NO;
}

- (FIRUser*) getUser {
    return [FIRAuth auth].currentUser;
}

- (void) processAuthResponse:(nullable FIRUser*) user error:(nullable NSError*) error callbackId:(int) callbackId {
    /* Success */
    if( error == nil ) {
        NSString* userJSON = [self getJSONFromUser:user];
        NSMutableDictionary* response = [NSMutableDictionary dictionary];
        response[@"user"] = userJSON;
        response[@"callbackId"] = @(callbackId);
        NSString* responseJSON = [MPStringUtils getJSONString:response];
        if( responseJSON != nil ) {
            [FirebaseAuth log:@"User authentication success"];
            [FirebaseAuth dispatchEvent:FBA_SIGN_IN_SUCCESS withMessage:responseJSON];
        } else {
            [FirebaseAuth log:@"User authentication success, but failed to create response"];
            [FirebaseAuth dispatchEvent:FBA_SIGN_IN_ERROR withMessage:[MPStringUtils getEventErrorJSONString:callbackId errorMessage:@"Failed to create response."]];
        }
    }
    /* Error */
    else {
        [FirebaseAuth log:[NSString stringWithFormat:@"Error authenticating user: %@", error.localizedDescription]];
        [FirebaseAuth dispatchEvent:FBA_SIGN_IN_ERROR withMessage:[MPStringUtils getEventErrorJSONString:callbackId errorMessage:error.localizedDescription]];
    }
}

- (void) processProfileChangeResponse:(nullable NSError*) error callbackId:(int) callbackId {
    /* Success */
    if( error == nil ) {
        [FirebaseAuth log:@"Successfully changed user profile"];
        [FirebaseAuth dispatchEvent:FBA_PROFILE_CHANGE_SUCCESS withMessage:[NSString stringWithFormat:@"%i", callbackId]];
    }
    /* Error */
    else {
        [FirebaseAuth log:[NSString stringWithFormat:@"Error changing user profile: %@", error.localizedDescription]];
        [FirebaseAuth dispatchEvent:FBA_PROFILE_CHANGE_ERROR withMessage:[MPStringUtils getEventErrorJSONString:callbackId errorMessage:error.localizedDescription]];
    }
}

# pragma mark - Private API

- (NSString*) getJSONFromUser:(FIRUser*) newUser {
    FIRUser* user = (newUser == nil) ? [self getUser] : newUser;
    if( user != nil ) {
        NSMutableDictionary* json = [NSMutableDictionary dictionary];
        json[@"uid"] = user.uid;
        json[@"isAnonymous"] = @(user.isAnonymous);
        if( user.displayName != nil ) {
            json[@"displayName"] = user.displayName;
        }
        if( user.email != nil ) {
            json[@"email"] = user.email;
        }
        if( user.photoURL != nil ) {
            json[@"photoURL"] = user.photoURL;
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

- (void) linkWithCredential:(FIRAuthCredential*) credential completion:(nullable FIRAuthResultCallback)completion {
    FIRUser* user = [self getUser];
    if( user != nil ) {
        [user linkWithCredential:credential completion:completion];
    } else {
        [FirebaseAuth log:@"Linking failed because user is not signed in."];
        if( completion != nil ) {
            completion( nil, [NSError errorWithDomain:@"com.marpies.ane.firebase.auth.error"
                                                 code:1337
                                             userInfo:@{ NSLocalizedDescriptionKey: @"Unable to link account, user is not signed in." }] );
        }
    }
}

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
