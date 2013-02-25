<%@ include file="/WEB-INF/template/include.jsp" %>

<openmrs:require privilege="View Patients" otherwise="/login.htm" redirect="/module/oncologypoc/patientView.form" />

<spring:message var="pageTitle" code="patientDashboard.title" scope="page"/>

<%@ include file="/WEB-INF/template/header.jsp" %>

<%-- Files from encounter and graph portlets being included near header to improve page loading speed
     If those tabs/portlets are no longer using them, they should be removed from here --%>
<openmrs:htmlInclude file="/scripts/easyAjax.js" />

<openmrs:htmlInclude file="/scripts/jquery/dataTables/css/dataTables.css" />
<openmrs:htmlInclude file="/scripts/jquery/dataTables/js/jquery.dataTables.min.js" />

<openmrs:htmlInclude file="/scripts/jquery-ui/js/jquery-ui-1.7.2.custom.min.js" />
<link href="<openmrs:contextPath/>/scripts/jquery-ui/css/<spring:theme code='jqueryui.theme.name' />/jquery-ui.custom.css" type="text/css" rel="stylesheet" />

<openmrs:htmlInclude file="/scripts/flot/jquery.flot.js" />
<openmrs:htmlInclude file="/scripts/flot/jquery.flot.multiple.threshold.js"/> 
<%-- /end file imports for portlets --%>

<script type="text/javascript">

window.onload = init;

function init() {
	var sections = new Array();
	var optform = document.getElementById("optionsForm");
	children = optform.childNodes;
	var seci = 0;
	for(i=0;i<children.length;i++) {
		if(children[i].nodeName.toLowerCase().indexOf('fieldset') != -1) {
			children[i].id = 'optsection-' + seci;
			children[i].className = 'optsection';
			legends = children[i].getElementsByTagName('legend');
			sections[seci] = new Object();
			if(legends[0] && legends[0].firstChild.nodeValue)
				sections[seci].text = legends[0].firstChild.nodeValue;
			else
				sections[seci].text = '# ' + seci;
			sections[seci].secid = children[i].id;
			sections[seci].error = containsError(children[i]);
			seci++;
			if(sections.length != 1)
				children[i].style.display = 'none';
			else
				var selectedid = children[i].id;
		}
	}
	
	var toc = document.createElement('ul');
	toc.id = 'optionsTOC';
	toc.selectedid = selectedid;
	for(i=0;i<sections.length;i++) {
		var li = document.createElement('li');
		if(i == 0) li.className = 'selected';
		var a =  document.createElement('a');
		a.href = '#' + sections[i].secid;
		a.onclick = uncoversection;
		a.appendChild(document.createTextNode(sections[i].text));
		a.secid = sections[i].secid;
		a.id = sections[i].secid + "_link";
		if (sections[i].error) {
			a.className = "error";
		}
		li.appendChild(a);
		toc.appendChild(li);
	}
	optform.insertBefore(toc, children[0]);

	var hash = document.location.hash;
	if (hash.length > 1) {
		var autoSelect = hash.substring(1, hash.length);
		for(i=0;i<sections.length;i++) {
			if (sections[i].text == autoSelect)
				uncoversection(sections[i].secid + "_link");
		}
	}
}

function uncoversection(secid) {
	var obj = this;
	if (typeof secid == 'string') {
		obj = document.getElementById(secid);
		if (obj == null)
			return false;
	}

	var ul = document.getElementById('optionsTOC');
	var oldsecid = ul.selectedid;
	var newsec = document.getElementById(obj.secid);
	if(oldsecid != obj.secid) {
		document.getElementById(oldsecid).style.display = 'none';
		newsec.style.display = 'block';
		ul.selectedid = obj.secid;
		lis = ul.getElementsByTagName('li');
		for(i=0;i< lis.length;i++) {
			lis[i].className = '';
		}
		obj.parentNode.className = 'selected';
	}
	newsec.blur();
	return false;
}

</script>

<c:if test="${patient.voided}">
	<div id="patientDashboardVoided" class="retiredMessage">
		<div><spring:message code="Patient.voidedMessage"/></div>
	</div>
</c:if>

