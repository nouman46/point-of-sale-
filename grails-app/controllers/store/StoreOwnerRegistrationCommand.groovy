package store

import grails.validation.Validateable

class StoreOwnerRegistrationCommand implements  Validateable{
    String username
    String password
    String email
    String storeName
    byte[] logo
    String logoContentType
    String subscriptionPlanId

    static constraints = {
        username nullable: false, blank: false
        password nullable:false, blank: false, validator: { val, obj ->
            if (val.length() < 8) return "password.minLength"
            if (!val.any { Character.isUpperCase(it.charAt(0)) }) return "password.upperCase"
            if (!val.any { Character.isDigit(it.charAt(0)) }) return "password.digit"
        }
        email nullable: false, email: true, blank: false
        storeName nullable: false, blank: false
        logo nullable: true, maxSize: 1024 * 1024 * 5 // Max 5MB
        logoContentType nullable: true
        subscriptionPlanId blank: false
    }
}