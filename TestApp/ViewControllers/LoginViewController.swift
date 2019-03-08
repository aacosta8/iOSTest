//
//  LoginViewController.swift
//  TestApp
//
//  Created by Leidy Carolina Zuluaga Bastidas on 7/03/19.
//  Copyright © 2019 intergrupo. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onSigninClick(_ sender: Any) {
        let userEmail = emailTextField.text;
        let userPassword = passwordTextField.text;

        if (userEmail?.isEmpty == true || userPassword?.isEmpty == true) {
            displayAlertMessage(userMessage: "All fields are required");
            return
        }
        else if !isValidEmail(testStr: userEmail) {
            displayAlertMessage(userMessage: "Invalid email");
            return
        }
        else {
            searchForUserAlamo(email: userEmail, password: userPassword)
        }
    }
    
    
    
    func isValidEmail(testStr: String?) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func searchForUserAlamo(email: String?, password: String?){
        let defaults = UserDefaults.standard

        let _url: URL = URL(string: "http://directotesting.igapps.co/application/login")!;
        let parameters: Parameters = ["email": email ?? "", "password": password ?? ""]
        Alamofire.request(_url, parameters: parameters, encoding: URLEncoding.default)
            .validate()
            .responseJSON { (response) in
                if response.result.isSuccess  {
                    do {
                        let response = Mapper<LoginResponse>().map(JSONObject: response.result.value)
                        print(UserDefaults.standard.string(forKey: "authToken") ?? "")
                        if response?.success ?? false{
                            defaults.set(response?.authToken, forKey: "authToken")
                            defaults.set(response?.success, forKey: "success")
                        }
                    } catch {
                        print("Error: ", error)
                    }
                } else {
                    self.displayAlertMessage(userMessage: "User not authorized");
                }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LoginViewController {
    func displayAlertMessage(userMessage: String){
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertController.Style.alert);
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil);
        
        myAlert.addAction(okAction);
        
        self.present(myAlert, animated: true, completion: nil);
    }
}
