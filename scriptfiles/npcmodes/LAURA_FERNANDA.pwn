#define RECORDING "LAURA_FERNANDA" //Este � o nome do seu arquivo de grava��o, sem a exten��o(.rec).
#define RECORDING_TYPE 2 //1 para grava��es em ve�culo e 2 para grava��es ap�.

#include <a_npc>
main(){}
public OnRecordingPlaybackEnd() StartRecordingPlayback(RECORDING_TYPE, RECORDING);

#if RECORDING_TYPE == 1
  public OnNPCEnterVehicle(vehicleid, seatid) StartRecordingPlayback(RECORDING_TYPE, RECORDING);
  public OnNPCExitVehicle() StopRecordingPlayback();
#else
  public OnNPCSpawn() StartRecordingPlayback(RECORDING_TYPE, RECORDING);
#endif
