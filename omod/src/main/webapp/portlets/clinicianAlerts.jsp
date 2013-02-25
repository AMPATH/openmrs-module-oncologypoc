<%@ include file="/WEB-INF/template/include.jsp"%>
<openmrs:require privilege="View Oncology POC"
	otherwise="/login.htm"
	redirect="/module/oncologypoc/portlets/scheduledPatients.form" />

<script src="/openmrs/scripts/calendar/calendar.js"
	type="text/javascript">
</script>

<style>
	.alertHolder {
		border: 1px solid lightpink;
		padding: 5px 2px 5px 2px;
		text-align: left;
		margin-left: auto;
		margin-right: auto;
		float:right;
		width:100%;
		display: block;
	}
		
	.alertHeader {
		border: 1px solid lightpink;
		background-color: lightpink;
		display: block;
		padding: 2px;
	}
</style>
<c:set var="alertPatients" value="${model.alertPatients}"/>
<div >
	<b class=alertHeader>${model.endDate}</b>
	<div class="alertHolder">
	
		<c:if test="${fn:length(alertPatients) == 0}">
			<i> &nbsp; There are no patients scheduled for today or specified range</i><br/>
		</c:if>
		<c:if test="${fn:length(alertPatients) > 0}">
			<form id="clinicianAlerts" method="post">
				<table width="100%" border="0" cellpadding="2" background="blue" cellspacing="0">
					<tr>
						<th align="left"><spring:message code="Patient.identifier" /></th>
						<th align="left"><spring:message code="PersonName.familyName" /></th>
						<th align="left"><spring:message code="PersonName.givenName" /></th>
						<th align="left"><spring:message code="PersonName.middleName" /></th>
						<th align="center"><spring:message code="Patient.gender" /></th>
						<th align="left"><spring:message code="oncologypoc.Scheduler.scheduledPatients.returnDate.header" /></th>
					</tr>
					<c:forEach items="${alertPatients}" var="pat" varStatus="varStatus">
						<input type="hidden" name="patientId" id="patientId" value="${pat.patientId}"/>
						<tr onmouseover="this.className='searchHighlight'" onmouseout="this.className=''" onClick="JavaScript:window.location='/openmrs/module/oncologypoc/patientView.form?patientId=${pat.patientId}&phrase=${pat.patientIdentifier}';"
							class="<c:choose><c:when test="${varStatus.index % 2 == 0}">evenRow</c:when><c:otherwise>oddRow</c:otherwise></c:choose>">
							<td>${pat.patientIdentifier}</td>
							<td>${pat.familyName}</td>
							<td>${pat.givenName}</td>
							<td>${pat.middleName}</td>
							<td align="center">
								<c:choose>
								     <c:when test='${pat.gender=="M"}'>
								     	<img src="${pageContext.request.contextPath}/images/male.gif"/>
							     	</c:when>
							        <c:otherwise>
							            <img src="${pageContext.request.contextPath}/images/female.gif"/>
							        </c:otherwise>
						      	</c:choose>
							</td>
							<td><openmrs:formatDate date="${pat.returnDate}" type="short" /></td>
						</tr>
					</c:forEach>
				</table>	
			</form>
		</c:if>

	</div>
</div>
<br>
