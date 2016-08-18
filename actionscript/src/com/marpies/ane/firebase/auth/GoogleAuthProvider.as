package com.marpies.ane.firebase.auth {

    /**
     * Represents the Google Sign-In authentication provider.
     */
    public class GoogleAuthProvider {

        /**
         * @private
         */
        public function GoogleAuthProvider() {
        }

        /**
         * Returns a new instance of <code>IAuthCredential</code> that wraps Google Sign-In ID and access token.
         */
        public static function getCredential( idToken:String, accessToken:String ):IAuthCredential {
            if( idToken === null ) throw new ArgumentError( "Parameter idToken cannot be null." );
            if( accessToken === null ) throw new ArgumentError( "Parameter accessToken cannot be null." );

            var credential:GoogleAuthCredential = new GoogleAuthCredential();
            credential.idToken = idToken;
            credential.accessToken = accessToken;
            return credential;
        }

    }

}
