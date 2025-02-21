package store

import grails.testing.web.controllers.ControllerUnitTest
import spock.lang.Specification

class SettingControllerSpec extends Specification implements ControllerUnitTest<SettingController> {

     void "test index action"() {
        when:
        controller.index()

        then:
        status == 200

     }
}
