//
//  AuthenticationService.swift
//  MySubscribe
//
//  Created by WebSpace Developer on 23.02.2026.
//

import Foundation
import LocalAuthentication
import OSLog

@Observable @MainActor
final class AuthenticationService {
    static let shared = AuthenticationService()
    
    private let logger = Logger(subsystem: "com.mysubscribe", category: "Authentication")
    private let lockEnabledKey = "com.mysubscribe.biometricLockEnabled"
    
    private(set) var isUnlocked = false
    private(set) var biometryType: LABiometryType = .none
    private(set) var authError: String?
    
    private(set) var isLockEnabled: Bool = false {
        didSet {
            UserDefaults.standard.set(isLockEnabled, forKey: lockEnabledKey)
            if !isLockEnabled {
                isUnlocked = true
            }
        }
    }
    
    private init() {
        isLockEnabled = UserDefaults.standard.bool(forKey: lockEnabledKey)
        refreshBiometryAvailability()
        
        // If lock is not enabled, user is unlocked by default
        if !isLockEnabled {
            isUnlocked = true
        }
    }
    
    var biometryName: String {
        switch biometryType {
        case .faceID:
            return "Face ID"
        case .touchID:
            return "Touch ID"
        case .opticID:
            return "Optic ID"
        case .none:
            return "Biometrics"
        @unknown default:
            return "Biometrics"
        }
    }
    
    var biometryIcon: String {
        switch biometryType {
        case .faceID:
            return "faceid"
        case .touchID:
            return "touchid"
        case .opticID:
            return "opticid"
        case .none:
            return "lock.fill"
        @unknown default:
            return "lock.fill"
        }
    }
    
    var isBiometryAvailable: Bool {
        let context = LAContext()
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }
    
    func refreshBiometryAvailability() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            biometryType = context.biometryType
            logger.info("Biometry available: \(self.biometryName)")
        } else {
            biometryType = context.biometryType
            if let error = error {
                logger.warning("Biometry not available: \(error.localizedDescription)")
            }
        }
    }
    
    func authenticateWithBiometrics(reason: String = "Unlock MySubscribe to access your subscriptions",
                                     completion: @escaping (Bool, Error?) -> Void) {
        let context = LAContext()
        var authError: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                   localizedReason: reason) { [weak self] success, error in
                DispatchQueue.main.async {
                    if success {
                        self?.isUnlocked = true
                        self?.authError = nil
                        self?.logger.info("Biometric authentication successful")
                    } else {
                        self?.authError = error?.localizedDescription
                        self?.logger.warning("Biometric authentication failed: \(error?.localizedDescription ?? "Unknown")")
                    }
                    completion(success, error)
                }
            }
        } else {
            DispatchQueue.main.async {
                self.authError = authError?.localizedDescription
                self.logger.warning("Biometrics not available: \(authError?.localizedDescription ?? "Unknown")")
                completion(false, authError)
            }
        }
    }
    
    func authenticate() async -> Bool {
        await withCheckedContinuation { continuation in
            authenticateWithBiometrics { success, _ in
                continuation.resume(returning: success)
            }
        }
    }
    
    func lock() {
        guard isLockEnabled else { return }
        isUnlocked = false
        logger.info("App locked")
    }
    
    func unlockIfDisabled() {
        if !isLockEnabled {
            isUnlocked = true
        }
    }
    
    func enableLockWithAuthentication(completion: @escaping (Bool) -> Void) {
        refreshBiometryAvailability()
        
        guard isBiometryAvailable else {
            logger.warning("Cannot enable lock: biometry not available")
            completion(false)
            return
        }
        
        let reason = String(localized: "Authenticate to enable \(biometryName) lock")
        
        authenticateWithBiometrics(reason: reason) { [weak self] success, _ in
            if success {
                self?.isLockEnabled = true
                self?.logger.info("Lock enabled with \(self?.biometryName ?? "biometrics")")
            }
            completion(success)
        }
    }
    
    func enableLockWithAuthentication() async -> Bool {
        await withCheckedContinuation { continuation in
            enableLockWithAuthentication { success in
                continuation.resume(returning: success)
            }
        }
    }
    
    func disableLock() {
        isLockEnabled = false
        logger.info("Lock disabled")
    }
}
