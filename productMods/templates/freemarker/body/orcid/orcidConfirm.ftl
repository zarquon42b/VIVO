<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#--
The body map contains the orcidInfo structure, which is set up like this:

orcidInfo
    progress      - a string set to one of these values: START, DENIED_PROFILE, 
                    FAILED_PROFILE, GOT_PROFILE, ID_ALREADY_PRESENT, DENIED_ID, 
                    FAILED_ID, ADDED_ID
    individualUri - the URI of the person
    profilePage   - the URL of the individual's profile page
    orcid         - the confirmed ORCID (just xxxx-xxxx-xxxx-xxxx), 
                    or the empty string.
    orcidUri      - the confirmed ORCID (full URI), or the empty string.
    externalIds   - empty if we haven't read their profile. Otherwise, a sequence
                    of maps, one for each external ID in their profile. These
                    might include SCOPUS ID, etc. Each map looks like this:
                    commonName - e.g., "VIVO Cornell"
                    reference  - e.g., their VIVO localname
                    uri        - e.g., their VIVO URI
    hasVivoId     - true, if we have read the profile and they already have 
                    their VIVO URI as an external ID. False otherwise.
    existngOrcids - A sequence of the ORCIDs (full URI) that we already associate 
                    with this individual.
    progressUrl   - The URL to go to, that will continue this process. If the 
                    process is complete or has failed, this is empty.
-->

<style TYPE="text/css">
#orcid-offer .step {
    color: blue;
    border: 2px solid black;
    background-color: pink;
    margin: 4px;
} 

#orcid-offer .links {
	text-align: center;
}

#orcid-offer ul {
	list-style: disc inside;
}

#orcid-offer ul.inner {
	list-style: circle inside;
}

#orcid-offer li {
	padding-left: 10px;
}

#orcid-offer .dimmed h2 {
    color: #CCCCCC;
}
#orcid-offer .dimmed li {
    color: #CCCCCC;
}
#orcid-offer .dimmed p {
    color: #CCCCCC;
}

</style>

<#assign step2dimmed = (["FAILED_PROFILE", "DENIED_PROFILE"]?seq_contains(orcidInfo.progress))?string("dimmed", "") />
<#assign continueAppears = (["START", "GOT_PROFILE"]?seq_contains(orcidInfo.progress))/>

<div>

<section id="orcid-offer" role="region">
    <h2>Do you want to confirm your ORCID Identification?</h2>
   
    <div class="step">
      <#if "START" == orcidInfo.progress>
        <h2>Confirming your ORCID ID:</h2>
        <ul>
          <li>VIVO redirects you to ORCID's web site.</li>
          <li>
            You log in to your ORCID account.
            <ul class="inner"><li>If you don't have an account, you can create one.</li></ul>
            </li>
          <li>You tell ORCID that VIVO may read your profile. (one-time permission)</li>
          <li>VIVO reads your profile.</li>
          <li>VIVO notes that your ORCID ID is confirmed.</li>
        </ul>
      <#elseif "DENIED_PROFILE" == orcidInfo.progress>
        <h2>Confirming your ORCID ID:</h2>
        <p>You denied VIVO's request to read your ORCID profile.</p>
        <p>Confirmation can't continue.</p>
      <#elseif "FAILED_PROFILE" == orcidInfo.progress>
        <h2>Confirming your ORCID ID:</h2>
        <p>VIVO failed to read your ORCID profile.</p>
        <p>Confirmation can't continue.</p>
      <#else>
        <h2>Confirming your ORCID ID:</h2>
        <p>Your ORCID ID is confirmed as ${orcidInfo.orcid}</p>
        <p><a href="${orcidInfo.orcidUri}" target="_blank">View your ORCID profile page.</a></p>
      </#if>
    </div>
    
    <div class="step ${step2dimmed}">
      <#if "ID_ALREADY_PRESENT" == orcidInfo.progress>
        <h2>Linking your ORCID profile to VIVO (Optional)</h2>
        <p>Your ORCID profile already includes a link to VIVO.</p>
      <#elseif "DENIED_ID" == orcidInfo.progress>
        <h2>Linking your ORCID profile to VIVO (Optional)</h2>
        <p>You denied VIVO's request to add an External ID to your ORCID profile.</p>
        <p>Linking can't continue.</p>
      <#elseif "FAILED_ID" == orcidInfo.progress>
        <h2>Linking your ORCID profile to VIVO (Optional)</h2>
        <p>VIVO failed to add an External ID to your ORCID profile.</p>
        <p>Linking can't continue.</p>
      <#elseif "ADDED_ID" == orcidInfo.progress>
        <h2>Linking your ORCID profile to VIVO (Optional)</h2>
        <p>Your ORCID profile is linked to VIVO</p>
        <p><a href="${orcidInfo.orcidUri}" target="_blank">View your ORCID profile page.</a></p>
      <#else>
        <h2>Linking your ORCID profile to VIVO (Optional)</h2>
        <ul>
          <li>VIVO redirects you to ORCID's web site</li>
          <li>You tell ORCID that VIVO may add an "external ID" to your profile. (one-time permission)</li>
          <li>VIVO adds the external ID.</li>
        </ul>
      </#if>
    </div>
    
    <div class=links>
      <form method="GET" action="${orcidInfo.progressUrl}">
        <p>
          <#if continueAppears>
            <input type="submit" name="submit" value="Continue" class="submit"/>
            or 
          </#if>
          <a class="cancel" href="${orcidInfo.profilePage}">Return to your profile page</a>
        </p>
      </form>
    </div>
</section>

</div> 