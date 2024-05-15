
import Foundation

protocol NewsManagerDelegate{
    func didUpdateNews(news: [NewsModel])
}

final class NewsManager {
    var delegate : NewsManagerDelegate?

    func fetchURL(newsTopic: String) {
        let urlString = "https://newsapi.org/v2/everything?q=\(newsTopic)&page=1&apiKey=5e71f905ed31473aaff8595392deca57"
        if let url = URL(string: urlString) {
            performRequest(url: url)
        }
    }
    
    private func performRequest(url: URL) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil{
                print(error!.localizedDescription)
            } else {
                if let safeData = data{
                    if let news = self.parseJSON(data: safeData){
                        self.delegate?.didUpdateNews(news: news)
                    }
                }
            }
        }
        task.resume()
    }
    
    private func parseJSON(data: Data) -> [NewsModel]? {
        let decoder = JSONDecoder()
        var newsArray = [NewsModel]()
        
        do{
            let decodedData = try decoder.decode(NewsData.self, from: data)
            if decodedData.articles.count == 0 { return [] }
            for count in (0 ... decodedData.articles.count - 1){
                let title = decodedData.articles[count].title
                let description = decodedData.articles[count].description
                let publishedAt = decodedData.articles[count].publishedAt
                let urlToImage = decodedData.articles[count].urlToImage
                let url = decodedData.articles[count].url
                let source = decodedData.articles[count].source?.name
                
                let news = NewsModel(title: title, description: description, imageUrl: urlToImage, source: source, date: publishedAt, url: url)
                newsArray.append(news)
            }
            return newsArray
            
        } catch {
            print(error)
            return nil
        }
    }
}
