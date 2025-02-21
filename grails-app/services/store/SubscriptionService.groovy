package store

import groovy.transform.CompileStatic

@CompileStatic
class SubscriptionService {

    Date calculateEndDate(Integer billingCycle) {
        Calendar cal = Calendar.getInstance()
        cal.add(Calendar.MONTH, billingCycle)
        return cal.time
    }
}