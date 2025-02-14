package store
import grails.gorm.transactions.Rollback
import grails.testing.mixin.integration.Integration

import geb.spock.*
import spock.lang.Ignore

/**
 * See https://www.gebish.org/manual/current/ for more instructions
 */
@Integration
@Rollback
class StoreSpec extends GebSpec {
    @Ignore
    void "test something"() {
        when:"The home page is visited"
            go '/'

        then:"The title is correct"
            title == "Welcome to Grails"
    }

}
