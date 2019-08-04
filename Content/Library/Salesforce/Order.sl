namespace: Salesforce
operation:
  name: Order
  inputs:
    - username
    - password:
        sensitive: true
    - account_name
    - order_date
    - contract_number
    - description
  sequential_action:
    gav: 'com.microfocus.seq:Salesforce.Order:1.0.0'
    steps:
      - step:
          id: '1'
          object_path: 'Browser("Login | Salesforce").Page("Login | Salesforce").WebEdit("username")'
          action: Set
          default_args: '"petr.panuska-cszm@force.com"'
          snapshot: ".\\Snapshots\\ssf1.html"
          highlight_id: '10000000'
          args: 'Parameter("username")'
      - step:
          id: '2'
          object_path: 'Browser("Login | Salesforce").Page("Login | Salesforce").WebEdit("pw")'
          action: SetSecure
          default_args: '"Cloud_123456"'
          snapshot: ".\\Snapshots\\ssf2.html"
          highlight_id: '10000000'
          args: 'Parameter("password")'
      - step:
          id: '3'
          object_path: 'Browser("Login | Salesforce").Page("Login | Salesforce").WebButton("Log In")'
          action: Click
          snapshot: ".\\Snapshots\\ssf3.html"
          highlight_id: '10000000'
      - step:
          id: '4'
          object_path: 'Browser("Login | Salesforce").Page("Salesforce - Professional").Link("Orders")'
          action: Click
          snapshot: ".\\Snapshots\\ssf4.html"
          highlight_id: '10000000'
      - step:
          id: '5'
          object_path: 'Browser("Login | Salesforce").Page("Orders: Home ~ Salesforce").WebButton("New")'
          action: Click
          snapshot: ".\\Snapshots\\ssf5.html"
          highlight_id: '10000000'
      - step:
          id: '7'
          object_path: 'Browser("Login | Salesforce").Page("New Order ~ Salesforce").WebEdit("accid")'
          action: Set
          default_args: '"Delta"'
          snapshot: ".\\Snapshots\\ssf7.html"
          highlight_id: '10000000'
          args: 'Parameter("account_name")'
      - step:
          id: '9'
          object_path: 'Browser("Login | Salesforce").Page("New Order ~ Salesforce").WebEdit("Contract")'
          action: Set
          default_args: '"00000101"'
          snapshot: ".\\Snapshots\\ssf9.html"
          highlight_id: '10000000'
          args: 'Parameter("contract_number")'
      - step:
          id: '10'
          object_path: 'Browser("Login | Salesforce").Page("New Order ~ Salesforce").WebEdit("EffectiveDate")'
          action: Set
          default_args: '"16/7/2019"'
          snapshot: ".\\Snapshots\\ssf10.html"
          highlight_id: '10000000'
          args: 'Parameter("order_date")'
      - step:
          id: '11'
          object_path: 'Browser("Login | Salesforce").Page("New Order ~ Salesforce").WebEdit("Description")'
          action: Set
          default_args: '"Ordering for Delta"'
          snapshot: ".\\Snapshots\\ssf11.html"
          highlight_id: '10000000'
          args: 'Parameter("description")'
      - step:
          id: '12'
          object_path: 'Browser("Login | Salesforce").Page("New Order ~ Salesforce").WebButton("Save")'
          action: Click
          snapshot: ".\\Snapshots\\ssf12.html"
          highlight_id: '10000000'
      - step:
          id: '14'
          object_path: 'Browser("Login | Salesforce").Page("Order 00000132 ~ Salesforce").WebElement("Order 00000132")'
          action: Output
          default_args: 'CheckPoint("order_number")'
  outputs:
    - order_number:
        robot: true
        value: '${order_number}'
    - return_result: '${return_result}'
    - error_message: '${error_message}'
  results:
    - SUCCESS
    - WARNING
    - FAILURE
