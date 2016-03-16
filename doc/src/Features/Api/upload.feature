@doc
Feature: Upload a program to the website

  Background:
   
    Given there are users:
      | name     | password | token      |
      | Catrobat | 12345    | cccccccccc |
      | User1    | vwxyz    | aaaaaaaaaa |

  Scenario: Upload program
    Given I have the HTTP Request:
          | Method | POST                               |
          | Url    | /pocketcode/api/upload/upload.json |
      And I use the POST parameters:
          | Name          | Value                  |
          | username      | Catrobat               |
          | token         | cccccccccc             |
          | fileChecksum  | <md5 checksum of file> |
      And I attach a catrobat file
      And the POST parameter "fileChecksum" contains the MD5 sum of the given file
      And We assume the next generated token will be "rrrrrrrrrrr"
     When I invoke the Request
     Then I will get the json object:
          """
          {
            "projectId": "1",
            "statusCode": 200,
            "answer": "Your project was uploaded successfully!",
            "token": "rrrrrrrrrrr",
            "preHeaderMessages": ""
          }
          """
