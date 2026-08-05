package pro.muzhiki.muzhiki_core

import android.content.Context
import android.net.ConnectivityManager
import android.net.wifi.WifiInfo
import android.net.wifi.WifiManager
import android.os.Build
import android.telephony.SubscriptionManager
import android.telephony.TelephonyManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel

class NetworkInfoPlugin : FlutterPlugin {

    private lateinit var context: Context
    private var channel: MethodChannel? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        channel = MethodChannel(
            binding.binaryMessenger,
            "report_problem/network_info",
        )
        channel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "getCellularDbm" -> result.success(getCellularDbm())
                "getWifiRssi" -> result.success(getWifiRssi())
                "getCarrierName" -> result.success(getCarrierName())
                "getSimsInfo" -> result.success(getSimsInfo())
                else -> result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel?.setMethodCallHandler(null)
        channel = null
    }

    /// TelephonyManager той SIM, через которую идёт мобильный интернет
    private fun dataTelephonyManager(): TelephonyManager {
        val tm = context.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            val dataSubId = SubscriptionManager.getDefaultDataSubscriptionId()
            if (dataSubId != SubscriptionManager.INVALID_SUBSCRIPTION_ID) {
                return tm.createForSubscriptionId(dataSubId)
            }
        }
        return tm
    }

    /// Уровень сотового сигнала dBm
    private fun getCellularDbm(): Int? = try {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            dataTelephonyManager()
                .signalStrength
                ?.cellSignalStrengths
                ?.firstOrNull()
                ?.dbm
                ?.takeIf { it < 0 }
        } else {
            null
        }
    } catch (_: Exception) {
        null
    }

    /// RSSI Wi-Fi dBm
    private fun getWifiRssi(): Int? = try {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val cm = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
            val wifiInfo = cm.getNetworkCapabilities(cm.activeNetwork)
                ?.transportInfo as? WifiInfo
            wifiInfo?.rssi?.takeIf { it < 0 }
        } else {
            @Suppress("DEPRECATION")
            val wm = context.getSystemService(Context.WIFI_SERVICE) as WifiManager
            @Suppress("DEPRECATION")
            wm.connectionInfo?.rssi?.takeIf { it < 0 }
        }
    } catch (_: Exception) {
        null
    }

    /// Имя оператора data-SIM
    private fun getCarrierName(): String? = try {
        val tm = dataTelephonyManager()
        tm.simOperatorName?.takeIf { it.isNotBlank() }
            ?: tm.networkOperatorName?.takeIf { it.isNotBlank() }
    } catch (_: Exception) {
        null
    }

    /// Информация по SIM картам
    private fun getSimsInfo(): List<Map<String, Any?>> = try {
        val tm = context.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            val defaultDataSubId = SubscriptionManager.getDefaultDataSubscriptionId()
            val defaultVoiceSubId = SubscriptionManager.getDefaultVoiceSubscriptionId()

            val subIds = listOf(
                defaultDataSubId,
                defaultVoiceSubId,
                SubscriptionManager.getDefaultSmsSubscriptionId(),
                SubscriptionManager.getDefaultSubscriptionId(),
            )
                .filter { it != SubscriptionManager.INVALID_SUBSCRIPTION_ID }
                .distinct()

            if (subIds.isEmpty()) {
                listOfNotNull(simInfoFrom(tm, subId = null, isDataSim = true, isVoiceSim = true))
            } else {
                subIds.mapNotNull { subId ->
                    simInfoFrom(
                        tm.createForSubscriptionId(subId),
                        subId = subId,
                        isDataSim = subId == defaultDataSubId,
                        isVoiceSim = subId == defaultVoiceSubId,
                    )
                }
            }
        } else {
            listOfNotNull(simInfoFrom(tm, subId = null, isDataSim = true, isVoiceSim = true))
        }
    } catch (_: Exception) {
        emptyList()
    }

    private fun simInfoFrom(
        tm: TelephonyManager,
        subId: Int?,
        isDataSim: Boolean,
        isVoiceSim: Boolean,
    ): Map<String, Any?>? {
        val carrier = try {
            tm.simOperatorName?.takeIf { it.isNotBlank() }
        } catch (_: Exception) {
            null
        }

        val dbm = try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                tm.signalStrength
                    ?.cellSignalStrengths
                    ?.firstOrNull()
                    ?.dbm
                    ?.takeIf { it < 0 }
            } else {
                null
            }
        } catch (_: Exception) {
            null
        }

        // Пустой слот / eSIM без профиля — запись не создаём
        if (carrier == null && dbm == null) return null

        return mapOf(
            "subscription_id" to subId,
            "carrier" to carrier,          // имя оператора
            "signal_strength" to dbm,      // уровень сигнала, dBm
            "is_data_sim" to isDataSim,    // активная для интернета
            "is_voice_sim" to isVoiceSim,  // активная для звонков
        )
    }
}