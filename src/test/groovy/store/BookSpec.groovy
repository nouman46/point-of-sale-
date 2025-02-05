package store

import grails.testing.gorm.DomainUnitTest
import spock.lang.Specification

class BookSpec extends Specification implements DomainUnitTest<Book> {

     void "test domain constraints"() {
        when:
        Book domain = new Book()
        //TODO: Set domain props here

        then:
        domain.validate()
     }
}
