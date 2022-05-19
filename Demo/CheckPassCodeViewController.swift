import UIKit

class CheckPassCodeViewController: UIViewController {
    
    @IBOutlet weak var progressLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var progressWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var progressCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var stackViewPassCodeCharacter: UIStackView!
    
    private let animationDuration: CGFloat = 0.33
    private var input: String = ""
    private let numberOfPasswordCharacter: Int = 4
    private var pass: String = ""
    private let frameView: CGFloat = 30
    private let delayAnimate: CGFloat = 0.5
    private var spacingOfStackViewPassCodeCharacter: CGFloat!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    let userDefaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spacingOfStackViewPassCodeCharacter = stackViewPassCodeCharacter.spacing
//        userDefaults.removeObject(forKey: "input")
        if userDefaults.value(forKey: "input") != nil {
            pass = userDefaults.value(forKey: "input")  as! String
        }
        else {
            pass = ""
        }
        print(pass)
        for subView in self.stackViewPassCodeCharacter.arrangedSubviews {
            subView.layer.borderWidth = 1
            subView.layer.cornerRadius = frameView/2
            subView.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        }
        if pass == "" {
            statusLabel.text = "CREATE YOUR PASSCODE"
        }
        else {
            statusLabel.text = "ENTER YOUR PASSCODE"
        }
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        if statusLabel.text == "ENTER YOUR PASSCODE" {
            if input.count < numberOfPasswordCharacter {
                input += String(sender.tag)
                self.progressWidthConstraint.constant = frameView * CGFloat(numberOfPasswordCharacter) * min(CGFloat(self.input.count)/CGFloat(numberOfPasswordCharacter), 1) + spacingOfStackViewPassCodeCharacter * CGFloat(self.input.count - 1)
            }
            else if input.count == numberOfPasswordCharacter && input == pass {
                self.progressWidthConstraint.constant = frameView
            }
            else {
                input = ""
            }
            progressView.layer.cornerRadius = frameView/2
            UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut) {
                self.view.layoutIfNeeded()
            } completion: { _ in
                if self.input.count == self.numberOfPasswordCharacter {
                    if self.input == self.pass {
                        
                        self.progressWidthConstraint.constant = self.frameView
                        self.progressLeadingConstraint.isActive = false
                        self.progressCenterConstraint.isActive = true
              
                        UIView.animate(withDuration: self.animationDuration, delay: self.delayAnimate, options: .curveEaseInOut) {
                            self.view.layoutIfNeeded()
                            self.stackViewPassCodeCharacter.isHidden = true
                            self.progressView.backgroundColor = .green

                        } completion: { _ in
                            // Reset
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.showUnlockView()
                            }
                        }
                    }
                    else {
                        UIView.animate(withDuration: self.animationDuration, delay: self.delayAnimate, options: .curveEaseInOut) {
                            self.view.layoutIfNeeded()
                        } completion: { _ in
                            // Reset
                            DispatchQueue.main.asyncAfter(deadline: .now() + self.delayAnimate) {
                                self.input = ""
                                self.progressWidthConstraint.constant = 0
                                self.progressCenterConstraint.isActive = false
                                self.progressLeadingConstraint.isActive = true
                            }
                        }
                    }
                }
            }
        }
        else if statusLabel.text == "CREATE YOUR PASSCODE" {
            if input.count < numberOfPasswordCharacter {
                input += String(sender.tag)
                self.progressWidthConstraint.constant = frameView * CGFloat(numberOfPasswordCharacter) * min(CGFloat(self.input.count)/CGFloat(numberOfPasswordCharacter), 1) + spacingOfStackViewPassCodeCharacter * CGFloat(self.input.count - 1)
            }
            else {
                input = ""
            }
            
            // gán input vào userDefaults
            userDefaults.setValue(input, forKey: "input")
            progressView.layer.cornerRadius = frameView/2
            
            UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut) {
                self.view.layoutIfNeeded()
            } completion: { _ in
                
                // Kiểm tra xem nếu nhập đủ 4 kí tự thì get giá trị từ userDefaluts rồi gán cho pass
                if self.input.count == self.numberOfPasswordCharacter {
                    
                    self.pass = self.userDefaults.value(forKey: "input") as! String
                    UIView.animate(withDuration: self.animationDuration, delay: self.delayAnimate, options: .curveEaseInOut) {
                        self.view.layoutIfNeeded()
                    } completion: { _ in
                        // Reset input
                        DispatchQueue.main.asyncAfter(deadline: .now() + self.delayAnimate) {
                            self.input = ""
                            self.progressWidthConstraint.constant = 0
                            self.progressLeadingConstraint.isActive = true
                            self.statusLabel.text = "CONFIRM YOUR PASSCODE"

                        }
                    }
                }
            }
        }
        else if statusLabel.text == "CONFIRM YOUR PASSCODE" {
            if self.input.count < self.numberOfPasswordCharacter {
                self.input += String(sender.tag)
                self.progressWidthConstraint.constant = self.frameView * CGFloat(self.numberOfPasswordCharacter) * min(CGFloat(self.input.count)/CGFloat(self.numberOfPasswordCharacter), 1) + self.spacingOfStackViewPassCodeCharacter * CGFloat(self.input.count - 1)
            }
            else {
                input = ""
            }
            UIView.animate(withDuration: self.animationDuration, delay: 0, options: .curveEaseInOut) {
                self.view.layoutIfNeeded()
            } completion: { _ in
                if self.input.count == self.numberOfPasswordCharacter {
                    if self.input == self.pass {
                        UIView.animate(withDuration: self.animationDuration, delay: self.delayAnimate, options: .curveEaseInOut) {
                            self.view.layoutIfNeeded()
                        } completion: { _ in
                            // Reset
                            DispatchQueue.main.asyncAfter(deadline: .now() + self.delayAnimate) {
                                self.input = ""
                                self.progressWidthConstraint.constant = 0
                                self.progressLeadingConstraint.isActive = true
                                self.showUnlockView()
                            }
                        }
                    }
                    else {
                        UIView.animate(withDuration: self.animationDuration, delay: self.delayAnimate, options: .curveEaseInOut) {
                            self.view.layoutIfNeeded()
                        } completion: { _ in
                            // Reset
                            DispatchQueue.main.asyncAfter(deadline: .now() + self.delayAnimate) {
                                self.input = ""
                                self.progressWidthConstraint.constant = 0
                                self.progressLeadingConstraint.isActive = true
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        if self.input.count > 0 {
            self.input.removeLast()
        }
        self.progressWidthConstraint.constant = frameView * CGFloat(numberOfPasswordCharacter) * min(CGFloat(self.input.count)/CGFloat(numberOfPasswordCharacter), 1) + spacingOfStackViewPassCodeCharacter * CGFloat(self.input.count - 1)
        UIView.animate(withDuration: self.animationDuration, delay: delayAnimate, options: .curveEaseInOut){
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func showUnlockView() {
        guard let unlockVC = storyboard?.instantiateViewController(withIdentifier: "UnlockView") as? UnlockViewController else { return }
        unlockVC.modalPresentationStyle = .fullScreen
        unlockVC.modalTransitionStyle = .crossDissolve
        present(unlockVC, animated: true)
    }
}

