package store

import grails.testing.web.controllers.ControllerUnitTest
import spock.lang.Specification

class StoreOwnerControllerSpec extends Specification implements ControllerUnitTest<StoreOwnerController> {

     void "test index action"() {
        when:
        controller.index()

        then:
        status == 200

     }
}
