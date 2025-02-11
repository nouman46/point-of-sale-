package store

import grails.gorm.transactions.Transactional
import org.springframework.context.event.EventListener
import org.grails.datastore.mapping.engine.event.AbstractPersistenceEvent

class UserPasswordEncoderListener {
    def passwordEncoder

    // Add a check to ensure the password is not null or empty before encoding
    def onSaveOrUpdate(event) {
        def user = event.entity
        if (user.password && user.password != '') {
            user.password = passwordEncoder.encode(user.password)
        }
    }
}
