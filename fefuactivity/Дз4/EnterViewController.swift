//
//  EnterViewController.swift
//  fefuactivity
//
//  Created by wsr5 on 19.12.2021.
//

import UIKit

class EnterViewController: UIViewController {
    let encoder = JSONEncoder()
    @IBAction func Button(_ sender: Any) {
        let login = LoginText.text ?? ""
        let password = PasswordText.text ?? ""
        let body = UserLoginBody(login: login, password: password)
                
        do {
            let reqBody = try JSONEncoder().encode(body)
            let queue = DispatchQueue.global(qos: .utility)
            AuthService.login(reqBody) { user in
                queue.async {
                    UserDefaults.standard.set(user.token, forKey: "token")
                }

            } onError: { err in
                DispatchQueue.main.async {
                            
                    let alert = UIAlertController(title: "Что-то", message: "Пошло не так", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Все фигня давай по новой", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)                }
            }
        } catch {
            print(error)
        }
    }
    
    @IBOutlet weak var LoginText: UITextField!
    @IBOutlet weak var PasswordText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
