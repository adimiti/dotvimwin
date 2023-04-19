scriptencoding utf-8
" Vim syntax file
" Language:     EHCP
if exists('b:current_syntax')
  finish
endif

if v:version < 600
  syntax clear
endif

let s:cpo_orig=&cpoptions
set cpoptions&vim

let b:current_syntax = 'ehcp'

syntax sync minlines=100

