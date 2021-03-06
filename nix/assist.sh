#!/usr/bin/env bash

# shellcheck source=/dev/null
source <(curl -s source "https://raw.githubusercontent.com/rajasoun/common-lib/main/docker/wrapper.sh")

opt="$1"
choice=$( tr '[:upper:]' '[:lower:]' <<<"$opt" )
case ${choice} in
    "clean")
      docker_clean_all
    ;;
    "speed-test")
      speed_test
    ;;
    "wrapper")
      echo -e "${GREEN}\nRun${NC}"
      echo -e "${ORANGE}source <(curl -s source "https://raw.githubusercontent.com/rajasoun/common-lib/main/docker/wrapper.sh")${NC}"
    ;;
    "bash-setup")
      if [ ! -d ~/.oh-my-bash ];then 
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
        yes | cp dotfiles/.bashrc ~/.bashrc
        yes | cp dotfiles/.bash_profile ~/.bash_profile
        echo -e "\n oh-my-bash Installation Done !!!"
      else 
        echo -e "\n oh-my-bash Already Installed !!!"
        echo -e "${ORANGE}Remove ~/.oh-my-bash if you want to re-install${NC}"
      fi
    ;;
    "bash-teardown")
      if [ -d ~/.oh-my-bash ];then 
        rm -fr ~/.oh-my-bash/
        rm -fr ~/.bashrc
        rm -fr ~/.bash_profile 
        echo -e "\n oh-my-bash UnInstallation Done !!!"
      else 
        echo -e "\n oh-my-bash Already UnInstalled !!!"
      fi
    ;;
    *)
    echo "${RED}Usage: $0 < clean | speed-test > ${NC}"
cat <<-EOF
Commands:
---------
  clean       -> Clean all Docker Containers, Volumes and Images
  speed-test  -> Run Speed Test
  wrapper     -> Provides Wrapper command for MinTTY Docker
EOF
    ;;
esac
