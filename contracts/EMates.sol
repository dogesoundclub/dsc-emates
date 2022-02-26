pragma solidity ^0.5.6;

import "./klaytn-contracts/token/KIP17/KIP17Full.sol";
import "./klaytn-contracts/token/KIP17/KIP17Mintable.sol";
import "./klaytn-contracts/token/KIP17/KIP17Burnable.sol";
import "./klaytn-contracts/token/KIP17/KIP17Pausable.sol";
import "./klaytn-contracts/ownership/Ownable.sol";
import "./interfaces/ITransferListener.sol";

contract EMates is Ownable, KIP17Full("", ""), KIP17Mintable, KIP17Burnable, KIP17Pausable {

    event SetName(string name);
    event SetSymbol(string symbol);
    event SetBaseURI(string baseURI);
    event SetTransferListener(address transferListener);

    string public name = "DSC E-MATES | 4 DA NEXT LEVEL";
    string public symbol = "EMATES";
    string public baseURI = "https://api.dogesound.club/emates/";
    address public transferListener;

    function setName(string calldata _name) external onlyOwner {
        name = _name;
        emit SetName(_name);
    }

    function setSymbol(string calldata _symbol) external onlyOwner {
        symbol = _symbol;
        emit SetSymbol(_symbol);
    }

    function setTransferListener(address _transferListener) external onlyOwner {
        transferListener = _transferListener;
        emit SetTransferListener(_transferListener);
    }

    function setBaseURI(string calldata _baseURI) external onlyOwner {
        baseURI = _baseURI;
        emit SetBaseURI(_baseURI);
    }

    function tokenURI(uint256 tokenId) public view returns (string memory) {
        require(_exists(tokenId), "KIP17Metadata: URI query for nonexistent token");
        
        if (tokenId == 0) {
            return string(abi.encodePacked(baseURI, "0"));
        }

        string memory idstr;
        
        uint256 temp = tokenId;
        uint256 digits;
        while (temp != 0) {
            digits += 1;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (tokenId != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(tokenId % 10)));
            tokenId /= 10;
        }
        idstr = string(buffer);

        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, idstr)) : "";
    }

    function _transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) internal {
        if (transferListener != address(0)) {
            ITransferListener(transferListener).transfer(from, to, tokenId);
        }
        super._transferFrom(from, to, tokenId);
    }

    function mintBatch(
        address to,
        uint256 fromId,
        uint256 amount
    ) external onlyMinter whenNotPaused {
        for (uint256 i = 0; i < amount; i += 1) {
            _mint(to, fromId + i);
        }
    }

    function bulkTransfer(address[] calldata tos, uint256[] calldata ids) external whenNotPaused {
        uint256 length = ids.length;
        for (uint256 i = 0; i < length; i += 1) {
            transferFrom(msg.sender, tos[i], ids[i]);
        }
    }
}
