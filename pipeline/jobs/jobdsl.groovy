def jobs = ['trigger', 'commit', "build-and-deploy", "test-application", "terminate-environment"]

for (i = 0; i < jobs.size; ++ i) {
  job {
      name "${jobs[i]}-dsl"
      scm {
          git('https://github.com/stelligent/honolulu_answers.git', 'master') { node ->
              node / skipTag << 'true'
          }
      }
    if (jobs[i].equals("trigger-stage")) {
        triggers {
          scm('* * * * *')
        }
    }
    steps {
      shell("pipeline/${jobs[i]}.sh")
      if (i + 1 < jobs.size) {
        downstreamParameterized {
          trigger ("${jobs[i+1]}-dsl", "ALWAYS"){
            currentBuild()
            propertiesFile('environment.txt')
          }
        }
      }
    }
    wrappers {
        rvm('1.9.3')
    }
    publishers {
      extendedEmail('jonny@stelligent.com', 'Oops', 'Something broken') {
          trigger("Failure")
          trigger("Fixed")
      }
    }
  }
}