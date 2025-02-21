package store

import grails.testing.gorm.DomainUnitTest
import spock.lang.Specification

class StoreOwnerSpec extends Specification implements DomainUnitTest<StoreOwner> {

     void "test domain constraints"() {
        when:
        StoreOwner domain = new StoreOwner()
        //TODO: Set domain props here

        then:
        domain.validate()
     }
}
