package store

import grails.testing.web.controllers.ControllerUnitTest
import spock.lang.Specification

class StoreControllerSpec extends Specification implements ControllerUnitTest<StoreController> {

     void "test index action"() {
        when:
        controller.index()

        then:
        status == 200

     }
}
