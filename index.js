web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
abi = JSON.parse('[{"constant":false,"inputs":[{"name":"project","type":"bytes32"}],"name":"totalVotesFor","outputs":[{"name":"","type":"uint8"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"project","type":"bytes32"}],"name":"validProject","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"bytes32"}],"name":"votesReceived","outputs":[{"name":"","type":"uint8"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"x","type":"bytes32"}],"name":"bytes32ToString","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"projectList","outputs":[{"name":"","type":"bytes32"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"project","type":"bytes32"}],"name":"voteForProject","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"contractOwner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"inputs":[{"name":"projectNames","type":"bytes32[]"}],"payable":false,"type":"constructor"}]')
VotingContract = web3.eth.contract(abi);
// In your nodejs console, execute contractInstance.address to get the address at which the contract is deployed and change the line below to use your deployed address
contractInstance = VotingContract.at('0x0aad519c76f98a1d8cb598dbb7e414df9077b60c');
projects = {"Project 1": "project-1", "Project 2": "project-2", "Project 3": "project-3"}

function voteForProject(project) {
  projectName = $("#project").val();
  contractInstance.voteForProject(projectName, {from: web3.eth.accounts[0]}, function() {
    let div_id = projects[projectName];
    $("#" + div_id).html(contractInstance.totalVotesFor.call(projectName).toString());
  });
}

$(document).ready(function() {
  projectNames = Object.keys(projects);
  for (var i = 0; i < projectNames.length; i++) {
    let name = projectNames[i];
    let val = contractInstance.totalVotesFor.call(name).toString()
    $("#" + projects[name]).html(val);
  }
});
