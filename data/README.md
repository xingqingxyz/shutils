# Code

```pwsh
for ($i = 0; $i -lt 3; $i++) {
  for ($j = 0; $j -lt 3; $j++) {
    "$i, $j"
  }
}
```

```sh
for ((i = 0; i < 3; i++)) {
  for ((j = 0; j < 3; j++)) {
    echo "$i, $j"
  }
}
```

```py
for i in range(3):
    for j in range(3):
        print(f'{i}, {j}')
```

```js
for (let i = 0; i < 3; i++) {
  for (let j = 0; j < 3; j++) {
    console.log(`${i}, ${j}`)
  }
}
```

```ts
for (let i: number = 0; i < 3; i++) {
  for (let j: number = 0; j < 3; j++) {
    console.log(`${i}, ${j}`)
  }
}
```
