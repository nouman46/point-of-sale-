package store

import grails.testing.gorm.DomainUnitTest
import spock.lang.Specification

class SubscriptionPlanSpec extends Specification implements DomainUnitTest<SubscriptionPlan> {

     void "test domain constraints"() {
        when:
        SubscriptionPlan domain = new SubscriptionPlan()
        //TODO: Set domain props here

        then:
        domain.validate()
     }
}
