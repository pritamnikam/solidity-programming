// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract TestMultiCall {
    function func1() external view returns (uint, uint) {
        return (1, block.timestamp);
    }

    function func2() external view returns (uint, uint) {
        return (2, block.timestamp);
    }

    function getData1() external pure returns (bytes memory) {
        // abi.encodeWithSignature("func1()")
        return abi.encodeWithSelector(this.func1.selector);
    }

    function getData2() external pure returns (bytes memory) {
        // abi.encodeWithSignature("func1()")
        return abi.encodeWithSelector(this.func2.selector);
    }
}

contract MultiCall {
    function multiCall(address[] calldata targets,
                       bytes[] calldata data)
        external
        view
        returns (bytes[] memory) {
        
        require(targets.length == data.length, "target length != data length");
        bytes[] memory results = new bytes[](data.length);
        
        for (uint i = 0; i < data.length; i++) {
            (bool success, bytes memory result) = targets[i].staticcall(data[i]);
            require(success, "call failed");
            results[i] = result;
        }

        // 0x00000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000062cb053b
        // 0x00000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000062cb053b
        return results;
    }
}