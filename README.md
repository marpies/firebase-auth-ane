# Firebase Authentication | Extension for Adobe AIR (iOS & Android)

[Firebase Authentication](https://firebase.google.com/docs/auth/) provides backend services and easy-to-use APIs to authenticate users to your app. It supports authentication using passwords, popular federated identity providers like Google, Facebook and Twitter, and more.

## Features

* Authenticate user:
  * Anonymously
  * Using email &amp; password
  * Using Facebook access token
  * Using Google Identity id and access tokens
  * Using GitHub access token
  * Using Twitter access token and secret
* Link with/unlink from providers
* Retrieve and update user information
* Sign out

## Firebase Auth SDK versions

* iOS `v3.0.4`
* Android `v9.4.0`

## Getting started

### Prerequisites

FirebaseAuth extension requires [FirebaseConfig](https://github.com/marpies/firebase-config-ane) and [FirebaseCore](https://github.com/marpies/firebase-core-ane) extensions. See the instructions for each extension and add them to your project.

### Additions to AIR descriptor

After you deal with the prerequisites, add the extension's ID to the `extensions` element.

```xml
<extensions>
    <extensionID>com.marpies.ane.firebase.auth</extensionID>
</extensions>
```

If you are targeting Android, add the following extensions from [this repository](https://github.com/marpies/android-dependency-anes) as well (unless you know these libraries are included by some other extensions):

```xml
<extensions>
    <extensionID>com.marpies.ane.androidsupport</extensionID>
    <extensionID>com.marpies.ane.googleplayservices.base</extensionID>
    <extensionID>com.marpies.ane.googleplayservices.basement</extensionID>
    <extensionID>com.marpies.ane.googleplayservices.tasks</extensionID>
</extensions>
```

For Android support, modify `manifestAdditions` element so that it contains the following activity:

```xml
<android>
    <manifestAdditions>
        <![CDATA[
        <manifest android:installLocation="auto">

            <application>

                <!-- GooglePlayServices Base -->
                <activity android:name="com.google.android.gms.common.api.GoogleApiActivity"
                        android:theme="@android:style/Theme.Translucent.NoTitleBar"
                        android:exported="false"/>

            </application>

        </manifest>
        ]]>
    </manifestAdditions>
</android>
```

Finally, add the [FirebaseAuth ANE](bin/com.marpies.ane.firebase.auth.ane) or [SWC](bin/com.marpies.ane.firebase.auth.swc) package from the [bin directory](bin/) to your project so that your IDE can work with it. The additional Android library ANEs are only necessary during packaging.

## API overview

### Initialization

Initialize the extension by calling the `init` method inside your document class' constructor, or as early as possible after your app's launch and **after** `FirebaseCore.configure()` is called:

```as3
if( FirebaseAuth.init( onFirebaseAuthInitialState ) ) {
    // successfully initialized
}
```

The first parameter is `Function` that will be called when the underlying SDK is initialized and information about currently logged in user becomes available:

```as3
private function onFirebaseAuthInitialState( user:FirebaseUser ):void {
    if( user == null ) {
    	// no user is currently logged in
	} else {
		// user is already logged in
		trace( user.id );
	}
}
```

You may also pass in second parameter of type `Boolean` to enable or disable extension logs.

### Create new user

To create new user with email and password, use the `FirebaseAuth.createUser` method:

```as3
FirebaseAuth.createUser( "**email**", "**password**", onFirebaseAuthCreateUser );

private function onFirebaseAuthCreateUser( user:FirebaseUser, errorMessage:String ):void {
    if( errorMessage == null ) {
        // user has been created
        trace( user.id );
    } else {
        // error creating the user
    }
}
```

### Signing in

To sign a user in, use any of the `FirebaseAuth.signIn*` methods:

```as3
/* Sign in anonymously */
FirebaseAuth.signInAnonymously( onFirebaseAuthSignIn );

/* Sign in using Facebook access token */
var credential:IAuthCredential = FacebookAuthProvider.getCredential( "**access_token**" );
FirebaseAuth.signInWithCredential( credential, onFirebaseAuthSignIn );

/* Sign in using Twitter access token and secret */
var credential:IAuthCredential = TwitterAuthProvider.getCredential( "**access_token**", "**secret**" );
FirebaseAuth.signInWithCredential( credential, onFirebaseAuthSignIn );

/* Sign in using Google access id token and access token */
var credential:IAuthCredential = GoogleAuthProvider.getCredential( "**id_token**", "**access_token**" );
FirebaseAuth.signInWithCredential( credential, onFirebaseAuthSignIn );

/* Sign in using Github access token */
var credential:IAuthCredential = GithubAuthProvider.getCredential( "**access_token**" );
FirebaseAuth.signInWithCredential( credential, onFirebaseAuthSignIn );

/* Sign in using email and password */
var credential:IAuthCredential = EmailAuthProvider.getCredential( "**email**", "**password**" );
FirebaseAuth.signInWithCredential( credential, onFirebaseAuthSignIn );
```

Each method accepts `Function` parameter as a callback:
```as3
private function onFirebaseAuthSignIn( user:FirebaseUser, errorMessage:String ):void {
    if( errorMessage == null ) {
        // user has been signed in
        trace( user.id );
    } else {
        // error signing the user in
    }
}
```

### Link/unlink providers

Once the user is signed in, his profile can be retrieved using `FirebaseAuth.currentUser` and his account can be linked with another provider. Simply obtain credential for the provider (as seen above) and call `FirebaseAuth.currentUser.linkWithCredential`:

```as3
FirebaseAuth.currentUser.linkWithCredential( credential, onFirebaseAuthUserLinked );

private function onFirebaseAuthUserLinked( user:FirebaseUser, errorMessage:String ):void {
    if( errorMessage == null ) {
        // user has been linked with the credential
        // process user.providerData to read provider-specific information
    } else {
        // there was an error linking the user with the credential
    }
}
```

To unlink from provider, just pass in one of the provider identifiers defined in [FirebaseAuthProviders class](actionscript/src/com/marpies/ane/firebase/auth/FirebaseAuthProviders.as), for example:

```as3
FirebaseAuth.currentUser.unlinkFromProvider( FirebaseAuthProviders.FACEBOOK, onFirebaseAuthUserUnlinked );

private function onFirebaseAuthUserUnlinked( user:FirebaseUser, errorMessage:String ):void {
    if( errorMessage == null ) {
        // user has been unlinked from the provider
    } else {
        // there was an error unlinking the user from the provider
    }
}
```

### Misc

See the documentation for [FirebaseUser](actionscript/src/com/marpies/ane/firebase/auth/FirebaseUser.as) object to learn about other operations on the user, such as [updating email](actionscript/src/com/marpies/ane/firebase/auth/FirebaseUser.as#L161-L192), [password](actionscript/src/com/marpies/ane/firebase/auth/FirebaseUser.as#L194-L223) or reading [provider-specific information](actionscript/src/com/marpies/ane/firebase/auth/FirebaseUser.as#L347-L355).

## Requirements

* iOS 7+
* Android 4+
* Adobe AIR 20+

## Documentation
Generated ActionScript documentation is available in the [docs](docs/) directory, or can be generated by running `ant asdoc` from the [build](build/) directory.

## Build ANE
ANT build scripts are available in the [build](build/) directory. Edit [build.properties](build/build.properties) to correspond with your local setup.

## Author
The ANE has been written by [Marcel Piestansky](https://twitter.com/marpies) and is distributed under [Apache License, version 2.0](http://www.apache.org/licenses/LICENSE-2.0.html).

## Changelog

#### September 2, 2016 (v1.0.0)

* Public release
