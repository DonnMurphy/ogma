package com.ogma;

import io.reactivex.Flowable;
import io.reactivex.functions.Function;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import org.web3j.abi.EventEncoder;
import org.web3j.abi.TypeReference;
import org.web3j.abi.datatypes.Address;
import org.web3j.abi.datatypes.Event;
import org.web3j.abi.datatypes.Type;
import org.web3j.abi.datatypes.Utf8String;
import org.web3j.abi.datatypes.generated.Uint256;
import org.web3j.crypto.Credentials;
import org.web3j.protocol.Web3j;
import org.web3j.protocol.core.DefaultBlockParameter;
import org.web3j.protocol.core.RemoteCall;
import org.web3j.protocol.core.RemoteFunctionCall;
import org.web3j.protocol.core.methods.request.EthFilter;
import org.web3j.protocol.core.methods.response.BaseEventResponse;
import org.web3j.protocol.core.methods.response.Log;
import org.web3j.protocol.core.methods.response.TransactionReceipt;
import org.web3j.tx.Contract;
import org.web3j.tx.TransactionManager;
import org.web3j.tx.gas.ContractGasProvider;

/**
 * <p>Auto generated code.
 * <p><strong>Do not modify!</strong>
 * <p>Please use the <a href="https://docs.web3j.io/command_line.html">web3j command line tools</a>,
 * or the org.web3j.codegen.SolidityFunctionWrapperGenerator in the 
 * <a href="https://github.com/web3j/web3j/tree/master/codegen">codegen module</a> to update.
 *
 * <p>Generated with web3j version 4.5.12.
 */
