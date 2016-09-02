package com.marpies.ane.firebase.auth {

    /**
     * Builder for user profile update request.
     */
    public class FirebaseUserProfileUpdateRequest {

        private var mDisplayName:String;
        private var mPhotoURL:String;

        /**
         * @private
         */
        public function FirebaseUserProfileUpdateRequest():void {

        }

        /**
         * Set's new user display name.
         */
        public function setDisplayName( value:String ):FirebaseUserProfileUpdateRequest {
            if( value === null ) throw new ArgumentError( "Display name cannot be set to null." );
            mDisplayName = value;
            return this;
        }

        /**
         * Set's new user photo URL.
         */
        public function setPhotoURL( value:String ):FirebaseUserProfileUpdateRequest {
            if( value === null ) throw new ArgumentError( "Photo URL cannot be set to null." );
            mPhotoURL = value;
            return this;
        }

        /**
         * Sends the request.
         *
         * @param callback Function with the following signature:
         * <listing version="3.0">
         * function callback( errorMessage:String ):void {
         *      if( errorMessage == null ) {
         *          // profile has been updated
         *      } else {
         *          // there was an error updating the profile
         *      }
         * };
         * </listing>
         */
        public function send( callback:Function ):void {
            if( !FirebaseAuth.isSupported ) return;
            FirebaseAuth.validateExtensionContext();

            if( callback === null ) throw new ArgumentError( "Parameter callback cannot be null." );
            if( mDisplayName === null && mPhotoURL === null )
                throw new ArgumentError( "At least display name or photo URL must be set." );
            FirebaseAuth.changeUserProfile( mDisplayName, mPhotoURL, callback );
        }

    }

}
