def pipelines =  [
  "Continuous Delivery Pipeline":["trigger", "commit", "build-and-deploy", "test-application", "terminate-environment"],
  "Production Delivery Pipeline":["production-trigger", "build-and-deploy-for-prod", "smoke-test", "bluegreen"]
  ]

pipelines.each { pipeline, jobs ->

// Create the jobs
for (i = 0; i < jobs.size; ++ i) {
    job {
        name "${jobs[i]}-dsl"
        scm {
            git("https://github.com/stelligent/honolulu_answers.git", "master") { node ->
                node / skipTag << "true"
            }
        }
      if (jobs[i].equals("trigger-stage")) {
          triggers {
            scm("* * * * *")
          }
      }
      steps {
        shell("pipeline/${jobs[i]}.sh")
        if (i + 1 < jobs.size) {
          downstreamParameterized {
            trigger ("${jobs[i+1]}-dsl", "ALWAYS"){
              currentBuild()
              propertiesFile("environment.txt")
            }
          }
        }
      }
      wrappers {
          rvm("1.9.3")
      }
      publishers {
        extendedEmail("jonny@stelligent.com", "\$PROJECT_NAME - Build # \$BUILD_NUMBER - \$BUILD_STATUS!", """\$PROJECT_NAME - Build # \$BUILD_NUMBER - \$BUILD_STATUS:

  Check console output at \$BUILD_URL to view the results.""") {
            trigger("Failure")
            trigger("Fixed")
        }
      }
    }
  }

  // Create a view for each pipeline
view {
  name = pipeline
  configure { view ->
    view.name = 'se.diabol.jenkins.pipeline.DeliveryPipelineView'
    (view / 'name').setValue("${key} View")
    (view / 'noOfPipelines').setValue(3)
    (view / 'noOfColumns').setValue(1)
    (view / 'sorting').setValue("none")
    (view / 'showAvatars').setValue("false")
    (view / 'updateInterval').setValue(2)
    (view / 'showChanges').setValue("false")
    (view / 'showAggregatedPipeline').setValue("false")
    (view / 'componentSpecs' / 'se.diabol.jenkins.pipeline.DeliveryPipelineView_-ComponentSpec' / 'name').setValue(pipeline)
    (view / 'componentSpecs' / 'se.diabol.jenkins.pipeline.DeliveryPipelineView_-ComponentSpec' / 'firstJob').setValue("${jobs[0]}-dsl")
    }
  }
}