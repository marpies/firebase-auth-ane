package com.marpies.ane.firebase.auth {

    /**
     * Represents the Facebook Login authentication provider.
     */
    public class FacebookAuthProvider {

        /**
         * @private
         */
        public function FacebookAuthProvider() {
        }

        /**
         * Returns a new instance of <code>IAuthCredential</code> that wraps a Facebook Login token.
         *
         * @param accessToken Valid Facebook Login access token.
         */
        public static function getCredential( accessToken:String ):IAuthCredential {
            if( accessToken === null ) throw new ArgumentError( "Parameter accessToken cannot be null." );

            var credential:FacebookAuthCredential = new FacebookAuthCredential();
            credential.accessToken = accessToken;
            return credential;
        }

    }

}
