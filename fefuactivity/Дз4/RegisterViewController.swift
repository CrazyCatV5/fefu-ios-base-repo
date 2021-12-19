//
//  RegisterViewController.swift
//  fefuactivity
//
//  Created by wsr5 on 19.12.2021.
//

import UIKit

class RegisterViewController: UIViewController {
    private let genders = ["Мужской", "Женский"]
    private var genderNum = 0
    @IBOutlet weak var LoginText: UITextField!
    @IBOutlet weak var PasswordText: UITextField!
    @IBOutlet weak var SecondPasswordText: UITextField!
    @IBOutlet weak var Gender: UIPickerView!
    @IBOutlet weak var Name: UITextField!
    @IBAction func Button(_ sender: Any) {
        let login = LoginText.text ?? ""
        let password = PasswordText.text ?? ""
        let passwordConfirm = SecondPasswordText.text ?? ""
        let name = Name.text ?? ""
        let gender = Gender
                
        if passwordConfirm != password {
            let alert = UIAlertController(title: "Ошибка", message: "Пароли не совпадают", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ясно", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
                
        let body = UserRegBody(login: login, password: password, name: name, gender: genderNum)
                
        do {
            let reqBody = try AuthService.encoder.encode(body)
            let queue = DispatchQueue.global(qos: .utility)
            AuthService.register(reqBody) { user in queue.async {
                            UserDefaults.standard.set(user.token, forKey: "token")
                        }
                    } onError: { err in
                        DispatchQueue.main.async {
                            var alertText = ""
                            for (_, values) in err.errors.reversed() {
                                for e in values {
                                    alertText += e + "\n"
                                }
                            }
                            
                            let alert = UIAlertController(title: "Проверьте поля", message: alertText, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Повторить попытку", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                } catch {
                    print(error)
                }
            
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Gender.delegate = self
        Gender.dataSource = self
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
extension RegisterViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
        
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }
        
}
