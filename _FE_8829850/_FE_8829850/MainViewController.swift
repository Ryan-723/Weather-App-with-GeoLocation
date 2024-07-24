//
//  MainViewController.swift
//  _FE_8829850
//
//  Created by user228704 on 8/11/23.
//

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var cityNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityNameTextField.delegate = self

        // Do any additional setup after loading the view.
    }
    
    // Implement UITextFieldDelegate method to dismiss the keyboard when the Return key is pressed
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
        
        // Implement a UITapGestureRecognizer to dismiss the keyboard when tapping outside the text field
        @IBAction func handleTap(_ sender: UITapGestureRecognizer) {
            view.endEditing(true)
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "MapSegueIdentifier" {
                if let mapViewController = segue.destination as? MapViewController {
                    mapViewController.cityName = cityNameTextField.text ?? ""
                }
            }
            if segue.identifier == "WeatherSegueIdentifier" {
                if let WeatherViewController = segue.destination as? WeatherViewController {
                    WeatherViewController.cityName = cityNameTextField.text ?? ""
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
