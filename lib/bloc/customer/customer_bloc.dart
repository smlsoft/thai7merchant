import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thai7merchant/model/customer.dart';
import 'package:thai7merchant/repositories/customer_repository.dart';
import 'package:thai7merchant/repositories/client.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final CustomerRepository _customerRepository;

  CustomerBloc({required CustomerRepository customerRepository})
      : _customerRepository = customerRepository,
        super(CustomerInitial()) {
    on<CustomerLoadList>(onCustomerLoad);
    on<CustomerSave>(onCustomerSave);
    on<CustomerUpdate>(onCustomerUpdate);
    on<CustomerDelete>(customerDelete);
    on<CustomerDeleteMany>(customerDeleteMany);
    on<CustomerGet>(onCustomerGet);
  }

  void onCustomerLoad(CustomerLoadList event, Emitter<CustomerState> emit) async {
    emit(CustomerInProgress());

    try {
      final results = await _customerRepository.getCustomerList(
          offset: event.offset, limit: event.limit, search: event.search);

      if (results.success) {
        List<CustomerModel> customers = (results.data as List)
            .map((customer) => CustomerModel.fromJson(customer))
            .toList();
        emit(CustomerLoadSuccess(customers: customers));
      } else {
        emit(const CustomerLoadFailed(message: 'Customer Group Not Found'));
      }
    } catch (e) {
      emit(CustomerLoadFailed(message: e.toString()));
    }
  }

  void customerDelete(CustomerDelete event, Emitter<CustomerState> emit) async {
    emit(CustomerDeleteInProgress());
    try {
      await _customerRepository.deleteCustomer(event.guid);

      emit(CustomerDeleteSuccess());
    } catch (e) {
      // emit(CustomerDeleteFailure(message: e.toString()));
    }
  }

  void customerDeleteMany(CustomerDeleteMany event, Emitter<CustomerState> emit) async {
    emit(CustomerDeleteManyInProgress());
    try {
      await _customerRepository.deleteCustomerMany(event.guid);

      emit(CustomerDeleteManySuccess());
    } catch (e) {
      // emit(CustomerDeleteFailure(message: e.toString()));
    }
  }

  void onCustomerSave(CustomerSave event, Emitter<CustomerState> emit) async {
    emit(CustomerSaveInProgress());
    try {
      await _customerRepository.saveCustomer(event.customerModel);
      emit(CustomerSaveSuccess());
    } catch (e) {
      emit(CustomerSaveFailed(message: e.toString()));
    }
  }

  void onCustomerUpdate(CustomerUpdate event, Emitter<CustomerState> emit) async {
    emit(CustomerUpdateInProgress());
    try {
      await _customerRepository.updateCustomer(event.guid, event.customerModel);
      emit(CustomerUpdateSuccess());
    } catch (e) {
      emit(CustomerUpdateFailed(message: e.toString()));
    }
  }

  void onCustomerGet(CustomerGet event, Emitter<CustomerState> emit) async {
    emit(CustomerGetInProgress());
    try {
      final result = await _customerRepository.getCustomer(event.guid);
      if (result.success) {
        CustomerModel customer = CustomerModel.fromJson(result.data);
        emit(CustomerGetSuccess(customer: customer));
      } else {
        emit(const CustomerGetFailed(message: 'Customer Not Found'));
      }
    } catch (e) {
      // emit(CustomerDeleteFailure(message: e.toString()));
    }
  }
}
