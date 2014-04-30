@jenkins
Feature: Scripted install of Jenkins
    As a continuous delivery engineer
    I would like Jenkins to be installed and configured correctly
    so that that my Jenkins server will work as expected

    Background:
        Given I am testing the local environment

    Scenario Outline: Are the pipeline jobs present?
        When I run "ls /var/lib/jenkins/jobs"
        Then I should see <jobname>
        When I inspect the config for <jobname>
        Then I should see multiscm configured for that job
        Then I should see emails turned on for that job
        Then I should see that the build step is run in an RVM managed environment
        Then I should see that each job has Delivery Pipeline configuration
        Examples: 
            | jobname                         |
            | "trigger-dsl"                   |
            | "commit-dsl"                    |
            | "build-and-deploy-dsl"          |
            | "test-application-dsl"          |
            | "terminate-environment-dsl"     |
            | "production-trigger-dsl"        |
            | "build-and-deploy-for-prod-dsl" |
            | "smoke-test-dsl"                |
            | "bluegreen-dsl"                 |
