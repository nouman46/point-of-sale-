<html>
    <head>
        <title>Settings</title>
          <meta name="layout" content="main" />
    </head>
    <body>
        <h1>Settings</h1>
        <g:form action="update">
            <g:each in="${settings.groupBy { it.category } }" var="group">
                <h2>${group.key}</h2>
                <g:each in="${group.value}" var="setting">
                    <div>
                            <h3>${setting.description}</h3>
                        <g:if test="${setting.type == 'string'}">
                            <g:textField name="setting_${setting.key}" value="${setting.value}"/>
                        </g:if>
                        <g:elseif test="${setting.type == 'boolean'}">
                            <g:checkBox name="setting_${setting.key}" checked="${setting.value == 'true'}"/>
                        </g:elseif>
                        <g:elseif test="${setting.type == 'integer'}">
                            <g:field type="number" name="setting_${setting.key}" value="${setting.value}"/>
                        </g:elseif>
                    </div>
                </g:each>
            </g:each>
            <g:submitButton name="save" value="Save"/>
        </g:form>
    </body>
</html>