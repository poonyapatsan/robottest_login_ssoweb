*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${LOGIN_URL}          https://idpeself.sso.go.th/login/
${BROWSER}            chrome
${USERNAME_WRONG}     12345678
${PASSWORD_WRONG}     12345678
${USERNAME_CORRECT}   11111111
${PASSWORD_CORRECT}   11111111
${EXPECTED_URL}       https://eself.sso.go.th/#/index  # เปลี่ยนเป็น URL ที่จริงหลังจากล็อกอิน


*** Test Cases ***
Login With Wrong Credentials
    Open Browser    ${LOGIN_URL}    ${BROWSER}
    Maximize Browser Window
    
    # กรอกข้อมูลผิด
    Wait Until Element Is Visible    xpath=//input[@class='form-control txt-label-login']    10s
    Input Text    xpath=//input[@class='form-control txt-label-login']    ${USERNAME_WRONG}
    Input Text    xpath=//input[@type='password']    ${PASSWORD_WRONG}
    Click Button    xpath=//button[contains(text(),'เข้าสู่ระบบ')]
    
    # ตรวจสอบว่า Pop-up แสดงขึ้นมา
    Sleep    3s
    ${popup_visible}=    Run Keyword And Return Status    Element Should Be Visible    xpath=//button[@class='custom-btn' and text()='OK']
    
    IF  '${popup_visible}' == 'True'
        Log    ✅ Pop-up appeared after wrong login!    level=INFO
    ELSE
        Fail    🚨 ERROR: Pop-up not found after wrong login!
    END

    # กดปุ่ม OK บน Pop-up
    Click Element    xpath=//button[@class='custom-btn' and text()='OK']
    Sleep    2s
    Capture Page Screenshot
    Close Browser

*** Test Cases ***
Login With Correct Credentials
    Open Browser    ${LOGIN_URL}    ${BROWSER}
    Maximize Browser Window

    # กรอกข้อมูลที่ถูกต้อง
    Wait Until Element Is Visible    xpath=//input[@class='form-control txt-label-login']    10s
    Input Text    xpath=//input[@class='form-control txt-label-login']    ${USERNAME_CORRECT}
    Input Text    xpath=//input[@type='password']    ${PASSWORD_CORRECT}
    Click Button    xpath=//button[contains(text(),'เข้าสู่ระบบ')]
    
    # รอให้หน้า "หน้าหลัก" ปรากฏขึ้น
    Sleep    3s  # เพิ่มเวลาให้เพียงพอ
    Log    "Waiting for the main page to appear..."
    
    # ตรวจสอบ URL ว่าตรงกับที่คาดหวัง
    ${current_url}=    Get Location
    Log    Current URL is: ${current_url}    level=INFO

    # ตรวจสอบว่า URL ตรงกับที่คาดหวัง
    Should Contain    ${current_url}    ${EXPECTED_URL}    # ใช้ Should Contain แทนเพื่อให้ยอมรับ URL ที่คล้ายกัน

    # ถ้า URL ตรงกับที่คาดหวัง ถือว่าเข้าสู่ระบบสำเร็จ
    Log    ✅ Login Successful and redirected to the correct page.    level=INFO
    Capture Page Screenshot
    Close Browser
