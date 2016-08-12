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
