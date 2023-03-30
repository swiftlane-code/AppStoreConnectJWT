//

import Foundation
import ES256SwiftJWT

/// Details: https://developer.apple.com/documentation/appstoreconnectapi/generating_tokens_for_api_requests
struct AppStoreConnectTokenClaims: Claims, Equatable {
	/// Issuer ID: Your issuer ID from the API Keys page in App Store Connect; for example, 57246542-96fe-1a63-e053-0824d011072a.
	let iss: String
	/// The token’s creation time, in UNIX epoch time; for example, 1528407600.
	let iat: Date
	/// The token’s expiration time in Unix epoch time. Tokens that expire more than 20 minutes into the future are not valid except for resources listed in Determine the Appropriate Token Lifetime.
	let exp: Date
	/// Audience
	var aud: String = "appstoreconnect-v1"
	/// A list of operations you want App Store Connect to allow for this token; for example, GET /v1/apps/123. (Optional)
	var scope: [String]?
}
