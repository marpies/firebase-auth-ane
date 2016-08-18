package com.marpies.ane.firebase.auth {

    /**
     * Represents the email and password authentication mechanism.
     */
    public class EmailAuthProvider {

        /**
         * @private
         */
        public function EmailAuthProvider() {
        }

        /**
         * Returns a new instance of <code>IAuthCredential</code> that wraps a given email and password.
         */
        public static function getCredential( email:String, password:String ):IAuthCredential {
            if( email === null ) throw new ArgumentError( "Parameter email cannot be null." );
            if( password === null ) throw new ArgumentError( "Parameter password cannot be null." );

            var credential:EmailAuthCredential = new EmailAuthCredential();
            credential.email = email;
            credential.password = password;
            return credential;
        }

    }

}
