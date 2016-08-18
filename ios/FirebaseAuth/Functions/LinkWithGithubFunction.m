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

#import "LinkWithGithubFunction.h"
#import "FirebaseAuth.h"
#import <AIRExtHelpers/MPFREObjectUtils.h>

FREObject fba_linkWithGithub( FREContext context, void* functionData, uint32_t argc, FREObject argv[] ) {
    [FirebaseAuth log:@"FirebaseAuth::fba_linkWithGithub"];
    NSString* accessToken = [MPFREObjectUtils getNSString:argv[0]];
    int callbackId = [MPFREObjectUtils getInt:argv[1]];
    
    FirebaseAuthHelper* authHelper = [[FirebaseAuth sharedInstance] helper];
    [authHelper linkWithGithubAccount:accessToken completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        [authHelper processAuthResponse:user error:error callbackId:callbackId];
    }];
    
    return nil;
}