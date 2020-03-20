## Custom S3 module

This terraform module takes several optional input variables and one
mandatory: `var.bucket` which represents an S3 bucket name.

In addition to bucket name one of the two variables must be non-empty:
either `var.app` or `var.team`. Those two are used for producing non-empty AWS tags
such as `team` and `org`.

Both `team` and `org` AWS tags are produced by another custom modules presented in
this repo: `ownership` or `team_org`.

1. `var.app` passed to the module. The `ownership` module will perform a lookup
in OD service registry and return `team` and `org` outputs. That is preferred method
of provisioning S3 buckets because `app` AWS label is also becoming available.

2. `var.app` is null but `var.team` is present. In that case the `ownwership` modules
returns null for both `team` and `org`, but `team_org` module will do the lookup
in OD service registry instead.

3. If both modules `ownwership` and `team_org` fail to produce proper team/org pair
then the S3 module will fail as well. That would guarantee that all S3 buckets are
properly tagged when provisioned by this custom S3 module.

There is no `output` to the S3 module yet. The result is the terraform resource
`aws_s3_bucket` provisioned and labeled according to its terraform configuration.

### Local testing (for terraform developers)

When we add or modify code for shared terrafrom modules stored in this repo
it is always a good idea to test the new code locally (before PR gets merged).

The `tests` folder contains a number of test S3 buckets configs to validate
each feature we support in S3 shared module (acl grants, encryption, tags, etc).

Here is the recommended sequence to run local tests during terraform development cycle:
```
$ cd tests
$
$ rm -rf .terraform   ## to remove any cached modules as they may change drammaticaly
$ terraform init
$
$ saml2aws login --skip-prompt -a od-eng
$ export AWS_PROFILE=od-eng
$
$ terraform plan
```

*Note* We force the developer to manually enter the proper value for the serviceregistry API
endpoint simply because that internal OD URL does not belong to a public repo.
