/*
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

package com.marpies.ane.firebase.auth.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.google.firebase.auth.AuthCredential;
import com.google.firebase.auth.FacebookAuthProvider;
import com.marpies.ane.firebase.auth.utils.AIR;
import com.marpies.ane.firebase.auth.utils.FREObjectUtils;
import com.marpies.ane.firebase.auth.utils.FirebaseAuthHelper;

public class ReauthenticateWithFacebookFunction extends BaseFunction {

	@Override
	public FREObject call( FREContext context, FREObject[] args ) {
		super.call( context, args );

		AIR.log( "FirebaseAuth::reauthenticateWithFacebook" );
		String accessToken = FREObjectUtils.getString( args[0] );
		final int callbackId = FREObjectUtils.getInt( args[1] );

		AuthCredential credential = FacebookAuthProvider.getCredential( accessToken );
		FirebaseAuthHelper.getInstance().reauthenticateWithCredential( credential, callbackId );

		return null;
	}

}

