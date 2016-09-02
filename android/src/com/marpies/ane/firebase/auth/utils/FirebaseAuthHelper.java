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
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.*;
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

	/**
	 *
	 *
	 * Public API
	 *
	 *
	 */

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

	public void signInWithCredential( AuthCredential credential, final int callbackId ) {
		FirebaseAuth.getInstance()
				.signInWithCredential( credential )
				.addOnCompleteListener( new OnCompleteListener<AuthResult>() {
					@Override
					public void onComplete( @NonNull Task<AuthResult> task ) {
						processAuthResponse( task, callbackId );
					}
				} );
	}

	public void linkWithCredential( AuthCredential credential, final int callbackId ) {
		FirebaseUser user = getUser();
		if( user != null ) {
			user.linkWithCredential( credential )
					.addOnCompleteListener( new OnCompleteListener<AuthResult>() {
						@Override
						public void onComplete( @NonNull Task<AuthResult> task ) {
							processAuthResponse( task, callbackId );
						}
					} );
		} else {
			dispatchAuthErrorResponse( "Unable to link with provider, user is not signed in.", callbackId );
		}
	}

	public void reauthenticateWithCredential( AuthCredential credential, final int callbackId ) {
		FirebaseUser user = getUser();
		if( user != null ) {
			user.reauthenticate( credential )
					.addOnCompleteListener( new OnCompleteListener<Void>() {
						@Override
						public void onComplete( @NonNull Task<Void> task ) {
							processProfileChangeResponse( task, callbackId );
						}
					} );
		} else {
			dispatchProfileChangeErrorResponse( "Unable to reauthenticate user, user is not signed in.", callbackId );
		}
	}

	public void processAuthResponse( @NonNull Task<AuthResult> task, int callbackId ) {
		if( task.isSuccessful() ) {
			JSONObject response = new JSONObject();
			try {
				response.put( "user", getJSONFromUser( task.getResult().getUser() ) );
				response.put( "callbackId", callbackId );
				AIR.dispatchEvent( FirebaseAuthEvent.SIGN_IN_SUCCESS, response.toString() );
			} catch( JSONException e ) {
				e.printStackTrace();
				AIR.log( "User authentication success, but failed to create response" );
				dispatchAuthErrorResponse( "Failed to create response.", callbackId );
			}
		} else {
			String errorMessage = (task.getException() != null) ? task.getException().getLocalizedMessage() : "Unknown error.";
			AIR.log( "Error authenticating user: " + errorMessage );
			dispatchAuthErrorResponse( errorMessage, callbackId );
		}
	}

	public void unlinkFromProvider( String providerId, final int callbackId ) {
		FirebaseUser user = getUser();
		if( user != null ) {
			user.unlink( providerId )
					.addOnCompleteListener( new OnCompleteListener<AuthResult>() {
						@Override
						public void onComplete( @NonNull Task<AuthResult> task ) {
							processAuthResponse( task, callbackId );
						}
					} );
		} else {
			dispatchAuthErrorResponse( "Unable to unlink from provider, user is not signed in.", callbackId );
		}
	}

	public void updateEmail( String email, final int callbackId ) {
		FirebaseUser user = getUser();
		if( user != null ) {
			user.updateEmail( email )
					.addOnCompleteListener( new OnCompleteListener<Void>() {
						@Override
						public void onComplete( @NonNull Task<Void> task ) {
							processProfileChangeResponse( task, callbackId );
						}
					} );
		} else {
			dispatchProfileChangeErrorResponse( "Unable to update email, user is not signed in.", callbackId );
		}
	}

	public void updatePassword( String password, final int callbackId ) {
		FirebaseUser user = getUser();
		if( user != null ) {
			user.updatePassword( password )
					.addOnCompleteListener( new OnCompleteListener<Void>() {
						@Override
						public void onComplete( @NonNull Task<Void> task ) {
							processProfileChangeResponse( task, callbackId );
						}
					} );
		} else {
			dispatchProfileChangeErrorResponse( "Unable to update password, user is not signed in.", callbackId );
		}
	}

	public void deleteUser( final int callbackId ) {
		FirebaseUser user = getUser();
		if( user != null ) {
			user.delete()
					.addOnCompleteListener( new OnCompleteListener<Void>() {
						@Override
						public void onComplete( @NonNull Task<Void> task ) {
							processProfileChangeResponse( task, callbackId );
						}
					} );
		} else {
			dispatchProfileChangeErrorResponse( "Unable to delete user, user is not signed in.", callbackId );
		}
	}

	public void updateUserProfile( String displayName, String photoURL, final int callbackId ) {
		FirebaseUser user = getUser();
		if( user != null ) {
			UserProfileChangeRequest.Builder request = new UserProfileChangeRequest.Builder();
			if( displayName != null ) {
				request.setDisplayName( displayName );
			}
			if( photoURL != null ) {
				request.setPhotoUri( Uri.parse( photoURL ) );
			}
			user.updateProfile( request.build() )
					.addOnCompleteListener( new OnCompleteListener<Void>() {
						@Override
						public void onComplete( @NonNull Task<Void> task ) {
							processProfileChangeResponse( task, callbackId );
						}
					} );
		} else {
			dispatchProfileChangeErrorResponse( "Unable to update profile, user is not signed in.", callbackId );
		}
	}

	/**
	 *
	 *
	 * Private API
	 *
	 *
	 */

	private void processProfileChangeResponse( @NonNull Task<Void> task, int callbackId ) {
		if( task.isSuccessful() ) {
			AIR.dispatchEvent( FirebaseAuthEvent.PROFILE_CHANGE_SUCCESS, String.valueOf( callbackId ) );
		} else {
			String errorMessage = (task.getException() != null) ? task.getException().getLocalizedMessage() : "Unknown error.";
			AIR.log( "Error changing user profile: " + errorMessage );
			dispatchProfileChangeErrorResponse( errorMessage, callbackId );
		}
	}

	private void dispatchAuthErrorResponse( String errorMessage, int callbackId ) {
		AIR.dispatchEvent( FirebaseAuthEvent.SIGN_IN_ERROR, StringUtils.getEventErrorJSON( callbackId, errorMessage ) );
	}

	private void dispatchProfileChangeErrorResponse( String errorMessage, int callbackId ) {
		AIR.dispatchEvent( FirebaseAuthEvent.PROFILE_CHANGE_ERROR, StringUtils.getEventErrorJSON( callbackId, errorMessage ) );
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
