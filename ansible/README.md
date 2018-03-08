Overview
========

This repository contains ansible playbooks for RH OSP deployment.

Structure
---------

Ansible playbooks in this directory should work for any version of Openstack. In the event this is not possible or does not make sense and the playbook needs to be version specific, it should be named as:

OSP##_{{script_name}}

Where OSP## identifies the intended version of Openstack.

Other Notes
-----------

In the vars sub-directory there are two YAML files with the following functionality:

static.yaml - This should contain variables which don't necessarily change from deployment
              to deployment, however, they might.  Stuff like the undercloud user, the location
              of OTHT, the location of the custom templates used for deployment, etc.

environment.yaml - This should contain variables which are more likely to change from 
                   deployment to deployment.  Items such as networking configuration, NTP,
                   SSL, DNS and Undercloud/Director configuration.


