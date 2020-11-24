//
//  SparkAuth.swift
//  FirebaseDB
//
//  Created by Alex Nagy on 24.11.2020.
//

import Foundation
import SparkUI
import FirebaseAuth

enum SparkAuthState {
    case undefined, signedOut, signedIn
}

struct SparkAuth {
    
    // MARK: - Properties
    
    static var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    
    // MARK: - Auth State Listener
    
    static func configureFirebaseStateDidChange(completion: @escaping (Result<Bool, Error>) -> () = {_ in }) {
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            guard let user = user else {
                print("User is signed out")
                SparkBuckets.currentUserAuthState.value = .signedOut
                completion(.success(true))
                return
            }
            print("Successfully authenticated user with uid: \(user.uid)")
            
            self.handleAuthenticated(user) { (result) in
                switch result {
                case .success(let finished):
                    if finished {
                        SparkBuckets.currentUserAuthState.value = .signedIn
                    } else {
                        Alert.showErrorSomethingWentWrong()
                    }
                case .failure(let err):
                    Alert.showError(message: err.localizedDescription)
                }
            }
            
        })
    }
    
    static func removeFirebaseAuthListener() {
        guard let handle = authStateDidChangeListenerHandle else { return }
        Auth.auth().removeStateDidChangeListener(handle)
    }
    
    static func signIn(providerID: String, idTokenString: String, nonce: String, completion: @escaping (Result<AuthDataResult, Error>) -> ()) {
        // Initialize a Firebase credential.
        let credential = OAuthProvider.credential(withProviderID: providerID,
                                                  idToken: idTokenString,
                                                  rawNonce: nonce)
        // Sign in with Firebase.
        Auth.auth().signIn(with: credential) { (authDataResult, err) in
            if let err = err {
                // Error. If error.code == .MissingOrInvalidNonce, make sure
                // you're sending the SHA256-hashed nonce as a hex string with
                // your request to Apple.
                print(err.localizedDescription)
                completion(.failure(err))
                return
            }
            // User is signed in to Firebase with Apple.
            guard let authDataResult = authDataResult else {
                completion(.failure(SignInWithAppleAuthError.noAuthDataResult))
                return
            }
            completion(.success(authDataResult))
        }
    }
    
    static func signOut(completion: @escaping (Result<Bool, Error>) -> ()) {
        let auth = Auth.auth()
        do {
            try auth.signOut()
            resetApp()
            completion(.success(true))
        } catch let err {
            completion(.failure(err))
        }
    }
    
    static func resetApp() {
        SparkBuckets.currentUserProfile.value = Profile()
    }
    
    static func handleAuthenticated(_ user: User, completion: @escaping (Result<Bool, Error>) -> ()) {
        SparkFirestore.retreiveProfile(uid: user.uid) { (result) in
            switch result {
            case .success(let profile):
                print("Successfully retreived: \(profile.dictionary())")
                SparkBuckets.currentUserProfile.value = profile
                completion(.success(true))
                
            case .failure(let err):
                print("Firestore err: \(err)")
                // if user currentUserProfile does not exist in the database we should upload it now
                if err._code == SparkFirestoreError.noQuerySnapshot.code || err._code == SparkFirestoreError.documentDoesNotExist.code {
                    print("No document found with uid: \(user.uid)")
                    print("Started to create: \(SparkBuckets.currentUserProfile.value.dictionary())")
                    
                    SparkFirestore.createProfile(SparkBuckets.currentUserProfile.value) { (result) in
                        completion(result)
                    }
                }
            }
        }
    }
}
