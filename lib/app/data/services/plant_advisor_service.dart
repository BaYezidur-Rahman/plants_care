class PlantAdvisorService {
  // Based on country + current month + weather → 
  // return what to plant now
  List<String> getRecommendedPlantsToPlant({
    required String country,
    required int month,
    required double temp,
    required int humidity,
  }) {
    // Bangladesh/BD logic:
    if (country == 'BD' || country == 'Bangladesh') {
      if (month >= 10 || month <= 2) { // শীতকাল (Oct-Feb)
        return ['টমেটো', 'ফুলকপি', 'বাঁধাকপি', 'মূলা', 'গাজর', 'পালংশাক', 'মেথি'];
      } else if (month >= 3 && month <= 5) { // গ্রীষ্মকাল (Mar-May)
        return ['করলা', 'ঢেঁড়স', 'পেঁপে', 'লাউ', 'কুমড়া', 'ঝিঙে'];
      } else { // বর্ষাকাল (Jun-Sep)
        return ['আদা', 'হলুদ', 'কচু', 'পুঁইশাক', 'ডাঁটাশাক'];
      }
    }
    // India logic:
    if (country == 'IN' || country == 'India') {
      if (month >= 10 || month <= 2) {
        return ['Tomato', 'Spinach', 'Carrot', 'Radish', 'Peas'];
      } else if (month >= 3 && month <= 6) {
        return ['Okra', 'Cucumber', 'Brinjal', 'Gourd'];
      } else {
        return ['Chilli', 'Beans', 'Ginger', 'Turmeric'];
      }
    }
    // Default:
    return ['টমেটো', 'মরিচ', 'পুদিনা'];
  }

  // Based on weather → fertilizer advice
  String getFertilizerAdvice({
    required double temp,
    required int humidity,
    required int month,
  }) {
    if (temp > 35) {
      return '🌡️ তীব্র গরমে সার দেওয়া থেকে বিরত থাকুন। শুধু জল দিন। সার দিলে শিকড় পুড়ে যেতে পারে।';
    }
    if (humidity > 80) {
      return '💧 অতিরিক্ত আর্দ্রতায় ছত্রাকনাশক স্প্রে করুন। জৈব সার (কম্পোস্ট) ব্যবহার করুন।';
    }
    if (month >= 10 || month <= 2) {
      return '❄️ শীতকালে NPK সার (10:10:10) দিন। ১৫ দিন পর পর।';
    }
    return '🌿 সাধারণ অবস্থায় মাসে একবার জৈব কম্পোস্ট সার দিন।';
  }

  // Based on weather → pesticide advice  
  String getPesticideAdvice({
    required double temp,
    required int humidity,
    required bool isRaining,
  }) {
    if (isRaining) {
      return '🌧️ বৃষ্টির সময় কীটনাশক স্প্রে করবেন না। বৃষ্টি থামার পর সন্ধ্যায় স্প্রে করুন।';
    }
    if (humidity > 75) {
      return '⚠️ আর্দ্র আবহাওয়ায় ছত্রাকের আক্রমণ বেশি হয়। নিম তেল স্প্রে করুন।';
    }
    return '✅ সকালে বা সন্ধ্যায় কীটনাশক স্প্রে করুন। রোদের সময় স্প্রে করবেন না।';
  }

  // Watering advice based on weather
  String getWateringAdvice({
    required double temp,
    required int humidity,
    required int rainProbability,
  }) {
    if (rainProbability > 60) {
      return '☔ আজ বৃষ্টির সম্ভাবনা আছে। পানি দেওয়ার দরকার নেই।';
    }
    if (temp > 35) {
      return '🌡️ তীব্র গরম। সকাল ও সন্ধ্যায় পানি দিন। দুপুরে পানি দেবেন না।';
    }
    if (humidity < 40) {
      return '💨 বাতাস শুষ্ক। স্বাভাবিকের চেয়ে বেশি পানি দিন।';
    }
    return '✅ স্বাভাবিক পানি দিন। মাটি শুকিয়ে গেলে তবেই দিন।';
  }
}
