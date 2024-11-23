import UIKit

class HomeViewController: UIViewController, CategoryViewControllerDelegate {
    
    private var words: [Word] = []
    
    func didSelectWords(_ words: [Word]) {
        self.words = words
        currentWordIndex = 0
        updateCardContent()
    }
    
    private var currentWordIndex = 0
    private var isEnglish = true
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let cardContentLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(.black)
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.text = "1 / 20"
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .darkGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "gearshape"), for: .normal)
        button.tintColor = .darkGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let undoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.uturn.backward"), for: .normal)
        button.tintColor = .darkGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.tintColor = .darkGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = UIColor(red: 1.0, green: 0.6, blue: 0.4, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.backgroundColor = UIColor(red: 1.0, green: 0.9, blue: 0.8, alpha: 1.0)
        label.textAlignment = .center
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let plusOneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+1", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.4, green: 0.8, blue: 0.6, alpha: 1.0)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateCardContent()
        addSwipeGestures()
        setupButtonActions()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(cardView)
        view.addSubview(progressLabel)
        view.addSubview(backButton)
        view.addSubview(settingsButton)
        view.addSubview(undoButton)
        view.addSubview(nextButton)
        view.addSubview(scoreLabel)
        view.addSubview(plusOneButton)
        cardView.addSubview(cardContentLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardTapped))
        cardView.addGestureRecognizer(tapGesture)
        
        NSLayoutConstraint.activate([
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            cardView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            
            cardContentLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            cardContentLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            
            progressLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            progressLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            undoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            undoButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            scoreLabel.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 10),
            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scoreLabel.widthAnchor.constraint(equalToConstant: 40),
            scoreLabel.heightAnchor.constraint(equalToConstant: 40),
            
            plusOneButton.trailingAnchor.constraint(equalTo: nextButton.leadingAnchor, constant: -20),
            plusOneButton.centerYAnchor.constraint(equalTo: nextButton.centerYAnchor),
            
        ])
    }
    
    private func addSwipeGestures() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        swipeLeft.direction = .left
        cardView.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        swipeRight.direction = .right
        cardView.addGestureRecognizer(swipeRight)
    }
    
    @objc private func swipeLeft() {
        if currentWordIndex < words.count - 1 {
            currentWordIndex += 1
            updateCardContent()
        } else {
            currentWordIndex = 0
            updateCardContent()
        }
    }
    
    @objc private func swipeRight() {
        if currentWordIndex > 0 {
            currentWordIndex -= 1
            updateCardContent()
        }
    }
    
    @objc private func cardTapped() {
        isEnglish.toggle()
        updateCardContent()
    }
    
    private func updateCardContent() {
        guard !words.isEmpty else { return }
        let word = words[currentWordIndex]
        if isEnglish {
            cardContentLabel.text = word.english
        } else {
            cardContentLabel.text = word.turkish
        }
        
        progressLabel.text = "\(currentWordIndex + 1) / \(words.count)"
    }
    
    @objc private func plusOneTapped() {
        if let currentScore = Int(scoreLabel.text ?? "0") {
            scoreLabel.text = "\(currentScore + 1)"
        }
    }
    
    private func setupButtonActions() {
        plusOneButton.addTarget(self, action: #selector(plusOneTapped), for: .touchUpInside)
        
        settingsButton.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
    }
    
    @objc private func settingsTapped() {
        let categoryVC = CategoryViewController()
        
        categoryVC.delegate = self
        
        let navigationController = UINavigationController(rootViewController: categoryVC)
        present(navigationController, animated: true, completion: nil)
    }
    
}
