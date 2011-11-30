/* $This file is distributed under the terms of the license in /doc/license.txt$ */

package edu.cornell.mannlib.vitro.webapp.utils.ConceptSearchService;

import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletContext;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import edu.cornell.mannlib.semservices.bo.Concept;
import edu.cornell.mannlib.semservices.service.ExternalConceptService;
import edu.cornell.mannlib.vitro.webapp.controller.VitroRequest;
/**
 * Utilities for search    
 */
public class ConceptSearchServiceUtils {
    private static final Log log = LogFactory.getLog(ConceptSearchServiceUtils.class);
    //Get the appropriate search service class
    //TODO: Change this so retrieved from the system instead using a query
    private static final String UMLSVocabSource = "http://link.informatics.stonybrook.edu/umls";
    private static final String AgrovocVocabSource = "http://aims.fao.org/aos/agrovoc/agrovocScheme";
    //Get the class that corresponds to the appropriate search
	public static String getConceptSearchServiceClassName(String searchServiceName) {
		HashMap<String, String> map = getMapping();
		if(map.containsKey(searchServiceName)) {
			return map.get(searchServiceName);
		}
		return null;
	}
	
	//Get the URLS for the different services
	//URL to label
	public static HashMap<String, String> getVocabSources() {
		HashMap<String, String> map = new HashMap<String, String>();
    	map.put(UMLSVocabSource, "UMLS");
    	map.put(AgrovocVocabSource, "Agrovoc");
    	return map;
	}
	
	
    
    //Get the hashmap mapping service name to Service class
    private static HashMap<String, String> getMapping() {
    	HashMap<String, String> map = new HashMap<String, String>();
    	map.put(UMLSVocabSource, "edu.cornell.mannlib.semservices.service.impl.UMLSService");
    	map.put(AgrovocVocabSource, "edu.cornell.mannlib.semservices.service.impl.AgrovocService");

    	return map;
    }
    
    public static List<Concept> getSearchResults(ServletContext context, VitroRequest vreq) {
    	String searchServiceName = getSearchServiceUri(vreq);
    	String searchServiceClassName = getConceptSearchServiceClassName(searchServiceName);
    
    	ExternalConceptService conceptServiceClass = null;
	
	    Object object = null;
	    try {
	        Class classDefinition = Class.forName(searchServiceClassName);
	        object = classDefinition.newInstance();
	        conceptServiceClass = (ExternalConceptService) object;
	    } catch (InstantiationException e) {
	        System.out.println(e);
	    } catch (IllegalAccessException e) {
	        System.out.println(e);
	    } catch (ClassNotFoundException e) {
	        System.out.println(e);
	    }    	
    
	    if(conceptServiceClass == null){
	    	log.error("could not find Concept Search Class for " + searchServiceName);
	    	return null;
	    } 
	    
	    //Get search
	    String searchTerm = getSearchTerm(vreq);
	    List<Concept> conceptResults =  conceptServiceClass.processResults(searchTerm);
	    return conceptResults;
    }


	private static String getSearchServiceUri(VitroRequest vreq) {
		return vreq.getParameter("source");
	}

	private static String getSearchTerm(VitroRequest vreq) {
		return vreq.getParameter("searchTerm");
	}
}