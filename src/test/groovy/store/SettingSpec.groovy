package store

import grails.testing.gorm.DomainUnitTest
import spock.lang.Specification

class SettingSpec extends Specification implements DomainUnitTest<Setting> {

     void "test domain constraints"() {
        when:
        Setting domain = new Setting()
        //TODO: Set domain props here

        then:
        domain.validate()
     }
}
