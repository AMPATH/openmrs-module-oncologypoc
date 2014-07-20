<%@ include file="/WEB-INF/template/include.jsp"%>
<openmrs:require privilege="OncologyPoc View Patient Schedules"
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
	var schedulestable;
	
	$j(document).ready(function() {
		schedulestable = $j('#schedulesTable').dataTable( { 
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
		schedulestable.fnSetFilteringDelay(1000);

		$j("#schedulesTable").delegate('tr','mouseover mouseleave', function(e) {
		    if (e.type == 'mouseover') {
			 $j(this).css("background","#F0E68C");
		    }
		    else {
			 $j(this).css("background","");
		    }
		});
	} );

</script>
<script src="/openmrs/scripts/calendar/calendar.js"	type="text/javascript">
</script>

<c:set var="patients" value="${model.patients}"/>
<div style="width:100%; margin-left:10px;">
<h3><spring:message	code="oncologypoc.scheduler.scheduledPatients.title" /></h3>
	<b class="boxHeader">
		<spring:message code="oncologypoc.scheduler.scheduledPatients.title"/> 
		<c:choose>
		     <c:when test='${model.endDate==model.startDate}'>
		     	[${model.startDate}]
	     	</c:when>
	        <c:otherwise>
	        	[${model.startDate} --> ${model.endDate}]
	        </c:otherwise>
      	</c:choose>
	</b>
	<div class="box">
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
			<table cellpadding="5" cellspacing="0" id="schedulesTable" width="100%">
				<thead>
					<th align="left"><spring:message code="Patient.identifier" /></th>
					<th align="left"><spring:message code="PersonName.familyName" /></th>
					<th align="left"><spring:message code="PersonName.givenName" /></th>
					<th align="left"><spring:message code="PersonName.middleName" /></th>
					<th align="center"><spring:message code="Patient.gender" /></th>
					<th align="left"><spring:message code="oncologypoc.scheduler.scheduledPatients.returnDate.header" /></th>
				</thead>
				
				<c:forEach items="${patients}" var="pat" varStatus="varStatus">
					<input type="hidden" name="patientId" id="patientId" value="${pat.patientId}"/>
					<tr onmouseover="this.className='searchHighlight'" onmouseout="this.className='<c:choose><c:when test="${varStatus.index % 2 == 0}">evenRow</c:when><c:otherwise>oddRow</c:otherwise></c:choose>'" onClick="JavaScript:window.location='${pageContext.request.contextPath}/module/oncologypoc/patientView.form?patientId=${pat.patientId}&phrase=${pat.patientIdentifier}';"
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
		</c:if>
	</div>
</div>