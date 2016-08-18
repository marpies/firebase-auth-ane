package com.marpies.ane.firebase.auth {

    /**
     * Enum of auth provider identifiers.
     */
    public class FirebaseAuthProviders {

        /**
         * Auth provider ID for Firebase email/password.
         */
        public static const EMAIL:String = "password";
        /**
         * Auth provider ID for Google.
         */
        public static const GOOGLE:String = "google.com";
        /**
         * Auth provider ID for Facebook.
         */
        public static const FACEBOOK:String = "facebook.com";
        /**
         * Auth provider ID for Twitter.
         */
        public static const TWITTER:String = "twitter.com";
        /**
         * Auth provider ID for Github.
         */
        public static const GITHUB:String = "github.com";

        /**
         * @private
         *
         * Returns <code>true</code> if the given provider identifier belongs to one of the supported providers,
         * <code>false</code> otherwise.
         */
        internal static function isSupported( providerId:String ):Boolean {
            switch( providerId ) {
                case EMAIL:
                case GOOGLE:
                case FACEBOOK:
                case TWITTER:
                case GITHUB:
                    return true;
                default:
                    return false;
            }
        }

    }

}
