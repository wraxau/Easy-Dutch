import UIKit

final class TranslatorViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "🇬🇧 → 🇳🇱 Translator"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter an English word..."
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 18)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.returnKeyType = .done
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        return textField
    }()
    
    private let translateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Translate", for: .normal)
        button.applyStyleForBigButtons()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 22, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let pronunciationLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let definitionLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .tertiaryLabel
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let speakButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "speaker.wave.2.fill"), for: .normal)
        button.tintColor = .darkBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SpeechService.shared.stop()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Translator"
        
        [titleLabel, inputTextField, translateButton, loadingIndicator,
         resultLabel, pronunciationLabel, definitionLabel, speakButton]
            .forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            inputTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            inputTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            inputTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            inputTextField.heightAnchor.constraint(equalToConstant: 50),
            
            translateButton.topAnchor.constraint(equalTo: inputTextField.bottomAnchor, constant: 20),
            translateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            translateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            translateButton.heightAnchor.constraint(equalToConstant: 50),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.topAnchor.constraint(equalTo: translateButton.bottomAnchor, constant: 30),
            
            resultLabel.topAnchor.constraint(equalTo: loadingIndicator.bottomAnchor, constant: 20),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            pronunciationLabel.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 10),
            pronunciationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pronunciationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            definitionLabel.topAnchor.constraint(equalTo: pronunciationLabel.bottomAnchor, constant: 15),
            definitionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            definitionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            speakButton.topAnchor.constraint(equalTo: definitionLabel.bottomAnchor, constant: 20),
            speakButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            speakButton.widthAnchor.constraint(equalToConstant: 150),
            speakButton.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func setupActions() {
        translateButton.addTarget(self, action: #selector(translateButtonTapped), for: .touchUpInside)
        speakButton.addTarget(self, action: #selector(speakButtonTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(speakResultTapped))
        resultLabel.addGestureRecognizer(tapGesture)
        resultLabel.isUserInteractionEnabled = true
    }
    
    private func setupKeyboard() {
        inputTextField.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    
    @objc private func translateButtonTapped() {
        guard let text = inputTextField.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert(title: "Ошибка", message: "Введите слово для перевода")
            return
        }
        
        let word = text.trimmingCharacters(in: .whitespaces).lowercased()
        
        loadingIndicator.startAnimating()
        translateButton.isEnabled = false
        resetResultViews()
        
        translateWord(word, from: "en", to: "nl") { [weak self] translated in
            DispatchQueue.main.async {
                self?.loadingIndicator.stopAnimating()
                self?.translateButton.isEnabled = true
                
                if let dutchWord = translated, !dutchWord.isEmpty {
                    self?.showTranslation(dutchWord, for: word)
                } else {
                    self?.showError("Не удалось перевести слово")
                }
            }
        }
    }
    
    @objc private func speakButtonTapped() {
        guard let dutchWord = resultLabel.text?.replacingOccurrences(of: "🇳🇱 ", with: "") else { return }
        SpeechService.shared.speak(text: dutchWord, language: "nl-NL", rate: 0.45)
    }
    
    @objc private func speakResultTapped() {
        guard !resultLabel.isHidden, resultLabel.text != "" else { return }
        speakButtonTapped()
    }
    
    // MARK: - Translation Logic
    
    private func translateWord(_ word: String,
                              from: String = "en",
                              to: String = "nl",
                              completion: @escaping (String?) -> Void) {
        
        print("Translating: \(word) (\(from) → \(to))")
        
        let encoded = word.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://api.mymemory.translated.net/get?q=\(encoded)&langpair=\(from)|\(to)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("DutchApp/1.0 (iOS)", forHTTPHeaderField: "User-Agent")
        request.timeoutInterval = 15
        
        print("Request: \(url.absoluteString)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status: \(httpResponse.statusCode)")
                if httpResponse.statusCode != 200 {
                    completion(nil)
                    return
                }
            }
            
            guard let data = data else {
                print("No data")
                completion(nil)
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response: \(jsonString.prefix(300))")
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let responseData = json["responseData"] as? [String: Any],
                   let translation = responseData["translatedText"] as? String,
                   !translation.isEmpty {
                    print("Translation: \(translation)")
                    completion(translation)
                } else {
                    print("Failed to parse JSON or empty translation")
                    completion(nil)
                }
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
    
    // MARK: - UI Updates
    
    private func resetResultViews() {
        resultLabel.text = ""
        resultLabel.textColor = .label
        pronunciationLabel.text = ""
        pronunciationLabel.isHidden = true
        definitionLabel.text = ""
        definitionLabel.isHidden = true
        speakButton.isHidden = true
    }
    
    private func showTranslation(_ dutchWord: String, for englishWord: String) {
        resultLabel.text = "🇳🇱 \(dutchWord)"
        resultLabel.textColor = .darkBlue
        speakButton.isHidden = false
        
        // Автоматическая озвучка при успешном переводе
        SpeechService.shared.speak(text: dutchWord, language: "nl-NL", rate: 0.45)
    }
    
    private func showError(_ message: String) {
        resultLabel.text = "Не найдено"
        resultLabel.textColor = .systemRed
        pronunciationLabel.isHidden = true
        definitionLabel.text = message
        definitionLabel.isHidden = false
        speakButton.isHidden = true
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Keyboard
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate

extension TranslatorViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        translateButtonTapped()
        return true
    }
    
    func textField(_ textField: UITextField,
                  shouldChangeCharactersIn range: NSRange,
                  replacementString string: String) -> Bool {
        let regex = "^[a-zA-Z\\s]*$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: string)
    }
}
