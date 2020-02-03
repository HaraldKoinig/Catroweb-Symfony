@api
Feature: Search programs

  To find programs, users should be able to search all available programs for specific words

  Background:
    Given there are users:
      | name     | password | token      | id |
      | Catrobat | 12345    | cccccccccc |  1 |
      | User1    | vwxyz    | aaaaaaaaaa |  2 |
      | NewUser  | 54321    | bbbbbbbbbb |  3 |
    And there are programs:
      | id | name            | description | owned by | downloads | views | upload time      | version | language_version  |
      | 1  | Galaxy War      | p1          | User1    | 3         | 12    | 01.01.2013 12:00 | 0.8.5   | 0.750            |
      | 2  | Minions         |             | Catrobat | 33        | 9     | 01.02.2013 13:00 | 0.8.5   | 0.850            |
      | 3  | Fisch           |             | User1    | 133       | 33    | 01.01.2012 13:00 | 0.8.5   | 0.933            |
      | 4  | Ponny           | p2          | User1    | 245       | 33    | 01.01.2012 13:00 | 0.8.5   | 0.810            |
      | 5  | MarkoTheBest    |             | NewUser  | 335       | 33    | 01.01.2012 13:00 | 0.8.5   | 0.850            |
      | 6  | Whack the Marko | Universe    | Catrobat | 2         | 33    | 01.02.2012 13:00 | 0.8.5   | 1.9            |
      | 7  | Superponny      | p1 p2 p3    | User1    | 4         | 33    | 01.01.2012 12:00 | 0.8.5   | 0.933            |
      | 8  | Universe        |             | User1    | 23        | 33    | 01.01.2012 13:00 | 0.8.5   | 0.933            |
      | 9  | Webteam         |             | User1    | 100       | 33    | 01.01.2012 13:00 | 0.8.5   | 0.933            |
      | 10 | Fritz the Cat   |             | User1    | 112       | 33    | 01.01.2012 13:00 | 0.8.5   | 0.933            |
    And the current time is "01.08.2014 13:00"
    And the server name is "catroweb"


  Scenario: A request with specific language version which matches two programs

    Given I have a parameter "max_version" with value "0.800"
    When I GET "/app/api/projects/search.json" with these parameters
    Then I should get the programs "Galaxy War, Whack the Marko" in random order


  Scenario: A request for lower language version for which only one program matches

    Given I have a parameter "max_version" with value "0.760"
    When I GET "/app/api/projects/search.json" with these parameters
    Then I should get the programs "Galaxy War" in random order

  Scenario: The result is in JSON format for an invalid max_version

    Given the HTTP Request:
      | Method | GET                                  |
      | Url    | /pocketcode/api/projects/search.json |
    And the GET parameters:
      | Name        | Value     |
      | limit       | 10        |
      | offset      | 0         |
      | max_version | 0         |
    When the Request is invoked
    Then I should get the json object:
    """
    {
      "CatrobatProjects":[],
      "completeTerm":"",
      "preHeaderMessages":"",
      "CatrobatInformation": {
        "BaseUrl":"(.*?)",
        "TotalProjects":0,
        "ProjectsExtension":".catrobat"
    }
    }
    """


  Scenario: A request for lower language version for which only one program matches returned as JSON

    Given the HTTP Request:
      | Method | GET                           |
      | Url    | /app/api/projects/search.json |
    And the GET parameters:
      | Name        | Value     |
      | q           | Galaxy    |
      | limit       | 10        |
      | max_version | 1     |
    When the Request is invoked
    Then I should get the json object:
      """
      {
        "CatrobatProjects": [{
          "ProjectId": "(.*?)",
          "ProjectName": "Galaxy War",
          "ProjectNameShort": "Galaxy War",
          "Author": "User1",
          "Description": "p1",
          "Version": "0.8.5",
          "Views": 12,
          "Downloads": 3,
          "Private": false,
          "Uploaded": 1357038000,
          "UploadedString": "more than one year ago",
          "ScreenshotBig": "images\/default\/screenshot.png",
          "ScreenshotSmall": "images\/default\/thumbnail.png",
          "ProjectUrl": "app\/project\/(.*?)",
          "DownloadUrl": "app\/download\/(.*?).catrobat",
          "FileSize": 0
        }],
        "completeTerm": "",
        "preHeaderMessages": "",
        "CatrobatInformation": {
          "BaseUrl": "http:\/\/pocketcode.org\/",
          "TotalProjects": 1,
          "ProjectsExtension": ".catrobat"
        }
      }
      """


  Scenario: No programs are found

    When searching for "NOTHINGTOBEFIOUND"
    Then I should get the json object:
      """
      {
        "CatrobatProjects":[],
        "completeTerm":"",
        "preHeaderMessages":"",
        "CatrobatInformation": {
          "BaseUrl":"http://pocketcode.org/",
          "TotalProjects":0,
          "ProjectsExtension":".catrobat"
        }
      }
      """
