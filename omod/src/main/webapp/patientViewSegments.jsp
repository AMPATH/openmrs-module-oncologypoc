<%@ include file="/WEB-INF/template/include.jsp"%>

<openmrs:require privilege="" otherwise="/login.htm"
	redirect="/options.form" />
	
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

	function containsError(element) {
		if (element) {
			var child = element.firstChild;
			while (child != null) {
				if (child.className == 'error') {
					return true;
				}
				else if (containsError(child) == true) {
					return true;
				}
				child = child.nextSibling;
			}
		}
		return false;
	}

</script>

<div id="optionsForm">
	<fieldset>
		<legend><spring:message code="Form.header"/></legend>
		<openmrs:hasPrivilege privilege="Form Entry">
			<div id="formEntry" style="display:none;">
				<openmrs:portlet url="personFormEntry" id="formEntryPortlet" personId="3" parameters="showDecoration=true|showLastThreeEncounters=true|returnUrl=${pageContext.request.contextPath}/patientDashboard.form"/>
			</div>
		</openmrs:hasPrivilege>
		<br/>
		<br/>
		<br/>
		<br/>
	</fieldset>

	<fieldset>
		<legend><spring:message code="Patient.encounters"/></legend>
		<openmrs:hasPrivilege privilege="Patient Dashboard - View Encounters Section">
			<div id="patientEncounters">
				<openmrs:portlet url="patientEncounters" id="patientDashboardEncounters" patientId="3" parameters="num=100|showPagination=true|formEntryReturnUrl=${pageContext.request.contextPath}/patientDashboard.form"/>
			</div>
		</openmrs:hasPrivilege>
		<br/>
		<br/>
		<br/>
		<br/>
	</fieldset>

	<fieldset>
		<legend>
			Abstract
		</legend>
		<br/>
		<br/>
		<br/>
		<br/>
	</fieldset>
</div>
