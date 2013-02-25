package org.openmrs.module.oncologypoc.web.controller;

/**
 * The contents of this file are subject to the OpenMRS Public License
 * Version 1.0 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 * http://license.openmrs.org
 *
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 * License for the specific language governing rights and limitations
 * under the License.
 *
 * Copyright (C) OpenMRS, LLC.  All Rights Reserved.
 */
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.openmrs.web.controller.PortletController;

public class PatientAbstractPortletController extends PortletController {
	protected void populateModel(HttpServletRequest request, Map<String,Object> model) {
		boolean displayable=true;

		model.put("displayable",displayable);
	}
}