//

import Foundation
import ES256SwiftJWT

public final class AppStoreConnectJWTGenerator {
	public init() {}
	
	/// Generates signed JWT token.
	///
	/// Value of `config.tokenLifeTime` will be used if passed `tokenLifetime` is nil.
	///
	/// See: https://developer.apple.com/documentation/appstoreconnectapi/generating_tokens_for_api_requests
	///
	/// - Parameter creationTime: The token’s creation time.
	/// - Parameter tokenLifeTime: Seconds the generated token is valid after `creationTime`.
	///   In most cases App Store Connect will refuse token with `lifetime` greater than 20 minutes (1200 seconds).
	/// - Parameter scope: A list of operations you want App Store Connect to allow for this token;
	///   for example, GET /v1/apps/123. (Optional).
	public func generateToken(
		config: Config,
		creationTime: Date = Date(),
		tokenLifeTime: TimeInterval = 20 * 60,
		scope: [String]? = nil
	) throws -> AppStoreConnectJWTToken {
		let header = Header(kid: config.keyIdentifier)
		
		let claims = AppStoreConnectTokenClaims(
			iss: config.issuerID,
			iat: creationTime,
			exp: creationTime + tokenLifeTime,
			scope: scope
		)
		
		var myJWT = JWT(header: header, claims: claims)
		let jwtSigner = JWTSigner.es256(privateKey: config.privateKey)
		let signedJWT = try myJWT.sign(using: jwtSigner)
		
		return AppStoreConnectJWTToken(
			jwtString: signedJWT,
			creationTime: claims.iat,
			expirationTime: claims.exp,
			scope: claims.scope
		)
	}
}
