/*
 * Copyright 2016 Marcel Piestansky (http://marpies.com)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.marpies.ane.firebase.auth.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;
import com.google.firebase.auth.FirebaseAuth;
import com.marpies.ane.firebase.auth.utils.AIR;

public class SignOutFunction extends BaseFunction {

	@Override
	public FREObject call( FREContext context, FREObject[] args ) {
		super.call( context, args );

		try {
			AIR.log( "FirebaseAuth::signOut" );
			FirebaseAuth.getInstance().signOut();
			return FREObject.newObject( true );
		} catch( FREWrongThreadException e ) {
			e.printStackTrace();
		}

		return null;
	}

}