@SuppressWarnings("rawtypes")
public class SheepHelper extends Contract {
    public static final String BINARY = "608060408190526010600155662386f26fc10000600255600a6003556000600581905580546001600160a01b03191633178082556001600160a01b0316917f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0908290a3610d84806100716000396000f3fe608060405234801561001057600080fd5b506004361061009e5760003560e01c80638cc8b591116100665780638cc8b591146102f35780638da5cb5b146103105780638f32d59b14610334578063adb0e41d14610350578063f2fde38b1461036d5761009e565b80633e90ad18146100a35780634f592bfc14610119578063541ce3a714610133578063715018a61461024357806380a665981461024d575b600080fd5b6100c9600480360360208110156100b957600080fd5b50356001600160a01b0316610393565b60408051602080825283518183015283519192839290830191858101910280838360005b838110156101055781810151838201526020016100ed565b505050509050019250505060405180910390f35b610121610448565b60408051918252519081900360200190f35b6101506004803603602081101561014957600080fd5b503561044f565b604051808060200186815260200185815260200184815260200180602001838103835288818151815260200191508051906020019080838360005b838110156101a357818101518382015260200161018b565b50505050905090810190601f1680156101d05780820380516001836020036101000a031916815260200191505b50838103825284518152845160209182019186019080838360005b838110156102035781810151838201526020016101eb565b50505050905090810190601f1680156102305780820380516001836020036101000a031916815260200191505b5097505050505050505060405180910390f35b61024b6105af565b005b61024b6004803603602081101561026357600080fd5b81019060208101813564010000000081111561027e57600080fd5b82018360208201111561029057600080fd5b803590602001918460018302840111640100000000831117156102b257600080fd5b91908080601f01602080910402602001604051908101604052809392919081815260200183838082843760009201919091525092955061060a945050505050565b6101506004803603602081101561030957600080fd5b503561064f565b610318610804565b604080516001600160a01b039092168252519081900360200190f35b61033c610813565b604080519115158252519081900360200190f35b6103186004803603602081101561036657600080fd5b5035610824565b61024b6004803603602081101561038357600080fd5b50356001600160a01b031661083f565b60608060076000846001600160a01b03166001600160a01b03168152602001908152602001600020546040519080825280602002602001820160405280156103e5578160200160208202803883390190505b5090506000805b60045481101561043f576000818152600660205260409020546001600160a01b0386811691161415610437578083838151811061042557fe5b60209081029190910101526001909101905b6001016103ec565b50909392505050565b6005545b90565b6004818154811061045c57fe5b60009182526020918290206005919091020180546040805160026001841615610100026000190190931692909204601f8101859004850283018501909152808252919350918391908301828280156104f55780601f106104ca576101008083540402835291602001916104f5565b820191906000526020600020905b8154815290600101906020018083116104d857829003601f168201915b505050505090806001015490806002015490806003015490806004018054600181600116156101000203166002900480601f0160208091040260200160405190810160405280929190818152602001828054600181600116156101000203166002900480156105a55780601f1061057a576101008083540402835291602001916105a5565b820191906000526020600020905b81548152906001019060200180831161058857829003601f168201915b5050505050905085565b6105b7610813565b6105c057600080fd5b600080546040516001600160a01b03909116907f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0908390a3600080546001600160a01b0319169055565b60006106158261085c565b905060006106248360016108e5565b905060006106338460006108e5565b9050606483068303925061064984848484610971565b50505050565b606060008060006060610660610c2a565b6004878154811061066d57fe5b600091825260209182902060408051600593909302909101805460026001821615610100026000190190911604601f8101859004909402830160c090810190925260a08301848152929390928492909184918401828280156107105780601f106106e557610100808354040283529160200191610710565b820191906000526020600020905b8154815290600101906020018083116106f357829003601f168201915b50505050508152602001600182015481526020016002820154815260200160038201548152602001600482018054600181600116156101000203166002900480601f0160208091040260200160405190810160405280929190818152602001828054600181600116156101000203166002900480156107d05780601f106107a5576101008083540402835291602001916107d0565b820191906000526020600020905b8154815290600101906020018083116107b357829003601f168201915b5050509190925250508151604083015160608401516020850151608090950151929c919b5099509297509550909350505050565b6000546001600160a01b031690565b6000546001600160a01b0316331490565b6006602052600090815260409020546001600160a01b031681565b610847610813565b61085057600080fd5b61085981610bbc565b50565b600080826040516020018082805190602001908083835b602083106108925780518252601f199092019160209182019101610873565b6001836020036101000a0380198251168184511680821785525050505050509050019150506040516020818303038152906040528051906020012060001c905060025481816108dd57fe5b069392505050565b600080836040516020018082805190602001908083835b6020831061091b5780518252601f1990920191602091820191016108fc565b6001836020036101000a0380198251168184511680821785525050505050509050019150506040516020818303038152906040528051906020012060001c905082600354828161096757fe5b0601949350505050565b60606040518060800160405280605d8152602001610cf2605d91396040805160a081018252878152602080820188905291810186905260608101859052608081018390526004805460018101825560009190915281518051949550919360059091027f8a35acfbc15ff81a39ae7d344fd709f28e8600b4aa8c65c6b64bfe7fe36bd19b0192610a04928492910190610c59565b506020828101516001830155604083015160028301556060830151600383015560808301518051610a3b9260048501920190610c59565b505060058054600190810190915560045460001901600081815260066020908152604080832080546001600160a01b0319163290811790915583526007825280832080549095019094558351838152938401899052606084018890526080840187905260c08482018181528b51918601919091528a519395507f4879619f7ff9493ef67b03bd003b4128af5d0d3fc86f27ec4d03017d481365159486948c948c948c948c948c949093919260a085019260e0860192918b0191908190849084905b83811015610b14578181015183820152602001610afc565b50505050905090810190601f168015610b415780820380516001836020036101000a031916815260200191505b50838103825284518152845160209182019186019080838360005b83811015610b74578181015183820152602001610b5c565b50505050905090810190601f168015610ba15780820380516001836020036101000a031916815260200191505b509850505050505050505060405180910390a1505050505050565b6001600160a01b038116610bcf57600080fd5b600080546040516001600160a01b03808516939216917f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e091a3600080546001600160a01b0319166001600160a01b0392909216919091179055565b6040518060a0016040528060608152602001600081526020016000815260200160008152602001606081525090565b828054600181600116156101000203166002900490600052602060002090601f016020900481019282601f10610c9a57805160ff1916838001178555610cc7565b82800160010185558215610cc7579182015b82811115610cc7578251825591602001919060010190610cac565b50610cd3929150610cd7565b5090565b61044c91905b80821115610cd35760008155600101610cdd56fe68747470733a2f2f696d6167652e7368757474657273746f636b2e636f6d2f696d6167652d766563746f722f637574652d66756e6e792d636172746f6f6e2d6b69636b2d73686565702d363030772d313537373238373231362e6a7067a2646970667358221220aa8b134a8629e9af15b9cf6d40179206c54d31ec3c6da1302233bf6cbda846cf64736f6c63430006010033";

