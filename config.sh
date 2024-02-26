#!/bin/bash
docker run -itd --name compiler -v ./Arquivos:/p4d/Arquivos -v ./Build:/p4d/Build --workdir /p4d dnredson/p4c
