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

#ifndef FirebaseAuthEvent_h
#define FirebaseAuthEvent_h

#import <Foundation/Foundation.h>

static NSString* const FBA_SIGN_IN_ERROR = @"signInError";
static NSString* const FBA_SIGN_IN_SUCCESS = @"signInSuccess";
static NSString* const FBA_AUTH_STATE_SIGN_IN = @"authStateSignIn";
static NSString* const FBA_AUTH_STATE_SIGN_OFF = @"authStateSignOff";

static NSString* const FBA_PROFILE_CHANGE_SUCCESS = @"profileChangeSuccess";
static NSString* const FBA_PROFILE_CHANGE_ERROR = @"profileChangeError";

#endif /* FirebaseAuthEvent_h */
