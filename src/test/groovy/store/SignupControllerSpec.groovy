package store

import grails.testing.web.controllers.ControllerUnitTest
import spock.lang.Specification

class SignupControllerSpec extends Specification implements ControllerUnitTest<SignupController> {

     void "test index action"() {
        when:
        controller.index()

        then:
        status == 200

     }
}
