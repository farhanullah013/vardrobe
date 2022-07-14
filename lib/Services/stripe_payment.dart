import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_payment/stripe_payment.dart';

class stripe_payment{

  static String message;

  static Map<String, String> headers = {
    'Authorization': '',
    'Content-Type': ''
  };

  static init(){ // we are initializing stripe payment with our api key
    StripePayment.setOptions(
        StripeOptions(
            publishableKey:"",
          merchantId: "Test",
          androidPayMode: 'test'
        )
    );
  }
  static paywithnewcard({String payment_amount,String currency}) async { // we are creating a payment method here
    message=null;
    try{
      PaymentMethod paymentmethod=await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest()
      ); // this will allow us to see a card form
      Map<String, dynamic> intent=await paymentintent(payment_amount:payment_amount, currency:currency);//creating intent

      var response = await StripePayment.confirmPaymentIntent(PaymentIntent( // sending payment with intent
          clientSecret: intent['client_secret'],
          paymentMethodId: paymentmethod.id));

      if (response.status == 'succeeded') {
        message='Payment successfull';
      } else {
        message='Transaction not successfull';
      }
    } on PlatformException catch (err) {
      if(err.message=='cancelled'){
        message='Transaction cancelled';
      }
    }
    catch(e){
      message=e.toString();
    }

  }

  static Future<Map<String, dynamic>> paymentintent({String payment_amount,String currency}) async { // creating payment intent
    try{
      Map<String, dynamic> body = {
        'amount': payment_amount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      Uri apiurl=Uri.parse('');
      var response=await http.post(apiurl,body:body ,headers: headers);
      return jsonDecode(response.body);
    }catch(e){
      message=e.toString();
    }
  }

}