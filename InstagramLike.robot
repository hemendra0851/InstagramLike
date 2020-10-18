*** Settings ***
Library    SeleniumLibrary    run_on_failure=Nothing
#Library    PyYaml
Library    Screenshot
Variables    Locators.yaml

*** Variables ***
${url}    https://www.instagram.com


*** Test Cases ***
instagramLike
   Sleep    5
   Open_Instagram
   Login_user
   SaveInfo
   TurnOnNotification
   SearchText
   ClickImage
   FOR    ${i}    IN RANGE    1    1000
      LikeImage
   END

*** Keywords ***

Open_Instagram
   Open Browser    ${url}    Chrome
   Maximize Browser Window

Login_user
   ${Result}=    WaitForElement    ${loginPage.email}
   Input Text    ${loginPage.email}    ${userDetail.username}
   Input Text    ${loginPage.password}    ${userDetail.password}
   Submit Form

SaveInfo
   ${Result}=    WaitForElement    ${prompt.saveInfo}
   Run Keyword If    '${Result}' == 'True'    Click Element    ${prompt.notNow}

TurnOnNotification
   ${Result}=    WaitForElement    ${prompt.turnOn}
   Run Keyword If    '${Result}' == 'True'    Click Element    ${prompt.notNow}

SearchText
   Click Element    ${dashboard.search}
   Input Text    ${dashboard.txtSearch}    ${dashboard.text}
   ${Result}=    WaitForElement    ${dashboard.result}
   Click Element    ${dashboard.result}
   Sleep    5
   ${Result}=    WaitForElement    (//div[contains(@class,'v1Nh3 kIKUG')])[1]

ClickImage
   Click Element    (//div[contains(@class,'v1Nh3 kIKUG')])[1]
   ${Result}=    WaitForElement    ${searchResult.share}
   Should Be True    ${Result}

LikeImage
   ${temp}=    WaitForElement    ${searchResult.share}
   ${Like}=    Run Keyword And Return Status    Page Should Contain Element    ${searchResult.like}
   ${Unlike}=    Run Keyword And Return Status    Page Should Contain Element    ${searchResult.unlike}
   Run Keyword If    '${Like}' == 'True'    Click Element    ${searchResult.like}
   Sleep    1
   Click Element    ${searchResult.next}
   #//*[name()='svg' and @fill='#262626']


WaitForElement
   [Arguments]    ${element}
   FOR    ${i}    IN RANGE    1    10
      Sleep    1
      ${Result}=    Run Keyword And Return Status    Page Should Contain Element    ${element}
      Exit For Loop If    '${Result}' == 'True'
   END
   Return From Keyword    ${Result}

