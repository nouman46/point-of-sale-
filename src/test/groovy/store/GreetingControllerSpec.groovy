package store

import grails.testing.web.controllers.ControllerUnitTest
import spock.lang.Specification

class GreetingControllerSpec extends Specification implements ControllerUnitTest<GreetingController> {

     void "test index action"() {
        when:
        controller.index()

        then:
        status == 200

     }
}
