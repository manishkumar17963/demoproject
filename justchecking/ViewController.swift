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
        
        
        // ADD DELEGATE OF INPUT FIELD
        mobileInput.delegate = self
        
        // SUBSCRIBE TO STATE CHANGES OF STORE
        appStore.subscribe(self)
        button.setTitle("Add and Verify", for: .normal)
        
        inputLabel.text="Mobile Phone"
        
        // BY DEFAULT DIABLED
        button.isEnabled = false

        
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        // UNSUBSCRIBE WHEN VIEW WILL DISAPPEAR SO THAT NO MEMORY LEAKAGE HAPPEN
        appStore.unsubscribe(self)
    }

    @IBAction func buttonAction(_ sender: Any) {
        let alert = UIAlertController(title: "Your number is \(appStore.state.number!)", message: "Press ok to submit the form", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
                case .default:
                print("ok selected")
                
            case .cancel: break
                
            case .destructive: break
                
            @unknown default:
                print("something other")
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - INPUTNUMBERFORMATTER
extension ViewController {
   // format input text into country number format
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
}




//MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    
 
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text != "" {
            button.isEnabled = true
            
            // UPDATE NUMBER VALUE TO STORE
            appStore.dispatch(AppAction.setNumber(number: textField.text ?? ""))
        } else {
            textField.placeholder = "Type something"
            
            // ENABLE BUTTON WHEN THERE IS ANY INPUT IN TEXTFIELD, WE CAN VALIDATE IT TOO.
            button.isEnabled=false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
          let newString = (text as NSString).replacingCharacters(in: range, with: string)
          textField.text = format(with: "(XXX) XXX-XXXX", phone: newString)
          return false
    }
}




//MARK: - TRIGGERWHENSTATECHANGES
extension ViewController{
    func newState(state: AppState) {
        print("something changes")
        print(state.number ?? "No value")
    }
}

