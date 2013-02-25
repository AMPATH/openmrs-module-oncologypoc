<%@ include file="/WEB-INF/template/include.jsp"%>

<script src="/openmrs/scripts/calendar/calendar.js"
	type="text/javascript">
</script>
<!--Display patient search Widget-->

<%@ include file="/WEB-INF/template/headerMinimal.jsp" %>
<div class="scheduledPatients">
	<b class="boxHeader" style="height:30; width:100%;"></b>
</div>
<table border="0" width="100%">
	<tr>
		<td style="width:50%;" valign="top">
			<h2><spring:message code="Patient.search"/></h2>	
			<br />
			<openmrs:portlet id="findPatient" url="findPatient" parameters="size=full|postURL=patientView.form|showIncludeVoided=false|viewType=shortEdit" />
		</td>
		<td width="50%" valign="top">
			<table width="100%">
				<tr>
					<td>
						<h2><spring:message	code="oncologypoc.Scheduler.scheduledPatients.title" /></h2>	
						<br />
						<openmrs:hasPrivilege privilege="OncologyPoc View Clinician Alerts">
							<openmrs:extensionPoint pointId="org.openmrs.clinicianAlertsPortlet" type="html">
								<openmrs:portlet id="${extension.portletId}" url="${extension.portletUrl}" parameters="${extension.portletParameters}"/>
							</openmrs:extensionPoint>
						</openmrs:hasPrivilege>
					</td>
				</tr>
				<tr>
					<td>
						<openmrs:extensionPoint pointId="org.openmrs.module.oncologypoc.patientSchedules" type="html">
							<openmrs:portlet id="${extension.portletId}" url="${extension.portletUrl}" parameters="${extension.portletParameters}"/>
						</openmrs:extensionPoint>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
