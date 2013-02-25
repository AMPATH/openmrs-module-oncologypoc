package org.openmrs.module.oncologypoc.api.db.hibernate;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Criteria;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Expression;
import org.openmrs.Concept;
import org.openmrs.Obs;
import org.openmrs.Patient;
import org.openmrs.api.context.Context;
import org.openmrs.module.oncologypoc.api.ExtendedPatient;
import org.openmrs.module.oncologypoc.api.SubEncounter;
import org.openmrs.module.oncologypoc.api.db.OncologyPOCDAO;

@SuppressWarnings("unchecked")
public class HibernateOncologyPOCDAO implements OncologyPOCDAO {

	protected final Log log = LogFactory.getLog(getClass());

	/**
	 * Hibernate session factory
	 */
	private SessionFactory sessionFactory;

	public HibernateOncologyPOCDAO() {
	}
	
	public void setSessionFactory(SessionFactory sessionFactory) {
		this.sessionFactory = sessionFactory;
	}

	/**
	 * @see org.openmrs.module.oncologypoc.db.OncologyPOCDAO#getPatientsByEncounterType(java.util.List)
	 */
	SimpleDateFormat df=new SimpleDateFormat("MMM dd, yyyy");

	public List<ExtendedPatient> getReturnPatients(Date sDate,Date eDate) {
		Calendar sCal = Calendar.getInstance();
		Calendar eCal = Calendar.getInstance();
		sCal.setTime(sDate);
		eCal.setTime(eDate);
		sCal.set(Calendar.HOUR_OF_DAY, 00);
		sCal.set(Calendar.MINUTE, 00);
		sCal.set(Calendar.SECOND, 00);
		eCal.set(Calendar.HOUR_OF_DAY, 23);
		eCal.set(Calendar.MINUTE, 59);
		eCal.set(Calendar.SECOND, 59);
		eCal.set(Calendar.MILLISECOND, 00);
		sCal.set(Calendar.MILLISECOND, 00);
		sDate=sCal.getTime();
		eDate=eCal.getTime();
		
		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(Obs.class);
		criteria.add(Expression.eq("concept", new Concept(5096)));
		criteria.add(Expression.between("valueDatetime", sDate, eDate));
		List<ExtendedPatient> ePatients=new ArrayList<ExtendedPatient>();
		Collection<Obs> returnObs=(Collection<Obs>)criteria.list();
		
		for (Obs observation:returnObs){
			ExtendedPatient ePatient=new ExtendedPatient(
					Context.getPatientService().getPatient(new Patient(observation.getPerson()).getPatientId()));
			ePatient.setReturnDate(observation.getValueDatetime());
			ePatients.add(ePatient);
		}
		return ePatients;
	}

	@Override
	public List<SubEncounter> getAllSubEncounters() {
		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(SubEncounter.class);
		return (List<SubEncounter>) criteria.list();
	}

	@Override
	public void saveSubEncounter(SubEncounter subEncounter) {
		sessionFactory.getCurrentSession().saveOrUpdate(subEncounter);
	}

	@Override
	public void deleteSubEncounter(SubEncounter subEncounter) {
		sessionFactory.getCurrentSession().delete(subEncounter);
	}
}