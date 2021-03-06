########################################################################################################################
#!!
#! @input client_id: Azure Client ID
#! @input client_secret: Azure Client Secret Key
#!!#
########################################################################################################################
namespace: Salesforce
flow:
  name: Email_Order
  inputs:
    - user: daniel@rpamf.onmicrosoft.com
    - client_id: 4c800826-f5c8-44a1-b779-2f333099823d
    - client_secret:
        sensitive: true
    - sf_username: rpa-demo@microfocus.com
    - sf_password:
        sensitive: true
  workflow:
    - Get_Authorization_Token:
        do_external:
          18ff19e5-8484-4803-857e-4a2293b91eef:
            - loginAuthority: 'https://login.windows.net/rpamf.onmicrosoft.com/oauth2/token'
            - clientId: '${client_id}'
            - clientSecret:
                value: '${client_secret}'
                sensitive: true
            - proxyHost: "${get_sp('io.cloudslang.salesforce.demo.proxy_host')}"
            - proxyPort: "${get_sp('io.cloudslang.salesforce.demo.proxy_port')}"
            - proxyUsername: "${get_sp('io.cloudslang.salesforce.demo.proxy_username')}"
        publish:
          - authToken
        navigate:
          - success: List_Messages
          - failure: on_failure
    - List_Messages:
        do_external:
          90083ffe-8000-4ddf-b158-22898a5efdfa:
            - authToken: '${authToken}'
            - userPrincipalName: '${user}'
            - folderId: Inbox
            - topQuery: '1'
            - proxyHost: "${get_sp('io.cloudslang.salesforce.demo.proxy_host')}"
            - proxyPort: "${get_sp('io.cloudslang.salesforce.demo.proxy_port')}"
            - proxyUsername: "${get_sp('io.cloudslang.salesforce.demo.proxy_username')}"
        publish:
          - message_json: '${document}'
        navigate:
          - success: get_message_id
          - failure: on_failure
    - get_message_id:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${message_json}'
            - json_path: '$.value[0].id'
        publish:
          - messageId: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: List_Attachments
          - FAILURE: on_failure
    - List_Attachments:
        do_external:
          40f50977-0b1c-4a43-bc37-6453f9a01a36:
            - authToken: '${authToken}'
            - userPrincipalName: '${user}'
            - messageId: '${messageId}'
            - proxyHost: "${get_sp('io.cloudslang.salesforce.demo.proxy_host')}"
            - proxyPort: "${get_sp('io.cloudslang.salesforce.demo.proxy_port')}"
            - proxyUsername: "${get_sp('io.cloudslang.salesforce.demo.proxy_username')}"
        publish:
          - attachmentId
        navigate:
          - success: Get_Attachment
          - failure: on_failure
    - Get_Attachment:
        do_external:
          a5971b46-89e1-4f5a-bef8-ceca822b377f:
            - authToken: '${authToken}'
            - userPrincipalName: '${user}'
            - messageId: '${messageId}'
            - attachmentId: '${attachmentId}'
            - filePath: "C:\\temp"
            - proxyHost: "${get_sp('io.cloudslang.salesforce.demo.proxy_host')}"
            - proxyPort: "${get_sp('io.cloudslang.salesforce.demo.proxy_port')}"
            - proxyUsername: "${get_sp('io.cloudslang.salesforce.demo.proxy_username')}"
        publish:
          - attachment_json: '${document}'
        navigate:
          - success: get_file_name
          - failure: on_failure
    - get_file_name:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${attachment_json}'
            - json_path: $.name
        publish:
          - file_name: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: extract_text_from_pdf
          - FAILURE: on_failure
    - extract_text_from_pdf:
        do:
          io.cloudslang.tesseract.ocr.extract_text_from_pdf:
            - file_path: "${'c:\\\\temp\\\\'+file_name}"
            - data_path: "C:\\Enablement\\tessdata"
            - language: ENG
        publish:
          - text_string
        navigate:
          - SUCCESS: order
          - FAILURE: on_failure
    - order:
        parallel_loop:
          for: 'line in text_string.splitlines()[1:]'
          do:
            Salesforce.order:
              - username: '${sf_username}'
              - password:
                  value: '${sf_password}'
                  sensitive: true
              - account_name: '${line.split()[1]}'
              - order_date: '${line.split()[4]}'
              - contract_number: '${line.split()[2]}'
              - description: '${"order id "+line.split()[0]+" with amount "+line.split()[3]}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Get_Authorization_Token:
        x: 64
        'y': 124
      List_Messages:
        x: 54
        'y': 326
      get_message_id:
        x: 225
        'y': 120
      List_Attachments:
        x: 215
        'y': 322
      Get_Attachment:
        x: 386
        'y': 124
      get_file_name:
        x: 380
        'y': 324
      extract_text_from_pdf:
        x: 532
        'y': 133
      order:
        x: 535
        'y': 326
        navigate:
          2439816b-988f-fb07-2e9e-84b4b2467017:
            targetId: ed019201-a1a4-679c-9598-b18409ddd093
            port: SUCCESS
    results:
      SUCCESS:
        ed019201-a1a4-679c-9598-b18409ddd093:
          x: 701
          'y': 133

