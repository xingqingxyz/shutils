import fs from 'fs'
import JSZip from 'jszip'
import path from 'path'
import { defineConfig } from 'rolldown'
import esbuildMinify from '../../internal/esbuildMinifyPlugin'

const isProd = process.env.NODE_ENV === 'production'

export default defineConfig({
  input: Object.fromEntries(
    fs
      .globSync('src/contentScripts/*.ts')
      .map((v) => [
        'content-scripts-' + path.basename(v, '.ts'),
        path.resolve(v),
      ])
      .concat(
        fs
          .globSync('src/*.ts')
          .map((v) => [path.basename(v, '.ts'), path.resolve(v)]),
      ),
  ),
  output: {
    sourcemap: !isProd,
  },
  shimMissingExports: true,
  transform: {
    define: {
      __DEV__: !isProd + '',
    },
    dropLabels: isProd ? ['DEBUG'] : undefined,
    typescript: isProd
      ? {
          declaration: { sourcemap: true, stripInternal: true },
          optimizeConstEnums: true,
          optimizeEnums: true,
        }
      : undefined,
  },
  plugins: [
    isProd && esbuildMinify(),
    {
      name: 'generate-manifest',
      async buildEnd(err) {
        fs.cpSync('./manifest.json', 'dist/manifest.json')
        if (isProd) {
          const zip = new JSZip()
          fs.globSync('dist/*.{js,json}').forEach((f) =>
            zip.file(path.basename(f), fs.promises.readFile(f)),
          )
          fs.writeFileSync(
            'dist/extension.zip',
            await zip.generateAsync({ type: 'nodebuffer' }),
          )
        }
      },
    },
  ],
})
