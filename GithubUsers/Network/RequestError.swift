//
//  RequestError.swift
//  GithubUsers
//
//  Created by Thinh Le on 10/08/2021.
//

import Foundation

enum RequestError: Error {
  case underlying
  case cancelled
  case invalidResponse(Error)
  case exception(Exception)
}

enum Exception: String, Decodable {
  case authentication = "AuthenticationException"
  case unauthorized = "UnauthorizedException"
  case profanity = "ProfanityException"
  case notFoundHttp = "NotFoundHttpException"
  case loginBonusException = "LoginBonusException"
  case error = "ErrorException"
}
