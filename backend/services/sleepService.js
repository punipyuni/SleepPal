// services/sleepService.js
const SleepModel = require('../models/sleepModel');

class SleepService {
  
  static async getSleepDataByUserId(userId) {
    try {
      return await SleepModel.find({ userId }).sort({ date: -1 });
    } catch (error) {
      throw error;
    }
  }

  static async saveSleepData(userId, sleepData) {
    try {
      const newSleepEntry = new SleepModel({ userId, ...sleepData });
      return await newSleepEntry.save();
    } catch (error) {
      throw error;
    }
  }
}

module.exports = SleepService;
