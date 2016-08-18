package com.marpies.ane.firebase.auth {

    /**
     * @private
     */
    public class EmailAuthCredential implements IAuthCredential {

        /**
         * @private
         */
        internal var email:String;
        /**
         * @private
         */
        internal var password:String;

        /**
         * @private
         */
        public function EmailAuthCredential() {
        }

        /**
         * Returns the unique string identifier for the provider type with which the credential is associated.
         *
         * @see com.marpies.ane.firebase.auth.FirebaseAuthProviders
         */
        public function get providerId():String {
            return FirebaseAuthProviders.EMAIL;
        }

    }

}
