package store

import grails.validation.Validateable

class ProductCommand implements Validateable {
    String productName
    String productDescription
    String productSKU
    String productBarcode
    BigDecimal productPrice
    Integer productQuantity

    static constraints = {
        productName blank: false, nullable: false, validator: { val, obj ->
            if ((val == null || val == '')) {
                return 'productNameNullNotAllowed'
            }
        }
        productDescription blank: false, nullable: false, validator: { val, obj ->
            if ((val == null || val == '')) {
                return 'productDescriptionNullNotAllowed'
            }
        }
        productSKU blank: false, nullable: false, validator: { val, obj ->
            if ((val == null || val == '')) {
                return 'productSKUNullNotAllowed'
            }
        }
        productBarcode blank: false, nullable: false, validator: { val, obj ->
            if ((val == null || val == '')) {
                return 'productBarcodeNullNotAllowed'
            }
        }
        productPrice blank: false, nullable: false, validator: { val, obj ->
            if ((val == null || val <= 0)) {
                return 'productPriceInvalid'
            }
        }
        productQuantity blank: false, nullable: false, validator: { val, obj ->
            if ((val == null || val < 0)) {
                return 'productQuantityInvalid'
            }
        }
    }
}