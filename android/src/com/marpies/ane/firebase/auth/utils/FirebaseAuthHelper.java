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

package com.marpies.ane.firebase.auth.utils;

import android.net.Uri;
import android.support.annotation.NonNull;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.auth.UserInfo;
import com.marpies.ane.firebase.auth.data.FirebaseAuthEvent;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class FirebaseAuthHelper implements FirebaseAuth.AuthStateListener {

	private static FirebaseAuthHelper mInstance;

	public static FirebaseAuthHelper getInstance() {
		if( mInstance == null ) {
			mInstance = new FirebaseAuthHelper();
		}
		return mInstance;
	}

	private FirebaseAuthHelper() { }

	@Override
	public void onAuthStateChanged( @NonNull FirebaseAuth firebaseAuth ) {
		FirebaseUser user = firebaseAuth.getCurrentUser();
		if( user != null ) {
			AIR.log( "User has signed in" );
			String userJSON = getJSONFromUser( user );
			if( userJSON == null ) {
				userJSON = "{}";
			}
			AIR.dispatchEvent( FirebaseAuthEvent.AUTH_STATE_SIGN_IN, userJSON );
		} else {
			AIR.log( "No user is currently signed in" );
			AIR.dispatchEvent( FirebaseAuthEvent.AUTH_STATE_SIGN_OFF );
		}
	}

	private String getJSONFromUser( FirebaseUser newUser ) {
		FirebaseUser user = (newUser == null) ? getUser() : newUser;
		if( user != null ) {
			JSONObject json = new JSONObject();
			try {
				json.put( "uid", user.getUid() );
				json.put( "isAnonymous", user.isAnonymous() );
				if( user.getDisplayName() != null ) {
					json.put( "displayName", user.getDisplayName() );
				}
				if( user.getEmail() != null ) {
					json.put( "email", user.getEmail() );
				}
				if( user.getPhotoUrl() != null ) {
					json.put( "email", user.getPhotoUrl().toString() );
				}
				JSONArray providerData = new JSONArray();
				for( UserInfo userInfo : user.getProviderData() ) {
					String userInfoJSON = getJSONFromUserInfo( userInfo );
					if( userInfoJSON != null ) {
						providerData.put( userInfoJSON );
					}
				}
				if( providerData.length() > 0 ) {
					json.put( "providerData", providerData );
				}
			} catch( JSONException e ) {
				e.printStackTrace();
			}
			return json.toString();
		}
		return null;
	}

	private String getJSONFromUserInfo( UserInfo userInfo ) {
		JSONObject json = new JSONObject();
		try {
			String providerId = userInfo.getProviderId();
			if( providerId != null ) {
				json.put( "providerId", providerId );
			}
			String uid = userInfo.getUid();
			if( uid != null ) {
				json.put( "uid", uid );
			}
			String displayName = userInfo.getDisplayName();
			if( displayName != null ) {
				json.put( "displayName", displayName );
			}
			String email = userInfo.getEmail();
			if( email != null ) {
				json.put( "email", email );
			}
			Uri photoURL = userInfo.getPhotoUrl();
			if( photoURL != null ) {
				json.put( "photoURL", photoURL.toString() );
			}
			return json.toString();
		} catch( JSONException e ) {
			e.printStackTrace();
		}
		return null;
	}

	private FirebaseUser getUser() {
		return FirebaseAuth.getInstance().getCurrentUser();
	}

}
