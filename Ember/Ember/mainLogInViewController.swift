//
//  mainLogInViewController.swift
//  bounceapp
//
//  Created by Anthony Wamunyu Maina on 6/23/16.
//  Copyright © 2016 Anthony Wamunyu Maina. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class mainLogInViewController: UIViewController, BWWalkthroughViewControllerDelegate {
    
    //BWWalkthroughViewControllerDelegate
    @IBOutlet weak var backSplashButton: UIButton!
    @IBOutlet weak var emailAddres: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var logInIndicator: UIActivityIndicatorView!
    var ref:FIRDatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        logInIndicator.hidesWhenStopped = true
        logInIndicator.hidden = true
        
        let image = UIImage(named: "backDown") as UIImage?
        backSplashButton.setImage(image, forState: UIControlState.Normal)
        backSplashButton.titleEdgeInsets.left = 15

        // Do any additional setup after loading the view.
    }    
    override func viewDidAppear(animated: Bool) {
        
        ref = FIRDatabase.database().reference()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logInTapped(sender: AnyObject) {
        
        logInIndicator.hidden = false
        logInIndicator.startAnimating()
        let email = emailAddres.text!
        let myPassword = password.text!
        
        FIRAuth.auth()?.signInWithEmail(email, password: myPassword, completion: {
            user,error in
            if error != nil {
                self.logInIndicator.stopAnimating()
                
                
                print(error!.localizedDescription)
                
                let alertController = UIAlertController(title: "Email address",
                    message: "Please check that you typed the email address correctly.",
                    preferredStyle: UIAlertControllerStyle.Alert
                )
                alertController.addAction(UIAlertAction(title: "Ok",
                    style: UIAlertActionStyle.Default, handler: nil)
                )
                // Display alert
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            else {
                self.logInIndicator.stopAnimating()
                if (!user!.emailVerified) {
                    // User needs to use .edu email address before continuing
                    let alertController = UIAlertController(title: "Email address Verification",
                        message: "Please check email to verify email address.",
                        preferredStyle: UIAlertControllerStyle.Alert
                    )
                    alertController.addAction(UIAlertAction(title: "Ok",
                        style: UIAlertActionStyle.Default, handler: nil)
                    )
                    // Display alert
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                else {
                    let defaults = NSUserDefaults.standardUserDefaults()
                    let hasViewedOnboarding:Bool = defaults.boolForKey("hasViewedOnboarding")
                    if (!hasViewedOnboarding) {
                        self.startOnboarding()
                        defaults.setBool(true, forKey: "hasViewedOnboarding")
                    }
                    else {
                       self.performSegueWithIdentifier("loginSegue", sender: nil)
                    }
                    
                }
            }
        })

    }
    
    func startOnboarding() {
        // Get view controllers and build the walkthrough
        let stb = UIStoryboard(name: "Walkthrough", bundle: nil)
        let walkthrough = stb.instantiateViewControllerWithIdentifier("walk") as! BWWalkthroughViewController
        let page_one = stb.instantiateViewControllerWithIdentifier("walk1")
        let page_two = stb.instantiateViewControllerWithIdentifier("walk2")
        let page_three = stb.instantiateViewControllerWithIdentifier("walk3")
        let page_four = stb.instantiateViewControllerWithIdentifier("walk4")
        let page_five = stb.instantiateViewControllerWithIdentifier("walk5")
        
        
        // Attach the pages to the master
        walkthrough.delegate = self
        walkthrough.addViewController(page_one)
        walkthrough.addViewController(page_two)
        walkthrough.addViewController(page_three)
        walkthrough.addViewController(page_four)
        walkthrough.addViewController(page_five)
        
        self.presentViewController(walkthrough, animated: true, completion: nil)
        //self.accountCreationIndicator.stopAnimating()
        
    
        
    }
    
    func walkthroughCloseButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.performSegueWithIdentifier("initialLoginSegue", sender: nil)
    }

    @IBAction func forgottenPasswordLink(sender: AnyObject) {
        
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ResetPasswordViewController") as UIViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func backSplashButtonClicked(sender: AnyObject) {
        
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}