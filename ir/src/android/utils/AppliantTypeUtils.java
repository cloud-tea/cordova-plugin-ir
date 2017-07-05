package CordovaIR.utils;

import com.tiqiaa.constant.ApplianceType;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class AppliantTypeUtils {

	public static String getAppliantTypeName(int type)
	{
		String appliantType = "";
		
		switch (type) {
		case ApplianceType.AIR_CONDITIONER:
			appliantType = "空调";
			break;
		case ApplianceType.AMPLIFIER:
			appliantType = "功放";
			break;
		case ApplianceType.CAMERA:
			appliantType = "单反";
			break;
		case ApplianceType.DVD:
			appliantType = "DVD";
			break;
		case ApplianceType.FAN:
			appliantType = "电扇";
			break;
		case ApplianceType.IPTV:
			appliantType = "IPTV";
			break;
		case ApplianceType.IR_LIGHT_SWITCH:
			appliantType = "红外灯";
			break;
		case ApplianceType.OTT_BOX:
			appliantType = "盒子";
			break;
		case ApplianceType.PROJECTOR:
			appliantType = "投影仪";
			break;
		case ApplianceType.STB:
			appliantType = "机顶盒";
			break;
		case ApplianceType.TV:
			appliantType = "电视";
			break;
		case ApplianceType.AIR_CLEANER:
			appliantType = "空气净化器";
			break;
		case ApplianceType.WATER_HEATER:
			appliantType = "热水器";
			break;
		}
		return appliantType;
	}
	
	public static String getApplianceShotcut(int type)
	{
		String appliantType = "";
		
		switch (type) {
		case ApplianceType.AIR_CONDITIONER:
			appliantType = "air";
			break;
		case ApplianceType.AMPLIFIER:
			appliantType = "amp";
			break;
		case ApplianceType.CAMERA:
			appliantType = "ca";
			break;
		case ApplianceType.DVD:
			appliantType = "dvd";
			break;
		case ApplianceType.FAN:
			appliantType = "tv";
			break;
		case ApplianceType.IPTV:
			appliantType = "iptv";
			break;
		case ApplianceType.IR_LIGHT_SWITCH:
			appliantType = "light";
			break;
		case ApplianceType.OTT_BOX:
			appliantType = "box";
			break;
		case ApplianceType.PROJECTOR:
			appliantType = "prj";
			break;
		case ApplianceType.STB:
			appliantType = "stb";
			break;
		case ApplianceType.TV:
			appliantType = "电视";
			break;
		}
		return appliantType;
	}

	public static HashMap getAllAppliance() {
        HashMap appliances = new HashMap();

		//空调、相机、红外开关三种电器类型不支持精确匹配
		appliances.put(ApplianceType.AIR_CONDITIONER, getAppliantTypeName(ApplianceType.AIR_CONDITIONER));
		appliances.put(ApplianceType.IR_LIGHT_SWITCH, getAppliantTypeName(ApplianceType.IR_LIGHT_SWITCH));
		appliances.put(ApplianceType.CAMERA, getAppliantTypeName(ApplianceType.CAMERA));
		appliances.put(ApplianceType.TV, getAppliantTypeName(ApplianceType.TV));
		appliances.put(ApplianceType.STB, getAppliantTypeName(ApplianceType.STB));
		appliances.put(ApplianceType.PROJECTOR, getAppliantTypeName(ApplianceType.PROJECTOR));
		appliances.put(ApplianceType.OTT_BOX, getAppliantTypeName(ApplianceType.OTT_BOX));
		appliances.put(ApplianceType.AMPLIFIER, getAppliantTypeName(ApplianceType.AMPLIFIER));
		appliances.put(ApplianceType.DVD, getAppliantTypeName(ApplianceType.DVD));
		appliances.put(ApplianceType.FAN, getAppliantTypeName(ApplianceType.FAN));
		appliances.put(ApplianceType.IPTV, getAppliantTypeName(ApplianceType.IPTV));
		appliances.put(ApplianceType.WATER_HEATER, getAppliantTypeName(ApplianceType.WATER_HEATER));
		appliances.put(ApplianceType.AIR_CLEANER, getAppliantTypeName(ApplianceType.AIR_CLEANER));

        return appliances;
	}
}
