@robot_verification @javascript @barcode-service
Feature: RobotVerification
  In order to ensure that the plates for a batch are placed in the correct beds
  the batch is used to generate labels for a form to prompt the user to put the
  the correct number of plates on, and then to check the barcodes scanned.

  Scenario: 3 source plates should be ordered by bed number and scanner has CR suffix
    Given I have a released cherrypicking batch with 3 plates
    And user "user" has a user barcode of "ID41440E"

    Given I am on the robot verification page
    When I fill in "Scan user ID" with multiline text
    """
    2470041440697
    """
    When I fill in "Scan Tecan robot" with multiline text
    """
    4880000444853
    """
    When I fill in "Scan worksheet" with multiline text
    """
    550000555760
    """
    When I fill in "Scan destination plate" with multiline text
    """
    1220099999705
    """
    And I press "Check"
    Then I should see "Scan robot beds and plates"
    And the source plates should be sorted by bed:
    | Bed    | Plate ID |
    | SCRC 1 | 1        |
    | SCRC 2 | 10       |
    | SCRC 3 | 5        |
    | DEST 1 | 99999    |
    
    
    When I fill in "SCRC 1" with multiline text
    """
    4880000001780
    
    """
    When I fill in "1" with multiline text
    """
    1220000001831
    
    """
    When I fill in "SCRC 2" with multiline text
    """
    4880000002794
    
    """
    When I fill in "5" with multiline text
    """
    1220000005877
    
    """
    When I fill in "SCRC 3" with multiline text
    """
    4880000003807
    
    """
    When I fill in "10" with multiline text
    """
    1220000010734
    
    """
    When I fill in "DEST 1" with multiline text
    """
    4880000020729
    
    """
    When I fill in "99999" with multiline text
    """
    1220099999705
    
    """
    And I press "Verify"
    Then I should see "Download TECAN file"
    Then the downloaded tecan file for batch "550000555760" and plate "1220099999705" is
    """
C;
A;SCRC1;;ABgene_0765;1;;4.0
D;DEST1;;ABgene_0800;1;;4.0
W;
A;SCRC1;;ABgene_0765;9;;4.0
D;DEST1;;ABgene_0800;2;;4.0
W;
A;SCRC2;;ABgene_0765;1;;4.0
D;DEST1;;ABgene_0800;3;;4.0
W;
A;SCRC2;;ABgene_0765;9;;4.0
D;DEST1;;ABgene_0800;4;;4.0
W;
A;SCRC3;;ABgene_0765;1;;4.0
D;DEST1;;ABgene_0800;5;;4.0
W;
A;SCRC3;;ABgene_0765;9;;4.0
D;DEST1;;ABgene_0800;6;;4.0
W;
C;
A;BUFF;;96-TROUGH;1;;9.0
D;DEST1;;ABgene_0800;1;;9.0
W;
A;BUFF;;96-TROUGH;2;;9.0
D;DEST1;;ABgene_0800;2;;9.0
W;
A;BUFF;;96-TROUGH;3;;9.0
D;DEST1;;ABgene_0800;3;;9.0
W;
A;BUFF;;96-TROUGH;4;;9.0
D;DEST1;;ABgene_0800;4;;9.0
W;
A;BUFF;;96-TROUGH;5;;9.0
D;DEST1;;ABgene_0800;5;;9.0
W;
A;BUFF;;96-TROUGH;6;;9.0
D;DEST1;;ABgene_0800;6;;9.0
W;
C;
C; SCRC1 = 1
C; SCRC2 = 10
C; SCRC3 = 5
C;
C; DEST1 = 99999
    """


  Scenario: Barcode scanners with carriage return should not submit page until end
    Given I have a released cherrypicking batch
    And user "user" has a user barcode of "ID41440E"

    Given I am on the robot verification page
    When I fill in "Scan user ID" with multiline text
    """
    2470041440697


    """
    When I fill in "Scan Tecan robot" with multiline text
    """
    4880000444853

    """
    When I fill in "Scan worksheet" with multiline text
    """
    550000555760

    """
    When I fill in "Scan destination plate" with multiline text
    """
    1220099999705

    """
      
    # the last step (with a carriage reture) trigger the check
    # and launch a new page. We want capyra to wait the check is finished 
    # before checking the page. Filling something does it.
    
    When I fill in the following:
    | SCRC 1  | 4880000001780 |
    | 1234567 | 1221234567841 |
    | DEST 1  | 4880000020729 |
    | 99999   | 1220099999705 |

    # we moved this step here, because we need the page to be loaded before checking it.
    Then I should see "Scan robot beds and plates"

    And I press "Verify"
    Then I should see "Download TECAN file"
    Then the downloaded tecan file for batch "550000555760" and plate "1220099999705" is
