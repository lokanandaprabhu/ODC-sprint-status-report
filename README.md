# ODC-sprint-status-report

# Prerequisite

create a Personal Access Token (PAT) on JIRA using the below steps. 
  - Go to your profile icon 
  - click on `Profile` 
  - click on `Personal access tokens`
  - Create token and save it.
  
Grant the execute permission for jira.sh script using below command 
  
  `chmod +x ./jira.sh`
  
To create the sprint status report use the below command, this will post the sprint status report to `forum-hac-dev` slack channel.

  `./jira.sh <PAT>`
