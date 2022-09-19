set -e

authorization="Authorization: Bearer "$1

echo "Generating Status Report"

# head="HELLO @hac-dev-team"
head="\nCurrent Sprint Status"
head+="\nHAC" 

echo "Fetching HAC stories"

hac_stories="\n\n*UI Stories*"
hac_stories+="\n1. <https://issues.redhat.com/issues/?filter=12396633 | Stories Done> ($(curl -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12396633' -H "Accept: application/json" | jq '.total'))" 
hac_stories+="\n2. <https://issues.redhat.com/issues/?filter=12396635 | Stories In Review> ($(curl -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12396635' -H "Accept: application/json" | jq '.total'))"
hac_stories+="\n3. <https://issues.redhat.com/issues/?filter=12396638 | Unassigned Stories>($(curl -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12396638' -H "Accept: application/json" | jq '.total'))" 
hac_stories+="\n4. <https://issues.redhat.com/issues/?filter=12396637 | Ready for pointing stories> ($(curl -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12396637' -H "Accept: application/json" | jq '.total'))" 

echo "Fetching HAC bugs"

hac_bugs="\n\n*Bugs:*"
hac_bugs+="\n1. <https://issues.redhat.com/issues/?filter=12396774 | In Review> ($(curl -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12396774' -H "Accept: application/json" | jq '.total'))" 
hac_bugs+="\n2. <https://issues.redhat.com/issues/?filter=12396775 | Stories QE Review> ($(curl -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12396775' -H "Accept: application/json" | jq '.total'))" 
hac_bugs+="\n3. <https://issues.redhat.com/issues/?filter=12396777 | Open bugs count> ($(curl -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12396777' -H "Accept: application/json" | jq '.total'))" 
hac_bugs+="\n4. <https://issues.redhat.com/issues/?filter=12396778 | Triaged Bugs> ($(curl -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12396778' -H "Accept: application/json" | jq '.total'))" 

echo "Fetching ODC stories"

odc_stories="\n*UI Stories*"

odc_stories+="\n1. <https://issues.redhat.com/issues/?jql=project%20%3D%20ODC%20and%20component%20%3D%20UI%20AND%20type%20%3D%20Story%20AND%20Sprint%20in%20openSprints()%20and%20status%3DClosed | Stories Done>($(curl -s 'https://issues.redhat.com/rest/api/2/search?jql=project%20%3D%20ODC%20and%20component%20%3D%20UI%20AND%20type%20%3D%20Story%20AND%20Sprint%20in%20openSprints()%20and%20status%3DClosed' -H "Accept: application/json" | jq '.total'))" 

odc_stories+="\n2. $(curl -s 'https://issues.redhat.com/rest/api/2/search?jql=project%20%3D%20ODC%20and%20component%20%3D%20UI%20AND%20type%20%3D%20Story%20AND%20Sprint%20in%20openSprints()%20and%20status%3D"Code%20Review"' -H "Accept: application/json" | jq '.total') <https://issues.redhat.com/issues/?jql=project%20%3D%20ODC%20and%20component%20%3D%20UI%20AND%20type%20%3D%20Story%20AND%20Sprint%20in%20openSprints()%20and%20status%3D%22Code%20Review%22 | Stories In Review>" 

# ODC Stories - Ready for Assignees
odc_stories+="\n3. <https://issues.redhat.com/issues/?filter=12396840 | Unassigned stories:> $(curl -s  -H "$authorization" 'https://issues.redhat.com/rest/api/2/search?jql=filter=12396840' -H "Accept: application/json" | jq '.total')"

# Ready for pointing
odc_stories+="\n4. $(curl -s -H "$authorization" 'https://issues.redhat.com/rest/api/2/search?jql=filter=12390129' -H "Accept: application/json" | jq '.total') <https://issues.redhat.com/issues/?filter=12390129 | Ready for pointing story>" 

echo "Fetching ODC bugs"

odc_bugs="\n*Bugs:*"

