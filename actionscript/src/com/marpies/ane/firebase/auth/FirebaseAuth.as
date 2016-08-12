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

    public class FirebaseAuth {

        private static const TAG:String = "[FirebaseAuth]";
        private static const EXTENSION_ID:String = "com.marpies.ane.firebase.auth";
        private static const iOS:Boolean = Capabilities.manufacturer.indexOf( "iOS" ) > -1;
        private static const ANDROID:Boolean = Capabilities.manufacturer.indexOf( "Android" ) > -1;

        CONFIG::ane {
            private static var mContext:ExtensionContext;
        }

        /* Event codes */

        /* Callbacks */
        private static var mCallbackMap:Dictionary;
        private static var mCallbackIdCounter:int;

        /* Misc */
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
        private static function createUser( email:String, password:String, callback:Function ):void {
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
         * Attempts to sign the user in using email and password.
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
         */
        public static function signInWithEmailAndPassword( email:String, password:String, callback:Function ):void {
            if( !isSupported ) return;
            validateExtensionContext();

            if( email === null ) throw new ArgumentError( "Parameter email cannot be null." );
            if( password === null ) throw new ArgumentError( "Parameter password cannot be null." );
            if( callback === null ) throw new ArgumentError( "Parameter callback cannot be null." );

            CONFIG::ane {
                mContext.call( "signInWithEmailAndPassword", email, password, registerCallback( callback ) );
            }
        }

        /**
         * Attempts to sign the user in with Google's ID token and access token.
         *
         * @param idToken User's ID token obtained from Google.
         * @param accessToken User's access token obtained from Google.
         * @param callback Function with the following signature:
         * <listing version="3.0">
         * function callback( user:FirebaseUser, errorMessage:String ):void {
         *      if( errorMessage == null ) {
         *          // user has been signed in
         *      } else {
         *          // there was an error singing the user in
         *      }
         * };
         */
        public static function signInWithGoogleAccount( idToken:String, accessToken:String, callback:Function ):void {
            if( !isSupported ) return;
            validateExtensionContext();

            if( idToken === null ) throw new ArgumentError( "Parameter idToken cannot be null." );
            if( accessToken === null ) throw new ArgumentError( "Parameter accessToken cannot be null." );
            if( callback === null ) throw new ArgumentError( "Parameter callback cannot be null." );

            CONFIG::ane {
                mContext.call( "signInWithGoogleAccount", idToken, accessToken, registerCallback( callback ) );
            }
        }

        /**
         * Attempts to sign the user in with Facebook's access token.
         *
         * @param accessToken User's access token obtained from Facebook.
         * @param callback Function with the following signature:
         * <listing version="3.0">
         * function callback( user:FirebaseUser, errorMessage:String ):void {
         *      if( errorMessage == null ) {
         *          // user has been signed in
         *      } else {
         *          // there was an error singing the user in
         *      }
         * };
         */
        public static function signInWithFacebookAccount( accessToken:String, callback:Function ):void {
            if( !isSupported ) return;
            validateExtensionContext();

            if( accessToken === null ) throw new ArgumentError( "Parameter accessToken cannot be null." );
            if( callback === null ) throw new ArgumentError( "Parameter callback cannot be null." );

            CONFIG::ane {
                mContext.call( "signInWithFacebookAccount", accessToken, registerCallback( callback ) );
            }
        }

        /**
         * Disposes native extension context.
         */
        public static function dispose():void {
            if( !isSupported ) return;
            validateExtensionContext();

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

        /**
         * Extension version.
         */
        public static function get version():String {
            return "0.1.0";
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
         * Private API
         *
         *
         */

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

        private static function validateExtensionContext():void {
            CONFIG::ane {
                if( !mContext ) throw new Error( "FirebaseAuth extension was not initialized. Call init() first." );
            }
        }

        private static function onStatus( event:StatusEvent ):void {

        }

        private static function log( message:String ):void {
            if( mLogEnabled ) {
                trace( TAG, message );
            }
        }

    }
}
