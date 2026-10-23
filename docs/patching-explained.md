# What type of patching does Ansible perform here?

The source PDF defines patching as applying software updates to fix bugs, improve functionality or address security vulnerabilities. It mentions binary patches and source-code patches.

In this project, Ansible uses the APT package manager to install or upgrade the Jenkins Debian package. This is **binary/package patching**: the system replaces installed package files with files from the configured repository. The playbook does not edit Jenkins source code.

The upgrade play uses `ansible.builtin.apt` with `state: latest`, which installs the latest candidate version available from the configured repository at the time the playbook runs. It does not guarantee a particular numeric version in the future. For controlled production changes, use an approved version, maintenance window, backup, compatibility review, staged rollout and post-change verification.
