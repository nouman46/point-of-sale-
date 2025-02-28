package store

import grails.gorm.transactions.Transactional
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder

class RegistrationService {
    def passwordEncoder = new BCryptPasswordEncoder()

    @Transactional
    def registerStoreOwner(StoreOwnerRegistrationCommand cmd, logoFile) {
        def appUser = new AppUser(
                username: cmd.username,
                password: passwordEncoder.encode(cmd.password),
                isAdmin: true)

        def storeOwner = new StoreOwner(
                email: cmd.email,
                storeName: cmd.storeName,
                appUser: appUser
        )

        if (AppUser.findByUsername(cmd.username)) {
            appUser.errors.rejectValue('username', 'appUser.username.unique', 'Username already exists')
            return [appUser: appUser, storeOwner: storeOwner, errors: true]
        }

        if (StoreOwner.findByEmail(cmd.email)) {
            storeOwner.errors.rejectValue('email', 'storeOwner.email.unique', 'Email already exists')
            return [appUser: appUser, storeOwner: storeOwner, errors: true]
        }

        if (logoFile && !logoFile.isEmpty()) {
            storeOwner.logo = logoFile.bytes
            storeOwner.logoContentType = logoFile.contentType
        }

        if (!appUser.validate() || !storeOwner.validate()) {
            return [appUser: appUser, storeOwner: storeOwner, errors: true]
        }

        appUser.save(flush: true)
        storeOwner.save(flush: true)

        return [appUser: appUser, storeOwner: storeOwner, errors: false]

    }
}