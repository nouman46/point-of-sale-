<g:if test="${ProductInfo.hasErrors()}">
  <div class="alert alert-danger">
    <g:eachError bean="${ProductInfo}">
      <p><g:message error="${it}"/></p>
    </g:eachError>
  </div>
</g:if>
<g:else>
  <div class="alert alert-success">
    <g:message code="Product Created successfully" />
  </div>
</g:else>