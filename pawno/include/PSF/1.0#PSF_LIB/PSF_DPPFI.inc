/*
*
*	-= PSF DEFINIÇÃO PADRÃO PARA FUNÇÕES INICIAIS =-
*	Protioso String Funções
*	Autor: Protioso ([VGS]Protioso_OC)
*
*/

#include <a_samp>

//      Arquivos base
#include "PSF\1.0#PSF_LIB\#PSF_B\PSF_B.&1"
#include "PSF\1.0#PSF_LIB\#PSF_B\PSF.&B"
//      Arquivos CODIFICAÇÃO
#include "PSF\1.0#PSF_LIB\#PSF_PCOD\PSF.&PE"
#include "PSF\1.0#PSF_LIB\#PSF_PCOD\#PSF-C_BASE\PSF_B.&PE"
//-----------------------------------------------------------------------------|
stock psf_PCODStr(str[], taxa = TAXA_MEDIANA)
{
	new f_e[256];
	f_e = psf_FormatarStr(str, psf_fT(taxa));
	return f_e;
}

stock psf_PCODNumero(numeral)
{
	new f_e[256],
	 	op;
	format(f_e, sizeof(f_e), "%d", numeral);
	psf_mN(f_e);
    while(op < 5)
    {
        strins(f_e, psf_CharStr(psf_adT(f_e[op])), strlen(f_e));
        op++;
	}
	psf_mN(f_e);
	return strval(f_e);
}

stock psf_Filtrar(str[])
{
	new cE[256];
	strcat(cE, str);
	for(new c; c < 8; c++)
	{
		if(psf_ParteExiste(str, FiltroB[c]))
		{
			cE = psf_SubstituirChar(str, FiltroB[c], FiltroF[c]);
		}
	}
	return cE;
}

stock psf_ReverterFiltro(str[])
{
	new cD[256];
	strcat(cD, str);
	for(new c; c < 8; c++)
	{
		if(psf_ParteExiste(str, FiltroF[c]))
		{
			cD = psf_SubstituirChar(str, FiltroF[c], FiltroB[c]);
		}
	}
	return cD;
}

stock psf_FormatarStrTexto(str[])
{
	new cF[256];
	strcat(cF, str);
	for(new c; c < 12; c++)
	{
		if(psf_ParteExiste(str, TfN[c]))
		{
			cF = psf_SubstituirChar(str, TfN[c], TfF[c]);
		}
	}
	return cF;
}
