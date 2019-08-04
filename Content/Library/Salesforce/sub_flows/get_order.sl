namespace: Salesforce.sub_flows
operation:
  name: get_order
  inputs:
    - lines
  python_action:
    script: "a = lines.split(None ,5);\ntry:\n    id = a[0];\n    account_name = a[1];\n    contract_number = a[2];\n    amount = a[3];\n    start_date = a[4];\n    if len(a) == 5:\n        next_lines = '';  \n    else:\n        next_lines = a[5];\nexcept:\n    id = '';\n    account_name = '';\n    contract_number = '';\n    amount = '';\n    start_date = '';\n    next_lines='';"
  outputs:
    - id: '${id}'
    - account_name: '${account_name}'
    - contract_number: '${contract_number}'
    - amount: '${amount}'
    - start_date: '${start_date}'
    - next_lines: '${next_lines}'
  results:
    - SUCCESS
