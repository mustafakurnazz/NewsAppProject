
import UIKit

final class NewsCell: UITableViewCell {
    @IBOutlet private weak var newsImageView: UIImageView!
    @IBOutlet private weak var newsTitle: UILabel!
    @IBOutlet private weak var newsSource: UILabel!
    @IBOutlet private weak var newsDate: UILabel!
    
    private var imageData = Data()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setLabel()
    }
    
    private func setLabel(){
        newsTitle.adjustsFontSizeToFitWidth = true
        newsTitle.minimumScaleFactor = 0.5
        newsSource.adjustsFontSizeToFitWidth = true
        newsSource.minimumScaleFactor = 0.5
        newsDate.adjustsFontSizeToFitWidth = true
        newsDate.minimumScaleFactor = 0.5
    }

    func setcell(imageUrl : String , title : String , source : String , date : String){
        newsTitle.text = title
        newsSource.text = source
        newsDate.text = setDate(date: date)
        
        if let url = URL(string: imageUrl) {
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
}
