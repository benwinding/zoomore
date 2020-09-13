class KalmanFilter {
  double _R;
  double _Q;
  double _A;
  double _C;
  double _B;

  double _cov;
  double _x;

  /**
  * Create 1-dimensional kalman filter
  * @param  {Number} options.R Process noise
  * @param  {Number} options.Q Measurement noise
  * @param  {Number} options.A State vector
  * @param  {Number} options.B Control vector
  * @param  {Number} options.C Measurement vector
  * @return {KalmanFilter}
  */
  KalmanFilter({R = 1, Q = 1, A = 1, B = 0, C = 1}) {
    this._R = R; // noise power desirable
    this._Q = Q; // noise power estimated

    this._A = A;
    this._C = C;
    this._B = B;
    this._cov = double.nan;
    this._x = double.nan; // estimated signal without noise
  }

  /**
  * Filter a new value
  * @param  {Number} z Measurement
  * @param  {Number} u Control
  * @return {Number}
  */
  filter(double z, [double u = 0]) {
    if (this._x == double.nan) {
      this._x = (1 / this._C) * z;
      this._cov = (1 / this._C) * this._Q * (1 / this._C);
    } else {
      // Compute prediction
      final predX = this.predict(u);
      final predCov = this.uncertainty();

      // Kalman gain
      final K =
          predCov * this._C * (1 / ((this._C * predCov * this._C) + this._Q));

      // Correction
      this._x = predX + K * (z - (this._C * predX));
      this._cov = predCov - (K * this._C * predCov);
    }

    return this._x;
  }

  /**
  * Predict next value
  * @param  {Number} [u] Control
  * @return {Number}
  */
  predict([u = 0]) {
    return (this._A * this._x) + (this._B * u);
  }

  /**
  * Return uncertainty of filter
  * @return {Number}
  */
  uncertainty() {
    return ((this._A * this._cov) * this._A) + this._R;
  }

  /**
  * Return the last filtered measurement
  * @return {Number}
  */
  lastMeasurement() {
    return this._x;
  }

  /**
  * Set measurement noise Q
  * @param {Number} noise
  */
  setMeasurementNoise(noise) {
    this._Q = noise;
  }

  /**
  * Set the process noise R
  * @param {Number} noise
  */
  setProcessNoise(noise) {
    this._R = noise;
  }
}
