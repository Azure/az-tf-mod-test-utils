require 'colorize'
require 'fileutils'

def get_version_tf
   message = `terraform -version`
   mlist = message.split(" ")
   if mlist.size>2
     return mlist[1]
   else
     raise "ERROR: Get Terraform Version failed!\n#{message}\n".red
   end
end

def lint_tf
  # Do the linting on current working folder.
  print "INFO: Linting Terraform configurations...\n".yellow  
  tf_version = get_version_tf
  if tf_version.start_with?("v0.11.")
    message = `terraform validate -check-variables=false 2>&1`
  elsif tf_version.start_with?("v0.12.")
    success = system ("terraform init")
       if not success
         raise "ERROR: terraform init failed!\n".red
       end
    message = `terraform validate ./ >/dev/null`
  end

  # Check the linting message.
  if not message.empty?
    raise "ERROR: Linting Terraform configurations failed!\n#{message}\n".red
  else
    print "INFO: Done!\n".green
  end
end

def style_tf
  # Do the style checking on current working folder.
  print "INFO: Styling Terraform configurations...\n".yellow
  tf_version = get_version_tf
  if tf_version.start_with?("v0.11.")
    message = `terraform fmt -check=true 2>&1`
  elsif tf_version.start_with?("v0.12.")
    message = `terraform fmt -check 2>&1`
  end

  # Check the styling message.
  if not message.empty?
    raise "ERROR: Styling Terraform configurations failed!\n#{message}\n".red
  else
    print "INFO: Done!\n".green
  end
end

def format_tf
  # Apply the canonical format and style on current working folder.
  print "INFO: Formatting Terraform configurations...\n".yellow
  tf_version = get_version_tf
  if tf_version.start_with?("v0.11.")
    message = `terraform fmt -diff=true 2>&1`
  elsif tf_version.start_with?("v0.12.")
    message = `terraform fmt -diff 2>&1`
  end

  # Check the styling message.
  if not message.empty?
    raise "ERROR: Formatting Terraform configurations failed!\n#{message}\n".red
  else
    print "INFO: Done!\n".green
  end
end
