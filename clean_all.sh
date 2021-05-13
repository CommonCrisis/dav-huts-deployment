#!/bin/bash

microk8s reset
microk8s inspect
microk8s enable dns ingress registry rbac storage helm3