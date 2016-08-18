package com.marpies.ane.firebase.auth {

    /**
     * Represents the Twitter authentication provider.
     */
    public class TwitterAuthProvider {

        /**
         * @private
         */
        public function TwitterAuthProvider() {
        }

        /**
         * Returns a new instance of <code>IAuthCredential</code> that wraps Google Sign-In ID and access token.
         */
        public static function getCredential( token:String, secret:String ):IAuthCredential {
            if( token === null ) throw new ArgumentError( "Parameter token cannot be null." );
            if( secret === null ) throw new ArgumentError( "Parameter secret cannot be null." );

            var credential:TwitterAuthCredential = new TwitterAuthCredential();
            credential.token = token;
            credential.secret = secret;
            return credential;
        }

    }

}
