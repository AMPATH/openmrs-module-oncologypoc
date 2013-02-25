<%@ include file="/WEB-INF/template/include.jsp"%>
<openmrs:require privilege="View Oncology POC"
	otherwise="/login.htm"
	redirect="/module/oncologypoc/portlets/patientSearch.htm" />

<script src="/openmrs/scripts/calendar/calendar.js"
	type="text/javascript">
</script>

<c:set var="patients" value="${model.patients}"/>
<div class="scheduledPatients" style="width:100%">
	<b class="boxHeader" style="width:100%">
		<spring:message code="oncologypoc.Scheduler.scheduledPatients.title"/> 
		<c:choose>
		     <c:when test='${model.endDate==model.startDate}'>
		     	[${model.startDate}]
	     	</c:when>
	        <c:otherwise>
	        	[${model.startDate} --> ${model.endDate}]
	        </c:otherwise>
      	</c:choose>
	</b>
	<div class="box" style="width:100%">
		<form action="" method="post">
			<table>	
				<tr>
					<td>From:</td>
					<td><input type="text" name="fromDate" size="10" value=""
						onClick="showCalendar(this)" /></td>
					<td>&nbsp;&nbsp;&nbsp;To:</td>
					<td><input type="text" name="toDate" size="10" value=""
						onClick="showCalendar(this)" /></td>
					<td><input type="submit" name="generateScheduledList" id="scheduledList" size="11" value="Get Schedule" /></td>
				</tr>
			</table>
		</form>
		<br>
		<c:if test="${fn:length(patients) == 0}">
			<i> &nbsp; There are no patients scheduled for today or specified range</i><br/>
		</c:if>
		<c:if test="${fn:length(patients) > 0}">
			<form id="scheduledPatientsForm" method="post">
				<table width="99%" border="0" cellpadding="2" background="blue" cellspacing="0">
					<tr>
						<th align="left"><spring:message
							code="Patient.identifier" /></th>
						<th align="left"><spring:message
							code="PersonName.familyName" /></th>
						<th align="left"><spring:message
							code="PersonName.givenName" /></th>
						<th align="left"><spring:message
							code="PersonName.middleName" /></th>
						<th align="center"><spring:message
							code="Patient.gender" /></th>
						<th align="left"><spring:message
							code="oncologypoc.Scheduler.scheduledPatients.returnDate.header" /></th>
					</tr>
					<c:forEach items="${patients}" var="pat" varStatus="varStatus">
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
