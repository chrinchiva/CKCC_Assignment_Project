
import UIKit
import Firebase
import FBSDKLoginKit
var currentUsername = "no name"
var currentUserID = ""
class LoginFirebaseViewController: UIViewController, FBSDKLoginButtonDelegate{
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!

    @IBOutlet weak var loginButton: FBSDKLoginButton!
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Facebook is log out successfully...")
    }
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("Login in completed")
        
        if !result.isCancelled {
            // Pass Facebook token to Firebase auth object
            let facebookToken = FBSDKAccessToken.current().tokenString!
            let credential = FacebookAuthProvider.credential(withAccessToken: facebookToken)
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if error != nil {
                    print("Login with Firebase error: ", error!.localizedDescription)
                }else{
                    print("Login with Firebase completed")
                    
                    let uUsername = user?.displayName
                    let uEmail = user?.email
                    
                    let myApp = MyApp.shared
                    myApp.username = uUsername
                    myApp.email = uEmail
                    // recorder user sign from facebook
                    self.performSegue(withIdentifier: "segue_detail_user", sender: nil)
                    
                    
                    
                }
            })
        }
        // do anything 
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.delegate = self // set selft to the delegat button
        loginButton.readPermissions = ["email", "user_birthday", "user_hometown"]
        FBSDKProfile.enableUpdates(onAccessTokenChange: true)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    @IBAction func onClickLoginButton(_ sender: Any) {
        let Email = usernameText.text
        let Pass = passwordText.text
        if (Email != "") && (Pass != "")
        {
            Auth.auth().signIn(withEmail: Email!, password: Pass!, completion: { (user, error) in
                
                if user != nil{
                    
                    print("Sign in successfully")
                    if let user = user
                    {
                        var uUsername = user.displayName
                        let uEmail = user.email
                        
                        let myApp = MyApp.shared
                        myApp.username = uUsername
                        myApp.email = uEmail
                        
                        if uUsername == nil
                        {
                            uUsername = "no name"
                        }
                        
                        self.passwordText.text = ""
                        //currentPhonenumber = phoneNumber!
                        //currentPhoto  = photoURL
                        //currentPhonenumber  = phoneNumber!
                        //let myApp = MyApp.shared
                        //myApp.emailAddress
                       
                        
                        
                        self.performSegue(withIdentifier: "segue_detail_user", sender: nil)
                    }
                    
                    // message
                    let alertController = UIAlertController(title: "Sign in", message: "Success", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    //present(alertController, animated: true, completion: nil)
                    self.present(alertController, animated: true, completion: nil)
                    /// end message declearation
                    
                    
                }
                else{
                    if let myError = error?.localizedDescription
                    {
                        // message
                        let alertController = UIAlertController(title: "Login", message: myError, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(okAction)
                        //present(alertController, animated: true, completion: nil)
                        self.present(alertController, animated: true, completion: nil)
                        /// end message declearation
                    }
                    else
                    {
                        // message
                        let alertController = UIAlertController(title: "Log in", message: "Unknow email or password", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(okAction)
                        //present(alertController, animated: true, completion: nil)
                        self.present(alertController, animated: true, completion: nil)
                        /// end message declearation
                    }
                }
                
            })
        }
        else
        {
            let alertController = UIAlertController(title: "", message: "email or password can't leave blank!!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            //present(alertController, animated: true, completion: nil)
            self.present(alertController, animated: true, completion: nil)
            /// end message declearation
        }
        
    }
    
    @IBAction func onClickSignUpButton(_ sender: Any) {
        if (usernameText.text != "") && (passwordText.text != "")
        {
            Auth.auth().createUser(withEmail: usernameText.text!, password: passwordText.text!, completion: { (user, error) in
                if user != nil
                {
                    let alertController = UIAlertController(title: "", message: "Success", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    self.usernameText.text = ""
                    self.passwordText.text = ""
                    
                    // send email to verification
                    Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                        print("Sending...")
                    })

                }
            })
        }
        else{
            let popupDialog = UIAlertController(title: "Information", message: "Email or password cannot leave blank!!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            popupDialog.addAction(okAction)
            self.present(popupDialog, animated: true, completion: nil)
        }
    }
    
    @IBAction func onClickUploadImage(_ sender: Any) {
    
    }
    
    
    
}
