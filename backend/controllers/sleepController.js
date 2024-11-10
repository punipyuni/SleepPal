// controllers/sleepController.js
const SleepService = require('../services/sleepService');

exports.getSleepData = async (req, res) => {
  try {
    const sleepData = await SleepService.getSleepDataByUserId(req.user._id);
    res.json(sleepData);
  } catch (error) {
    res.status(500).json({ message: 'Server error', error });
  }
};

exports.saveSleepData = async (req, res) => {
  try {
    const sleepData = req.body;
    const savedData = await SleepService.saveSleepData(req.user._id, sleepData);
    res.json({ message: 'Sleep data saved', data: savedData });
  } catch (error) {
    res.status(500).json({ message: 'Server error', error });
  }
};
