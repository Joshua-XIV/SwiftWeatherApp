// Dev FastAPI Key

import Foundation

func fetchWeatherApiKey(completion: @escaping (String?) -> Void) {
    guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
          let plist = NSDictionary(contentsOfFile: path),
          let urlString = plist["DEV_API_KEY_URL"] as? String,
          let url = URL(string: urlString) else {
        completion(nil)
        return
    }

    let task = URLSession.shared.dataTask(with: url) { data, _, _ in
        guard let data = data,
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: String],
              let apiKey = json["api_key"] else {
            completion(nil)
            return
        }

        completion(apiKey)
    }

    task.resume()
}
