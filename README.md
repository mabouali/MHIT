# MATLAB Hydrological Index Tool (MHIT)
MATLAB Hydrological Index Tool (MHIT) provides a collection of high-performance functions that calculates 171 Hydrological indices.

## License
Copyright (c) 2015, Mohammad Abouali (mabouali@gmail.com)

All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

- Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
- Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
- It is being used only for noncommerical use and solely for academic and research purposes.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

## File Structures
There are three folders
- Data: contains a sample data set.
- MFiles: contains all the MATLAB files and codes. There are individual files for each (or a group of) indices. Some other matlab functions are provided to facilitate the calculation of the indices.
- Output: Sample output file

## Test files and examples:
There are three test/example fiels provided.

- Test1.m: This test manually calculates all the indices. This is to show how each individual functions could be used to calculate different indices. This particularly usefull if you have a data set that does not follow the same format and structure as those provided in the data folder. You could read your own data set and then prepare the input that are required for MHIT and call each function separately.
- Test2.m: This example also calculates all the indices for a single stream. However, unlike Test1 it make use of one of the auxilary MATLAB functions, i.e. mhit_getAllIndices.
- Test3.m: This example shows how to use "mhit_getAllInd_AllFiles" auxilary function to calculate the indices for all the streams within a folder. Make sure that the input Directory contains only the data for the streams and an additional file that stores the drainage area.
