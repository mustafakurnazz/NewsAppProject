
import UIKit

final class NewsVC: UIViewController {
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var cancelButton: UIButton!
    
    private var newsArray = [NewsModel]()
    private var newsService = NewsManager()
    private var selectedNews = NewsModel(title: "", description: "", imageUrl: "", source: "", date: "", url: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsService.delegate = self
        configureUI()
    }
    
    private func configureUI() {
        cancelButton.isHidden = true
        searchTextField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    @IBAction private func searchButtonClicked(_ sender: UIButton) {
        getNews()
    }
    
    @IBAction private func cancelButtonClicked(_ sender: UIButton) {
        searchTextField.text = ""
        searchTextField.placeholder = "Type a text"
        cancelButton.isHidden = true
        newsArray.removeAll()
        tableView.reloadData()
    }
    
    private func getNews() {
        if let newsTopic = searchTextField.text {
            newsService.fetchURL(newsTopic: newsTopic)
        }
        searchTextField.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            let destinationVC = segue.destination as! DetailsVC
            destinationVC.chosenNews = selectedNews
        }
    }
}

// MARK: - NewsServiceDelegate
extension NewsVC: NewsManagerDelegate {
    func didUpdateNews(news: [NewsModel]) {
        newsArray = news
        if newsArray.count == 0 {
            DispatchQueue.main.async {
                self.errorLabel.isHidden = false
                self.errorLabel.text = "No results found for the searched text"
            }
        } else {
            DispatchQueue.main.async {
                self.errorLabel.isHidden = true
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource
extension NewsVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        let newsItem = newsArray[indexPath.row]
        if let imgUrl = newsItem.imageUrl, let title = newsItem.title, let source = newsItem.source, let date = newsItem.date{
            cell.setcell(imageUrl: imgUrl, title: title, source: source, date: date)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NewsVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedNews = newsArray[indexPath.row]
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension NewsVC: UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if searchTextField.text == "" {
            cancelButton.isHidden = true
        } else {
            cancelButton.isHidden = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        getNews()
        return true
    }
}

