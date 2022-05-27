const core = require('@actions/core')
const github = require('@actions/github')

try {
    const imageName = core.getInput('image-name');
    core.setOutput('image-name', imageName.toLowerCase);
} catch (error) {
    core.setFailed(error.message);
}
