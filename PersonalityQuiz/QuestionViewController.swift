//
//  QuestionViewController.swift
//  PersonalityQuiz
//
//  Created by Wesley Keetch on 10/8/24.
//

import UIKit

class QuestionViewController: UIViewController {

  @IBOutlet var questionLabel: UILabel!

  @IBOutlet var singleStackView: UIStackView!

  @IBOutlet var multipleStackView: UIStackView!

  @IBOutlet var rangedStackView: UIStackView!
  @IBOutlet var rangedLabel1: UILabel!
  @IBOutlet var rangedLabel2: UILabel!
  @IBOutlet var rangedSlider: UISlider!

  @IBOutlet var questionProgressView: UIProgressView!

  var questions: [Question] = [
    Question(
      text: "When faced with a challenge, how do you typically respond?",
      type: .single,
      answers: [
        Answer(text: "Rally your friends and tackle it together. Teamwork is the best way to overcome challenges.", type: .LOTR),
        Answer(text: "Usually you just go for it without thinking. Think outside the box and come up with a unique solution. ", type: .marvel),
        Answer(text: "Analyze the situation carefully before making a move. You seek the wisdom of elders.", type: .dune),
        Answer(text: "Charge in with confidence and trust your instincts. You kind or sort of plan it out.", type: .starWars)].shuffled()
    ),

    Question(text: "Which of these values resonates most with you?",
             type: .multiple,
             answers: [
              Answer(text: "Friendship, loyalty, and second breakfast.", type: .LOTR),
              Answer(text: "Individuality, freedom, cringey one liners and shawarma. ", type: .marvel),
              Answer(text: "Knowledge, power, and blue juice", type: .dune),
              Answer(text: "Courage and fighting for what is right and blue milk. ", type: .starWars)
             ].shuffled()
            ),

    Question(text: "If you could choose a setting for your ideal adventure, which would it be?",
             type: .single,
             answers: [
              Answer(text: "A magical land filled with mythical creatures and epic quests.", type: .LOTR),
              Answer(text: "A bustling city where you can explore and create your own path.", type: .marvel),
              Answer(text: "A vast desert with hidden secrets and ancient mysteries.", type: .dune),
              Answer(text: "A galaxy far, far away, filled with diverse planets and thrilling battles.", type: .starWars)
             ]
            ),

    Question(text: "On a scale from 1 to 10, how much do you value adventure in your life?",
             type: .ranged,
             answers: [
                Answer(text: "1 - Calm life.", type: .LOTR),
                Answer(text: "5 - I enjoy a mix of adventure and relaxation.", type: .marvel),
                Answer(text: "8 - I seek thrilling experiences and challenges.", type: .dune),
                Answer(text: "10 - Insane adventures.", type: .starWars)
             ]
    ),

    Question(text: "If you could possess one special ability, which would you choose?",
             type: .single,
             answers: [
              Answer(text: "The power to communicate with and command nature and its creatures.", type: .LOTR),
              Answer(text: "The ability to manipulate time and space to create my own reality.", type: .marvel),
              Answer(text: "The skill to see into the future and navigate complex situations with foresight.", type: .dune),
              Answer(text: "The talent to harness the Force and connect with the universe around me.", type: .starWars)
             ]
            )

  ].shuffled()

  var questionIndex = 0

  var answerChosen: [Answer] = []

  var multipleLabelSwitch: [UISwitch] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    updateUI()
  }

  @IBAction func singleAnswerButtonPressed(sender: UIButton) {
    let currentAnswers = questions[questionIndex].answers

    for i in Range(0...currentAnswers.count - 1) {
      if sender.titleLabel?.text == currentAnswers[i].text {
        answerChosen.append(currentAnswers[i])
      }
    }

    nextQuestion()
  }

  @IBAction func multipleAnswerButtonPressed(sender: Any) {
    let currentAnswers = questions[questionIndex].answers
    for i in Range(0...currentAnswers.count - 1) {
      if multipleLabelSwitch[i].isOn {
        answerChosen.append(currentAnswers[i])
        print(currentAnswers[i])
      }
    }

    nextQuestion()
  }


  @IBAction func rangedAnswerButtonPressed(_ sender: Any) {
    let currentAnswers = questions[questionIndex].answers
    let index = Int(rangedSlider.value * Float(currentAnswers.count - 1))

    answerChosen.append(currentAnswers[index])

    nextQuestion()
  }

  func updateUI() {
    singleStackView.isHidden = true
    multipleStackView.isHidden = true
    rangedStackView.isHidden = true

    singleStackView.subviews.forEach { $0.removeFromSuperview() }
    multipleStackView.subviews.forEach { $0.removeFromSuperview() }
    multipleLabelSwitch.removeAll()



    let currentQuestion = questions[questionIndex]
    let currentAnswer = currentQuestion.answers
    let totalProgress = Float(questionIndex) / Float(questions.count)

    navigationItem.title = "Question #\(questionIndex + 1)"
    questionLabel.text = currentQuestion.text
    questionProgressView.setProgress(totalProgress, animated: true)

    switch currentQuestion.type {
    case .single:
      updateSingleStack(using: currentAnswer)
    case .multiple:
      updateMultipleStack(using: currentAnswer)
    case .ranged:
      updateRangedStack(using: currentAnswer)
    }

  }

  @IBSegueAction func showResults(_ coder: NSCoder) -> ResultViewController? {
    return ResultViewController(coder: coder, responses: answerChosen)
  }

  func updateSingleStack(using answers: [Answer]) {
    for i in Range(0...answers.count - 1) {
      let button = UIButton(type: .system)
      button.titleLabel?.font = .systemFont(ofSize: 18)
      button.setTitle(answers[i].text, for: .normal)
      button.addTarget(self, action: #selector(singleAnswerButtonPressed(sender:)), for: .touchUpInside)
      button.titleLabel?.numberOfLines = 0
      button.titleLabel?.lineBreakMode = .byWordWrapping
      button.contentHorizontalAlignment = .left
      singleStackView.addArrangedSubview(button)
    }
    singleStackView.isHidden = false
  }

  func updateMultipleStack(using answers: [Answer]) {
    multipleStackView.isHidden = false

    for i in Range(0...answers.count - 1) {
      let multiSwitch = UISwitch()
      let label = UILabel()
      let stackView = UIStackView()
      stackView.axis = .horizontal
      stackView.alignment = .fill
      stackView.distribution = .fill
      stackView.spacing = 8
      multiSwitch.isOn = false
      label.text = answers[i].text
      label.numberOfLines = 0
      label.lineBreakMode = .byWordWrapping
      label.font = .systemFont(ofSize: 16)
      multipleLabelSwitch.append(multiSwitch)
      print(multipleLabelSwitch)
      stackView.addArrangedSubview(label)
      stackView.addArrangedSubview(multipleLabelSwitch[i])
      multipleStackView.addArrangedSubview(stackView)
    }

    let button = UIButton(type: .system)
    button.setTitle("Submit answer", for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 18)
    button.addTarget(self, action: #selector(multipleAnswerButtonPressed(sender:)), for: .touchUpInside)
    multipleStackView.addArrangedSubview(button)
  }

  func updateRangedStack(using answers: [Answer]) {
    rangedStackView.isHidden = false
    rangedSlider.setValue(0.5, animated: false)
    rangedLabel1.text = answers.first?.text
    rangedLabel2.text = answers.last?.text
  }

  func nextQuestion() {
    questionIndex += 1
    if questionIndex < questions.count {
      updateUI()
    } else {
      performSegue(withIdentifier: "Results", sender: nil)
    }
  }
}
