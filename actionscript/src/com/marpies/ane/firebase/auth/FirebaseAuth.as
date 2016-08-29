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

package com.marpies.ane.firebase.auth {

    import flash.events.StatusEvent;

    CONFIG::ane {
        import flash.external.ExtensionContext;
    }

    import flash.system.Capabilities;
    import flash.utils.Dictionary;

    /**
     * Class providing APIs for the Firebase Authentication service.
     */
    public class FirebaseAuth {

        private static const TAG:String = "[FirebaseAuth]";
        private static const EXTENSION_ID:String = "com.marpies.ane.firebase.auth";
        private static const iOS:Boolean = Capabilities.manufacturer.indexOf( "iOS" ) > -1;
        private static const ANDROID:Boolean = Capabilities.manufacturer.indexOf( "Android" ) > -1;

        CONFIG::ane {
            private static var mContext:ExtensionContext;
        }

        /* Event codes */
        private static const SIGN_IN_ERROR:String = "signInError";
        private static const SIGN_IN_SUCCESS:String = "signInSuccess";
        private static const AUTH_STATE_SIGN_IN:String = "authStateSignIn";
        private static const AUTH_STATE_SIGN_OFF:String = "authStateSignOff";
        private static const FBA_PROFILE_CHANGE_SUCCESS:String = "profileChangeSuccess";
        private static const FBA_PROFILE_CHANGE_ERROR:String = "profileChangeError";


        /* Callbacks */
        private static var mCallbackMap:Dictionary;
        private static var mCallbackIdCounter:int;

        /* Misc */
        private static var mFirebaseUser:FirebaseUser;
        private static var mInitialized:Boolean;
        private static var mLogEnabled:Boolean;

        /**
         * @private
         * Do not use. FirebaseAuth is a static class.
         */
        public function FirebaseAuth() {
            throw Error( "FirebaseAuth is static class." );
        }

        /**
         *
         *
         * Public API
         *
         *
         */

        /**
         * Initializes extension context.
         *
         * @param showLogs Set to <code>true</code> to show extension log messages.
         *
         * @return <code>true</code> if the extension context was created, <code>false</code> otherwise
         */
        public static function init( showLogs:Boolean = false ):Boolean {
            if( !isSupported ) return false;
            if( mInitialized ) return true;

            mLogEnabled = showLogs;

            /* Initialize context */
            if( !initExtensionContext() ) {
                log( "Error creating extension context for " + EXTENSION_ID );
                return false;
            }
            /* Listen for native library events */
            CONFIG::ane {
                mContext.addEventListener( StatusEvent.STATUS, onStatus );
            }

            mCallbackMap = new Dictionary();

            /* Call init */
            CONFIG::ane {
                mContext.call( "init", showLogs );
            }

            mInitialized = true;
            return true;
        }

        /**
         * Attempts to create a new user account with the given email address and password.
         * If successful, it also signs the user in into the app.
         *
         * @param email User's email address.
         * @param password User's password.
         * @param callback Function with the following signature:
         * <listing version="3.0">
         * function callback( user:FirebaseUser, errorMessage:String ):void {
         *      if( errorMessage == null ) {
         *          // user has been created and signed in
         *      } else {
         *          // there was an error creating the user
         *      }
         * };
         * </listing>
         */
        public static function createUser( email:String, password:String, callback:Function ):void {
            if( !isSupported ) return;
            validateExtensionContext();

            if( email === null ) throw new ArgumentError( "Parameter email cannot be null." );
            if( password === null ) throw new ArgumentError( "Parameter password cannot be null." );
            if( callback === null ) throw new ArgumentError( "Parameter callback cannot be null." );

            CONFIG::ane {
                mContext.call( "createUser", email, password, registerCallback( callback ) );
            }
        }

        /**
         * Attempts to sign in anonymously, i.e. creates an anonymous user.
         * If there is already an anonymous user signed in, that user will be returned instead.
         *
         * @param callback Function with the following signature:
         * <listing version="3.0">
         * function callback( user:FirebaseUser, errorMessage:String ):void {
         *      if( errorMessage == null ) {
         *          // user has been signed in
         *      } else {
         *          // there was an error singing the user in
         *      }
         * };
         * </listing>
         */
        public static function signInAnonymously( callback:Function ):void {
            if( !isSupported ) return;
            validateExtensionContext();

            if( callback === null ) throw new ArgumentError( "Parameter callback cannot be null." );

            CONFIG::ane {
                mContext.call( "signInAnonymously", registerCallback( callback ) );
            }
        }

        /**
         * Attempts to sign the user in using email and password. This is equivalent to calling
         * <code>signInWithCredential</code> with an <code>EmailAuthCredential</code>.
         *
         * @param email User's email address.
         * @param password User's password.
         * @param callback Function with the following signature:
         * <listing version="3.0">
         * function callback( user:FirebaseUser, errorMessage:String ):void {
         *      if( errorMessage == null ) {
         *          // user has been signed in
         *      } else {
         *          // there was an error singing the user in
         *      }
         * };
         * </listing>
         */
        public static function signInWithEmailAndPassword( email:String, password:String, callback:Function ):void {
            signInWithCredential( EmailAuthProvider.getCredential( email, password ), callback );
        }

        /**
         * Attempts to sign in a user with the given credential.
         *
         * <p>Use this method to sign in a user into your Firebase Authentication system. First retrieve the
         * credential either directly from the user, in case of <code>EmailAuthCredential</code>, or from a
         * supported authentication SDK, such as Google Sign-In or Facebook.</p>
         *
         * <p>For all <code>IAuthCredential</code> types except <code>EmailAuthCredential</code>, this method
         * will create an account for the user in the case that it didn't exist before.</p>
         *
         * <p><strong>Important:</strong> you must configure the authentication providers in the Firebase console
         * before you can use them.</p>
         *
         * @param credential The credential to use to sign in a user.
         * @param callback Function with the following signature:
         * <listing version="3.0">
         * function callback( user:FirebaseUser, errorMessage:String ):void {
         *      if( errorMessage == null ) {
         *          // user has been signed in
         *      } else {
         *          // there was an error singing the user in
         *      }
         * };
         * </listing>
         *
         * @see com.marpies.ane.firebase.auth.EmailAuthProvider#getCredential()
         * @see com.marpies.ane.firebase.auth.FacebookAuthProvider#getCredential()
         * @see com.marpies.ane.firebase.auth.GoogleAuthProvider#getCredential()
         * @see com.marpies.ane.firebase.auth.TwitterAuthProvider#getCredential()
         * @see com.marpies.ane.firebase.auth.GithubAuthProvider#getCredential()
         */
        public static function signInWithCredential( credential:IAuthCredential, callback:Function ):void {
            if( !isSupported ) return;
            validateExtensionContext();

            if( callback === null ) throw new ArgumentError( "Parameter callback cannot be null." );
            if( credential === null ) throw new ArgumentError( "Parameter credential cannot be null." );

            switch( credential.providerId ) {
                case FirebaseAuthProviders.EMAIL:
                    signInWithEmailCredential( credential as EmailAuthCredential, callback );
                    return;
                case FirebaseAuthProviders.FACEBOOK:
                    signInWithFacebookCredential( credential as FacebookAuthCredential, callback );
                    return;
                case FirebaseAuthProviders.GOOGLE:
                    signInWithGoogleCredential( credential as GoogleAuthCredential, callback );
                    return;
                case FirebaseAuthProviders.TWITTER:
                    signInWithTwitterCredential( credential as TwitterAuthCredential, callback );
                    return;
                case FirebaseAuthProviders.GITHUB:
                    signInWithGithubCredential( credential as GithubAuthCredential, callback );
                    return;
                default:
                    throw new ArgumentError( "Encountered credential for unknown provider: " + credential.providerId );
            }
        }

        /**
         * Signs out the current user and clears it from the disk cache.
         *
         * @return <code>true</code> error did not occur, <code>false</code> otherwise.
         */
        public static function signOut():Boolean {
            if( !isSupported ) return false;
            validateExtensionContext();

            var result:Boolean;
            CONFIG::ane {
                result = mContext.call( "signOut" ) as Boolean;
            }
            return result;
        }

        /**
         * Disposes native extension context.
         */
        public static function dispose():void {
            if( !isSupported ) return;
            validateExtensionContext();

            mFirebaseUser = null;

            CONFIG::ane {
                mContext.removeEventListener( StatusEvent.STATUS, onStatus );
                mContext.dispose();
                mContext = null;
            }

            mInitialized = false;
        }

        /**
         *
         *
         * Getters / Setters
         *
         *
         */

        public static function get currentUser():FirebaseUser {
            return mFirebaseUser;
        }

        /**
         * Extension version.
         */
        public static function get version():String {
            return "0.3.0";
        }

        /**
         * Supported on iOS and Android.
         */
        public static function get isSupported():Boolean {
            return iOS || ANDROID;
        }

        /**
         *
         *
         * Internal API
         *
         *
         */

        /**
         *
         * LINK WITH CREDENTIAL
         *
         */

        /**
         * @private
         */
        internal static function linkWithEmailCredential( credential:EmailAuthCredential, callback:Function ):void {
            if( credential === null ) throw new ArgumentError( "Invalid email credential provided." );

            CONFIG::ane {
                mContext.call( "linkWithEmailAndPassword", credential.email, credential.password, registerCallback( callback ) );
            }
        }

        /**
         * @private
         */
        internal static function linkWithFacebookCredential( credential:FacebookAuthCredential, callback:Function ):void {
            if( credential === null ) throw new ArgumentError( "Invalid Facebook credential provided." );

            CONFIG::ane {
                mContext.call( "linkWithFacebookAccount", credential.accessToken, registerCallback( callback ) );
            }
        }

        /**
         * @private
         */
        internal static function linkWithGoogleCredential( credential:GoogleAuthCredential, callback:Function ):void {
            if( credential === null ) throw new ArgumentError( "Invalid Google credential provided." );

            CONFIG::ane {
                mContext.call( "linkWithGoogleAccount", credential.idToken, credential.accessToken, registerCallback( callback ) );
            }
        }

        /**
         * @private
         */
        internal static function linkWithTwitterCredential( credential:TwitterAuthCredential, callback:Function ):void {
            if( credential === null ) throw new ArgumentError( "Invalid Twitter credential provided." );

            CONFIG::ane {
                mContext.call( "linkWithTwitterAccount", credential.token, credential.secret, registerCallback( callback ) );
            }
        }

        /**
         * @private
         */
        internal static function linkWithGithubCredential( credential:GithubAuthCredential, callback:Function ):void {
            if( credential === null ) throw new ArgumentError( "Invalid Github credential provided." );

            CONFIG::ane {
                mContext.call( "linkWithGithubAccount", credential.accessToken, registerCallback( callback ) );
            }
        }

        /**
         * @private
         */
        internal static function unlinkFromProvider( providerId:String, callback:Function ):void {
            CONFIG::ane {
                mContext.call( "unlinkFromProvider", providerId, registerCallback( callback ) );
            }
        }

        /**
         * @private
         */
        internal static function reauthenticate( credential:IAuthCredential, callback:Function ):void {
            switch( credential.providerId ) {
                case FirebaseAuthProviders.EMAIL:
                    reauthenticateWithEmailCredential( credential as EmailAuthCredential, callback );
                    return;
                case FirebaseAuthProviders.FACEBOOK:
                    reauthenticateWithFacebookCredential( credential as FacebookAuthCredential, callback );
                    return;
                case FirebaseAuthProviders.GOOGLE:
                    reauthenticateWithGoogleCredential( credential as GoogleAuthCredential, callback );
                    return;
                case FirebaseAuthProviders.TWITTER:
                    reauthenticateWithTwitterCredential( credential as TwitterAuthCredential, callback );
                    return;
                case FirebaseAuthProviders.GITHUB:
                    reauthenticateWithGithubCredential( credential as GithubAuthCredential, callback );
                    return;
                default:
                    throw new ArgumentError( "Encountered credential for unknown provider: " + credential.providerId );
            }
        }

        /**
         * @private
         */
        internal static function updateEmail( email:String, callback:Function ):void {
            CONFIG::ane {
                mContext.call( "updateEmail", email, registerCallback( callback ) );
            }
        }

        /**
         * @private
         */
        internal static function updatePassword( password:String, callback:Function ):void {
            CONFIG::ane {
                mContext.call( "updatePassword", password, registerCallback( callback ) );
            }
        }

        /**
         * @private
         */
        internal static function changeUserProfile( displayName:String, photoURL:String, callback:Function ):void {
            CONFIG::ane {
                mContext.call( "changeUserProfile", displayName, photoURL, registerCallback( callback ) );
            }
        }

        /**
         * @private
         */
        internal static function validateExtensionContext():void {
            CONFIG::ane {
                if( !mContext ) throw new Error( "FirebaseAuth extension was not initialized. Call init() first." );
            }
        }

        /**
         *
         *
         * Private API
         *
         *
         */

        /**
         *
         * SIGN IN WITH CREDENTIAL
         *
         */

        private static function signInWithEmailCredential( credential:EmailAuthCredential, callback:Function ):void {
            if( credential === null ) throw new ArgumentError( "Invalid email credential provided." );

            CONFIG::ane {
                mContext.call( "signInWithEmailAndPassword", credential.email, credential.password, registerCallback( callback ) );
            }
        }

        private static function signInWithFacebookCredential( credential:FacebookAuthCredential, callback:Function ):void {
            if( credential === null ) throw new ArgumentError( "Invalid Facebook credential provided." );

            CONFIG::ane {
                mContext.call( "signInWithFacebookAccount", credential.accessToken, registerCallback( callback ) );
            }
        }

        private static function signInWithGoogleCredential( credential:GoogleAuthCredential, callback:Function ):void {
            if( credential === null ) throw new ArgumentError( "Invalid Google credential provided." );

            CONFIG::ane {
                mContext.call( "signInWithGoogleAccount", credential.idToken, credential.accessToken, registerCallback( callback ) );
            }
        }

        private static function signInWithTwitterCredential( credential:TwitterAuthCredential, callback:Function ):void {
            if( credential === null ) throw new ArgumentError( "Invalid Twitter credential provided." );

            CONFIG::ane {
                mContext.call( "signInWithTwitterAccount", credential.token, credential.secret, registerCallback( callback ) );
            }
        }

        private static function signInWithGithubCredential( credential:GithubAuthCredential, callback:Function ):void {
            if( credential === null ) throw new ArgumentError( "Invalid Github credential provided." );

            CONFIG::ane {
                mContext.call( "signInWithGithubAccount", credential.accessToken, registerCallback( callback ) );
            }
        }

        /**
         *
         * REAUTHENTICATE WITH CREDENTIAL
         *
         */

        private static function reauthenticateWithEmailCredential( credential:EmailAuthCredential, callback:Function ):void {
            if( credential === null ) throw new ArgumentError( "Invalid email credential provided." );

            CONFIG::ane {
                mContext.call( "reauthWithEmailAndPassword", credential.email, credential.password, registerCallback( callback ) );
            }
        }

        private static function reauthenticateWithFacebookCredential( credential:FacebookAuthCredential, callback:Function ):void {
            if( credential === null ) throw new ArgumentError( "Invalid Facebook credential provided." );

            CONFIG::ane {
                mContext.call( "reauthWithFacebookAccount", credential.accessToken, registerCallback( callback ) );
            }
        }

        private static function reauthenticateWithGoogleCredential( credential:GoogleAuthCredential, callback:Function ):void {
            if( credential === null ) throw new ArgumentError( "Invalid Google credential provided." );

            CONFIG::ane {
                mContext.call( "reauthWithGoogleAccount", credential.idToken, credential.accessToken, registerCallback( callback ) );
            }
        }

        private static function reauthenticateWithTwitterCredential( credential:TwitterAuthCredential, callback:Function ):void {
            if( credential === null ) throw new ArgumentError( "Invalid Twitter credential provided." );

            CONFIG::ane {
                mContext.call( "reauthWithTwitterAccount", credential.token, credential.secret, registerCallback( callback ) );
            }
        }

        private static function reauthenticateWithGithubCredential( credential:GithubAuthCredential, callback:Function ):void {
            if( credential === null ) throw new ArgumentError( "Invalid Github credential provided." );

            CONFIG::ane {
                mContext.call( "reauthWithGithubAccount", credential.accessToken, registerCallback( callback ) );
            }
        }

        /**
         * Initializes extension context.
         * @return <code>true</code> if initialized successfully, <code>false</code> otherwise.
         */
        private static function initExtensionContext():Boolean {
            var result:Boolean;
            CONFIG::ane {
                if( mContext === null ) {
                    mContext = ExtensionContext.createExtensionContext( EXTENSION_ID, null );
                }
                result = mContext !== null;
            }
            return result;
        }

        /**
         * Registers given callback and generates ID which is used to look the callback up when it is time to call it.
         * @param callback Function to register.
         * @return ID of the callback.
         */
        private static function registerCallback( callback:Function ):int {
            if( callback == null ) return -1;

            mCallbackMap[mCallbackIdCounter] = callback;
            return mCallbackIdCounter++;
        }

        /**
         * Gets registered callback with given ID.
         * @param callbackID ID of the callback to retrieve.
         * @return Callback registered with given ID, or <code>null</code> if no such callback exists.
         */
        private static function getCallback( callbackID:int ):Function {
            if( callbackID == -1 || !(callbackID in mCallbackMap) ) return null;
            return mCallbackMap[callbackID];
        }

        /**
         * Unregisters callback with given ID.
         * @param callbackID ID of the callback to unregister.
         */
        private static function unregisterCallback( callbackID:int ):void {
            if( callbackID in mCallbackMap ) {
                delete mCallbackMap[callbackID];
            }
        }

        private static function onStatus( event:StatusEvent ):void {
            var json:Object = null;
            var callback:Function = null;
            switch( event.code ) {
                case SIGN_IN_SUCCESS:
                    json = JSON.parse( event.level );
                    mFirebaseUser = FirebaseUser.fromJSON( json.user );
                    callback = getCallbackFromJSON( json );
                    if( callback !== null ) {
                        callback( mFirebaseUser, null );
                    }
                    return;

                case SIGN_IN_ERROR:
                    json = JSON.parse( event.level );
                    callback = getCallbackFromJSON( json );
                    if( callback !== null ) {
                        callback( null, json.errorMessage );
                    }
                    return;

                case AUTH_STATE_SIGN_IN:
                    /* We may receive this event on app startup when user has signed in before */
                    if( mFirebaseUser === null ) {
                        json = (event.level != "") ? JSON.parse( event.level ) : null;
                        if( json !== null ) {
                            mFirebaseUser = FirebaseUser.fromJSON( json );
                        }
                    }
                    return;

                case AUTH_STATE_SIGN_OFF:
                    mFirebaseUser = null;
                    return;

                case FBA_PROFILE_CHANGE_SUCCESS:
                    callback = getCallback( int( event.level ) );
                    if( callback !== null ) {
                        callback( null );
                    }
                    return;

                case FBA_PROFILE_CHANGE_ERROR:
                    json = JSON.parse( event.level );
                    callback = getCallbackFromJSON( json );
                    if( callback !== null ) {
                        callback( json.errorMessage );
                    }
                    return;
            }
        }

        /**
         * Retrieves callback ID from JSON response and gets callback registered with that ID.
         * If callback is found, it is removed from the callback map.
         *
         * @param json JSON response that is expected to contain callback ID.
         * @return Callback registered for the ID found in the JSON, or <code>null</code> if no callback exists.
         */
        private static function getCallbackFromJSON( json:Object ):Function {
            var callbackId:int = -1;
            if( "callbackId" in json ) {
                callbackId = json.callbackId;
            } else if( "listenerID" in json ) {
                callbackId = json.listenerID;
            }
            var callback:Function = getCallback( callbackId );
            unregisterCallback( callbackId );
            return callback;
        }

        private static function log( message:String ):void {
            if( mLogEnabled ) {
                trace( TAG, message );
            }
        }

    }
}
