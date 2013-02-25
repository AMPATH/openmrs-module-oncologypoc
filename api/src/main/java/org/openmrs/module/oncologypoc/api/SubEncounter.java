package org.openmrs.module.oncologypoc.api;


public class SubEncounter{
	
	private Integer subEncounterId;
	
	private Integer encounterId;
	
	
	/**
	 * @param subEncounterId the subEncounterId to set
	 */
	public void setSubEncounterId(Integer subEncounterId) {
		this.subEncounterId = subEncounterId;
	}

	/**
	 * @return the subEncounter
	 */
	public Integer getSubEncounterId() {
		return subEncounterId;
	}

	/**
	 * @param encounterId the encounterId to set
	 */
	public void setEncounterId(Integer encounterId) {
		this.encounterId = encounterId;
	}

	/**
	 * @return the encounterId
	 */
	public Integer getEncounterId() {
		return encounterId;
	}
}