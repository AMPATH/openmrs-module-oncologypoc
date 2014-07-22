<%@ include file="/WEB-INF/template/include.jsp" %>
<spring:message var="pageTitle" code="index.title" scope="page"/>
<%@ include file="/WEB-INF/template/header.jsp" %>
<center>
	<img src="${pageContext.request.contextPath}<spring:theme code="image.logo.large"/>" alt='<spring:message code="openmrs.title"/>' title='<spring:message code="openmrs.title"/>'/>
	<br/><br/><br/>
	<openmrs:portlet url="welcome" parameters="showName=true|showLogin=true" />
</center>
<br />
<%@ include file="/WEB-INF/template/footer.jsp" %> 

