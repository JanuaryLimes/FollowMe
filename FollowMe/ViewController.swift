//
//  ViewController.swift
//  FollowMe
//
//  Created by Kacper Śledź on 16.10.2017.
//  Copyright © 2017 JanuaryLimes. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIAlertViewDelegate {
    
    enum ButtonColor : Int {
        case Red = 1
        case Green = 2
        case Blue = 3
        case Yellow = 4
    }
    
    enum WhoseTurn {
        case Human, Computer
    }
    
    @IBOutlet weak var redButton : UIButton!
    @IBOutlet weak var greenButton : UIButton!
    @IBOutlet weak var blueButton : UIButton!
    @IBOutlet weak var yellowButton : UIButton!
    
    let winningNumber = 25
    var currentPlayer = WhoseTurn.Computer
    var inputs = [ButtonColor]()
    var indexOfNextButtonToTouch = 0
    var highlightSquareTime = 0.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startNewGame()
    }
    
    func buttonByColor(color : ButtonColor) -> UIButton{
        switch color {
        case .Red:
            return redButton
        case .Green:
            return greenButton
        case .Blue:
            return blueButton
        case .Yellow:
            return yellowButton
        }
    }
    
    func playSequence(index : Int, highlightTime : Double) {
        currentPlayer = .Computer
        
        if index == inputs.count {
            currentPlayer = .Human
            return
        }
        
        let button : UIButton = buttonByColor(color: inputs[index])
        let originalColor : UIColor? = button.backgroundColor
        let highlightColor : UIColor = UIColor.white
        
        UIView.animate(withDuration: highlightTime,
                       delay: 0.0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveLinear,
                       animations: {
                        button.backgroundColor = highlightColor},
                       completion: {
                        finished in
                        button.backgroundColor = originalColor
                        let newIndex = index + 1
                        self.playSequence(index: newIndex, highlightTime: highlightTime)
        })
    }
    
    @IBAction func buttonTouched(sender : UIButton){
        let buttonTag : Int = sender.tag
        
        if let colorTouched = ButtonColor(rawValue: buttonTag) {
            if currentPlayer == .Computer{
                return
            }
            
            if colorTouched == inputs[indexOfNextButtonToTouch]{
                indexOfNextButtonToTouch = indexOfNextButtonToTouch + 1
                
                if indexOfNextButtonToTouch == inputs.count{
                    if advanceGame() == false{
                        playerWins()
                    }
                    indexOfNextButtonToTouch = 0
                }
                else {
                    //more buttons
                }
            }
            else {
                playerLoses()
                indexOfNextButtonToTouch = 0
            }
        }
    }
    
    func playerWins(){
        let alert = UIAlertController(title: "You won!", message: "Congratulations", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Awesome!", style: .default, handler:
            { _ in
                NSLog("User won.")
                self.startNewGame()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func playerLoses(){
        let alert = UIAlertController(title: "You lost!", message: "Sorry", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again!", style: .default, handler:
            { _ in
                self.startNewGame()
                NSLog("User lost")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func randomButton() -> ButtonColor{
        let v = Int(arc4random_uniform(UInt32(4))) + 1
        let result = ButtonColor(rawValue: v)
        return result!
    }
    
    func startNewGame(){
        inputs = [ButtonColor]()
        _ = advanceGame()
    }
    
    func advanceGame() -> Bool{
        var result = true
        
        if inputs.count == winningNumber {
            result = false
        }else{
            inputs += [randomButton()]
            playSequence(index: 0, highlightTime: highlightSquareTime)
        }
        
        return result
    }
}
