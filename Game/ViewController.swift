import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var middleBlock: UIView! {
        didSet {
            middleBlock.layer.cornerRadius = 10.0
        }
    }

    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var greenScore: UILabel! {
        didSet {
            greenScore.transform = CGAffineTransformRotate(
                CGAffineTransformIdentity, CGFloat(M_PI))
            let value = NSUserDefaults.standardUserDefaults().integerForKey("GreenScore")
            greenScore.text = String(value)
        }
    }

    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var blueScore: UILabel! {
        didSet {
            let value = NSUserDefaults.standardUserDefaults().integerForKey("BlueScore")
            blueScore.text = String(value)
        }
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    @IBAction func greenButtonPress(sender: UIButton) {
        print("Green Button Press")
        UIView.animateWithDuration(2.0,
               delay: 0,
               usingSpringWithDamping: 0.01,
               initialSpringVelocity: 10,
               options: [.CurveEaseInOut],
               animations: {
//            self.middleBlock.center.y += 10.0
                let current = self.middleBlock.layer.affineTransform()
                self.middleBlock.layer.setAffineTransform(CGAffineTransformTranslate(current, 0.0, 10.0))
        }, completion: nil)


        let win = middleBlock.frame.intersects(blueButton.frame)
        if win {
            adjustControls(false)
            showRematchAlert("Green")
            let currentScore = Int(greenScore.text!)!
            let newScore = currentScore + 1
            self.greenScore.text = String(newScore)
            NSUserDefaults.standardUserDefaults().setInteger(newScore, forKey: "GreenScore")
        }
    }

    @IBAction func blueButtonPress(sender: UIButton) {
        print("Blue button Press")

        UIView.animateWithDuration(2.0,
           delay: 0,
           usingSpringWithDamping: 0.1,
           initialSpringVelocity: 5,
           options: [.CurveEaseInOut],
           animations: {
//                self.middleBlock.center.y -= 10.0
            let current = self.middleBlock.layer.affineTransform()
            self.middleBlock.layer.setAffineTransform(
                CGAffineTransformTranslate(current, 0.0, -10.0))
            }, completion: nil)

        let win = middleBlock.frame.intersects(greenButton.frame)
        if win {
            adjustControls(false)
            showRematchAlert("Blue")
            let currentScore = Int(blueScore.text!)!
            let newScore = currentScore + 1
            self.blueScore.text = String(newScore)
            NSUserDefaults.standardUserDefaults().setInteger(newScore, forKey: "BlueScore")
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("Laying Out")
    }

    func showRematchAlert(winner: String) {
        let alert = UIAlertController(title: "🎉🎉 \(winner) 🕶 Wins 🎉🎉",
                                      message: "Ready for a rematch?",
                                      preferredStyle: UIAlertControllerStyle.Alert)
        let rematchButton = UIAlertAction(title: "Rematch",
                                   style: UIAlertActionStyle.Default,
                                   handler: handleRematch)
        alert.addAction(rematchButton)
        presentViewController(alert, animated: true, completion: nil)
    }

    func adjustControls(enabled: Bool) {
        blueButton.userInteractionEnabled = enabled
        greenButton.userInteractionEnabled = enabled
    }

    func handleRematch(alertAction: UIAlertAction) -> Void {
        print("Start Remath")
        adjustControls(true)
        UIView.animateWithDuration(0.5, animations: {
            self.middleBlock.layer.setAffineTransform(CGAffineTransformIdentity)
        })
    }
}
