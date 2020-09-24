import Foundation

public struct AppVersion {

    public let major: Int
    public let minor: Int
    public let patch: Int

    public init(
        major: Int,
        minor: Int,
        patch: Int
    ) {
        self.major = major
        self.minor = minor
        self.patch = patch
    }

    public static let zero = AppVersion.init(major: 0, minor: 0, patch: 0)
}

public extension AppVersion {
    init?(_ value: String) {
        let values = value.split(separator: ".")
        guard
            values.count == 3,
            let major = Int(values[0]),
            let minor = Int(values[1]),
            let patch = Int(values[2])
        else {
            return nil
        }
        self.major = major
        self.minor = minor
        self.patch = patch
    }
}

extension AppVersion: Comparable {
    public static func < (lhs: AppVersion, rhs: AppVersion) -> Bool {
        if lhs.major != rhs.major { return lhs.major < rhs.major }
        if lhs.minor != rhs.minor { return lhs.minor < rhs.minor }
        return lhs.patch < rhs.patch
    }
}

extension AppVersion: CustomStringConvertible {
    public var description: String {
        "\(major).\(minor).\(patch)"
    }
}

public extension AppVersion {
    static func storeVersion(
        bundleId: String = Bundle.main.bundleIdentifier!, // Never nil
        session: URLSession = URLSession.shared,
        completion: @escaping (Result<(storeVersion: AppVersion, storeUrl: URL), Error>) -> Void
    ) {
        let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(bundleId)")!
        session.dataTask(with: url) { result in
            switch result {
            case .success(let data):
                guard
                    let object = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                    let count = object["resultCount"] as? Int, count > 0,
                    let first = object["results"] as? [Any], first.count > 0,
                    let info = first[0] as? [String: Any],
                    let versionString = info["version"] as? String,
                    let storeVersion = AppVersion(versionString),
                    let urlString = info["trackViewUrl"] as? String,
                    let storeUrl = URL(string: urlString)
                else {
                    completion(.failure(NSError(domain: "com.appupdater", code: -2, userInfo: nil)))
                    return
                }
                completion(.success((storeVersion, storeUrl)))
            case .failure(let error):
                completion(.failure(error))
            }
        }.resume()
    }
}

extension URLSession {

    public func dataTask(with url: URL, completionHandler: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: url, completionHandler: { (data, _, error) in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            guard let data = data else {
                completionHandler(.failure(NSError(domain: "com.appupdater", code: -1, userInfo: [:])))
                return
            }
            completionHandler(.success(data))
        })
    }
}

public extension Bundle {

    var semanticVersion: String {
        return object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0.0.0"
    }

    var buildNumber: String {
        return object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "0"
    }

    var appVersion: AppVersion {
        return AppVersion(semanticVersion) ?? .zero
    }
}
