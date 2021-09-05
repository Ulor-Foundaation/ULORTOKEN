pragma solidity ^0.8.0;

contract ownable{
    address internal owner; //internal make variables possible to be assess on external contract but its private on remix or public
    //address payable public owner;
    bool private _paused;
    
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    
    modifier onlyOwner (){
        require(msg.sender == owner,"Only owner have access to this");
        _;
    }
    
    modifier whenNotPaused(){
        require(!_paused);
        _;
    }
    
    modifier whenPaused(){
        require(_paused);
        _;
    }
    
    function pause()public onlyOwner whenNotPaused{
        _paused = true;
    }
    
    function unPause()public onlyOwner whenPaused{
        _paused = false;
    }
    
    constructor() public{
        _setOwner(msg.sender);
        _paused = false;
    }
    
    function transferOwnership(address payable newOwner) public  onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _setOwner(newOwner);
    }

    function _setOwner(address newOwner) private {
        address oldOwner = owner;
        owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}
