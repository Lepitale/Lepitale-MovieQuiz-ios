import UIKit

struct ViewModel {
  let image: UIImage
  let question: String
  let questionNumber: String
}

struct QuizStepViewModel {
  let image: UIImage
  let question: String
  let questionNumber: String
}

struct QuizResultsViewModel {
  let title: String
  let text: String
  let buttonText: String
}

struct QuizQuestion {
  let image: String
  let text: String
  let correctAnswer: Bool
}

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false)
    ]
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentQuestion = questions[currentQuestionIndex]
        let firstQuestion = convert(model: currentQuestion)
        show(quiz: firstQuestion)
    }

    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        answerGived(answer: true)
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = true // 2
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        answerGived(answer: true)
        let currentQuestion = questions[currentQuestionIndex] // 1
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    private func answerGived(answer: Bool) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect { // 1
            correctAnswers += 1
        }
        imageView.layer.borderWidth = 4
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        if isCorrect {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
            self.imageView.layer.borderColor = UIColor.ypWhite.withAlphaComponent(0.0).cgColor
            
        }
    }
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
                    let text = "Ваш результат: \(correctAnswers)/10" // 1
                    let result = QuizResultsViewModel(
                        title: "Этот раунд окончен!",
                        text: text,
                        buttonText: "Сыграть ещё раз")
            
                    // создаем UIAlertController и UIAlertAction
                    let alert = UIAlertController(
                        title: result.title,
                        message: result.text,
                        preferredStyle: .alert)
                    let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
                        guard let self = self else {
                            return
                        }
                        self.currentQuestionIndex = 0
                        self.correctAnswers = 0
                        let firstQuestion = self.questions[self.currentQuestionIndex]
                        let viewModel = self.convert(model: firstQuestion)
                        self.show(quiz: viewModel)
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
            
        } else {
            currentQuestionIndex += 1
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            show(quiz: viewModel)
        }
    }
    
}
