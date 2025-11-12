using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName openssl -ScriptBlock {
  param ([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
  $command = @(foreach ($i in $commandAst.CommandElements) {
      if ($i.Extent.StartOffset -eq $commandAst.Extent.StartOffset -or $i.Extent.EndOffset -eq $cursorPosition) {
        continue
      }
      if ($i -isnot [StringConstantExpressionAst] -or
        $i.StringConstantType -ne [StringConstantType]::BareWord -or
        $i.Value.StartsWith('-')) {
        break
      }
      $i.Value
    }) -join ' '
  $command = switch -CaseSensitive -Regex ($command) {
    '^(blake2b512|blake2s256|md4|md5|mdc2|rmd160|sha1|sha224|sha256|sha3-224|sha3-256|sha3-384|sha3-512|sha384|sha512|sha512-224|sha512-256|shake128|shake256|sm3)$' { 'dgst'; break }
    '^(aes-128-cbc|aes-128-ecb|aes-192-cbc|aes-192-ecb|aes-256-cbc|aes-256-ecb|aria-128-cbc|aria-128-cfb|aria-128-cfb1|aria-128-cfb8|aria-128-ctr|aria-128-ecb|aria-128-ofb|aria-192-cbc|aria-192-cfb|aria-192-cfb1|aria-192-cfb8|aria-192-ctr|aria-192-ecb|aria-192-ofb|aria-256-cbc|aria-256-cfb|aria-256-cfb1|aria-256-cfb8|aria-256-ctr|aria-256-ecb|aria-256-ofb|base64|bf|bf-cbc|bf-cfb|bf-ecb|bf-ofb|camellia-128-cbc|camellia-128-ecb|camellia-192-cbc|camellia-192-ecb|camellia-256-cbc|camellia-256-ecb|cast|cast-cbc|cast5-cbc|cast5-cfb|cast5-ecb|cast5-ofb|des|des-cbc|des-cfb|des-ecb|des-ede|des-ede-cbc|des-ede-cfb|des-ede-ofb|des-ede3|des-ede3-cbc|des-ede3-cfb|des-ede3-ofb|des-ofb|des3|desx|idea|idea-cbc|idea-cfb|idea-ecb|idea-ofb|rc2|rc2-40-cbc|rc2-64-cbc|rc2-cbc|rc2-cfb|rc2-ecb|rc2-ofb|rc4|rc4-40|seed|seed-cbc|seed-cfb|seed-ecb|seed-ofb|sm4-cbc|sm4-cfb|sm4-ctr|sm4-ecb|sm4-ofb)$' { 'enc'; break }
    default { $_; break }
  }
  $cursorPosition -= $wordToComplete.Length
  foreach ($i in $commandAst.CommandElements) {
    if ($i.Extent.StartOffset -ge $cursorPosition) {
      break
    }
    $prev = $i
  }
  $prev = $prev -is [System.Management.Automation.Language.StringConstantExpressionAst] ? $prev.Value : $prev.ToString()
  @(switch ($command) {
      '' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '-v', '--version'
          break
        }
        'asn1parse', 'ca', 'ciphers', 'cmp', 'cms', 'crl', 'crl2pkcs7', 'dgst', 'dhparam', 'dsa', 'dsaparam', 'ec', 'ecparam', 'enc', 'engine', 'errstr', 'fipsinstall', 'gendsa', 'genpkey', 'genrsa', 'help', 'info', 'kdf', 'list', 'mac', 'nseq', 'ocsp', 'passwd', 'pkcs12', 'pkcs7', 'pkcs8', 'pkey', 'pkeyparam', 'pkeyutl', 'prime', 'rand', 'rehash', 'req', 'rsa', 'rsautl', 's_client', 's_server', 's_time', 'sess_id', 'skeyutl', 'smime', 'speed', 'spkac', 'srp', 'storeutl', 'ts', 'verify', 'version', 'x509', 'blake2b512', 'blake2s256', 'md4', 'md5', 'mdc2', 'rmd160', 'sha1', 'sha224', 'sha256', 'sha3-224', 'sha3-256', 'sha3-384', 'sha3-512', 'sha384', 'sha512', 'sha512-224', 'sha512-256', 'shake128', 'shake256', 'sm3', 'aes-128-cbc', 'aes-128-ecb', 'aes-192-cbc', 'aes-192-ecb', 'aes-256-cbc', 'aes-256-ecb', 'aria-128-cbc', 'aria-128-cfb', 'aria-128-cfb1', 'aria-128-cfb8', 'aria-128-ctr', 'aria-128-ecb', 'aria-128-ofb', 'aria-192-cbc', 'aria-192-cfb', 'aria-192-cfb1', 'aria-192-cfb8', 'aria-192-ctr', 'aria-192-ecb', 'aria-192-ofb', 'aria-256-cbc', 'aria-256-cfb', 'aria-256-cfb1', 'aria-256-cfb8', 'aria-256-ctr', 'aria-256-ecb', 'aria-256-ofb', 'base64', 'bf', 'bf-cbc', 'bf-cfb', 'bf-ecb', 'bf-ofb', 'camellia-128-cbc', 'camellia-128-ecb', 'camellia-192-cbc', 'camellia-192-ecb', 'camellia-256-cbc', 'camellia-256-ecb', 'cast', 'cast-cbc', 'cast5-cbc', 'cast5-cfb', 'cast5-ecb', 'cast5-ofb', 'des', 'des-cbc', 'des-cfb', 'des-ecb', 'des-ede', 'des-ede-cbc', 'des-ede-cfb', 'des-ede-ofb', 'des-ede3', 'des-ede3-cbc', 'des-ede3-cfb', 'des-ede3-ofb', 'des-ofb', 'des3', 'desx', 'idea', 'idea-cbc', 'idea-cfb', 'idea-ecb', 'idea-ofb', 'rc2', 'rc2-40-cbc', 'rc2-64-cbc', 'rc2-cbc', 'rc2-cfb', 'rc2-ecb', 'rc2-ofb', 'rc4', 'rc4-40', 'seed', 'seed-cbc', 'seed-cfb', 'seed-ecb', 'seed-ofb', 'sm4-cbc', 'sm4-cfb', 'sm4-ctr', 'sm4-ecb', 'sm4-ofb'
        break
      }
      'asn1parse' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-oid', '-inform', '-in', '-out', '-noout', '-offset', '-length', '-strparse', '-genstr', '-genconf', '-strictpem', '-item', '-i', '-dump', '-dlimit'
          break
        }
        break
      }
      'ca' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-verbose', '-quiet', '-outdir', '-in', '-inform', '-infiles', '-out', '-dateopt', '-notext', '-batch', '-msie_hack', '-ss_cert', '-spkac', '-engine', '-config', '-name', '-section', '-policy', '-subj', '-utf8', '-create_serial', '-rand_serial', '-multivalue-rdn', '-startdate', '-not_before', '-enddate', '-not_after', '-days', '-extensions', '-extfile', '-preserveDN', '-noemailDN', '-md', '-keyfile', '-keyform', '-passin', '-key', '-cert', '-certform', '-selfsign', '-sigopt', '-vfyopt', '-gencrl', '-valid', '-status', '-updatedb', '-crlexts', '-crl_reason', '-crl_hold', '-crl_compromise', '-crl_CA_compromise', '-crl_lastupdate', '-crl_nextupdate', '-crldays', '-crlhours', '-crlsec', '-revoke', '-rand', '-writerand', '-provider', '-provider-path', '-provparam', '-propquery'
          break
        }
        break
      }
      'ciphers' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-v', '-V', '-stdname', '-convert', '-s', '-tls1', '-tls1_1', '-tls1_2', '-tls1_3', '-psk', '-srp', '-ciphersuites', '-provider', '-provider', '-provparam', '-propquery'
          break
        }
        break
      }
      'cmp' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-config', '-section', '-verbosity', '-cmd', '-infotype', '-profile', '-geninfo', '-template', '-keyspec', '-newkey', '-newkeypass', '-centralkeygen', '-newkeyout', '-subject', '-days', '-reqexts', '-sans', '-san_nodefault', '-policies', '-policy_oids', '-policy_oids_critical', '-popo', '-csr', '-out_trusted', '-implicit_confirm', '-disable_confirm', '-certout', '-chainout', '-oldcert', '-issuer', '-serial', '-revreason', '-server', '-proxy', '-no_proxy', '-recipient', '-path', '-keep_alive', '-msg_timeout', '-total_timeout', '-trusted', '-untrusted', '-srvcert', '-expect_sender', '-ignore_keyusage', '-unprotected_errors', '-no_cache_extracerts', '-srvcertout', '-extracertsout', '-cacertsout', '-oldwithold', '-newwithnew', '-newwithold', '-oldwithnew', '-crlcert', '-oldcrl', '-crlout', '-ref', '-secret', '-cert', '-own_trusted', '-key', '-keypass', '-digest', '-mac', '-extracerts', '-unprotected_requests', '-certform', '-crlform', '-keyform', '-otherpass', '-engine', '-provider', '-provider-path', '-provparam', '-propquery', '-rand', '-writerand', '-tls_used', '-tls_cert', '-tls_key', '-tls_keypass', '-tls_extra', '-tls_trusted', '-tls_host', '-batch', '-repeat', '-reqin', '-reqin_new_tid', '-reqout', '-reqout_only', '-rspin', '-rspout', '-use_mock_srv', '-port', '-max_msgs', '-srv_ref', '-srv_secret', '-srv_cert', '-srv_key', '-srv_keypass', '-srv_trusted', '-srv_untrusted', '-ref_cert', '-rsp_cert', '-rsp_key', '-rsp_keypass', '-rsp_crl', '-rsp_extracerts', '-rsp_capubs', '-rsp_newwithnew', '-rsp_newwithold', '-rsp_oldwithnew', '-poll_count', '-check_after', '-grant_implicitconf', '-pkistatus', '-failure', '-failurebits', '-statusstring', '-send_error', '-send_unprotected', '-send_unprot_err', '-accept_unprotected', '-accept_unprot_err', '-accept_raverified', '-policy', '-purpose', '-verify_name', '-verify_depth', '-auth_level', '-attime', '-verify_hostname', '-verify_email', '-verify_ip', '-ignore_critical', '-issuer_checks', '-crl_check', '-crl_check_all', '-policy_check', '-explicit_policy', '-inhibit_any', '-inhibit_map', '-x509_strict', '-extended_crl', '-use_deltas', '-policy_print', '-check_ss_sig', '-trusted_first', '-suiteB_128_only', '-suiteB_128', '-suiteB_192', '-partial_chain', '-no_alt_chains', '-no_check_time', '-allow_proxy_certs'
          break
        }
        break
      }
      'cms' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-in', '-out', '-config', '-encrypt', '-decrypt', '-sign', '-verify', '-resign', '-sign_receipt', '-verify_receipt', '-digest', '-digest_create', '-digest_verify', '-compress', '-uncompress', '-EncryptedData_encrypt', '-EncryptedData_decrypt', '-data_create', '-data_out', '-cmsout', '-inform', '-outform', '-rctform', '-stream', '-indef', '-noindef', '-binary', '-crlfeol', '-asciicrlf', '-pwri_password', '-secretkey', '-secretkeyid', '-inkey', '-passin', '-keyopt', '-keyform', '-engine', '-provider', '-provider', '-provparam', '-propquery', '-rand', '-writerand', '-originator', '-recip', '-cert', '-wrap', '-aes128', '-aes192', '-aes256', '-des3', '-debug_decrypt', '-md', '-signer', '-certfile', '-cades', '-nodetach', '-nocerts', '-noattr', '-nosmimecap', '-no_signing_time', '-receipt_request_all', '-receipt_request_first', '-receipt_request_from', '-receipt_request_to', '-signer', '-content', '-no_content_verify', '-no_attr_verify', '-nosigs', '-noverify', '-nointern', '-cades', '-verify_retcode', '-CAfile', '-CApath', '-CAstore', '-no', '-no', '-no', '-keyid', '-econtent_type', '-text', '-certsout', '-to', '-from', '-subject', '-noout', '-print', '-nameopt', '-receipt_request_print', '-policy', '-purpose', '-verify_name', '-verify_depth', '-auth_level', '-attime', '-verify_hostname', '-verify_email', '-verify_ip', '-ignore_critical', '-issuer_checks', '-crl_check', '-crl_check_all', '-policy_check', '-explicit_policy', '-inhibit_any', '-inhibit_map', '-x509_strict', '-extended_crl', '-use_deltas', '-policy_print', '-check_ss_sig', '-trusted_first', '-suiteB_128_only', '-suiteB_128', '-suiteB_192', '-partial_chain', '-no_alt_chains', '-no_check_time', '-allow_proxy_certs'
          break
        }
        break
      }
      'crl' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-verify', '-in', '-inform', '-key', '-keyform', '-out', '-outform', '-dateopt', '-text', '-hash', '-hash_old', '-nameopt', '-issuer', '-lastupdate', '-nextupdate', '-noout', '-fingerprint', '-crlnumber', '-badsig', '-gendelta', '-CApath', '-CAfile', '-CAstore', '-no-CAfile', '-no-CApath', '-no-CAstore', '-provider-path', '-provider', '-provparam', '-propquery'
          break
        }
        break
      }
      'crl2pkcs7' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-in', '-inform', '-nocrl', '-certfile', '-out', '-outform', '-provider', '-provider', '-provparam', '-propquery'
          break
        }
        break
      }
      'dgst' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-list', '-engine', '-engine_impl', '-passin', '-c', '-r', '-out', '-keyform', '-hex', '-binary', '-xoflen', '-d', '-debug', '-sign', '-verify', '-prverify', '-sigopt', '-signature', '-hmac', '-mac', '-macopt', '-fips-fingerprint', '-rand', '-writerand', '-provider-path', '-provider', '-provparam', '-propquery'
          break
        }
        break
      }
      'dhparam' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-check', '-dsaparam', '-engine', '-in', '-inform', '-out', '-outform', '-text', '-noout', '-2', '-3', '-5', '-verbose', '-quiet', '-rand', '-writerand', '-provider', '-provider-path', '-provparam', '-propquery'
          break
        }
        break
      }
      'dsa' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-pvk-strong', '-pvk-weak', '-pvk-none', '-engine', '-in', '-inform', '-pubin', '-passin', '-out', '-outform', '-noout', '-text', '-modulus', '-pubout', '-passout', '-provider-path', '-provider', '-provparam', '-propquery'
          break
        }
        break
      }
      'dsaparam' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-engine', '-in', '-inform', '-out', '-outform', '-text', '-noout', '-verbose', '-quiet', '-genkey', '-rand', '-writerand', '-provider', '-provider-path', '-provparam', '-propquery'
          break
        }
        break
      }
      'ec' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-engine', '-in', '-inform', '-pubin', '-passin', '-check', '-param_enc', '-conv_form', '-out', '-outform', '-noout', '-text', '-param_out', '-pubout', '-no_public', '-passout', '-provider', '-provider-path', '-provparam', '-propquery'
          break
        }
        break
      }
      'ecparam' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-list_curves', '-engine', '-genkey', '-in', '-inform', '-out', '-outform', '-text', '-noout', '-param_enc', '-check', '-check_named', '-no_seed', '-name', '-conv_form', '-rand', '-writerand', '-provider', '-provider-path', '-provparam', '-propquery'
          break
        }
        break
      }
      'enc' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-list', '-ciphers', '-e', '-d', '-p', '-P', '-engine', '-in', '-k', '-kfile', '-out', '-pass', '-v', '-a', '-base64', '-A', '-nopad', '-salt', '-nosalt', '-debug', '-bufsize', '-K', '-S', '-iv', '-md', '-iter', '-pbkdf2', '-none', '-saltlen', '-skeyopt', '-skeymgmt', '-rand', '-writerand', '-provider', '-provider-path', '-provparam', '-propquery'
          break
        }
        break
      }
      'engine' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-t', '-pre', '-post', '-v', '-vv', '-vvv', '-vvvv', '-c', '-tt'
          break
        }
        break
      }
      'errstr' {
        if ($wordToComplete.StartsWith('-')) {
          '-help'
          break
        }
        break
      }
      'fipsinstall' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-pedantic', '-verify', '-module', '-provider_name', '-section_name', '-no_conditional_errors', '-no_security_checks', '-self_test_onload', '-self_test_oninstall', '-ems_check', '-no_short_mac', '-no_drbg_truncated_digests', '-signature_digest_check', '-hmac_key_check', '-kmac_key_check', '-hkdf_digest_check', '-tls13_kdf_digest_check', '-tls1_prf_digest_check', '-sshkdf_digest_check', '-sskdf_digest_check', '-x963kdf_digest_check', '-dsa_sign_disabled', '-tdes_encrypt_disabled', '-rsa_pkcs15_padding_disabled', '-rsa_pss_saltlen_check', '-rsa_sign_x931_disabled', '-hkdf_key_check', '-kbkdf_key_check', '-tls13_kdf_key_check', '-tls1_prf_key_check', '-sshkdf_key_check', '-sskdf_key_check', '-x963kdf_key_check', '-x942kdf_key_check', '-no_pbkdf2_lower_bound_check', '-ecdh_cofactor_check', '-in', '-out', '-mac_name', '-macopt', '-noout', '-corrupt_desc', '-corrupt_type', '-config', '-quiet'
          break
        }
        break
      }
      'gendsa' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-engine', '-out', '-passout', '-rand', '-writerand', '-provider', '-provider', '-provparam', '-propquery', '-verbose', '-quiet'
          break
        }
        break
      }
      'genpkey' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-engine', '-paramfile', '-algorithm', '-verbose', '-quiet', '-pkeyopt', '-config', '-out', '-outpubkey', '-outform', '-pass', '-genparam', '-text', '-provider', '-provider-path', '-provparam', '-propquery', '-rand', '-writerand'
          break
        }
        break
      }
      'genrsa' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-engine', '-3', '-F4', '-f4', '-out', '-passout', '-primes', '-verbose', '-quiet', '-traditional', '-rand', '-writerand', '-provider', '-provider-path', '-provparam', '-propquery'
          break
        }
        break
      }
      'help' {
        if ($wordToComplete.StartsWith('-')) {
          '-help'
          break
        }
        'asn1parse', 'ca', 'ciphers', 'cmp', 'cms', 'crl', 'crl2pkcs7', 'dgst', 'dhparam', 'dsa', 'dsaparam', 'ec', 'ecparam', 'enc', 'engine', 'errstr', 'fipsinstall', 'gendsa', 'genpkey', 'genrsa', 'help', 'info', 'kdf', 'list', 'mac', 'nseq', 'ocsp', 'passwd', 'pkcs12', 'pkcs7', 'pkcs8', 'pkey', 'pkeyparam', 'pkeyutl', 'prime', 'rand', 'rehash', 'req', 'rsa', 'rsautl', 's_client', 's_server', 's_time', 'sess_id', 'skeyutl', 'smime', 'speed', 'spkac', 'srp', 'storeutl', 'ts', 'verify', 'version', 'x509', 'blake2b512', 'blake2s256', 'md4', 'md5', 'mdc2', 'rmd160', 'sha1', 'sha224', 'sha256', 'sha3-224', 'sha3-256', 'sha3-384', 'sha3-512', 'sha384', 'sha512', 'sha512-224', 'sha512-256', 'shake128', 'shake256', 'sm3', 'aes-128-cbc', 'aes-128-ecb', 'aes-192-cbc', 'aes-192-ecb', 'aes-256-cbc', 'aes-256-ecb', 'aria-128-cbc', 'aria-128-cfb', 'aria-128-cfb1', 'aria-128-cfb8', 'aria-128-ctr', 'aria-128-ecb', 'aria-128-ofb', 'aria-192-cbc', 'aria-192-cfb', 'aria-192-cfb1', 'aria-192-cfb8', 'aria-192-ctr', 'aria-192-ecb', 'aria-192-ofb', 'aria-256-cbc', 'aria-256-cfb', 'aria-256-cfb1', 'aria-256-cfb8', 'aria-256-ctr', 'aria-256-ecb', 'aria-256-ofb', 'base64', 'bf', 'bf-cbc', 'bf-cfb', 'bf-ecb', 'bf-ofb', 'camellia-128-cbc', 'camellia-128-ecb', 'camellia-192-cbc', 'camellia-192-ecb', 'camellia-256-cbc', 'camellia-256-ecb', 'cast', 'cast-cbc', 'cast5-cbc', 'cast5-cfb', 'cast5-ecb', 'cast5-ofb', 'des', 'des-cbc', 'des-cfb', 'des-ecb', 'des-ede', 'des-ede-cbc', 'des-ede-cfb', 'des-ede-ofb', 'des-ede3', 'des-ede3-cbc', 'des-ede3-cfb', 'des-ede3-ofb', 'des-ofb', 'des3', 'desx', 'idea', 'idea-cbc', 'idea-cfb', 'idea-ecb', 'idea-ofb', 'rc2', 'rc2-40-cbc', 'rc2-64-cbc', 'rc2-cbc', 'rc2-cfb', 'rc2-ecb', 'rc2-ofb', 'rc4', 'rc4-40', 'seed', 'seed-cbc', 'seed-cfb', 'seed-ecb', 'seed-ofb', 'sm4-cbc', 'sm4-cfb', 'sm4-ctr', 'sm4-ecb', 'sm4-ofb'
        break
      }
      'info' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-configdir', '-enginesdir', '-modulesdir', '-dsoext', '-dirnamesep', '-listsep', '-seeds', '-cpusettings', '-windowscontext'
          break
        }
        break
      }
      'kdf' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-kdfopt', '-cipher', '-digest', '-mac', '-keylen', '-out', '-binary', '-provider', '-provider-path', '-provparam', '-propquery'
          break
        }
        break
      }
      'list' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-1', '-verbose', '-select', '-commands', '-standard-commands', '-all-algorithms', '-digest-commands', '-digest-algorithms', '-kdf-algorithms', '-random-instances', '-random-generators', '-mac-algorithms', '-cipher-commands', '-cipher-algorithms', '-encoders', '-decoders', '-key-managers', '-skey-managers', '-key-exchange-algorithms', '-kem-algorithms', '-signature-algorithms', '-tls-signature-algorithms', '-asymcipher-algorithms', '-public-key-algorithms', '-public-key-methods', '-store-loaders', '-tls-groups', '-all-tls-groups', '-tls1_2', '-tls1_3', '-providers', '-engines', '-disabled', '-options', '-objects', '-provider-path', '-provider', '-provparam', '-propquery'
          break
        }
        break
      }
      'mac' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-macopt', '-cipher', '-digest', '-in', '-out', '-binary', '-provider', '-provider-path', '-provparam', '-propquery'
          break
        }
        break
      }
      'nseq' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-in', '-toseq', '-out', '-provider', '-provider-path', '-provparam', '-propquery'
          break
        }
        break
      }
      'ocsp' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-ignore_err', '-CAfile', '-CApath', '-CAstore', '-no-CAfile', '-no-CApath', '-no-CAstore', '-timeout', '-resp_no_certs', '-multi', '-no_certs', '-badsig', '-CA', '-nmin', '-nrequest', '-reqin', '-signer', '-sign_other', '-index', '-ndays', '-rsigner', '-rkey', '-passin', '-rother', '-rmd', '-rsigopt', '-header', '-rcid', '-url', '-host', '-port', '-path', '-proxy', '-no_proxy', '-out', '-noverify', '-nonce', '-no_nonce', '-no_signature_verify', '-resp_key_id', '-no_cert_verify', '-text', '-req_text', '-resp_text', '-no_chain', '-no_cert_checks', '-no_explicit', '-trust_other', '-no_intern', '-respin', '-VAfile', '-verify_other', '-cert', '-serial', '-validity_period', '-signkey', '-reqout', '-respout', '-issuer', '-status_age', '-policy', '-purpose', '-verify_name', '-verify_depth', '-auth_level', '-attime', '-verify_hostname', '-verify_email', '-verify_ip', '-ignore_critical', '-issuer_checks', '-crl_check', '-crl_check_all', '-policy_check', '-explicit_policy', '-inhibit_any', '-inhibit_map', '-x509_strict', '-extended_crl', '-use_deltas', '-policy_print', '-check_ss_sig', '-trusted_first', '-suiteB_128_only', '-suiteB_128', '-suiteB_192', '-partial_chain', '-no_alt_chains', '-no_check_time', '-allow_proxy_certs', '-provider-path', '-provider', '-provparam', '-propquery'
          break
        }
        break
      }
      'passwd' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-in', '-noverify', '-stdin', '-quiet', '-table', '-reverse', '-salt', '-6', '-5', '-apr1', '-1', '-aixmd5', '-rand', '-writerand', '-provider', '-provider-path', '-provparam', '-propquery'
          break
        }
        break
      }
      'pkcs12' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-in', '-out', '-passin', '-passout', '-password', '-twopass', '-nokeys', '-nocerts', '-noout', '-legacy', '-engine', '-provider', '-provider-path', '-provparam', '-propquery', '-rand', '-writerand', '-info', '-nomacver', '-clcerts', '-cacerts', '-noenc', '-nodes', '-export', '-inkey', '-certfile', '-passcerts', '-chain', '-untrusted', '-CAfile', '-CApath', '-CAstore', '-no', '-no', '-no', '-name', '-caname', '-CSP', '-LMK', '-keyex', '-keysig', '-keypbe', '-certpbe', '-descert', '-macalg', '-pbmac1_pbkdf2', '-pbmac1_pbkdf2_md', '-iter', '-noiter', '-nomaciter', '-maciter', '-macsaltlen', '-nomac', '-jdktrust', ''
          break
        }
        break
      }
      'pkcs7' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-engine', '-in', '-inform', '-outform', '-out', '-noout', '-text', '-print', '-print_certs', '-quiet', '-provider', '-provider-path', '-provparam', '-propquery'
          break
        }
        break
      }
      'pkcs8' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-engine', '-v1', '-v2', '-v2prf', '-in', '-inform', '-passin', '-nocrypt', '-out', '-outform', '-topk8', '-passout', '-traditional', '-iter', '-noiter', '-saltlen', '-scrypt', '-scrypt_N', '-scrypt_r', '-scrypt_p', '-rand', '-writerand', '-provider', '-provider-path', '-provparam', '-propquery'
          break
        }
        break
      }
      'pkey' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-engine', '-provider', '-provider-path', '-provparam', '-propquery', '-check', '-pubcheck', '-in', '-inform', '-passin', '-pubin', '-out', '-outform', '-passout', '-traditional', '-pubout', '-noout', '-text', '-text_pub', '-ec_conv_form', '-ec_param_enc'
          break
        }
        break
      }
      'pkeyparam' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-engine', '-check', '-in', '-out', '-text', '-noout', '-provider', '-provider-path', '-provparam', '-propquery'
          break
        }
        break
      }
      'pkeyutl' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-engine', '-engine_impl', '-sign', '-verify', '-encrypt', '-decrypt', '-derive', '-decap', '-encap', '-config', '-in', '-inkey', '-pubin', '-passin', '-peerkey', '-peerform', '-certin', '-rev', '-sigfile', '-keyform', '-out', '-secret', '-asn1parse', '-hexdump', '-verifyrecover', '-rawin', '-digest', '-pkeyopt', '-pkeyopt_passin', '-kdf', '-kdflen', '-kemop', '-rand', '-writerand', '-provider', '-provider-path', '-provparam', '-propquery'
          break
        }
        break
      }
      'prime' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-bits', '-checks', '-hex', '-generate', '-safe', '-provider', '-provider-path', '-provparam', '-propquery'
          break
        }
        break
      }
      'rand' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-engine', '-out', '-base64', '-hex', '-rand', '-writerand', '-provider', '-provider-path', '-provparam', '-propquery'
          break
        }
        break
      }
      'rehash' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-h', '-compat', '-old', '-n', '-v', '-provider', '-provider-path', '-provparam', '-propquery'
          break
        }
        break
      }
      'req' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-cipher', '-engine', '-keygen_engine', '-in', '-inform', '-verify', '-new', '-config', '-section', '-utf8', '-nameopt', '-reqopt', '-text', '-x509', '-x509v1', '-CA', '-CAkey', '-subj', '-subject', '-multivalue-rdn', '-not_before', '-not_after', '-days', '-set_serial', '-copy_extensions', '-extensions', '-reqexts', '-addext', '-precert', '-key', '-keyform', '-pubkey', '-keyout', '-passin', '-passout', '-newkey', '-pkeyopt', '-sigopt', '-vfyopt', '-out', '-outform', '-batch', '-verbose', '-quiet', '-noenc', '-nodes', '-noout', '-newhdr', '-modulus', '-rand', '-writerand', '-provider', '-provider-path', '-provparam', '-propquery'
          break
        }
        break
      }
      'rsa' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-check', '-engine', '-in', '-inform', '-pubin', '-RSAPublicKey_in', '-passin', '-out', '-outform', '-pubout', '-RSAPublicKey_out', '-passout', '-noout', '-text', '-modulus', '-traditional', '-pvk-strong', '-pvk-weak', '-pvk-none', '-provider-path', '-provider', '-provparam', '-propquery'
          break
        }
        break
      }
      'rsautl' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-sign', '-verify', '-encrypt', '-decrypt', '-engine', '-in', '-inkey', '-keyform', '-pubin', '-certin', '-rev', '-passin', '-out', '-raw', '-pkcs', '-x931', '-oaep', '-asn1parse', '-hexdump', '-rand', '-writerand', '-provider', '-provider-path', '-provparam', '-propquery'
          break
        }
        break
      }
      's_client' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-engine', '-ssl_client_engine', '-ssl_config', '-ct', '-noct', '-ctlogfile', '-host', '-port', '-connect', '-bind', '-proxy', '-proxy_user', '-proxy_pass', '-unix', '-4', '-6', '-maxfraglen', '-max_send_frag', '-split_send_frag', '-max_pipelines', '-read_buf', '-fallback_scsv', '-cert', '-certform', '-cert_chain', '-build_chain', '-key', '-keyform', '-pass', '-verify', '-nameopt', '-CApath', '-CAfile', '-CAstore', '-no-CAfile', '-no-CApath', '-no-CAstore', '-requestCAfile', '-dane_tlsa_domain', '-dane_tlsa_rrdata', '-dane_ee_no_namechecks', '-psk_identity', '-psk', '-psk_session', '-name', '-reconnect', '-sess_out', '-sess_in', '-crlf', '-quiet', '-ign_eof', '-no_ign_eof', '-starttls', '-xmpphost', '-brief', '-prexit', '-no-interactive', '-showcerts', '-debug', '-msg', '-msgfile', '-nbio_test', '-state', '-keymatexport', '-keymatexportlen', '-security_debug', '-security_debug_verbose', '-trace', '-keylogfile', '-nocommands', '-adv', '-servername', '-noservername', '-tlsextdebug', '-ignore_unexpected_eof', '-status', '-serverinfo', '-alpn', '-async', '-nbio', '-tls1', '-tls1_1', '-tls1_2', '-tls1_3', '-dtls', '-quic', '-timeout', '-mtu', '-dtls1', '-dtls1_2', '-nextprotoneg', '-early_data', '-enable_pha', '-enable_server_rpk', '-enable_client_rpk', '-use_srtp', '-srpuser', '-srppass', '-srp_lateuser', '-srp_moregroups', '-srp_strength', '-rand', '-writerand', '-no_ssl3', '-no_tls1', '-no_tls1_1', '-no_tls1_2', '-no_tls1_3', '-bugs', '-no_comp', '-comp', '-no_tx_cert_comp', '-no_rx_cert_comp', '-no_ticket', '-serverpref', '-legacy_renegotiation', '-client_renegotiation', '-no_renegotiation', '-legacy_server_connect', '-no_resumption_on_reneg', '-no_legacy_server_connect', '-allow_no_dhe_kex', '-prefer_no_dhe_kex', '-prioritize_chacha', '-strict', '-sigalgs', '-client_sigalgs', '-groups', '-curves', '-named_curve', '-cipher', '-ciphersuites', '-min_protocol', '-max_protocol', '-record_padding', '-debug_broken_protocol', '-no_middlebox', '-no_etm', '-no_ems', '-policy', '-purpose', '-verify_name', '-verify_depth', '-auth_level', '-attime', '-verify_hostname', '-verify_email', '-verify_ip', '-ignore_critical', '-issuer_checks', '-crl_check', '-crl_check_all', '-policy_check', '-explicit_policy', '-inhibit_any', '-inhibit_map', '-x509_strict', '-extended_crl', '-use_deltas', '-policy_print', '-check_ss_sig', '-trusted_first', '-suiteB_128_only', '-suiteB_128', '-suiteB_192', '-partial_chain', '-no_alt_chains', '-no_check_time', '-allow_proxy_certs', '-CRL', '-crl_download', '-CRLform', '-verify_return_error', '-verify_quiet', '-chainCAfile', '-chainCApath', '-chainCAstore', '-verifyCAfile', '-verifyCApath', '-verifyCAstore', '-xkey', '-xcert', '-xchain', '-xchain_build', '-xcertform', '-xkeyform', '-provider', '-provider-path', '-provparam', '-propquery'
          break
        }
        break
      }
      's_server' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-ssl_config', '-trace', '-engine', '-port', '-accept', '-unix', '-unlink', '-4', '-6', '-context', '-CAfile', '-CApath', '-CAstore', '-no-CAfile', '-no-CApath', '-no-CAstore', '-nocert', '-verify', '-Verify', '-nameopt', '-cert', '-cert2', '-certform', '-cert_chain', '-build_chain', '-serverinfo', '-key', '-key2', '-keyform', '-pass', '-dcert', '-dcertform', '-dcert_chain', '-dkey', '-dkeyform', '-dpass', '-dhparam', '-servername', '-servername_fatal', '-nbio_test', '-crlf', '-quiet', '-no_resume_ephemeral', '-www', '-WWW', '-ignore_unexpected_eof', '-tlsextdebug', '-HTTP', '-id_prefix', '-keymatexport', '-keymatexportlen', '-CRL', '-CRLform', '-crl_download', '-chainCAfile', '-chainCApath', '-chainCAstore', '-verifyCAfile', '-verifyCApath', '-verifyCAstore', '-no_cache', '-ext_cache', '-verify_return_error', '-verify_quiet', '-ign_eof', '-no_ign_eof', '-status', '-status_verbose', '-status_timeout', '-status_url', '-proxy', '-no_proxy', '-status_file', '-security_debug', '-security_debug_verbose', '-brief', '-rev', '-debug', '-msg', '-msgfile', '-state', '-async', '-max_pipelines', '-naccept', '-keylogfile', '-nbio', '-timeout', '-mtu', '-read_buf', '-split_send_frag', '-max_send_frag', '-psk_identity', '-psk_hint', '-psk', '-psk_session', '-srpvfile', '-srpuserseed', '-max_early_data', '-recv_max_early_data', '-early_data', '-num_tickets', '-anti_replay', '-no_anti_replay', '-http_server_binmode', '-no_ca_names', '-stateless', '-tls1', '-tls1_1', '-tls1_2', '-tls1_3', '-dtls', '-listen', '-dtls1', '-dtls1_2', '-use_srtp', '-no_dhe', '-nextprotoneg', '-alpn', '-enable_server_rpk', '-enable_client_rpk', '-rand', '-writerand', '-no_ssl3', '-no_tls1', '-no_tls1_1', '-no_tls1_2', '-no_tls1_3', '-bugs', '-no_comp', '-comp', '-no_tx_cert_comp', '-no_rx_cert_comp', '-no_ticket', '-serverpref', '-legacy_renegotiation', '-client_renegotiation', '-no_renegotiation', '-legacy_server_connect', '-no_resumption_on_reneg', '-no_legacy_server_connect', '-allow_no_dhe_kex', '-prefer_no_dhe_kex', '-prioritize_chacha', '-strict', '-sigalgs', '-client_sigalgs', '-groups', '-curves', '-named_curve', '-cipher', '-ciphersuites', '-min_protocol', '-max_protocol', '-record_padding', '-debug_broken_protocol', '-no_middlebox', '-no_etm', '-no_ems', '-policy', '-purpose', '-verify_name', '-verify_depth', '-auth_level', '-attime', '-verify_hostname', '-verify_email', '-verify_ip', '-ignore_critical', '-issuer_checks', '-crl_check', '-crl_check_all', '-policy_check', '-explicit_policy', '-inhibit_any', '-inhibit_map', '-x509_strict', '-extended_crl', '-use_deltas', '-policy_print', '-check_ss_sig', '-trusted_first', '-suiteB_128_only', '-suiteB_128', '-suiteB_192', '-partial_chain', '-no_alt_chains', '-no_check_time', '-allow_proxy_certs', '-xkey', '-xcert', '-xchain', '-xchain_build', '-xcertform', '-xkeyform', '-provider', '-provider-path', '-provparam', '-propquery'
          break
        }
        break
      }
      's_time' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-connect', '-new', '-reuse', '-bugs', '-cipher', '-ciphersuites', '-tls1', '-tls1_1', '-tls1_2', '-tls1_3', '-verify', '-time', '-www', '-nameopt', '-cert', '-key', '-cafile', '-CAfile', '-CApath', '-CAstore', '-no-CAfile', '-no-CApath', '-no-CAstore', '-provider-path', '-provider', '-provparam', '-propquery'
          break
        }
        break
      }
      'sess_id' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-context', '-in', '-inform', '-out', '-outform', '-text', '-cert', '-noout'
          break
        }
        break
      }
      'skeyutl' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-skeyopt', '-skeymgmt', '-genkey', '-cipher', '-provider', '-provider-path', '-provparam', '-propquery'
          break
        }
        break
      }
      'smime' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-in', '-inform', '-out', '-outform', '-inkey', '-keyform', '-engine', '-stream', '-indef', '-noindef', '-config', '-encrypt', '-decrypt', '-sign', '-resign', '-verify', '-pk7out', '-passin', '-md', '-nointern', '-nodetach', '-noattr', '-binary', '-signer', '-content', '-nocerts', '-nosigs', '-noverify', '-certfile', '-recip', '-to', '-from', '-subject', '-text', '-nosmimecap', '-CApath', '-CAfile', '-CAstore', '-no-CAfile', '-no-CApath', '-no-CAstore', '-nochain', '-crlfeol', '-rand', '-writerand', '-policy', '-purpose', '-verify_name', '-verify_depth', '-auth_level', '-attime', '-verify_hostname', '-verify_email', '-verify_ip', '-ignore_critical', '-issuer_checks', '-crl_check', '-crl_check_all', '-policy_check', '-explicit_policy', '-inhibit_any', '-inhibit_map', '-x509_strict', '-extended_crl', '-use_deltas', '-policy_print', '-check_ss_sig', '-trusted_first', '-suiteB_128_only', '-suiteB_128', '-suiteB_192', '-partial_chain', '-no_alt_chains', '-no_check_time', '-allow_proxy_certs', '-provider', '-provider-path', '-provparam', '-propquery'
          break
        }
        break
      }
      'speed' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-mb', '-mr', '-multi', '-async_jobs', '-engine', '-primes', '-mlock', '-testmode', '-config', '-evp', '-hmac', '-cmac', '-decrypt', '-aead', '-kem-algorithms', '-signature-algorithms', '-elapsed', '-seconds', '-bytes', '-misalign', '-rand', '-writerand', '-provider', '-provider-path', '-provparam', '-propquery'
          break
        }
        break
      }
      'spkac' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-spksect', '-engine', '-in', '-key', '-keyform', '-passin', '-challenge', '-spkac', '-digest', '-out', '-noout', '-pubkey', '-verify', '-provider', '-provider-path', '-provparam', '-propquery'
          break
        }
        break
      }
      'srp' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-verbose', '-config', '-name', '-engine', '-add', '-modify', '-delete', '-list', '-srpvfile', '-gn', '-userinfo', '-passin', '-passout', '-rand', '-writerand', '-provider', '-provider-path', '-provparam', '-propquery'
          break
        }
        break
      }
      'storeutl' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-engine', '-certs', '-keys', '-crls', '-subject', '-issuer', '-serial', '-fingerprint', '-alias', '-r', '-passin', '-out', '-text', '-noout', '-provider', '-provider-path', '-provparam', '-propquery'
          break
        }
        break
      }
      'ts' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-config', '-section', '-engine', '-inkey', '-signer', '-chain', '-CAfile', '-CApath', '-CAstore', '-untrusted', '-token_in', '-token_out', '-passin', '-query', '-data', '-digest', '-queryfile', '-cert', '-in', '-verify', '-reply', '-tspolicy', '-no_nonce', '-out', '-text', '-rand', '-writerand', '-policy', '-purpose', '-verify_name', '-verify_depth', '-auth_level', '-attime', '-verify_hostname', '-verify_email', '-verify_ip', '-ignore_critical', '-issuer_checks', '-crl_check', '-crl_check_all', '-policy_check', '-explicit_policy', '-inhibit_any', '-inhibit_map', '-x509_strict', '-extended_crl', '-use_deltas', '-policy_print', '-check_ss_sig', '-trusted_first', '-suiteB_128_only', '-suiteB_128', '-suiteB_192', '-partial_chain', '-no_alt_chains', '-no_check_time', '-allow_proxy_certs', '-provider', '-provider-path', '-provparam', '-propquery'
          break
        }
        break
      }
      'verify' {
        switch ($prev) {
          '-purpose' { 'sslclient', 'sslserver', 'nssslserver', 'smimesign', 'smimeencrypt', 'crlsign', 'any', 'ocsphelper', 'timestampsign', 'codesign'; break }
          { $_ -ceq 'policy' -or $_ -ceq '-verify_name' } { 'code_sign', 'default', 'pkcs7', 'smime_sign', 'ssl_client', 'ssl_server'; break }
          default {
            if ($wordToComplete.StartsWith('-')) {
              '-help', '-engine', '-verbose', '-nameopt', '-trusted', '-CAfile', '-CApath', '-CAstore', '-no-CAfile', '-no-CApath', '-no-CAstore', '-untrusted', '-CRLfile', '-crl_download', '-show_chain', '-policy', '-purpose', '-verify_name', '-verify_depth', '-auth_level', '-attime', '-verify_hostname', '-verify_email', '-verify_ip', '-ignore_critical', '-issuer_checks', '-crl_check', '-crl_check_all', '-policy_check', '-explicit_policy', '-inhibit_any', '-inhibit_map', '-x509_strict', '-extended_crl', '-use_deltas', '-policy_print', '-check_ss_sig', '-trusted_first', '-suiteB_128_only', '-suiteB_128', '-suiteB_192', '-partial_chain', '-no_alt_chains', '-no_check_time', '-allow_proxy_certs', '-vfyopt', '-provider', '-provider-path', '-provparam', '-propquery'
              break
            }
            break
          }
        }
        break
      }
      'version' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-a', '-b', '-d', '-e', '-m', '-f', '-o', '-p', '-r', '-v', '-c'
          break
        }
        break
      }
      'x509' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-in', '-passin', '-new', '-x509toreq', '-req', '-copy_extensions', '-inform', '-vfyopt', '-key', '-signkey', '-keyform', '-out', '-outform', '-nocert', '-noout', '-text', '-dateopt', '-certopt', '-fingerprint', '-alias', '-serial', '-startdate', '-enddate', '-dates', '-subject', '-issuer', '-nameopt', '-email', '-hash', '-subject_hash', '-subject_hash_old', '-issuer_hash', '-issuer_hash_old', '-ext', '-ocspid', '-ocsp_uri', '-purpose', '-pubkey', '-modulus', '-checkend', '-checkhost', '-checkemail', '-checkip', '-set_serial', '-next_serial', '-not_before', '-not_after', '-days', '-preserve_dates', '-set_issuer', '-set_subject', '-subj', '-force_pubkey', '-clrext', '-extfile', '-extensions', '-sigopt', '-badsig', '-CA', '-CAform', '-CAkey', '-CAkeyform', '-CAserial', '-CAcreateserial', '-trustout', '-setalias', '-clrtrust', '-addtrust', '-clrreject', '-addreject', '-rand', '-writerand', '-engine', '-provider', '-provider-path', '-provparam', '-propquery'
          break
        }
        break
      }
      'blake2b512' {
        if ($wordToComplete.StartsWith('-')) {
          '-help', '-list', '-engine', '-engine_impl', '-passin', '-c', '-r', '-out', '-keyform', '-hex', '-binary', '-xoflen', '-d', '-debug', '-sign', '-verify', '-prverify', '-sigopt', '-signature', '-hmac', '-mac', '-macopt', '-fips', '-rand', '-writerand', '-provider', '-provider-path', '-provparam', '-propquery'
          break
        }
        break
      }
      '' {
        if ($wordToComplete.StartsWith('-')) {

          break
        }
        break
      }
      '' {
        if ($wordToComplete.StartsWith('-')) {
          break
        }
        break
      }
      '' {
        if ($wordToComplete.StartsWith('-')) {
          break
        }
        break
      }
      '' {
        if ($wordToComplete.StartsWith('-')) {
          break
        }
        break
      }
      '' {
        if ($wordToComplete.StartsWith('-')) {
          break
        }
        break
      }
      '' {
        if ($wordToComplete.StartsWith('-')) {
          break
        }
        break
      }
      '' {
        if ($wordToComplete.StartsWith('-')) {
          break
        }
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
