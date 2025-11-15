# clang-tools-extra
Register-ArgumentCompleter -Native -CommandName amdgpu-arch, c-index-test, diagtool, find-all-symbols, hmaptool, modularize, nvptx-arch, offload-arch, run-clang-tidy -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      switch -CaseSensitive (Split-Path -LeafBase $commandAst.GetCommandName()) {
        amdgpu-arch {
          '--help', '--help-list', '--version', '--only=all', '--only=amdgpu', '--only=nvptx', '--verbose'
          break
        }
        c-index-test {
          '-code-completion-at=', '-code-completion-timing=', '-cursor-at=', '-evaluate-cursor-at=', '-get-macro-info-cursor-at=', '-file-refs-at=', '-file-includes-in=', '-check-prefix=', '-index-file', '-index-file-full', '-index-tu', '-index-compile-db', '-test-file-scan', '-test-load-tu', '-test-load-tu-usrs', '-test-load-source', '-test-load-source-memory-usage', '-test-load-source-reparse', '-test-load-source-usrs', '-test-load-source-usrs-memory-usage', '-test-annotate-tokens=', '-test-inclusion-stack-source', '-test-inclusion-stack-tu', '-test-inline-assembly', '-test-print-linkage-source', '-test-print-visibility', '-test-print-type', '-test-print-type-size', '-test-print-bitwidth', '-test-print-target-info', '-test-print-type-declaration', '-print-usr', '-print-usr-file', '-single-symbol-sgfs', '-single-symbol-sgf-at=', '-single-symbol-sgf-for=', '-write-pch', '-compilation-db', '-print-build-session-timestamp', '-read-diagnostics'
          break
        }
        diagtool {
          '-h', '--help', '--help-list', '-V', '--version'
          break
        }
        find-all-symbols {
          '--help', '--help-list', '--version', '--extra-arg=', '--extra-arg-before=', '--merge-dir=', '--output-dir=', '-p'
          break
        }
        hmaptool {
          '-h', '--help', '-v', '--verbose', '--build-path='
          break
        }
        modularize {
          '--color', '-I', '--aarch64-neon-syntax=generic', '--aarch64-neon-syntax=apple', '--aarch64-use-aa', '--abort-on-max-devirt-iterations-reached', '--allow-ginsert-as-artifact', '--amdgpu-atomic-optimizer-strategy=DPP', '--amdgpu-atomic-optimizer-strategy=Iterative', '--amdgpu-atomic-optimizer-strategy=None', '--amdgpu-bypass-slow-div', '--amdgpu-disable-loop-alignment', '--amdgpu-dpp-combine', '--amdgpu-dump-hsa-metadata', '--amdgpu-enable-merge-m0', '--amdgpu-indirect-call-specialization-threshold=', '--amdgpu-kernarg-preload-count=', '--amdgpu-module-splitting-max-depth=', '--amdgpu-promote-alloca-to-vector-limit=', '--amdgpu-promote-alloca-to-vector-max-regs=', '--amdgpu-promote-alloca-to-vector-vgpr-ratio=', '--amdgpu-sdwa-peephole', '--amdgpu-use-aa-in-codegen', '--amdgpu-verify-hsa-metadata', '--amdgpu-vgpr-index-mode', '--arc-contract-use-objc-claim-rv', '--argext-abi-check', '--arm-add-build-attributes', '--arm-implicit-it=always', '--arm-implicit-it=never', '--arm-implicit-it=arm', '--arm-implicit-it=thumb', '--asm-show-inst', '--atomic-counter-update-promoted', '--atomic-first-counter', '--block-check-header-list-only', '--bounds-checking-single-trap', '--bpf-stack-size=', '--cfg-hide-cold-paths=', '--cfg-hide-deoptimize-paths', '--cfg-hide-unreachable-paths', '--check-functions-filter=', '--conditional-counter-update', '--cost-kind=throughput', '--cost-kind=latency', '--cost-kind=code-size', '--cost-kind=size-latency', '--cost-kind=all', '--coverage-check-only', '--crel', '--cs-profile-generate', '--cs-profile-path=', '--ctx-prof-include-empty', '--ctx-profile-force-is-specialized', '--debug-info-correlate', '--debugify-atoms', '--debugify-func-limit=', '--debugify-level=locations', '--debugify-level=location', '--debugify-quiet', '--disable-auto-upgrade-debug-info', '--disable-i2p-p2i-opt', '--disable-promote-alloca-to-lds', '--disable-promote-alloca-to-vector', '--display-file-lists', '--do-counter-promotion', '--dot-cfg-mssa=', '--dwarf-version=', '--dwarf64', '--emit-compact-unwind-non-canonical', '--emit-dwarf-unwind=always', '--emit-dwarf-unwind=no-compact-unwind', '--emit-dwarf-unwind=default', '--emit-gnuas-syntax-on-zos', '--emscripten-cxx-exceptions-allowed=', '--enable-cse-in-irtranslator', '--enable-cse-in-legalizer', '--enable-emscripten-cxx-exceptions', '--enable-emscripten-sjlj', '--enable-gvn-hoist', '--enable-gvn-memdep', '--enable-gvn-memoryssa', '--enable-gvn-sink', '--enable-jump-table-to-switch', '--enable-load-in-loop-pre', '--enable-load-pre', '--enable-loop-simplifycfg-term-folding', '--enable-name-compression', '--enable-split-backedge-in-load-pre', '--enable-split-loopiv-heuristic', '--enable-vtable-profile-use', '--enable-vtable-value-profiling', '--execute-concurrency=', '--executor=', '--expand-variadics-override=unspecified', '--expand-variadics-override=disable', '--expand-variadics-override=optimize', '--expand-variadics-override=lowering', '--experimental-debug-variable-locations', '--fatal-warnings', '--fdpic', '--filter=', '--force-tail-folding-style=none', '--force-tail-folding-style=data', '--force-tail-folding-style=data-without-lane-mask', '--force-tail-folding-style=data-and-control', '--force-tail-folding-style=data-and-control-without-rt-check', '--force-tail-folding-style=data-with-evl', '--fs-profile-debug-bw-threshold=', '--fs-profile-debug-prob-diff-threshold=', '--generate-merged-base-profiles', '--gpsize=', '--hash-based-counter-split', '--hexagon-add-build-attributes', '--hexagon-rdf-limit=', '--hot-cold-split', '--hwasan-percentile-cutoff-hot=', '--hwasan-random-rate=', '--implicit-mapsyms', '--import-all-index', '--incremental-linker-compatible', '--instcombine-code-sinking', '--instcombine-guard-widening-window=', '--instcombine-max-num-phis=', '--instcombine-max-sink-users=', '--instcombine-maxarray-size=', '--instcombine-negator-enabled', '--instcombine-negator-max-depth=', '--instrprof-atomic-counter-update-all', '--internalize-public-api-file=', '--internalize-public-api-list=', '--intrinsic-cost-strategy=instruction-cost', '--intrinsic-cost-strategy=intrinsic-cost', '--intrinsic-cost-strategy=type-based-intrinsic-cost', '--iterative-counter-promotion', '--loongarch-use-aa', '--lower-allow-check-percentile-cutoff-hot=', '--lower-allow-check-random-rate=', '--lto-aix-system-assembler=', '--lto-embed-bitcode=none', '--lto-embed-bitcode=optimized', '--lto-embed-bitcode=post-merge-pre-opt', '--lto-pass-remarks-filter=', '--lto-pass-remarks-format=', '--lto-pass-remarks-output=', '--matrix-default-layout=column-major', '--matrix-default-layout=row-major', '--matrix-print-after-transpose-opt', '--max-counter-promotions=', '--max-counter-promotions-per-loop=', '--mc-relax-all', '--mcabac', '--merror-missing-parenthesis', '--merror-noncontigious-register', '--mhvx', '--mhvx=v60', '--mhvx=v62', '--mhvx=v65', '--mhvx=v66', '--mhvx=v67', '--mhvx=v68', '--mhvx=v69', '--mhvx=v71', '--mhvx=v73', '--mhvx=v75', '--mhvx=v79', '--mips-compact-branches=never', '--mips-compact-branches=optimal', '--mips-compact-branches=always', '--mips16-constant-islands', '--mips16-hard-float', '--mir-strip-debugify-only', '--misexpect-tolerance=', '--mno-compound', '--mno-fixup', '--mno-ldc1-sdc1', '--mno-pairing', '--module-map-path=', '--ms-secure-hotpatch-functions-file=', '--ms-secure-hotpatch-functions-list=', '--mwarn-missing-parenthesis', '--mwarn-noncontigious-register', '--mwarn-sign-mismatch', '--no-coverage-check', '--no-deprecated-warn', '--no-discriminators', '--no-type-check', '--no-warn', '--nvptx-approx-log2f32', '--nvptx-sched4reg', '--object-size-offset-visitor-max-visit-instructions=', '--pgo-block-coverage', '--pgo-temporal-instrumentation', '--pgo-view-block-coverage-graph', '--prefix=', '--print-pipeline-passes', '--problem-files-list=', '--profile-correlate=', '--profile-correlate=debug-info', '--profile-correlate=binary', '--promote-alloca-vector-loop-user-weight=', '--r600-ir-structurize', '--riscv-add-build-attributes', '--riscv-use-aa', '--root-module=', '--runtime-counter-relocation', '--safepoint-ir-verifier-print-only', '--sample-profile-check-record-coverage=', '--sample-profile-check-sample-coverage=', '--sample-profile-max-propagate-iterations=', '--sampled-instr-burst-duration=', '--sampled-instr-period=', '--sampled-instrumentation', '--sanitizer-early-opt-ep', '--save-temp-labels', '--skip-ret-exit-block', '--speculative-counter-promotion-max-exiting=', '--speculative-counter-promotion-to-loop', '--spirv-ext=', '--spv-dump-deps', '--spv-emit-nonsemantic-debug-info', '--summary-file=', '--sve-tail-folding=', '--tail-predication=disabled', '--tail-predication=enabled-no-reductions', '--tail-predication=enabled', '--tail-predication=force-enabled-no-reductions', '--tail-predication=force-enabled', '--target-abi=', '--thinlto-assume-merged', '--threads=', '--translator-compatibility-mode', '--ubsan-guard-checks', '--use-undef', '--verify-region-info', '--vp-counters-per-site=', '--vp-static-alloc', '--wasm-enable-eh', '--wasm-enable-sjlj', '--wasm-use-legacy-eh', '--wholeprogramdevirt-cutoff=', '--x86-align-branch=', '--x86-align-branch-boundary=', '--x86-branches-within-32B-boundaries', '--x86-enable-apx-for-relocation', '--x86-pad-max-prefix-size=', '--x86-relax-relocations', '--x86-sse2avx', '--help', '--help-list', '--version', '--ir2vec-arg-weight=', '--ir2vec-opc-weight=', '--ir2vec-type-weight=', '--ir2vec-vocab-path='
          break
        }
        nvptx-arch {
          '--help', '--help-list', '--version', '--only=all', '--only=amdgpu', '--only=nvptx', '--verbose'
          break
        }
        offload-arch {
          '--help', '--help-list', '--version', '--only=all', '--only=amdgpu', '--only=nvptx', '--verbose'
          break
        }
        pp-trace {
          '--help', '--help-list', '--version', '--callbacks=', '--extra-arg=', '--extra-arg-before=', '--output=', '-p'
          break
        }
        run-clang-tidy {
          '-h', '--help', '-allow-enabling-alpha-checkers', '-clang-tidy-binary', '-clang-apply-replacements-binary', '-checks', '-config', '-config-file', '-exclude-header-filter', '-header-filter', '-source-filter', '-line-filter', '-export-fixes', '-j', '-fix', '-format', '-style=', '-style=none', '-style=file', '-style=llvm', '-style=google', '-style=webkit', '-style=mozilla', '-use-color', '-p', '-extra-arg', '-extra-arg-before', '-quiet', '-load', '-warnings-as-errors', '-allow-no-checks'
          break
        }
      }
    }
    else {
      switch -CaseSensitive (Split-Path -LeafBase $commandAst.GetCommandName()) {
        c-index-test {
          'all', 'local', 'category', 'interface', 'protocol', 'function', 'typedef', 'scan-function'
          break
        }
        diagtool {
          'find-diagnostic-id', 'list-warnings', 'show-enabled', 'tree'
          break
        }
        hmaptool {
          'dump', 'tovfs', 'write'
          break
        }
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
