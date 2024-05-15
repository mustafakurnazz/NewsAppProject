
import UIKit

final class DetailsVC: UIViewController {
    @IBOutlet private weak var newsImageView: UIImageView!
    @IBOutlet private weak var newsTitleLabel: UILabel!
    @IBOutlet private weak var newsSourceLabel: UILabel!
    @IBOutlet private weak var newsDateLabel: UILabel!
    @IBOutlet private weak var newsDescriptionLabel: UILabel!
    @IBOutlet private weak var favouriteButton: UIBarButtonItem!
    
    var chosenNews = NewsModel(title: "", description: "", imageUrl: "", source: "", date: "", url: "")
    private var favouriteNews = [NewsModel]()
    private var imageData = Data()
    private var urlToImage = String()
    private var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLabel()
        configureUI()
    }
    
    private func configureUI() {
        if let data = defaults.data(forKey: "favNews") {
            do {
                let decoder = JSONDecoder()
                let notes = try decoder.decode([NewsModel].self, from: data)
                favouriteNews = notes
            } catch {
                print("Code could not be decoded \(error)")
            }
        }
        
        if let date = chosenNews.date, let imgData = chosenNews.imageUrl{
            newsDateLabel.text = setDate(date: date)
            urlToImage = imgData
        }
        newsTitleLabel.text = chosenNews.title
        newsSourceLabel.text = chosenNews.source
        newsDescriptionLabel.text = chosenNews.description

        if let url = URL(string: urlToImage) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
              guard let imageData = data else { return }
              DispatchQueue.main.async {
                  self.newsImageView.image = UIImage(data: imageData)
              }
            }.resume()
        }
    }
    
    private func setDate(date: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        
        if let newDate = dateFormatterGet.date(from: date) {
            return dateFormatterPrint.string(from: newDate)
        } else { return "----" }
    }
    
    private func setLabel(){
        newsTitleLabel.adjustsFontSizeToFitWidth = true
        newsTitleLabel.minimumScaleFactor = 0.5
        newsSourceLabel.adjustsFontSizeToFitWidth = true
        newsSourceLabel.minimumScaleFactor = 0.5
        newsDateLabel.adjustsFontSizeToFitWidth = true
        newsDateLabel.minimumScaleFactor = 0.5
        newsDescriptionLabel.adjustsFontSizeToFitWidth = true
        newsDescriptionLabel.minimumScaleFactor = 0.5
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWebView" {
            let destinationVC = segue.destination as! NewsSourceVC
            if let loadUrl = chosenNews.url {
                destinationVC.loadUrl = loadUrl
            }
        }
    }
    
    @IBAction private func favouriteButtonClicked(_ sender: UIBarButtonItem) {
        if !favouriteNews.contains(where: {$0.description == chosenNews.description}) {
            favouriteNews.append(chosenNews)
        } else {
            if let index = self.favouriteNews.firstIndex(where: {$0.description == chosenNews.description}) {
                favouriteNews.remove(at: index)
            }
        }
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(self.favouriteNews)
            self.defaults.set(data, forKey: "favNews")
            print(data)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction private func actionButtonClicked(_ sender: UIBarButtonItem) {
        let message = "share link"
        if let link = NSURL(string: chosenNews.url!)
        {
            let objectsToShare = [message,link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop,
                                                UIActivity.ActivityType.mail,
                                                UIActivity.ActivityType.postToFacebook,
                                                UIActivity.ActivityType.postToTwitter,
            ]
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    
    @IBAction private func newsSourceButtonClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "toWebView", sender: nil)
    }
}
