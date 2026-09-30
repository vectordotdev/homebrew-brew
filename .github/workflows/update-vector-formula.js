// Updates Formula/vector.rb to a stable Vector release.
// Called from .github/workflows/release.yml through actions/github-script.
const { createHash } = require("node:crypto");
const { readFile, writeFile } = require("node:fs/promises");

module.exports = async ({ core, version }) => {
  const stableVersion = /^(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$/;
  if (!version || stableVersion.exec(version)?.[0] !== version) {
    throw new Error("version must be a stable semantic version (X.Y.Z)");
  }

  const path = "Formula/vector.rb";
  let formula = await readFile(path, "utf8");
  const versionPattern = /^([ \t]*)version "([^"]+)"[ \t]*$/gm;
  const versions = [...formula.matchAll(versionPattern)];
  if (versions.length !== 1 || stableVersion.exec(versions[0][2])?.[0] !== versions[0][2]) {
    throw new Error("Formula must contain exactly one stable Vector version");
  }
  const current = versions[0][2];
  const currentParts = current.split(".").map(BigInt);
  const requestedParts = version.split(".").map(BigInt);
  const difference = currentParts.findIndex((part, index) => part !== requestedParts[index]);
  if (difference === -1 || currentParts[difference] > requestedParts[difference]) {
    core.info(`Formula already has Vector ${current}; skipping ${version}.`);
    return;
  }

  // Intel stays pinned to its last supported release. Only ARM64 is updated.
  const url = `https://install.datadoghq.com/vector/${version}/vector-${version}-arm64-apple-darwin.tar.gz`;
  const response = await fetch(url, { signal: AbortSignal.timeout(60_000) });
  // fetch does not reject HTTP errors; never publish a checksum of an error page.
  if (!response.ok) {
    throw new Error(`Failed to download ${url}: HTTP ${response.status}`);
  }
  const digest = createHash("sha256");
  for await (const chunk of response.body) {
    digest.update(chunk);
  }

  const replacements = [
    [versionPattern, `version "${version}"`],
    [/^([ \t]*)url "[^"]+" # arm64 url[ \t]*$/gm, `url "${url}" # arm64 url`],
    [/^([ \t]*)sha256 "[^"]+" # arm64 sha256[ \t]*$/gm, `sha256 "${digest.digest("hex")}" # arm64 sha256`],
  ];
  for (const [pattern, replacement] of replacements) {
    let count = 0;
    formula = formula.replace(pattern, (_match, indent) => {
      count += 1;
      return indent + replacement;
    });
    if (count !== 1) {
      throw new Error("Formula must contain exactly one version, ARM64 URL, and ARM64 checksum");
    }
  }
  await writeFile(path, formula);
  core.info(`Updated Vector to ${version}.`);
};
