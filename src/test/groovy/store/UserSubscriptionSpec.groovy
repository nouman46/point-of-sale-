package store

import grails.testing.gorm.DomainUnitTest
import spock.lang.Specification

class UserSubscriptionSpec extends Specification implements DomainUnitTest<UserSubscription> {

     void "test domain constraints"() {
        when:
        UserSubscription domain = new UserSubscription()
        //TODO: Set domain props here

        then:
        domain.validate()
     }
}
