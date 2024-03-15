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
    
    // Created by David.
    // When button is clicked, this function will start the Google Sign-in process.
    // After signning in, the user information should be saved in AppDelegate. For now, I will print the user information to console.
    // Steps to move this function to any ViewController:
        // Put these 2 lines in viewDidLoad() method
            // let mainDelegate = UIApplication.shared.delegate as! AppDelegate
            // mainDelegate.setupGoogleSignIn()
        // Copy this IBAction Function to the new ViewController
        // Come to AppDelegate, change the "segueIdentiferForSignIn" variable to the segue identifier name that you want
        // All user information is saved in AppDelegate
    @IBAction func signInWithGoogle(_ sender: UIButton) {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [self] authentication, error in
            
            if error != nil {
                print("Google Sign-In error")
                return
            }
            
            let mainDelegate = UIApplication.shared.delegate as! AppDelegate

            guard let user = authentication?.user,
                  let idToken = user.idToken?.tokenString else { return }
            
            print(user.profile?.name as Any)
            mainDelegate.username = user.profile!.name
            print(user.profile?.givenName as Any)
            mainDelegate.givenName = user.profile!.givenName!
            print(user.profile?.email as Any)
            if let profileURL = user.profile?.imageURL(withDimension: 100) {
                print("Profile Image URL: \(profileURL)")
                mainDelegate.imgUrl = profileURL
            } else {
                print("Profile Image URL not found.")
            }
            
            performSegue(withIdentifier: mainDelegate.segueIdentiferForSignIn, sender: nil)
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { authResult, error in}
        }
        
    }


}

