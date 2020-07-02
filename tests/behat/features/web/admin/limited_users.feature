@admin
Feature: Limited Users
  In a gamejam for schools, a class may use the same account for all students
  In order to prevent students from deleting programs that belong to another student or hijaking the account
  As a teacher
  I need the possibility to prevent program deletions and password changes


  Background:
    Given there are admins:
      | name     | password | token      | email                | id |
      | Adminius | 123456   | eeeeeeeeee | admin@pocketcode.org |  0 |

    And there are users:
      | name     | password | token      | email               | id | limited |
      | Superman | 123456   | cccccccccc | dev1@pocketcode.org |  1 |    1    |
      | Gregor   | 123456   | dddddddddd | dev2@pocketcode.org |  2 |    0    |
      | Hans     | 123456   | ffffffffff | dev3@pocketcode.org |  3 |    0    |
      | Peter    | 123456   | eeeeeeeeee | dev4@pocketcode.org |  4 |    0    |
      | Maier    | 123456   | gggggggggg | dev5@pocketcode.org |  5 |    1    |

    And there are programs:
      | id | name      | description             | owned by | downloads | apk_downloads | views | upload time      | version | language version | visible | apk_ready |
      | 1  | program 1 | my superman description | Superman | 3         | 2             | 12    | 01.01.2013 12:00 | 0.8.5   | 0.94             | true    | true      |
      | 2  | program 2 | abcef                   | Gregor   | 333       | 3             | 9     | 22.04.2014 13:00 | 0.8.5   | 0.93             | true    | true      |
      | 3  | program 3 | abcef                   | Gregor   | 333       | 3             | 9     | 22.04.2014 13:00 | 0.8.5   | 0.93             | true    | true      |

  Scenario: List limited users
    Given I log in as "Adminius" with the password "123456"
    And I am on "/admin/limited_users/list"
    And I wait for the page to be loaded
    Then I should see the limited table:
      | username | email                | limited | enabled |
      | Superman | dev1@pocketcode.org  |    yes  |    yes  |
      | Maier    | dev5@pocketcode.org  |    yes  |    yes  |
      | Gregor   | dev2@pocketcode.org  |    no   |    yes  |
      | Hans     | dev3@pocketcode.org  |    no   |    yes  |
      | Peter    | dev4@pocketcode.org  |    no   |    yes  |
      | Adminius | admin@pocketcode.org |    no   |    yes  |

  Scenario: List only limited users
    Given I log in as "Adminius" with the password "123456"
    And I am on "/admin/limited_users/list?filter%5Busername%5D%5Btype%5D=&filter%5Busername%5D%5Bvalue%5D=&filter%5Bemail%5D%5Btype%5D=&filter%5Bemail%5D%5Bvalue%5D=&filter%5Blimited%5D%5Btype%5D=&filter%5Blimited%5D%5Bvalue%5D=1&filter%5Benabled%5D%5Btype%5D=&filter%5Benabled%5D%5Bvalue%5D=&filter%5B_page%5D=1&filter%5B_sort_by%5D=limited&filter%5B_sort_order%5D=DESC&filter%5B_per_page%5D=32"
    And I wait for the page to be loaded
    Then I should see the limited table:
      | username | email                | limited | enabled |
      | Superman | dev1@pocketcode.org  |    yes  |    yes  |
      | Maier    | dev5@pocketcode.org  |    yes  |    yes  |
    And I should not see "Gregor"
    And I should not see "Hans"
    And I should not see "Peter"

  Scenario: I unlimit a certain user
    Given I log in as "Adminius" with the password "123456"
    And I am on "/admin/limited_users/list?filter%5Busername%5D%5Btype%5D=&filter%5Busername%5D%5Bvalue%5D=&filter%5Bemail%5D%5Btype%5D=&filter%5Bemail%5D%5Bvalue%5D=&filter%5Blimited%5D%5Btype%5D=&filter%5Blimited%5D%5Bvalue%5D=1&filter%5Benabled%5D%5Btype%5D=&filter%5Benabled%5D%5Bvalue%5D=&filter%5B_page%5D=1&filter%5B_sort_by%5D=limited&filter%5B_sort_order%5D=DESC&filter%5B_per_page%5D=32"
    And I wait for the page to be loaded
    Then I should see the limited table:
      | username | email                | limited | enabled |
      | Superman | dev1@pocketcode.org  |    yes  |    yes  |
      | Maier    | dev5@pocketcode.org  |    yes  |    yes  |
    When I click on the username "Superman"
    And I wait for the page to be loaded
    Then I should see "Edit \"Superman\""
    When I click the iCheckHelper which contains "limited" in his label
    And I click on the button named "btn_update_and_list"
    And I wait for the page to be loaded
    And I am on "/admin/limited_users/list?filter%5Busername%5D%5Btype%5D=&filter%5Busername%5D%5Bvalue%5D=&filter%5Bemail%5D%5Btype%5D=&filter%5Bemail%5D%5Bvalue%5D=&filter%5Blimited%5D%5Btype%5D=&filter%5Blimited%5D%5Bvalue%5D=1&filter%5Benabled%5D%5Btype%5D=&filter%5Benabled%5D%5Bvalue%5D=&filter%5B_page%5D=1&filter%5B_sort_by%5D=limited&filter%5B_sort_order%5D=DESC&filter%5B_per_page%5D=32"
    Then I should see the limited table:
      | username | email                | limited | enabled |
      | Maier    | dev5@pocketcode.org  |    yes  |    yes  |
    Then I should not see "Superman"

  Scenario: I limit a certain user
    Given I log in as "Adminius" with the password "123456"
    And I am on "/admin/limited_users/list"
    And I wait for the page to be loaded
    When I click on the username "Gregor"
    And I wait for the page to be loaded
    Then I should see "Edit \"Gregor\""
    When I click the iCheckHelper which contains "limited" in his label
    And I click on the button named "btn_update_and_list"
    And I wait for the page to be loaded
    And I am on "/admin/limited_users/list?filter%5Busername%5D%5Btype%5D=&filter%5Busername%5D%5Bvalue%5D=&filter%5Bemail%5D%5Btype%5D=&filter%5Bemail%5D%5Bvalue%5D=&filter%5Blimited%5D%5Btype%5D=&filter%5Blimited%5D%5Bvalue%5D=1&filter%5Benabled%5D%5Btype%5D=&filter%5Benabled%5D%5Bvalue%5D=&filter%5B_page%5D=1&filter%5B_sort_by%5D=limited&filter%5B_sort_order%5D=DESC&filter%5B_per_page%5D=32"
    Then I should see the limited table:
      | username | email                | limited | enabled |
      | Superman | dev1@pocketcode.org  |    yes  |    yes  |
      | Maier    | dev5@pocketcode.org  |    yes  |    yes  |
      | Gregor   | dev2@pocketcode.org  |    yes  |    yes  |
    Then I should not see "Adminius"
    And I should not see "Hans"
    And I should not see "Peter"

