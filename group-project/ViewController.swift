import UIKit

// Created by David
// These imports are used for Google Sign-in
import GoogleSignIn
import FirebaseCore
import FirebaseAuth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Created by David
        // Access to AppDelegate
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Created by David
        // Set up GoogleSignIn in the first load
        mainDelegate.setupGoogleSignIn()
    }
    
    // Created by David
    // When button is clicked, this function will start the Google Sign-in process
    // After signning in, the user information should be saved in AppDelegate. For now, I will print the user information to console.
    // I will move this function to the AppDelegate soon
    @IBAction func signInWithGoogle(_ sender: UIButton) {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { authentication, error in
            
            guard error == nil else {
                return
            }

            guard let user = authentication?.user,
                  let idToken = user.idToken?.tokenString else { return }
            
            print(user.profile?.name as Any)
            print(user.profile?.givenName as Any)
            print(user.profile?.email as Any)
            if let profileURL = user.profile?.imageURL(withDimension: 100) {
                print("Profile Image URL: \(profileURL)")
            } else {
                print("Profile Image URL not found.")
            }


            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { authResult, error in
                
            }
            
        }
        
    }


}

