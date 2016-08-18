package com.marpies.ane.firebase.auth {

    /**
     * Interface for a credential that the Firebase Authentication server can use to authenticate a user.
     */
    public interface IAuthCredential {

        /**
         * Returns the unique string identifier for the provider type with which the credential is associated.
         *
         * @see com.marpies.ane.firebase.auth.FirebaseAuthProviders
         */
        function get providerId():String;

    }

}