bugs=$(curl -H "$authorization" -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12399207' -H "Accept: application/json" | jq '.total')
odc_bugs+="\n1.  <https://issues.redhat.com/issues/?filter=12399207 | Bugs In Review > ($bugs)" 
if [ $bugs -ge 20 ]; then
    odc_bugs+=" :fire::fire:"
fi

odc_bugs+="\n   [$(curl -s -H "$authorization" 'https://issues.redhat.com/rest/api/2/search?jql=filter=12399473' -H "Accept: application/json" | jq '.total') for <https://issues.redhat.com/issues/?filter=12399473  | 4.12> &"

odc_bugs+=" $(curl -s -H "$authorization" 'https://issues.redhat.com/rest/api/2/search?jql=filter=12399474' -H "Accept: application/json" | jq '.total') for <https://issues.redhat.com/issues/?filter=12399474  | z-stream> ]"

qe_bugs=$(curl -H  "$authorization" -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12399206' -H "Accept: application/json" | jq '.total') 
odc_bugs+="\n2. <https://issues.redhat.com/issues/?filter=12399206 | Bugs In QE Review >($qe_bugs)" 
if [ $qe_bugs -ge 10 ]; then
    odc_bugs+=" :fire::fire:" 
fi
odc_bugs+="\n3. <https://issues.redhat.com/issues/?filter=12399208 | Unresolved blockers> ($(curl -H "$authorization" -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12399208' -H "Accept: application/json" | jq '.total'))"

odc_bugs+="\n4. <https://issues.redhat.com/issues/?filter=12390303 | Triaged bugs> ($(curl -H "$authorization" -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12390303' -H "Accept: application/json" | jq '.total'))"


openbugs=$(curl -H "$authorization" -s 'https://issues.redhat.com/rest/api/2/search?jql=(project%20in%20(%22OpenShift%20Dev%20Console%22%2C%20%22OCP%20Bugs%20Mirroring%22%2C%20%22OpenShift%20Bugs%22)%20AND%20component%20in%20(UI%2C%20%22Dev%20Console%22)%20AND%20type%20%3D%20Bug%20AND%20status%20in%20(%22To%20Do%22%2C%20%22In%20Progress%22%2C%20%22In%20Review%22%20%2C%20POST)%20AND%20labels%20in%20(%22triaged%22)%20AND%20labels%20not%20in%20(%22needs-ux%22%2C%20%22needs-more-info%22)%20AND%20Blocked%20in%20(EMPTY%2C%20%22False%22)%20AND%20reporter%20!%3D%20%27openshift-bugzilla-robot%40redhat.com%27)' -H "Accept: application/json" | jq '.total')


odc_bugs+="\n5. <https://issues.redhat.com/browse/ODC-6640?jql=project%20in%20(%22OpenShift%20Dev%20Console%22%2C%20%22OCP%20Bugs%20Mirroring%22%2C%20%22OpenShift%20Bugs%22)%20AND%20component%20in%20(UI%2C%20%22Dev%20Console%22)%20AND%20type%20%3D%20Bug%20AND%20status%20in%20(%22To%20Do%22%2C%20%22In%20Progress%22%2C%20%22In%20Review%22%20%2C%20POST)%20AND%20labels%20in%20(%22triaged%22)%20AND%20labels%20not%20in%20(%22needs-ux%22%2C%20%22needs-more-info%22)%20AND%20Blocked%20in%20(EMPTY%2C%20%22False%22)%20AND%20reporter%20!%3D%20%27openshift-bugzilla-robot%40redhat.com%27 | Open Bug count:> ($openbugs)"
if [ $openbugs -ge 40 ]; then
    odc_bugs+=" :fire::fire:"
fi

odc_bugs+="\n6. <https://issues.redhat.com/browse/ODC-6640?jql=project%20in%20(%22OpenShift%20Dev%20Console%22%2C%20%22OCP%20Bugs%20Mirroring%22%2C%20%22OpenShift%20Bugs%22)%20AND%20component%20in%20(UI%2C%20%22Dev%20Console%22)%20AND%20type%20%3D%20Bug%20AND%20status%20in%20(%22To%20Do%22%2C%20%22In%20Progress%22)%20AND%20reporter%20!%3D%20%27openshift-bugzilla-robot%40redhat.com%27 | Total open bugs (incl. untriaged, blocked):> ( $(curl -H "$authorization" -s 'https://issues.redhat.com/rest/api/2/search?jql=(project%20in%20(%22OpenShift%20Dev%20Console%22%2C%20%22OCP%20Bugs%20Mirroring%22%2C%20%22OpenShift%20Bugs%22)%20AND%20component%20in%20(UI%2C%20%22Dev%20Console%22)%20AND%20type%20%3D%20Bug%20AND%20status%20in%20(%22To%20Do%22%2C%20%22In%20Progress%22)%20AND%20reporter%20!%3D%20%27openshift-bugzilla-robot%40redhat.com%27)' -H "Accept: application/json" | jq '.total'))" 

odc_bugs+="\n7. <https://issues.redhat.com/issues/?jql=project%20%3D%20OCPBUGSM%20AND%20issuetype%20%3D%20Bug%20AND%20status%20in%20(%22In%20Progress%22%2C%20%22To%20Do%22)%20AND%20component%20%3D%20%22Dev%20Console%22 | Open Bugzilla :> ($(curl -H "$authorization" -s 'https://issues.redhat.com/rest/api/2/search?jql=(project%20%3D%20OCPBUGSM%20AND%20issuetype%20%3D%20Bug%20AND%20status%20in%20(%22In%20Progress%22%2C%20%22To%20Do%22)%20AND%20component%20%3D%20%22Dev%20Console%22)' -H "Accept: application/json" | jq '.total'))" 

echo "Fetching Github data"

github_data="\n<https://github.com/search?q=repo%3Aopenshift%2Fhac-dev+repo%3Aopenshift%2Fconsole+repo%3Aopenshift%2Fenhancements+repo%3Aopenshift%2Fconsole-operator+repo%3Aopenshift%2Fapi+-label%3Ado-not-merge%2Fwork-in-progress+-label%3Algtm+author%3Arohitkrai03+author%3Adebsmita1+author%3Ajeff-phillips-18+author%3AinvincibleJai+author%3Anemesis09+author%3Asahil143+author%3Avikram-raj+author%3Achristianvogt+author%3Ajerolimov+author%3AdivyanshiGupta+author%3Arottencandy+author%3Akarthikjeeyar+author%3Aabhinandan13jan+state%3Aopen+created%3A%3C2022-08-15+author%3ALucifergene+author%3Agruselhaus+author%3Alokanandaprabhu&type=Issues&ref=advsearch&l=&l= | PRs Opened for more than 7 days>:  $(curl -s 'https://api.github.com/search/issues?q=repo%3Aopenshift%2Fhac-dev+repo%3Aopenshift%2Fconsole+repo%3Aopenshift%2Fenhancements+repo%3Aopenshift%2Fconsole-operator+repo%3Aopenshift%2Fapi+-label%3Ado-not-merge%2Fwork-in-progress+-label%3Algtm+author%3Arohitkrai03+author%3Adebsmita1+author%3Ajeff-phillips-18+author%3AinvincibleJai+author%3Anemesis09+author%3Asahil143+author%3Avikram-raj+author%3Achristianvogt+author%3Ajerolimov+author%3AdivyanshiGupta+author%3Arottencandy+author%3Akarthikjeeyar+author%3Aabhinandan13jan+state%3Aopen+created%3A%3C2022-08-15+author%3ALucifergene+author%3Agruselhaus+author%3Alokanandaprabhu&type=Issues&ref=advsearch&l=&l=' -H "Accept: application/json" | jq '.total_count')"

github_data+="\n<https://github.com/search?q=repo%3Aopenshift%2Fconsole+repo%3Aopenshift%2Fenhancements+repo%3Aopenshift%2Fconsole-operator+repo%3Aopenshift%2Fapi+repo%3Aopenshift%2Fhac-dev+-label%3Ado-not-merge%2Fwork-in-progress+-label%3Algtm+author%3Arohitkrai03+author%3Adebsmita1+author%3Ajeff-phillips-18+author%3AinvincibleJai+author%3Anemesis09+author%3Asahil143+author%3Avikram-raj+author%3Achristianvogt+author%3Ajerolimov+author%3AdivyanshiGupta+author%3Arottencandy+author%3Akarthikjeeyar+author%3Aabhinandan13jan+author%3Ayozaam+state%3Aopen+author%3ALucifergene+author%3Agruselhaus+author%3Alokanandaprabhu&type=Issues&ref=advsearch&l=&l= | PRs with No LGTM>: $(curl -s 'https://api.github.com/search/issues?q=repo%3Aopenshift%2Fconsole+repo%3Aopenshift%2Fenhancements+repo%3Aopenshift%2Fconsole-operator+repo%3Aopenshift%2Fapi+repo%3Aopenshift%2Fhac-dev+-label%3Ado-not-merge%2Fwork-in-progress+-label%3Algtm+author%3Arohitkrai03+author%3Adebsmita1+author%3Ajeff-phillips-18+author%3AinvincibleJai+author%3Anemesis09+author%3Asahil143+author%3Avikram-raj+author%3Achristianvogt+author%3Ajerolimov+author%3AdivyanshiGupta+author%3Arottencandy+author%3Akarthikjeeyar+author%3Aabhinandan13jan+author%3Ayozaam+state%3Aopen+author%3ALucifergene+author%3Agruselhaus+author%3Alokanandaprabhu&type=Issues&ref=advsearch&l=&l=' -H "Accept: application/json" | jq '.total_count')" 

# Single block cannot take much load

github_data_b="\n<https://github.com/search?q=repo%3Aopenshift%2Fhac-dev+repo%3Aopenshift%2Fconsole+repo%3Aopenshift%2Fenhancements+repo%3Aopenshift%2Fconsole-operator+repo%3Aopenshift%2Fapi+-label%3Aapproved+label%3Algtm+author%3Arohitkrai03+author%3Adebsmita1+author%3Ajeff-phillips-18+author%3AinvincibleJai+author%3Anemesis09+author%3Asahil143+author%3Avikram-raj+author%3Achristianvogt+author%3Ajerolimov+author%3Ayozaam+author%3AdivyanshiGupta+author%3Arottencandy+author%3Akarthikjeeyar+author%3Aabhinandan13jan+state%3Aopen+author%3ALucifergene+author%3Agruselhaus+author%3Alokanandaprabhu&type=Issues&ref=advsearch&l=&l= | PRs without Approval>: $(curl -s 'https://api.github.com/search/issues?q=repo%3Aopenshift%2Fhac-dev+repo%3Aopenshift%2Fconsole+repo%3Aopenshift%2Fenhancements+repo%3Aopenshift%2Fconsole-operator+repo%3Aopenshift%2Fapi+-label%3Aapproved+label%3Algtm+author%3Arohitkrai03+author%3Adebsmita1+author%3Ajeff-phillips-18+author%3AinvincibleJai+author%3Anemesis09+author%3Asahil143+author%3Avikram-raj+author%3Achristianvogt+author%3Ajerolimov+author%3Ayozaam+author%3AdivyanshiGupta+author%3Arottencandy+author%3Akarthikjeeyar+author%3Aabhinandan13jan+state%3Aopen+author%3ALucifergene+author%3Agruselhaus+author%3Alokanandaprabhu&type=Issues&ref=advsearch&l=&l=' | jq '.total_count')" 

github_data_b+="\n<https://github.com/search?q=repo%3Aopenshift%2Fconsole++-label%3Acherry-pick-approved+label%3Abackport-risk-assessed+label%3Abugzilla%2Fvalid-bug+label%3Aapproved+label%3Algtm+author%3Arohitkrai03+author%3Adebsmita1+author%3Ajeff-phillips-18+author%3AinvincibleJai+author%3Anemesis09+author%3Asahil143+author%3Avikram-raj+author%3Achristianvogt+author%3Ajerolimov+author%3Ayozaam+author%3AdivyanshiGupta+author%3Arottencandy+author%3Akarthikjeeyar+author%3Aabhinandan13jan+state%3Aopen+author%3ALucifergene+author%3Agruselhaus+author%3Aopenshift-cherrypick-robot+assignee%3Arohitkrai03+assignee%3Adebsmita1+assignee%3Ajeff-phillips-18+assignee%3AinvincibleJai+assignee%3Anemesis09+assignee%3Asahil143+assignee%3Avikram-raj+assignee%3Achristianvogt+assignee%3Ajerolimov+assignee%3AdivyanshiGupta+assignee%3Arottencandy+assignee%3Akarthikjeeyar+assignee%3Aabhinandan13jan+assignee%3ALucifergene+assignee%3Agruselhaus+author%3Alokanandaprabhu+assignee%3Alokanandaprabhu&type=Issues&ref=advsearch&l=&l= | PRs waiting on cherry-pick-approved>: $(curl -s 'https://api.github.com/search/issues?q=repo%3Aopenshift%2Fconsole++-label%3Acherry-pick-approved+label%3Abackport-risk-assessed+label%3Abugzilla%2Fvalid-bug+label%3Aapproved+label%3Algtm+author%3Arohitkrai03+author%3Adebsmita1+author%3Ajeff-phillips-18+author%3AinvincibleJai+author%3Anemesis09+author%3Asahil143+author%3Avikram-raj+author%3Achristianvogt+author%3Ajerolimov+author%3Ayozaam+author%3AdivyanshiGupta+author%3Arottencandy+author%3Akarthikjeeyar+author%3Aabhinandan13jan+state%3Aopen+author%3ALucifergene+author%3Agruselhaus+author%3Aopenshift-cherrypick-robot+assignee%3Arohitkrai03+assignee%3Adebsmita1+assignee%3Ajeff-phillips-18+assignee%3AinvincibleJai+assignee%3Anemesis09+assignee%3Asahil143+assignee%3Avikram-raj+assignee%3Achristianvogt+assignee%3Ajerolimov+assignee%3AdivyanshiGupta+assignee%3Arottencandy+assignee%3Akarthikjeeyar+assignee%3Aabhinandan13jan+assignee%3ALucifergene+assignee%3Agruselhaus+author%3Alokanandaprabhu+assignee%3Alokanandaprabhu&type=Issues&ref=advsearch&l=&l=' -H "Accept: application/json" | jq '.total_count' )" 

echo "Posting on slack"

############==============HAC--DEV================###############
curl -X POST -H "Content-type:application/json" --data "{\"type\":\"home\", \"blocks\":[{\"type\":\"header\",\"text\":{\"type\":\"plain_text\",\"text\":\"$head\"}},{\"type\":\"section\",\"fields\":[{\"type\":\"mrkdwn\",\"text\":\"$hac_stories\"},{\"type\":\"mrkdwn\",\"text\":\"$hac_bugs\"}]},{\"type\":\"divider\"},{\"type\":\"header\",\"text\":{\"type\":\"plain_text\",\"text\":\"ODC\"}},{\"type\":\"section\",\"fields\":[{\"type\":\"mrkdwn\",\"text\":\"$odc_stories\"},{\"type\":\"mrkdwn\",\"text\":\"$odc_bugs\"}]},{\"type\":\"divider\"},{\"type\":\"header\",\"text\":{\"type\":\"plain_text\",\"text\":\"Github Status\"}},{\"type\":\"section\",\"text\":{\"type\":\"mrkdwn\",\"text\":\"$github_data\"}}, {\"type\":\"section\",\"text\":{\"type\":\"mrkdwn\",\"text\":\"$github_data_b\"}}]}" https://hooks.slack.com/services/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


#curl -X POST -H "Content-type:application/json" --data "{\"type\":\"home\", \"blocks\":[{\"type\":\"header\",\"text\":{\"type\":\"plain_text\",\"text\":\"$head\"}},{\"type\":\"section\",\"fields\":[{\"type\":\"mrkdwn\",\"text\":\"$hac_stories\"},{\"type\":\"mrkdwn\",\"text\":\"$hac_bugs\"}]},{\"type\":\"divider\"},{\"type\":\"header\",\"text\":{\"type\":\"plain_text\",\"text\":\"ODC\"}},{\"type\":\"section\",\"fields\":[{\"type\":\"mrkdwn\",\"text\":\"$odc_stories\"},{\"type\":\"mrkdwn\",\"text\":\"$odc_bugs\"}]},{\"type\":\"divider\"},{\"type\":\"header\",\"text\":{\"type\":\"plain_text\",\"text\":\"Github Status\"}},{\"type\":\"section\",\"text\":{\"type\":\"mrkdwn\",\"text\":\"$github_data\"}}]}" https://hooks.slack.com/services/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


############==============MY-WORKSPACE================###############
# curl -X POST -H "Content-type:application/json" --data "{\"type\":\"home\", \"blocks\":[{\"type\":\"header\",\"text\":{\"type\":\"plain_text\",\"text\":\"$head\"}},{\"type\":\"section\",\"fields\":[{\"type\":\"mrkdwn\",\"text\":\"$hac_stories\"},{\"type\":\"mrkdwn\",\"text\":\"$hac_bugs\"}]},{\"type\":\"divider\"},{\"type\":\"header\",\"text\":{\"type\":\"plain_text\",\"text\":\"ODC\"}},{\"type\":\"section\",\"fields\":[{\"type\":\"mrkdwn\",\"text\":\"$odc_stories\"},{\"type\":\"mrkdwn\",\"text\":\"$odc_bugs\"}]},{\"type\":\"divider\"},{\"type\":\"header\",\"text\":{\"type\":\"plain_text\",\"text\":\"Github Status\"}},{\"type\":\"section\",\"text\":{\"type\":\"mrkdwn\",\"text\":\"$github_data\"}}, {\"type\":\"section\",\"text\":{\"type\":\"mrkdwn\",\"text\":\"$github_data_b\"}}]}" https://hooks.slack.com/services/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

echo "\nDone"