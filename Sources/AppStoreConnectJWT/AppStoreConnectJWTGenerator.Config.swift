//

import Foundation

extension AppStoreConnectJWTGenerator {
	/// Data used to generate JWT token for App Store Connect API requests.
	public struct Config {
		let keyIdentifier: String
		let issuerID: String
		let privateKey: Data
		
		/// - Parameter keyIdentifier: Your private key ID from App Store Connect;
		///   for example 2X9R4HXF34. This is the `XXX` part of `AuthKey_XXX.p8` file name.
		///
		/// - Parameter issuerID: Your issuer ID from the API Keys page in App Store Connect;
		///   for example, 57246542-96fe-1a63-e053-0824d011072a.
		///
		/// - Parameter privateKey: utf8-encoded PEM private key
		///   including the "BEGIN CERTIFICATE/END CERTIFICATE" statements.
		///   Contents of your `AuthKey_XXX.p8` file.
		public init(
			keyIdentifier: String,
			issuerID: String,
			privateKey: Data
		) {
			self.keyIdentifier = keyIdentifier
			self.issuerID = issuerID
			self.privateKey = privateKey
		}
	}
}
