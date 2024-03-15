How to use the Google Sign-in Feature -> using @IBAction func signInWithGoogle(_ sender: UIButton) method 
+ Put these 2 lines in viewDidLoad() method
    + let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    + mainDelegate.setupGoogleSignIn()
+ Copy this IBAction Function to the new ViewController
+ Come to AppDelegate, change the "segueIdentiferForSignIn" variable to the segue identifier name that you want
+ All user information is saved in AppDelegate
