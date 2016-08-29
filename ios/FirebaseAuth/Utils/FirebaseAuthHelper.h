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

#import <Foundation/Foundation.h>
#import <FirebaseAuth/FirebaseAuth.h>

@interface FirebaseAuthHelper : NSObject

- (nullable FIRUser*) getUser;

- (void) linkWithCredential:(nonnull FIRAuthCredential*) credential completion:(nullable FIRAuthResultCallback)completion;
- (void) unlinkFromProvider:(nonnull NSString*) providerId completion:(nonnull FIRAuthResultCallback)completion;

- (void) updateEmail:(nonnull NSString*) email completion:(nonnull FIRUserProfileChangeCallback) completion;
- (void) updatePassword:(NSString*) email completion:(FIRUserProfileChangeCallback) completion;
- (void) deleteUserWithCompletion:(FIRUserProfileChangeCallback) completion;
- (void) reauthenticateWithCredential:(nonnull FIRAuthCredential*) credential completion:(nullable FIRUserProfileChangeCallback) completion;

- (BOOL) signOut;

- (void) processAuthResponse:(nullable FIRUser*) user error:(nullable NSError*) error callbackId:(int) callbackId;
- (void) processProfileChangeResponse:(nullable NSError*) error callbackId:(int) callbackId;

@end