    public static final String FUNC_CREATERANDOMSHEEP = "createRandomSheep";

    public static final String FUNC_GETSHEEPBYID = "getSheepById";

    public static final String FUNC_GETSHEEPTOTAL = "getSheepTotal";

    public static final String FUNC_GETSHEEPSBYOWNER = "getSheepsByOwner";

    public static final String FUNC_ISOWNER = "isOwner";

    public static final String FUNC_OWNER = "owner";

    public static final String FUNC_RENOUNCEOWNERSHIP = "renounceOwnership";

    public static final String FUNC_SHEEPTOOWNER = "sheepToOwner";

    public static final String FUNC_SHEEPS = "sheeps";

    public static final String FUNC_TRANSFEROWNERSHIP = "transferOwnership";

    public static final Event NEWSHEEP_EVENT = new Event("NewSheep", 
            Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}, new TypeReference<Utf8String>() {}, new TypeReference<Uint256>() {}, new TypeReference<Uint256>() {}, new TypeReference<Uint256>() {}, new TypeReference<Utf8String>() {}));
    ;

    public static final Event OWNERSHIPTRANSFERRED_EVENT = new Event("OwnershipTransferred", 
            Arrays.<TypeReference<?>>asList(new TypeReference<Address>(true) {}, new TypeReference<Address>(true) {}));
    ;

    @Deprecated
    protected SheepHelper(String contractAddress, Web3j web3j, Credentials credentials, BigInteger gasPrice, BigInteger gasLimit) {
        super(BINARY, contractAddress, web3j, credentials, gasPrice, gasLimit);
    }

    protected SheepHelper(String contractAddress, Web3j web3j, Credentials credentials, ContractGasProvider contractGasProvider) {
        super(BINARY, contractAddress, web3j, credentials, contractGasProvider);
    }

    @Deprecated
    protected SheepHelper(String contractAddress, Web3j web3j, TransactionManager transactionManager, BigInteger gasPrice, BigInteger gasLimit) {
        super(BINARY, contractAddress, web3j, transactionManager, gasPrice, gasLimit);
    }

    protected SheepHelper(String contractAddress, Web3j web3j, TransactionManager transactionManager, ContractGasProvider contractGasProvider) {
        super(BINARY, contractAddress, web3j, transactionManager, contractGasProvider);
    }

    public List<NewSheepEventResponse> getNewSheepEvents(TransactionReceipt transactionReceipt) {
        List<Contract.EventValuesWithLog> valueList = extractEventParametersWithLog(NEWSHEEP_EVENT, transactionReceipt);
        ArrayList<NewSheepEventResponse> responses = new ArrayList<NewSheepEventResponse>(valueList.size());
        for (Contract.EventValuesWithLog eventValues : valueList) {
            NewSheepEventResponse typedResponse = new NewSheepEventResponse();
            typedResponse.log = eventValues.getLog();
            typedResponse.sheepId = (BigInteger) eventValues.getNonIndexedValues().get(0).getValue();
            typedResponse.name = (String) eventValues.getNonIndexedValues().get(1).getValue();
            typedResponse.dna = (BigInteger) eventValues.getNonIndexedValues().get(2).getValue();
            typedResponse.hp = (BigInteger) eventValues.getNonIndexedValues().get(3).getValue();
            typedResponse.dp = (BigInteger) eventValues.getNonIndexedValues().get(4).getValue();
            typedResponse.imageAsset = (String) eventValues.getNonIndexedValues().get(5).getValue();
            responses.add(typedResponse);
        }
        return responses;
    }

    public Flowable<NewSheepEventResponse> newSheepEventFlowable(EthFilter filter) {
        return web3j.ethLogFlowable(filter).map(new Function<Log, NewSheepEventResponse>() {
            @Override
            public NewSheepEventResponse apply(Log log) {
                Contract.EventValuesWithLog eventValues = extractEventParametersWithLog(NEWSHEEP_EVENT, log);
                NewSheepEventResponse typedResponse = new NewSheepEventResponse();
                typedResponse.log = log;
                typedResponse.sheepId = (BigInteger) eventValues.getNonIndexedValues().get(0).getValue();
                typedResponse.name = (String) eventValues.getNonIndexedValues().get(1).getValue();
                typedResponse.dna = (BigInteger) eventValues.getNonIndexedValues().get(2).getValue();
                typedResponse.hp = (BigInteger) eventValues.getNonIndexedValues().get(3).getValue();
                typedResponse.dp = (BigInteger) eventValues.getNonIndexedValues().get(4).getValue();
                typedResponse.imageAsset = (String) eventValues.getNonIndexedValues().get(5).getValue();
                return typedResponse;
            }
        });
    }

    public Flowable<NewSheepEventResponse> newSheepEventFlowable(DefaultBlockParameter startBlock, DefaultBlockParameter endBlock) {
        EthFilter filter = new EthFilter(startBlock, endBlock, getContractAddress());
        filter.addSingleTopic(EventEncoder.encode(NEWSHEEP_EVENT));
        return newSheepEventFlowable(filter);
    }

    public List<OwnershipTransferredEventResponse> getOwnershipTransferredEvents(TransactionReceipt transactionReceipt) {
        List<Contract.EventValuesWithLog> valueList = extractEventParametersWithLog(OWNERSHIPTRANSFERRED_EVENT, transactionReceipt);
        ArrayList<OwnershipTransferredEventResponse> responses = new ArrayList<OwnershipTransferredEventResponse>(valueList.size());
        for (Contract.EventValuesWithLog eventValues : valueList) {
            OwnershipTransferredEventResponse typedResponse = new OwnershipTransferredEventResponse();
            typedResponse.log = eventValues.getLog();
            typedResponse.previousOwner = (String) eventValues.getIndexedValues().get(0).getValue();
            typedResponse.newOwner = (String) eventValues.getIndexedValues().get(1).getValue();
            responses.add(typedResponse);
        }
        return responses;
    }

    public Flowable<OwnershipTransferredEventResponse> ownershipTransferredEventFlowable(EthFilter filter) {
        return web3j.ethLogFlowable(filter).map(new Function<Log, OwnershipTransferredEventResponse>() {
            @Override
            public OwnershipTransferredEventResponse apply(Log log) {
                Contract.EventValuesWithLog eventValues = extractEventParametersWithLog(OWNERSHIPTRANSFERRED_EVENT, log);
                OwnershipTransferredEventResponse typedResponse = new OwnershipTransferredEventResponse();
                typedResponse.log = log;
                typedResponse.previousOwner = (String) eventValues.getIndexedValues().get(0).getValue();
                typedResponse.newOwner = (String) eventValues.getIndexedValues().get(1).getValue();
                return typedResponse;
            }
        });
    }

    public Flowable<OwnershipTransferredEventResponse> ownershipTransferredEventFlowable(DefaultBlockParameter startBlock, DefaultBlockParameter endBlock) {
        EthFilter filter = new EthFilter(startBlock, endBlock, getContractAddress());
        filter.addSingleTopic(EventEncoder.encode(OWNERSHIPTRANSFERRED_EVENT));
        return ownershipTransferredEventFlowable(filter);
    }

    public RemoteFunctionCall<TransactionReceipt> createRandomSheep(String _name) {
        final org.web3j.abi.datatypes.Function function = new org.web3j.abi.datatypes.Function(
                FUNC_CREATERANDOMSHEEP, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Utf8String(_name)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteFunctionCall<TransactionReceipt> getSheepById(BigInteger _sheepId) {
        final org.web3j.abi.datatypes.Function function = new org.web3j.abi.datatypes.Function(
                FUNC_GETSHEEPBYID, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Uint256(_sheepId)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteFunctionCall<TransactionReceipt> getSheepTotal() {
        final org.web3j.abi.datatypes.Function function = new org.web3j.abi.datatypes.Function(
                FUNC_GETSHEEPTOTAL, 
                Arrays.<Type>asList(), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteFunctionCall<TransactionReceipt> getSheepsByOwner(String _owner) {
        final org.web3j.abi.datatypes.Function function = new org.web3j.abi.datatypes.Function(
                FUNC_GETSHEEPSBYOWNER, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(160, _owner)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteFunctionCall<TransactionReceipt> isOwner() {
        final org.web3j.abi.datatypes.Function function = new org.web3j.abi.datatypes.Function(
                FUNC_ISOWNER, 
                Arrays.<Type>asList(), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteFunctionCall<TransactionReceipt> owner() {
        final org.web3j.abi.datatypes.Function function = new org.web3j.abi.datatypes.Function(
                FUNC_OWNER, 
                Arrays.<Type>asList(), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteFunctionCall<TransactionReceipt> renounceOwnership() {
        final org.web3j.abi.datatypes.Function function = new org.web3j.abi.datatypes.Function(
                FUNC_RENOUNCEOWNERSHIP, 
                Arrays.<Type>asList(), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteFunctionCall<TransactionReceipt> sheepToOwner(BigInteger param0) {
        final org.web3j.abi.datatypes.Function function = new org.web3j.abi.datatypes.Function(
                FUNC_SHEEPTOOWNER, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Uint256(param0)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteFunctionCall<TransactionReceipt> sheeps(BigInteger param0) {
        final org.web3j.abi.datatypes.Function function = new org.web3j.abi.datatypes.Function(
                FUNC_SHEEPS, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Uint256(param0)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteFunctionCall<TransactionReceipt> transferOwnership(String newOwner) {
        final org.web3j.abi.datatypes.Function function = new org.web3j.abi.datatypes.Function(
                FUNC_TRANSFEROWNERSHIP, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(160, newOwner)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    @Deprecated
    public static SheepHelper load(String contractAddress, Web3j web3j, Credentials credentials, BigInteger gasPrice, BigInteger gasLimit) {
        return new SheepHelper(contractAddress, web3j, credentials, gasPrice, gasLimit);
    }

    @Deprecated
    public static SheepHelper load(String contractAddress, Web3j web3j, TransactionManager transactionManager, BigInteger gasPrice, BigInteger gasLimit) {
        return new SheepHelper(contractAddress, web3j, transactionManager, gasPrice, gasLimit);
    }

    public static SheepHelper load(String contractAddress, Web3j web3j, Credentials credentials, ContractGasProvider contractGasProvider) {
        return new SheepHelper(contractAddress, web3j, credentials, contractGasProvider);
    }

    public static SheepHelper load(String contractAddress, Web3j web3j, TransactionManager transactionManager, ContractGasProvider contractGasProvider) {
        return new SheepHelper(contractAddress, web3j, transactionManager, contractGasProvider);
    }

    public static RemoteCall<SheepHelper> deploy(Web3j web3j, Credentials credentials, ContractGasProvider contractGasProvider) {
        return deployRemoteCall(SheepHelper.class, web3j, credentials, contractGasProvider, BINARY, "");
    }

    @Deprecated
    public static RemoteCall<SheepHelper> deploy(Web3j web3j, Credentials credentials, BigInteger gasPrice, BigInteger gasLimit) {
        return deployRemoteCall(SheepHelper.class, web3j, credentials, gasPrice, gasLimit, BINARY, "");
    }

    public static RemoteCall<SheepHelper> deploy(Web3j web3j, TransactionManager transactionManager, ContractGasProvider contractGasProvider) {
        return deployRemoteCall(SheepHelper.class, web3j, transactionManager, contractGasProvider, BINARY, "");
    }

    @Deprecated
    public static RemoteCall<SheepHelper> deploy(Web3j web3j, TransactionManager transactionManager, BigInteger gasPrice, BigInteger gasLimit) {
        return deployRemoteCall(SheepHelper.class, web3j, transactionManager, gasPrice, gasLimit, BINARY, "");
    }

    public static class NewSheepEventResponse extends BaseEventResponse {
        public BigInteger sheepId;

        public String name;

        public BigInteger dna;

        public BigInteger hp;

        public BigInteger dp;

        public String imageAsset;
    }

    public static class OwnershipTransferredEventResponse extends BaseEventResponse {
        public String previousOwner;

        public String newOwner;
    }
}
