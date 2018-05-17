#!groovy

DOCKER_IMAGE_NAME = "reinerjung/kieker.maven"

node('kieker-slave-docker') {
	try {
		stage('Pull Request Check') {
		if ( isPRMergeBuild() ) {
			echo "This build is a pull request from branch '${env.BRANCH_NAME}' to branch '${env.CHANGE_TARGET}'."

			if ( env.CHANGE_TARGET == 'stable' ) {
				error "Pull requests are not allowed to target to the 'stable' branch."
			}
		}
	}

	stage ('Checkout') {
		timeout(time: 3, unit: 'MINUTES') {	// typically finished in under 1 min.
			checkout scm
		}
	}

	stage ('0-prepare logs') {
		sh 'docker run --rm -u `id -u` -v ' + env.WORKSPACE + ':/opt/irl '+DOCKER_IMAGE_NAME+' /bin/bash -c "cd /opt/irl; mvn -s /opt/settings.xml -B -o clean"'
	}

	stage ('1-compile logs') {
		sh 'docker run --rm -u `id -u` -v ' + env.WORKSPACE + ':/opt/irl '+DOCKER_IMAGE_NAME+' /bin/bash -c "cd /opt/irl; mvn -s /opt/settings.xml -B compile"'
	}

	stage ('2-unit-test logs') {
		sh 'docker run --rm -u `id -u` -v ' + env.WORKSPACE + ':/opt/irl '+DOCKER_IMAGE_NAME+' /bin/bash -c "cd /opt/irl; mvn -s /opt/settings.xml -B test"'
		junit '**/build/test-results/test/*.xml'
		step([
		    $class: 'CloverPublisher',
		    cloverReportDir: env.WORKSPACE + '/build/reports/clover',
		    cloverReportFileName: 'clover.xml',
		    healthyTarget: [methodCoverage: 70, conditionalCoverage: 80, statementCoverage: 80], // optional, default is: method=70, conditional=80, statement=80
		    unhealthyTarget: [methodCoverage: 50, conditionalCoverage: 50, statementCoverage: 50], // optional, default is none
		    //failingTarget: [methodCoverage: 0, conditionalCoverage: 0, statementCoverage: 0]     // optional, default is none
		])
	}

//	stage ('3-static-analysis logs') {
//		sh 'docker run --rm -u `id -u` -v ' + env.WORKSPACE + ':/opt/kieker '+DOCKER_IMAGE_NAME+' /bin/bash -c "cd /opt/kieker; ./gradlew -S check"'    
//	}

//	stage ('4-release-checks logs') {
//		sh 'docker run --rm -u `id -u` -v ' + env.WORKSPACE + ':/opt/kieker '+DOCKER_IMAGE_NAME+' /bin/bash -c "cd /opt/kieker; ./gradlew checkReleaseArchivesShort"'

//		checkstyle canComputeNew: false, defaultEncoding: '', healthy: '', pattern: 'kieker-analysis\\build\\reports\\checkstyle\\*.xml,kieker-tools\\build\\reports\\checkstyle\\*.xml,kieker-monitoring\\build\\reports\\checkstyle\\*.xml,kieker-common\\build\\reports\\checkstyle\\*.xml', unHealthy: ''

//		findbugs canComputeNew: false, defaultEncoding: '', excludePattern: '', healthy: '', includePattern: '', pattern: 'kieker-analysis\\build\\reports\\findbugs\\*.xml,kieker-tools\\build\\reports\\findbugs\\*.xml,kieker-monitoring\\build\\reports\\findbugs\\*.xml,kieker-common\\build\\reports\\findbugs\\*.xml', unHealthy: ''

//		pmd canComputeNew: false, defaultEncoding: '', healthy: '', pattern: 'kieker-analysis\\build\\reports\\pmd\\*.xml,kieker-tools\\build\\reports\\pmd\\*.xml,kieker-monitoring\\build\\reports\\pmd\\*.xml,kieker-common\\build\\reports\\pmd\\*.xml', unHealthy: ''

//		archiveArtifacts artifacts: 'build/distributions/*,kieker-documentation/userguide/kieker-userguide.pdf,build/libs/*.jar', fingerprint: true
//	}

//    stage ('push-to-stable') {
//        if (env.BRANCH_NAME == "master") {
//	        sh 'echo "We are in master branch."'
//
//		    sh 'echo "Pushing to stable branch."'
//	        sh 'git push git@github.com:kieker-monitoring/kieker.git $(git rev-parse HEAD):stable'
//        } else {
//            sh 'echo "We are not in master - skipping."'
//	    }
//	}
	} finally {
		deleteDir()
	}
}

// pull request merge builds look like "PR-XXX" where XXX is the pull request number.
def isPRMergeBuild() {
    //return (env.BRANCH_NAME ==~ /^PR-\d+$/)
    //env.CHANGE_ID	// represents the pull request number if not null
    //return env.CHANGE_TARGET != null
    return env.BRANCH_NAME.startsWith('PR-')
}