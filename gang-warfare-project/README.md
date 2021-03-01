# Gangs' Wars

1. Fork this project into a **private** group:
- if you don't have a private group, create one - give it a name of your team, cool names are cool
- this requirement is caused by a GitLab bug: https://gitlab.com/gitlab-org/gitlab/-/issues/214446
2. Add @mateusz.slazynski as the new project's member (role: ``maintainer``)
4. Change project permissions from ``internal`` to ``private``
5. Check the ``handout.pdf`` for the instructions. Ignore all sections about submitting to coursera.
5. Make sure that output contains a line of form ``obj = <objective>;`` where ``objective`` is the value of optimized function (as in the ``solve maximize <objective>``). 
6. Solve the problem!
7. Automated tests will be run periodically to check quality of your model. The results will be available on top of the ``README.md``. Details will be available in the ``test.log`` file. Of course you can run the tests by yourself - just run the ``test.sh`` script (with decent versions of ``bash`` and ``MiniZinc``). More tests may be added in the future.
8. If done before the deadline, contact @mateusz.slazynski via Slack, so he can check it earlier.
9. To take part in the competition create file ``competition.sol`` containing solution for the ``gw_31_42_00.dzn`` instance.