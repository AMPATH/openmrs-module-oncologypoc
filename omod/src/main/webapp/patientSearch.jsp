<%@ include file="/WEB-INF/template/include.jsp"%>

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
	if(layer_ref=="patientSearch"){
		state = 'block';
		if(document.getElementById("patientSearch").style.display=='none'){
			document.getElementById("patientSearch").style.display='block';
		}
		document.getElementById("alerts").style.display='none';
		document.getElementById("schedules").style.display='none';
	}
	if (document.all) { //IS IE 4 or 5 (or 6 beta)
	eval( "document.all." + layer_ref + ".style.display = state");
	}
	if (document.layers) { //IS NETSCAPE 4 or below
	document.layers[layer_ref].display = state;
	}
	}
</script> 

<%@ include file="/WEB-INF/template/header.jsp"%>
<table class="containerTable" cellpadding="0" cellspacing="0">
  <tr>
    <td width="20%" class="navigationTd">
    	<div style="background-repeat:repeat-x; height: 100%; width: 100%; float: left; position: relative; padding: 10px; ">
    		<ul>
    			<a href="#" onclick="showhide('patientSearch');"><img src='<c:url value="/moduleResources/oncologypoc/images/search.gif"/>'/></a>
			</ul>
			<ul>
				<openmrs:hasPrivilege privilege="OncologyPoc View Scheduler">
					<a href="#" onclick="showhide('schedules');"><img src='<c:url value="/moduleResources/oncologypoc/images/schedule.gif"/>'/></a>
				</openmrs:hasPrivilege>
			</ul>
			<ul>
				<openmrs:hasPrivilege privilege="OncologyPoc View Clinician Alerts">
					<a href="#" onclick="showhide('alerts');"><img src='<c:url value="/moduleResources/oncologypoc/images/alerts.gif"/>'/></a>
				</openmrs:hasPrivilege>
			</ul>
			
		</div>
    </td>
    <td width="80%" valign="top" class="navigationTd">
	    <div id="patientSearch" style="display:block;">
			<h3><spring:message code="Patient.search"/></h3>	
			<openmrs:portlet id="findPatient" url="findPatient" parameters="size=full|postURL=patientView.form|showIncludeVoided=false|viewType=shortEdit" />
		</div>
		<div id="schedules" style="display:none;">
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
	</td>
  </tr>
</table>
<%@ include file="/WEB-INF/template/footer.jsp"%>