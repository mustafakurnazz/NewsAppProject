
import Foundation

struct NewsData: Decodable{
    let articles: [Articles]
}

struct Articles: Decodable{
    let title: String?
    let description: String?
    let urlToImage: String?
    let publishedAt: String?
    let url: String?
    let source: Source?
}

struct Source: Decodable{
    let name: String?
}
