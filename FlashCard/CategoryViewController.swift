import UIKit

struct Word: Decodable {
    var english: String
    var turkish: String
}

protocol CategoryViewControllerDelegate: AnyObject {
    func didSelectWords(_ words: [Word])
}

class CategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    weak var delegate: CategoryViewControllerDelegate?
    
    private var categories: [String] = []
    private var wordsByCategory: [String: [Word]] = [:]
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationItem.title = "Categories"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "categoryCell")
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        loadCategoriesFromJSON()
    }
    
    private func loadCategoriesFromJSON() {
        if let url = Bundle.main.url(forResource: "categories", withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            let decoder = JSONDecoder()
            do {
                let categoriesData = try decoder.decode([String: [Word]].self, from: data)
                self.wordsByCategory = categoriesData
                self.categories = Array(categoriesData.keys)
                tableView.reloadData()
            } catch {
                print("Error decoding JSON: \(error)")
            }
        } else {
            print("Error loading JSON file")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let category = categories[indexPath.row]
        cell.textLabel?.text = category
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = categories[indexPath.row]
        let wordsForCategory = wordsByCategory[selectedCategory] ?? []
        
        delegate?.didSelectWords(wordsForCategory)
        
        navigationController?.popViewController(animated: true)
    }
}