<c:if test="${patient.dead}">
	<div id="patientDashboardDeceased" class="retiredMessage">
		<div>
			<spring:message code="Patient.patientDeceased"/>
			<c:if test="${not empty patient.deathDate}">
				&nbsp;&nbsp;&nbsp;&nbsp;
				<spring:message code="Person.deathDate"/>: <openmrs:formatDate date="${patient.deathDate}"/>
			</c:if>
			<c:if test="${not empty patient.causeOfDeath}">
				&nbsp;&nbsp;&nbsp;&nbsp;
				<spring:message code="Person.causeOfDeath"/>: <openmrs:format concept="${patient.causeOfDeath}"/>
				<c:if test="${not empty causeOfDeathOther}"> 
					  &nbsp;:&nbsp;<c:out value="${causeOfDeathOther}"></c:out>
				</c:if>
			</c:if>
		</div>
	</div>
</c:if>

<table width="100%">
	<tr>
		<c:if test="${empty patientReasonForExit}">
			<td width="40%" id="patientHeader" class="boxHeader" width="30%">
		</c:if>
		<c:if test="${not empty patientReasonForExit}">
			<td width="40%" id="patientHeader" class="boxHeaderRed" width="30%">
		</c:if>
			<table>
				<tr>
					<td>
						<c:if test="${patient.gender == 'M'}"><img src='<c:url value="/moduleResources/oncologypoc/images/male.jpeg"/>' alt='<spring:message code="Person.gender.male"/>' id="maleGenderIcon"/></c:if>
						<c:if test="${patient.gender == 'F'}"><img src='<c:url value="/moduleResources/oncologypoc/images/female.jpeg"/>' alt='<spring:message code="Person.gender.female"/>' id="femaleGenderIcon"/></c:if>
					</td>
					<td valign="top">
						<input type="hidden" name="patientId" value="3"/>
						<div id="patientHeaderPatientName">${patient.personName}</div><br><br>
						<c:if test="${patient.age > 0}">${patient.age} <spring:message code="Person.age.years"/></c:if>
						<c:if test="${patient.age == 0}">< 1 <spring:message code="Person.age.year"/></c:if>
						<span id="patientHeaderPatientBirthdate"><c:if test="${not empty patient.birthdate}">(<c:if test="${patient.birthdateEstimated}">~</c:if><openmrs:formatDate date="${patient.birthdate}" type="medium" />)</c:if><c:if test="${empty patient.birthdate}"><spring:message code="Person.age.unknown"/></c:if></span>
						<br><br>
						<div id="patientHeaderPreferredIdentifier">
							<c:if test="${fn:length(patient.activeIdentifiers) > 0}">
								<c:forEach var="identifier" items="${patient.activeIdentifiers}" begin="0" end="0">
									<span class="patientHeaderPatientIdentifier"><span id="patientHeaderPatientIdentifierType">${identifier.identifierType.name}<openmrs:extensionPoint pointId="org.openmrs.patientDashboard.afterPatientHeaderPatientIdentifierType" type="html" parameters="identifierLocation=${identifier.location.name}"/>:</span> ${identifier.identifier}</span>
								</c:forEach>
							</c:if>
						</div>
						<c:if test="${fn:length(patient.activeIdentifiers) > 1}">
							<c:forEach var="identifier" items="${patient.activeIdentifiers}" begin="1" end="1">
								<span class="patientHeaderPatientIdentifier">${identifier.identifierType.name}<openmrs:extensionPoint pointId="org.openmrs.patientDashboard.afterPatientHeaderPatientIdentifierType" type="html" parameters="identifierLocation=${identifier.location.name}"/>: ${identifier.identifier}</span>
							</c:forEach>
						</c:if>
						<c:if test="${fn:length(patient.activeIdentifiers) > 2}">
							<div id="patientHeaderMoreIdentifiers">
								<c:forEach var="identifier" items="${patient.activeIdentifiers}" begin="2">
									<span class="patientHeaderPatientIdentifier">${identifier.identifierType.name}<openmrs:extensionPoint pointId="org.openmrs.patientDashboard.afterPatientHeaderPatientIdentifierType" type="html" parameters="identifierLocation=${identifier.location.name}"/>: ${identifier.identifier}</span>
								</c:forEach>
							</div>
						</c:if>
						<c:if test="${fn:length(patient.activeIdentifiers) > 2}">
								<small><a id="patientHeaderShowMoreIdentifiers" onclick="return showMoreIdentifiers()" title='<spring:message code="patientDashboard.showMoreIdentifers"/>'><spring:message code="general.nMore" arguments="${fn:length(patient.activeIdentifiers) - 2}"/></a></small>
						</c:if>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<div id="patientSubheader">
							<table id="patientHeaderObs">
								<openmrs:globalProperty key="concept.weight" var="weightConceptId"/>
								<openmrs:globalProperty key="concept.height" var="heightConceptId"/>
								<openmrs:globalProperty key="concept.cd4_count" var="cd4ConceptId"/>
								<tr class="patientObsRow">
									<th class="patientHeaderObsWeightHeightHeader">
										<spring:message code="Patient.weight"/>:
										<openmrs_tag:mostRecentObs observations="${patientObs}" concept="${weightConceptId}" showUnits="true" locale="${locale}" showDate="false" />
									</th>
									<th class="patientHeaderObsWeightHeightHeader">
										<spring:message code="Patient.height"/>:
										<openmrs_tag:mostRecentObs observations="${patientObs}" concept="${heightConceptId}" showUnits="true" locale="${locale}" showDate="false" />
									</th>
								</tr>
							</table>
						</div>
					</td>
				</tr>
				<tr>
					<th colspan="2">
						<spring:message code="Patient.bmi"/>: ${patientBmiAsString}
					</th>
				</tr>
				<tr>
					<td colspan="2">
						<table class="patientLastEncounterTable">
							<tr class="patientLastEncounterRow">
								<td class="patientLastEncounterData">
									<spring:message code="Patient.lastEncounter"/>:
								</td>
								<th>
									<c:forEach items='${openmrs:sort(patientEncounters, "encounterDatetime", true)}' var="lastEncounter" varStatus="lastEncounterStatus" end="0">
										${lastEncounter.encounterType.name} @ ${lastEncounter.location.name}, <openmrs:formatDate date="${lastEncounter.encounterDatetime}" type="medium" />
									</c:forEach>
									<c:if test="${fn:length(patientEncounters) == 0}">
										<spring:message code="Encounter.no.previous"/>
									</c:if>	
								</th>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<c:forEach var="address" items="${patient.addresses}" varStatus="status">
							<c:if test="${!address.voided}">
								<% request.setAttribute("address", pageContext.getAttribute("address")); %>
								<spring:nestedPath path="address">
									<openmrs:portlet url="addressLayout" id="addressPortlet" size="full" parameters="layoutMode=view|layoutShowTable=false|layoutShowExtended=true" />
								</spring:nestedPath>
							</c:if>
						</c:forEach>
					</td>
				</tr>
				<tr>
					<%-- Display selected person attributes from the manage person attributes page --%>
					<openmrs:forEachDisplayAttributeType personType="patient" displayType="header" var="attrType">
						<spring:message code="PersonAttributeType.${fn:replace(attrType.name, ' ', '')}" text="${attrType.name}"/>: 
						<b>${patient.attributeMap[attrType.name]}</b>
					</openmrs:forEachDisplayAttributeType>
				</tr>
			</table>

		</td>
		<td width="70%" valign="top">
			<openmrs:portlet id="patientViewSegments" url="patientViewSegments" moduleId="oncologypoc" parameters="size=full|postURL=patientDashboard.form|showIncludeVoided=false|viewType=shortEdit" />
		</td>
	</tr>
</table>
	
<script type="text/javascript">
	function showMoreIdentifiers() {
		if (identifierElement.style.display == '') {
			linkElement.innerHTML = '<spring:message code="general.nMore" arguments="${fn:length(patient.activeIdentifiers) - 2}"/>';
			identifierElement.style.display = "none";
		}
		else {
			linkElement.innerHTML = '<spring:message code="general.nLess" arguments="${fn:length(patient.activeIdentifiers) - 2}"/>';
			identifierElement.style.display = "";
		}
	}
	
	var identifierElement = document.getElementById("patientHeaderMoreIdentifiers");
	var linkElement = document.getElementById("patientHeaderShowMoreIdentifiers");
	if (identifierElement)
		identifierElement.style.display = "none";
	
</script>


<%@ include file="/WEB-INF/template/footer.jsp" %>