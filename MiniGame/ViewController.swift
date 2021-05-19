//
//  ViewController.swift
//  MiniGame
//
//  Created by Edrey Payan on 18/05/21.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    var answers = [String]()
    
    var tableData: Result? = nil
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tableData?.Questions.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "question") as! QuestionCell
        let quest = tableData?.Questions[indexPath.row]
        cell.question.text = quest?.Question
        cell.optionB.setTitle(quest?.OptionB, for: .normal)
        cell.optionA.setTitle(quest?.OptionA, for: .normal)
        cell.actionA = { sender in
            cell.optionA.backgroundColor = .clear
            cell.optionA.layer.cornerRadius = 10
            cell.optionA.layer.borderWidth = 1
            cell.optionA.layer.borderColor = UIColor.systemBlue.cgColor
            cell.optionA.layer.backgroundColor = UIColor.systemBlue.cgColor
            cell.optionA.titleLabel?.tintColor = UIColor.white
            cell.optionA.clipsToBounds = true
            cell.optionB.layer.borderColor = UIColor.white.cgColor
            cell.optionB.layer.backgroundColor = UIColor.white.cgColor
            cell.optionB.titleLabel?.tintColor = UIColor.systemBlue
            self.answers[indexPath.row] = "A"
        }
        
        cell.actionB = {sender in
            cell.optionB.backgroundColor = .clear
            cell.optionB.layer.cornerRadius = 10
            cell.optionB.layer.borderWidth = 1
            cell.optionB.layer.borderColor = UIColor.systemBlue.cgColor
            cell.optionB.layer.backgroundColor = UIColor.systemBlue.cgColor
            cell.optionB.titleLabel?.tintColor = UIColor.white
            cell.optionB.clipsToBounds = true
            cell.optionA.layer.borderColor = UIColor.white.cgColor
            cell.optionA.layer.backgroundColor = UIColor.white.cgColor
            cell.optionA.titleLabel?.tintColor = UIColor.systemBlue
            self.answers[indexPath.row] = "B"

        }
            
            
        return cell
    }
    
    @IBAction func sendAnswers(_ sender: Any) {
        var points: Int = 0
        if answers.contains("0"){
            message(message: "You need to answer all the questions!",buttonMessage: "OK")
        }else{
            for (index,answer) in answers.enumerated() {
               if answer == tableData?.Questions[index].Answer {
                    points += 1;
               }
            }
            message(message: "Congratulations you got \(points) points",buttonMessage: "Play again!")
        }
    }
    
    func message(message:String,buttonMessage: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: buttonMessage, style: UIAlertAction.Style.default, handler:{ (ACTION) -> Void in
            if buttonMessage == "Play again!"{
                self.dismiss(animated: true, completion: nil)
            }
        }))
    
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let path = Bundle.main.path(forResource: "Questions", ofType: "json"){
            do{
            
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let user = try! JSONDecoder().decode(Result.self, from: data)
               // let jsonCount = Array(repeating: "0", count: user.Questions.count)
                //answers = jsonCount
                answers = Array(repeating: "0", count: user.Questions.count)
                tableData = user
            }catch{
                
            }
        }
    }


    struct Questions : Codable {
        var Question : String
        var OptionA : String
        var OptionB : String
        var Answer : String
    }
    
    struct Result : Codable {
        var Questions: [Questions]
    }
}

class QuestionCell:UITableViewCell{
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var optionA: UIButton!
    @IBOutlet weak var optionB: UIButton!
    
    var actionA: ((Any) -> Void)?

    @IBAction func pressedA(sender: Any) {
        self.actionA?(sender)
    }
    var actionB: ((Any) -> Void)?

    @IBAction func pressedB(sender: Any) {
        self.actionB?(sender)
    }
 
}

