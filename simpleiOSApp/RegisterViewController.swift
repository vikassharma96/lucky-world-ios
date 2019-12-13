import UIKit
import Firebase
import FirebaseFirestore
import CoreLocation
import MBProgressHUD

class RegisterViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var number: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    var locationManager: CLLocationManager!

    var firestore : Firestore = Firestore.firestore()
    var deviceId: String = UIDevice.current.identifierForVendor!.uuidString
    var deviceName: String = UIDevice.current.name
    var deviceLocation: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        registerBtn.layer.cornerRadius = CGFloat(10.0)
        
        let doneToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width:UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneTool = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(self.doneTapped))
        doneToolbar.items = [flexSpace, doneTool]
        doneToolbar.sizeToFit()
        number.inputAccessoryView = doneToolbar
    }
    
    @objc func doneTapped() {
        email.becomeFirstResponder()
    }
    
    @IBAction func registerClick(_ sender: Any) {
        _ = checkValidation()
    }
    
    func checkValidation() -> Bool{
        if(name.text!.isEmpty){
            self.showToast(message: "Please Provide Name")
            return false
        } else if(number.text!.isEmpty || number.text!.count < 10){
            self.showToast(message: "Please Provide Correct Phone Number")
            return false
        } else if (email.text!.isEmpty || !isValidEmail(emailStr: email.text!)){
            self.showToast(message: "Please Provide Correct Email Id")
            return false
        } else {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            let reference = firestore.collection("users").document()
            let ref = reference.collection("deviceDetails")
            let user = User(name: name.text!, number: number.text!, email: email.text!, deviceId: self.deviceId, deviceName: self.deviceName, deviceLocation: self.deviceLocation)
            let deviceDetails = DeviceDetails(deviceMac: self.deviceId, deviceName: self.deviceName, deviceLocation: self.deviceLocation)
            let encoder = JSONEncoder()
            do {
                let data = try encoder.encode(user)
                let dictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? [String: Any] ?? [:]
                let deviceData = try encoder.encode(deviceDetails)
                let dict = try JSONSerialization.jsonObject(with: deviceData, options: JSONSerialization.ReadingOptions()) as? [String: Any] ?? [:]
                print("Data: \(String(decoding: data, as: UTF8.self))")
//                print("Data Dictionary: \(dictionary)")
                reference.setData(dictionary)
                ref.document("data").setData(dict)
                //move to success screen
                if let successStoryBoard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SuccessViewController") as? SuccessViewController {
                    self.present(successStoryBoard, animated: true, completion: nil)
                }
                MBProgressHUD.hide(for: self.view, animated: true)
                return true
            } catch let err {
                print("checkValidation: \(err)")
                MBProgressHUD.hide(for: self.view, animated: true)
                return false
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse {return}
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        if let locValue: CLLocationCoordinate2D = manager.location?.coordinate {
//        let locValue: CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.longitude) \(locValue.latitude)")
        deviceLocation = String(locValue.longitude) + "," + String(locValue.latitude)
        }
    }
    
    func showToast(message: String){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.5
        alert.view.layer.cornerRadius = 15
        
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            alert.dismiss(animated: true)
        }
    }
    
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == name {
            number.becomeFirstResponder()
        }
        textField.resignFirstResponder()
        return true
    }
}

//extension String {
//    var isValidEmail: Bool {
//        return NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
//    }
//}
