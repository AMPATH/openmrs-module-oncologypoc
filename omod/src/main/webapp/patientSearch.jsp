<%@ include file="/WEB-INF/template/include.jsp"%>
<%@ include file="/WEB-INF/template/header.jsp" %>

<openmrs:htmlInclude file="/moduleResources/oncologypoc/scripts/css/nav.css"/>

<script src="/openmrs/scripts/calendar/calendar.js"
	type="text/javascript">
</script>
<style type="text/css">
.containerTable{
	width:100%;
	height:100%;
	border-collapse:collapse;
	}
.navigationTd{
	border: 1px solid #1aac9b;
	}
</style>

<script language="javascript">

	function showhide(layer_ref) {

	if(layer_ref=="patientSearch"){
		state = 'block';
		if(document.getElementById("patientSearch").style.display=='none'){
			document.getElementById("patientSearch").style.display='block';
		}
		document.getElementById("alerts").style.display='none';
		document.getElementById("schedules").style.display='none';
	}
	if(layer_ref=="schedules"){
		state = 'block';
		if(document.getElementById("schedules").style.display=='none'){
			document.getElementById("schedules").style.display='block';
		}
		document.getElementById("alerts").style.display='none';
		document.getElementById("patientSearch").style.display='none';
	}
	if(layer_ref=="alerts"){
		state = 'block';
		if(document.getElementById("alerts").style.display=='none'){
			document.getElementById("alerts").style.display='block';
		}
		document.getElementById("schedules").style.display='none';
		document.getElementById("patientSearch").style.display='none';
	}
	if (document.all) { //IS IE 4 or 5 (or 6 beta)
		eval( "document.all." + layer_ref + ".style.display = state");
	}
	if (document.layers) { //IS NETSCAPE 4 or below
		document.layers[layer_ref].display = state;
	}
	}
</script> 

<table class="containerTable" cellpadding="0" cellspacing="0">
  <tr class="navigationTd">
    <td width="20%" valign="top">
    	<img src='<c:url value="/moduleResources/oncologypoc/images/logo.png"/>'/>
    	<div class="leftnav-div">
			<openmrs:hasPrivilege privilege="OncologyPoc View Scheduler">
				<div class="leftnavSchedules-div">
					<a href="#" onclick="showhide('schedules');">Patient Schedules</a>
				</div>
				<hr style="height: 5px; border: 0px solid #D6D6D6; border-top-width: 1px;" />
			</openmrs:hasPrivilege>
			<openmrs:hasPrivilege privilege="OncologyPoc View Clinician Alerts">
				<div class="leftnavAlerts-div">
					<a href="#" onclick="showhide('alerts');">Clinician Alerts</a>
			 	</div>
			 	<hr style="height: 5px; border: 0px solid #D6D6D6; border-top-width: 1px;" />
			</openmrs:hasPrivilege>
			<div class="leftnavSearch-div">
				<a href="#" onclick="showhide('patientSearch');">Patient Search</a>
			</div>
			<hr style="height: 5px; border: 0px solid #D6D6D6; border-top-width: 1px;" />
		</div>
    </td>
    <td width="80%" valign="top">
		<div id="schedules" style="display:block;">
			<openmrs:hasPrivilege privilege="OncologyPoc View Scheduler">
				<h3><spring:message	code="oncologypoc.Scheduler.scheduledPatients.title" /></h3>
				<openmrs:extensionPoint pointId="org.openmrs.module.oncologypoc.patientSchedules" type="html">
					<openmrs:portlet id="${extension.portletId}" url="${extension.portletUrl}" parameters="${extension.portletParameters}"/>
				</openmrs:extensionPoint>
			</openmrs:hasPrivilege>
		</div>
	    <div id="alerts" style="display:none;">
			<openmrs:hasPrivilege privilege="OncologyPoc View Clinician Alerts">
				<h3><spring:message	code="oncologypoc.Scheduler.clinicalAlerts.title" /></h3>	
				<openmrs:extensionPoint pointId="org.openmrs.clinicianAlertsPortlet" type="html">
					<openmrs:portlet id="${extension.portletId}" url="${extension.portletUrl}" parameters="${extension.portletParameters}"/>
				</openmrs:extensionPoint>
			</openmrs:hasPrivilege>
		</div>
	    <div id="patientSearch" style="display:none;">
			<h3><spring:message code="Patient.search"/></h3>	
			<openmrs:portlet id="findPatient" url="findPatient" parameters="size=full|postURL=patientView.form|showIncludeVoided=false|viewType=shortEdit" />
		</div>
	</td>
  </tr>
</table>
<%@ include file="/WEB-INF/template/footer.jsp"%>