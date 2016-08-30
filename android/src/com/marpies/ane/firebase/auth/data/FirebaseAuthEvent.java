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

package com.marpies.ane.firebase.auth.data;

public class FirebaseAuthEvent {

	public static final String SIGN_IN_ERROR = "signInError";
	public static final String SIGN_IN_SUCCESS = "signInSuccess";
	public static final String AUTH_STATE_SIGN_IN = "authStateSignIn";
	public static final String AUTH_STATE_SIGN_OFF = "authStateSignOff";

	public static final String PROFILE_CHANGE_SUCCESS = "profileChangeSuccess";
	public static final String PROFILE_CHANGE_ERROR = "profileChangeError";

}
