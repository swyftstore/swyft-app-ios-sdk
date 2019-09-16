//
//  InitSdkRouter.swift
//  SwyftSdk
//
//  Created by Rigoberto Saenz Imbacuan on 9/12/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

internal class InitSdkRouter {
    
    // MARK: Singleton
    static let shared = InitSdkRouter()
    private init() {}
    
    // MARK: Data
    let appName = "com_swyft_SwyftSdk"
    let googleFile = "Swyft-GoogleService-Info"
    
    // MARK: Actions
    func route() {
        
        guard let filePath = Bundle.main.path(forResource: googleFile, ofType: "plist") else {
            report(.initSdkNoSwyftFile)
            return
        }
        
        guard let firebaseOptions = FirebaseOptions(contentsOfFile: filePath) else {
            report(.initSdkNoFirebaseOptions)
            return
        }
        
        FirebaseApp.configure(name: appName, options: firebaseOptions)
        
        let firebaseApp = FirebaseApp.app(name: appName)
        route(firebaseApp)
    }
    
    func route(_ firebaseApp: FirebaseApp?) {
        
        DispatchQueue.global(qos: .background).async {
            self.auth(firebaseApp)
        }
    }
}

// MARK: Internals
private extension InitSdkRouter {
    
    private func auth(_ firebaseApp: FirebaseApp?) {
        
        Configure.setup(session: SwyftSession(), firebaseApp: firebaseApp)
        
        SdkAuthInteractor.auth(success: { response in
            
            Configure.current.session?.sdkAuthToken = response.payload.authToken
            Configure.current.session?.merchantNames = response.payload.merchantNames
            Configure.current.session?.categories = response.payload.categories
            
            if let firebaseApp = firebaseApp {
                Configure.current.db = Firestore.firestore(app: firebaseApp)
                
                if let settings = Configure.current.db?.settings {
                    settings.areTimestampsInSnapshotsEnabled = true
                    Configure.current.db!.settings = settings
                }
                
                self.addAuthentication(response.payload.authToken, firebaseApp)
            }
            
        }) { error in
            report(.initSdkAuthFailure)
        }
    }
    
    private func addAuthentication(_ authToken: String, _ firebaseApp: FirebaseApp) {
        
        Auth.auth(app: firebaseApp).signIn(withCustomToken: authToken) { result, error in
            
            if let _ = error {
                Configure.current.session?.sdkFirebaseUser = nil
                report(.initSdkFirebaseSignInFailure)
                return
            }
            
            guard let result = result else {
                Configure.current.session?.sdkFirebaseUser = nil
                report(.initSdkNoFirebaseSignIn)
                return
            }
            
            let user = result.user
            Configure.current.session?.sdkFirebaseUser = user
        }
    }
}
