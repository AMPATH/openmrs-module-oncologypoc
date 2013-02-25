package org.openmrs.module.oncologypoc.extension.html;

import org.openmrs.module.Extension;
import org.openmrs.module.web.extension.PatientDashboardTabExt;

public class PatientAbstractPatientDashBoardTabExt extends PatientDashboardTabExt {

	public Extension.MEDIA_TYPE getMediaType() {
		return Extension.MEDIA_TYPE.html;
	}
	
	@Override
	public String getPortletUrl() {
		return "patientAbstract";
	}

	@Override
	public String getRequiredPrivilege() {
		return "Patient Dashboard - View Forms Section";
	}

	@Override
	public String getTabId() {
		return "PatientAbstract";
	}

	@Override
	public String getTabName() {
		return "Abstract";
	}
	
///Tab for patient abstract
	
	
	
}
