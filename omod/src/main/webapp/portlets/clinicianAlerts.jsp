<%@ include file="/WEB-INF/template/include.jsp"%>
<openmrs:require privilege="OncologyPoc View Clinician Alerts"
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
<c:set var="subEncounters" value="${model.subEncounters}"/>
<div >
	<b class="alertHeader">Clinical alerts</b>
	<div class="alertHolder">
		<c:if test="${fn:length(subEncounters) == 0}">
			<i> &nbsp; There are no patients scheduled for today or specified range</i><br/>
		</c:if>
		<c:if test="${fn:length(subEncounters) > 0}">
			<form id="clinicianAlerts" method="post">
				<table width="100%" border="0" cellpadding="2" background="blue" cellspacing="0">
					<tr>
						<th align="left"><spring:message code="Patient.identifier" /></th>
						<th align="left"><spring:message code="PersonName.familyName" /></th>
						<th align="left"><spring:message code="PersonName.givenName" /></th>
						<th align="left"><spring:message code="PersonName.middleName" /></th>
						<th align="center"><spring:message code="Patient.gender" /></th>
						<th align="left"><spring:message code="oncologypoc.Scheduler.scheduledPatients.entryDate.header" /></th>
					</tr>
					<c:forEach items="${subEncounters}" var="subEncounter" varStatus="varStatus">
						<input type="hidden" name="encounterId" id="encounterId" value="${subEncounter.encounterId}"/>
						<c:set var="editUrl" value="${pageContext.request.contextPath}/admin/encounters/encounter.form?encounterId=${subEncounter.encounterId}"/>
						<c:if test="${ model.formToEditUrlMap[subEncounter.encounter.form] != null }">
							<c:url var="editUrl" value="/${model.formToEditUrlMap[subEncounter.encounter.form]}">
								<c:param name="encounterId" value="${subEncounter.encounterId}"/>
							</c:url>
						</c:if>
						<tr onmouseover="this.className='searchHighlight'" onmouseout="this.className=''" onClick="JavaScript:window.location='${editUrl}';"
							class="<c:choose><c:when test="${varStatus.index % 2 == 0}">evenRow</c:when><c:otherwise>oddRow</c:otherwise></c:choose>">
							<td>${subEncounter.patient.patientIdentifier}</td>
							<td>${subEncounter.patient.familyName}</td>
							<td>${subEncounter.patient.givenName}</td>
							<td>${subEncounter.patient.middleName}</td>
							<td align="center">
								<c:choose>
								     <c:when test='${subEncounter.patient.gender=="M"}'>
								     	<img src="${pageContext.request.contextPath}/images/male.gif"/>
							     	</c:when>
							        <c:otherwise>
							            <img src="${pageContext.request.contextPath}/images/female.gif"/>
							        </c:otherwise>
						      	</c:choose>
							</td>
							<td><openmrs:formatDate date="${subEncounter.encounter.encounterDatetime}" type="short" /></td>
						</tr>
					</c:forEach>
				</table>	
			</form>
			<c:set var="page" value="${model.page}"/>
			<input type="hidden" value=${page} name="page"/>
			<table width="100%" cellpadding="8">
				<tr>
					<td align="center">
						<c:choose>
							<c:when test="${page > 1}">
								<a href="patientSearch.htm?page=${page - 2}">Previous</a>
							</c:when>
							<c:otherwise>
								Previous
							</c:otherwise>
						</c:choose> |
						<c:choose>
							<c:when test="${!model.endPage}">
								<a href="patientSearch.htm?page=${page}">Next</a>
							</c:when>
							<c:otherwise>
								Next
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
			</table>
		</c:if>

	</div>
</div>
<br>