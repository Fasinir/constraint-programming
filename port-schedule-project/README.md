# Port Scheduling

1. Fork this project
2. Add @mateusz.slazynski as the new project's member (role: ``maintainer``)
3. Change project permissions from ``internal`` to ``private``
4. Check the ``handout.pdf`` for the instructions. Ignore all sections about submitting to coursera.
6. Solve the problem! Do not forget about commiting your changes.
7. You can test your model by runing ``test.sh`` and ``profile.sh`` scripts. They both require decent versions of ``bash`` and ``MiniZinc`` binaries in ``$PATH``). 

## Visualization

If you want to visualize your solution, you have to:

1. Install ``gnuplot`` and make sure it's available in ``$PATH``
2. Compile ``portschedule_draw.cpp``, i.e. ``g++ portschedule_draw.cpp -o visualizer``.
3. Store solution you want to visualize in a file, i.e. ``solution.sol``. Example of an solution to visualize is displayed below:

    ```westend  = [8, 1, 0, 4, 0, 2, 3, 4];
    eastend  = [12, 4, 2, 9, 4, 4, 4, 8];
    stack    = [0, 11, 0, 20, 31, 4, 0, 2];
    endstack = [8, 17, 4, 30, 39, 8, 2, 10];
    reclaim  = [8, 17, 4, 30, 39, 8, 2, 10];
    finish   = [12, 20, 6, 35, 43, 10, 3, 14];
    which    = [3, 1, 2, 1, 1, 2, 1, 1];
    obj = 45;
    ```

4. Run visualier, i.e. ``./visualizer solution.sol``
5. Now there should be file ``solution.sol.ps`` you can view in your favorite PDF reader.
