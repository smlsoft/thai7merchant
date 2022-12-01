import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thai7merchant/model/customer.dart';
import 'package:thai7merchant/model/global_model.dart';
import 'package:thai7merchant/model/master_model.dart';
import 'package:thai7merchant/repositories/customer_repository.dart';
import 'package:thai7merchant/repositories/client.dart';
import 'dart:io';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final CustomerRepository _customerRepository;

  CustomerBloc({required CustomerRepository customerRepository})
      : _customerRepository = customerRepository,
        super(CustomerInitial()) {
    on<CustomerLoadList>(onCustomerLoad);
    on<CustomerSave>(onCustomerSave);
    on<CustomerWithImageSave>(onCustomerWithImageSave);
    on<CustomerUpdate>(onCustomerUpdate);
    on<CustomerWithImageUpdate>(onCustomerWithImageUpdate);
    on<CustomerDelete>(customerDelete);
    on<CustomerDeleteMany>(customerDeleteMany);
    on<CustomerGet>(onCustomerGet);
  }

  void onCustomerLoad(
      CustomerLoadList event, Emitter<CustomerState> emit) async {
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

  void customerDeleteMany(
      CustomerDeleteMany event, Emitter<CustomerState> emit) async {
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

  void onCustomerWithImageSave(
      CustomerWithImageSave event, Emitter<CustomerState> emit) async {
    emit(CustomerSaveInProgress());
    try {
      List<ImagesModel> imagesList = [];
      if (event.imageFile.isNotEmpty) {
        for (int i = 0; i < event.imageFile.length; i++) {
          if (event.imageFile[i].uri != '') {
            ApiResponse result = await _customerRepository.uploadImage(
                event.imageFile[i], event.imageWeb[i]);
            if (result.success) {
              UploadImageModel uploadImage =
                  UploadImageModel.fromJson(result.data);
              imagesList.add(ImagesModel(uri: uploadImage.uri, xorder: i));
            } else {
              emit(CustomerSaveFailed(message: result.message));
            }
          }
        }

        if (imagesList.length == event.imageFile.length) {
          CustomerModel customerModel = event.customerModel;
          customerModel.images = imagesList;
          customerModel.addressforbilling.guid = "";
          for (int i = 0; i < customerModel.addressforshipping.length; i++) {
            customerModel.addressforshipping[i].guid = "";
          }

          print(customerModel);
          await _customerRepository.saveCustomer(customerModel);
          emit(CustomerSaveSuccess());
        } else {
          emit(const CustomerSaveFailed(message: 'image upload failed'));
        }
      } else {
        emit(const CustomerSaveFailed(message: 'no image found'));
      }
    } catch (e) {
      emit(CustomerSaveFailed(message: e.toString()));
    }
  }

  void onCustomerUpdate(
      CustomerUpdate event, Emitter<CustomerState> emit) async {
    emit(CustomerUpdateInProgress());
    try {
      await _customerRepository.updateCustomer(event.guid, event.customerModel);
      emit(CustomerUpdateSuccess());
    } catch (e) {
      emit(CustomerUpdateFailed(message: e.toString()));
    }
  }

  void onCustomerWithImageUpdate(
      CustomerWithImageUpdate event, Emitter<CustomerState> emit) async {
    emit(CustomerUpdateInProgress());
    try {
      List<ImagesModel> imagesList = [];
      if (event.imagesUri.isNotEmpty) {
        for (int i = 0; i < event.imagesUri.length; i++) {
          if (event.imageWeb[i].isNotEmpty) {
            ApiResponse result = await _customerRepository.uploadImage(
                event.imageFile[i], event.imageWeb[i]);
            if (result.success) {
              UploadImageModel uploadImage =
                  UploadImageModel.fromJson(result.data);
              imagesList.add(ImagesModel(uri: uploadImage.uri, xorder: i));
            } else {
              emit(CustomerUpdateFailed(message: result.message));
            }
          } else if (event.imagesUri[i].uri != '') {
            imagesList.add(ImagesModel(uri: event.imagesUri[i].uri, xorder: i));
          }
        }

        if (imagesList.isNotEmpty) {
          CustomerModel customerModel = event.customerModel;
          customerModel.images = imagesList;
          customerModel.addressforbilling.guid = "";
          for (int i = 0; i < customerModel.addressforshipping.length; i++) {
            customerModel.addressforshipping[i].guid = "";
          }

          print(customerModel);
          await _customerRepository.updateCustomer(
              event.guid, event.customerModel);
          emit(CustomerUpdateSuccess());
        } else {
          emit(const CustomerUpdateFailed(message: 'image upload failed'));
        }
      } else {
        emit(const CustomerUpdateFailed(message: 'no image found'));
      }
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
