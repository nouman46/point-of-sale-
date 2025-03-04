<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
</head>
<body>
<div class="main-content">
    <h1>Select a Theme</h1>
    <g:link controller="theme" action="switchTheme" params="[theme: 'default']">Default Theme</g:link><br/>
    <g:link controller="theme" action="switchTheme" params="[theme: 'dark']">Dark Theme</g:link><br/>
    <g:link controller="theme" action="switchTheme" params="[theme: 'blue-ocean']">Blue Ocean Theme</g:link><br/>
    <g:link controller="theme" action="switchTheme" params="[theme: 'warm-sunset']">Warm Sunset Theme</g:link>
</div>
</body>
</html>