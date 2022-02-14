/********************************************************************
 * FILE: guassian.c
 * AUTHOR: Chen Hebing
 * CREATE DATE: 8/28/3013
 * PROJECT: Gaussian kernel density estimation
 * COPYRIGHT: 2013-2016
 ********************************************************************/

#include <assert.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>


int main(int argc, char** argv) {
	char *infile=argv[1];
	char *outfile=argv[2];
	fprintf(stderr, "infile : %s\n",infile);
	fprintf(stderr, "outfile : %s\n",outfile);


	double *guass;
	int sigma=3000;
	int Width=30000;
	long ii=0;
	int jj=0;
	double Expp=2.718281828459;
	guass=(double *)calloc((Width+1),sizeof(double));
	int boundary=0;
	for(jj=0;jj<=Width;jj++)
	{
		double tjj=(double) jj;
		guass[jj]=pow(Expp,(-(tjj*tjj)/(2*sigma*sigma)));
		if(guass[jj]>0.1){boundary=jj;}
	}
	//fprintf(stderr,"guassian %g\t%g\t%g\n",guass[0],guass[100],guass[643]);
	fprintf(stderr,"guassian %d\n",boundary);
	
    FILE *fp = fopen(infile, "r");
    if (fp == NULL)
    {
    	fprintf(stderr,"unable to open %s", infile);
    	exit(1);
    }
    
    FILE *fout = fopen(outfile, "w");
    if (fout == NULL)
    {
    	fprintf(stderr,"unable to open %s", outfile);
    	exit(1);
    }  
    FILE *ftemp = fopen("ztemp.txt", "w");
    if (fout == NULL)
    {
    	fprintf(stderr,"unable to open ");
    	exit(1);
    }          

	char *chrname;
	chrname=(char *)calloc(6,sizeof(char));
	char *prechr;
	prechr=(char *)calloc(6,sizeof(char));
	//fprintf(stderr,"%c\n",prechr[0]);
	long tempPos;
	int tempNum;
	
	long prePos=-1000;
	
	long *cluster;
	cluster=(long *)calloc(1,sizeof(long));
	int *cluNum;
	cluNum=(int *)calloc(1,sizeof(int));
	int cli=0;
	int innum=0;
    while (!feof(fp))
    {
		innum=fscanf(fp, "%s%d%d",chrname,&tempPos,&tempNum);
		if(innum != 3){break;}
		//fprintf(stderr, "%s\t%d\t%d\n",chrname,tempPos,tempNum);
		//fprintf(fout, ": %s\t%d\t%d\n",chrname,tempPos,tempNum);
		//fprintf(stderr,"%s\t%s\n",prechr,chrname);
		if((strcmp(prechr,chrname)!=0)||((tempPos-prePos)>2*Width))
		{
			
			if(prechr[0] == 0)
			{
				for(jj=0;jj<6;jj++){prechr[jj] = chrname[jj];}
				prePos = tempPos;
				fprintf(stderr,"!start cal %s ...\n", prechr);

				cluster=(long *)realloc(cluster,(cli+1)*sizeof(long));
				cluNum=(int *)realloc(cluNum,(cli+1)*sizeof(int));	
				cluster[cli]=tempPos;
				cluNum[cli]=tempNum;
				cli++;
				
				continue;
			}
			if((strcmp(prechr,chrname)!=0)){fprintf(stderr,"start cal %s ...\n", chrname);}
			if(cli==1)
			{
				long start=cluster[0]-sigma/2;
				long end=cluster[0]+sigma/2;
				if(start<0){start=0;}
				fprintf(fout,"%s\t%d\t%d\t%d\t%d\n",prechr,start,end,cluNum[0],cluNum[0]);
			}
			else
			{
				double *scores;
				scores=(double *)calloc((cluster[cli-1]-cluster[0]+1),sizeof(double));
				for(ii=cluster[0];ii<=cluster[cli-1];ii++)
				{
					for(jj=0;jj<cli;jj++)
					{
						int ttl=ii-cluster[jj];
						if(ttl<0){ttl=-ttl;}
						if(ttl>Width){continue;}
						scores[ii-cluster[0]]=scores[ii-cluster[0]]+guass[ttl]*cluNum[jj];
					}
				}
				//fprintf(stderr,"%d\t%d\t%s\t%s\t%d\t%d\n",cluster[0],cli,prechr,chrname,tempPos,prePos);
				for(jj=0;jj<=cluster[cli-1]-cluster[0];jj++)
				{
					if(scores[jj]<1){continue;}
					fprintf(ftemp,"%d\t%.13f\n",jj+cluster[0],scores[jj]);
			    }

				int *Posit;
				Posit=(int *)calloc((cluster[cli-1]-cluster[0]+1),sizeof(int));
				//for(jj=0;jj<cluster[cli-1]-cluster[0];jj++){Posit[jj]=0;}
				for(jj=0;jj<cli;jj++)
				{
					Posit[cluster[jj]-cluster[0]]=cluNum[jj];
				}

				//for(ii=cluster[0];ii<=cluster[cli-1];ii++)
				for(jj=0;jj<=cluster[cli-1]-cluster[0];jj++)
				{
					if(((jj==0)&&(scores[jj]>=1)&&((scores[jj]-scores[jj+1])>=0)) \
					||((jj==cluster[cli-1]-cluster[0])&&(scores[jj]>=1)&&((scores[jj]-scores[jj-1])>0)) \
					||((scores[jj]>=1)&&((scores[jj]-scores[jj-1])>0)&&((scores[jj]-scores[jj+1])>=0)))	
					{
						//you are max
						int kk=0;
						for(kk=boundary;kk>=0;kk--)
						{
							if((jj-kk>=0)&&(Posit[jj-kk]>0))
							{
								break;
							}
							if((jj+kk<=cluster[cli-1]-cluster[0])&&(Posit[jj+kk]>0))
							{
								break;
							}						
						}
						long start=jj-kk-sigma/2 + cluster[0];
						long end =jj+kk+sigma/2 + cluster[0];
							
						double tvalue=0;
						for(kk=-boundary;kk<boundary;kk++)
						{
							if((kk+jj>=0) && (jj+kk<=cluster[cli-1]-cluster[0]) && (Posit[kk+jj]>0))
							{	
								int tkk=kk;
								if(tkk<0){tkk=-tkk;}
								if(tkk>Width){continue;}
								//fprintf(stderr,"tvalue\t%d\t%d\n", tkk,Posit[jj+kk]);
								tvalue=tvalue+guass[tkk]*Posit[jj+kk];
							}
						}	
						if(tvalue<0.927){continue;}	
						if(start<0){start=0;}
						fprintf(fout,"%s\t%d\t%d\t%g\t%g\n",prechr,start,end,tvalue,scores[jj]);			
						//print OUT "$prechr\t$start\t$end\t$value\t@scores[$ii]\n";
			
				}
				}
				free(scores);
				free(Posit);								
			}

					
			for(jj=0;jj<6;jj++){prechr[jj] = chrname[jj];}
			prePos = tempPos;
			
			free(cluster);
			free(cluNum);
			cluster=(long *)calloc(1,sizeof(long));
			cluNum=(int *)calloc(1,sizeof(int));
					
			cli=0;			
		}
		
		cluster=(long *)realloc(cluster,(cli+1)*sizeof(long));
		cluNum=(int *)realloc(cluNum,(cli+1)*sizeof(int));		
		cluster[cli]=tempPos;
		cluNum[cli]=tempNum;
		prePos = tempPos;
		cli++;
		//fprintf(stderr,"%d\n", cli);	
	}
		/*last cal*/
			if(cli==1)
			{
				long start=cluster[0]-sigma/2;
				long end=cluster[0]+sigma/2;
				if(start<0){start=0;}
				fprintf(fout,"%s\t%d\t%d\t%d\t%d\n",prechr,start,end,cluNum[0],cluNum[0]);
			}
			else
			{
				double *scores;
				scores=(double *)calloc((cluster[cli-1]-cluster[0]+1),sizeof(double));
				for(ii=cluster[0];ii<=cluster[cli-1];ii++)
				{
					for(jj=0;jj<cli;jj++)
					{
						int ttl=ii-cluster[jj];
						if(ttl<0){ttl=-ttl;}
						if(ttl>Width){continue;}
						scores[ii-cluster[0]]=scores[ii-cluster[0]]+guass[ttl]*cluNum[jj];
					}
				}
				int *Posit;
				Posit=(int *)calloc((cluster[cli-1]-cluster[0]+1),sizeof(int));
				for(jj=0;jj<cluster[cli-1]-cluster[0];jj++){Posit[jj]=0;}
				for(jj=0;jj<cli;jj++)
				{
					Posit[cluster[jj]-cluster[0]]=cluNum[jj];
				}
				
				//for(ii=cluster[0];ii<=cluster[cli-1];ii++)
				{
					//fprintf(stderr,"%g\n", scores[ii-cluster[0]]);
				}
				
				//for(ii=cluster[0];ii<=cluster[cli-1];ii++)
				for(jj=0;jj<=cluster[cli-1]-cluster[0];jj++)
				{
					if(((jj==0)&&(scores[jj]>=1)&&((scores[jj]-scores[jj+1])>=0)) \
					||((jj==cluster[cli-1]-cluster[0])&&(scores[jj]>=1)&&((scores[jj]-scores[jj-1])>0)) \
					||((scores[jj]>=1)&&((scores[jj]-scores[jj-1])>0)&&((scores[jj]-scores[jj+1])>=0)))	
					{
						//you are max
						
						int kk=0;
						for(kk=boundary;kk>=0;kk--)
						{
							if((jj-kk>=0)&&(Posit[jj-kk]>0))
							{
								break;
							}
							if((jj+kk<=cluster[cli-1]-cluster[0])&&(Posit[jj+kk]>0))
							{
								break;
							}						
						}
						//fprintf(stderr,"here\t%d\n",kk);	
						long start=jj-kk-sigma/2 + cluster[0];
						long end =jj+kk+sigma/2 + cluster[0];
							//fprintf(stderr,"here\t%d\n",start);	
						double tvalue=0;
						for(kk=-boundary;kk<boundary;kk++)
						{
							if((kk+jj>=0) && (jj+kk<=cluster[cli-1]-cluster[0]) && (Posit[kk+jj]>0))
							{	
								int tkk=kk;
								if(tkk<0){tkk=-tkk;}
								if(tkk>Width){continue;}
								//fprintf(stderr,"tvalue\t%d\t%d\n", tkk,Posit[jj+kk]);
								tvalue=tvalue+guass[tkk]*Posit[jj+kk];
							}
						}	
						if(tvalue<0.927){continue;}	
						if(start<0){start=0;}
						fprintf(fout,"%s\t%d\t%d\t%g\t%g\n",prechr,start,end,tvalue,scores[jj]);			
						//print OUT "$prechr\t$start\t$end\t$value\t@scores[$ii]\n";
			
					}
				}
				free(scores);
				free(Posit);								
			}	
			free(cluster);
			free(cluNum);



	 
    fclose(fp);
    fclose(fout);
fclose(ftemp);
	return 0;
}
