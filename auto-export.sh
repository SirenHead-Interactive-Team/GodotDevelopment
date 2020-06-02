#!/bin/bash

LINUX_EXPORTS=linux_automated_exports.cfg
EXPORTS_BACKUP=export_presets.cfg.bkp 
EXPORTS=export_presets.cfg

TEMPLATE_ZIP=Godot_v3.2.1-stable_export_templates.zip

while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do case $1 in
  -c | --clean | --cleanup )
  # revert everything to its original state
  echo "Attempting to clean any byproducts of this script..."
  rm -rf ./templates/
  rm Godot_v3.2.1-stable_export_templates.zip
  
  if  [ -f "$EXPORTS" ]; then
    if cmp -s "$EXPORTS" "$LINUX_EXPORTS"; then
      echo "Current exports config matches linux exports config; deleting"
      rm $EXPORTS
    else
      echo "Exports config found; assumed the users"
    fi
  else
    echo "No exports config present; no action taken"
  fi
  
  if [ -f "$EXPORTS_BACKUP" ]; then
    if cmp -s "$EXPORTS_BACKUP" "$LINUX_EXPORTS"; then
      echo "Backup export config is the same as the linux export config; deleting"
      rm $EXPORTS_BACKUP
    else
      if  [ -f "$EXPORTS" ]; then
        echo "Backup export config and current export config both exist and aren't the linux config"
	echo "  No action taken"
      else
        echo "Backup exports config does not match linux export configs"
        echo "  Assuming backup is the local users, restoring export config..."
        mv $EXPORTS_BACKUP $EXPORTS
      fi
    fi
  else
    echo "No backup exports config present; no action taken"
  fi

  exit
esac; shift; done
if [[ "$1" == '--' ]]; then shift; fi



# download & unzip the templates
if  [ ! -f "$EXPORTS" ]; then
  echo "Downloading godot v3.2.1 templates..."
  wget https://downloads.tuxfamily.org/godotengine/3.2.1/Godot_v3.2.1-stable_export_templates.tpz --output-document $TEMPLATE_ZIP
fi
echo "Unzipping godot v3.2.1 templates..."
unzip -o -q $TEMPLATE_ZIP
# put the templates in the desired linux folder
echo "Copying templates to godot-visible folder..."
sudo mkdir -p ~/.local/share/godot/templates/3.2.1.stable/
sudo cp templates/* ~/.local/share/godot/templates/3.2.1.stable/
if  [ -f "$EXPORTS" ]; then
    if cmp -s "$EXPORTS" "$LINUX_EXPORTS"; then
      echo "Current exports config matches linux exports config"
    else
      echo "User defind configs present - backing them up..."
      # save the poor soul who tries to run this on their local linux install
      mv $EXPORTS $EXPORTS_BACKUP
    fi
fi

if  [ -f "$EXPORTS" ]; then
  echo "No need to copy linux configs, already present"
else
  echo "Linux exports taking precedence..."
  # use the linux configs
  cp $LINUX_EXPORTS $EXPORTS
fi
