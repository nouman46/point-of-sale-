<tr>
    <td>${product.productName}</td>
    <td class="item-price">${product.productPrice}</td>
    <td>
        <input type="number" name="quantity" value="1" min="1" class="quantity-input" required>
    </td>
    <td class="item-total">${product.productPrice} PKR</td>
    <td>
        <button type="button" class="btn btn-danger remove-item">Remove</button>
    </td>
    <!-- Add a hidden element to store the barcode -->
    <td style="display: none;">
        <span class="product-barcode">${product.productBarcode}</span>
    </td>
</tr>