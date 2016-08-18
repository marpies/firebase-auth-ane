package com.marpies.ane.firebase.auth {

    /**
     * Represents the Github authentication provider.
     */
    public class GithubAuthProvider {

        /**
         * @private
         */
        public function GithubAuthProvider() {
        }

        /**
         * Returns a new instance of <code>IAuthCredential</code> that wraps a Github OAuth token.
         *
         * @param accessToken Valid Github OAuth access token.
         */
        public static function getCredential( accessToken:String ):IAuthCredential {
            if( accessToken === null ) throw new ArgumentError( "Parameter accessToken cannot be null." );

            var credential:GithubAuthCredential = new GithubAuthCredential();
            credential.accessToken = accessToken;
            return credential;
        }

    }

}
