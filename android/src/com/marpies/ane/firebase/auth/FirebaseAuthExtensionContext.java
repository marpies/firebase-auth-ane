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

package com.marpies.ane.firebase.auth;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.marpies.ane.firebase.auth.functions.*;
import com.marpies.ane.firebase.auth.utils.AIR;

import java.util.HashMap;
import java.util.Map;

public class FirebaseAuthExtensionContext extends FREContext {

	@Override
	public Map<String, FREFunction> getFunctions() {
		Map<String, FREFunction> functions = new HashMap<String, FREFunction>();

		functions.put( "init", new InitFunction() );
		functions.put( "createUser", new CreateUserFunction() );
		functions.put( "signInWithFacebookAccount", new SignInWithFacebookFunction() );
		functions.put( "signInWithGoogleAccount", new SignInWithGoogleFunction() );
		functions.put( "signInWithEmailAndPassword", new SignInWithEmailFunction() );
		functions.put( "signInWithTwitterAccount", new SignInWithTwitterFunction() );
		functions.put( "signInWithGithubAccount", new SignInWithGithubFunction() );
		functions.put( "signInAnonymously", new SignInAnonymouslyFunction() );
		functions.put( "linkWithFacebookAccount", new LinkWithFacebookFunction() );
		functions.put( "linkWithGoogleAccount", new LinkWithGoogleFunction() );
		functions.put( "linkWithEmailAccount", new LinkWithEmailFunction() );
		functions.put( "linkWithTwitterAccount", new LinkWithTwitterFunction() );
		functions.put( "linkWithGithubAccount", new LinkWithGithubFunction() );
		functions.put( "reauthWithFacebookAccount", new ReauthenticateWithFacebookFunction() );
		functions.put( "reauthWithGoogleAccount", new ReauthenticateWithGoogleFunction() );
		functions.put( "reauthWithEmailAccount", new ReauthenticateWithEmailFunction() );
		functions.put( "reauthWithTwitterAccount", new ReauthenticateWithTwitterFunction() );
		functions.put( "reauthWithGithubAccount", new ReauthenticateWithGithubFunction() );
		functions.put( "unlinkFromProvider", new UnlinkFromProviderFunction() );
		functions.put( "updateEmail", new UpdateEmailFunction() );
		functions.put( "updatePassword", new UpdatePasswordFunction() );
		functions.put( "deleteUser", new DeleteUserFunction() );
		functions.put( "changeUserProfile", new UpdateUserProfileFunction() );
		functions.put( "signOut", new SignOutFunction() );

		return functions;
	}

	@Override
	public void dispose() {
		AIR.setContext( null );
	}
}
