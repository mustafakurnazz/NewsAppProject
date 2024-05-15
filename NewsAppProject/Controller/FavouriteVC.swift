
import UIKit

final class FavouriteVC: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private var defaults = UserDefaults.standard
    private var favouriteNews = [NewsModel]()
    private var selectedNews = NewsModel(title: "", description: "", imageUrl: "", source: "", date: "", url: "")
    
    override func viewWillAppear(_ animated: Bool) {
        configureUI()
    }
    
    private func configureUI() {
        
        if let data = defaults.data(forKey: "favNews") {
            do {
                let decoder = JSONDecoder()
                
                let notes = try decoder.decode([NewsModel].self, from: data)
                favouriteNews = notes
            } catch {
                print("Kod çözülemedi \(error)")
            }
        }
        
        tableView.reloadData()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favToDetailsVC" {
            let destinationVC = segue.destination as! DetailsVC
            destinationVC.chosenNews = selectedNews
        }
    }
}

// MARK: - UITableViewDataSource
extension FavouriteVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        let newsItem = favouriteNews[indexPath.row]
        if let imgUrl = newsItem.imageUrl, let title = newsItem.title, let source = newsItem.source, let date = newsItem.date{
            cell.setcell(imageUrl: imgUrl, title: title, source: source, date: date)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FavouriteVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedNews = favouriteNews[indexPath.row]
        performSegue(withIdentifier: "favToDetailsVC", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
