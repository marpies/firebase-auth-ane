package com.marpies.ane.firebase.auth {

    /**
     * @private
     */
    public class GithubAuthCredential implements IAuthCredential {

        /**
         * @private
         */
        internal var accessToken:String;

        /**
         * @private
         */
        public function GithubAuthCredential() {
        }

        /**
         * Returns the unique string identifier for the provider type with which the credential is associated.
         *
         * @see com.marpies.ane.firebase.auth.FirebaseAuthProviders
         */
        public function get providerId():String {
            return FirebaseAuthProviders.GITHUB;
        }

    }

}
