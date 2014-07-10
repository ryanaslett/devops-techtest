#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

VAGRANT_CORE_FOLDER=$(echo "$1")

OS=$(/bin/bash "${VAGRANT_CORE_FOLDER}/shell/os-detect.sh" ID)
CODENAME=$(/bin/bash "${VAGRANT_CORE_FOLDER}/shell/os-detect.sh" CODENAME)

# For some dumb reason, vagrant takes the output
# And chops it off in 16384 byte chunks. In order
# To have a clear picture, the txt files gotta be less
# than 16k.
cat "${VAGRANT_CORE_FOLDER}/shell/drupal1.txt"
cat "${VAGRANT_CORE_FOLDER}/shell/drupal2.txt"
cat "${VAGRANT_CORE_FOLDER}/shell/drupal3.txt"
cat "${VAGRANT_CORE_FOLDER}/shell/drupal4.txt"
cat "${VAGRANT_CORE_FOLDER}/shell/drupal5.txt"

if [[ ! -d '/.techtest-stuff' ]]; then
    mkdir '/.techtest-stuff'
    echo 'Created directory /.techtest-stuff'
fi

touch '/.techtest-stuff/vagrant-core-folder.txt'
echo "${VAGRANT_CORE_FOLDER}" > '/.techtest-stuff/vagrant-core-folder.txt'

if [[ ! -f '/.techtest-stuff/initial-setup-base-packages' ]]; then
    if [ "${OS}" == 'debian' ] || [ "${OS}" == 'ubuntu' ]; then
        echo 'Running initial-setup apt-get update'
        apt-get update >/dev/null
        echo 'Finished running initial-setup apt-get update'

        echo 'Installing git'
        apt-get -q -y install git-core >/dev/null
        echo 'Finished installing git'

        if [[ "${CODENAME}" == 'lucid' || "${CODENAME}" == 'precise' ]]; then
            echo 'Installing basic curl packages (Ubuntu only)'
            apt-get install -y libcurl3 libcurl4-gnutls-dev curl >/dev/null
            echo 'Finished installing basic curl packages (Ubuntu only)'
        fi

        echo 'Installing rubygems'
        apt-get install -y rubygems >/dev/null
        echo 'Finished installing rubygems'

        echo 'Installing base packages for r10k'
        apt-get install -y build-essential ruby-dev >/dev/null
        gem install json >/dev/null
        echo 'Finished installing base packages for r10k'

        if [ "${OS}" == 'ubuntu' ]; then
            echo 'Updating libgemplugin-ruby (Ubuntu only)'
            apt-get install -y libgemplugin-ruby >/dev/null
            echo 'Finished updating libgemplugin-ruby (Ubuntu only)'
        fi

        if [ "${CODENAME}" == 'lucid' ]; then
            echo 'Updating rubygems (Ubuntu Lucid only)'
            gem install rubygems-update >/dev/null 2>&1
            /var/lib/gems/1.8/bin/update_rubygems >/dev/null 2>&1
            echo 'Finished updating rubygems (Ubuntu Lucid only)'
        fi

        echo 'Installing r10k'
        gem install r10k >/dev/null 2>&1
        echo 'Finished installing r10k'

        touch '/.techtest-stuff/initial-setup-base-packages'
    elif [[ "${OS}" == 'centos' ]]; then

        echo 'Installing git'
        yum -y install git >/dev/null
        echo 'Finished installing git'

        echo 'Installing basic development tools (CentOS)'
        yum -y groupinstall 'Development Tools' >/dev/null
        echo 'Finished installing basic development tools (CentOS)'

        echo 'Installing r10k'
        gem install r10k >/dev/null 2>&1
        echo 'Finished installing r10k'

        touch '/.techtest-stuff/initial-setup-base-packages'
    fi
fi
