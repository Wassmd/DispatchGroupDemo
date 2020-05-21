import UIKit

class ViewController: UIViewController {

    private var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Search"
        label.textAlignment = .left

        return label
    }()

    let partners = [
        "EMP 🤘",
        "QVC.de Online-Shop 📺",
        "The North Face ⬆️",
        "ABOUT YOU 👕",
        "abracar 🚗",
        "adidas 👟",
        "342!!! Online Shops ...",
        "... danke, dass du so lange schaust 😎",
        "Online Shops suchen",
        "Prämienshop 🎁",
        "Dyson 🌪️",
        "Lieferando 🍕 🍔 🍣",
        "Zalando Lounge 👚",
        "1-2-3.tv 🔨",
        "H&M 👖",
        "Otto 🏠 👜",
        "OTTO Office 🏢",
        "Tchibo ☕",
        "Blue Tomato 🏂"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        dispatchGroupDemo()
        semaphoreDemo()

        print("\(Date()) Waiting images to finish fetching...")

        setupSubViews()
        setupConstraints()

        showPartners()
    }


    private func setupSubViews() {
        view.addSubview(label)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    var timer: Timer?
    var timer1: Timer?
    var timer2: Timer?
    private func showPartners() {
        startAnother()
    }

    lazy var totalCount = partners.count
    var position = 0

    private func startAnother() {
         label.text = ""
        if position == totalCount { position = 0 }
        let text = partners[position]
        startTyping(text: text)
        position += 1
    }

    private func startTyping(text: String) {
        let charactersCount = text.count
         var position = 0
        timer1 = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] _ in
            if position == (charactersCount) {
                self?.timer1?.invalidate()
                self?.deleteTyping(text)
                return

            }
            self?.label.text?.append(text[position])

            position += 1
        }
    }

    private func deleteTyping(_ text: String) {
        let charactersCount = text.count
         var position = charactersCount - 1
        timer2 = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            if position == -1 {
                self?.timer2?.invalidate()

                self?.startAnother()
                return

            }
            self?.label.text?.removeLast()
            position -= 1
        }
    }

    private func fetchImage(completion: @escaping(UIImage, Error?) -> Void) {
        let randomNumber = Int.random(in: 3...10)
        print("RandomNumber:\(randomNumber)")
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(randomNumber)) {
            completion(UIImage(), nil)
        }
    }

    private func dispatchGroupDemo() {
        print("------dispatchGroupDemo------")

        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        fetchImage { image, error in
            print("\(Date()) finished fetching image 1: \(image)")
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        fetchImage { image, error in
            print("\(Date()) finished fetching image 2: \(image)")
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        fetchImage { image, error in
            print("\(Date()) finished fetching image 3: \(image)")
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            print("\(Date()) Finished fetching images.")
            self.updateUI()
        }
    }

    private func semaphoreDemo() {
        print("------Semaphore------")

        let semaphore = DispatchSemaphore(value: 0)
        let dispatchQueue = DispatchQueue.global(qos: .userInteractive)

        dispatchQueue.async {
            self.fetchImage { image, error in
                print("\(Date()) finished fetching image 1: \(image)")
                semaphore.signal()
            }
            semaphore.wait()

            self.fetchImage { image, error in
                print("\(Date()) finished fetching image 2: \(image)")
                semaphore.signal()
            }
            semaphore.wait()

            self.fetchImage { image, error in
                print("\(Date()) finished fetching image 3: \(image)")
                semaphore.signal()
            }

            semaphore.wait()

            self.updateUI()
        }
    }

    private func updateUI() {
        print("Update UI")
    }
}

private extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}
