awswrapper
==========

A tool for repeating operations over multiple aws accounts (and in future,
regions)

What?
-----
Awswrapper is a wrapper for running various aws command-line utilities over
multiple aws accounts. It also has (read "will have very soon") support for
repeating tasks over multiple aws regions as well.

For instance, say you wanted to use the Amazon provided Java cli application
'ec2-describe-vpcs' over a set of production and development accounts. Rather 
than copying and pasting your access keys for each account, you can simply have 
these credentials exported as: 

  DEV_AWS_ACCESS_KEY=asdfkjhsdf
  DEV_AWS_SECRET_KEY=asdfkjhsdf
  PROD_AWS_ACCESS_KEY=asdfkjhsdf
  PROD_AWS_SECRET_KEY=asdfkjhsdf

and run

  awsw -a dev prod -c ec2-describe-vpcs

(provided you've already supplied the other 11 million environment variables it
asks for). Awswrapper will loop over those accounts, substituting these
variables in as AWS_ACCESS_KEY and AWS_SECRET_KEY (and AWS_SECRET_ACCESS_KEY)
before running the given command.

You can also access these variables by including `\$AWS_ACCESS_KEY` in the
command, for example. As it's called through an eval, the variable gets
interpolated and will evaluate in a subshell with the variable set.

I've written most of the code for iterating over region as well, but I needed
the account features most myself so I did them first :)

Why?
----
I get really fed up of repeatedly setting my variables or copying my access keys
when trying to keep all environments across accounts uniform

It should help make auditing more painless.

YMMV
----
Securing your credentials in a safe yet accessible way is your own lookout -
this code doesn't even vaguely touch that :)

Also I make no guarantee that it won't blow up your house.

Contributing
------------
Patches welcome, but write tests! If you run `make test` for the first time, the
Makefile will clone down https://github.com/sstephenson/bats which is a basic
testing framework for bash.
