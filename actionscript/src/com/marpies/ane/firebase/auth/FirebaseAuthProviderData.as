package com.marpies.ane.firebase.auth {

    /**
     * Represents a collection of standard profile information for a user.
     * Can be used to expose profile information returned by an identity provider,
     * such as Google Sign-In or Facebook Login.
     */
    public class FirebaseAuthProviderData {

        private var mProviderId:String;
        private var mUserId:String;
        private var mUserDisplayName:String;
        private var mUserEmail:String;
        private var mUserPhotoURL:String;

        /**
         * @private
         */
        public function FirebaseAuthProviderData() {
        }

        /**
         * @private
         */
        internal static function fromJSON( json:Object ):FirebaseAuthProviderData {
            if( json == null ) return null;
            if( json is String ) {
                json = JSON.parse( json as String );
            }
            var data:FirebaseAuthProviderData = new FirebaseAuthProviderData();
            data.mProviderId = json.providerId;
            data.mUserId = json.uid;
            data.mUserDisplayName = json.displayName;
            data.mUserEmail = json.email;
            data.mUserPhotoURL = json.photoURL;
            return data;
        }

        /**
         *
         *
         * Getters / Setters
         *
         *
         */

        /**
         * Returns the unique identifier of the provider type that this instance corresponds to,
         * e.g. <code>facebook.com</code> or <code>google.com</code>.
         *
         * @see com.marpies.ane.firebase.auth.FirebaseAuthProviders
         */
        public function get providerId():String {
            return mProviderId;
        }

        /**
         * Returns a user identifier as specified by the authentication provider.
         */
        public function get userId():String {
            return mUserId;
        }

        /**
         * Returns the user's display name, if available.
         */
        public function get userDisplayName():String {
            return mUserDisplayName;
        }

        /**
         * Returns the email address corresponding to the user's account in the specified provider, if available.
         */
        public function get userEmail():String {
            return mUserEmail;
        }

        /**
         * Returns a URL to the user's profile picture, if available.
         */
        public function get userPhotoURL():String {
            return mUserPhotoURL;
        }

    }

}
