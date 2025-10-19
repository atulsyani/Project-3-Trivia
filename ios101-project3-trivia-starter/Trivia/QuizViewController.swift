import UIKit

final class QuizViewController: UIViewController {

    // MARK: - Outlets (connect these in Interface Builder)
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet var optionButtons: [UIButton]!
    
    // MARK: - State
    private var questions: [Question] = [
        Question(
            category: "Entertainment: Video Games",
            prompt: "What was the first weapon pack for 'PAYDAY'?",
            answers: ["The Gage Weapon Pack #1",
                      "The Overkill Pack",
                      "The Gage Chivalry Pack",
                      "The Gage Historical Pack"],
            correctIndex: 0
        ),
        Question(
            category: "Geography",
            prompt: "What is the capital of Australia?",
            answers: ["Sydney", "Melbourne", "Canberra", "Perth"],
            correctIndex: 2
        ),
        Question(
            category: "Science",
            prompt: "Which planet has the most confirmed moons?",
            answers: ["Mars", "Jupiter", "Saturn", "Neptune"],
            correctIndex: 2
        )
    ]

    private var index = 0
    private var score = 0

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        styleUI()
        showQuestion()
    }

    // MARK: - Actions
    @IBAction func optionTapped(_ sender: UIButton) {
        let chosen = sender.tag
        let correct = questions[index].correctIndex
        if chosen == correct { score += 1 }
        provideFeedback(on: sender, correct: chosen == correct)
        goToNextQuestion(after: 0.35)
    }

    // MARK: - UI helpers
    private func styleUI() {
        // Card look for the white question box
        cardView.layer.cornerRadius = 16
        cardView.layer.masksToBounds = true

        // Rounded buttons
        optionButtons.forEach {
            $0.layer.cornerRadius = 12
            $0.titleLabel?.numberOfLines = 2
            $0.titleLabel?.adjustsFontSizeToFitWidth = true
            $0.titleLabel?.minimumScaleFactor = 0.7
        }
    }

    private func showQuestion() {
        let q = questions[index]
        progressLabel.text = "Question \(index + 1)/\(questions.count)"
        categoryLabel.text = "Entertainment: \(q.category)"
        questionLabel.text = q.prompt
        for (i, btn) in optionButtons.enumerated() {
            btn.setTitle(q.answers[i], for: .normal)
            btn.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.4)
            btn.isEnabled = true
        }
        // subtle fade-in
        UIView.transition(with: cardView, duration: 0.2, options: .transitionCrossDissolve) {}
    }

    private func goToNextQuestion(after delay: TimeInterval) {
        // disable taps during transition
        optionButtons.forEach { $0.isEnabled = false }
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.index += 1
            if self.index < self.questions.count {
                self.showQuestion()
            } else {
                self.presentResults()
            }
        }
    }

    private func presentResults() {
        let alert = UIAlertController(
            title: "Quiz Complete!",
            message: "You scored \(score) / \(questions.count).",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Restart", style: .default) { _ in
            self.index = 0
            self.score = 0
            self.showQuestion()
        })
        present(alert, animated: true)
    }

    private func provideFeedback(on button: UIButton, correct: Bool) {
        button.backgroundColor = correct ? .systemGreen : .systemRed
        // briefly show which was correct (optional)
        if !correct {
            let correctBtn = optionButtons[questions[index].correctIndex]
            correctBtn.backgroundColor = .systemGreen
        }
    }
}
