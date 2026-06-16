import UIKit

final class TranslatorViewController: UIViewController {

    // MARK: - Language Pills

    private let fromPillView: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.darkBlue.withAlphaComponent(0.08)
        container.layer.cornerRadius = 18
        container.layer.cornerCurve = .continuous
        container.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = "🇬🇧  English"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .darkBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 18),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -18)
        ])
        return container
    }()

    private let arrowLabel: UILabel = {
        let label = UILabel()
        label.text = "→"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = UIColor.darkBlue.withAlphaComponent(0.35)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let toPillView: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.darkBlue.withAlphaComponent(0.08)
        container.layer.cornerRadius = 18
        container.layer.cornerCurve = .continuous
        container.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = "🇳🇱  Dutch"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .darkBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 18),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -18)
        ])
        return container
    }()

    private lazy var pillsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [fromPillView, arrowLabel, toPillView])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - UI Elements

    private let inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter an English word..."
        textField.borderStyle = .none
        textField.font = .systemFont(ofSize: 18)
        textField.layer.borderWidth = 1.5
        textField.layer.borderColor = UIColor.darkBlue.withAlphaComponent(0.2).cgColor
        textField.layer.cornerRadius = 12
        textField.layer.cornerCurve = .continuous
        textField.backgroundColor = .systemBackground
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.returnKeyType = .done
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        return textField
    }()

    private let translateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Translate", for: .normal)
        button.applyStyle()
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
        button.backgroundColor = UIColor.darkBlue.withAlphaComponent(0.1)
        button.layer.cornerRadius = 22
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()

    // MARK: - Result Card

    private let resultCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.layer.cornerCurve = .continuous
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor.darkBlue.withAlphaComponent(0.2).cgColor
        view.layer.shadowColor = UIColor.darkBlue.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 10
        view.alpha = 0
        view.transform = CGAffineTransform(translationX: 0, y: 16)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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

        inputTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 50))
        inputTextField.leftViewMode = .always

        [pillsStackView, inputTextField, translateButton, loadingIndicator, resultCardView]
            .forEach { view.addSubview($0) }

        [resultLabel, pronunciationLabel, definitionLabel, speakButton]
            .forEach { resultCardView.addSubview($0) }

        NSLayoutConstraint.activate([
            pillsStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            pillsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            inputTextField.topAnchor.constraint(equalTo: pillsStackView.bottomAnchor, constant: 32),
            inputTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            inputTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            inputTextField.heightAnchor.constraint(equalToConstant: 50),

            translateButton.topAnchor.constraint(equalTo: inputTextField.bottomAnchor, constant: 20),
            translateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            translateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            translateButton.heightAnchor.constraint(equalToConstant: 50),

            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.topAnchor.constraint(equalTo: translateButton.bottomAnchor, constant: 30),

            resultCardView.topAnchor.constraint(equalTo: loadingIndicator.bottomAnchor, constant: 24),
            resultCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            speakButton.topAnchor.constraint(equalTo: resultCardView.topAnchor, constant: 20),
            speakButton.trailingAnchor.constraint(equalTo: resultCardView.trailingAnchor, constant: -16),
            speakButton.widthAnchor.constraint(equalToConstant: 44),
            speakButton.heightAnchor.constraint(equalToConstant: 44),

            resultLabel.topAnchor.constraint(equalTo: resultCardView.topAnchor, constant: 22),
            resultLabel.leadingAnchor.constraint(equalTo: resultCardView.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: speakButton.leadingAnchor, constant: -12),

            pronunciationLabel.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 8),
            pronunciationLabel.leadingAnchor.constraint(equalTo: resultCardView.leadingAnchor, constant: 20),
            pronunciationLabel.trailingAnchor.constraint(equalTo: resultCardView.trailingAnchor, constant: -20),

            definitionLabel.topAnchor.constraint(equalTo: pronunciationLabel.bottomAnchor, constant: 8),
            definitionLabel.leadingAnchor.constraint(equalTo: resultCardView.leadingAnchor, constant: 20),
            definitionLabel.trailingAnchor.constraint(equalTo: resultCardView.trailingAnchor, constant: -20),
            definitionLabel.bottomAnchor.constraint(equalTo: resultCardView.bottomAnchor, constant: -20)
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
            showAlert(title: "Error", message: "Please enter a word to translate")
            return
        }

        let word = text.trimmingCharacters(in: .whitespaces).lowercased()

        loadingIndicator.startAnimating()
        translateButton.isEnabled = false
        resetResultViews()

        Task {
            do {
                let translated = try await translateWord(word, from: "en", to: "nl")
                await MainActor.run {
                    loadingIndicator.stopAnimating()
                    translateButton.isEnabled = true
                    showTranslation(translated, for: word)
                }
            } catch {
                await MainActor.run {
                    loadingIndicator.stopAnimating()
                    translateButton.isEnabled = true
                    showError("Could not translate the word")
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

    private func translateWord(_ word: String, from: String = "en", to: String = "nl") async throws -> String {
        print("Translating: \(word) (\(from) → \(to))")

        // MARK: URLComponents encodes query parameters correctly
        var components = URLComponents(string: "https://api.mymemory.translated.net/get")
        components?.queryItems = [
            URLQueryItem(name: "q", value: word),
            URLQueryItem(name: "langpair", value: "\(from)|\(to)")
        ]
        guard let url = components?.url else {
            print("Invalid URL")
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.setValue("DutchApp/1.0 (iOS)", forHTTPHeaderField: "User-Agent")
        request.timeoutInterval = 15

        print("Request: \(url.absoluteString)")

        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse {
            print("Status: \(httpResponse.statusCode)")
            guard httpResponse.statusCode == 200 else {
                throw NetworkError.serverError(statusCode: httpResponse.statusCode)
            }
        }

        if let jsonString = String(data: data, encoding: .utf8) {
            print("Response: \(jsonString.prefix(300))")
        }

        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let responseData = json["responseData"] as? [String: Any],
           let translation = responseData["translatedText"] as? String,
           !translation.isEmpty {
            let decoded = translation.removingPercentEncoding ?? translation
            print("Translation: \(decoded)")
            return decoded
        }

        print("Failed to parse JSON or empty translation")
        throw NetworkError.decodingError
    }

    // MARK: - UI Updates

    private func resetResultViews() {
        resultCardView.alpha = 0
        resultCardView.transform = CGAffineTransform(translationX: 0, y: 16)
        resultLabel.text = ""
        resultLabel.textColor = .label
        pronunciationLabel.text = ""
        pronunciationLabel.isHidden = true
        definitionLabel.text = ""
        definitionLabel.isHidden = true
        speakButton.isHidden = true
        resultCardView.layer.borderColor = UIColor.darkBlue.withAlphaComponent(0.2).cgColor
    }

    private func showTranslation(_ dutchWord: String, for englishWord: String) {
        resultLabel.text = "🇳🇱 \(dutchWord)"
        resultLabel.textColor = .darkBlue
        speakButton.isHidden = false
        resultCardView.layer.borderColor = UIColor.darkBlue.withAlphaComponent(0.2).cgColor

        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.5, options: []) {
            self.resultCardView.alpha = 1
            self.resultCardView.transform = .identity
        }

        // Автоматическая озвучка при успешном переводе
        SpeechService.shared.speak(text: dutchWord, language: "nl-NL", rate: 0.45)
    }

    private func showError(_ message: String) {
        resultLabel.text = "Not found"
        resultLabel.textColor = .systemRed
        pronunciationLabel.isHidden = true
        definitionLabel.text = message
        definitionLabel.isHidden = false
        speakButton.isHidden = true
        resultCardView.layer.borderColor = UIColor.systemRed.withAlphaComponent(0.4).cgColor

        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.5, options: []) {
            self.resultCardView.alpha = 1
            self.resultCardView.transform = .identity
        }
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
