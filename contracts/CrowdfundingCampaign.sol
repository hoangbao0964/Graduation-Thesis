pragma solidity ^0.5.11;

contract CrowdfundingCampaign
{
    // Enum
    enum ProjectStatus 
    { 
        Activated,
        Deactivated,
        Expired,
        CompletelyFunded
    }
    
    // State variables
    address payable public ProjectOwnerAddress;
    uint16 public CurrentNumberOfProjects;
    
    // Constructor
    constructor() public
    {
        ProjectOwnerAddress = msg.sender;
    }    
    // Structs
    struct Project
    {
        address payable projectOwnerAddress;
        ProjectStatus projectStatus;
        uint32 projectID;
        string projectName;
        string projectDescription;
        string projectStartDate;
        string projectEndDate;
        uint64 totalMoneyNeeded;
        uint64 totalMoneyCollected;
        uint32 totalContributors;
        mapping (uint32 => Contributor) ProjectFundingHistory;
    }
    Project[] public ListOfProjects;
    
    struct Contributor
    {
        address payable contributor;
        uint64 moneyContributed;
    }
    
    /*
        Currently using for functions:
            + CreateNewProject
    */
    modifier OwnerPermission()
    {
        require(msg.sender == ProjectOwnerAddress, "Only the project owner can use this function");
        _;
    }
    
    /*
        Currently using for functions:
            + CreateNewProject
    */
    modifier ContributorPermission()
    {
        require(msg.sender != ProjectOwnerAddress, "Only give permission for the project's contributors");
        _;
    }
    
    function CreateNewProject
    (
        string memory _projectName,
        string memory _projectDescription,
        string memory _projectStartDate,
        string memory _projectEndDate,
        uint64 _moneyNeeded
    ) public OwnerPermission
    {
        CurrentNumberOfProjects++;
        Project memory newProject = Project({
                                                projectOwnerAddress: ProjectOwnerAddress,
                                                projectStatus: ProjectStatus.Activated,
                                                projectID: CurrentNumberOfProjects,
                                                projectName: _projectName,
                                                projectDescription: _projectDescription,
                                                projectStartDate: _projectStartDate,
                                                projectEndDate: _projectEndDate,
                                                totalMoneyNeeded: _moneyNeeded,
                                                totalMoneyCollected: 0,
                                                totalContributors: 0
                                            });
        ListOfProjects.push(newProject);
    }
        
    function ContributeToAProject (uint32 _projectID, uint64 _moneyContributed) public ContributorPermission
    {
        uint projectIndex;
        uint32 contributionHistoryIndex;
        Contributor memory newContributor = Contributor({contributor: msg.sender, moneyContributed: _moneyContributed});
        
        projectIndex = _projectID - 1;
        ListOfProjects[projectIndex].totalContributors++;
        contributionHistoryIndex = ListOfProjects[projectIndex].totalContributors;
        // add new contributor to the project's history funding list
        ListOfProjects[projectIndex].ProjectFundingHistory[contributionHistoryIndex] = newContributor;
        // Update total money funded
        ListOfProjects[projectIndex].totalMoneyCollected += _moneyContributed;
        if (ListOfProjects[projectIndex].totalMoneyCollected >= ListOfProjects[projectIndex].totalMoneyNeeded)
        {
            ListOfProjects[projectIndex].projectStatus = ProjectStatus.CompletelyFunded;
        }
    }
        
    function DeactivateProject (uint32 _projectID) public OwnerPermission
    {
        uint projectIndex;
        
        projectIndex = _projectID - 1;
        ListOfProjects[projectIndex].projectStatus = ProjectStatus.Deactivated;
    }
}