//
//  StartViewController.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 13.06.2021.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    
    @IBAction func search() {
        accountGlobal = usernameTF.text ?? "turinz"
        performSegue(withIdentifier: "toProfile", sender: nil)
    }
    
}

extension StartViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        accountGlobal = textField.text ?? "turinz"
    }
}
