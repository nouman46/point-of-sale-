import groovy.json.JsonSlurper
import groovy.json.JsonBuilder

class Checkout {
    String customerName
    String status // e.g., 'pending', 'completed'
    BigDecimal totalAmount
    String purchasedItemsMap // Store the Map as a JSON string

    static constraints = {
        customerName blank: false, maxSize: 255
        status blank: false, maxSize: 50
        totalAmount min: 0.00
        purchasedItemsMap nullable: true
    }

    // Get the purchased items as a Map
    Map getPurchasedItems() {
        return purchasedItemsMap ? new JsonSlurper().parseText(purchasedItemsMap) : [:]
    }

    // Set the purchased items from a Map and save it as a JSON string
    void setPurchasedItems(Map items) {
        purchasedItemsMap = new JsonBuilder(items).toString()
    }
}
