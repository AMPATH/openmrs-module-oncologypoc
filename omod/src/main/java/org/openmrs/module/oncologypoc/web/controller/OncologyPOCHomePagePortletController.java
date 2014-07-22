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
package org.openmrs.module.oncologypoc.web.controller;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.openmrs.User;
import org.openmrs.api.context.Context;
import org.openmrs.module.oncologypoc.api.utils.OncologyPOCConstants;
import org.openmrs.util.OpenmrsClassLoader;
import org.openmrs.web.controller.PortletController;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * Controller for role-based home page
 */
public class OncologyPOCHomePagePortletController extends PortletController {

    public static final String DEFAULT_HOME = "/index";

    /**
     * @see org.openmrs.web.controller.PortletController#populateModel(javax.servlet.http.HttpServletRequest, java.util.Map)
     */
    @Override
    public ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Thread.currentThread().setContextClassLoader(OpenmrsClassLoader.getInstance());
        Map model = new HashMap();

        try {

            ModelAndView modelAndView = super.handleRequest(request, response);
            model = (Map)modelAndView.getModel().get("model");

            String view = null;
            User authenticatedUser = Context.getAuthenticatedUser();

            if ((authenticatedUser != null) && (!authenticatedUser.isSuperUser())) {
                String prop = Context.getAdministrationService().getGlobalProperty(OncologyPOCConstants.GP_INTERCEPTROLES);

                if ((prop != null) && (prop.length() > 0)) {
                    String[] interceptRoles = prop.split(",");
                    boolean interceptThisOne = false;
                    String interceptedRole = null;

                    for (String role : interceptRoles) {
                        if (authenticatedUser.hasRole(role.trim())){
                            interceptThisOne = true;
                            interceptedRole = role;
                            break;
                        }
                    }

                    if (interceptThisOne)
                        view = generateHomepage(request, interceptedRole,"/module/oncologypoc/patientSearch.htm");
                }
            }
            if (view != null)
                return new ModelAndView(view, model);

        }catch (Exception e) {
            log.error("Error displaying oncology POC home page", e);
        }
        return new ModelAndView(DEFAULT_HOME, model);
    }

    /** adopted from role based login module */
    @SuppressWarnings("deprecation")
    protected String generateHomepage(HttpServletRequest request, String role, String url) throws Exception {
        BufferedWriter out = null;
        try {
            String content;
            if (StringUtils.isBlank(url))
                url = DEFAULT_HOME;
            if (!url.startsWith("http:"))
                url = request.getContextPath() + (url.startsWith("/") ? "" : "/") + url;

            content = "<meta http-equiv=\"refresh\" content=\"0;url=" + url + "\"/>\n";
            String view = "/module/oncologypoc/" + (role != null ? role.replace(" ","") : "OncologyHomePage");
            String path = request.getRealPath("") + "/WEB-INF/view" + view + ".jsp";
            File file = new File(path);
            file.deleteOnExit();
            out = new BufferedWriter(new FileWriter(file));
            out.write("<%@ include file=\"/WEB-INF/template/include.jsp\" %>\n" + content);
            return view;
        } finally {
            IOUtils.closeQuietly(out);
        }
    }
}