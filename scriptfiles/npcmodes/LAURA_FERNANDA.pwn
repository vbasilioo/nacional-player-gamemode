#define RECORDING "LAURA_FERNANDA" //Este é o nome do seu arquivo de gravação, sem a extenção(.rec).
#define RECORDING_TYPE 2 //1 para gravações em veículo e 2 para gravações apé.

#include <a_npc>
main(){}
public OnRecordingPlaybackEnd() StartRecordingPlayback(RECORDING_TYPE, RECORDING);

#if RECORDING_TYPE == 1
  public OnNPCEnterVehicle(vehicleid, seatid) StartRecordingPlayback(RECORDING_TYPE, RECORDING);
  public OnNPCExitVehicle() StopRecordingPlayback();
#else
  public OnNPCSpawn() StartRecordingPlayback(RECORDING_TYPE, RECORDING);
#endif
