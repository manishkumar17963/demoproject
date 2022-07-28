//
//  ViewController.swift
//  justchecking
//
//  Created by Manish Sah on 28/07/22.
//

import UIKit
import ReSwift

class ViewController: UIViewController, StoreSubscriber {

    @IBOutlet weak var mobileInput: UITextField!
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        appStore.subscribe(self)
        button.setTitle("Add and Verify", for: .normal)
        
        inputLabel.text="Mobile Phone"
        button.isEnabled = false
        mobileInput.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        appStore.unsubscribe(self)
    }


}

/// m(XXX) XXX-XXXX`
func format(with mask: String, phone: String) -> String {
    let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    var result = ""
    var index = numbers.startIndex // numbers iterator

    // iterate over the mask characters until the iterator of numbers ends
    for ch in mask where index < numbers.endIndex {
        if ch == "X" {
            // mask requires a number in this place, so take the next one
            result.append(numbers[index])

            // move numbers iterator to the next index
            index = numbers.index(after: index)

        } else {
            result.append(ch) // just append a mask character
        }
    }
    return result
}


//MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        mobileInput.endEditing(true)
        return true
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text != "" {
            button.isEnabled = true
            appStore.dispatch(AppAction.setNumber(number: textField.text ?? ""))
        } else {
            textField.placeholder = "Type something"
            button.isEnabled=false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
          let newString = (text as NSString).replacingCharacters(in: range, with: string)
          textField.text = format(with: "(XXX) XXX-XXXX", phone: newString)
          return false
    }
  
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let number = mobileInput.text {
            print(number)
        }
    }
}

extension ViewController{
    func newState(state: AppState) {
        print("something changes")
        print(state.number ?? "No value")
    }
}

