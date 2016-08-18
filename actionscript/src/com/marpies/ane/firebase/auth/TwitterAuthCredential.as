package com.marpies.ane.firebase.auth {

    /**
     * @private
     */
    public class TwitterAuthCredential implements IAuthCredential {

        /**
         * @private
         */
        internal var token:String;
        /**
         * @private
         */
        internal var secret:String;

        /**
         * @private
         */
        public function TwitterAuthCredential() {
        }

        /**
         * Returns the unique string identifier for the provider type with which the credential is associated.
         *
         * @see com.marpies.ane.firebase.auth.FirebaseAuthProviders
         */
        public function get providerId():String {
            return FirebaseAuthProviders.TWITTER;
        }

    }

}
