<%@ include file="/WEB-INF/template/include.jsp"%>
<openmrs:require privilege="OncologyPoc View Clinician Alerts"
	otherwise="/login.htm"
	redirect="/module/oncologypoc/portlets/scheduledPatients.form" />


<openmrs:htmlInclude file="/scripts/jquery/highlight/jquery.highlight-3.js" />
<openmrs:htmlInclude file="/scripts/jquery/dataTables/js/jquery.dataTables.min.js" />
<openmrs:htmlInclude file="/scripts/jquery/dataTables/js/jquery.dataTables.filteringDelay.js" />
<openmrs:htmlInclude file="/scripts/jquery-ui/js/jquery-ui.custom.min.js" />
<link href="<openmrs:contextPath/>/scripts/jquery-ui/css/<spring:theme code='jqueryui.theme.name' />/jquery-ui.custom.css" type="text/css" rel="stylesheet" />
<openmrs:htmlInclude file="/scripts/jquery/dataTables/css/dataTables.css" />
<openmrs:htmlInclude file="/scripts/jquery/dataTables/css/dataTables_jui.css" />

<script type="text/javascript">
	var alertstable;
	var errorDetails = {};
	
	$j(document).ready(function() {
		alertstable = $j('#alertsTable').dataTable( { 
		 	"aLengthMenu": [[5, 10, 15]],
			"aoColumns": [  
							{ "bVisible": true, "bSortable": false},
							{ "bVisible": true, "bSortable": false},
							{ "bVisible": true, "bSortable": false},
							{ "bVisible": true, "bSortable": false},
							{ "bVisible": true, "bSortable": false},
							{ "bVisible": true, "bSortable": false}
			  			 ],
			"sPaginationType": "full_numbers",
			"bAutoWidth": false,
			"bLengthChange": true,
			"bJQueryUI": true
		});
		alertstable.fnSetFilteringDelay(1000);

	} );

</script>
<style>
	div.dataTables_length {
		float: right;
	}
	
	div.dataTables_filter {
		float: left;
	}
	
	div.dataTables_info {
		float: left;
	}
	
	div.dataTables_paginate {
		float: right;
	}
</style>

<div id="popup" style="display: none;"><span class="content"></span>
</div>
<c:set var="subEncounters" value="${model.subEncounters}"/>
<table cellpadding="5" cellspacing="0" id="alertsTable" width="100%" class="pretty">
	<thead>
		<th align="left"><spring:message code="Patient.identifier" /></th>
		<th align="left"><spring:message code="PersonName.familyName" /></th>
		<th align="left"><spring:message code="PersonName.givenName" /></th>
		<th align="left"><spring:message code="PersonName.middleName" /></th>
		<th align="center"><spring:message code="Patient.gender" /></th>
		<th align="left"><spring:message code="oncologypoc.Scheduler.scheduledPatients.entryDate.header" /></th>
	</thead>
	<tbody>
		<c:forEach items="${subEncounters}" var="subEncounter" varStatus="varStatus">
			<input type="hidden" name="encounterId" id="encounterId" value="${subEncounter.encounterId}"/>
			<c:set var="editUrl" value="${pageContext.request.contextPath}/admin/encounters/encounter.form?encounterId=${subEncounter.encounterId}"/>
			<c:if test="${ model.formToEditUrlMap[subEncounter.encounter.form] != null }">
				<c:url var="editUrl" value="/${model.formToEditUrlMap[subEncounter.encounter.form]}">
					<c:param name="encounterId" value="${subEncounter.encounterId}"/>
				</c:url>
			</c:if>
			<tr onmouseover="this.className='searchHighlight'" onmouseout="this.className=''" onClick="JavaScript:window.location='${editUrl}';"
				>
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
	</tbody>
</table>