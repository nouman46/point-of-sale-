<!-- grails-app/views/order/_itemRow.gsp -->
<tr>
    <td>
        ${product.productName}
        <span class="product-barcode" style="display: none;">${product.productBarcode}</span> <!-- Hidden barcode -->
    </td>
    <td class="item-price">${product.productPrice}</td>
    <td>
        <input type="number" name="quantity" value="1" min="1" class="quantity-input" required>
        <span class="error-message item-error"></span> <!-- Error placeholder next to quantity -->
    </td>
    <td class="item-total">${product.productPrice} PKR</td>
    <td>
        <button type="button" class="btn btn-danger remove-item">Remove</button>
    </td>
</tr>