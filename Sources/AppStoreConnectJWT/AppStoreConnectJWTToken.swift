//

import Foundation

public struct AppStoreConnectJWTToken {
	/// JWT token string iself.
	public let jwtString: String
	/// The token’s creation time, in UNIX epoch time; for example, 1528407600.
	public let creationTime: Date
	/// The token’s expiration time in Unix epoch time. Tokens that expire more than 20 minutes into the future are not valid except for resources listed in Determine the Appropriate Token Lifetime.
	public let expirationTime: Date
	/// A list of operations you want App Store Connect to allow for this token; for example, GET /v1/apps/123. (Optional)
	public let scope: [String]?
	
	public func isExpired(after date: Date = Date()) -> Bool {
		date > expirationTime
	}
	
	/// HTTP header `"Authorization": "Bearer <jwtString>"` to be used in requests to App Store Connect API.
	public var httpHeader: (key: String, value: String) {
		("Authorization", "Bearer \(jwtString)")
	}
}
