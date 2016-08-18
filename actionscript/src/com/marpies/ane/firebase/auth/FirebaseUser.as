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

    /**
     * Represents a user's profile information in your Firebase project's user database.
     */
    public class FirebaseUser {

        private var mId:String;
        private var mIsAnonymous:Boolean;
        private var mDisplayName:String;
        private var mProviderData:Vector.<FirebaseAuthProviderData>;

        /**
         * @private
         */
        public function FirebaseUser() {
        }

        /**
         * @private
         */
        internal static function fromJSON( json:Object ):FirebaseUser {
            if( json === null ) return null;
            if( json is String ) {
                json = JSON.parse( json as String );
            }
            var user:FirebaseUser = new FirebaseUser();
            user.mId = json.uid;
            user.mIsAnonymous = json.isAnonymous;
            user.mDisplayName = json.displayName;
            var providerDataArray:Array = null;
            if( "providerData" in json ) {
                if( json.providerData is String ) {
                    providerDataArray = JSON.parse( json.providerData ) as Array;
                } else {
                    providerDataArray = json.providerData;
                }
                if( providerDataArray !== null ) {
                    var providerDataResult:Vector.<FirebaseAuthProviderData> = new <FirebaseAuthProviderData>[];
                    var length:int = providerDataArray.length;
                    for( var i:int = 0; i < length; ++i ) {
                        var providerData:FirebaseAuthProviderData = FirebaseAuthProviderData.fromJSON( providerDataArray[i] );
                        if( providerData !== null ) {
                            providerDataResult[providerDataResult.length] = providerData;
                        }
                    }
                    user.mProviderData = providerDataResult;
                }
            }
            return user;
        }

        /**
         *
         *
         * Public API
         *
         *
         */

        /**
         * Attaches the given <code>IAuthCredential</code> to the user.
         * This allows the user to sign in to this account in the future with credentials for such provider.
         *
         * @param credential The credential to link the current user with.
         * @param callback Function with the following signature:
         * <listing version="3.0">
         * function callback( user:FirebaseUser, errorMessage:String ):void {
         *      if( errorMessage == null ) {
         *          // user has been linked with the credential
         *      } else {
         *          // there was an error linking the user with the credential
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
        public function linkWithCredential( credential:IAuthCredential, callback:Function ):void {
            if( !FirebaseAuth.isSupported ) return;
            FirebaseAuth.validateExtensionContext();

            if( callback === null ) throw new ArgumentError( "Parameter callback cannot be null." );
            if( credential === null ) throw new ArgumentError( "Parameter credential cannot be null." );

            switch( credential.providerId ) {
                case FirebaseAuthProviders.EMAIL:
                    FirebaseAuth.linkWithEmailCredential( credential as EmailAuthCredential, callback );
                    return;
                case FirebaseAuthProviders.FACEBOOK:
                    FirebaseAuth.linkWithFacebookCredential( credential as FacebookAuthCredential, callback );
                    return;
                case FirebaseAuthProviders.GOOGLE:
                    FirebaseAuth.linkWithGoogleCredential( credential as GoogleAuthCredential, callback );
                    return;
                case FirebaseAuthProviders.TWITTER:
                    FirebaseAuth.linkWithTwitterCredential( credential as TwitterAuthCredential, callback );
                    return;
                case FirebaseAuthProviders.GITHUB:
                    FirebaseAuth.linkWithGithubCredential( credential as GithubAuthCredential, callback );
                    return;
                default:
                    throw new ArgumentError( "Encountered credential for unknown provider: " + credential.providerId );
            }
        }

        /**
         * Detaches credentials from a given provider type from this user.
         * This prevents the user from signing in to this account in the future with credentials from such provider.
         *
         * @param providerId Unique identifier of the type of provider to be unlinked.
         * @param callback Function with the following signature:
         * <listing version="3.0">
         * function callback( user:FirebaseUser, errorMessage:String ):void {
         *      if( errorMessage == null ) {
         *          // user has been linked with the credential
         *      } else {
         *          // there was an error linking the user with the credential
         *      }
         * };
         * </listing>
         *
         * @see com.marpies.ane.firebase.auth.FirebaseAuthProviders
         */
        public function unlinkFromProvider( providerId:String, callback:Function ):void {
            if( !FirebaseAuth.isSupported ) return;
            FirebaseAuth.validateExtensionContext();

            if( callback === null ) throw new ArgumentError( "Parameter callback cannot be null." );
            if( providerId === null ) throw new ArgumentError( "Parameter providerId cannot be null." );
            if( !FirebaseAuthProviders.isSupported( providerId ) ) throw new ArgumentError( "Encountered unsupported provider identifier '" + providerId + "'." );

            FirebaseAuth.unlinkFromProvider( providerId, callback );
        }

        /**
         *
         *
         * Getters / Setters
         *
         *
         */

        /**
         * Returns a string used to uniquely identify your user in your Firebase project's user database.
         */
        public function get id():String {
            return mId;
        }

        /**
         * Returns <code>true</code> if the user account was created with <code>FirebaseAuth.signInAnonymously()</code>
         * and has not been linked with a provider.
         */
        public function get isAnonymous():Boolean {
            return mIsAnonymous;
        }

        /**
         * Returns the main display name of this user from the Firebase project's user database.
         */
        public function get displayName():String {
            return mDisplayName;
        }

        /**
         * Returns a list of <code>FirebaseAuthProviderData</code> objects that represents the linked identities
         * of the user using different authentication providers that may be linked to their account.
         *
         * @see com.marpies.ane.firebase.auth.FirebaseAuthProviderData
         */
        public function get providerData():Vector.<FirebaseAuthProviderData> {
            return mProviderData;
        }

    }

}
