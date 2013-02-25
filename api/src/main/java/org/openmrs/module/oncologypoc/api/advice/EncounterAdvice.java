package org.openmrs.module.oncologypoc.api.advice;

import java.lang.reflect.Method;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.Encounter;
import org.openmrs.api.context.Context;
import org.openmrs.module.oncologypoc.api.SubEncounter;
import org.openmrs.module.oncologypoc.api.service.OncologyPOCService;
import org.springframework.aop.AfterReturningAdvice;

public class EncounterAdvice implements AfterReturningAdvice {
	
	private static final Log log = LogFactory.getLog(EncounterAdvice.class);
	
	@Override
	public void afterReturning(Object returnValue, Method method, Object[] args, Object target) throws Throwable {
		
		if (method.getName().equals("saveEncounter")) {
			Encounter encounter = (Encounter) returnValue;
			if (encounter != null) {
				log.debug("Intercepted an Encounter Save");
				if (encounter.getPatient() != null && encounter.getForm() != null){
					OncologyPOCService service = Context.getService(OncologyPOCService.class);
					SubEncounter subEncounter = new SubEncounter();
					subEncounter.setEncounterId(encounter.getEncounterId());
					service.saveSubEncounter(subEncounter);
				}
			}
		}
	}
}