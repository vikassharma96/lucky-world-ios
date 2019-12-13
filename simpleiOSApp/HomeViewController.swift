import UIKit
import Firebase
import FirebaseFirestore
import MBProgressHUD

class HomeViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    
    var deviceId: String = UIDevice.current.identifierForVendor!.uuidString
    var appDelegate:AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.imageTapped))
        imgView.isUserInteractionEnabled = true
        imgView.addGestureRecognizer(singleTap)
        appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    }

    @objc func imageTapped(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let dbRef = appDelegate.firestore.collection("users")
        dbRef.getDocuments(){
            (querySnapshot, err) in
            if let err = err
            {
                print("Error getting documents: \(err)");
            }
            else
            {
                for document in querySnapshot!.documents {
                    if let macId = document.get("deviceMac") as? String  {
                        if !macId.isEmpty {
                            if(macId.contains(self.deviceId)){
                                self.showToast(message: "You are already registered with us!")
                                MBProgressHUD.hide(for: self.view, animated: true)
                                return
                            } else{
                                MBProgressHUD.hide(for: self.view, animated: true)
                                if let registerStoryBoard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController {
                                    self.present(registerStoryBoard, animated: true, completion: nil)
                                }
                            }
                        }
                    }
                   
                }
                MBProgressHUD.hide(for: self.view, animated: true)
                if let registerStoryBoard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController {
                    self.present(registerStoryBoard, animated: true, completion: nil)
                }
            }
        }
    }
    
    func showToast(message: String){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.5
        alert.view.layer.cornerRadius = 15
        
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            alert.dismiss(animated: true)
        }
    }
    
}

