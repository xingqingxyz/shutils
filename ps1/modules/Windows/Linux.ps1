function edit {
  if ($MyInvocation.ExpectingInput) {
    $file = New-TemporaryFile
    $input > $file
    return msedit $file $args.ForEach{ $_ }
  }
  msedit $args.ForEach{ $_ }
}