"""
C;
A;SCRC1;;ABgene_0765;1;;4.0
D;DEST1;;ABgene_0800;1;;4.0
W;
A;SCRC1;;ABgene_0765;2;;3.0
D;DEST1;;ABgene_0800;2;;3.0
W;
A;SCRC1;;ABgene_0765;3;;3.0
D;DEST1;;ABgene_0800;3;;3.0
W;
A;SCRC1;;ABgene_0765;4;;3.0
D;DEST1;;ABgene_0800;4;;3.0
W;
A;SCRC1;;ABgene_0765;5;;3.0
D;DEST1;;ABgene_0800;5;;3.0
W;
A;SCRC1;;ABgene_0765;6;;4.0
D;DEST1;;ABgene_0800;6;;4.0
W;
A;SCRC1;;ABgene_0765;7;;3.0
D;DEST1;;ABgene_0800;7;;3.0
W;
A;SCRC1;;ABgene_0765;8;;3.0
D;DEST1;;ABgene_0800;8;;3.0
W;
A;SCRC1;;ABgene_0765;9;;4.0
D;DEST1;;ABgene_0800;9;;4.0
W;
A;SCRC1;;ABgene_0765;10;;3.0
D;DEST1;;ABgene_0800;10;;3.0
W;
A;SCRC1;;ABgene_0765;11;;3.0
D;DEST1;;ABgene_0800;11;;3.0
W;
A;SCRC1;;ABgene_0765;12;;3.0
D;DEST1;;ABgene_0800;12;;3.0
W;
A;SCRC1;;ABgene_0765;13;;3.0
D;DEST1;;ABgene_0800;13;;3.0
W;
A;SCRC1;;ABgene_0765;14;;4.0
D;DEST1;;ABgene_0800;14;;4.0
W;
A;SCRC1;;ABgene_0765;15;;3.0
D;DEST1;;ABgene_0800;15;;3.0
W;
A;SCRC1;;ABgene_0765;16;;3.0
D;DEST1;;ABgene_0800;16;;3.0
W;
A;SCRC1;;ABgene_0765;17;;4.0
D;DEST1;;ABgene_0800;17;;4.0
W;
A;SCRC1;;ABgene_0765;18;;3.0
D;DEST1;;ABgene_0800;18;;3.0
W;
A;SCRC1;;ABgene_0765;19;;3.0
D;DEST1;;ABgene_0800;19;;3.0
W;
A;SCRC1;;ABgene_0765;20;;3.0
D;DEST1;;ABgene_0800;20;;3.0
W;
A;SCRC1;;ABgene_0765;21;;4.0
D;DEST1;;ABgene_0800;21;;4.0
W;
A;SCRC1;;ABgene_0765;22;;3.0
D;DEST1;;ABgene_0800;22;;3.0
W;
A;SCRC1;;ABgene_0765;23;;3.0
D;DEST1;;ABgene_0800;23;;3.0
W;
A;SCRC1;;ABgene_0765;24;;3.0
D;DEST1;;ABgene_0800;24;;3.0
W;
A;SCRC1;;ABgene_0765;25;;4.0
D;DEST1;;ABgene_0800;25;;4.0
W;
A;SCRC1;;ABgene_0765;26;;3.0
D;DEST1;;ABgene_0800;26;;3.0
W;
A;SCRC1;;ABgene_0765;27;;3.0
D;DEST1;;ABgene_0800;27;;3.0
W;
A;SCRC1;;ABgene_0765;28;;3.0
D;DEST1;;ABgene_0800;28;;3.0
W;
A;SCRC1;;ABgene_0765;29;;4.0
D;DEST1;;ABgene_0800;29;;4.0
W;
A;SCRC1;;ABgene_0765;30;;3.0
D;DEST1;;ABgene_0800;30;;3.0
W;
A;SCRC1;;ABgene_0765;31;;3.0
D;DEST1;;ABgene_0800;31;;3.0
W;
A;SCRC1;;ABgene_0765;32;;3.0
D;DEST1;;ABgene_0800;32;;3.0
W;
A;SCRC1;;ABgene_0765;33;;4.0
D;DEST1;;ABgene_0800;33;;4.0
W;
A;SCRC1;;ABgene_0765;34;;3.0
D;DEST1;;ABgene_0800;34;;3.0
W;
A;SCRC1;;ABgene_0765;35;;3.0
D;DEST1;;ABgene_0800;35;;3.0
W;
A;SCRC1;;ABgene_0765;36;;3.0
D;DEST1;;ABgene_0800;36;;3.0
W;
A;SCRC1;;ABgene_0765;37;;4.0
D;DEST1;;ABgene_0800;37;;4.0
W;
A;SCRC1;;ABgene_0765;38;;3.0
D;DEST1;;ABgene_0800;38;;3.0
W;
A;SCRC1;;ABgene_0765;39;;3.0
D;DEST1;;ABgene_0800;39;;3.0
W;
A;SCRC1;;ABgene_0765;40;;3.0
D;DEST1;;ABgene_0800;40;;3.0
W;
A;SCRC1;;ABgene_0765;41;;4.0
D;DEST1;;ABgene_0800;41;;4.0
W;
A;SCRC1;;ABgene_0765;42;;3.0
D;DEST1;;ABgene_0800;42;;3.0
W;
A;SCRC1;;ABgene_0765;43;;3.0
D;DEST1;;ABgene_0800;43;;3.0
W;
A;SCRC1;;ABgene_0765;44;;3.0
D;DEST1;;ABgene_0800;44;;3.0
W;
A;SCRC1;;ABgene_0765;45;;4.0
D;DEST1;;ABgene_0800;45;;4.0
W;
A;SCRC1;;ABgene_0765;46;;3.0
D;DEST1;;ABgene_0800;46;;3.0
W;
A;SCRC1;;ABgene_0765;47;;3.0
D;DEST1;;ABgene_0800;47;;3.0
W;
A;SCRC1;;ABgene_0765;48;;3.0
D;DEST1;;ABgene_0800;48;;3.0
W;
A;SCRC1;;ABgene_0765;49;;4.0
D;DEST1;;ABgene_0800;49;;4.0
W;
A;SCRC1;;ABgene_0765;50;;3.0
D;DEST1;;ABgene_0800;50;;3.0
W;
A;SCRC1;;ABgene_0765;51;;3.0
D;DEST1;;ABgene_0800;51;;3.0
W;
A;SCRC1;;ABgene_0765;52;;3.0
D;DEST1;;ABgene_0800;52;;3.0
W;
A;SCRC1;;ABgene_0765;53;;4.0
D;DEST1;;ABgene_0800;53;;4.0
W;
A;SCRC1;;ABgene_0765;54;;3.0
D;DEST1;;ABgene_0800;54;;3.0
W;
A;SCRC1;;ABgene_0765;55;;3.0
D;DEST1;;ABgene_0800;55;;3.0
W;
A;SCRC1;;ABgene_0765;56;;3.0
D;DEST1;;ABgene_0800;56;;3.0
W;
A;SCRC1;;ABgene_0765;57;;4.0
D;DEST1;;ABgene_0800;57;;4.0
W;
A;SCRC1;;ABgene_0765;58;;3.0
D;DEST1;;ABgene_0800;58;;3.0
W;
A;SCRC1;;ABgene_0765;59;;3.0
D;DEST1;;ABgene_0800;59;;3.0
W;
A;SCRC1;;ABgene_0765;60;;3.0
D;DEST1;;ABgene_0800;60;;3.0
W;
A;SCRC1;;ABgene_0765;61;;4.0
D;DEST1;;ABgene_0800;61;;4.0
W;
A;SCRC1;;ABgene_0765;62;;3.0
D;DEST1;;ABgene_0800;62;;3.0
W;
A;SCRC1;;ABgene_0765;63;;3.0
D;DEST1;;ABgene_0800;63;;3.0
W;
A;SCRC1;;ABgene_0765;64;;3.0
D;DEST1;;ABgene_0800;64;;3.0
W;
A;SCRC1;;ABgene_0765;65;;4.0
D;DEST1;;ABgene_0800;65;;4.0
W;
A;SCRC1;;ABgene_0765;66;;3.0
D;DEST1;;ABgene_0800;66;;3.0
W;
A;SCRC1;;ABgene_0765;67;;3.0
D;DEST1;;ABgene_0800;67;;3.0
W;
A;SCRC1;;ABgene_0765;68;;3.0
D;DEST1;;ABgene_0800;68;;3.0
W;
A;SCRC1;;ABgene_0765;69;;4.0
D;DEST1;;ABgene_0800;69;;4.0
W;
A;SCRC1;;ABgene_0765;70;;3.0
D;DEST1;;ABgene_0800;70;;3.0
W;
A;SCRC1;;ABgene_0765;71;;3.0
D;DEST1;;ABgene_0800;71;;3.0
W;
A;SCRC1;;ABgene_0765;72;;3.0
D;DEST1;;ABgene_0800;72;;3.0
W;
A;SCRC1;;ABgene_0765;73;;4.0
D;DEST1;;ABgene_0800;73;;4.0
W;
A;SCRC1;;ABgene_0765;74;;3.0
D;DEST1;;ABgene_0800;74;;3.0
W;
A;SCRC1;;ABgene_0765;75;;3.0
D;DEST1;;ABgene_0800;75;;3.0
W;
A;SCRC1;;ABgene_0765;76;;3.0
D;DEST1;;ABgene_0800;76;;3.0
W;
A;SCRC1;;ABgene_0765;77;;4.0
D;DEST1;;ABgene_0800;77;;4.0
W;
A;SCRC1;;ABgene_0765;78;;3.0
D;DEST1;;ABgene_0800;78;;3.0
W;
A;SCRC1;;ABgene_0765;79;;3.0
D;DEST1;;ABgene_0800;79;;3.0
W;
A;SCRC1;;ABgene_0765;80;;3.0
D;DEST1;;ABgene_0800;80;;3.0
W;
A;SCRC1;;ABgene_0765;81;;4.0
D;DEST1;;ABgene_0800;81;;4.0
W;
A;SCRC1;;ABgene_0765;82;;3.0
D;DEST1;;ABgene_0800;82;;3.0
W;
A;SCRC1;;ABgene_0765;83;;3.0
D;DEST1;;ABgene_0800;83;;3.0
W;
A;SCRC1;;ABgene_0765;84;;3.0
D;DEST1;;ABgene_0800;84;;3.0
W;
A;SCRC1;;ABgene_0765;85;;4.0
D;DEST1;;ABgene_0800;85;;4.0
W;
A;SCRC1;;ABgene_0765;86;;3.0
D;DEST1;;ABgene_0800;86;;3.0
W;
A;SCRC1;;ABgene_0765;87;;3.0
D;DEST1;;ABgene_0800;87;;3.0
W;
A;SCRC1;;ABgene_0765;88;;3.0
D;DEST1;;ABgene_0800;88;;3.0
W;
A;SCRC1;;ABgene_0765;89;;4.0
D;DEST1;;ABgene_0800;89;;4.0
W;
A;SCRC1;;ABgene_0765;90;;3.0
D;DEST1;;ABgene_0800;90;;3.0
W;
A;SCRC1;;ABgene_0765;91;;3.0
D;DEST1;;ABgene_0800;91;;3.0
W;
A;SCRC1;;ABgene_0765;92;;3.0
D;DEST1;;ABgene_0800;92;;3.0
W;
A;SCRC1;;ABgene_0765;93;;4.0
D;DEST1;;ABgene_0800;93;;4.0
W;
A;SCRC1;;ABgene_0765;94;;3.0
D;DEST1;;ABgene_0800;94;;3.0
W;
A;SCRC1;;ABgene_0765;95;;3.0
D;DEST1;;ABgene_0800;95;;3.0
W;
A;SCRC1;;ABgene_0765;96;;3.0
D;DEST1;;ABgene_0800;96;;3.0
W;
C;
A;BUFF;;96-TROUGH;1;;9.0
D;DEST1;;ABgene_0800;1;;9.0
W;
A;BUFF;;96-TROUGH;2;;10.0
D;DEST1;;ABgene_0800;2;;10.0
W;
A;BUFF;;96-TROUGH;3;;10.0
D;DEST1;;ABgene_0800;3;;10.0
W;
A;BUFF;;96-TROUGH;4;;10.0
D;DEST1;;ABgene_0800;4;;10.0
W;
A;BUFF;;96-TROUGH;5;;10.0
D;DEST1;;ABgene_0800;5;;10.0
W;
A;BUFF;;96-TROUGH;6;;9.0
D;DEST1;;ABgene_0800;6;;9.0
W;
A;BUFF;;96-TROUGH;7;;10.0
D;DEST1;;ABgene_0800;7;;10.0
W;
A;BUFF;;96-TROUGH;8;;10.0
D;DEST1;;ABgene_0800;8;;10.0
W;
A;BUFF;;96-TROUGH;9;;9.0
D;DEST1;;ABgene_0800;9;;9.0
W;
A;BUFF;;96-TROUGH;10;;10.0
D;DEST1;;ABgene_0800;10;;10.0
W;
A;BUFF;;96-TROUGH;11;;10.0
D;DEST1;;ABgene_0800;11;;10.0
W;
A;BUFF;;96-TROUGH;12;;10.0
D;DEST1;;ABgene_0800;12;;10.0
W;
A;BUFF;;96-TROUGH;13;;10.0
D;DEST1;;ABgene_0800;13;;10.0
W;
A;BUFF;;96-TROUGH;14;;9.0
D;DEST1;;ABgene_0800;14;;9.0
W;
A;BUFF;;96-TROUGH;15;;10.0
D;DEST1;;ABgene_0800;15;;10.0
W;
A;BUFF;;96-TROUGH;16;;10.0
D;DEST1;;ABgene_0800;16;;10.0
W;
A;BUFF;;96-TROUGH;17;;9.0
D;DEST1;;ABgene_0800;17;;9.0
W;
A;BUFF;;96-TROUGH;18;;10.0
D;DEST1;;ABgene_0800;18;;10.0
W;
A;BUFF;;96-TROUGH;19;;10.0
D;DEST1;;ABgene_0800;19;;10.0
W;
A;BUFF;;96-TROUGH;20;;10.0
D;DEST1;;ABgene_0800;20;;10.0
W;
A;BUFF;;96-TROUGH;21;;9.0
D;DEST1;;ABgene_0800;21;;9.0
W;
A;BUFF;;96-TROUGH;22;;10.0
D;DEST1;;ABgene_0800;22;;10.0
W;
A;BUFF;;96-TROUGH;23;;10.0
D;DEST1;;ABgene_0800;23;;10.0
W;
A;BUFF;;96-TROUGH;24;;10.0
D;DEST1;;ABgene_0800;24;;10.0
W;
A;BUFF;;96-TROUGH;25;;9.0
D;DEST1;;ABgene_0800;25;;9.0
W;
A;BUFF;;96-TROUGH;26;;10.0
D;DEST1;;ABgene_0800;26;;10.0
W;
A;BUFF;;96-TROUGH;27;;10.0
D;DEST1;;ABgene_0800;27;;10.0
W;
A;BUFF;;96-TROUGH;28;;10.0
D;DEST1;;ABgene_0800;28;;10.0
W;
A;BUFF;;96-TROUGH;29;;9.0
D;DEST1;;ABgene_0800;29;;9.0
W;
A;BUFF;;96-TROUGH;30;;10.0
D;DEST1;;ABgene_0800;30;;10.0
W;
A;BUFF;;96-TROUGH;31;;10.0
D;DEST1;;ABgene_0800;31;;10.0
W;
A;BUFF;;96-TROUGH;32;;10.0
D;DEST1;;ABgene_0800;32;;10.0
W;
A;BUFF;;96-TROUGH;33;;9.0
D;DEST1;;ABgene_0800;33;;9.0
W;
A;BUFF;;96-TROUGH;34;;10.0
D;DEST1;;ABgene_0800;34;;10.0
W;
A;BUFF;;96-TROUGH;35;;10.0
D;DEST1;;ABgene_0800;35;;10.0
W;
A;BUFF;;96-TROUGH;36;;10.0
D;DEST1;;ABgene_0800;36;;10.0
W;
A;BUFF;;96-TROUGH;37;;9.0
D;DEST1;;ABgene_0800;37;;9.0
W;
A;BUFF;;96-TROUGH;38;;10.0
D;DEST1;;ABgene_0800;38;;10.0
W;
A;BUFF;;96-TROUGH;39;;10.0
D;DEST1;;ABgene_0800;39;;10.0
W;
A;BUFF;;96-TROUGH;40;;10.0
D;DEST1;;ABgene_0800;40;;10.0
W;
A;BUFF;;96-TROUGH;41;;9.0
D;DEST1;;ABgene_0800;41;;9.0
W;
A;BUFF;;96-TROUGH;42;;10.0
D;DEST1;;ABgene_0800;42;;10.0
W;
A;BUFF;;96-TROUGH;43;;10.0
D;DEST1;;ABgene_0800;43;;10.0
W;
A;BUFF;;96-TROUGH;44;;10.0
D;DEST1;;ABgene_0800;44;;10.0
W;
A;BUFF;;96-TROUGH;45;;9.0
D;DEST1;;ABgene_0800;45;;9.0
W;
A;BUFF;;96-TROUGH;46;;10.0
D;DEST1;;ABgene_0800;46;;10.0
W;
A;BUFF;;96-TROUGH;47;;10.0
D;DEST1;;ABgene_0800;47;;10.0
W;
A;BUFF;;96-TROUGH;48;;10.0
D;DEST1;;ABgene_0800;48;;10.0
W;
A;BUFF;;96-TROUGH;49;;9.0
D;DEST1;;ABgene_0800;49;;9.0
W;
A;BUFF;;96-TROUGH;50;;10.0
D;DEST1;;ABgene_0800;50;;10.0
W;
A;BUFF;;96-TROUGH;51;;10.0
D;DEST1;;ABgene_0800;51;;10.0
W;
A;BUFF;;96-TROUGH;52;;10.0
D;DEST1;;ABgene_0800;52;;10.0
W;
A;BUFF;;96-TROUGH;53;;9.0
D;DEST1;;ABgene_0800;53;;9.0
W;
A;BUFF;;96-TROUGH;54;;10.0
D;DEST1;;ABgene_0800;54;;10.0
W;
A;BUFF;;96-TROUGH;55;;10.0
D;DEST1;;ABgene_0800;55;;10.0
W;
A;BUFF;;96-TROUGH;56;;10.0
D;DEST1;;ABgene_0800;56;;10.0
W;
A;BUFF;;96-TROUGH;57;;9.0
D;DEST1;;ABgene_0800;57;;9.0
W;
A;BUFF;;96-TROUGH;58;;10.0
D;DEST1;;ABgene_0800;58;;10.0
W;
A;BUFF;;96-TROUGH;59;;10.0
D;DEST1;;ABgene_0800;59;;10.0
W;
A;BUFF;;96-TROUGH;60;;10.0
D;DEST1;;ABgene_0800;60;;10.0
W;
A;BUFF;;96-TROUGH;61;;9.0
D;DEST1;;ABgene_0800;61;;9.0
W;
A;BUFF;;96-TROUGH;62;;10.0
D;DEST1;;ABgene_0800;62;;10.0
W;
A;BUFF;;96-TROUGH;63;;10.0
D;DEST1;;ABgene_0800;63;;10.0
W;
A;BUFF;;96-TROUGH;64;;10.0
D;DEST1;;ABgene_0800;64;;10.0
W;
A;BUFF;;96-TROUGH;65;;9.0
D;DEST1;;ABgene_0800;65;;9.0
W;
A;BUFF;;96-TROUGH;66;;10.0
D;DEST1;;ABgene_0800;66;;10.0
W;
A;BUFF;;96-TROUGH;67;;10.0
D;DEST1;;ABgene_0800;67;;10.0
W;
A;BUFF;;96-TROUGH;68;;10.0
D;DEST1;;ABgene_0800;68;;10.0
W;
A;BUFF;;96-TROUGH;69;;9.0
D;DEST1;;ABgene_0800;69;;9.0
W;
A;BUFF;;96-TROUGH;70;;10.0
D;DEST1;;ABgene_0800;70;;10.0
W;
A;BUFF;;96-TROUGH;71;;10.0
D;DEST1;;ABgene_0800;71;;10.0
W;
A;BUFF;;96-TROUGH;72;;10.0
D;DEST1;;ABgene_0800;72;;10.0
W;
A;BUFF;;96-TROUGH;73;;9.0
D;DEST1;;ABgene_0800;73;;9.0
W;
A;BUFF;;96-TROUGH;74;;10.0
D;DEST1;;ABgene_0800;74;;10.0
W;
A;BUFF;;96-TROUGH;75;;10.0
D;DEST1;;ABgene_0800;75;;10.0
W;
A;BUFF;;96-TROUGH;76;;10.0
D;DEST1;;ABgene_0800;76;;10.0
W;
A;BUFF;;96-TROUGH;77;;9.0
D;DEST1;;ABgene_0800;77;;9.0
W;
A;BUFF;;96-TROUGH;78;;10.0
D;DEST1;;ABgene_0800;78;;10.0
W;
A;BUFF;;96-TROUGH;79;;10.0
D;DEST1;;ABgene_0800;79;;10.0
W;
A;BUFF;;96-TROUGH;80;;10.0
D;DEST1;;ABgene_0800;80;;10.0
W;
A;BUFF;;96-TROUGH;81;;9.0
D;DEST1;;ABgene_0800;81;;9.0
W;
A;BUFF;;96-TROUGH;82;;10.0
D;DEST1;;ABgene_0800;82;;10.0
W;
A;BUFF;;96-TROUGH;83;;10.0
D;DEST1;;ABgene_0800;83;;10.0
W;
A;BUFF;;96-TROUGH;84;;10.0
D;DEST1;;ABgene_0800;84;;10.0
W;
A;BUFF;;96-TROUGH;85;;9.0
D;DEST1;;ABgene_0800;85;;9.0
W;
A;BUFF;;96-TROUGH;86;;10.0
D;DEST1;;ABgene_0800;86;;10.0
W;
A;BUFF;;96-TROUGH;87;;10.0
D;DEST1;;ABgene_0800;87;;10.0
W;
A;BUFF;;96-TROUGH;88;;10.0
D;DEST1;;ABgene_0800;88;;10.0
W;
A;BUFF;;96-TROUGH;89;;9.0
D;DEST1;;ABgene_0800;89;;9.0
W;
A;BUFF;;96-TROUGH;90;;10.0
D;DEST1;;ABgene_0800;90;;10.0
W;
A;BUFF;;96-TROUGH;91;;10.0
D;DEST1;;ABgene_0800;91;;10.0
W;
A;BUFF;;96-TROUGH;92;;10.0
D;DEST1;;ABgene_0800;92;;10.0
W;
A;BUFF;;96-TROUGH;93;;9.0
D;DEST1;;ABgene_0800;93;;9.0
W;
A;BUFF;;96-TROUGH;94;;10.0
D;DEST1;;ABgene_0800;94;;10.0
W;
A;BUFF;;96-TROUGH;95;;10.0
D;DEST1;;ABgene_0800;95;;10.0
W;
A;BUFF;;96-TROUGH;96;;10.0
D;DEST1;;ABgene_0800;96;;10.0
W;
C;
C; SCRC1 = 1234567
C;
C; DEST1 = 99999
"""






