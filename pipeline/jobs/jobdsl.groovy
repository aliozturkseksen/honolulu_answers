// pipelines is a map of maps of arrays
// pipelines is a map of pipeline names mapped to maps of stage names mapped to jobs

def create_view(pipeline, triggerjob) {
  view {
    name = pipeline
    configure { view ->
      view.name = 'se.diabol.jenkins.pipeline.DeliveryPipelineView'
      (view / 'name').setValue("${pipeline} View")
      (view / 'noOfPipelines').setValue(3)
      (view / 'noOfColumns').setValue(1)
      (view / 'sorting').setValue("none")
      (view / 'showAvatars').setValue("false")
      (view / 'updateInterval').setValue(2)
      (view / 'showChanges').setValue("false")
      (view / 'showAggregatedPipeline').setValue("false")
      (view / 'componentSpecs' / 'se.diabol.jenkins.pipeline.DeliveryPipelineView_-ComponentSpec' / 'name').setValue(pipeline)
      (view / 'componentSpecs' / 'se.diabol.jenkins.pipeline.DeliveryPipelineView_-ComponentSpec' / 'firstJob').setValue("${triggerjob}-dsl")
    }
  }
}

def create_job(job, nextJob, stage) {
  job {
    name job
  }
}

def pipelines =  [
  "Continuous Delivery Pipeline":[
    "commit":["trigger", "commit"], 
    "acceptance": ["build-and-deploy", "test-application", "terminate-environment"]
    ],
  "Production Delivery Pipeline":[
    "production" : ["production-trigger", "build-and-deploy-for-prod", "smoke-test", "bluegreen"]
    ]
  ]

pipelines.each { pipeline, stages ->
  stageList = stages.keySet().toArray()
  create_view(pipeline, stages[stageList[0]].first())

  // the data structure we define the pipelines in is useful for humans to read, but a pain to look-forward through. Translate to something easier to code around.
    joblist = []
    stages.each { stage, jobs ->
      jobs.each { job ->
        joblist.add([job, stage])
      }
    }

  for (int i = 0; i < joblist.size(); ++ i) {
    job = joblist[i][0]
    nextJob = (i + 1 < joblist.size()) ? joblist[i +1][0] : null
    stage = joblist[i][1]

    job {
        name "${job}-dsl"
        scm {
            git("https://github.com/stelligent/honolulu_answers.git", "master") { node ->
                node / skipTag << "true"
            }
        }
      if (job.equals("trigger")) {
          triggers {
            scm("* * * * *")
          }
      }
      steps {
        shell("pipeline/${job}.sh")
        if (nextJob != null) {
          downstreamParameterized {
            trigger ("${nextJob}-dsl", "ALWAYS"){
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
}