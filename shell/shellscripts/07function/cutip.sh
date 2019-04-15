#! /bin/bash
cutip() {
	ifconfig | grep "inet " | awk '{print $2}' | cut -d : -f 2
}
cutip

