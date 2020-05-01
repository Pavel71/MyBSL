//
//  NetworkEnum.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 01.05.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import Foundation


enum NetworkFirebaseError: Error {
  case createUserError
  case loadDataInStorageError
  case getImageUrlError
  case saveDocumentError
  case fetchingUserError
  case fetchUserImageError
  case fetchCurrentUserError
  case saveDataFromSettingsError
  case signInError
  case saveSwipeToFirestore
  case fetchSwipes
  
  
  case resetPasswordError
}
