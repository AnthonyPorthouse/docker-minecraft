const core = require('@actions/core')
const github = require('@actions/github')

try {
    const imageName = core.getInput('image-name');

    const newName = imageName.toLowerCase();

    console.log(`Normalized image name ${imageName} as ${newName}`);

    core.setOutput('image-name', newName);
} catch (error) {
    core.setFailed(error.message);
}
